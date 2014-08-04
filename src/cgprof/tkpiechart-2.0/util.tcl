set rcsId {$Id: util.tcl,v 1.3 1995/10/03 10:22:02 jfontain Exp $}

set PI 3.14159265358979323846

proc maximum {a b} {
    return [expr $a>$b?$a:$b]
}
proc minimum {a b} {
    return [expr $a<$b?$a:$b]
}
