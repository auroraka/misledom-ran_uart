`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:51:31 10/26/2016
// Design Name:   ram_full
// Module Name:   F:/2016FALL/JY/hw/prj3/ram_uart/ram_uart/ram_full_test.v
// Project Name:  ram_uart
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ram_full
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ram_full_test;

	// Inputs
	reg en;
	reg re;
	reg we;
	reg [15:0] data_in;
	reg [16:0] addr;

	// Outputs
	wire done;
	wire ram1EN;
	wire ram2EN;
	wire ram1OE;
	wire ram2OE;
	wire ram1WE;
	wire ram2WE;
	wire [17:0] ram_addr1;
	wire [17:0] ram_addr2;
	wire [15:0] data_out;

	// Bidirs
	wire [15:0] ram_data1;
	wire [15:0] ram_data2;

	// Instantiate the Unit Under Test (UUT)
	ram_full uut (
		.en(en), 
		.re(re), 
		.we(we), 
		.data_in(data_in), 
		.addr(addr), 
		.done(done), 
		.ram1EN(ram1EN), 
		.ram2EN(ram2EN), 
		.ram1OE(ram1OE), 
		.ram2OE(ram2OE), 
		.ram1WE(ram1WE), 
		.ram2WE(ram2WE), 
		.ram_addr1(ram_addr1), 
		.ram_addr2(ram_addr2), 
		.ram_data1(ram_data1), 
		.ram_data2(ram_data2), 
		.data_out(data_out)
	);

	initial begin
		// Initialize Inputs
		en = 0;
		re = 0;
		we = 0;
		data_in = 0;
		addr = 0;

		// Wait 100 ns for global reset to finish
		#100;
      en = 1;
		data_in = 16'b1110;
		addr = 17'b0101;
		//write1
		we = #10 1;
		//read1
		we = #100 0;
		re = 1;
		//write 2
		addr[16] = #20 1;
		re = #100 0;
		we = 1;
		//read2
		we = #100 0;
		re = 1;
		
	end
      
endmodule

