`timescale 1ns / 1ns

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:16:40 10/25/2016
// Design Name:   ram_controller
// Module Name:   F:/2016FALL/JY/hw/prj3/ram_uart/ram_uart/ram_ctrl_test.v
// Project Name:  ram_uart
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ram_controller
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ram_ctrl_test;

	// Inputs
	reg en;
	reg re;
	reg we;
	reg [15:0] data_in;
	reg [17:0] addr_in;

	// Outputs
	wire ram_en;
	wire ram_oe;
	wire ram_we;
	wire done;
	wire [17:0] addr;
	wire [15:0] data_out;
	wire [15:0] data;

	// Instantiate the Unit Under Test (UUT)
	ram_controller uut (
		.en(en), 
		.re(re), 
		.we(we), 
		.data_in(data_in), 
		.addr_in(addr_in), 
		.ram_en(ram_en), 
		.ram_oe(ram_oe), 
		.ram_we(ram_we), 
		.done(done), 
		.addr(addr), 
		.data_out(data_out), 
		.data(data)
	);

	initial begin
		// Initialize Inputs
		en = 0;
		re = 0;
		we = 0;
		data_in = 0;
		addr_in = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		en = 1;
		data_in = 16'b1110;
		addr_in = 18'b0101;
		we = #10 1;
		//read
		we = #100 0;
		re = 1;
		
	end
      
endmodule

