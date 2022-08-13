module TX_FSM (
input	wire 								CLK,
input	wire								RST,
input	wire								Data_Valid,
input	wire 								PAR_en,
input	wire								ser_done,

output	reg 								ser_en,
output	reg 								PAR_calc,
output	reg 			[1:0]				mux_sel,
output	reg 								busy
);

//States encoding "gray code"
localparam	IDLE = 3'b000,
			Start = 3'b001,
			Serial_out = 3'b011,
			Parity_out = 3'b010,
			Stop = 3'b110 ;
			
reg		[2:0]	current_state,
				next_state ;
		

reg				busy_comb;

always @(posedge CLK, negedge RST)
 begin
	if (!RST)
	 begin
		current_state <= IDLE ;
	 end
	else 
	 begin 
		current_state <= next_state ;
	 end
 end	
 
  //next state logic
 always @ (*)
  begin
	case (current_state)
	IDLE		:	
				begin
	
				 if ( Data_Valid )
				  begin
				   next_state = Start ;
				  end
				 else
				  begin
				   next_state = IDLE ;
				  end
				  
				end
	
	Start		:	
				begin
				   next_state = Serial_out ;
				end
				
	Serial_out	:	
				begin
	
				 if ( ser_done && PAR_en )
				  begin
				   next_state = Parity_out ;
				  end
				 else if ( ser_done && !PAR_en )
				  begin
				   next_state = Stop ;
				  end
				  else
				  begin
				   next_state = Serial_out ;
				  end
				end
				 
	Parity_out	:
				begin
				   next_state = Stop ;
				end
				
	Stop		:	
				begin
	
				 if ( Data_Valid )
				  begin
				   next_state = Start ;
				  end
				  else
				  begin
				   next_state = IDLE ;
				  end
				end

	default 	: 
				begin
                 next_state = IDLE  ;
				end  
    endcase 
 end

//output logic
 always @ (*)
  begin
	ser_en = 1'b0;
	PAR_calc = 1'b0;
	mux_sel = 2'b01;
	busy_comb = 1'b0;
	case (current_state)
	IDLE		:	
				begin
				ser_en = 1'b0;
				PAR_calc = 1'b0;
				mux_sel = 2'b01;
				busy_comb = 1'b0;
				end
	
	Start		:	
				begin
				ser_en = 1'b1;
				mux_sel = 2'b00;
				busy_comb = 1'b1;
				
				if ( PAR_en )
				 begin
				  PAR_calc = 1'b1; 
				 end
				else
				 begin
				  PAR_calc = 1'b0; 
				 end
				
				end
				
	Serial_out	:	
				begin
				ser_en = 1'b0;
				PAR_calc = 1'b0;
				mux_sel = 2'b10;
				busy_comb = 1'b1;
				end
				 
	Parity_out	:
				begin
				ser_en = 1'b0;
				PAR_calc = 1'b0;
				mux_sel = 2'b11;
				busy_comb = 1'b1;
				end
				
	Stop		:	
				begin
				ser_en = 1'b0;
				PAR_calc = 1'b0;
				mux_sel = 2'b01;
				busy_comb = 1'b1;
				end

	default 	: 
				begin
				ser_en = 1'b0;
				PAR_calc = 1'b0;
				mux_sel = 2'b01;
				busy_comb = 1'b0;
				end
    endcase 
 end


always @ (posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
    busy <= 1'b0 ;
   end
  else
   begin
    busy <= busy_comb ;
   end
 end

endmodule