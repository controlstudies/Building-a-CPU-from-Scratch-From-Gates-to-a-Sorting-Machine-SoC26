module tb_opdecoder;
    reg [15:0] c;
    reg en;
    wire [22:0] out;
    integer errors = 0;
    opdecoder uut (
        .c(c),
        .en(en),
        .out(out)
    );
    task check;
        input [15:0] test_c;
        input test_en;
        input integer target_bit;
        reg [22:0] expected_out;
        begin
            c = test_c;
            en = test_en;
            expected_out =(23'b1 << target_bit);            
            #5;
            if (out !== expected_out) begin
                $display("[FAIL] c = %b | Expected out[%0d]=1, Got %27b", 
                         test_c, target_bit, out);
                errors = errors + 1;
            end
        end
    endtask
    initial begin
        check({4'd0, 12'd0}, 1'b1, 0);  // NOOP

        // Input-sub case (wi = 1, depends on Ry)
        check({4'd1, 2'b00, 2'd0, 8'd0}, 1'b1, 1);  // INPUTC
        check({4'd1, 2'b00, 2'd1, 8'd0}, 1'b1, 2);  // INPUTCF
        check({4'd1, 2'b00, 2'd2, 8'd0}, 1'b1, 3);  // INPUTD
        check({4'd1, 2'b00, 2'd3, 8'd0}, 1'b1, 4);  // INPUTDF

        // Single Opcodes
        check({4'd2,  12'd0}, 1'b1, 5);  // MOVE
        check({4'd3,  12'd0}, 1'b1, 6);  // LOADI/LOADP
        check({4'd4,  12'd0}, 1'b1, 7);  // ADD
        check({4'd5,  12'd0}, 1'b1, 8);  // ADDI
        check({4'd6,  12'd0}, 1'b1, 9);  // SUB
        check({4'd7,  12'd0}, 1'b1, 10); // SUBI
        check({4'd8,  12'd0}, 1'b1, 11); // LOAD
        check({4'd9,  12'd0}, 1'b1, 12); // LOADF
        check({4'd10, 12'd0}, 1'b1, 13); // STORE
        check({4'd11, 12'd0}, 1'b1, 14); // STOREF

        // Shift case (wi = 12, depends on c[8])
        // c[8] is the LSB of the 2-bit Ry field, so Ry=00 gives c[8]=0, Ry=01 gives c[8]=1
        check({4'd12, 2'b00, 2'b00, 8'd0}, 1'b1, 15); // SHIFTL 
        check({4'd12, 2'b00, 2'b01, 8'd0}, 1'b1, 16); // SHIFTR 
        check({4'd13, 12'd0}, 1'b1, 17); // CMP
        check({4'd14, 12'd0}, 1'b1, 18); // JUMP
        // Branch case (wi = 15, depends on Ry)
        check({4'd15, 2'b00, 2'd0, 8'd0}, 1'b1, 19); // BRE/BRZ
        check({4'd15, 2'b00, 2'd1, 8'd0}, 1'b1, 20); // BRNE/BRNZ
        check({4'd15, 2'b00, 2'd2, 8'd0}, 1'b1, 21); // BRG
        check({4'd15, 2'b00, 2'd3, 8'd0}, 1'b1, 22); // BRGE

        // 5. Final Result Display
        $display("\n");
        if (errors == 0) begin
            $display("ALL TESTS PASSED");
        end else begin
            $display("FAILED: %0d ERRORS FOUND", errors);
        end
        $display("\n");

        $finish;
    end

endmodule
