module uart_state_machine(
	input wire clk11,
	input wire clk,
	input wire rst,
	input wire[3:0] key
	input wire[15:0] sw,
	inout[7:0] data,
	input wire tbre,
	input wire tsre,
	input wire data_ready,
	
	output reg ram_we,
	output reg ram_oe,
	output reg ram_en,
	output reg led[15:0],
	output reg wrn,
	output reg rdn
	output reg[6:0] show_seg;
);

assign ram_we='1';
assign ram_oe='1';
assign ram_en='1';

reg we,re;
reg[15:0] data_in;
wire[15:0] data_out;
wire done;

uart_controller0 uart_controller(
	.tbre(tbre),
	.tsre(tsre),
	.data_ready(data_ready),
	.clk11(clk11),
	.data(data),
	.we(we),
	.re(re),
	.data_in(data_in),
	.wrn(wrn),
	.rdn(rdn),
	.data_out(data_out),
	.done(done)	
);

reg[3:0] show_num;

seg0 seg(
	isHex('1'),
	num(show_num),
	seg(show_seg)
);

always @ (*) begin
	if (rst == '1') begin
		we<='0';
		re<='0';
	end
end

enum {state_rec_data,state_send_data,state_rec_add_data} state;

always @ (*) begin
	case (state) 
		state_rec_data:		show_num<=4'b0000;
		state_send_data:	show_num<=4'b0001;
		state_rec_add_data:	show_num<=4'b0010;
		default:			show_num<=4'b1111;
	endcase;
end

always @ (posedge key[0]) begin
	case (state) 
		state_rec_data:		state<=state_send_data;
		state_send_data:	state<=state_rec_add_data;
		state_rec_add_data:	state<=state_rec_data;
		default:			state<=state_rec_data;
	endcase;
end

always @ (posedge clk) begin
	case (state) 
		state_rec_data:begin
			we<='0';
			re<='1';
			@(posedge done);//wait for done
			led<=data_out;
			re<='0' #10;
		end
		state_send_data:begin
			re<='0';
			data_in<=sw;
			we<='1';
			@(posedge done);//wait for done
			we<='0' #10;
		end
		state_rec_add_data:begin
			we<='0';
			re<='1';
			@(posedge done);//wait for done
			data_in<=data_out+1'b1;
			re<='0';
			we<='1';
			led<=data_out+1'b1;
			@(posedge done);
			re<='0';
			we<='0' #10;
		end
	endcase;
end

endmodule;