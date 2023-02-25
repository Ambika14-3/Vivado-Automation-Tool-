open_project [pwd]/Automation_demo/Automation_demo.xpr
set_property source_mgmt_mode None [current_project]
update_compile_order -fileset sources_1	

set_property top [string trimright [lindex $argv 0] ".v"] [current_fileset]
set_property source_mgmt_mode None [current_project]
update_compile_order -fileset sources_1

reset_run synth_1
launch_runs synth_1 -jobs 12

reset_run impl_1
launch_runs impl_1 -jobs 12

set x 0
while {$x !=1 } {
	if {[catch {open_run impl_1}]} { 
		set x 0 
		continue } \
	else { set x 1 }
}

report_power > Impl_Automation_demo/[string trimright [lindex $argv 0] ".v"]/power.txt
report_timing > Impl_Automation_demo/[string trimright [lindex $argv 0] ".v"]/timing.txt
report_utilization > Impl_Automation_demo/[string trimright [lindex $argv 0] ".v"]/utilization.txt

close_project
