module datam(
    input clk, we,
    input [5:0] addr,       
    input [15:0] wdata,     
    output [15:0] out       
);
    reg [15:0] mem [63:0];  // 64 slots of 2 bytes
    integer i;
    //initiating first 16 slots with numbers
    initial begin
        mem[0] = 16'd55;
        mem[1] = 16'd12;
        mem[2] = 16'd89;
        mem[3] = 16'd3;
        mem[4] = 16'd22;
        mem[5] = 16'd125;
        mem[6] = 16'd7;
        mem[7] = 16'd56;
        mem[8] = 16'd77;
        mem[9] = 16'd1;
        mem[10] = 16'd34;
        mem[11] = 16'd78;
        mem[12] = 16'd14;
        mem[13] = 16'd67;
        mem[14] = 16'd29;
        mem[15] = 16'd5;
		  //setting rest to 0
        for (i = 16; i < 64; i = i + 1)
            mem[i] = 16'd0;
    end

    always @(posedge clk) begin 
        if(we) mem[addr] <= wdata;
    end
    assign out = mem[addr];
endmodule