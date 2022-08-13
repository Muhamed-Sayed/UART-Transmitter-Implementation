module UART_TX #(parameter WIDTH = 8)
(
input	wire 								CLK,
input	wire								RST,
input	wire								DATA_VALID,
input	wire 								PAR_EN,
input	wire 								PAR_TYP,
input	wire		[WIDTH-1:0]				P_DATA,

output	wire									TX_OUT,
output	wire 									Busy

);

wire			 Ser_EN, Ser_Done, ser_DATA, Parity_Calc;
wire	[1:0]	 MUX_sel;


TX_FSM	 U1 
(
.CLK(CLK),
.RST(RST),
.Data_Valid(DATA_VALID),
.PAR_en(PAR_EN),
.ser_done(Ser_Done),

.ser_en(Ser_EN),
.PAR_calc(Parity_Calc),
.busy(Busy),
.mux_sel(MUX_sel)

);

Serializer #(.SERIALIZER_WIDTH(WIDTH)) U2
(
.CLK(CLK),
.RST(RST),
.P_DATA(P_DATA),
.ser_en(Ser_EN),

.ser_done(Ser_Done),
.ser_data(ser_DATA)
);

parity_calc #(.WIDTH(WIDTH)) U3 
(
.CLK(CLK),
.RST(RST),
.P_DATA(P_DATA),
.PAR_calc(Parity_Calc),
.PAR_TYP(PAR_TYP),

.PAR_BIT(PAR_BIT)
);

Mux 	U4 
(
.CLK(CLK),
.RST(RST),
.ser_data(ser_DATA),
.PAR_BIT(PAR_BIT),
.mux_sel(MUX_sel),

.TX_OUT(TX_OUT)
);

endmodule