module RS232(
	input avm_rst,
	input avm_clk,
	output [4:0] avm_address,
	output avm_read,
	input [31:0] avm_readdata,
	output avm_write,
	output [31:0] avm_writedata,
	input avm_waitrequest
	input [3:0] userID_from_IR,
	input [3:0] sight_from_Core,
	input astigmatism_from_Core
);
	localparam RX_BASE     = 0*4;
	localparam TX_BASE     = 1*4;
	localparam STATUS_BASE = 2*4;
	localparam TX_OK_BIT = 6;
	localparam RX_OK_BIT = 7;

	localparam S_GET_KEY = 0;
	localparam S_GET_DATA = 1;
	localparam S_WAIT_CALCULATE = 2;
	localparam S_SEND_DATA = 3;
	localparam P_READ_DATA = 4;
	localparam P_MAINTAIN = 5;
	localparam P_READ_DATA_WRITE = 6;
	localparam P_MAINTAIN_WRITE = 7;

	localparam SMALL_N = 8;
	localparam SMALL_E = 9;
//	localparam SMALL_ENC = 10;
	
	localparam N_FULL = 32;
	localparam E_FULL = 64;
	localparam ENC_FULL = 96;


	logic [255:0] n_r, n_w, e_r, e_w, enc_r, enc_w;
	logic [255:0] read_buffer_r, read_buffer_w;								//terminally save 256 bits value
	logic [255:0] write_buffer_r, write_buffer_w;
	logic [3:0] state_r, state_w;
	//logic [1:0] small_state_r, small_state_w;
	logic [6:0] bytes_counter_r, bytes_counter_w;
	logic [4:0] avm_address_r, avm_address_w;
	logic avm_read_r, avm_read_w, avm_write_r, avm_write_w;
	logic rsa_start_r, rsa_start_w;
	logic rsa_finished;
	logic [255:0] rsa_dec;																					

	assign avm_address = avm_address_r;
	assign avm_read = avm_read_r;
	assign avm_write = avm_write_r;
	assign avm_writedata = write_buffer_r[247-:8];   

	Rsa256Core rsa256_core(
		.i_clk(avm_clk),
		.i_rst(avm_rst),
		.i_start(rsa_start_r),
		.i_a(enc_r),
		.i_e(e_r),
		.i_n(n_r),
		.o_a_pow_e(rsa_dec),
		.o_finished(rsa_finished)
	);

	task StartRead;
		input [4:0] addr;
		begin
			avm_read_w = 1;
			avm_write_w = 0;
			avm_address_w = addr;
		end
	endtask

	task StartWrite;
		input [4:0] addr;
		begin
			avm_read_w = 0;
			avm_write_w = 1;
			avm_address_w = addr;
		end
	endtask

	task DoNothing;
    	begin
      		avm_read_w = 1;					//not sure
      		avm_write_w = 0;
      		avm_address_w = 8;				//not sure
    	end
  	endtask

  	task DoNothing_readzero;
  		begin
  			avm_read_w = 0;					//not sure
      		avm_write_w = 0;
      		avm_address_w = 8;	
  		end
  	endtask

	always_comb begin
		// NOT SURE >_<
	    enc_w = enc_r;
    	n_w = n_r;
    	e_w = e_r;

    	avm_read_w = avm_read_r;
    	avm_write_w = avm_write_r;
    	avm_address_w = avm_address_r;

    	read_buffer_w = read_buffer_r;
    	write_buffer_w = write_buffer_r;

    	state_w = state_r;

    	bytes_counter_w = bytes_counter_r;
    	rsa_start_w = rsa_start_r;


		case(state_r)  
			S_GET_KEY:  begin
				state_w = P_MAINTAIN;
				end 

			P_READ_DATA:			
				if(avm_waitrequest == 0)begin   
					read_buffer_w = (read_buffer_r << 8) + avm_readdata[7:0];   
					bytes_counter_w = bytes_counter_r + 1;
					DoNothing_readzero();
					state_w = P_MAINTAIN;						
				end

				else begin
					bytes_counter_w = bytes_counter_r;
					StartRead(RX_BASE);
					state_w = P_READ_DATA;
				end	

			SMALL_N: 
				if(avm_waitrequest ==0 && avm_readdata[RX_OK_BIT]==1) begin
					StartRead(RX_BASE);
					state_w = P_READ_DATA;
				end

				else begin
					DoNothing();
					state_w = SMALL_N;
				end	

			SMALL_E:
				if(avm_waitrequest ==0 && avm_readdata[RX_OK_BIT]==1) begin
					StartRead(RX_BASE);
					state_w = P_READ_DATA;
				end

				else begin
					DoNothing();
					state_w = SMALL_E;
				end		


			P_MAINTAIN:
				if(bytes_counter_r == N_FULL) begin
					n_w = read_buffer_r;
					DoNothing_readzero();
					state_w = SMALL_N;
				end

				else if(bytes_counter_r == E_FULL) begin
					e_w = read_buffer_r;
					DoNothing_readzero();
					state_w = S_GET_DATA;
				end

				else if(bytes_counter_r == ENC_FULL) begin
					enc_w = read_buffer_r;
					bytes_counter_w = 0;
					DoNothing_readzero();	
					rsa_start_w = 1;
					state_w = S_WAIT_CALCULATE;					
				end				

				else begin
					if(avm_waitrequest ==0 && avm_readdata[RX_OK_BIT]==1) begin
						StartRead(RX_BASE);
						state_w = P_READ_DATA;
					end
					else begin
						DoNothing();
						state_w = P_MAINTAIN;
					end
				end

			S_GET_DATA: begin
				state_w =  SMALL_E; 
				end 

			S_WAIT_CALCULATE: 
				if(rsa_finished == 1)begin
					write_buffer_w = rsa_dec;
					DoNothing();		//not sure
					state_w = S_SEND_DATA;
				end

				else begin
					rsa_start_w = 0;
					DoNothing_readzero();
					state_w = S_WAIT_CALCULATE;
				end


			S_SEND_DATA: begin
				state_w = P_MAINTAIN_WRITE;
				end

			P_READ_DATA_WRITE:
				if(avm_waitrequest == 0) begin
					case(bytes_counter_r)
						(N_FULL-2): begin 
							DoNothing();							
							write_buffer_w = 0;  						
							bytes_counter_w = 64;						//not sure
							state_w = S_GET_DATA;	
						end

						default : begin
							DoNothing();
							write_buffer_w = write_buffer_r << 8;   
							bytes_counter_w = bytes_counter_r + 1;
							state_w = P_MAINTAIN_WRITE;	
						end
					endcase
				end

				else begin
					bytes_counter_w = bytes_counter_r;
					StartWrite(TX_BASE);
					state_w = P_READ_DATA_WRITE;
				end

			P_MAINTAIN_WRITE:
				if(avm_waitrequest ==0 && avm_readdata[TX_OK_BIT]==1)begin 
					StartWrite(TX_BASE);
					state_w = P_READ_DATA_WRITE;
				end

				else begin
					DoNothing();
					state_w = P_MAINTAIN_WRITE;
				end

		endcase

	end



	always_ff @(posedge avm_clk or posedge avm_rst) begin
		if (avm_rst) begin
			n_r <= 0;
			e_r <= 0;
			enc_r <= 0;
			avm_address_r <= STATUS_BASE;
			avm_read_r <= 1;
			avm_write_r <= 0;
			state_r <= S_GET_KEY;
			bytes_counter_r <= 0;								
			rsa_start_r <= 0;
			write_buffer_r <= 0;
      		read_buffer_r <= 0;
		end else begin
			n_r <= n_w;
			e_r <= e_w;
			enc_r <= enc_w;
			avm_address_r <= avm_address_w;
			avm_read_r <= avm_read_w;
			avm_write_r <= avm_write_w;
			state_r <= state_w;
			bytes_counter_r <= bytes_counter_w;
			rsa_start_r <= rsa_start_w;
			read_buffer_r <= read_buffer_w;
			write_buffer_r <= write_buffer_w;
		end
	end
endmodule
