`timescale 1ns/1ns
`include "Capstone.v"

module borrow_flipflopTB; //Testbench for borrow flip flop module
    reg D, CLK; 
	wire Q;
	borrow_flipflop UUT(D, CLK, Q);
	always begin
        #10;
        
        
        $monitor("%b  %b  %b| %b", D, CLK, Q); 
		{D, CLK} = {D, CLK} + 1;
		
    end
        
	initial begin
	    {D, CLK} = 2'b00; 
		$display("D CLK  R| Q"); 	
	end
    initial
		#90 $finish; 
endmodule