`timescale 1ns/1ns
`include "Capstone.v"

module full_subtractorTB; //Testbench for full subtractor
	reg X, Y, Bin; //Input registers
	
	wire D, Bout; // Output wires
	
	full_subtractor UUT(X, Y, Bin, D, Bout); // Unit Under Test
	// Test Execution
	initial 
	begin
		// Show the truth table for F.
		$display("x y Bin | d Bout");
		$display("----------------");
		$monitor("%b %b %b | %b %b", X, Y, Bin, D, Bout);
		// Iterate through all possible inputs.
		for (integer i = 0; i < 8; i++)
			begin
				{X, Y, Bin} = i; #10;
			end
	end
endmodule