module SevenDecDecoder(
	input [2:0] i_dec,
	input i_rst,
	input i_clk,
	output [6:0] o_seven
);
	/* The layout of seven segment display, 1: dark
	 *    00
	 *   5  1
	 *    66
	 *   4  2
	 *    33
	 */
	parameter D0 = 7'b1000000;
	parameter D1 = 7'b1111001;
	parameter D2 = 7'b0100100;
	parameter D3 = 7'b0110000;
	parameter D4 = 7'b0011001;
	parameter D5 = 7'b0010010;
	parameter D6 = 7'b0000010;
	parameter D7 = 7'b1011000;
	parameter D8 = 7'b0000000;
	parameter D9 = 7'b0010000;
   parameter D_OFF = 7'b0000000;

 //   localparam UP = 0;
 //  localparam DOWN = 1;
 //   localparam LEFT = 2;
//    localparam RIGHT = 3;

 //   logic [6:0]  o_seven_r, o_seven_w;
 //   logic [1:0] state_r, state_w;
	 
//    assign o_seven = o_seven_r;

	always_comb begin
//		state_w = state_r;
		case (i_dec)
					3'd0: o_seven = D0;
					3'd1: o_seven = D1;
					3'd2: o_seven = D2;
					3'd3: o_seven = D3;
					default: o_seven = D4;
			endcase
	end

	/*

	always_ff @(posedge i_clk or negedge i_rst) begin
	if (!i_rst) begin
		state_r <= UP;
		o_seven_r <= D0;
	end
	else 
		state_r <= state_w;
		o_seven_r <= o_seven_w;
	end
*/
endmodule


/*
		counter_w = counter_r;
		o_seven_w = o_seven_r;
		o_seven_buffer_w = o_seven_buffer_r;


				counter_w = counter_r;
		o_seven_w = o_seven_r;
		o_seven_buffer_w = o_seven_buffer_r;

		if (o_seven_buffer_r != o_seven_r) begin
			counter_w = 0;
			o_seven_w = o_seven_buffer_r;
		end

		else if(counter_r == 1000000000)
			o_seven_w = o_seven_buffer_r;
			case(i_dec)
				3'd0: o_seven_buffer_w = D0;
				3'd1: o_seven_buffer_w = D1;
				3'd2: o_seven_buffer_w = D2;
				3'd3: o_seven_buffer_w = D3;
				3'd4: o_seven_buffer_w = D4;
				3'd5: o_seven_buffer_w = D5;
				3'd6: o_seven_buffer_w = D6;
				3'd7: o_seven_buffer_w = D7;
				3'd8: o_seven_buffer_w = D8;
				3'd9: o_seven_buffer_w = D9;
            default: o_seven_buffer_w = D_OFF;
		endcase

		else begin
			counter_w = counter_r + 1;
		end
*/

