module uart_reader(
	input wire data_ready,
	inout wire[7:0] data_in,
	input wire clk11,
	input wire re,
	
	output reg rdn,
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
	if (re=='0') begin
		state<=state0;
		rdn<='1';
		data_out<={8{z}};
	end else begin
		case(state)
			state0:begin
				state<=state1;
			end
			state1:begin
				state<=state2;
			end
			state2:begin
				state<=state3;
			end
			state3:;
				state<=state4;
			state4:;
				state<=state0;
			default:;
		endcase;		
	end
end

endmodule;