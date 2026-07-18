module flags(
input clk,
input we,
input zin,
input cin,
input oin,
output reg zout,
output reg cout,
output reg oout
);
always @(posedge clk)begin
if(we) begin 
zout<=zin;
cout<=cin;
oout<=oin;
end
end

endmodule