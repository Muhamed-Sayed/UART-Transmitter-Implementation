module Mux (
input	wire 				CLK,
input	wire				RST,
input 	wire				ser_data,
input	wire				PAR_BIT,
input 	wire	[1:0]		mux_sel,
output	reg					TX_OUT
);

reg 	OUT;

always @(*)
 begin
	case (mux_sel)
	2'b00:	OUT = 1'b0;
	2'b01:	OUT = 1'b1;
	2'b10:	OUT = ser_data;
	2'b11:	OUT = PAR_BIT;
	endcase
 end


always @ (posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
    TX_OUT <= 1'b0 ;
   end
  else
   begin
    TX_OUT <= OUT ;
   end 
 end  
endmodule