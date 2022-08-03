
//accumulator right shift register
module accumulator_shift_reg (input CLK, //Clock
							  input Si, //Serial in
							  input Sh, //shift right 
							  input L, //Load enable
							  input Load, //Load value
							  output Sout //Shift out
							  ); 

endmodule






// cyclical shift register
module addend_shift_reg (input CLK, //Clock
						 input C, //Cyclical shift
						 input L, //Load enable
						 input Load, //Load 
						 output Sout //Serial out
						 );

endmodule







//Module for borrow flipflop
module borrow_flipflop (D, //Input
                       CLK, 
                       Q //Output
					   ); 
    input D, CLK;
    output reg Q;

    always @(negedge CLK) begin //executes block at every neg edge of clock // print current values to output console
        Q = D;
    end

endmodule







//Module for full subtractor
module full_subtractor (input x, //Minuend
                       input y, //Subtrahend
                       input Bin, //Borrow in
                       output d, //Difference
                       output Bout //Borrow out
					   ); 
    
    assign d = x ^ y ^ Bin; // D(x, y, Bin) = x ⊕ y ⊕ Bin
    assign Bout = (~x & Bin) | (y & Bin) | (~x & y); //Bout(x, y, Bin) = x'*Bin + Y*Bin + x'y

endmodule





module top (input St, //start signal
			input CLK, // clock
			output Sh //Control circuit
			);
	
	
	
endmodule


/////////////////////////////
////top module Testbench////
///////////////////////////


module topTB; //Testbench for control circuit
    
endmodule