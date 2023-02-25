open_project [pwd]/Automation_demo/Automation_demo.xpr
set_property source_mgmt_mode None [current_project]
update_compile_order -fileset sources_1	

set fname [lindex $argv 0]
set suffix [file extension $fname]
set fname_wo_extension [string trimright $fname $suffix]

set_property top $fname_wo_extension [current_fileset]
update_compile_order -fileset sources_1



puts $fname
puts $suffix
puts $fname_wo_extension


reset_run synth_1
launch_runs synth_1 -jobs 16

reset_run impl_1
launch_runs impl_1 -jobs 16


set x 0
while {$x !=1 } {
	if {[catch {open_run impl_1}]} { 
		set x 0 
		continue } \
	else { set x 1 }
}


report_power > Impl_Automation_demo/$fname_wo_extension/power.txt
report_timing > Impl_Automation_demo/$fname_wo_extension/timing.txt
report_utilization > Impl_Automation_demo/$fname_wo_extension/utilization.txt

close_project
