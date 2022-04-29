`timescale 10ps/1ps
module bfifo_testtwo(
);
reg [3:0] data_in;
wire [3:0] data_out;
reg clk,v_in,r_in,reset;
wire v_out,r_out;
initial begin
	clk = 0;
	forever #10 clk = ~clk;
end
initial begin
	data_in = 0;
	reset = 1;
	#20 reset = 0;
		v_in = 0;
		r_in = 0;
		
	#10 v_in = 1;r_in = 1;data_in = 1;
	#20 v_in = 0;r_in = 0;
		
	#20 v_in = 1;r_in = 1;	data_in = 2;
	#20 v_in = 0;r_in = 0;
		
	#22 v_in = 1;r_in = 1;data_in = 3;	
	#20 v_in = 0;r_in = 0;
		
	#16 data_in = 4;v_in = 1;r_in = 1;	
	#20 v_in = 0;r_in = 0;
	
	#20 v_in = 1;r_in = 1;data_in = 5;
	#20 v_in = 0;r_in = 0;
	
	#20 v_in = 1;r_in = 1;	data_in = 6;
	#20 v_in = 0;r_in = 0;
	
end
bfifo a(data_in,reset,v_in,r_in,clk,data_out,v_out,r_out);
endmodule	
module bfifo(
	input [3:0] data_in,
	input reset,
	input v_in,
	input r_in,
	input clk,
	output reg [3:0] data_out,
	output v_out,
	output r_out
);
reg full,vreg,rreg;
reg [3:0] data_reg;
always@(posedge v_in)begin
	vreg <= v_in;
end
always@(posedge r_in)begin
	rreg <= r_in;
end
always@(posedge clk)begin
	if(reset)begin
		vreg <= 0;
		full <= 0;
		data_reg <= 0;
	end
	if((~full)&(vreg|v_in))begin
		data_reg <= data_in;
		vreg <= 0;
		full <= 1;
	end
	else
		full <= full;
end
always@(posedge clk)begin
	if(reset)begin
		rreg <= 0;
		full <= 0;
		data_out <= 0;
	end
	if(full&(rreg|r_in))begin
		data_out <= data_reg;
		rreg <= 0;
		full <= 0;
	end
end
assign v_out = full;
assign r_out = ~full;
endmodule
