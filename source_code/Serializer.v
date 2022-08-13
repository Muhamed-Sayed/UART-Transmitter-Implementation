module Serializer #( parameter SERIALIZER_WIDTH = 8, parameter SHIFT_COUNTER_WIDTH = 4 )
(
input	wire 								CLK,
input	wire								RST,
input	wire	[SERIALIZER_WIDTH-1:0]		P_DATA,
input	wire 								ser_en,
output	wire								ser_done,
output	wire								ser_data
);

reg		[SERIALIZER_WIDTH-1:0]			Shift_Reg;
reg		[SHIFT_COUNTER_WIDTH-1:0]		Shift_Counter;

always @(posedge CLK, negedge RST)
 begin
	if (!RST)
	 begin
		Shift_Reg <= 'b0;
		//ser_data <= 1'b1;
	 end
	else if (ser_en)
	 begin 
		Shift_Reg <= P_DATA ;
		//ser_data <= 1'b0;
	 end
	else if (!ser_done)
	 begin 
		//{Shift_Reg[SERIALIZER_WIDTH -2:0] ,ser_data} <= Shift_Reg ;
		Shift_Reg[SERIALIZER_WIDTH -2:0]  <= Shift_Reg[SERIALIZER_WIDTH -1:1] ;
	 end
 end

assign ser_done = (Shift_Counter == 4'b0111) ? 1'b1 : 1'b0 ;
assign ser_data = Shift_Reg[0];

always @(posedge CLK, negedge RST)
 begin
	if (!RST)
	 begin
		Shift_Counter <= 'b0;
	 end
	else if (ser_en)
	 begin 
		Shift_Counter <= 'b0 ;
	 end
	else if (!ser_done)
	 begin 
		Shift_Counter <= Shift_Counter + 'b1 ;
	 end
 end


endmodule