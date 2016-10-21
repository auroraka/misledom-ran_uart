module uart_writter(
	input wire tbre,
	input wire tsre,
	input wire clk11,
	input wire we,
	input wire[7:0] data_in,
	
	output reg wrn,
	output reg[7:0] data_out,
	output reg done
);

enum {state0,state1,state2,state3,state4} state;

wire clk;
integer cnt=0;

always @ (posedge clk11) begin
	if (cnt<50) begin
		cnt=cnt+1;
	end else begin
		cnt=0;
		clk=~clk;	
	end
end

always @ (posedge clk) begin
	if (we=='0') begin
		state<=state0;
		wrn<='1';
		done<='0';
	end else begin
		case(state)
			state0:begin
				data_out<=data_in;
				wrn<='0';
				state<=state1;
			end
			state1:begin
				wrn<='1';
				state<=state2;
			end
			state2:begin
				if (tbre=='1') state<=state3;
			end
			state3:;
				if (tsre=='1') state<=state4;
			state4:;
				state<=state0;
			default:;
		endcase;		
	end
end

endmodule;