
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name ram_uart -dir "D:/CC/ram_uart/ram_uart/planAhead_run_2" -part xc3s1200efg320-4
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "ram_state_machine.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {ram_controller.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {src/seg_displayer.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {ram_full.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {src/ram_state_machine.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set_property top ram_state_machine $srcset
add_files [list {ram_state_machine.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc3s1200efg320-4
