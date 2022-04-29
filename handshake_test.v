`timescale 10ps/1ps
module handshake_test(
);
reg [3:0] data_in;
wire [3:0] data_out;
reg clk,valid,ready;

initial begin
	clk = 0;
	forever #5 clk = ~clk;
end
initial begin
	#15 data_in = 0;
	forever #20 data_in = data_in+1;
end
initial begin
	#15 valid=1;ready=1;#10 valid=0;ready=0;
	#10 valid=1;ready=1;#10 valid=0;ready=0;//normal test
	#10 valid=1;ready=1;#10 valid=0;ready=0;
	#10 valid=1;#5 ready=1;#5 valid=0;ready=0;//valid wait for ready
	#10 valid=1;ready=1;#10 valid=0;ready=0;
	#10 ready=1;#5 valid=1;#5 valid=0;ready=0;//ready wait for test
	#10 valid=1;ready=1;#5 valid=0;ready=0;//increase lasting time of valid and ready
	#10 valid=1;ready=1;#5 valid=0;ready=0;
	#25 valid=1;ready=1;#5 valid=0;ready=0;//asynchronous test
	#15 valid=1;ready=1;#5 valid=0;ready=0;
	#10 valid=1;#5 valid=0;#5 ready=1;#5 ready=0;//valid then ready
	#5 ready=1;#2 ready=0;#2 valid=1;#2 valid=0;//ready then valid with short lasting time
	#14 valid=1;#2 valid=0;#2 ready=1;#2 ready=0;//valid then ready with short lasting time
	#14 valid=1;#8 ready=1;#12 ready=0;valid=0;//valid wait for ready
	
end
afifo a(data_in,valid,ready,clk,data_out);
endmodule	
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

