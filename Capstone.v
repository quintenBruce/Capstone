//accumulator right shift register
module accumulator_shift_reg (input CLK, //Clock
							  input Si, //Serial in
							  //input Sh, //shift right 
							  input L, //Load enable
							  input [7:0] Load, //Load value
							  output Sout //Shift out
							  ); 

	reg Sout;
	reg [7:0] accumulator;

	always @ (CLK) begin
		if (L) begin 
			accumulator = Load;
		$display("Accumulator Loaded: %b", accumulator);
		end
			
	end

	always @ (posedge CLK) begin
		if (!L) begin
			$display("\nPositive Edge");
		
		Sout = accumulator[0];
		$display("Accumulator: %b Sout: %b", accumulator, Sout);
		end
		
	end

	always @ (negedge CLK) begin
		if (!L) begin
			$display("\nNegative Edge");
		//if (Sh) begin
			accumulator = {Si, accumulator[7:1]};
		//end
		$display("Accumulator: %b Si: %b", accumulator, Si);
		end
		
	end
endmodule




// cyclical shift register
module addend_shift_reg (input CLK, //Clock
						 input L, //Load enable
						 input [7:0] Load, //Load 
						 output Sout //Serial out
						 );

	reg Sout;
	reg [7:0] subtrahend;



	always @ (CLK) begin
		if (L) begin
			subtrahend = Load;

			$display("Subtrahend Loaded: %b", subtrahend);
		end
			
	end	
	
	always @ (posedge CLK) begin
		if (!L) begin
			$display("\nPositive Edge");
		
		Sout = subtrahend[0];
		$display("Subtrahend: %b Sout: %b", subtrahend, Sout);
		end
		
	end	
	always @ (negedge CLK) begin
		if (!L) begin
			$display("\nNegative Edge");
		
		subtrahend = {subtrahend[0], subtrahend[7:1]};
		$display("Subtrahend: %b", subtrahend);
		end
		
	end
endmodule


//Module for borrow flipflop
module borrow_flipflop (input D, //Input
                       input CLK, 
					   input R,
                       output reg Q //Output
			
					   ); 
	

    always @(negedge CLK) begin //executes block at every neg edge of clock // print current values to output console
        if (!R)
			Q = D;
		else
			Q = 0;
    end

endmodule





//Module for full subtractor
module full_subtractor (input X, //Minuend
                       input Y, //Subtrahend
                       input Bin, //Borrow in
                       output D, //Difference
                       output Bout //Borrow out
					   ); 
    
    assign D = X ^ Y ^ Bin; // D(x, y, Bin) = x ⊕ y ⊕ Bin
    assign Bout = (~X & Bin) | (Y & Bin) | (~X & Y); //Bout(x, y, Bin) = x'*Bin + Y*Bin + x'y
	always @ (Bout) $display("X: %b Y: %b Bin: %b D: %b Bout: %b", X, Y, Bin, D, Bout);

	

endmodule





module top (input St, //start signal
			output Sh //Control circuit
			);
	
	reg CLK = 0;
	reg LAccumulator = 1;
	wire minuend;
	reg [7:0] LoadAcc = 8'b00101101;

	accumulator_shift_reg accumulatorReg(
		.CLK(CLK), .Si(Si), .L(LAccumulator), .Load(LoadAcc), .Sout(minuend)
	);



	reg LSubtrahend = 1;
	wire subtrahend;
	reg [7:0] LoadSubtrahend = 8'b11010000;

	addend_shift_reg subtrahendReg(
		.CLK(CLK), .L(LSubtrahend), .Load(LoadSubtrahend), .Sout(subtrahend)
	);

	wire Bout;
	wire Bin;
	reg R = 1;

	borrow_flipflop flipflop(
		.D(Bout), .CLK(CLK), .R(R), .Q(Bin)
	);


	full_subtractor subtractor(
		.X(minuend), .Y(subtrahend), .Bin(Bin), .D(Si), .Bout(Bout)
	);

	

	
	always begin
		$display("\nCLK: %b Min: %b, Sub: %b, D: %b Bout: %b",CLK,  minuend, subtrahend, Si, Bout);
		$monitor("Si: %b Bout: %b", Si, Bout);
		#10 
		R = 0;
		CLK = 0;
		LAccumulator = 0;
		LSubtrahend = 0;
		#10
		R = 0;
		CLK = ~CLK;

		
	end


	always #180 $finish;
	

	


endmodule





/////////////////////////////
////top module Testbench////
///////////////////////////


module topTB; //Testbench for control circuit
    
endmodule