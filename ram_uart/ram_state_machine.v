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
	input wire ram2EN,
    output reg [15:0] ledout,
    output reg [6:0] dyp0,
    output reg [6:0] dyp1
    );

reg re, we, en_ram, count ;
reg ram_choose ; 
reg [15:0] data_in, data_out ;
reg [16:0] data_address ;
reg [3:0] CS, NS ;
wire done ;
wire data_out ;

parameter [3:0] start = 4'd0,
load_data1 = 1,
write_data1 = 2,
read_out1 = 3,
write_data2 = 4,
read_out2 = 5 ;


always @ (posedge clk or negedge rst)
begin
	if(en == 0) CS <= start ;
	if(!rst) CS <= start ;
	else CS <= NS ;
end 

always @ (CS)
begin 
	NS = start ;
	case(CS)
		start:
		begin
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
			re = 0 ;
			we = 1 ;
			en_ram = 1 ;
			wait(done == 1) ;
			count = count + 1 ;
			if(count >= 10) NS = read_out1 ;
			else
			begin
				data_in = data_in + 1 ;
				data_address = data_address + 1 ;
				data_address[16] = data_address[16] & 0 ; // increase data and address
				NS = write_data1 ;
			end
		end		
		read_out1:
		begin
			we = 0 ;
			re = 1 ;
			//en_ram = 1 ;
			if(count == 10)
			begin
				data_address = data_address - 9 ;
				data_address[16] = data_address[16] & 0 ; // the initial address
			end
			else
			begin
				data_address = data_address + 1 ;
				data_address[16] = data_address[16] & 0 ;
			end
			wait(done == 1) ; // wait for read data to dataout finish
			count = count + 1 ;
			if(count >= 20) NS = write_data2 ;
			else NS = read_out1 ;
		end
		write_data2 :
		begin 
			we = 0 ;
			re = 1 ;
			//en_ram = 1 ;
			wait(done) ; // read from ram1
			re = 0 ;
			we = 1 ;
			//en_ram = 1 ;
			data_address[16] = data_address[16] & 1 ;
			data_in = data_out - 1 ;
			wait(done) ;
			count = count + 1 ;
			if(count >= 30) NS = read_out2 ;
			else
			begin
				data_address = data_address - 1 ;
				data_address[16] = data_address[16] & 0 ; // decrease the address
				NS = write_data2 ;
			end 
		end
		read_out2:
		begin
			we = 0 ;
			re = 1 ;
			if(count > 30)
			begin
				data_address = data_address + 1 ;
				data_address[16] = data_address[16] & 1 ; // increase the address
			end
			else data_address[16] = data_address[16] & 1 ; // remain at first
			wait(done) ;// wait for read data to data_out ;
			count = count + 1 ;
			if(count >= 40) NS = start ;
			else
			begin
				//data_address = data_address + 1 ;
				//data_address[16] = data_address[16] & 1 ; // increase the address
				NS = read_out2 ;
			end
		end
		default: NS = start ;
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

always @ (CS)
begin
	case(CS)
		start: 
		begin
			dyp0 <= 7'b0000001 ;
			dyp1 <= {4'b0000, en_ram, re, we} ;
		end
		write_data1: 
		begin
			dyp0 <= 7'b0000010 ;
			dyp1 <= {4'b0000, en_ram, re, we} ;
		end
		read_out1:
		begin
			dyp0 <= 7'b0000100 ;
			dyp1 <= {4'b0000, en_ram, re, we} ;
		end
		write_data2:
		begin
			dyp0 <= 7'b0001000 ;
			dyp1 <= {4'b0000, en_ram, re, we} ;
		end
		read_out2:
		begin
			dyp0 <= 7'b0010000 ;
			dyp1 <= {4'b0000, en_ram, re, we} ;
		end
		default:
		begin
			dyp0 <= 7'b0000000 ;
			dyp1 <= 7'b0000000 ;
		end
	endcase	
end

ramcontroller ramcontroller(
	.en(en_ram),
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
	.ram_data2(ram_data2),
) ; // need to confirm the ram_controller module
endmodule
