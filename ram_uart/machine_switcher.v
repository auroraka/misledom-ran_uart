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

wire rst_r=key[3]==0?rst:0;
wire clk_r=key[3]==0?clk:0;
wire en_r=key[3]==0?1:0;
wire [15:0] sw_r=key[3]==0?sw:0;
wire [17:0] ram_addr1_r=key[3]==0?ram_addr1:0;
reg [15:0] ram_data1_r;//=key[3]==0?ram_data1:0;
wire [17:0] ram_addr2_r=key[3]==0?ram_addr2:0;
reg [15:0] ram_data2_r;
//=key[3]==0?ram_data2:0;
wire ram1OE_r=key[3]==0?ram1OE:0;
wire ram2OE_r=key[3]==0?ram2OE:0;
wire ram1WE_r=key[3]==0?ram1WE:0;
wire ram2WE_r=key[3]==0?ram2WE:0;
wire ram1EN_r=key[3]==0?ram1EN:0;
wire ram2EN_r=key[3]==0?ram2EN:0;
wire [15:0] ledout_r=key[3]==0?led:0;
wire [6:0] dyp0_r=key[3]==0?dyp0:0;
wire [6:0] dyp1_r=key[3]==0?dyp1:0;
wire rdn_r=key[3]==0?rdn:0;
wire wrn_r=key[3]==0?wrn:0;

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

wire clk_u=key[3]==1?clk:0;
wire rst_u=key[3]==1?rst:0;
wire data_ready_u=key[3]==1?data_ready:0;
wire tbre_u=key[3]==1?tbre:0;
wire tsre_u=key[3]==1?tsre:0;
reg[7:0] data_u;
//=key[3]==1?ram_data1[7:0]:0;
wire[1:0] mode_u=key[3]==1?sw[1:0]:0;
wire[7:0] data_in_u=key[3]==1?sw[15:8]:0;

wire wrn_u=key[3]==1?wrn:0;
wire rdn_u=key[3]==1?rdn:0;
wire[7:0] data_out_u=key[3]==1?led[7:0]:0;
wire ram1_oe_u=key[3]==1?ram1OE:0;
wire ram1_we_u=key[3]==1?ram1WE:0;
wire ram1_en_u=key[3]==1?ram1EN:0;
wire[6:0] seg_show_u=key[3]==1?dyp0:0;

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

// always @ (*) begin
// 	if (key[3]==0) begin 
// 		//ram
// 		rst_r<=rst;
// 		clk_r<=clk;
// 		en_r<=1'b1;
// 		sw_r<=sw;
// 		ram_addr1_r<=ram_addr1;
// 		ram_data1_r<=ram_data1;
// 		ram_addr2_r<=ram_addr2;
// 		ram_data2_r<=ram_data2;
// 		ram1OE_r<=ram1OE;
// 		ram2OE_r<=ram2OE;
// 		ram1WE_r<=ram1WE;
// 		ram2WE_r<=ram2WE;
// 		ram1EN_r<=ram1EN;
// 		ram2EN_r<=ram2EN;
// 		ledout_r<=led;
// 		dyp0_r<=dyp0;
// 		dyp1_r<=dyp1;
// 		rdn_r<=rdn;
// 		wrn_r<=wrn;

// 		//uart
// 		clk_u<=0;
// 		rst_u<=0;
// 		data_ready_u<=0;
// 		tbre_u<=0;
// 		tsre_u<=0;
// 		data_u<=0;
// 		mode_u<=0;
// 		data_in_u<=0;
// 		wrn_u<=0;
// 		rdn_u<=0;
// 		data_out_u<=0;
// 		ram1_oe_u<=0;
// 		ram1_we_u<=0;
// 		ram1_en_u<=0;
// 		seg_show_u<=0;
// 	end else begin
// 		rst_r<=0;
// 		clk_r<=0;
// 		en_r<=0;
// 		sw_r<=0;
// 		ram_addr1_r<=0;
// 		ram_data1_r<=0;
// 		ram_addr2_r<=0;
// 		ram_data2_r<=0;
// 		ram1OE_r<=0;
// 		ram2OE_r<=0;
// 		ram1WE_r<=0;
// 		ram2WE_r<=0;
// 		ram1EN_r<=0;
// 		ram2EN_r<=0;
// 		ledout_r<=0;
// 		dyp0_r<=0;
// 		dyp1_r<=0;
// 		rdn_r<=0;
// 		wrn_r<=0;

// 		clk_u<=clk;
// 		rst_u<=rst;
// 		data_ready_u<=data_ready;
// 		tbre_u<=tbre;
// 		tsre_u<=tsre;
// 		data_u<=ram_data1[7:0];
// 		mode_u<=sw[1:0];
// 		data_in_u<=sw[15:8];
// 		wrn_u<=wrn;
// 		rdn_u<=rdn;
// 		data_out_u<=led[7:0];
// 		ram1_oe_u<=ram1OE;
// 		ram1_we_u<=ram1WE;
// 		ram1_en_u<=ram1EN;
// 		seg_show_u<=dyp0;
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