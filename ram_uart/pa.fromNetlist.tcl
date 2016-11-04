
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name ram_uart -dir "D:/misledom/ram_uart/ram_uart/planAhead_run_4" -part xc3s1200efg320-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "D:/misledom/ram_uart/ram_uart/machine_switcher.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {D:/misledom/ram_uart/ram_uart} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "ram_state_machine.ucf" [current_fileset -constrset]
add_files [list {ram_state_machine.ucf}] -fileset [get_property constrset [current_run]]
link_design
