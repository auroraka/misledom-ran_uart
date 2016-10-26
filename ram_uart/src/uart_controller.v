module uart_writter(
	input wire tbre,
	input wire tsre,
	input wire data_ready,
	input wire clk11,
	inout wire[7:0] data,
	input wire we,
	input wire re,
	input wire[7:0] data_in,
	
	output reg wrn,
	output reg rdn,
	output reg[7:0] data_out,
	output reg done
);

//typedef enum {WAIT, GO} state_type;
//typedef enum {rstate0,rstate1,rstate2,rstate3,rstate4} rstate;
//typedef enum {wstate0,wstate1,wstate2,wstate3} wstate; 
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
	if (re == '1' && we == '0') begin//read
		case(rstate)
			rstate0:begin
				wrn<='1';
				done<='0';
				rstate<=rstate1;
			end
			rstate1:begin
				data<=data_in;
				wrn<='0';
				rstate<=rstate2;
			end
			rstate2:begin
				wrn<='1';
			end
			rstate3:;
				if (tbre=='1') rstate<=rstate4;
			rstate4:;
				if (tsre=='1') rstate<=rstate0;
				done<='1';
			default:;
		endcase;		
	
	end else if (we=='1' && re=='0') begin//write
		case (wstate) 
			wstate0:begin
				wstate<=wstate1;
			end
			wstate1:begin
				rdn<='1';
				data<={16{z}};
				wstate<=wstate2;
			end
			wstate2:begin
				if (data_ready=='1') begin
					rdn<='0';
					wstate<=wstate3;
				end else begin
					wstate<=wstate1;
				end
			end
			wstate3:begin
				data_out<=data;
				wstate<=wstate1;
			end
		endcase;
	end else begin
		done<='0';
		rstate<=rstate0;
		wstate<=wstate0;
	end
end

endmodule;