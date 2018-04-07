`timescale 1ns/100ps

module tb();

	localparam CLK = 10;
	localparam HCLK = CLK/2;

	logic rst;
	logic clk;

	initial clk = 0;
	always #HCLK clk = ~clk;

	logic [2:0] user_direction;
	logic reset;
	logic [1:0] r_direction;
	logic [3:0] o_size;
	logic done;


	Core core (
		.i_clk(clk),
		.i_rst(rst),
		.user_direction(user_direction),
		.reset(reset),
		.random_direction(r_direction),
		.o_size(o_size),
		.done(done)
	);

// 沒有訊號真的是"沒有訊號"嗎？
	initial begin 
	    $fsdbDumpfile("core_test.fsdb");
     	$fsdbDumpvars; 
     	rst = 0;
     	reset = 0;
		user_direction = 3'b100;
     	#(0.5*CLK) 
     	rst = 1;
     	#(CLK)
     	user_direction = 3'b000; // state change to O, random direction change to 1 (down)
		#(CLK)
		user_direction = 3'b100;
		#(CLK)
		user_direction = 3'b100;
		#(CLK)
		user_direction = 3'b100;
     	#(CLK)
     	user_direction = 3'b010; // state change to X, random direction change to 2 (left) */
		#(CLK)
		user_direction = 3'b100;
		#(10*CLK)
     	$display("DONE");
     	$finish;
    end


// 根本不會到 finish
// counter 是不是不會歸零
    endmodule
