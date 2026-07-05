module alu(
    input      [15:0] a, b,
    input      [2:0] op,
    output reg [15:0] result,
    output           zero,
    output reg       carry,
    output reg       overflow
);

    assign zero = (result == 16'd0);

    always @(*) begin
        carry = 1'b0;
        overflow = 1'b0;
        result = 16'd0;

        case (op) //decode op
            3'b000: begin // ADD
                // 8-bit + 8-bit = 9-bit result. The 9th bit automatically drops into 'carry'
                {carry, result} = a + b;
            end
            
            3'b001: begin // SUB
                // Subtraction also catches borrow in the carry bit
                {carry, result} = a - b;
            end
            
            3'b010: begin // AND
                result = a & b;
            end
            
            3'b011: begin // OR
                result = a | b;
            end
            
            3'b100: begin // XOR
                result = a ^ b;
            end
            
            3'b101: begin // SHIFTL
                carry = a[15];
                result = a << 1; 
            end
            
            3'b110: begin // SHIFTR
                result = a >> 1; 
            end
            3'b111: result = b;
            default: begin
                result = 16'd0;
            end
        endcase
    end
    
endmodule