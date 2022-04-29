module handshake(
	input [3:0] data_in,
	input valid,
	input ready,
	input clk,
	output reg [3:0] data_out
);
reg vreg,rreg;
always@(posedge valid)begin
	vreg <= valid;//valid regged
end
always@(posedge ready)begin
	rreg <= ready;//ready regged
end
always@(posedge clk)begin
	if((vreg|valid)&(rreg|ready))begin
		data_out <= data_in;//data_in = data_out
		vreg <= 0;//reset vreg
		rreg <= 0;//reset rreg
	end
end
endmodule


