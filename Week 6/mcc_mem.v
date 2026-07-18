module datam(
    input clk, memr,memw,
    input [5:0] addr,       
    input [15:0] wdata,     
    output reg [15:0] out       
);
    reg [15:0] mem [63:0];  // 64 slots of 2 bytes
    integer i; 
    initial begin
        // Instructions (0 - 31)
        mem[0] = 16'b0011_10_00_00100110; // LOADI C, 38
        mem[1] = 16'b0011_11_00_00000000; // LOADI D, 0
        mem[2] = 16'b0011_00_00_00010111; // LOADI A, 23
        mem[3] = 16'b1001_01_00_00000000; // LOADF B, [A]
        mem[4] = 16'b0101_00_00_00000001; // ADDI A, 1
        mem[5] = 16'b1001_10_00_00000000; // LOADF C, [A]
        mem[6] = 16'b0111_00_00_00000001; // SUBI A, 1
        mem[7] = 16'b1101_01_10_00000000; // CMP B, C
        mem[8] = 16'b1111_00_10_00001010; // BRG 10
        mem[9] = 16'b1110_00_00_00001111; // JUMP 15
        mem[10] = 16'b1011_10_00_00000000; // STOREF C, [A]
        mem[11] = 16'b0101_00_00_00000001; // ADDI A, 1
        mem[12] = 16'b1011_01_00_00000000; // STOREF B, [A]
        mem[13] = 16'b0111_00_00_00000001; // SUBI A, 1
        mem[14] = 16'b0011_11_00_00000001; // LOADI D, 1
        mem[15] = 16'b0101_00_00_00000001; // ADDI A, 1
        mem[16] = 16'b0011_10_00_00100110; // LOADI C, 38 
        mem[17] = 16'b1101_00_10_00000000; // CMP A, C
        mem[18] = 16'b1111_00_01_00000011; // BRNE 3
        mem[19] = 16'b0011_10_00_00000001; // LOADI C, 1
        mem[20] = 16'b1101_11_10_00000000; // CMP D, C
        mem[21] = 16'b1111_00_00_00000001; // BRE 1
        mem[22] = 16'b1110_00_00_00010110; // HALT
			
		  mem[23] = 16'd55;
        mem[24] = 16'd12;
        mem[25] = 16'd89;
        mem[26] = 16'd3;
        mem[27] = 16'd22;
        mem[28] = 16'd125;
        mem[29] = 16'd7;
        mem[30] = 16'd56;
        mem[31] = 16'd77;
        mem[32] = 16'd1;
        mem[33] = 16'd34;
        mem[34] = 16'd78;
        mem[35] = 16'd14;
        mem[36] = 16'd67;
        mem[37] = 16'd29;
        mem[38] = 16'd5;
		  //setting rest to 0
        for (i = 39; i < 64; i = i + 1)
            mem[i] = 16'd0;
    end
    always @(posedge clk) begin 
        if(memw) mem[addr] <= wdata;
    end
    always @(*) begin
        if (memr) out = mem[addr];
        else          out = 16'd0;
    end
endmodule