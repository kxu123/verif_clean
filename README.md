To run the testbench, run make in the main repository directory. Make will compile and link the C CORDIC reference function, compile the .sv testbench files, and run the simulation. 

The test case output will include the following:
- Information about the specific test cases run, and the corresponding inputs and outputs. There will be a section across all the inputs and outputs that display a table with ref_x 0, ref_z 0, m00_data_x 0, and m00_data_z 0. These fields can be ignored, this isn't the actual data coming out. The relevant fields in this table are s00_data_x and s00_data_y that display the input hex values.
- For each test case there will also be a statement that has "monitor found packet...". For this field, ignore the 0s in ref_x and ref_y. This is due to the fact that the interface itself doesn't have a direct value corresponding to the reference values. The S and M data fields are correct however.
- Finally, if the test case passes, it will just display "IN SCOREBOARD" twice with the expected and actual values for x (magnitude) and z (magnitude). If the test case doesn't pass, it will display those fields along with "UVM_ERROR".

The test case also includes coverage insight at the bottom of the output:
- Code coverage including Line Coverage, Branch Coverage, Condition Coverage, and Toggle Coverage displayed on the terminal
- Functional Coverage. Opening the listed directory/dashboard.html will display a single score for the functional coverage. With ~5 cases the coverage is around 8, and with 150 test cases the coverage is around 34. 

In axi_cordic_sequence.sv, you can change the number of test cases by changing the repeat (X) value on L11. 
