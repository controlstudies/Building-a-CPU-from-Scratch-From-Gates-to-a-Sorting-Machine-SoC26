module mdr(
input clk,
input [15:0]dmem_out,
output reg [15:0] mem
);

always@(posedge clk)begin 
mem<=dmem_out;
end

endmodule