
`timescale 1ns/100ps
module UART_TX_tb ();

parameter CLK_PERIOD = 5 ;
parameter WIDTH = 8;


reg 								CLK_tb;
reg									RST_tb;
reg									DATA_VALID_tb;
reg 								PAR_EN_tb;
reg 								PAR_TYP_tb;
reg			[WIDTH-1:0]				P_DATA_tb;

wire								TX_OUT_tb;
wire 								Busy_tb;


initial
begin

 // Save Waveform
 $dumpfile("UART_TX.vcd") ;       
 $dumpvars;
  
 initialize();
 
 reset();
 
 $monitor("TX_OUT_tb = %d, Busy_tb = %d, time = %d clk", TX_OUT_tb, Busy_tb, $time/CLK_PERIOD  );
 
  #(0.5*CLK_PERIOD)
 $display("/****************************************************************************************/");
 $display("/************************************* Test Case 1:  ************************************/");
 $display("/****************************************************************************************/\n");
 put_data_and_check(8'b01111111,0,1);
 $display("/****************************************************************************************/");
 $display("/************************************* Test Case 2:  ************************************/");
 $display("/****************************************************************************************/\n");
 put_data_and_check(8'b01111111,0,0);
 
 #(2*CLK_PERIOD)
 $finish;
 
end



initial
begin
	forever #(0.5*CLK_PERIOD)	CLK_tb = ~ CLK_tb ;
end

////////////////////////////////////////////////////////
/////////////////////// TASKS //////////////////////////
////////////////////////////////////////////////////////
task initialize;
 begin
  CLK_tb = 1'b0;
  DATA_VALID_tb = 1'b0; 
  PAR_EN_tb = 1'b0;
  PAR_TYP_tb = 1'b0;
  P_DATA_tb = 'b0;
 end
endtask 

task reset;
 begin
  RST_tb = 1'b1;
  #(5*CLK_PERIOD)
  RST_tb = 1'b0;
  #(5*CLK_PERIOD)
  RST_tb = 1'b1;
 end
endtask


task put_data_and_check;
 input 	reg		[WIDTH-1:0] 	parallel_data ;
 input	reg						parity_enable ;
 input	reg						parity_type ;
  
 reg 	even_parity; 
 integer i; 
 begin
  P_DATA_tb = parallel_data ;
  PAR_EN_tb = parity_enable ; 
  PAR_TYP_tb = parity_type ;
  
 
  DATA_VALID_tb = 1'b1 ;
  #(CLK_PERIOD)
  DATA_VALID_tb = 1'b0 ;
  #(CLK_PERIOD)
  if (TX_OUT_tb == 1'b0)	$display("Start bit is out\n");
  else						$display("Start bit isn't out\n");
  
  for (i=0; i< WIDTH; i = i+1)
   begin
    #(CLK_PERIOD)
    if (TX_OUT_tb == parallel_data[i])
	 $display("bit no %d of data is sent successfully\n",i);
	else
	 $display("bit no %d of data had an error\n",i);
   end
   
 
  if (parity_enable == 1'b1)
   begin
    even_parity = ^parallel_data ;
	#(CLK_PERIOD)
    case (parity_type)
	1'b1: 
		if (TX_OUT_tb == ~even_parity)
		 $display("Odd parity is correct\n");
		else
		 $display("Odd parity is not correct\n");
		 
	1'b0:
		if (TX_OUT_tb == even_parity)
		 $display("even parity is correct\n");
		else
		 $display("even parity is not correct\n");
	endcase
   end
   
   #(CLK_PERIOD)
   if (TX_OUT_tb == 1'b1)	$display("stop bit is out\n");
   else						$display("stop bit isn't out\n");
   
 end
 endtask



UART_TX DUT 
(
.CLK(CLK_tb),
.RST(RST_tb),
.DATA_VALID(DATA_VALID_tb),
.PAR_EN(PAR_EN_tb),
.PAR_TYP(PAR_TYP_tb),
.P_DATA(P_DATA_tb),

.TX_OUT(TX_OUT_tb),
.Busy(Busy_tb)
);

endmodule