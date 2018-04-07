module astigmatism (
	input i_clk,
	input i_rst,
	input [11:0] x,
	input [11:0] y,
// state or a
	output o_e_chart_color


);

logic  o_e_chart_color_r, o_e_chart_color_w;



assign o_e_chart_color = o_e_chart_color_r;

always_comb begin
//(((x-y) >= 73 && (x-y) <= 75) || ((x-y) >= 79 && (x-y) <= 81) || ((x-y) >= 85 && (x-y) <= 87)) && ((x >= 340 && y <= 220) || (x <= 300 && y >= 260))
//(((x+y) >= 553 && (x+y) <= 555) || ((x+y) >= 559 && (x+y) <= 561) || ((x+y) >= 565 && (x+y) <= 567)) && ((x >= 340 && y >= 260) || (x <= 300 && y <= 220))
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

always_ff @(posedge i_clk or negedge i_rst) begin
	if (~i_rst) begin
		o_e_chart_color_r <= 255;


	end else begin
		o_e_chart_color_r <= o_e_chart_color_w;
	end


end

endmodule