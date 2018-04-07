module Core (
	// Input from IR module
	input	i_clk,
	input	i_rst,
	input  [2:0] user_direction,
	input	reset,
	input  [1:0] Yes_or_no,
	
	// Output to IR virtual IR
	output finish,

	// Output to VGA module
	output [1:0] random_direction,
	output [3:0] o_size,
	output	done,
	output [2:0] state_to_VGA,
	output  astigmatism_result,
	output  color_test_result,

	// Output to RS232
	output start_to_send
);
logic [3:0] state_w, state_r;
logic [1:0] random_direction_w, random_direction_r;
logic [1:0] counter_w, counter_r;
logic [3:0] size_w, size_r;
logic done_w, done_r, astigmatism_w, astigmatism_r, color_test_w, color_test_r;

localparam s_user_id = 6;
localparam start = 0;
localparam O = 1;
localparam X = 2;
localparam OO = 3;
localparam XO = 4;
localparam XX = 5;
localparam astigmatism_test = 7;
localparam s_astigmatism_result = 8;
localparam color_test = 9;
localparam final_result = 10;

localparam up = 3'b000;
localparam down = 3'b001;
localparam left = 3'b010;
localparam right = 3'b011;
localparam No_signal = 3'b100;

assign random_direction = random_direction_r;
assign o_size = size_r;
assign done = done_r;
assign degree_of_sight = size_r;
assign astigmatism_result = astigmatism_r;
assign astigmatism = astigmatism_r;
assign color_test_result = color_test_r;

always begin
	
	size_w = size_r;
	astigmatism_w = astigmatism_r;
	color_test_w = color_test_r;
	// State transition
	case (state_r) 
		s_user_id : begin
			if (Yes_or_no == 2'b10) begin
				state_w = start;
			end
			else begin
				state_w = state_r;
			end
		end
		
		start : begin
			if (reset == 1) begin
				state_w = state_r;
			end
			else if (user_direction == No_signal) begin
				state_w = state_r;
				random_direction_w = random_direction_r;
			end
			else if (user_direction[1:0] == random_direction_r) begin
				state_w = O;
				random_direction_w = counter_r;
			end	
			else begin
				state_w = X;
				random_direction_w = counter_r;
			end
		end
		
		O : begin
			if (reset == 1) begin
				state_w = start;
			end
			else if (user_direction == No_signal) begin
				state_w = state_r;
				random_direction_w = random_direction_r;
			end
			else if (user_direction[1:0] == random_direction_r) begin
				state_w = OO;
				size_w = size_r + 1;
				random_direction_w = counter_r;
			end
			else begin
				state_w = X;
				random_direction_w = counter_r;
			end
		end
		
		X : begin
			if (reset == 1) begin
				state_w = start;
			end
			else if (user_direction == No_signal) begin
				state_w = state_r;
				random_direction_w = random_direction_r;
			end
			else if (user_direction[1:0] == random_direction_r) begin
				state_w = XO;
				random_direction_w = counter_r;
			end
			else begin
				state_w = XX;
				if (size_r != 4'b0000)
					size_w = size_r - 1;
				else
					size_w = size_r;
				random_direction_w = counter_r;
			end
		end
		
		OO : begin
			if (reset == 1) begin
				state_w = start;
			end
			else if (size_r == 4'b1100) begin
				state_w = XX;
			end
			else if (user_direction == No_signal) begin
				state_w = state_r;
				random_direction_w = random_direction_r;
			end
			else if (user_direction[1:0] == random_direction_r) begin
				state_w = O;
				random_direction_w = counter_r;
			end
			else begin
				state_w = X;
				random_direction_w = counter_r;
			end
		end
		
		XO : begin
			if (reset == 1) begin
				state_w = start;
			end
			else if (user_direction == No_signal) begin
				state_w = state_r;
				random_direction_w = random_direction_r;
			end
			else if (user_direction[1:0] == random_direction_r) begin
				state_w = OO;
				size_w = size_r + 1;
				random_direction_w = counter_r;
			end
			else begin
				state_w = XX;
				random_direction_w = counter_r;
				if (size_r != 4'b0000)
					size_w = size_r - 1;
				else
					size_w = size_r;
			end
		end
		
		XX : begin
			if (reset == 1)
				state_w = start;
			else if (Yes_or_no == 2'b10)
				state_w = astigmatism_test;
			else
				state_w = state_r;
		end
		
		astigmatism_test : begin
			if (Yes_or_no != 2'b00)
				state_w = s_astigmatism_result;
			else
				state_w = state_r;
		end
		
		s_astigmatism_result : begin
			if (Yes_or_no != 2'b00)
				state_w = color_test;
			else
				state_w = state_r;
		end
		
		color_test : begin
			if (Yes_or_no != 2'b00)
				state_w = final_result;
			else
				state_w = state_r;
		end
		
		final_result : begin
			if (reset == 1)
				state_w = s_user_id;
			else
				state_w = state_r;
		end
		
	endcase
	
	// To do in each state_r
	
    // Independent of state transition
	finish = 0;
	if (counter_r == 2'b11)
		counter_w = 0;
	else
		counter_w = counter_r + 1;
		
	if (state_r == s_user_id) begin
		done_w = done_r;
		state_to_VGA = 3'b000;
		astigmatism_w = 0;
		start_to_send = 0;
		color_test_w = 0;
	end
	else if (state_r == start) begin
		size_w = 4'b0000;
		done_w = 0;
		state_to_VGA = 3'b001;
		start_to_send = 0;
	end
	else if (state_r == O) begin
		done_w = done_r;
		state_to_VGA = 3'b001;
		start_to_send = 0;
	end
	else if (state_r == X) begin
		done_w = done_r;
		state_to_VGA = 3'b001;
		start_to_send = 0;
	end
	else if (state_r == OO) begin
		start_to_send = 0;
		state_to_VGA = 3'b001;
		if (size_r == 4'b1100) begin
			done_w = 1;
		end
		else begin
			done_w = done_r;
		end
	end
	else if (state_r == XO) begin
		start_to_send = 0;
		done_w = done_r;
		state_to_VGA = 3'b001;
	end
	else if (state_r == XX) begin
		start_to_send = 0;
		state_to_VGA = 3'b001;
		done_w = 1;
	end
	else if (state_r == astigmatism_test) begin
		state_to_VGA = 3'b010;
		start_to_send = 0;
		done_w = done_r;
		if (Yes_or_no == 2'b10) 
			astigmatism_w = 1;
		else
			astigmatism_w = 0;
	end
	else if (state_r == s_astigmatism_result)begin
		state_to_VGA = 3'b011;
		start_to_send = 0;
		done_w = done_r;
	end
	else if (state_r == color_test)begin
		state_to_VGA = 3'b100;
		start_to_send = 0;
		done_w = done_r;
		if (Yes_or_no == 2'b10)
			color_test_w = 1;
		else
			color_test_w = 0;
	end
	else begin
		state_to_VGA = 3'b101;
		finish = 1;
		start_to_send = 1;
		done_w = done_r;
	end
end

always_ff @(posedge i_clk or negedge i_rst) begin
	if (!i_rst) begin
		state_r <= s_user_id;
		random_direction_r <= 2'b00;
		size_r <= 4'b0000;
		counter_r <= 2'b00;
		done_r <= 0;
		astigmatism_r <= 0;
		color_test_r <= 0;
	end
	else begin
		state_r <= state_w;
		random_direction_r <= random_direction_w;
		size_r <= size_w;
		counter_r <= counter_w;
		done_r <= done_w;
		astigmatism_r <= astigmatism_w;
		color_test_r <= color_test_w;
	end
end
endmodule
