module IR_RECEIVE(
					iCLK,         //clk 50MHz
					iRST_n,       //reset					
					iIRDA,        //IR code input
					oRST,         //output reset signal
					//oUP,          //output direction
					//oDOWN,        //output direction down
					//oLEFT,        //output direction left
					//oRIGHT,       //output direction right
					o_1,          //output 1 for user ID
					o_2,          //output 2 for user ID
					o_3,          //output 3 for user ID
					o_4,          //output 4 for user ID
					o_5,          //output 5 for user ID
					o_6,          //output 6 for user ID
					o_7,          //output 7 for user ID
					o_8,          //output 8 for user ID
					o_9,          //output 9 for user ID
					o_0,          //output 0 for user ID
					o_A,          //output yes
					o_B           //output no
					);

//  PARAMETER declarations
parameter IDLE               = 2'b00;    //always high voltage level
parameter GUIDANCE           = 2'b01;    //9ms low voltage and 4.5 ms high voltage
parameter DATAREAD           = 2'b10;    //0.6ms low voltage start and with 0.52ms high voltage is 0,with 1.66ms high voltage is 1, 32bit in sum.
parameter OUTPUT             = 2'b11;    //output the direction and reset

parameter IDLE_HIGH_DUR      =  262143;  // data_count    262143*0.02us = 5.24ms, threshold for DATAREAD-----> IDLE
parameter GUIDE_LOW_DUR      =  230000;  // idle_count    230000*0.02us = 4.60ms, threshold for IDLE--------->GUIDANCE
parameter GUIDE_HIGH_DUR     =  210000;  // state_count   210000*0.02us = 4.20ms, 4.5-4.2 = 0.3ms < BIT_AVAILABLE_DUR = 0.4ms,threshold for GUIDANCE------->DATAREAD
parameter DATA_HIGH_DUR      =  41500;	 // data_count    41500 *0.02us = 0.83ms, sample time from the posedge of iIRDA
parameter BIT_AVAILABLE_DUR  =  20000;   // data_count    20000 *0.02us = 0.4ms,  the sample bit pointer,can inhibit the interference from iIRDA signal

//  PORT declarations
// Input from Top module
input         iCLK;        //input clk,50MHz
input         iRST_n;      //rst
input         iIRDA;       //Irda RX output decoded data
// Output to virtual IR module
output        oRST;        //output reset signal
//output        oUP;
//output        oDOWN;
//output        oLEFT;
//output        oRIGHT;
output        o_1;
output        o_2;
output        o_3;
output        o_4;
output        o_5;
output        o_6;
output        o_7;
output        o_8;
output        o_9;
output        o_0;
output        o_A;
output        o_B;

//  Signal Declarations
reg    [31:0] oDATA_r, oDATA_w;      //data output reg
reg    [17:0] idle_count;            //idle_count counter works under data_read state
reg           idle_count_flag;       //idle_count conter flag
reg    [17:0] state_count;           //state_count counter works under guide state
reg           state_count_flag;      //state_count conter flag
reg    [17:0] data_count;            //data_count counter works under data_read state
reg           data_count_flag;       //data_count conter flag
reg     [5:0] bitcount;              //sample bit pointer
reg     [1:0] state;                 //state reg
reg    [31:0] data;                  //data reg
reg    [31:0] data_buf;              //data buf
reg           data_ready;            //data ready flag
//reg           up_reg, down_reg, left_reg, right_reg;
reg           reg_rst, reg_1, reg_2, reg_3, reg_4, reg_5, reg_6, reg_7, reg_8, reg_9, reg_0, reg_A, reg_B;

//  Structural coding	
assign oRST   = reg_rst;
//assign oUP    = up_reg;
//assign oDOWN  = down_reg;
//assign oLEFT  = left_reg;
//assign oRIGHT = right_reg;
assign o_1    = reg_1;
assign o_2    = reg_2;
assign o_3    = reg_3;
assign o_4    = reg_4;
assign o_5    = reg_5;
assign o_6    = reg_6;
assign o_7    = reg_7;
assign o_8    = reg_8;
assign o_9    = reg_9;
assign o_0    = reg_0;
assign o_A    = reg_A;
assign o_B    = reg_B;

//idle counter works on iclk under IDLE state only
always @(posedge iCLK or negedge iRST_n)	
	  if (!iRST_n)
		   idle_count <= 0;
	  else if (idle_count_flag)    //the counter works when the flag is 1
			 idle_count <= idle_count + 1'b1;
		else  
			 idle_count <= 0;	         //the counter resets when the flag is 0		      		 	

//idle counter switch when iIRDA is low under IDLE state
always @(posedge iCLK or negedge iRST_n)	
	  if (!iRST_n)
		   idle_count_flag <= 1'b0;
	  else if ((state == IDLE) && !iIRDA)
			 idle_count_flag <= 1'b1;
		else                           
			 idle_count_flag <= 1'b0;		     		 	
      
//state counter works on iclk under GUIDE state only
always @(posedge iCLK or negedge iRST_n)	
	  if (!iRST_n)
		   state_count <= 0;
	  else if (state_count_flag)    //the counter works when the flag is 1
			 state_count <= state_count + 1'b1;
		else  
			 state_count <= 0;	        //the counter resets when the flag is 0		      		 	

//state counter switch when iIRDA is high under GUIDE state
always @(posedge iCLK or negedge iRST_n)	
	  if (!iRST_n)
		   state_count_flag <= 1'b0;
	  else if ((state == GUIDANCE) && iIRDA)
			 state_count_flag <= 1'b1;
		else  
			 state_count_flag <= 1'b0;     		 	

//data read decode counter based on iCLK
always @(posedge iCLK or negedge iRST_n)	
	  if (!iRST_n)
		   data_count <= 1'b0;
	  else if(data_count_flag)      //the counter works when the flag is 1
			 data_count <= data_count + 1'b1;
		else 
			 data_count <= 1'b0;        //the counter resets when the flag is 0

//data counter switch
always @(posedge iCLK or negedge iRST_n)
	  if (!iRST_n) 
		   data_count_flag <= 0;	
	  else if ((state == DATAREAD) && iIRDA)
			 data_count_flag <= 1'b1;  
		else
			 data_count_flag <= 1'b0; 

//data reg pointer counter 
always @(posedge iCLK or negedge iRST_n)
    if (!iRST_n)
       bitcount <= 6'b0;
	  else if (state == DATAREAD)
		begin
			if (data_count == 20000)
					bitcount <= bitcount + 1'b1; //add 1 when iIRDA posedge
		end   
	  else
	     bitcount <= 6'b0;

//state change between IDLE,GUIDE,DATA_READ according to irda edge or counter
always @(posedge iCLK or negedge iRST_n) 
	  if (!iRST_n)	     
	     state <= IDLE;
	  else 
			 case (state)
 			    IDLE     : if (idle_count > GUIDE_LOW_DUR)  // state chang from IDLE to Guidance when detect the negedge and the low voltage last for > 4.6ms
			  	              state <= GUIDANCE; 
			    GUIDANCE : if (state_count > GUIDE_HIGH_DUR)//state change from GUIDANCE to DATAREAD when detect the posedge and the high voltage last for > 4.2ms
			  	              state <= DATAREAD;
			    DATAREAD : if ((data_count >= IDLE_HIGH_DUR) || (bitcount >= 33))
			  					      state <= OUTPUT;
				OUTPUT   : state <= IDLE;
				default  : state <= IDLE; //default
			endcase

//data decode base on the value of data_count 	
always @(posedge iCLK or negedge iRST_n)
	  if (!iRST_n)
	     data <= 0;
		else if (state == DATAREAD)
		begin
			 if (data_count >= DATA_HIGH_DUR) //2^15 = 32767*0.02us = 0.64us
			    data[bitcount-1'b1] <= 1'b1;  //>0.52ms  sample the bit 1
		end
		else
			 data <= 0;
	
//set the data_ready flag 
always @(posedge iCLK or negedge iRST_n) 
	  if (!iRST_n)
	     data_ready <= 1'b0;
    else if (bitcount == 32)   
		begin
			 if (data[31:24] == ~data[23:16])
			 begin		
					data_buf <= data;     //fetch the value to the databuf from the data reg
				  data_ready <= 1'b1;   //set the data ready flag
			 end	
			 else
				  data_ready <= 1'b0 ;  //data error
		end
		else
		   data_ready <= 1'b0 ;

//read data
always @(posedge iCLK or negedge iRST_n)
	if (!iRST_n)
		oDATA_r <= 32'b0000;
	else if (data_ready) 
	    oDATA_r <= data_buf;  //output
	else
		oDATA_r <= oDATA_w;
		  
always begin
   if(state == OUTPUT) begin
	case (oDATA_r[31:16])
		16'b1111110100000010 : begin                 //2 up
			//up_reg = 1;
			//down_reg = 0;
			//left_reg = 0;
			//right_reg = 0;
			reg_rst = 0;
			reg_1 = 0; 
			reg_2 = 1;
			reg_3 = 0;
			reg_4 = 0; 
			reg_5 = 0;
			reg_6 = 0;
			reg_7 = 0;
			reg_8 = 0;
			reg_9 = 0;
			reg_0 = 0;
			reg_A = 0;
			reg_B = 0;
		end
		
		16'b1111011100001000 : begin					//8 down
			//up_reg = 0;
			//down_reg = 1;
			//left_reg = 0;
			//right_reg = 0;
			reg_rst = 0;
			reg_1 = 0; 
			reg_2 = 0;
			reg_3 = 0;
			reg_4 = 0; 
			reg_5 = 0;
			reg_6 = 0;
			reg_7 = 0;
			reg_8 = 1;
			reg_9 = 0;
			reg_0 = 0;
			reg_A = 0;
			reg_B = 0;
		end
		
		16'b1111101100000100 : begin					//4 left
			//up_reg = 0;
			//down_reg = 0;
			//left_reg = 1;
			//right_reg = 0;
			reg_rst = 0;
			reg_1 = 0; 
			reg_2 = 0;
			reg_3 = 0;
			reg_4 = 1; 
			reg_5 = 0;
			reg_6 = 0;
			reg_7 = 0;
			reg_8 = 0;
			reg_9 = 0;
			reg_0 = 0;
			reg_A = 0;
			reg_B = 0;
		end
		
		16'b1111100100000110 : begin					//6 right
			//up_reg = 0;
			//down_reg = 0;
			//left_reg = 0;
			//right_reg = 1;
			reg_rst = 0;
			reg_1 = 0; 
			reg_2 = 0;
			reg_3 = 0;
			reg_4 = 0; 
			reg_5 = 0;
			reg_6 = 1;
			reg_7 = 0;
			reg_8 = 0;
			reg_9 = 0;
			reg_0 = 0;
			reg_A = 0;
			reg_B = 0;
		end
		
		16'b1111111000000001 : begin					//1
			//up_reg = 0;
			//down_reg = 0;
			//left_reg = 0;
			//right_reg = 0;
			reg_rst = 0;
			reg_1 = 1; 
			reg_2 = 0;
			reg_3 = 0;
			reg_4 = 0; 
			reg_5 = 0;
			reg_6 = 0;
			reg_7 = 0;
			reg_8 = 0;
			reg_9 = 0;
			reg_0 = 0;
			reg_A = 0;
			reg_B = 0;
		end
		
		16'b1111110000000011 : begin					//3
			//up_reg = 0;
			//down_reg = 0;
			//left_reg = 0;
			//right_reg = 0;
			reg_rst = 0;
			reg_1 = 0; 
			reg_2 = 0;
			reg_3 = 3;
			reg_4 = 0; 
			reg_5 = 0;
			reg_6 = 0;
			reg_7 = 0;
			reg_8 = 0;
			reg_9 = 0;
			reg_0 = 0;
			reg_A = 0;
			reg_B = 0;
		end
		
		16'b1111101000000101 : begin					//5
			//up_reg = 0;
			//down_reg = 0;
			//left_reg = 0;
			//right_reg = 0;
			reg_rst = 0;
			reg_1 = 0; 
			reg_2 = 0;
			reg_3 = 0;
			reg_4 = 0; 
			reg_5 = 1;
			reg_6 = 0;
			reg_7 = 0;
			reg_8 = 0;
			reg_9 = 0;
			reg_0 = 0;
			reg_A = 0;
			reg_B = 0;
		end
		
		16'b1111100000000111 : begin					//7
			//up_reg = 0;
			//down_reg = 0;
			//left_reg = 0;
			//right_reg = 0;
			reg_rst = 0;
			reg_1 = 0; 
			reg_2 = 0;
			reg_3 = 0;
			reg_4 = 0; 
			reg_5 = 0;
			reg_6 = 0;
			reg_7 = 1;
			reg_8 = 0;
			reg_9 = 0;
			reg_0 = 0;
			reg_A = 0;
			reg_B = 0;
		end
		
		16'b1111011000001001 : begin					//9
			//up_reg = 0;
			//down_reg = 0;
			//left_reg = 0;
			//right_reg = 0;
			reg_rst = 0;
			reg_1 = 0; 
			reg_2 = 0;
			reg_3 = 0;
			reg_4 = 0; 
			reg_5 = 0;
			reg_6 = 0;
			reg_7 = 0;
			reg_8 = 0;
			reg_9 = 1;
			reg_0 = 0;
			reg_A = 0;
			reg_B = 0;
		end
		
		16'b1111111100000000 : begin					//0
			//up_reg = 0;
			//down_reg = 0;
			//left_reg = 0;
			//right_reg = 0;
			reg_rst = 0;
			reg_1 = 0; 
			reg_2 = 0;
			reg_3 = 0;
			reg_4 = 0; 
			reg_5 = 0;
			reg_6 = 0;
			reg_7 = 0;
			reg_8 = 0;
			reg_9 = 0;
			reg_0 = 1;
			reg_A = 0;
			reg_B = 0;
		end
		
		16'b1111000000001111 : begin					//A
			//up_reg = 0;
			//down_reg = 0;
			//left_reg = 0;
			//right_reg = 0;
			reg_rst = 0;
			reg_1 = 0; 
			reg_2 = 0;
			reg_3 = 0;
			reg_4 = 0; 
			reg_5 = 0;
			reg_6 = 0;
			reg_7 = 0;
			reg_8 = 0;
			reg_9 = 0;
			reg_0 = 0;
			reg_A = 1;
			reg_B = 0;
		end
		
		16'b1110110000010011 : begin 				//B
			//up_reg = 0;
			//down_reg = 0;
			//left_reg = 0;
			//right_reg = 0;
			reg_rst = 0;
			reg_1 = 0; 
			reg_2 = 0;
			reg_3 = 0;
			reg_4 = 0; 
			reg_5 = 0;
			reg_6 = 0;
			reg_7 = 0;
			reg_8 = 0;
			reg_9 = 0;
			reg_0 = 0;
			reg_A = 0;
			reg_B = 1;
		end
		
		16'b1110110100010010 : begin					//power reset
			//up_reg = 0;
			//down_reg = 0;
			//left_reg = 0;
			//right_reg = 0;
			reg_rst = 1;
			reg_1 = 0; 
			reg_2 = 0;
			reg_3 = 0;
			reg_4 = 0; 
			reg_5 = 0;
			reg_6 = 0;
			reg_7 = 0;
			reg_8 = 0;
			reg_9 = 0;
			reg_0 = 0;
			reg_A = 0;
			reg_B = 0;
		end
		
		default     : begin
			//up_reg = 0;
			//down_reg = 0;
			//left_reg = 0;
			//right_reg = 0;
			reg_rst = 0;
			reg_1 = 0; 
			reg_2 = 0;
			reg_3 = 0;
			reg_4 = 0; 
			reg_5 = 0;
			reg_6 = 0;
			reg_7 = 0;
			reg_8 = 0;
			reg_9 = 0;
			reg_0 = 0;
			reg_A = 0;
			reg_B = 0;
		end
	endcase
	end
	else begin
			//up_reg = 0;
			//down_reg = 0;
			//left_reg = 0;
			//right_reg = 0;
			reg_rst = 0;
			reg_1 = 0; 
			reg_2 = 0;
			reg_3 = 0;
			reg_4 = 0; 
			reg_5 = 0;
			reg_6 = 0;
			reg_7 = 0;
			reg_8 = 0;
			reg_9 = 0;
			reg_0 = 0;
			reg_A = 0;
			reg_B = 0;
	end
end

endmodule
