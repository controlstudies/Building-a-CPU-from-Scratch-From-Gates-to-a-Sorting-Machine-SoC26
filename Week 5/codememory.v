module code_memory(
    input [5:0] address,
    output reg [15:0] instruction
);
    always @(*) begin
        case(address)
            // [15:12] Opcode | [11:10] Rx | [9:8] Ry | [7:0] immediate/Target
         
			// 0: LOADI C, 15 (wi=3, Rx=10, Imm=15) 
            6'd0:  instruction = 16'b0011100000001111;
            // 1: LOADI D, 0 (wi=3, Rx=11, Imm=0)
            6'd1:  instruction = 16'b0011110000000000;
            // 2: LOADI A, 0 (wi=3, Rx=00, Imm=0)
            6'd2:  instruction = 16'b0011000000000000;
            // 3: LOADF B, [A] (wi=9, Rx=01, Ry=00)
            6'd3:  instruction = 16'b1001010000000000;
            // 4: ADDI A, 1 (wi=5, Rx=00, Imm=1)
            6'd4:  instruction = 16'b0101000000000001;
            // 5: LOADF C, [A] (wi=9, Rx=10, Ry=00)
            6'd5:  instruction = 16'b1001100000000000;
            // 6: SUBI A, 1 (wi=7, Rx=00, Imm=1)
            6'd6:  instruction = 16'b0111000000000001;
            
            // 7: CMP B, C (wi=13, Rx=01, Ry=10)
            6'd7:  instruction = 16'b1101011000000000;
            // 8: BRG 10 (wi=15, Ry=10 for BRG, Target=10)
            6'd8:  instruction = 16'b1111001000001010;
            // 9: JUMP 15 (wi=14, Target=15)
            6'd9:  instruction = 16'b1110000000001111;
            // 10: STOREF C, [A] (wi=11, Rx=10, Ry=00)
            6'd10: instruction = 16'b1011100000000000;
            // 11: ADDI A, 1
            6'd11: instruction = 16'b0101000000000001;
            // 12: STOREF B, [A] (wi=11, Rx=01, Ry=00)
            6'd12: instruction = 16'b1011010000000000;
            // 13: SUBI A, 1
            6'd13: instruction = 16'b0111000000000001;
            // 14: LOADI D, 1 (Swap flag = 1)
            6'd14: instruction = 16'b0011110000000001;
            // 15: ADDI A, 1
            6'd15: instruction = 16'b0101000000000001;
            // 16: LOADI C, 15
            6'd16: instruction = 16'b0011100000001111;
            // 17: CMP A, C (wi=13, Rx=00, Ry=10)
            6'd17: instruction = 16'b1101001000000000;
            // 18: BRNE 3 (wi=15, Ry=01 for BRNE, Target=3)
            6'd18: instruction = 16'b1111000100000011;
            // 19: LOADI C, 1
            6'd19: instruction = 16'b0011100000000001;
            // 20: CMP D, C (wi=13, Rx=11, Ry=10)
            6'd20: instruction = 16'b1101111000000000;
            // 21: BRE 1 (wi=15, Ry=00 for BRE, Target=1)
            6'd21: instruction = 16'b1111000000000001;
            // 22: JUMP 22 (HALT)
            6'd22: instruction = 16'b1110000000010110;

            default: instruction = 16'b0000000000000000;
        endcase
    end
endmodule