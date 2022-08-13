module parity_calc #(parameter WIDTH = 8)
(
input	wire 								CLK,
input	wire								RST,
input	wire	[WIDTH-1:0]					P_DATA,
input	wire 								PAR_calc,
input	wire 								PAR_TYP,
output	reg									PAR_BIT
);

reg 	PAR_BIT_Comb;
wire 	even_parity;

assign even_parity = ^P_DATA;

always @(*)
 begin
	if (PAR_TYP)
	 begin
		PAR_BIT_Comb = ~even_parity;
	 end
	else
	 begin
		PAR_BIT_Comb = even_parity;
	 end
 end
 
always @(posedge CLK, negedge RST)
 begin
	if (!RST)
	 begin
		PAR_BIT <= 1'b0;
	 end
	else if (PAR_calc)
	 begin 
		PAR_BIT <= PAR_BIT_Comb ;
	 end
 end

endmodule