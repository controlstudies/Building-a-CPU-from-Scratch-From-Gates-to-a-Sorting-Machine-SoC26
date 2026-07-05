module opdecoder(
    input [15:0] c,
    input en,
    output reg [22:0] out,
	 output [1:0] Rx,Ry
);
    wire [3:0] wi;
    assign wi = c[15:12];
    assign Ry = c[9:8];
    assign Rx = c[11:10];
    always @(*) begin
        out = 23'b0;
        if (en) begin
            case(wi)
                4'd0: out[0] = 1'b1;        // NOOP
                4'd1: begin                 // input-sub case
                    case (Ry)
                2'd0: out[1]  = 1'b1; // INPUTC
                2'd1: out[2]  = 1'b1; // INPUTCF
                2'd2: out[3]  = 1'b1; // INPUTD
                2'd3: out[4]  = 1'b1; // INPUTDF
                    endcase
                end
	4'd2:  out[5]  = 1'b1;      // MOVE
        4'd3:  out[6]  = 1'b1;      // LOADI/LOADP
        4'd4:  out[7]  = 1'b1;      // ADD
        4'd5:  out[8]  = 1'b1;      // ADDI
        4'd6:  out[9]  = 1'b1;      // SUB
        4'd7:  out[10] = 1'b1;      // SUBI
        4'd8:  out[11] = 1'b1;      // LOAD
        4'd9:  out[12] = 1'b1;      // LOADF
        4'd10: out[13] = 1'b1;      // STORE
        4'd11: out[14] = 1'b1;      // STOREF
        4'd12: begin                // shift case
                    case (c[8])             
                        1'b0: out[15] = 1'b1; // SHIFTL
                        1'b1: out[16] = 1'b1; // SHIFTR
                    endcase
                end
                4'd13: out[17] = 1'b1;      // CMP
                4'd14: out[18] = 1'b1;      // JUMP
                4'd15: begin                //branch case
                    case (Ry)
                        2'd0: out[19] = 1'b1; // BRE/BRZ
                        2'd1: out[20] = 1'b1; // BRNE/BRNZ
                        2'd2: out[21] = 1'b1; // BRG
                        2'd3: out[22] = 1'b1; // BRGE
                    endcase
                end
       
            endcase
        end
    end

endmodule
