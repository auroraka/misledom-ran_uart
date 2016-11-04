module machine_switcher(
   input wire rst,
   input wire clk,
   input wire [15:0] sw,
	output wire [17:0] ram_addr1,
	inout [15:0] ram_data1,
	output wire [17:0] ram_addr2,
	inout [15:0] ram_data2,
	output wire ram1OE,
	output wire ram2OE,
	output wire ram1WE,
	output wire ram2WE,
	output wire ram1EN,
	output wire ram2EN,
   	output reg [15:0] led,
   	output wire [6:0] dyp0,
   	output wire [6:0] dyp1,
   	output wire rdn,
   	output wire wrn,
	input wire data_ready,
	input wire tbre,
	input wire tsre,
	input wire[3:0] key
);

wire rst_r;
wire clk_r;
wire en_r;
wire [15:0] sw_r;
wire [17:0] ram_addr1_r;
reg [15:0] ram_data1_r;
wire [17:0] ram_addr2_r;
reg [15:0] ram_data2_r;
wire ram1OE_r;
wire ram2OE_r;
wire ram1WE_r;
wire ram2WE_r;
wire ram1EN_r;
wire ram2EN_r;
wire [15:0] ledout_r;
wire [6:0] dyp0_r;
wire [6:0] dyp1_r;
wire rdn_r;
wire wrn_r;

assign rst_r=key[3]==0?rst:0;
assign clk_r=key[3]==0?clk:0;
assign en_r=key[3]==0?0:1;
assign sw_r=key[3]==0?sw:0;
assign ram_addr1_r=key[3]==0?ram_addr1:0;
//assign ram_data1_r=key[3]==0?ram_data1:0;
assign ram_addr2_r=key[3]==0?ram_addr2:0;
//assign ram_data2_r=key[3]==0?ram_data2:0;
assign ram1OE_r=key[3]==0?ram1OE:0;
assign ram2OE_r=key[3]==0?ram2OE:0;
assign ram1WE_r=key[3]==0?ram1WE:0;
assign ram2WE_r=key[3]==0?ram2WE:0;
assign ram1EN_r=key[3]==0?ram1EN:0;
assign ram2EN_r=key[3]==0?ram2EN:0;
assign ledout_r=key[3]==0?led:0;
assign dyp0_r=key[3]==0?dyp0:0;
assign dyp1_r=key[3]==0?dyp1:0;
assign rdn_r=key[3]==0?rdn:0;
assign wrn_r=key[3]==0?wrn:0;


ram_state_machine ram_state_machine0(
	.rst(rst_r),
   .clk(clk_r),
   .en(en_r),
   .sw(sw_r),
	.ram_addr1(ram_addr1_r),
	.ram_data1(ram_data1),
	.ram_addr2(ram_addr2_r),
	.ram_data2(ram_data2),
	.ram1OE(ram1OE_r),
	.ram2OE(ram2OE_r),
	.ram1WE(ram1WE_r),
	.ram2WE(ram2WE_r),
	.ram1EN(ram1EN_r),
	.ram2EN(ram2EN_r),
   .ledout(ledout_r),
   .dyp0(dyp0_r),
   .dyp1(dyp1_r),
   .rdn(rdn_r),
   .wrn(wrn_r)
 );

wire clk_u;
wire rst_u;
wire data_ready_u;
wire tbre_u;
wire tsre_u;
reg[7:0] data_u;
wire[1:0] mode_u;
wire[7:0] data_in_u;
wire wrn_u;
wire rdn_u;
wire[7:0] data_out_u;
wire ram1_oe_u;
wire ram1_we_u;
wire ram1_en_u;
wire[6:0] seg_show_u;

assign clk_u=key[3]==1?clk:0;
assign rst_u=key[3]==1?rst:0;
assign data_ready_u=key[3]==1?data_ready:0;
assign tbre_u=key[3]==1?tbre:0;
assign tsre_u=key[3]==1?tsre:0;
//assign data_u=key[3]==1?ram_data1[7:0]:0;
assign mode_u=key[3]==1?sw[1:0]:0;
assign data_in_u=key[3]==1?sw[15:8]:0;
assign wrn_u=key[3]==1?wrn:0;
assign rdn_u=key[3]==1?rdn:0;
assign data_out_u=key[3]==1?led[7:0]:0;
assign ram1_oe_u=key[3]==1?ram1OE:0;
assign ram1_we_u=key[3]==1?ram1WE:0;
assign ram1_en_u=key[3]==1?ram1EN:0;
assign seg_show_u=key[3]==1?dyp0:0;

// always @ (*) begin
// 	if (key[3]==0) begin
// 		ram_data1_r<=ram_data1;
// 		ram_data2_r<=ram_data2;
// 		data_u<=0;
// 	end else begin
// 		ram_data1_r<=0;
// 		ram_data2_r<=0;
// 		data_u<=ram_data1[7:0];
// 	end
// end

 uart_controller uart_controller0(
	.clk(clk_u),
	.rst(rst_u),
	.data_ready(data_ready_u),
	.tbre(tbre_u),
	.tsre(tsre_u),
	//.data(data_u),
	.mode(mode_u),
	.data_in(data_in_u),
	.wrn(wrn_u),
	.rdn(rdn_u),
	.data_out(data_out_u),
	.ram1_oe(ram1_oe_u),
	.ram1_we(ram1_we_u),
	.ram1_en(ram1_en_u),
	.seg_show(seg_show_u)
);

endmodule