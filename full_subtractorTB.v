`timescale 1ns/1ns
`include "Capstone.v"

module full_subtractorTB; //Testbench for full subtractor
	reg x, y, Bin; //Input registers
	
	wire d, Bout; // Output wires
	
	full_subtractor UUT(x, y, Bin, d, Bout); // Unit Under Test
	// Test Execution
	initial 
	begin
		// Show the truth table for F.
		$display("x y Bin | d Bout");
		$display("----------------");
		$monitor("%b %b %b | %b %b", x, y, Bin, d, Bout);
		// Iterate through all possible inputs.
		for (integer i = 0; i < 8; i++)
			begin
				{x, y, Bin} = i; #10;
			end
	end
endmodule