module Aluc( 
	input [1:0] aluscrb,
	input [1:0]aluop,
	input aluscra,
	input [15:0]A,B,
	input [15:0] ir,
	input [5:0] pcout,
	output reg [15:0] a,b,
	output reg [2:0] op
);
wire [3:0] opcode = ir[15:12];
always@(*)begin 
	case(aluscrb) 
		0:b=B;
		1:b=1;
		2:b = {8'b0,ir[7:0]};
		3:b = 8'd0;
		endcase
	case (aluscra) 
		0:a={10'b0,pcout};
		1:a=A;
		endcase
end
always@(*)begin 
	case(aluop)
		0:op=3'b000;
		1:op=3'b001;
		2:begin 
			case (opcode) 
				4'd3: op = 3'b111; 
				4'd5: op = 3'b000;
				4'd7: op = 3'b001; 
				4'd13:op= 3'b001;
			endcase
		end
	endcase
end
endmodule