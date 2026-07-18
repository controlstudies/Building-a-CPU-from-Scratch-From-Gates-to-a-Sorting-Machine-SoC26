module IR(
input clk,
input write,
input [15:0] instruct,
output reg [15:0] ir 
);
	always@(posedge clk)begin 
	if(write)
		begin
			ir<=instruct;
		end
	end
	
endmodule