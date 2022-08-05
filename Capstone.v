//accumulator right shift register
module accumulator_shift_reg (input CLK, //Clock
							  input Si, //Serial in
							  input LE, //Load enable
							  input [7:0] Load, //Load value
							  input PoutE, //Parralell out enable
							  output Sout, //Shift out
							  output reg [7:0] Pout //Parralell out
							  ); 
	reg Sout;
	reg [7:0] accumulator;

	always @ (CLK) begin
		if (LE)
			accumulator = Load;
	end

	always @ (posedge CLK) begin
		if (!LE)
			Sout = accumulator[0];
		if (PoutE)
			Pout = accumulator;
	end

	always @ (negedge CLK) begin
		if (!LE)
			accumulator = {Si, accumulator[7:1]};

		if (PoutE)
			Pout = accumulator;
	end
endmodule

// cyclical shift register
module subtrahend_shift_reg (input CLK, //Clock
						 input LE, //Load enable
						 input [7:0] Load, //Load 
						 output Sout //Serial out
						 );
	reg Sout;
	reg [7:0] subtrahend;

	always @ (CLK) begin
		if (LE) 
			subtrahend = Load;
	end	

	always @ (posedge CLK) begin
		if (!LE)
			Sout = subtrahend[0];
	end

	always @ (negedge CLK) begin
		if (!LE) 
			subtrahend = {subtrahend[0], subtrahend[7:1]};
	end
endmodule


//Module for borrow flipflop
module borrow_flipflop (input D, //Input
                       input CLK, 
					   input R, //Reset
                       output reg Q //Output
					   ); 
    always @(negedge CLK) begin
		Q = R ? 0 : D;
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

// Status Register module
module status_register(input [7:0] X,   // Minuend
					   input [7:0] Y,   // Subtrahend
					   input clk, // Clock
					   output reg SReg1, // Status Register Z, 0x00
					   output reg SReg2, // Status Register N, negative
					   output reg SReg3  // Status Register V, overflow
					   );
	always @ (negedge clk) begin
		SReg1 = X == Y ? 1 : 0;
		SReg2 = X < Y ? 1 : 0;
		SReg3 = ((Y - X) >= 128) ? 1 : 0;
	end
endmodule	

module top (input St, //start signal
			input [7:0] eightBitMinuend, //One byte minuend
			input [7:0] eightBitSubtrahend, //One byte Subtrahend
			output [7:0] eightBitDifference, //One byte difference
			output StatusRegZ, //Flag (subtraction operation is 0x00)
			output StatusRegN, //Flag (subtraction is negative)
			output StatusRegV // Flag (subtraction operation results in an overflow)
			);
	reg [7:0] acc;
	reg CLK = 0;
	reg LAccumulator = 1;
	wire minuend;
	reg PoutE = 0;
	wire [7:0] Difference;
	wire Z, N, V; 

	accumulator_shift_reg accumulatorReg( //Instantiate accumulater shift register
		.CLK(CLK), .Si(Si), .LE(LAccumulator), .Load(eightBitMinuend), .Sout(minuend), .PoutE(PoutE), .Pout(eightBitDifference)
	);

	reg LSubtrahend = 1;
	wire subtrahend;

	subtrahend_shift_reg subtrahendReg( //Instantiate subtrahend shift register
		.CLK(CLK), .LE(LSubtrahend), .Load(eightBitSubtrahend), .Sout(subtrahend)
	);

	wire Bout;
	wire Bin;
	reg R = 1;

	borrow_flipflop flipflop( //Instantiate borrow flipflop
		.D(Bout), .CLK(CLK), .R(R), .Q(Bin)
	);

	full_subtractor subtractor(//Instantiate full subtractor combinational circuit
		.X(minuend), .Y(subtrahend), .Bin(Bin), .D(Si), .Bout(Bout)
	);

	status_register register( //Instantiate status register
		.X(eightBitMinuend), .Y(eightBitSubtrahend), .clk(CLK), .SReg1(StatusRegZ), .SReg2(StatusRegN), .SReg3(StatusRegV)
	);
	
	always begin
		#10 
		R = 0;
		CLK = 0;
		LAccumulator = 0;
		LSubtrahend = 0;
		#10 CLK = ~CLK;
	end

	always #180 begin
		PoutE = 1;
		#10 $finish;
	end
endmodule

/////////////////////////////
////top module Testbench////
///////////////////////////


module topTB; //Testbench for control circuit
    reg St; //Input registers
	reg [7:0] eightBitMinuend = 8'b00110100; //assi
	reg [7:0] eightBitSubtrahend = 8'b11110111;
	wire [7:0] eightBitDifference;
	wire Z, N, V;

	top UUT(.St(St), .eightBitMinuend(eightBitMinuend), .eightBitSubtrahend(eightBitSubtrahend), .eightBitDifference(eightBitDifference), .StatusRegZ(Z), .StatusRegN(N), .StatusRegV(V)); // Unit Under Test
	// Test Execution
	initial begin
		#190
		$display(" %b {%d}", eightBitMinuend, eightBitMinuend);
		$display("-%b {%d}", eightBitSubtrahend, eightBitSubtrahend);
		$display("------------");
		$display(" %b\n", eightBitDifference);
		$display("Status Registers:");
		$display("Z= %b  N= %b  V= %b", Z, N, V);
	end
endmodule