module Virtual_IR (
	// Input from Top module
	input i_clk,
	input i_rst,
	
	// Input from IR module 
	input i_1,
	input i_2,
	input i_3,
	input i_4,
	input i_5,
	input i_6,
	input i_7,
	input i_8,
	input i_9,
	input i_0,
	input i_A,
	input i_B,
	input i_reset_sw,
	
	// Input from Core
	input i_finish,
	
	// Output to Core module
	output o_rst,
	output [2:0] o_direction,
	output [1:0] YesOrNo_to_core,
	
	// Output to VGA and RS232 module
	output [3:0] o_ID1,
	output [3:0] o_ID2,
	output [3:0] o_ID3,
	output [3:0] o_ID4
);
logic [3:0] state_r, state_w;
logic [2:0] o_direction_r, o_direction_w;
logic       o_rst_r, o_rst_w;
logic [1:0] o_yesno_r, o_yesno_w;
logic [3:0] num1_r, num1_w, num2_r, num2_w, num3_r, num3_w, num4_r, num4_w;

localparam INPUT_ID1   = 0;
localparam INPUT_ID2   = 1;
localparam INPUT_ID3   = 2;
localparam INPUT_ID4   = 3;
localparam WAIT_YES    = 4;
localparam NO_SIGNAL   = 5;
localparam UP          = 6;
localparam DOWN        = 7;
localparam LEFT        = 8;
localparam RIGHT       = 9;
localparam YES         = 10;
localparam NO          = 11;


assign o_direction = o_direction_r;
assign o_rst = o_rst_r;
assign YesOrNo_to_core = o_yesno_r;
assign o_ID1 = num1_r;
assign o_ID2 = num2_r;
assign o_ID3 = num3_r;
assign o_ID4 = num4_r;

always_comb begin

	case(state_r)
		INPUT_ID1: begin
			if(i_1 == 1) begin
				state_w = INPUT_ID2;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = 4'b0001;
				num2_w = 4'b0000;
				num3_w = 4'b0000;
				num4_w = 4'b0000;
			end
			
			else if(i_2 == 1) begin
				state_w = INPUT_ID2;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = 4'b0010;
				num2_w = 4'b0000;
				num3_w = 4'b0000;
				num4_w = 4'b0000;
			end
			
			else if(i_3 == 1) begin
				state_w = INPUT_ID2;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = 4'b0011;
				num2_w = 4'b0000;
				num3_w = 4'b0000;
				num4_w = 4'b0000;
			end
			
			else if(i_4 == 1) begin
				state_w = INPUT_ID2;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = 4'b0100;
				num2_w = 4'b0000;
				num3_w = 4'b0000;
				num4_w = 4'b0000;
			end
			
			else if(i_5 == 1) begin
				state_w = INPUT_ID2;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = 4'b0101;
				num2_w = 4'b0000;
				num3_w = 4'b0000;
				num4_w = 4'b0000;
			end
			
			else if(i_6 == 1) begin
				state_w = INPUT_ID2;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = 4'b0110;
				num2_w = 4'b0000;
				num3_w = 4'b0000;
				num4_w = 4'b0000;
			end
			
			else if(i_7 == 1) begin
				state_w = INPUT_ID2;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = 4'b0111;
				num2_w = 4'b0000;
				num3_w = 4'b0000;
				num4_w = 4'b0000;
			end
			
			else if(i_8 == 1) begin
				state_w = INPUT_ID2;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = 4'b1000;
				num2_w = 4'b0000;
				num3_w = 4'b0000;
				num4_w = 4'b0000;
			end
			
			else if(i_9 == 1) begin
				state_w = INPUT_ID2;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = 4'b1001;
				num2_w = 4'b0000;
				num3_w = 4'b0000;
				num4_w = 4'b0000;
			end
			
			else if(i_0 == 1) begin
				state_w = INPUT_ID2;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = 4'b1010;
				num2_w = 4'b0000;
				num3_w = 4'b0000;
				num4_w = 4'b0000;
			end
			
			else if(i_reset_sw == 1) begin
				state_w = INPUT_ID1;
				o_direction_w = 3'b100;
				o_rst_w = 1;
				o_yesno_w = 2'b00;
				num1_w = 4'b0000;
				num2_w = 4'b0000;
				num3_w = 4'b0000;
				num4_w = 4'b0000;
			end
			
			else begin
				state_w = state_r;
				o_direction_w = o_direction_r;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = num3_r;
				num4_w = num4_r;
			end
		end
		
		INPUT_ID2: begin
			if(i_1 == 1) begin
				state_w = INPUT_ID3;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = 4'b0001;
				num3_w = 4'b0000;
				num4_w = 4'b0000;
			end
			
			else if(i_2 == 1) begin
				state_w = INPUT_ID3;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = 4'b0010;
				num3_w = 4'b0000;
				num4_w = 4'b0000;
			end
			
			else if(i_3 == 1) begin
				state_w = INPUT_ID3;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = 4'b0011;
				num3_w = 4'b0000;
				num4_w = 4'b0000;
			end
			
			else if(i_4 == 1) begin
				state_w = INPUT_ID3;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = 4'b0100;
				num3_w = 4'b0000;
				num4_w = 4'b0000;
			end
			
			else if(i_5 == 1) begin
				state_w = INPUT_ID3;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = 4'b0101;
				num3_w = 4'b0000;
				num4_w = 4'b0000;
			end
			
			else if(i_6 == 1) begin
				state_w = INPUT_ID3;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = 4'b0110;
				num3_w = 4'b0000;
				num4_w = 4'b0000;
			end
			
			else if(i_7 == 1) begin
				state_w = INPUT_ID3;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = 4'b0111;
				num3_w = 4'b0000;
				num4_w = 4'b0000;
			end
			
			else if(i_8 == 1) begin
				state_w = INPUT_ID3;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = 4'b1000;
				num3_w = 4'b0000;
				num4_w = 4'b0000;
			end
			
			else if(i_9 == 1) begin
				state_w = INPUT_ID3;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = 4'b1001;
				num3_w = 4'b0000;
				num4_w = 4'b0000;
			end
			
			else if(i_0 == 1) begin
				state_w = INPUT_ID3;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = 4'b1010;
				num3_w = 4'b0000;
				num4_w = 4'b0000;
			end
			
			else if(i_reset_sw == 1) begin
				state_w = INPUT_ID1;
				o_direction_w = 3'b100;
				o_rst_w = 1;
				o_yesno_w = 2'b00;
				num1_w = 4'b0000;
				num2_w = 4'b0000;
				num3_w = 4'b0000;
				num4_w = 4'b0000;
			end
			
			else begin
				state_w = state_r;
				o_direction_w = o_direction_r;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = num3_r;
				num4_w = num4_r;
			end
		end
		
		INPUT_ID3: begin
			if(i_1 == 1) begin
				state_w = INPUT_ID4;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = 4'b0001;
				num4_w = 4'b0000;
			end
			
			else if(i_2 == 1) begin
				state_w = INPUT_ID4;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = 4'b0010;
				num4_w = 4'b0000;
			end
			
			else if(i_3 == 1) begin
				state_w = INPUT_ID4;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = 4'b0011;
				num4_w = 4'b0000;
			end
			
			else if(i_4 == 1) begin
				state_w = INPUT_ID4;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = 4'b0100;
				num4_w = 4'b0000;
			end
			
			else if(i_5 == 1) begin
				state_w = INPUT_ID4;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = 4'b0101;
				num4_w = 4'b0000;
			end
			
			else if(i_6 == 1) begin
				state_w = INPUT_ID4;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = 4'b0110;
				num4_w = 4'b0000;
			end
			
			else if(i_7 == 1) begin
				state_w = INPUT_ID4;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = 4'b0111;
				num4_w = 4'b0000;
			end
			
			else if(i_8 == 1) begin
				state_w = INPUT_ID4;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = 4'b1000;
				num4_w = 4'b0000;
			end
			
			else if(i_9 == 1) begin
				state_w = INPUT_ID4;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = 4'b1001;
				num4_w = 4'b0000;
			end
			
			else if(i_0 == 1) begin
				state_w = INPUT_ID4;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = 4'b1010;
				num4_w = 4'b0000;
			end
			
			else if(i_reset_sw == 1) begin
				state_w = INPUT_ID1;
				o_direction_w = 3'b100;
				o_rst_w = 1;
				o_yesno_w = 2'b00;
				num1_w = 4'b0000;
				num2_w = 4'b0000;
				num3_w = 4'b0000;
				num4_w = 4'b0000;
			end
			
			else begin
				state_w = state_r;
				o_direction_w = o_direction_r;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = num3_r;
				num4_w = num4_r;
			end		
		end
		
		INPUT_ID4: begin
			if(i_1 == 1) begin
				state_w = WAIT_YES;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = num3_r;
				num4_w = 4'b0001;
			end
			
			else if(i_2 == 1) begin
				state_w = WAIT_YES;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = num3_r;
				num4_w = 4'b0010;
			end
			
			else if(i_3 == 1) begin
				state_w = WAIT_YES;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = num3_r;
				num4_w = 4'b0011;
			end
			
			else if(i_4 == 1) begin
				state_w = WAIT_YES;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = num3_r;
				num4_w = 4'b0100;
			end
			
			else if(i_5 == 1) begin
				state_w = WAIT_YES;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = num3_r;
				num4_w = 4'b0101;
			end
			
			else if(i_6 == 1) begin
				state_w = WAIT_YES;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = num3_r;
				num4_w = 4'b0110;
			end
			
			else if(i_7 == 1) begin
				state_w = WAIT_YES;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = num3_r;
				num4_w = 4'b0111;
			end
			
			else if(i_8 == 1) begin
				state_w = WAIT_YES;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = num3_r;
				num4_w = 4'b1000;
			end
			
			else if(i_9 == 1) begin
				state_w = WAIT_YES;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = num3_r;
				num4_w = 4'b1001;
			end
			
			else if(i_0 == 1) begin
				state_w = WAIT_YES;
				o_direction_w = 3'b100;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = num3_r;
				num4_w = 4'b1010;
			end
			
			else if(i_reset_sw == 1) begin
				state_w = INPUT_ID1;
				o_direction_w = 3'b100;;
				o_rst_w = 1;
				o_yesno_w = 2'b00;
				num1_w = 4'b0000;
				num2_w = 4'b0000;
				num3_w = 4'b0000;
				num4_w = 4'b0000;
			end
			
			else begin
				state_w = state_r;
				o_direction_w = o_direction_r;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = num3_r;
				num4_w = num4_r;
			end
		end
		
		WAIT_YES: begin
			if(i_A == 1) begin
				state_w = NO_SIGNAL;
				o_direction_w = o_direction_r;
				o_rst_w = 0;
				o_yesno_w = 2'b10;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = num3_r;
				num4_w = num4_r;
			end
			
			else if(i_reset_sw == 1) begin
				state_w = INPUT_ID1;
				o_direction_w = o_direction_r;
				o_rst_w = 1;
				o_yesno_w = 2'b00;
				num1_w = 4'b0000;
				num2_w = 4'b0000;
				num3_w = 4'b0000;
				num4_w = 4'b0000;
			end
			
			else begin
				state_w = state_r;
				o_direction_w = o_direction_r;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = num3_r;
				num4_w = num4_r;
			end
		end
		
		NO_SIGNAL: begin
			if(i_2 == 1 && i_finish == 0) begin
				state_w = UP;
				o_direction_w = 3'b000;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = num3_r;
				num4_w = num4_r;
			end

			else if(i_8 == 1 && i_finish == 0) begin
				state_w = DOWN;
				o_direction_w = 3'b001;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = num3_r;
				num4_w = num4_r;
			end

			else if(i_4 == 1 && i_finish == 0) begin
				state_w = LEFT;
				o_direction_w = 3'b010;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = num3_r;
				num4_w = num4_r;
			end

			else if(i_6 == 1 && i_finish == 0) begin
				state_w = RIGHT;
				o_direction_w = 3'b011;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = num3_r;
				num4_w = num4_r;
			end

			else if(i_A == 1 && i_finish == 0) begin
				state_w = YES;
				o_direction_w = o_direction_r;
				o_rst_w = 0;
				o_yesno_w = 2'b10;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = num3_r;
				num4_w = num4_r;
			end
			
			else if(i_B == 1 && i_finish == 0) begin
				state_w = NO;
				o_direction_w = o_direction_r;
				o_rst_w = 0;
				o_yesno_w = 2'b01;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = num3_r;
				num4_w = num4_r;
			end
			
			else if(i_reset_sw == 1 && i_finish == 0) begin
				state_w = NO_SIGNAL;
				o_direction_w = 3'b100;
				o_rst_w = 1;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = num3_r;
				num4_w = num4_r;
			end
			
			else if(i_reset_sw == 1 && i_finish == 1) begin
				state_w = INPUT_ID1;
				o_direction_w = 3'b100;
				o_rst_w = 1;
				o_yesno_w = 2'b00;
				num1_w = 4'b0000;
				num2_w = 4'b0000;
				num3_w = 4'b0000;
				num4_w = 4'b0000;
			end

			else begin
				state_w = state_r;
				o_direction_w = o_direction_r;
				o_rst_w = 0;
				o_yesno_w = 2'b00;
				num1_w = num1_r;
				num2_w = num2_r;
				num3_w = num3_r;
				num4_w = num4_r;
			end
		end

		UP: begin
			state_w = NO_SIGNAL;
			o_direction_w = 3'b100;
			o_rst_w = 0;
			o_yesno_w = 2'b00;
			num1_w = num1_r;
			num2_w = num2_r;
			num3_w = num3_r;
			num4_w = num4_r;
		end
		
		DOWN:  begin
			state_w = NO_SIGNAL;
			o_direction_w = 3'b100;
			o_rst_w = 0;
			o_yesno_w = 2'b00;
			num1_w = num1_r;
			num2_w = num2_r;
			num3_w = num3_r;
			num4_w = num4_r;
		end
			
		LEFT:  begin
			state_w = NO_SIGNAL;
			o_direction_w = 3'b100;
			o_rst_w = 0;
			o_yesno_w = 2'b00;
			num1_w = num1_r;
			num2_w = num2_r;
			num3_w = num3_r;
			num4_w = num4_r;
		end
			
		RIGHT:  begin
			state_w = NO_SIGNAL;
			o_direction_w = 3'b100;
			o_rst_w = 0;
			o_yesno_w = 2'b00;
			num1_w = num1_r;
			num2_w = num2_r;
			num3_w = num3_r;
			num4_w = num4_r;
		end
		
		YES: begin
			state_w = NO_SIGNAL;
			o_direction_w = 3'b100;
			o_rst_w = 0;
			o_yesno_w = 2'b00;
			num1_w = num1_r;
			num2_w = num2_r;
			num3_w = num3_r;
			num4_w = num4_r;
		end
		
		NO: begin
			state_w = NO_SIGNAL;
			o_direction_w = 3'b100;
			o_rst_w = 0;
			o_yesno_w = 2'b00;
			num1_w = num1_r;
			num2_w = num2_r;
			num3_w = num3_r;
			num4_w = num4_r;
		end

		default: begin
			state_w = state_r;
			o_direction_w = o_direction_r;
			o_rst_w = o_rst_r;
			o_yesno_w = o_yesno_r;
			num1_w = num1_r;
			num2_w = num2_r;
			num3_w = num3_r;
			num4_w = num4_r;
		end


	endcase

end

always_ff @(posedge i_clk or negedge i_rst) begin
	if (!i_rst) begin
		state_r <= INPUT_ID1;
		o_direction_r <= 3'b100;
		o_rst_r <= 0;
		o_yesno_r <= 1'b00;
		num1_r <= 4'b0000;
		num2_r <= 4'b0000;
		num3_r <= 4'b0000;
		num4_r <= 4'b0000;
	end

	else begin
		state_r <= state_w;
		o_direction_r <= o_direction_w;
		o_rst_r <= o_rst_w;
		o_yesno_r <= o_yesno_w;
		num1_r <= num1_w;
		num2_r <= num2_w;
		num3_r <= num3_w;
		num4_r <= num4_w;
	end

end


endmodule