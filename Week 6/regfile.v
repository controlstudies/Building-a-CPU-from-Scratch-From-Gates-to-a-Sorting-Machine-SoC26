// Week 2 — Register File (4 x 8-bit)
// regs[0]=A, regs[1]=B, regs[2]=C, regs[3]=D
// Reads: asynchronous | Write: synchronous, gated by we
// Run: iverilog -o sim ../testbenches/tb_regfile.v regfile.v && vvp sim

module regfile(
    input        clk, we,
    input  [1:0] raddr0, raddr1, waddr,
    input  [15:0] wdata,
    output [15:0] rdata0, rdata1
);
    reg [15:0] regs [3:0]; //4 registers, each 2 bytes wide 
		integer i;

initial begin
    for (i = 0; i < 4; i = i + 1)
        regs[i] = 16'd0;
end
    always @(posedge clk) begin
        if (we) begin// synchronus part
            // YOUR CODE HERE — write wdata to regs[waddr]
				regs[waddr] <=wdata;
		  end
    end

    // YOUR CODE HERE — assign rdata0 and rdata1 from regs\
    // assign rdata0 = ...
    // assign rdata1 = ...
		assign rdata0= regs[raddr0];
		assign rdata1=regs[raddr1];
endmodule 