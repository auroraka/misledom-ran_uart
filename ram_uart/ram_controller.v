`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:09:12 10/25/2016 
// Design Name: 
// Module Name:    ram_controller 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ram_controller(
	input en, re, we, 
	input [15:0]data_in,
	input [17:0]addr_in,
	output reg ram_en, ram_oe, ram_we, done, 
	output reg [17:0]addr,
	output reg [15:0]data_out, 
	inout wire [15:0] data
    );
	
parameter write_establish=3, write_hold=3, write_time=3;
parameter read_reference=3;
parameter done_hold=50;

initial
begin
	ram_en=0;
	ram_oe=1;
	ram_we=1;
	done=0;
end

always @(*)
begin
	addr=addr_in;
	ram_en=en;
end

assign data=we?data_in:16'bz;
always @(re, we)
begin
	if(en==0)data_out=16'b0;
	else
		if(we==1)//write
			begin
				data_out=data_in;
				#write_establish ram_we=0;
				#write_time ram_we=1;
				#write_hold done=1;
				#done_hold done=0;
			end
		else if(re==1)
			begin
				ram_oe=0;
				#read_reference data_out=data;
				ram_oe=1;
				done=1;
				#done_hold done=0;
			end			
end

endmodule
