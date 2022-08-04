`timescale 1ns/1ns
`include "Capstone.v"

module addend_shift_regTB; //Testbench for addend
    reg CLK, C, L, R; 
    reg [7:0] Load;
    
	wire Sout;
	addend_shift_reg UUT(CLK, L, Load, Sout);

    initial begin
        CLK = 0; 
        Load = 8'b10100100;
        L = 1;
 

        $display("CLK L Load      Sout");
        


        $monitor("Sout: %b", Sout);

        #10 
        CLK = 1;
        L = 0;
        #10 
        CLK = 0;
        L = 0;
        #10 
        CLK = 1;
        L = 0;
        #10 
        CLK = 0;
        L = 1;
        Load = 8'b01101101;
        #10
        CLK = 1;
        L = 0;
        #10
        CLK = 0;
        L = 0;
    end 

    
        
	initial begin
		 	
	end
    initial
		#90 $finish; 
endmodule