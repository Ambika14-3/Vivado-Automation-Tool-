create_project -force Automation_demo [pwd]/Automation_demo -part xc7a35tcpg236-1
set_property board_part digilentinc.com:basys3:part0:1.1 [current_project]
update_compile_order -fileset sources_1

foreach x $argv {
    add_files -norecurse $x
    update_compile_order -fileset sources_1
}



close_project
