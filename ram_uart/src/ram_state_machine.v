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
	output wire [17:0] ram_addr1,
	inout wire [15:0] ram_data1,
	output wire [17:0] ram_addr2,
	inout wire [15:0] ram_data2,
	output wire ram1OE,
	output wire ram2OE,
	output wire ram1WE,
	output wire ram2WE,
	output wire ram1EN,
	output wire ram2EN,
   output reg [15:0] ledout,
   output wire [6:0] dyp0,
   output wire [6:0] dyp1
    );

reg re, we, count ;
reg ram_choose ; 
reg [15:0] data_in ;
reg [16:0] data_address ;
reg [3:0] CS, NS ;
wire done ;
wire [15:0] data_out ;

parameter [3:0] start = 4'd0,
load_data1 = 1,
write_data1 = 2,
incre1 = 3, 
read_out1 = 4,
incre2 = 5,
read_before_write = 6,
decr = 7,
write_data2 = 8,
incre3 = 9,
read_out2 = 10,
incre4 = 11 ;

always @ (posedge clk or negedge rst or posedge done)
begin
	//if(!rst || !en) CS <= start ;
	if(!rst) CS <= start ;
	else
		CS <= start ;
end 

always @ (CS)
begin 
	NS = start ;
	case(CS)
		start:
		begin
		   //en_ram = 0 ;
		   re = 0 ;
		   we = 0 ;
		   count = 0 ;
		   data_address = {0, sw} ;
		   NS = load_data1 ;
		end
		load_data1:
		begin
			data_in = sw ;
			NS = write_data1 ; 
		end
		write_data1:
		begin
			we = 1 ;
			//en_ram = 1 ;
			NS = incre1 ;
		end
		incre1:
		begin
			we = 0 ;
			count = count + 1 ;
			if(count <= 9)
			begin
				data_in = data_in + 1 ;
				data_address = data_address + 1 ;
				data_address[16] = data_address[16] & 0 ; // increase data and address
				NS = write_data1 ;
			end
			else
			begin
				data_address = data_address - 9 ;
				data_address[16] = data_address[16] & 0 ; // the initial address
				NS = read_out1 ;
			end
		end
		read_out1:
		begin
			re = 1 ;
			NS = incre2 ;
		end
		incre2:
		begin
			re = 0 ;
			count = count + 1 ;
			if(count <= 19)
			begin
				data_address = data_address + 1 ;
				data_address[16] = data_address[16] & 0 ; // increase address1
				NS = read_out1 ;
			end
			else
			begin
				data_address = data_address - 9 ;
				data_address[16] = data_address[16] & 0 ;
				NS = read_before_write ;
			end
		end
		read_before_write:
		begin
			re = 1 ;
			NS = decr ;
		end
		decr:
		begin
			re = 0 ;
			data_in = data_out - 1; 
			data_address[16] = data_address[16] & 1 ;
			NS = write_data2 ;
		end
		write_data2:
		begin
			we = 1 ;
			NS = incre3 ;
		end
		incre3:
		begin
			we = 0 ;
			count = count + 1 ;
			if(count <= 29)
			begin
				data_address = data_address + 1 ;
				data_address[16] = data_address[16] & 0 ;
				NS = read_before_write ;
			end
			else
			begin
				data_address = data_address - 9 ;
				data_address[16] = data_address[16] & 1 ;
				NS = read_out2 ;
			end
		end
		read_out2:
		begin
			re = 1 ;
			NS = incre4 ;
		end
		incre4:
		begin
			re = 0 ;
			count = count + 1 ;
			if(count <= 30)
			begin
				data_address = data_address + 1 ;
				data_address[16] = data_address[16] & 1 ;
				NS = read_out2 ;
			end
			else
			begin
				NS = start ;
			end
		end
	endcase
end

always @ (CS)
begin
	case(CS)
		start: ledout <= data_address[15:0] ;
		load_data1: ledout <= data_in ;
		write_data1: 
		begin
			ledout[15:8] <= data_address[7:0] ;
			ledout[7:0] <= data_in[7:0] ;
		end
		read_out1:
		begin
			ledout[15:8] <= data_address[7:0] ;
			ledout[7:0] <= data_out[7:0] ;
		end
		write_data2:
		begin
			ledout[15:8] <= data_address[7:0] ;
			ledout[7:0] <= data_in[7:0] ;
		end
		read_out2:
		begin
			ledout[15:8] <= data_address[7:0] ;
			ledout[7:0] <= data_out[7:0] ;
		end
		default: ledout <= 16'b0000000000000000 ;
	endcase
end

seg_displayer seg_displayer0(
	.isHex(1),
	.num(CS),
	.seg(dyp0)
) ;

seg_displayer seg_displayer1(
	.isHex(1),
	.num(CS),
	.seg(dyp1)
) ;

ram_full ram_full(
	.en(en),
	.re(re),
	.we(we),
	.data_in(data_in),
	.addr(data_address),
	.done(done),
	.data_out(data_out),
	.ram1EN(ram1EN),
	.ram2EN(ram2EN),
	.ram1OE(ram1OE),
	.ram2OE(ram2OE),
	.ram1WE(ram1WE),
	.ram2WE(ram2WE),
	.ram_addr1(ram_addr1),
	.ram_data1(ram_data1),
	.ram_addr2(ram_addr2),
	.ram_data2(ram_data2)
) ; // need to confirm the ram_controller module
endmodule