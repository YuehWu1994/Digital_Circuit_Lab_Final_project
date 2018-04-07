module Wrapper_transfer(
	input [3:0] i_ID1,
	input [3:0] i_ID2,
	input [3:0] i_ID3,
	input [3:0] i_ID4,
	input [3:0] i_size,
	input i_astigmatism_result,
	input i_start_to_send,
	output [3:0] o_ID1,
	output [3:0] o_ID2,
	output [3:0] o_ID3,
	output [3:0] o_ID4,
	output [3:0] o_size,
	output o_astigmatism_result,
	output o_start_to_send 
);
	assign o_ID1 = i_ID1;
	assign o_ID2 = i_ID2;
	assign o_ID3 = i_ID3;
	assign o_ID4 = i_ID4;
	assign o_size = i_size;
	assign o_astigmatism_result = i_astigmatism_result;
	assign o_start_to_send = i_start_to_send;

endmodule
