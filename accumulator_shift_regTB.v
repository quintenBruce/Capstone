`timescale 1ns/1ns
`include "Capstone.v"

module accumulator_shift_regTB; //Testbench for accumulator
    reg CLK, C, LE, Si, PoutE; 
    reg [7:0] Load;
    wire [7:0] Pout;
    
	wire Sout;
	accumulator_shift_reg UUT(CLK, Si, LE, Load,  PoutE, Sout, Pout);

///////////////////
////Load in a value (be sure to set LE to one and zero after you load) then Serial in number on the falling edge and show it's Sout (output) a few times. then enable PoutE for parrelell out and display Pout
///////////////////

    // initial begin
    //     CLK = 0; 
    //     Load = 8'b10100100;
    //     LE = 1;
    //     Si = 1;
    //     $display("CLK LE Load      Sout");

    //     #10 
    //     CLK = 1;
    //     LE = 0;
    //     Si = 1;
        
    //     #10 
    //     CLK = 0;
    //     LE = 0;
    //     Si = 1;
    //     PoutE = 1;

    //     $display("Pout: %b Sout: %b", Pout, Sout);
    //     #10 
    //     CLK = 1;
    //     LE = 0;
    //     #10 
    //     CLK = 0;
    //     LE = 1;
    //     Load = 8'b00000000;
    //     #10
    //     CLK = 1;
    //     LE = 0;
    //     #10
    //     CLK = 0;
    //     LE = 0;
    // end 

    
        
	// initial begin
		 	
	// end
    // initial
	// 	#90 $finish; 
endmodule