if {![info exists _newId]} {set _newId 0}
proc new {class args} {global _newId
set id [incr _newId]
eval ${class}::$class $id $args
return $id}
proc delete {class args} {foreach id $args {${class}::~$class $id
global $class
foreach name [array names $class $id,*] {unset ${class}($name)}}}
proc virtual {keyword name arguments args} {if {[string compare $keyword proc]!=0} {error "cannot use virtual operator on $keyword"}
if {![regexp {^(.+)::(.+)$} $name _dummy _class _function]} {error "$name is not a valid member function name"}
if {[string compare $_class $_function]==0} {if {[llength $args]==0} {error "$_class constructor cannot be a pure virtual"}
proc $name $arguments "
            global $_class
            if { \[regexp {^(.+)::(.+)$} \[lindex \[info level -1\] 0\] _dummy _derived _function]&& (\[string compare \$_derived \$_function\]==0) } {
                set ${_class}(\$this,_derived) \$_derived
            }
            [lindex $args 0]
        "} elseif {[string compare ~$_class $_function]==0} {proc $name $arguments "
            global $_class
            delete \[set ${_class}(\$this,_derived)\] \$this
            [lindex $args 0]
        "} elseif {[llength $args]==0} {proc $name $arguments "
            global $_class
            eval \[set ${_class}(\$this,_derived)\]::$_function \[lrange \[info level 0\] 1 end\]
        "} else {proc $name $arguments "
            global $_class
            if {!\[catch {info args \[set ${_class}(\$this,_derived)\]::$_function}\]} {
                return \[eval \[set ${_class}(\$this,_derived)\]::$_function \[lrange \[info level 0\] 1 end\]\]
            }
            [lindex $args 0]
        "}}
set PI 3.14159265358979323846
proc maximum {a b} {return [expr $a>$b?$a:$b]}
proc minimum {a b} {return [expr $a<$b?$a:$b]}
proc normalizedAngle {value} {while {$value>=180} {set value [expr $value-360]}
while {$value<-180} {set value [expr $value+360]}
return $value}
proc slice::slice {this canvas x y radiusX radiusY start extent args} {global slice
array set option {-height 0 -topcolor {} -bottomcolor {}}
array set option $args
set slice($this,canvas) $canvas
set slice($this,start) 0
set slice($this,radiusX) $radiusX
set slice($this,radiusY) $radiusY
set slice($this,height) $option(-height)
set slice($this,origin) [$canvas create line -$radiusX -$radiusY -$radiusX -$radiusY -fill {} -tags slice($this)]
if {$option(-height)>0} {set slice($this,startBottomArcFill) [$canvas create arc 0 0 0 0 -style chord -extent 0 -fill $option(-bottomcolor) -outline $option(-bottomcolor) -tags slice($this)]
set slice($this,startPolygon) [$canvas create polygon 0 0 0 0 0 0 -fill $option(-bottomcolor) -tags slice($this)]
set slice($this,startBottomArc) [$canvas create arc 0 0 0 0 -style arc -extent 0 -fill black -tags slice($this)]
set slice($this,endBottomArcFill) [$canvas create arc 0 0 0 0 -style chord -extent 0 -fill $option(-bottomcolor) -outline $option(-bottomcolor) -tags slice($this)]
set slice($this,endPolygon) [$canvas create polygon 0 0 0 0 0 0 -fill $option(-bottomcolor) -tags slice($this)]
set slice($this,endBottomArc) [$canvas create arc 0 0 0 0 -style arc -extent 0 -fill black -tags slice($this)]
set slice($this,startLeftLine) [$canvas create line 0 0 0 0 -tags slice($this)]
set slice($this,startRightLine) [$canvas create line 0 0 0 0 -tags slice($this)]
set slice($this,endLeftLine) [$canvas create line 0 0 0 0 -tags slice($this)]
set slice($this,endRightLine) [$canvas create line 0 0 0 0 -tags slice($this)]}
set slice($this,topArc) [$canvas create arc -$radiusX -$radiusY $radiusX $radiusY -extent $extent -fill $option(-topcolor) -tags slice($this)]
$canvas move slice($this) [expr $x+$radiusX] [expr $y+$radiusY]
slice::update $this $start $extent}
proc slice::~slice {this} {global slice
$slice($this,canvas) delete slice($this)}
proc slice::update {this start extent} {global slice
set canvas $slice($this,canvas)
set coordinates [$canvas coords slice($this)]
set radiusX $slice($this,radiusX)
set radiusY $slice($this,radiusY)
$canvas coords $slice($this,origin) -$radiusX -$radiusY $radiusX $radiusY
$canvas coords $slice($this,topArc) -$radiusX -$radiusY $radiusX $radiusY
set extent [maximum 0 $extent]
if {$extent>=360} {set extent 359.9999999999999}
$canvas itemconfigure $slice($this,topArc) -start [set slice($this,start) [normalizedAngle $start]] -extent [set slice($this,extent) $extent]
if {$slice($this,height)>0} {slice::updateBottom $this}
$canvas move slice($this) [expr [lindex $coordinates 0]+$radiusX] [expr [lindex $coordinates 1]+$radiusY]}
proc slice::updateBottom {this} {global slice PI
set start $slice($this,start)
set extent $slice($this,extent)
set canvas $slice($this,canvas)
set radiusX $slice($this,radiusX)
set radiusY $slice($this,radiusY)
set height $slice($this,height)
$canvas itemconfigure $slice($this,startBottomArcFill) -extent 0
$canvas coords $slice($this,startBottomArcFill) -$radiusX -$radiusY $radiusX $radiusY
$canvas move $slice($this,startBottomArcFill) 0 $height
$canvas itemconfigure $slice($this,startBottomArc) -extent 0
$canvas coords $slice($this,startBottomArc) -$radiusX -$radiusY $radiusX $radiusY
$canvas move $slice($this,startBottomArc) 0 $height
$canvas coords $slice($this,startLeftLine) 0 0 0 0
$canvas coords $slice($this,startRightLine) 0 0 0 0
$canvas itemconfigure $slice($this,endBottomArcFill) -extent 0
$canvas coords $slice($this,endBottomArcFill) -$radiusX -$radiusY $radiusX $radiusY
$canvas move $slice($this,endBottomArcFill) 0 $height
$canvas itemconfigure $slice($this,endBottomArc) -extent 0
$canvas coords $slice($this,endBottomArc) -$radiusX -$radiusY $radiusX $radiusY
$canvas move $slice($this,endBottomArc) 0 $height
$canvas coords $slice($this,endLeftLine) 0 0 0 0
$canvas coords $slice($this,endRightLine) 0 0 0 0
$canvas coords $slice($this,startPolygon) 0 0 0 0 0 0 0 0
$canvas coords $slice($this,endPolygon) 0 0 0 0 0 0 0 0
set startX [expr $radiusX*cos($start*$PI/180)]
set startY [expr -$radiusY*sin($start*$PI/180)]
set end [normalizedAngle [expr $start+$extent]]
set endX [expr $radiusX*cos($end*$PI/180)]
set endY [expr -$radiusY*sin($end*$PI/180)]
set startBottom [expr $startY+$height]
set endBottom [expr $endY+$height]
if {(($start>=0)&&($end>=0))||(($start<0)&&($end<0))} {if {$extent<=180} {if {$start<0} {$canvas itemconfigure $slice($this,startBottomArcFill) -start $start -extent $extent
$canvas itemconfigure $slice($this,startBottomArc) -start $start -extent $extent
$canvas coords $slice($this,startPolygon) $startX $startY $endX $endY $endX $endBottom $startX $startBottom
$canvas coords $slice($this,startLeftLine) $startX $startY $startX $startBottom
$canvas coords $slice($this,startRightLine) $endX $endY $endX $endBottom}} else {if {$start<0} {$canvas itemconfigure $slice($this,startBottomArcFill) -start 0 -extent $start
$canvas itemconfigure $slice($this,startBottomArc) -start 0 -extent $start
$canvas coords $slice($this,startPolygon) $startX $startY $radiusX 0 $radiusX $height $startX $startBottom
$canvas coords $slice($this,startLeftLine) $startX $startY $startX $startBottom
$canvas coords $slice($this,startRightLine) $radiusX 0 $radiusX $height
set bottomArcExtent [expr $end+180]
$canvas itemconfigure $slice($this,endBottomArcFill) -start -180 -extent $bottomArcExtent
$canvas itemconfigure $slice($this,endBottomArc) -start -180 -extent $bottomArcExtent
$canvas coords $slice($this,endPolygon) -$radiusX 0 $endX $endY $endX $endBottom -$radiusX $height
$canvas coords $slice($this,endLeftLine) -$radiusX 0 -$radiusX $height
$canvas coords $slice($this,endRightLine) $endX $endY $endX $endBottom} else {$canvas itemconfigure $slice($this,startBottomArcFill) -start 0 -extent -180
$canvas itemconfigure $slice($this,startBottomArc) -start 0 -extent -180
$canvas coords $slice($this,startPolygon) -$radiusX 0 $radiusX 0 $radiusX $height -$radiusX $height
$canvas coords $slice($this,startLeftLine) -$radiusX 0 -$radiusX $height
$canvas coords $slice($this,startRightLine) $radiusX 0 $radiusX $height}}} else {if {$start<0} {$canvas itemconfigure $slice($this,startBottomArcFill) -start 0 -extent $start
$canvas itemconfigure $slice($this,startBottomArc) -start 0 -extent $start
$canvas coords $slice($this,startPolygon) $startX $startY $radiusX 0 $radiusX $height $startX $startBottom
$canvas coords $slice($this,startLeftLine) $startX $startY $startX $startBottom
$canvas coords $slice($this,startRightLine) $radiusX 0 $radiusX $height} else {set bottomArcExtent [expr $end+180]
$canvas itemconfigure $slice($this,endBottomArcFill) -start -180 -extent $bottomArcExtent
$canvas itemconfigure $slice($this,endBottomArc) -start -180 -extent $bottomArcExtent
$canvas coords $slice($this,endPolygon) -$radiusX 0 $endX $endY $endX $endBottom -$radiusX $height
$canvas coords $slice($this,startLeftLine) -$radiusX 0 -$radiusX $height
$canvas coords $slice($this,startRightLine) $endX $endY $endX $endBottom}}}
proc slice::position {this start} {global slice
slice::update $this $start $slice($this,extent)}
proc slice::rotate {this angle} {global slice
if {$angle!=0} {slice::update $this [expr $slice($this,start)+$angle] $slice($this,extent)}}
proc slice::size {this extent} {global slice
slice::update $this $slice($this,start) $extent}
proc slice::data {this arrayName} {global slice
upvar $arrayName data
set data(start) $slice($this,start)
set data(extent) $slice($this,extent)
set data(xRadius) $slice($this,radiusX)
set data(yRadius) $slice($this,radiusY)
set coordinates [$slice($this,canvas) coords $slice($this,origin)]
set data(xCenter) [expr [lindex $coordinates 0]+$data(xRadius)]
set data(yCenter) [expr [lindex $coordinates 1]+$data(yRadius)]
set data(height) $slice($this,height)}
virtual proc pieLabeller::pieLabeller {this canvas args} {
    global pieLabeller
    array set option {-offset 5}
    array set option $args
    set pieLabeller($this,offset) [winfo fpixels $canvas $option(-offset)]
    catch {set pieLabeller($this,font) $option(-font)}
    set pieLabeller($this,canvas) $canvas
}
virtual proc pieLabeller::~pieLabeller {this}
proc pieLabeller::bind {this pieId} {global pieLabeller
set pieLabeller($this,pieId) $pieId}
virtual proc pieLabeller::create {this sliceId args}
virtual proc pieLabeller::update {this label value}
virtual proc pieLabeller::rotate {this label}
proc canvasLabel::canvasLabel {this canvas x y args} {global canvasLabel
set canvasLabel($this,canvas) $canvas
set canvasLabel($this,origin) [$canvas create line $x $y $x $y -fill {} -tags canvasLabel($this)]
set canvasLabel($this,rectangle) [$canvas create rectangle 0 0 0 0 -tags canvasLabel($this)]
set canvasLabel($this,text) [$canvas create text 0 0 -tags canvasLabel($this)]
set canvasLabel($this,anchor) center
set canvasLabel($this,style) box
set canvasLabel($this,padding) 2
eval canvasLabel::configure $this $args
canvasLabel::update $this}
proc canvasLabel::~canvasLabel {this} {global canvasLabel
$canvasLabel($this,canvas) delete canvasLabel($this)}
proc canvasLabel::configure {this args} {global canvasLabel
set number [llength $args]
for {set index 0} {$index<$number} {incr index} {set option [lindex $args $index]
set value [lindex $args [incr index]]
switch -- $option {-background {
                $canvasLabel($this,canvas) itemconfigure $canvasLabel($this,rectangle) -fill $value
            }
-foreground {
                $canvasLabel($this,canvas) itemconfigure $canvasLabel($this,text) -fill $value
            }
-borderwidth {
                $canvasLabel($this,canvas) itemconfigure $canvasLabel($this,rectangle) -width $value
                canvasLabel::update $this
            }
-stipple {
                $canvasLabel($this,canvas) itemconfigure $canvasLabel($this,rectangle) $option $value
            }
-anchor {
                set canvasLabel($this,anchor) $value
                canvasLabel::update $this
            }
-font -
-justify -
-text -
-width {
                $canvasLabel($this,canvas) itemconfigure $canvasLabel($this,text) $option $value
                canvasLabel::update $this
            }
-bordercolor {
                $canvasLabel($this,canvas) itemconfigure $canvasLabel($this,rectangle) -outline $value
            }
-style {
                set canvasLabel($this,style) $value
                canvasLabel::update $this
            }}}}
proc canvasLabel::cget {this option} {global canvasLabel
switch -- $option {-background {
            return [$canvasLabel($this,canvas) itemcget $canvasLabel($this,rectangle) -fill]
        }
-foreground {
            return [$canvasLabel($this,canvas) itemcget $canvasLabel($this,text) -fill]
        }
-borderwidth {
            return [$canvasLabel($this,canvas) itemcget $canvasLabel($this,rectangle) -width]
        }
-stipple {
            return [$canvasLabel($this,canvas) itemcget $canvasLabel($this,rectangle) $option]
        }
-anchor {
            return $canvasLabel($this,anchor)
        }
-font -
-justify -
-text -
-width {
            return [$canvasLabel($this,canvas) itemcget $canvasLabel($this,text) $option]
        }
-bordercolor {
            return [$canvasLabel($this,canvas) itemcget $canvasLabel($this,rectangle) -outline]
        }
-style {
            return canvasLabel($this,style) $value
        }}}
proc canvasLabel::update {this} {global canvasLabel
set canvas $canvasLabel($this,canvas)
set rectangle $canvasLabel($this,rectangle)
set text $canvasLabel($this,text)
set coordinates [$canvas coords $canvasLabel($this,origin)]
set x [lindex $coordinates 0]
set y [lindex $coordinates 1]
set border [$canvas itemcget $rectangle -width]
set textBox [$canvas bbox $text]
if {[string compare $canvasLabel($this,style) split]==0} {set textHeight [expr [lindex $textBox 3]-[lindex $textBox 1]]
set rectangleWidth [expr 2.0*($textHeight+$border)]
set halfWidth [expr ($rectangleWidth+$canvasLabel($this,padding)+([lindex $textBox 2]-[lindex $textBox 0]))/2.0]
set halfHeight [expr ($textHeight/2.0)+$border]
$canvas coords $rectangle [expr $x-$halfWidth] [expr $y-$halfHeight] [expr $x-$halfWidth+$rectangleWidth] [expr $y+$halfHeight]
$canvas coords $text [expr $x+(($rectangleWidth+$canvasLabel($this,padding))/2.0)] $y} else {set halfWidth [expr $border+$canvasLabel($this,padding)+(([lindex $textBox 2]-[lindex $textBox 0])/2.0)]
set halfHeight [expr $border+$canvasLabel($this,padding)+(([lindex $textBox 3]-[lindex $textBox 1])/2.0)]
$canvas coords $rectangle [expr $x-$halfWidth] [expr $y-$halfHeight] [expr $x+$halfWidth] [expr $y+$halfHeight]
$canvas coords $text $x $y}
set anchor $canvasLabel($this,anchor)
set xDelta [expr ([string match *w $anchor]-[string match *e $anchor])*$halfWidth]
set yDelta [expr ([string match n* $anchor]-[string match s* $anchor])*$halfHeight]
$canvas move $rectangle $xDelta $yDelta
$canvas move $text $xDelta $yDelta}
proc canvasLabelsArray::canvasLabelsArray {this canvas x y width args} {global canvasLabelsArray
set canvasLabelsArray($this,canvas) $canvas
set canvasLabelsArray($this,width) [winfo fpixels $canvas $width]
set canvasLabelsArray($this,origin) [$canvas create line $x $y $x $y -fill {} -tags canvasLabelsArray($this)]
array set option {-justify left -style box}
array set option $args
catch {set canvasLabelsArray($this,font) $option(-font)}
set canvasLabelsArray($this,justify) $option(-justify)
set canvasLabelsArray($this,style) $option(-style)}
proc canvasLabelsArray::~canvasLabelsArray {this} {global canvasLabelsArray
foreach label $canvasLabelsArray($this,labelIds) {delete canvasLabel $label}
$canvasLabelsArray($this,canvas) delete canvasLabelsArray($this)}
proc canvasLabelsArray::create {this args} {global canvasLabelsArray
if {[lsearch -exact $args -font]<0} {catch {lappend args -font $canvasLabelsArray($this,font)}}
if {[lsearch -exact $args -style]<0} {lappend args -style $canvasLabelsArray($this,style)}
set labelId [eval new canvasLabel $canvasLabelsArray($this,canvas) 0 0 $args]
$canvasLabelsArray($this,canvas) addtag canvasLabelsArray($this) withtag canvasLabel($labelId)
lappend canvasLabelsArray($this,labelIds) $labelId
canvasLabelsArray::position $this $labelId
return $labelId}
proc canvasLabelsArray::position {this labelId} {global canvasLabelsArray
set canvas $canvasLabelsArray($this,canvas)
set coordinates [$canvas coords $canvasLabelsArray($this,origin)]
set x [lindex $coordinates 0]
set y [lindex $coordinates 1]
set coordinates [$canvas bbox canvasLabel($labelId)]
set labelHeight [expr [lindex $coordinates 3]-[lindex $coordinates 1]]
set index [expr [llength $canvasLabelsArray($this,labelIds)]-1]
switch $canvasLabelsArray($this,justify) {
        left {
            set x [expr $x+(($index%2)*($canvasLabelsArray($this,width)/2.0))]
            set anchor nw
        }
        right {
            set x [expr $x+((($index%2)+1)*($canvasLabelsArray($this,width)/2.0))]
            set anchor ne
        }
        default {
            set x [expr $x+((1.0+(2*($index%2)))*$canvasLabelsArray($this,width)/4)]
            set anchor n
        }
    }
canvasLabel::configure $labelId -anchor $anchor
$canvas move canvasLabel($labelId) $x [expr $y+(($index/2)*$labelHeight)]}
proc pieBoxLabeller::pieBoxLabeller {this canvas args} {global pieBoxLabeller
eval pieLabeller::pieLabeller $this $canvas $args
array set option {-justify left}
array set option $args
set pieBoxLabeller($this,justify) $option(-justify)}
proc pieBoxLabeller::~pieBoxLabeller {this} {global pieBoxLabeller
catch {delete canvasLabelsArray $pieBoxLabeller($this,array)}}
proc pieBoxLabeller::create {this sliceId args} {global pieBoxLabeller pieLabeller
if {![info exists pieBoxLabeller($this,array)]} {set options "-justify $pieBoxLabeller($this,justify)"
catch {lappend options -font $pieLabeller($this,font}
set box [$pieLabeller($this,canvas) bbox pie($pieLabeller($this,pieId))]
set pieBoxLabeller($this,array) [eval new canvasLabelsArray $pieLabeller($this,canvas) [lindex $box 0] [expr [lindex $box 3]+$pieLabeller($this,offset)] [expr [lindex $box 2]-[lindex $box 0]] $options]}
set labelId [eval canvasLabelsArray::create $pieBoxLabeller($this,array) $args]
$pieLabeller($this,canvas) addtag pieLabeller($this) withtag canvasLabelsArray($pieBoxLabeller($this,array))
canvasLabel::configure $labelId -text [canvasLabel::cget $labelId -text]:
return $labelId}
proc pieBoxLabeller::update {this labelId value} {regsub {:.*$} [canvasLabel::cget $labelId -text] ": $value" text
canvasLabel::configure $labelId -text $text}
proc pieBoxLabeller::rotate {this labelId} {}
proc pie::pie {this canvas x y width height args} {global pie
array set option {-thickness 0 -background {} -colors {#7FFFFF #7FFF7F #FF7F7F #FFFF7F #7F7FFF #FFBF00 #BFBFBF #FF7FFF #FFFFFF}}
array set option $args
set pie($this,canvas) $canvas
if {[info exists option(-labeller)]} {set pie($this,labellerId) $option(-labeller)} else {set pie($this,labellerId) [new pieBoxLabeller $canvas]}
$canvas addtag pie($this) withtag pieLabeller($pie($this,labellerId))
pieLabeller::bind $pie($this,labellerId) $this
set pie($this,radiusX) [expr [winfo fpixels $canvas $width]/2.0]
set pie($this,radiusY) [expr [winfo fpixels $canvas $height]/2.0]
set pie($this,thickness) [winfo fpixels $canvas $option(-thickness)]
if {[string length $option(-background)]>0} {set bottomColor [tkDarken $option(-background) 60]} else {set bottomColor {}}
set pie($this,backgroundSliceId) [new slice $canvas [winfo fpixels $canvas $x] [winfo fpixels $canvas $y] $pie($this,radiusX) $pie($this,radiusY) 90 360 -height $pie($this,thickness) -topcolor $option(-background) -bottomcolor $bottomColor]
$canvas addtag pie($this) withtag slice($pie($this,backgroundSliceId))
$canvas addtag pieGraphics($this) withtag slice($pie($this,backgroundSliceId))
set pie($this,sliceIds) {}
set pie($this,colors) $option(-colors)}
proc pie::~pie {this} {global pie
delete pieLabeller $pie($this,labellerId)
foreach sliceId $pie($this,sliceIds) {delete slice $sliceId}
delete slice $pie($this,backgroundSliceId)}
proc pie::newSlice {this {text {}}} {global pie slice
set start 90
foreach sliceId $pie($this,sliceIds) {set start [expr $start-$slice($sliceId,extent)]}
set color [lindex $pie($this,colors) [expr [llength $pie($this,sliceIds)]%[llength $pie($this,colors)]]]
set numberOfSlices [llength $pie($this,sliceIds)]
set coordinates [$pie($this,canvas) coords slice($pie($this,backgroundSliceId))]
set sliceId [new slice $pie($this,canvas) [lindex $coordinates 0] [lindex $coordinates 1] $pie($this,radiusX) $pie($this,radiusY) $start 0 -height $pie($this,thickness) -topcolor $color -bottomcolor [tkDarken $color 60]]
$pie($this,canvas) addtag pie($this) withtag slice($sliceId)
$pie($this,canvas) addtag pieGraphics($this) withtag slice($sliceId)
lappend pie($this,sliceIds) $sliceId
if {[string length $text]==0} {set text "slice [expr [llength $pie($this,sliceIds)]+1]"}
set pie($this,sliceLabel,$sliceId) [pieLabeller::create $pie($this,labellerId) $sliceId -text $text -background $color]
$pie($this,canvas) addtag pie($this) withtag pieLabeller($pie($this,labellerId))
return $sliceId}
proc pie::sizeSlice {this sliceId unitShare {valueToDisplay {}}} {global pie slice
if {[set index [lsearch $pie($this,sliceIds) $sliceId]]<0} {error "could not find slice $sliceId in pie $this slices"}
set newExtent [expr [maximum [minimum $unitShare 1] 0]*360]
set growth [expr $newExtent-$slice($sliceId,extent)]
slice::update $sliceId [expr $slice($sliceId,start)-$growth] $newExtent
if {[string length $valueToDisplay]>0} {pieLabeller::update $pie($this,labellerId) $pie($this,sliceLabel,$sliceId) $valueToDisplay} else {pieLabeller::update $pie($this,labellerId) $pie($this,sliceLabel,$sliceId) $unitShare}
set value [expr -1*$growth]
foreach sliceId [lrange $pie($this,sliceIds) [incr index] end] {slice::rotate $sliceId $value
pieLabeller::rotate $pie($this,labellerId) $pie($this,sliceLabel,$sliceId)}}
proc normalizedAngle {value} {while {$value>=180} {set value [expr $value-360]}
while {$value<-180} {set value [expr $value+360]}
return $value}
proc slice::slice {this canvas x y radiusX radiusY start extent args} {global slice
array set option {-height 0 -topcolor {} -bottomcolor {}}
array set option $args
set slice($this,canvas) $canvas
set slice($this,start) 0
set slice($this,radiusX) $radiusX
set slice($this,radiusY) $radiusY
set slice($this,height) $option(-height)
set slice($this,origin) [$canvas create line -$radiusX -$radiusY -$radiusX -$radiusY -fill {} -tags slice($this)]
if {$option(-height)>0} {set slice($this,startBottomArcFill) [$canvas create arc 0 0 0 0 -style chord -extent 0 -fill $option(-bottomcolor) -outline $option(-bottomcolor) -tags slice($this)]
set slice($this,startPolygon) [$canvas create polygon 0 0 0 0 0 0 -fill $option(-bottomcolor) -tags slice($this)]
set slice($this,startBottomArc) [$canvas create arc 0 0 0 0 -style arc -extent 0 -fill black -tags slice($this)]
set slice($this,endBottomArcFill) [$canvas create arc 0 0 0 0 -style chord -extent 0 -fill $option(-bottomcolor) -outline $option(-bottomcolor) -tags slice($this)]
set slice($this,endPolygon) [$canvas create polygon 0 0 0 0 0 0 -fill $option(-bottomcolor) -tags slice($this)]
set slice($this,endBottomArc) [$canvas create arc 0 0 0 0 -style arc -extent 0 -fill black -tags slice($this)]
set slice($this,startLeftLine) [$canvas create line 0 0 0 0 -tags slice($this)]
set slice($this,startRightLine) [$canvas create line 0 0 0 0 -tags slice($this)]
set slice($this,endLeftLine) [$canvas create line 0 0 0 0 -tags slice($this)]
set slice($this,endRightLine) [$canvas create line 0 0 0 0 -tags slice($this)]}
set slice($this,topArc) [$canvas create arc -$radiusX -$radiusY $radiusX $radiusY -extent $extent -fill $option(-topcolor) -tags slice($this)]
$canvas move slice($this) [expr $x+$radiusX] [expr $y+$radiusY]
slice::update $this $start $extent}
proc slice::~slice {this} {global slice
$slice($this,canvas) delete slice($this)}
proc slice::update {this start extent} {global slice
set canvas $slice($this,canvas)
set coordinates [$canvas coords slice($this)]
set radiusX $slice($this,radiusX)
set radiusY $slice($this,radiusY)
$canvas coords $slice($this,origin) -$radiusX -$radiusY $radiusX $radiusY
$canvas coords $slice($this,topArc) -$radiusX -$radiusY $radiusX $radiusY
set extent [maximum 0 $extent]
if {$extent>=360} {set extent 359.9999999999999}
$canvas itemconfigure $slice($this,topArc) -start [set slice($this,start) [normalizedAngle $start]] -extent [set slice($this,extent) $extent]
if {$slice($this,height)>0} {slice::updateBottom $this}
$canvas move slice($this) [expr [lindex $coordinates 0]+$radiusX] [expr [lindex $coordinates 1]+$radiusY]}
proc slice::updateBottom {this} {global slice PI
set start $slice($this,start)
set extent $slice($this,extent)
set canvas $slice($this,canvas)
set radiusX $slice($this,radiusX)
set radiusY $slice($this,radiusY)
set height $slice($this,height)
$canvas itemconfigure $slice($this,startBottomArcFill) -extent 0
$canvas coords $slice($this,startBottomArcFill) -$radiusX -$radiusY $radiusX $radiusY
$canvas move $slice($this,startBottomArcFill) 0 $height
$canvas itemconfigure $slice($this,startBottomArc) -extent 0
$canvas coords $slice($this,startBottomArc) -$radiusX -$radiusY $radiusX $radiusY
$canvas move $slice($this,startBottomArc) 0 $height
$canvas coords $slice($this,startLeftLine) 0 0 0 0
$canvas coords $slice($this,startRightLine) 0 0 0 0
$canvas itemconfigure $slice($this,endBottomArcFill) -extent 0
$canvas coords $slice($this,endBottomArcFill) -$radiusX -$radiusY $radiusX $radiusY
$canvas move $slice($this,endBottomArcFill) 0 $height
$canvas itemconfigure $slice($this,endBottomArc) -extent 0
$canvas coords $slice($this,endBottomArc) -$radiusX -$radiusY $radiusX $radiusY
$canvas move $slice($this,endBottomArc) 0 $height
$canvas coords $slice($this,endLeftLine) 0 0 0 0
$canvas coords $slice($this,endRightLine) 0 0 0 0
$canvas coords $slice($this,startPolygon) 0 0 0 0 0 0 0 0
$canvas coords $slice($this,endPolygon) 0 0 0 0 0 0 0 0
set startX [expr $radiusX*cos($start*$PI/180)]
set startY [expr -$radiusY*sin($start*$PI/180)]
set end [normalizedAngle [expr $start+$extent]]
set endX [expr $radiusX*cos($end*$PI/180)]
set endY [expr -$radiusY*sin($end*$PI/180)]
set startBottom [expr $startY+$height]
set endBottom [expr $endY+$height]
if {(($start>=0)&&($end>=0))||(($start<0)&&($end<0))} {if {$extent<=180} {if {$start<0} {$canvas itemconfigure $slice($this,startBottomArcFill) -start $start -extent $extent
$canvas itemconfigure $slice($this,startBottomArc) -start $start -extent $extent
$canvas coords $slice($this,startPolygon) $startX $startY $endX $endY $endX $endBottom $startX $startBottom
$canvas coords $slice($this,startLeftLine) $startX $startY $startX $startBottom
$canvas coords $slice($this,startRightLine) $endX $endY $endX $endBottom}} else {if {$start<0} {$canvas itemconfigure $slice($this,startBottomArcFill) -start 0 -extent $start
$canvas itemconfigure $slice($this,startBottomArc) -start 0 -extent $start
$canvas coords $slice($this,startPolygon) $startX $startY $radiusX 0 $radiusX $height $startX $startBottom
$canvas coords $slice($this,startLeftLine) $startX $startY $startX $startBottom
$canvas coords $slice($this,startRightLine) $radiusX 0 $radiusX $height
set bottomArcExtent [expr $end+180]
$canvas itemconfigure $slice($this,endBottomArcFill) -start -180 -extent $bottomArcExtent
$canvas itemconfigure $slice($this,endBottomArc) -start -180 -extent $bottomArcExtent
$canvas coords $slice($this,endPolygon) -$radiusX 0 $endX $endY $endX $endBottom -$radiusX $height
$canvas coords $slice($this,endLeftLine) -$radiusX 0 -$radiusX $height
$canvas coords $slice($this,endRightLine) $endX $endY $endX $endBottom} else {$canvas itemconfigure $slice($this,startBottomArcFill) -start 0 -extent -180
$canvas itemconfigure $slice($this,startBottomArc) -start 0 -extent -180
$canvas coords $slice($this,startPolygon) -$radiusX 0 $radiusX 0 $radiusX $height -$radiusX $height
$canvas coords $slice($this,startLeftLine) -$radiusX 0 -$radiusX $height
$canvas coords $slice($this,startRightLine) $radiusX 0 $radiusX $height}}} else {if {$start<0} {$canvas itemconfigure $slice($this,startBottomArcFill) -start 0 -extent $start
$canvas itemconfigure $slice($this,startBottomArc) -start 0 -extent $start
$canvas coords $slice($this,startPolygon) $startX $startY $radiusX 0 $radiusX $height $startX $startBottom
$canvas coords $slice($this,startLeftLine) $startX $startY $startX $startBottom
$canvas coords $slice($this,startRightLine) $radiusX 0 $radiusX $height} else {set bottomArcExtent [expr $end+180]
$canvas itemconfigure $slice($this,endBottomArcFill) -start -180 -extent $bottomArcExtent
$canvas itemconfigure $slice($this,endBottomArc) -start -180 -extent $bottomArcExtent
$canvas coords $slice($this,endPolygon) -$radiusX 0 $endX $endY $endX $endBottom -$radiusX $height
$canvas coords $slice($this,startLeftLine) -$radiusX 0 -$radiusX $height
$canvas coords $slice($this,startRightLine) $endX $endY $endX $endBottom}}}
proc slice::position {this start} {global slice
slice::update $this $start $slice($this,extent)}
proc slice::rotate {this angle} {global slice
if {$angle!=0} {slice::update $this [expr $slice($this,start)+$angle] $slice($this,extent)}}
proc slice::size {this extent} {global slice
slice::update $this $slice($this,start) $extent}
proc slice::data {this arrayName} {global slice
upvar $arrayName data
set data(start) $slice($this,start)
set data(extent) $slice($this,extent)
set data(xRadius) $slice($this,radiusX)
set data(yRadius) $slice($this,radiusY)
set coordinates [$slice($this,canvas) coords $slice($this,origin)]
set data(xCenter) [expr [lindex $coordinates 0]+$data(xRadius)]
set data(yCenter) [expr [lindex $coordinates 1]+$data(yRadius)]
set data(height) $slice($this,height)}
virtual proc pieLabeller::pieLabeller {this canvas args} {
    global pieLabeller
    array set option {-offset 5}
    array set option $args
    set pieLabeller($this,offset) [winfo fpixels $canvas $option(-offset)]
    catch {set pieLabeller($this,font) $option(-font)}
    set pieLabeller($this,canvas) $canvas
}
virtual proc pieLabeller::~pieLabeller {this}
proc pieLabeller::bind {this pieId} {global pieLabeller
set pieLabeller($this,pieId) $pieId}
virtual proc pieLabeller::create {this sliceId args}
virtual proc pieLabeller::update {this label value}
virtual proc pieLabeller::rotate {this label}
proc pieBoxLabeller::pieBoxLabeller {this canvas args} {global pieBoxLabeller
eval pieLabeller::pieLabeller $this $canvas $args
array set option {-justify left}
array set option $args
set pieBoxLabeller($this,justify) $option(-justify)}
proc pieBoxLabeller::~pieBoxLabeller {this} {global pieBoxLabeller
catch {delete canvasLabelsArray $pieBoxLabeller($this,array)}}
proc pieBoxLabeller::create {this sliceId args} {global pieBoxLabeller pieLabeller
if {![info exists pieBoxLabeller($this,array)]} {set options "-justify $pieBoxLabeller($this,justify)"
catch {lappend options -font $pieLabeller($this,font}
set box [$pieLabeller($this,canvas) bbox pie($pieLabeller($this,pieId))]
set pieBoxLabeller($this,array) [eval new canvasLabelsArray $pieLabeller($this,canvas) [lindex $box 0] [expr [lindex $box 3]+$pieLabeller($this,offset)] [expr [lindex $box 2]-[lindex $box 0]] $options]}
set labelId [eval canvasLabelsArray::create $pieBoxLabeller($this,array) $args]
$pieLabeller($this,canvas) addtag pieLabeller($this) withtag canvasLabelsArray($pieBoxLabeller($this,array))
canvasLabel::configure $labelId -text [canvasLabel::cget $labelId -text]:
return $labelId}
proc pieBoxLabeller::update {this labelId value} {regsub {:.*$} [canvasLabel::cget $labelId -text] ": $value" text
canvasLabel::configure $labelId -text $text}
proc pieBoxLabeller::rotate {this labelId} {}
set PI 3.14159265358979323846
proc maximum {a b} {return [expr $a>$b?$a:$b]}
proc minimum {a b} {return [expr $a<$b?$a:$b]}
proc canvasLabel::canvasLabel {this canvas x y args} {global canvasLabel
set canvasLabel($this,canvas) $canvas
set canvasLabel($this,origin) [$canvas create line $x $y $x $y -fill {} -tags canvasLabel($this)]
set canvasLabel($this,rectangle) [$canvas create rectangle 0 0 0 0 -tags canvasLabel($this)]
set canvasLabel($this,text) [$canvas create text 0 0 -tags canvasLabel($this)]
set canvasLabel($this,anchor) center
set canvasLabel($this,style) box
set canvasLabel($this,padding) 2
eval canvasLabel::configure $this $args
canvasLabel::update $this}
proc canvasLabel::~canvasLabel {this} {global canvasLabel
$canvasLabel($this,canvas) delete canvasLabel($this)}
proc canvasLabel::configure {this args} {global canvasLabel
set number [llength $args]
for {set index 0} {$index<$number} {incr index} {set option [lindex $args $index]
set value [lindex $args [incr index]]
switch -- $option {-background {
                $canvasLabel($this,canvas) itemconfigure $canvasLabel($this,rectangle) -fill $value
            }
-foreground {
                $canvasLabel($this,canvas) itemconfigure $canvasLabel($this,text) -fill $value
            }
-borderwidth {
                $canvasLabel($this,canvas) itemconfigure $canvasLabel($this,rectangle) -width $value
                canvasLabel::update $this
            }
-stipple {
                $canvasLabel($this,canvas) itemconfigure $canvasLabel($this,rectangle) $option $value
            }
-anchor {
                set canvasLabel($this,anchor) $value
                canvasLabel::update $this
            }
-font -
-justify -
-text -
-width {
                $canvasLabel($this,canvas) itemconfigure $canvasLabel($this,text) $option $value
                canvasLabel::update $this
            }
-bordercolor {
                $canvasLabel($this,canvas) itemconfigure $canvasLabel($this,rectangle) -outline $value
            }
-style {
                set canvasLabel($this,style) $value
                canvasLabel::update $this
            }}}}
proc canvasLabel::cget {this option} {global canvasLabel
switch -- $option {-background {
            return [$canvasLabel($this,canvas) itemcget $canvasLabel($this,rectangle) -fill]
        }
-foreground {
            return [$canvasLabel($this,canvas) itemcget $canvasLabel($this,text) -fill]
        }
-borderwidth {
            return [$canvasLabel($this,canvas) itemcget $canvasLabel($this,rectangle) -width]
        }
-stipple {
            return [$canvasLabel($this,canvas) itemcget $canvasLabel($this,rectangle) $option]
        }
-anchor {
            return $canvasLabel($this,anchor)
        }
-font -
-justify -
-text -
-width {
            return [$canvasLabel($this,canvas) itemcget $canvasLabel($this,text) $option]
        }
-bordercolor {
            return [$canvasLabel($this,canvas) itemcget $canvasLabel($this,rectangle) -outline]
        }
-style {
            return canvasLabel($this,style) $value
        }}}
proc canvasLabel::update {this} {global canvasLabel
set canvas $canvasLabel($this,canvas)
set rectangle $canvasLabel($this,rectangle)
set text $canvasLabel($this,text)
set coordinates [$canvas coords $canvasLabel($this,origin)]
set x [lindex $coordinates 0]
set y [lindex $coordinates 1]
set border [$canvas itemcget $rectangle -width]
set textBox [$canvas bbox $text]
if {[string compare $canvasLabel($this,style) split]==0} {set textHeight [expr [lindex $textBox 3]-[lindex $textBox 1]]
set rectangleWidth [expr 2.0*($textHeight+$border)]
set halfWidth [expr ($rectangleWidth+$canvasLabel($this,padding)+([lindex $textBox 2]-[lindex $textBox 0]))/2.0]
set halfHeight [expr ($textHeight/2.0)+$border]
$canvas coords $rectangle [expr $x-$halfWidth] [expr $y-$halfHeight] [expr $x-$halfWidth+$rectangleWidth] [expr $y+$halfHeight]
$canvas coords $text [expr $x+(($rectangleWidth+$canvasLabel($this,padding))/2.0)] $y} else {set halfWidth [expr $border+$canvasLabel($this,padding)+(([lindex $textBox 2]-[lindex $textBox 0])/2.0)]
set halfHeight [expr $border+$canvasLabel($this,padding)+(([lindex $textBox 3]-[lindex $textBox 1])/2.0)]
$canvas coords $rectangle [expr $x-$halfWidth] [expr $y-$halfHeight] [expr $x+$halfWidth] [expr $y+$halfHeight]
$canvas coords $text $x $y}
set anchor $canvasLabel($this,anchor)
set xDelta [expr ([string match *w $anchor]-[string match *e $anchor])*$halfWidth]
set yDelta [expr ([string match n* $anchor]-[string match s* $anchor])*$halfHeight]
$canvas move $rectangle $xDelta $yDelta
$canvas move $text $xDelta $yDelta}
proc piePeripheralLabeller::piePeripheralLabeller {this canvas args} {global piePeripheralLabeller pieLabeller
eval pieLabeller::pieLabeller $this $canvas $args
catch {set piePeripheralLabeller($this,smallFont) $pieLabeller($this,font)}
array set option {-justify left}
array set option $args
catch {set piePeripheralLabeller($this,smallFont) $option(-smallfont)}
set piePeripheralLabeller($this,justify) $option(-justify)}
proc piePeripheralLabeller::~piePeripheralLabeller {this} {global piePeripheralLabeller pieLabeller
catch {delete canvasLabelsArray $piePeripheralLabeller($this,array)}
$pieLabeller($this,canvas) delete pieLabeller($this)}
proc piePeripheralLabeller::create {this sliceId args} {global piePeripheralLabeller pieLabeller
set canvas $pieLabeller($this,canvas)
set valueId [$canvas create text 0 0 -tags pieLabeller($this)]
catch {$canvas itemconfigure $valueId -font $piePeripheralLabeller($this,smallFont)}
set box [$canvas bbox $valueId]
set smallTextHeight [expr [lindex $box 3]-[lindex $box 1]]
if {![info exists piePeripheralLabeller($this,array)]} {set options "-style split -justify $piePeripheralLabeller($this,justify)"
catch {lappend options -font $pieLabeller($this,font}
set box [$canvas bbox pie($pieLabeller($this,pieId))]
set piePeripheralLabeller($this,array) [eval new canvasLabelsArray $canvas [lindex $box 0] [expr [lindex $box 3]+(2*$pieLabeller($this,offset))+$smallTextHeight] [expr [lindex $box 2]-[lindex $box 0]] $options]}
set labelId [eval canvasLabelsArray::create $piePeripheralLabeller($this,array) $args]
$canvas addtag pieLabeller($this) withtag canvasLabelsArray($piePeripheralLabeller($this,array))
set piePeripheralLabeller($this,sliceId,$valueId) $sliceId
return $valueId}
proc piePeripheralLabeller::anglePosition {degrees} {return [expr (2*($degrees/90))+(($degrees%90)!=0)]}
set index 0
foreach anchor {w sw s se e ne n nw} {set piePeripheralLabeller(anchor,[piePeripheralLabeller::anglePosition [expr $index*45]]) $anchor
incr index}
unset index anchor
proc piePeripheralLabeller::update {this valueId value} {global pieLabeller
piePeripheralLabeller::rotate $this $valueId
$pieLabeller($this,canvas) itemconfigure $valueId -text $value}
proc piePeripheralLabeller::rotate {this valueId} {global piePeripheralLabeller pieLabeller PI
set canvas $pieLabeller($this,canvas)
set sliceId $piePeripheralLabeller($this,sliceId,$valueId)
slice::data $sliceId data
set midAngle [expr $data(start)+($data(extent)/2.0)]
set radians [expr $midAngle*$PI/180]
set x [expr ($data(xRadius)+$pieLabeller($this,offset))*cos($radians)]
set y [expr ($data(yRadius)+$pieLabeller($this,offset))*sin($radians)]
set angle [expr round($midAngle)%360]
if {$angle>180} {set y [expr $y-$data(height)]}
set coordinates [$pieLabeller($this,canvas) coords $valueId]
$pieLabeller($this,canvas) move $valueId [expr $data(xCenter)+$x-[lindex $coordinates 0]] [expr $data(yCenter)-$y-[lindex $coordinates 1]]
$canvas itemconfigure $valueId -anchor $piePeripheralLabeller(anchor,[piePeripheralLabeller::anglePosition $angle])}
proc canvasLabelsArray::canvasLabelsArray {this canvas x y width args} {global canvasLabelsArray
set canvasLabelsArray($this,canvas) $canvas
set canvasLabelsArray($this,width) [winfo fpixels $canvas $width]
set canvasLabelsArray($this,origin) [$canvas create line $x $y $x $y -fill {} -tags canvasLabelsArray($this)]
array set option {-justify left -style box}
array set option $args
catch {set canvasLabelsArray($this,font) $option(-font)}
set canvasLabelsArray($this,justify) $option(-justify)
set canvasLabelsArray($this,style) $option(-style)}
proc canvasLabelsArray::~canvasLabelsArray {this} {global canvasLabelsArray
foreach label $canvasLabelsArray($this,labelIds) {delete canvasLabel $label}
$canvasLabelsArray($this,canvas) delete canvasLabelsArray($this)}
proc canvasLabelsArray::create {this args} {global canvasLabelsArray
if {[lsearch -exact $args -font]<0} {catch {lappend args -font $canvasLabelsArray($this,font)}}
if {[lsearch -exact $args -style]<0} {lappend args -style $canvasLabelsArray($this,style)}
set labelId [eval new canvasLabel $canvasLabelsArray($this,canvas) 0 0 $args]
$canvasLabelsArray($this,canvas) addtag canvasLabelsArray($this) withtag canvasLabel($labelId)
lappend canvasLabelsArray($this,labelIds) $labelId
canvasLabelsArray::position $this $labelId
return $labelId}
proc canvasLabelsArray::position {this labelId} {global canvasLabelsArray
set canvas $canvasLabelsArray($this,canvas)
set coordinates [$canvas coords $canvasLabelsArray($this,origin)]
set x [lindex $coordinates 0]
set y [lindex $coordinates 1]
set coordinates [$canvas bbox canvasLabel($labelId)]
set labelHeight [expr [lindex $coordinates 3]-[lindex $coordinates 1]]
set index [expr [llength $canvasLabelsArray($this,labelIds)]-1]
switch $canvasLabelsArray($this,justify) {
        left {
            set x [expr $x+(($index%2)*($canvasLabelsArray($this,width)/2.0))]
            set anchor nw
        }
        right {
            set x [expr $x+((($index%2)+1)*($canvasLabelsArray($this,width)/2.0))]
            set anchor ne
        }
        default {
            set x [expr $x+((1.0+(2*($index%2)))*$canvasLabelsArray($this,width)/4)]
            set anchor n
        }
    }
canvasLabel::configure $labelId -anchor $anchor
$canvas move canvasLabel($labelId) $x [expr $y+(($index/2)*$labelHeight)]}
