module cu(
input clk,
input reset,
input [23:0] opcoderes,
input [1:0] Ry, Rx,
output reg RegWrite, ALUSrcA, MemRead, MemWrite, MemtoReg, IorD, IRWrite, PCWrite, PCWriteCond,
output reg [1:0] ALUSrcB, PCSource,
output reg [1:0] ALUOp, 
output reg [1:0] reg_raddr0, reg_raddr1, reg_waddr
);
reg [3:0] state, next_state;
    always @(posedge clk) begin
     if (reset) state <= 0;
     else       state <= next_state;
	  end
    always @(*) begin
       //defaults
		 next_state = 0;
        RegWrite = 0; ALUSrcA = 0; MemRead = 0; MemWrite = 0; MemtoReg = 0; IorD = 0; IRWrite = 0; PCWrite = 0; PCWriteCond = 0;ALUSrcB = 2'b00; PCSource = 2'b00; ALUOp = 2'b00;
        if (opcoderes == 24'd4096 || opcoderes == 24'd16384) begin
            reg_raddr0 = Ry;
            reg_raddr1 = Rx; 
        end else begin
            reg_raddr0 = Rx; 
            reg_raddr1 = Ry; 
        end
        reg_waddr = Rx; 
        case (state)
            0: begin // fetch
                next_state = 1; 
                MemRead = 1;      
                IorD = 0;         
                IRWrite = 1;      
                ALUSrcA = 0;      
                ALUSrcB = 2'b01;  
                ALUOp = 2'b00;    
                PCSource = 2'b00; 
                PCWrite = 1;      
            end
            1: begin // decode
                case (opcoderes)
                    24'd4096:next_state = 2; 24'd16384: next_state = 2;
                    24'd64:next_state = 6; 24'd256:next_state = 6; 24'd1024:next_state = 6; 24'd131072:next_state = 6;
                    24'd524288:next_state = 8; 24'd1048576:next_state = 8; 24'd2097152:next_state = 8; 24'd4194304:next_state = 8; 
                    24'd262144:next_state = 9;
                    default: next_state = 0;
                endcase					 
            end
            2: begin
                if (opcoderes == 24'd4096) next_state = 3; 
                else                       next_state = 5;  
                ALUSrcA = 1;      
                ALUSrcB = 2'b10;  
                ALUOp = 2'b00;    
            end
            3: begin
                next_state = 4;
                MemRead = 1;      
                IorD = 1;         
            end
            4: begin // Memwriteback
                next_state = 0;
                RegWrite = 1;     
                MemtoReg = 1;     
                reg_waddr = Rx;   
            end
            5: begin
                next_state = 0;
                MemWrite = 1;     
                IorD = 1;         
            end
            6: begin // exec
                if (opcoderes == 24'd131072) next_state = 0; 
                else                         next_state = 7;
                ALUSrcA = 1;      
                ALUOp = 2'b10; 
                
                if (opcoderes == 24'd131072) begin 
                    ALUSrcB = 2'b00; 
                end 
                else begin
                    ALUSrcB = 2'b10; 
                end
            end
            7: begin // Alu writeback
                next_state = 0;
                RegWrite = 1;     
                MemtoReg = 0;     
                reg_waddr = Rx;
            end
            8: begin
                next_state = 0;
                PCSource = 2'b01; 
                PCWriteCond = 1;  
            end
            9: begin 
                next_state = 0;
                PCSource = 2'b01; 
                PCWrite = 1;      
            end
        endcase
    end
endmodule