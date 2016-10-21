`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:26:24 10/21/2016 
// Design Name: 
// Module Name:    ram_state_machine 
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
module ram_state_machine(
    input wire rst,
    input wire clk,
    input wire en,
    input wire [15:0] sw,
	 input wire [15:0] ram_addr1,
	 inout wire [15:0] ram_data1,
	 input wire [15:0] ram_addr2,
	 inout wire [15:0] ram_data2,
	 input wire ram1OE,
	 input wire ram2OE,
	 input wire ram1WE,
	 input wire ram2WE,
	 input wire ram1EN,
	 input wire ran2EN,
    output reg [15:0] ledout,
    output reg [6:0] dyp0,
    output reg [6:0] dyp1
    );

reg re, we, en_ram, count ;
reg ram_choose ; 
reg [15:0] data_in ;
reg [16:0] data_address ;
reg [2:0] CS, NS ;
wire done ;
wire data_out ;

parameter [2:0] start = 3'd0,
load_data1 = 1,
write_data1 = 2,
incr = 3,
read_out1 = 4,
decr = 5,
write_data2 = 6,
read_out2 = 7 ;

parameter [15:0] zerodata = 16'd0, zeroaddress = 16'd0 ;

always @ (posedge clk or negedge rst)
begin
	if(!rst) CS <= start ;
	else CS <= NS ;
end 

always @ (CS)
begin 
	NS <= start ;
	case(CS)
		start:
		begin
			//ram_choose = 0 ;
		   data_address = {0, sw} ;
		   en_ram = 0 ;
			re = 0 ;
			we = 0 ;
			count = 0 ;
			NS = load_data1 ;
		end
		load_data1:
		begin
			data_in = sw ;
			NS = write_data1 ; 
		end
		write_data1:
		begin
			en_ram = 1 ;
			we = 1 ;
			re = 0 ;
			NS = incr ;
		end
		incr:
		begin
			if(done == 1)
			begin 
				count = count + 1 ;
				//data_address = (data_address + 1)
				//data_address[16] = data_address[16] & 1 ;
				if(count < 10)
				begin
					data_address = (data_address + 1) ;
					data_address[16] = data_address[16] & 0 ;
					data_in = data_in + 1 ;
					//incresement
					NS = write_data1 ;
				end
				else if(count == 10)
				begin
					data_address = data_address - 9 ;
					data_address[16] = data_address[16] & 0 ;
				begin
					
			
	endcase
endmodule
