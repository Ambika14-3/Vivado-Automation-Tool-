create_project -force Automation [pwd]/Automation -part xc7k325tffg900-2
set_property board_part xilinx.com:kc705:part0:1.5 [current_project]
update_compile_order -fileset sources_1

add_files -norecurse [pwd]/Modules/top_CLA8.v
add_files -norecurse [pwd]/Modules/top_CLA16.v
add_files -norecurse [pwd]/Modules/top_CLA32.v
add_files -norecurse [pwd]/Modules/top_CLA64.v
add_files -norecurse [pwd]/Modules/PGGen.v

update_compile_order -fileset sources_1

close_project
