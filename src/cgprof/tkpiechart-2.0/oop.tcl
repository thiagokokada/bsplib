set rcsId {$Id: oop.tcl,v 1.8 1995/10/14 22:45:39 jfontain Exp $}

if {![info exists _newId]} {
    # work around object creation between multiple include of this file
    set _newId 0
}

proc new {class args} {
    # calls the constructor for the class with optional arguments
    # and returns a unique object identifier independent of the class name

    global _newId
    # use local variable for id for new can be called recursively
    set id [incr _newId]
    eval ${class}::$class $id $args
    return $id
}

proc delete {class args} {
    # delete one or more objects
    # calls the destructor for the class and delete all the object data members

    foreach id $args {
        ${class}::~$class $id
        global $class
        # and delete all this object array members if any (assume that they were stored as $class($id,memberName))
        foreach name [array names $class $id,*] {
            unset ${class}($name)
        }
    }
}

proc virtual {keyword name arguments args} {
    if {[string compare $keyword proc]!=0} {
        error "cannot use virtual operator on $keyword"
    }
    if {![regexp {^(.+)::(.+)$} $name _dummy _class _function]} {
        error "$name is not a valid member function name"
    }

    if {[string compare $_class $_function]==0} {
        # class constructor, if called from derived constructor, remember derived class name
        if {[llength $args]==0} {
            error "$_class constructor cannot be a pure virtual"
        }
        proc $name $arguments "
            global $_class
            if {\
                \[regexp {^(.+)::(.+)$} \[lindex \[info level -1\] 0\] _dummy _derived _function]&&\
                (\[string compare \$_derived \$_function\]==0)\
            } {
                set ${_class}(\$this,_derived) \$_derived
            }
            [lindex $args 0]
        "
    } elseif {[string compare ~$_class $_function]==0} {
        # class destructor, delete derived part. derived destructor must exists
        # objects from classes with virtual destructor must be destroyed through the root class otherwise infinite loops may occur
        proc $name $arguments "
            global $_class
            delete \[set ${_class}(\$this,_derived)\] \$this
            [lindex $args 0]
        "
    } elseif {[llength $args]==0} {
        # no procedure body means pure virtual
        # call derived function which must exists. derived function return value is returned
        proc $name $arguments "
            global $_class
            eval \[set ${_class}(\$this,_derived)\]::$_function \[lrange \[info level 0\] 1 end\]
        "
    } else {
        # regular virtual function, override with derived function if it exists
        proc $name $arguments "
            global $_class
            if {!\[catch {info args \[set ${_class}(\$this,_derived)\]::$_function}\]} {
                return \[eval \[set ${_class}(\$this,_derived)\]::$_function \[lrange \[info level 0\] 1 end\]\]
            }
            [lindex $args 0]
        "
    }
}
