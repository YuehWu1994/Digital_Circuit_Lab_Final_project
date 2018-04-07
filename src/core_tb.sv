`timescale 1ns/100ps

module tb;
	localparam CLK = 10;
	localparam HCLK = CLK/2;

	logic clk, i_rst;
	logic [2:0] u_direction;
	logic [1:0] r_direction;
	logic [3:0] s;
	logic d;
	initial clk = 0;
	always #HCLK clk = ~clk;
	
	Core core (
		.i_clk(clk),
		.i_rst(i_rst),
		.user_direction(u_direction),
		.reset(rst),
		.random_direction(r_direction),
		.size(s),
		.done(d)
	);
	
	initial begin: Control_signal
		$fsdbDumpfile("Core_test.fsdb");
		$fsdbDumpvars;
		i_rst = 0;
		u_direction = 3'b100;
		reset = 0;
		#(1.5*CLK)
		i_rst = 1;
		#(5*CLK)
		u_direction = 3'b000;
		#(6*CLK)
		u_direction = 3'b100;
		#(13*CLK)
		u_direction = 3'b010;
		#(14*CLK)
		u_direction = 3'b100;
	end
endmodule