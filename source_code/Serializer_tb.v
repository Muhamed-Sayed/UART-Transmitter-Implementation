`timescale 1ns/100ps		
module Serializer_tb ;

parameter CLK_PERIOD = 5 ;
parameter SERIALIZER_WIDTH = 8;
////////////////////////////////////////////////////////
/////////////////// DUT Signals //////////////////////// 
////////////////////////////////////////////////////////

reg 								CLK_tb;
reg									RST_tb;
reg		[SERIALIZER_WIDTH-1:0]		P_DATA_tb;
reg 								ser_en_tb;
wire								ser_done_tb;
wire								ser_data_tb;

integer i;
initial
 begin
	CLK_tb = 1'b0;
	P_DATA_tb = 'b0;
	ser_en_tb = 1'b0;
	
	RST_tb = 1'b1;
	#(1*CLK_PERIOD);
	RST_tb = 1'b0;
	#(1*CLK_PERIOD);
	RST_tb = 1'b1;
	
	P_DATA_tb = 8'b11111111;
	#(0.5*CLK_PERIOD)
	ser_en_tb = 1'b1;
	#(CLK_PERIOD)
	ser_en_tb = 1'b0;
	//$monitor ("ser_data = %d, ser_done = %d, Current time = %d CLK",ser_data_tb,ser_done_tb, $time/CLK_PERIOD);
	#(0.5*CLK_PERIOD)
	for (i = 0; i< 8; i=i+1)
	 begin
		if (ser_data_tb == P_DATA_tb[i])
		 $display("bit no %d is right",i);
		else
		 $display("bit no %d is wrong",i);
	 #(CLK_PERIOD);
	 end
	
	if (ser_done_tb == 1'b1)
		 $display("ser_done HIGH");
	else
		$display("ser_done HIGH");
	
	#100
	$finish;
 end



initial
 begin
$monitor ("ser_en = %d, ser_data = %d, ser_done = %d, Current time = %d CLK",ser_en_tb,ser_data_tb,ser_done_tb, $time/CLK_PERIOD);
end



initial
 begin
	forever #(0.5*CLK_PERIOD)  CLK_tb = ~CLK_tb ;
 end
  
  
Serializer DUT (
.CLK(CLK_tb),
.RST(RST_tb),
.P_DATA(P_DATA_tb),
.ser_en(ser_en_tb),
.ser_done(ser_done_tb),
.ser_data(ser_data_tb)
);

endmodule