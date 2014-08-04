#!/usr/local/bin/wish

source @includedir@/piecrunch.tcl 
source @includedir@/FSBox.tcl
#source oop.tcl
#source pie.tcl
#source perilabel.tcl


########################################################
proc createPieChart {} {
  global pie_idle canvas
  set pie_idle [new pie\
    $canvas 10 10 200 100 -thickness 20 -background gray\
    -labeller [new piePeripheralLabeller $canvas -font variable \
    -smallfont fixed]\
  ]

  pack .canvas .buttons -side top -fill both -expand 1

  ### Move canvas around with button 1.
  $canvas move pie($pie_idle) 30 20
  $canvas bind pie($pie_idle) <ButtonPress-1> "
          set xLast %x
          set yLast %y
      "
      $canvas bind pie($pie_idle) <Button1-Motion> "
          $canvas move pie($pie_idle)\
              \[expr %x-\$xLast\] \[expr %y-\$yLast\]
          set xLast %x
          set yLast %y
      "
}
########################################################
proc savePieChart {} {
  global fsBox
 
  set fsBox(pattern) *.ps
  FSBox "Save pie-chart" -fsBoxActionOk "savePieChart_ok"
}


proc savePieChart_ok {} {
  global canvas fsBox piecolour

  set filename $fsBox(name)
  if {$filename==""} {
      tk_dialog .dialog "Error" {No filename given} error 0 Ok 
  } else {
      set fontMap(fixed) [list Courier 12]
      if {[file exists $filename]} {
	  if {[tk_dialog .dialog "Error" {The file already exists.} info 0 Overwrite Cancel]==0} {
              $canvas postscript -file $filename -fontmap fontMap -colormode $piecolour
          }
      } else {
          $canvas postscript -file $filename -fontmap fontMap -colormode $piecolour
      }
  } 
}

########################################################
### Title of the window
wm title . "The Oxford BSPlib toolset: process view" 
frame .buttons -bg white 

set topmessage ""
label .msg -pady 2 -relief raised -textvariable topmessage
pack .msg -side top


### Draw the pie chart
set canvas [canvas .canvas -highlightthickness 0 -width 300 -height 230]
pack $canvas -padx 20 -pady 20 -fill both -expand 1
createPieChart

### Create the radio buttons
set idle comp
radiobutton .buttons.comp -text "Comp" -variable idle -value comp \
	    -command {daVinci tcl_answer comp}
pack        .buttons.comp -side left -pady 2 -anchor w -fill both -expand 1

radiobutton .buttons.comm -text "Comm" -variable idle -value comm \
	    -command {daVinci tcl_answer comm}
pack        .buttons.comm -side left -pady 2 -anchor w -fill both -expand 1

radiobutton .buttons.wait -text "Wait" -variable idle -value wait \
	    -command {daVinci tcl_answer wait}
pack        .buttons.wait -side left -pady 2 -anchor w -fill both -expand 1

radiobutton .buttons.hrel -text "H-rel" -variable idle -value hrel \
	    -command {daVinci tcl_answer hrel}
pack        .buttons.hrel -side left -pady 2 -anchor w -fill both -expand 1

checkbutton .buttons.combine -text Combine \
            -command {daVinci tcl_answer combine}
pack   .buttons.combine -side left -pady 2 -anchor w -fill both -expand 1

button .buttons.save -text Save -command {savePieChart}
pack   .buttons.save -side left -pady 2 -anchor w -fill both -expand 1

## set slice0 [pie::newSlice $pie_idle "Proc 0"];set slice1 [pie::newSlice $pie_idle "Proc 1"];set slice2 [pie::newSlice $pie_idle "Proc 2"]

## pie::sizeSlice $pie_idle $slice0 0.1 "10%";pie::sizeSlice $pie_idle $slice1 0.3 "30%";pie::sizeSlice $pie_idle $slice0 0.6 "60%"

set piecolour color

