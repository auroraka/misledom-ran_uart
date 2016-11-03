`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:09:54 10/25/2016 
// Design Name: 
// Module Name:    ram_full 
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
module ram_full(
    input en, re, we, 
	input [15:0]data_in,
	input wire[16:0]addr,
	output reg done,
	output wire ram1EN, ram2EN, ram1OE, ram2OE, ram1WE, ram2WE,
	output wire [17:0]ram_addr1, ram_addr2,
	inout [15:0]ram_data1, ram_data2,
    output reg [15:0]data_out
    );
	
wire [17:0] addr_17;
wire done1, done2;
wire [15:0]data_out1;
wire [15:0]data_out2;
reg en1=0, en2=0;

assign addr_17[15:0] = addr[15:0];
assign addr_17[16] = 0;
assign addr_17[17] = 0;
	
always @(*)
begin
	if(addr[16]==0)//ram1
		begin
		en1 = 0;
		en2 = 0;
		done = done1;
		data_out = data_out1;
		end
	else//ram2
		begin
		en2 = 0;
		en1 = 0;
		done = done2;
		data_out = data_out2;
		end
end

ram_controller ram_ctrl_1(
	.en(en1), 
	.re(re), 
	.we(we), 
	.data_in(data_in),
	.addr_in(addr_17),
	.ram_en(ram1EN), 
	.ram_oe(ram1OE), 
	.ram_we(ram1WE), 
	.done(done1), 
	.addr(ram_addr1),
	.data_out(data_out1), 
	.data(ram_data1)
);

ram_controller ram_ctrl_2(
	.en(en2), 
	.re(re), 
	.we(we), 
	.data_in(data_in),
	.addr_in(addr_17),
	.ram_en(ram2EN), 
	.ram_oe(ram2OE), 
	.ram_we(ram2WE), 
	.done(done2), 
	.addr(ram_addr2),
	.data_out(data_out2), 
	.data(ram_data2)
);

endmodule
