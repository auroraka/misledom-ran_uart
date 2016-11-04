module uart_controller(
	input wire clk,
	input wire rst,
	input wire data_ready,
	input wire tbre,
	input wire tsre,
	inout wire[7:0] data,
	input wire[1:0] mode,
	input wire[7:0] data_in,

	output reg wrn,
	output reg rdn,
	output reg[7:0] data_out,
	output reg ram1_oe,
	output reg ram1_we,
	output reg ram1_en,
	output wire[6:0] seg_show
);

integer state;
reg[7:0] tmp_data=8'b0;
integer cnt=0;

reg[7:0] data_write;
reg[7:0] data_read;

reg readFlag;

seg_displayer seg_displayer0(
	.isHex(1),
	.num({2'b00,mode}),
	.seg(seg_show)
);

assign data=(readFlag==1)?{8{1'bz}}:data_write;

always @ (state,mode) begin
	if (readFlag) begin
		data_read<=data;
	end
end


always @ (posedge clk or negedge rst) begin
	if (rst==0) begin 
		state<=0;
		data_out<=8'b0;
		ram1_en<=1;
		ram1_we<=1;
		ram1_oe<=1;
		cnt=0;
	end else begin
		if (cnt == 1023) begin 
			if (mode ==	2'b00) begin
					//mode_out2<=2'b00;
					case (state) 
						0:begin 
							wrn<=1;
							ram1_en<=1;
							ram1_oe<=1;
							ram1_we<=1;
							state<=1;
							readFlag=0;
						end
						1:begin 
							data_write<=data_in;
							wrn<=0;
							state<=2;
						end
						2:begin 
							wrn<=1;
							state<=3;
						end
						3:begin 
							if (tbre==1) begin 
								state<=4;
							end
 						end
 						4:begin
 							if (tsre==1) begin 
 								//state<=0;
 							end
 						end
						default:;
					endcase
			end else if (mode ==2'b01) begin
					//mode_out2<=2'b01;
					case (state)
						0:begin 
							ram1_oe<=1;
							ram1_we<=1;
							ram1_en<=1;
							state<=1;
						end
						1:begin 
							data_write<={8{1'bz}};
							rdn<=1;
							state<=2;
						end
						2:begin
							if (data_ready==1) begin
								rdn<=0;
								state<=3;
							end else if (data_ready== 0 )begin 
								state<=1;
							end
							readFlag=1;
						end
						3:begin
							data_out<=data_read;
							state<=1;
						end

						default : begin
							state<=0;
						end
					endcase
			end else if (mode == 2'b11) begin 
					//mode_out2<=2'b11;
					case (state)
						0:begin 
							ram1_we<=1;
							ram1_oe<=1;
							ram1_en<=1;
							wrn<=1;
							state<=1;
						end
						1:begin 
							rdn<=1;
							data_write<={8{1'bz}};
							state<=2;
						end
						2:begin 
							if (data_ready==1) begin 
								rdn<=0;
								state<=3;
							end else begin 
								state<=1;
							end
							readFlag=1;
						end
						3:begin 
							data_out<=data_read;
							tmp_data<=data_read;
							rdn<=1;
							wrn<=1;
							state<=4;
						end
						4:begin 
							tmp_data<=tmp_data+1;
							state<=5;
						end
						5:begin 
							readFlag=0;
							wrn<=0;
							data_write<=tmp_data;
							data_out<=tmp_data;
							state<=6;
						end
						6:begin 
							wrn<=1;
							state<=7;
						end
						7:begin 
							if (tbre==1) begin 
								state<=8;
							end
						end
						8:begin
							if (tsre ==1) begin 
								state<=0;
							end
						end
						default :;
					endcase
			end
			cnt=0;
		end else begin
			if (cnt <1023) begin 
				cnt=cnt+1;
			end
		end
	end
end

endmodule