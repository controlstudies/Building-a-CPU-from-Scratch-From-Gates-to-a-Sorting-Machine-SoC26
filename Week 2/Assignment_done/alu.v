module alu(
    input      [7:0] a, b,
    input      [2:0] op,
    output reg [7:0] result,
    output           zero,
    output reg       carry,
    output reg       overflow
);

    assign zero = (result == 8'b00000000);

    always @(*) begin
        // Default assignments to prevent latches
        carry = 1'b0;
        overflow = 1'b0;
        result = 8'b0;

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
                carry = a[7];
                result = a << 1; 
            end
            
            3'b110: begin // SHIFTR
                result = a >> 1; 
            end
            
            default: begin
                result = 8'b0;
            end
        endcase
    end
    
endmodule