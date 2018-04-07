module VGA_SHOW_E (
	input i_clk,
	input i_rst,
	input [11:0] x,
	input [11:0] y,
	//  signal from core
	input [3:0] i_size,
	input [1:0] i_direction,
	input i_done,
	input [2:0] i_state,
	input astigmatism_or_not,
	input color_test_result,
	//  signal from IR
	input [3:0] i_ID_0,
	input [3:0] i_ID_1,
	input [3:0] i_ID_2,
	input [3:0] i_ID_3,
	output o_e_chart_color
);
// vision degree
localparam ZERO_ONE = 0;
localparam ZERO_TWO = 1;
localparam ZERO_THREE = 2;
localparam ZERO_FOUR = 3;
localparam ZERO_FIVE = 4;
localparam ZERO_SIX = 5;
localparam ZERO_SEVEN = 6;
localparam ZERO_EIGHT = 7;
localparam ZERO_NINE = 8;
localparam ONE_ZERO = 9;
localparam ONE_TWO = 10;
localparam ONE_FIVE = 11;
localparam TWO_ZERO = 12;

// vision direction
localparam UP = 0;
localparam DOWN = 1;
localparam LEFT = 2;
localparam RIGHT = 3;

// state
localparam USER_ID = 0;
localparam VISION = 1;
localparam ASTIGMATISM = 2;
localparam ASTIG_DETECT = 3;
localparam COLOR_BLIND_DETECT = 5;

// id number
localparam ZERO = 10;
localparam ONE = 1;
localparam TWO = 2;
localparam THREE = 3;
localparam FOUR = 4;
localparam FIVE = 5;
localparam SIX = 6;
localparam SEVEN = 7;
localparam EIGHT = 8;
localparam NINE = 9;



logic  o_e_chart_color_r, o_e_chart_color_w;


assign o_e_chart_color = o_e_chart_color_r;

task point_up;
	input [6:0] weight;
	input [4:0] string_up;
	input [4:0] string_middle;
	input [4:0] string_down;
	input [4:0] interval;
	input [11:0] translator_x;
	input [11:0] translator_y;

	if(x >= translator_x && x <= (translator_x + weight) &&  y>= translator_y && y <= (translator_y + weight)) begin
		if(((x >= (translator_x + string_up) && x <= (translator_x + string_up + interval)) || (x >= (translator_x + weight - string_down - interval) && x <= (translator_x + weight - string_down))) && y <= (translator_y + weight - string_up))
			o_e_chart_color_w = 1;
		else 
			o_e_chart_color_w = 0;		
	end

	else 
		o_e_chart_color_w = 1;	 
endtask

task point_down;
	input [6:0] weight;
	input [4:0] string_up;
	input [4:0] string_middle;
	input [4:0] string_down;
	input [4:0] interval;
	input [11:0] translator_x;
	input [11:0] translator_y;

	if(x >= translator_x && x <= (translator_x + weight) &&  y>= translator_y && y <= (translator_y + weight)) begin
		if(((x >= (translator_x + string_up) && x <= (translator_x + string_up + interval)) || (x >= (translator_x + weight - string_down - interval) && x <= (translator_x + weight - string_down))) && y >= (translator_y + string_up))
			o_e_chart_color_w = 1;
		else
			o_e_chart_color_w = 0;
	end

	else 
		o_e_chart_color_w = 1;	

endtask

task point_left;
	input [6:0] weight;
	input [4:0] string_up;
	input [4:0] string_middle;
	input [4:0] string_down;
	input [4:0] interval;
	input [11:0] translator_x;
	input [11:0] translator_y;

	if(x >= translator_x && x <= (translator_x + weight) &&  y>= translator_y && y <= (translator_y + weight)) begin
		if(((y >= (translator_y + string_up) && y <= (translator_y + string_up + interval)) || (y >= (translator_y + weight - string_down - interval) && y <= (translator_y + weight - string_down))) && x <= (translator_x + weight - string_up))
			o_e_chart_color_w = 1;
		else
			o_e_chart_color_w = 0;	
	end

	else 
		o_e_chart_color_w = 1;	

endtask

task point_right;
	input [6:0] weight;
	input [4:0] string_up;
	input [4:0] string_middle;
	input [4:0] string_down;
	input [4:0] interval;
	input [11:0] translator_x;
	input [11:0] translator_y;

	if(x >= translator_x && x <= (translator_x + weight) &&  y>= translator_y && y <= (translator_y + weight)) begin
		if(((y >= (translator_y + string_up) && y <= (translator_y + string_up + interval)) || (y >= (translator_y + weight - string_down - interval) && y <= (translator_y + weight - string_down))) && x >= (translator_x + string_up))
			o_e_chart_color_w = 1;
		else
			o_e_chart_color_w = 0;	
	end

	else 
		o_e_chart_color_w = 1;	

endtask							//   0		  7
								//   __		  __
								// 1|__|2  8 |__| 9	
								// 4|__|5  11|__| 12
								//   3 6  14* 10 13

task user_id_number;
	input [3:0] id;
	input [11:0] translator_x;
	// 401 451 501 551

	case(id)
		ZERO: begin	
			if(x >= (translator_x + 6) && x <= (translator_x + 33) && y >= 207 && y <= 274)
				o_e_chart_color_w = 1;
			else
				o_e_chart_color_w = 0;
		end

		ONE: begin
			if(x >= (translator_x + 17) && x <= (translator_x + 22))
				o_e_chart_color_w = 0;
			else
				o_e_chart_color_w = 1;
		end

		TWO: begin
			if((y >= 207 && y <= 237 && x <= (translator_x + 33)) || (y >= 244 && y <= 274 && x >= (translator_x + 6)))
				o_e_chart_color_w = 1;
			else 
				o_e_chart_color_w = 0;
		end

		THREE: begin
			if(((y >= 207 && y <= 237) || (y >= 244 && y <= 274)) && x <= (translator_x + 33))
				o_e_chart_color_w = 1;
			else 
				o_e_chart_color_w = 0;
		end

		FOUR: begin
			if(y >= 221 && x >= (translator_x + 17) && x <= (translator_x + 22))
				o_e_chart_color_w = 0;
			else if( y <= 243 && x <= (translator_x + 5))
				o_e_chart_color_w = 0;
			else if(((x >= (translator_x + 6) && x <= (translator_x + 21)) || (x >= (translator_x + 23))) && y <= 243 && y >= 238)
				o_e_chart_color_w = 0;
			else 
				o_e_chart_color_w = 1;
		end

		FIVE: begin 
			if((y >= 207 && y <= 237 && x >= (translator_x + 6)) || (y >= 244 && y <= 274 && x <= (translator_x + 33)))
				o_e_chart_color_w = 1;
			else 
				o_e_chart_color_w = 0;
		end

		SIX: begin
			if(y >= 207 && y <= 237 && x >= (translator_x + 6))
				o_e_chart_color_w = 1;
			else if (x >= (translator_x + 6) && x <= (translator_x + 33) && y >= 244 && y <= 274)
				o_e_chart_color_w = 1;
			else
				o_e_chart_color_w = 0;
		end

		SEVEN: begin 
			if(y <= 206 || (y >= 207 && x >= (translator_x + 34)))
				o_e_chart_color_w = 0;
			else
				o_e_chart_color_w = 1;
		end

		EIGHT: begin
			if (x >= (translator_x + 6) && x <= (translator_x + 33) && ((y >= 244 && y <= 274) || (y >= 207 && y <= 237)))
				o_e_chart_color_w = 1;
			else
				o_e_chart_color_w = 0; 
		end

		NINE: begin
			if(y >= 244 && y <= 274 && x <= (translator_x + 33))
				o_e_chart_color_w = 1;
			else if(y >= 207 && y <= 237 && x >= (translator_x + 6) && x <= (translator_x + 33))
				o_e_chart_color_w = 1;
			else 
				o_e_chart_color_w = 0;
		end

	endcase 
endtask



task show_0_1;
	if(x > 200 && x <= 300 && y > 140 && y <= 146)     //0
		o_e_chart_color_w = 0;
	else if(x > 200 && x <= 206 && y > 146 && y <= 237)//1
		o_e_chart_color_w = 0;
	else if(x > 294 && x <= 300 && y > 146 && y <= 237)//2
		o_e_chart_color_w = 0;
	else if(x > 200 && x <= 206 && y > 243 && y <= 334)//4
		o_e_chart_color_w = 0;
	else if(x > 294 && x <= 300 && y > 243 && y <= 334)//5
		o_e_chart_color_w = 0;
	else if(x > 200 && x <= 300 && y > 334 && y <= 340)//6
		o_e_chart_color_w = 0;
	else if(x > 384 && x <= 390 && y > 146 && y <= 237)//9
		o_e_chart_color_w = 0;
	else if(x > 384 && x <= 390 && y > 243 && y <= 334)//12
		o_e_chart_color_w = 0;
	else if(x >= 317 && x <=322 && y > 334 && y <= 340)//14
		o_e_chart_color_w = 0;
	else 
		o_e_chart_color_w = 1;
endtask

task show_0_2;
	if(x > 200 && x <= 300 && y > 140 && y <= 146)     //0
		o_e_chart_color_w = 0;
	else if(x > 200 && x <= 206 && y > 146 && y <= 237)//1
		o_e_chart_color_w = 0;
	else if(x > 294 && x <= 300 && y > 146 && y <= 237)//2
		o_e_chart_color_w = 0;
	else if(x > 200 && x <= 206 && y > 243 && y <= 334)//4
		o_e_chart_color_w = 0;
	else if(x > 294 && x <= 300 && y > 243 && y <= 334)//5
		o_e_chart_color_w = 0;
	else if(x > 200 && x <= 300 && y > 334 && y <= 340)//6
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 440 && y > 140 && y <= 146)//7
		o_e_chart_color_w = 0;
	else if(x > 434 && x <= 440 && y > 146 && y <= 237)//9
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 440 && y > 237 && y <= 243)//10
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 346 && y > 243 && y <= 334)//11
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 440 && y > 334 && y <= 340)//13
		o_e_chart_color_w = 0;
	else if(x >= 317 && x <=322 && y > 334 && y <= 340)//14
		o_e_chart_color_w = 0;
	else 
		o_e_chart_color_w = 1;
endtask

task show_0_3;
	if(x > 200 && x <= 300 && y > 140 && y <= 146)     //0
		o_e_chart_color_w = 0;
	else if(x > 200 && x <= 206 && y > 146 && y <= 237)//1
		o_e_chart_color_w = 0;
	else if(x > 294 && x <= 300 && y > 146 && y <= 237)//2
		o_e_chart_color_w = 0;
	else if(x > 200 && x <= 206 && y > 243 && y <= 334)//4
		o_e_chart_color_w = 0;
	else if(x > 294 && x <= 300 && y > 243 && y <= 334)//5
		o_e_chart_color_w = 0;
	else if(x > 200 && x <= 300 && y > 334 && y <= 340)//6
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 440 && y > 140 && y <= 146)//7
		o_e_chart_color_w = 0;
	else if(x > 434 && x <= 440 && y > 146 && y <= 237)//9
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 440 && y > 237 && y <= 243)//10
		o_e_chart_color_w = 0;
	else if(x > 434 && x <= 440 && y > 243 && y <= 334)//12
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 440 && y > 334 && y <= 340)//13
		o_e_chart_color_w = 0;
	else if(x >= 317 && x <=322 && y > 334 && y <= 340)//14
		o_e_chart_color_w = 0;
	else 
		o_e_chart_color_w = 1;
endtask

task show_0_4;
	if(x > 200 && x <= 300 && y > 140 && y <= 146)     //0
		o_e_chart_color_w = 0;
	else if(x > 200 && x <= 206 && y > 146 && y <= 237)//1
		o_e_chart_color_w = 0;
	else if(x > 294 && x <= 300 && y > 146 && y <= 237)//2
		o_e_chart_color_w = 0;
	else if(x > 200 && x <= 206 && y > 243 && y <= 334)//4
		o_e_chart_color_w = 0;
	else if(x > 294 && x <= 300 && y > 243 && y <= 334)//5
		o_e_chart_color_w = 0;
	else if(x > 200 && x <= 300 && y > 334 && y <= 340)//6
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 346 && y > 146 && y <= 237)//8
		o_e_chart_color_w = 0;
	else if(x > 434 && x <= 440 && y > 146 && y <= 237)//9
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 440 && y > 237 && y <= 243)//10
		o_e_chart_color_w = 0;
	else if(x > 434 && x <= 440 && y > 243 && y <= 334)//12
		o_e_chart_color_w = 0;
	else if(x >= 317 && x <=322 && y > 334 && y <= 340)//14
		o_e_chart_color_w = 0;
	else 
		o_e_chart_color_w = 1;
endtask

task show_0_5;
	if(x > 200 && x <= 300 && y > 140 && y <= 146)     //0
		o_e_chart_color_w = 0;
	else if(x > 200 && x <= 206 && y > 146 && y <= 237)//1
		o_e_chart_color_w = 0;
	else if(x > 294 && x <= 300 && y > 146 && y <= 237)//2
		o_e_chart_color_w = 0;
	else if(x > 200 && x <= 206 && y > 243 && y <= 334)//4
		o_e_chart_color_w = 0;
	else if(x > 294 && x <= 300 && y > 243 && y <= 334)//5
		o_e_chart_color_w = 0;
	else if(x > 200 && x <= 300 && y > 334 && y <= 340)//6
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 440 && y > 140 && y <= 146)//7
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 346 && y > 146 && y <= 237)//8
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 440 && y > 237 && y <= 243)//10
		o_e_chart_color_w = 0;
	else if(x > 434 && x <= 440 && y > 243 && y <= 334)//12
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 440 && y > 334 && y <= 340)//13
		o_e_chart_color_w = 0;
	else if(x >= 317 && x <=322 && y > 334 && y <= 340)//14
		o_e_chart_color_w = 0;
	else 
		o_e_chart_color_w = 1;
endtask

task show_0_6;
	if(x > 200 && x <= 300 && y > 140 && y <= 146)     //0
		o_e_chart_color_w = 0;
	else if(x > 200 && x <= 206 && y > 146 && y <= 237)//1
		o_e_chart_color_w = 0;
	else if(x > 294 && x <= 300 && y > 146 && y <= 237)//2
		o_e_chart_color_w = 0;
	else if(x > 200 && x <= 206 && y > 243 && y <= 334)//4
		o_e_chart_color_w = 0;
	else if(x > 294 && x <= 300 && y > 243 && y <= 334)//5
		o_e_chart_color_w = 0;
	else if(x > 200 && x <= 300 && y > 334 && y <= 340)//6
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 440 && y > 140 && y <= 146)//7
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 346 && y > 146 && y <= 237)//8
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 440 && y > 237 && y <= 243)//10
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 346 && y > 243 && y <= 334)//11
		o_e_chart_color_w = 0;
	else if(x > 434 && x <= 440 && y > 243 && y <= 334)//12
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 440 && y > 334 && y <= 340)//13
		o_e_chart_color_w = 0;
	else if(x >= 317 && x <=322 && y > 334 && y <= 340)//14
		o_e_chart_color_w = 0;
	else 
		o_e_chart_color_w = 1;
endtask

task show_0_7;
	if(x > 200 && x <= 300 && y > 140 && y <= 146)     //0
		o_e_chart_color_w = 0;
	else if(x > 200 && x <= 206 && y > 146 && y <= 237)//1
		o_e_chart_color_w = 0;
	else if(x > 294 && x <= 300 && y > 146 && y <= 237)//2
		o_e_chart_color_w = 0;
	else if(x > 200 && x <= 206 && y > 243 && y <= 334)//4
		o_e_chart_color_w = 0;
	else if(x > 294 && x <= 300 && y > 243 && y <= 334)//5
		o_e_chart_color_w = 0;
	else if(x > 200 && x <= 300 && y > 334 && y <= 340)//6
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 440 && y > 140 && y <= 146)//7
		o_e_chart_color_w = 0;
	else if(x > 434 && x <= 440 && y > 146 && y <= 237)//9
		o_e_chart_color_w = 0;
	else if(x > 434 && x <= 440 && y > 243 && y <= 334)//12
		o_e_chart_color_w = 0;
	else if(x >= 317 && x <=322 && y > 334 && y <= 340)//14
		o_e_chart_color_w = 0;
	else 
		o_e_chart_color_w = 1;
endtask

task show_0_8;
	if(x > 200 && x <= 300 && y > 140 && y <= 146)     //0
		o_e_chart_color_w = 0;
	else if(x > 200 && x <= 206 && y > 146 && y <= 237)//1
		o_e_chart_color_w = 0;
	else if(x > 294 && x <= 300 && y > 146 && y <= 237)//2
		o_e_chart_color_w = 0;
	else if(x > 200 && x <= 206 && y > 243 && y <= 334)//4
		o_e_chart_color_w = 0;
	else if(x > 294 && x <= 300 && y > 243 && y <= 334)//5
		o_e_chart_color_w = 0;
	else if(x > 200 && x <= 300 && y > 334 && y <= 340)//6
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 440 && y > 140 && y <= 146)//7
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 346 && y > 146 && y <= 237)//8
		o_e_chart_color_w = 0;
	else if(x > 434 && x <= 440 && y > 146 && y <= 237)//9
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 440 && y > 237 && y <= 243)//10
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 346 && y > 243 && y <= 334)//11
		o_e_chart_color_w = 0;
	else if(x > 434 && x <= 440 && y > 243 && y <= 334)//12
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 440 && y > 334 && y <= 340)//13
		o_e_chart_color_w = 0;
	else if(x >= 317 && x <=322 && y > 334 && y <= 340)//14
		o_e_chart_color_w = 0;
	else 
		o_e_chart_color_w = 1;
endtask

task show_0_9;
	if(x > 200 && x <= 300 && y > 140 && y <= 146)     //0
		o_e_chart_color_w = 0;
	else if(x > 200 && x <= 206 && y > 146 && y <= 237)//1
		o_e_chart_color_w = 0;
	else if(x > 294 && x <= 300 && y > 146 && y <= 237)//2
		o_e_chart_color_w = 0;
	else if(x > 200 && x <= 206 && y > 243 && y <= 334)//4
		o_e_chart_color_w = 0;
	else if(x > 294 && x <= 300 && y > 243 && y <= 334)//5
		o_e_chart_color_w = 0;
	else if(x > 200 && x <= 300 && y > 334 && y <= 340)//6
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 440 && y > 140 && y <= 146)//7
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 346 && y > 146 && y <= 237)//8
		o_e_chart_color_w = 0;
	else if(x > 434 && x <= 440 && y > 146 && y <= 237)//9
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 440 && y > 237 && y <= 243)//10
		o_e_chart_color_w = 0;
	else if(x > 434 && x <= 440 && y > 243 && y <= 334)//12
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 440 && y > 334 && y <= 340)//13
		o_e_chart_color_w = 0;
	else if(x >= 317 && x <=322 && y > 334 && y <= 340)//14
		o_e_chart_color_w = 0;
	else 
		o_e_chart_color_w = 1;
endtask

task show_1_0;
	if(x > 244 && x <= 250 && y > 146 && y <= 237)     //2
		o_e_chart_color_w = 0;
	else if(x > 244 && x <= 250 && y > 243 && y <= 334)//5
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 440 && y > 140 && y <= 146)//7
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 346 && y > 146 && y <= 237)//8
		o_e_chart_color_w = 0;
	else if(x > 434 && x <= 440 && y > 146 && y <= 237)//9
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 346 && y > 243 && y <= 334)//11
		o_e_chart_color_w = 0;
	else if(x > 434 && x <= 440 && y > 243 && y <= 334)//12
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 440 && y > 334 && y <= 340)//13
		o_e_chart_color_w = 0;
	else if(x >= 317 && x <=322 && y > 334 && y <= 340)//14
		o_e_chart_color_w = 0;
	else 
		o_e_chart_color_w = 1;
endtask

task show_1_2;
	if(x > 244 && x <= 250 && y > 146 && y <= 237)     //2
		o_e_chart_color_w = 0;
	else if(x > 244 && x <= 250 && y > 243 && y <= 334)//5
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 440 && y > 140 && y <= 146)//7
		o_e_chart_color_w = 0;
	else if(x > 434 && x <= 440 && y > 146 && y <= 237)//9
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 440 && y > 237 && y <= 243)//10
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 346 && y > 243 && y <= 334)//11
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 440 && y > 334 && y <= 340)//13
		o_e_chart_color_w = 0;
	else if(x >= 317 && x <=322 && y > 334 && y <= 340)//14
		o_e_chart_color_w = 0;
	else 
		o_e_chart_color_w = 1;
endtask

task show_1_5;
	if(x > 244 && x <= 250 && y > 146 && y <= 237)     //2
		o_e_chart_color_w = 0;
	else if(x > 244 && x <= 250 && y > 243 && y <= 334)//5
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 440 && y > 140 && y <= 146)//7
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 346 && y > 146 && y <= 237)//8
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 440 && y > 237 && y <= 243)//10
		o_e_chart_color_w = 0;
	else if(x > 434 && x <= 440 && y > 243 && y <= 334)//12
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 440 && y > 334 && y <= 340)//13
		o_e_chart_color_w = 0;
	else if(x >= 317 && x <=322 && y > 334 && y <= 340)//14
		o_e_chart_color_w = 0;
	else 
		o_e_chart_color_w = 1;
endtask

task show_2_0;
	if(x > 200 && x <= 300 && y > 140 && y <= 146)     //0
		o_e_chart_color_w = 0;
	else if(x > 294 && x <= 300 && y > 146 && y <= 237)//2
		o_e_chart_color_w = 0;
	else if(x > 200 && x <= 300 && y > 237 && y <= 243)//3
		o_e_chart_color_w = 0;
	else if(x > 200 && x <= 206 && y > 243 && y <= 334)//4
		o_e_chart_color_w = 0;
	else if(x > 200 && x <= 300 && y > 334 && y <= 340)//6
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 440 && y > 140 && y <= 146)//7
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 346 && y > 146 && y <= 237)//8
		o_e_chart_color_w = 0;
	else if(x > 434 && x <= 440 && y > 146 && y <= 237)//9
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 346 && y > 243 && y <= 334)//11
		o_e_chart_color_w = 0;
	else if(x > 434 && x <= 440 && y > 243 && y <= 334)//12
		o_e_chart_color_w = 0;
	else if(x > 340 && x <= 440 && y > 334 && y <= 340)//13
		o_e_chart_color_w = 0;
	else if(x >= 317 && x <=322 && y > 334 && y <= 340)//14
		o_e_chart_color_w = 0;
	else 
		o_e_chart_color_w = 1;
endtask


always_comb begin
	o_e_chart_color_w = o_e_chart_color_r;

	case (i_state)
		USER_ID: begin
			// U
			if(((x >= 51 && x <= 56) || (x >= 85 && x <= 90)) && (y >= 201 && y <=274))
				o_e_chart_color_w = 0;
			else if ((y >= 274 && y <=280) && (x >= 51 && x <= 90))
				o_e_chart_color_w = 0;
			// S
			else if((x >= 101 && x <= 140) && (y >= 201 && y <=280)) begin
				if ((x >= 106 && y >= 207 && y <= 237) || (x <= 134 && y >= 244 && y <= 273))
					o_e_chart_color_w = 1;
				else
					o_e_chart_color_w = 0;
			end
			// E
			else if((x >= 151 && x <= 190) && (y >= 201 && y <=280)) begin 
				if (x >= 156 && ((y >= 207 && y <=237) ||(y >= 244 && y <= 273) ))
					o_e_chart_color_w = 1;
				else
					o_e_chart_color_w = 0;
			end
			// R 
			else if((x >= 201 && x <= 206) && (y >= 201 && y <=280))
				o_e_chart_color_w = 0;
			else if((x >= 207 && x <= 240) && (y >= 201 && y <=243)) begin
				if(x <= 234 && y >= 207 && y <=237)
					o_e_chart_color_w = 1;
				else
					o_e_chart_color_w = 0;
			end
			else if((x >= 207 && x <= 240) && (y-x >= 35) && (y-x <= 43)) begin
				if(y <= 280)
					o_e_chart_color_w = 0;
				else 
					o_e_chart_color_w = 1;
			end
			// I
			else if((x >= 261 && x <= 300) && ((y >= 201 && y <=207) || (y >= 274 && y <=280)))
				o_e_chart_color_w = 0;
			else if((x >= 277 && x <= 283) && (y >= 208 && y <=273))
				o_e_chart_color_w = 0;

			// D
			else if((x >= 344 && x <= 350) && (y >= 201 && y <=280))
				o_e_chart_color_w = 0;	

			else if(y >= 237 && y <=280 && x >=311 && x<=344) begin
				if(y >= 243 && y <=274 && x >= 317)
					o_e_chart_color_w = 1;
				else
					o_e_chart_color_w = 0;
			end

			// :
			else if(x >= 372 && x <= 378 && ((y >= 218 && y <= 224) || (y >= 256 && y <= 262)))
				o_e_chart_color_w = 0;

			// _ _ _ _ 
			else if ( y>=201 && y <= 280 && x >= 401 && x <= 590) begin
				if((i_ID_0 >= 1 && i_ID_0 <= 10) && (i_ID_1 == 0 || i_ID_1 >= 11) && (i_ID_2 == 0 || i_ID_2 >= 11) && (i_ID_3 == 0 || i_ID_3 >= 11)) begin

					if(y>=276 && y <= 280 && ((x >= 551 && x <= 590)|| ( x >= 501 && x <= 540 ) || ( x >= 451 && x <= 490 )))
						o_e_chart_color_w = 0;

					else if(y >= 201 && y <= 280 && x >= 401 && x <= 440) 
						user_id_number(i_ID_0, 401);

					else
						o_e_chart_color_w = 1;
					
				end

				else if((i_ID_0 >= 1 && i_ID_0 <= 10) && (i_ID_1 >= 1 && i_ID_1 <= 10) && (i_ID_2 == 0 || i_ID_2 >= 11) && (i_ID_3 == 0 || i_ID_3 >= 11)) begin

					if(y>=276 && y <= 280 && ((x >= 551 && x <= 590) || ( x >= 501 && x <= 540 )))
						o_e_chart_color_w = 0;	

					else if(y >= 201 && y <= 280 && x >= 401 && x <= 440) begin
						user_id_number(i_ID_0, 401);
					end

					else if(y >= 201 && y <= 280 && x >= 451 && x <= 490) begin
						user_id_number(i_ID_1, 451);
					end					

					else 
						o_e_chart_color_w = 1;
											
				end

				else if((i_ID_0 >= 1 && i_ID_0 <= 10) && (i_ID_1 >= 1 && i_ID_1 <= 10) && (i_ID_2 >= 1 && i_ID_2 <= 10) && (i_ID_3 == 0 || i_ID_3 >= 11)) begin

					if(y>=276 && y <= 280 && (x >= 551 && x <= 590))
						o_e_chart_color_w = 0;	

					else if(y >= 201 && y <= 280 && x >= 401 && x <= 440) begin
						user_id_number(i_ID_0, 401);
					end

					else if(y >= 201 && y <= 280 && x >= 451 && x <= 490) begin
						user_id_number(i_ID_1, 451);
					end						

					else if(y >= 201 && y <= 280 && x >= 501 && x <= 540) begin
						user_id_number(i_ID_2, 501);									
					end

					else 
						o_e_chart_color_w = 1;
				end

				else if((i_ID_0 >= 1 && i_ID_0 <= 10) && (i_ID_1 >= 1 && i_ID_1 <= 10) && (i_ID_2 >= 1 && i_ID_2 <= 10) && (i_ID_3 >= 1 && i_ID_3 <= 10)) begin

					if(y >= 201 && y <= 280 && x >= 401 && x <= 440) begin
						user_id_number(i_ID_0, 401);
					end

					else if(y >= 201 && y <= 280 && x >= 451 && x <= 490) begin
						user_id_number(i_ID_1, 451);
					end						

					else if(y >= 201 && y <= 280 && x >= 501 && x <= 540) begin
						user_id_number(i_ID_2, 501);									
					end

					else if(y >= 201 && y <= 280 && x >= 551 && x <= 590) begin
						user_id_number(i_ID_3, 551);
					end

					else
						o_e_chart_color_w = 1;
				end

				else begin
					if(y>=276 && y <= 280 && ((x >= 551 && x <= 590)|| ( x >= 501 && x <= 540 ) || (x >= 451 && x <= 490) || (x >= 401 && x <= 440)))
						o_e_chart_color_w = 0;
					else
						o_e_chart_color_w = 1;
				end
			end

			else 
				o_e_chart_color_w = 1;

			// ( y>=276 && y <= 280 && (( x >= 401 && x <= 440 ) || ( x >= 551 && x <= 590 ) || ( x >= 451 && x <= 490 ) || ( x >= 501 && x <= 540 )))
		end

		VISION: begin
			case(i_size)
				ZERO_ONE: begin
					if(i_done == 1) begin
						show_0_1;
					end

					else begin
						case(i_direction)
							UP: 
								point_up(120,24,24,24,24,40,180);
							DOWN:
								point_down(120,24,24,24,24,40,180);
							LEFT:
								point_left(120,24,24,24,24,40,180);
							RIGHT:
								point_right(120,24,24,24,24,40,180);
						endcase
					end
					end

				ZERO_TWO: begin
					if(i_done == 1) begin
						show_0_2();
					end

					else begin
						case(i_direction)
							UP: 
								point_up(60,12,12,12,12,40,180);
							DOWN:
								point_down(60,12,12,12,12,40,180);
							LEFT:
								point_left(60,12,12,12,12,40,180);
							RIGHT:
								point_right(60,12,12,12,12,40,180);
						endcase
					end
					end

				ZERO_THREE: begin
					if(i_done == 1) begin
						show_0_3();
					end

					else begin		
						case(i_direction)
							UP: 
								point_up(40,8,8,8,8,40,180);
							DOWN:
								point_down(40,8,8,8,8,40,180);
							LEFT:
								point_left(40,8,8,8,8,40,180);
							RIGHT:
								point_right(40,8,8,8,8,40,180);
						endcase
					end
					end

				ZERO_FOUR: begin
					if(i_done == 1) begin
						show_0_4();
					end

					else begin	
					case(i_direction)
						UP: 
							point_up(30,6,6,6,6,40,180);
						DOWN:
							point_down(30,6,6,6,6,40,180);
						LEFT:
							point_left(30,6,6,6,6,40,180);
						RIGHT:
							point_right(30,6,6,6,6,40,180);
					endcase
					end
					end

				ZERO_FIVE: begin
					if(i_done == 1) begin
						show_0_5();
					end

					else begin
					case(i_direction)
						UP: 
							point_up(24,5,4,5,5,40,180);
						DOWN:
							point_down(24,5,4,5,5,40,180);
						LEFT:
							point_left(24,5,4,5,5,40,180);
						RIGHT:
							point_right(24,5,4,5,5,40,180);
					endcase
					end
					end

				ZERO_SIX: begin
					if(i_done == 1) begin
						show_0_6();
					end

					else begin
					case(i_direction)
						UP: 
							point_up(20,4,4,4,4,40,180);
						DOWN:
							point_down(20,4,4,4,4,40,180);
						LEFT:
							point_left(20,4,4,4,4,40,180);
						RIGHT:
							point_right(20,4,4,4,4,40,180);
					endcase
					end
					end

				ZERO_SEVEN: begin
					if(i_done == 1) begin
						show_0_7();
					end

					else begin
					case(i_direction)
						UP: 
							point_up(17,3,3,3,4,40,180);
						DOWN:
							point_down(17,3,3,3,4,40,180);
						LEFT:
							point_left(17,3,3,3,4,40,180);
						RIGHT:
							point_right(17,3,3,3,4,40,180);
					endcase
					end
					end

				ZERO_EIGHT: begin
					if(i_done == 1) begin
						show_0_8();
					end

					else begin
					case(i_direction)
						UP: 
							point_up(15,3,3,3,3,40,180);
						DOWN:
							point_down(15,3,3,3,3,40,180);
						LEFT:
							point_left(15,3,3,3,3,40,180);
						RIGHT:
							point_right(15,3,3,3,3,40,180);
					endcase
					end
					end

				ZERO_NINE:begin
					if(i_done == 1) begin
						show_0_9();
					end

					else begin
					case(i_direction)
						UP: 
							point_up(13,3,3,3,2,40,180);
						DOWN:
							point_down(13,3,3,3,2,40,180);
						LEFT:
							point_left(13,3,3,3,2,40,180);
						RIGHT:
							point_right(13,3,3,3,2,40,180);
					endcase
					end
					end

				ONE_ZERO: begin
					if(i_done == 1) begin
						show_1_0();
					end

					else begin
					case(i_direction)
						UP: 
							point_up(12,2,2,2,3,40,180);
						DOWN:
							point_down(12,2,2,2,3,40,180);
						LEFT:
							point_left(12,2,2,2,3,40,180);
						RIGHT:
							point_right(12,2,2,2,3,40,180);
					endcase
					end
					end

				ONE_TWO: begin
					if(i_done == 1) begin
						show_1_2();
					end

					else begin
					case(i_direction)
						UP: 
							point_up(10,2,2,2,2,40,180);
						DOWN:
							point_down(10,2,2,2,2,40,180);
						LEFT:
							point_left(10,2,2,2,2,40,180);
						RIGHT:
							point_right(10,2,2,2,2,40,180);
					endcase
					end
					end

				ONE_FIVE: begin
					if(i_done == 1) begin
						show_1_5();
					end

					else begin
					case(i_direction)
						UP: 
							point_up(8,2,2,2,1,40,180);
						DOWN:
							point_down(8,2,2,2,1,40,180);
						LEFT:
							point_left(8,2,2,2,1,40,180);
						RIGHT:
							point_right(8,2,2,2,1,40,180);
					endcase
					end
					end

				TWO_ZERO: begin
					if(i_done == 1) begin
						show_2_0();
					end

					else begin
					case(i_direction)
						UP: 
							point_up(6,1,2,1,1,40,180);
						DOWN:
							point_down(6,1,2,1,1,40,180);
						LEFT:
							point_left(6,1,2,1,1,40,180);
						RIGHT:
							point_right(6,1,2,1,1,40,180);
					endcase
					end
					end
				
				default: 
					o_e_chart_color_w = 100;   // debug
			endcase
		end

		ASTIGMATISM: begin
			if(((x >= 312 && x <=314) || (x >= 318 && x <=320) || (x >= 324 && x <=326)) && (y >= 282 || y<=198))
				o_e_chart_color_w = 0;
			else if (((y >= 232 && y <=235) || (y >= 239 && y <=242) || (y >= 246 && y <=249)) && (x >= 355 || x<=285))
				o_e_chart_color_w = 0;
			else if ((((x-y) >= 68 && (x-y) <= 72) || ((x-y) >= 78 && (x-y) <= 82) || ((x-y) >= 88 && (x-y) <= 92)) )
				o_e_chart_color_w = 0;
			else if ((((x+y) >= 548 && (x+y) <= 552) || ((x+y) >= 558 && (x+y) <= 562) || ((x+y) >= 568 && (x+y) <= 572)))
				o_e_chart_color_w = 0;
			else 
				o_e_chart_color_w = 1;
		end

		ASTIG_DETECT: begin
			// YES or NO
			if(~astigmatism_or_not) begin
				if(x >= 280 && x <=360 && y <= 295 && y >= 185) begin
					if(x >= 320 && y <= 225 && (x+y) >= 538 && (x+y) <= 548)
						o_e_chart_color_w = 0;
					else if(x <= 320 && y <= 225 && (x-y) <= 98 && (x-y) >= 88)
						o_e_chart_color_w = 0;
					else if (x <= 323 && x >= 317 && y >= 225)
						o_e_chart_color_w = 0;
					else 
						o_e_chart_color_w = 1;
				end

				else
					o_e_chart_color_w = 1;
			end

			else begin
				if(x >= 265 && x <=375 && y <= 294 && y >= 186) begin
					if(x <= 272 || x >=368)
						o_e_chart_color_w = 0;
					else if((x-y) >= 74 && (x-y) <= 86)
						o_e_chart_color_w = 0;
					else
						o_e_chart_color_w = 1;
				end
				else
					o_e_chart_color_w = 1;
			end
		end

		COLOR_BLIND_DETECT: begin
			// YES or NO
			if(~color_test_result) begin
				if(x >= 280 && x <=360 && y <= 295 && y >= 185) begin
					if(x >= 320 && y <= 225 && (x+y) >= 538 && (x+y) <= 548)
						o_e_chart_color_w = 0;
					else if(x <= 320 && y <= 225 && (x-y) <= 98 && (x-y) >= 88)
						o_e_chart_color_w = 0;
					else if (x <= 323 && x >= 317 && y >= 225)
						o_e_chart_color_w = 0;
					else 
						o_e_chart_color_w = 1;
				end

				else
					o_e_chart_color_w = 1;
			end

			else begin
				if(x >= 265 && x <=375 && y <= 294 && y >= 186) begin
					if(x <= 272 || x >=368)
						o_e_chart_color_w = 0;
					else if((x-y) >= 74 && (x-y) <= 86)
						o_e_chart_color_w = 0;
					else
						o_e_chart_color_w = 1;
				end
				else
					o_e_chart_color_w = 1;
			end
		end

		default: 
			o_e_chart_color_w = 100;

	endcase
end

always_ff @(posedge i_clk or negedge i_rst) begin
	if (~i_rst) begin
		o_e_chart_color_r <= 255;

	end else begin
		o_e_chart_color_r <= o_e_chart_color_w;
	end


end

endmodule
