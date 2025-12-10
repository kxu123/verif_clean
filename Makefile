
run:
	xsc ../project_verif/cordic_model.c
	xvlog -sv -L uvm axi_cordic.sv axi_cordic_item.sv ./axi_cordic_driver.sv cordic_interface.sv axi_cordic_sequence.sv axi_cordic_monitor.sv axi_cordic_scoreboard.sv axi_cordic_agent.sv axi_cordic_env.sv axi_cordic_test.sv
	xvlog -sv -L uvm tb_top.sv
	xelab -debug typical -top tb_top -L uvm -sv_lib dpi -snapshot test
	#xsim test -R -testplusarg "UVM_TESTNAME=axi_cordic_test"
	xsim test -tclbatch xsim_run_wave.tcl -testplusarg "UVM_TESTNAME=axi_cordic_test"


