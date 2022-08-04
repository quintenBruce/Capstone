//accumulator right shift register
module accumulator_shift_reg (input CLK, //Clock
							  input Si, //Serial in
							  input L, //Load enable
							  input [7:0] Load, //Load value
							  input PoutE, //Parralell out enable
							  output Sout, //Shift out
							  output reg [7:0] Pout //Parralell out
							  ); 
	reg Sout;
	reg [7:0] accumulator;

	always @ (CLK) begin
		if (L) begin 
			accumulator = Load;
		end
		
	end

	always @ (posedge CLK) begin
		if (!L)
			Sout = accumulator[0];
		if (PoutE)
			Pout = accumulator;
	end

	always @ (negedge CLK) begin
		if (!L)
			accumulator = {Si, accumulator[7:1]};

		if (PoutE)
			Pout = accumulator;
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
		end
	end	
	
	always @ (posedge CLK) begin
		if (!L)
			Sout = subtrahend[0];
	end	
	always @ (negedge CLK) begin
		if (!L) 
			subtrahend = {subtrahend[0], subtrahend[7:1]};
	end
endmodule


//Module for borrow flipflop
module borrow_flipflop (input D, //Input
                       input CLK, 
					   input R, //Reset
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
endmodule

module top (input St, //start signal
			input [7:0] eightBitMinuend,
			input [7:0] eightBitSubtrahend,
			output [7:0] eightBitDifference
			);
	reg [7:0] acc;
	reg CLK = 0;
	reg LAccumulator = 1;
	wire minuend;
	reg PoutE = 0;
	wire [7:0] Difference;

	accumulator_shift_reg accumulatorReg(
		.CLK(CLK), .Si(Si), .L(LAccumulator), .Load(eightBitMinuend), .Sout(minuend), .PoutE(PoutE), .Pout(eightBitDifference)
	);

	reg LSubtrahend = 1;
	wire subtrahend;

	addend_shift_reg subtrahendReg(
		.CLK(CLK), .L(LSubtrahend), .Load(eightBitSubtrahend), .Sout(subtrahend)
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

	initial begin
		$dumpfile("sss.vcd");
		$dumpvars(0, top);
	end
	
	always begin
		#10 
		R = 0;
		CLK = 0;
		LAccumulator = 0;
		LSubtrahend = 0;
		//$display("\nCLK: %b Min: %b, Sub: %b, D: %b Bout: %b",CLK,  minuend, subtrahend, Si, Bout);
		#10
		CLK = ~CLK;
	end


	always #180 begin
		PoutE = 1;
		#10
		//$display("Accu: ", Difference);
		$finish;

	end
endmodule

/////////////////////////////
////top module Testbench////
///////////////////////////


module topTB; //Testbench for control circuit
    reg St; //Input registers

	reg [7:0] eightBitMinuend = 8'b10100101 ;
	reg [7:0] eightBitSubtrahend = 8'b10000011;
	wire [7:0] eightBitDifference;

	top UUT(.St(St), .eightBitMinuend(eightBitMinuend), .eightBitSubtrahend(eightBitSubtrahend), .eightBitDifference(eightBitDifference)); // Unit Under Test
	// Test Execution
	initial begin
		#190
		$display(" %b {%d}", eightBitMinuend, eightBitMinuend);
		$display("-%b {%d}", eightBitSubtrahend, eightBitSubtrahend);
		$display("------------");
		$display(" %b {%d}\n\n", eightBitDifference, eightBitDifference);
		// #190
		// 
		// $display(" %b {%d}", eightBitMinuend, eightBitMinuend);
		// $display("-%b {%d}", eightBitSubtrahend, eightBitSubtrahend);
		// $display("------------");
		// $display(" %b {%d}\n\n", eightBitDifference, );
	end
endmodule