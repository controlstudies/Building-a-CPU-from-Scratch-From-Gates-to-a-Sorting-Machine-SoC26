module tb;
    reg clk;
    reg reset;
    integer i; 
    singlecyclecpu cpu (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk; // every 5 ns clk signal changes to its compliment

    initial begin
        $display("unsorted array :");
        //displaying the unsorted array
        for (i = 0; i < 16; i = i + 1) begin
            $display("mem[%0d] \t= %0d", i, cpu.data_memory.mem[i]);
        end
        clk = 0;
        reset = 1;
        #20;
        reset = 0;
        #60000;
		  $display("Array Sorted :");
        for (i = 0; i < 16; i = i + 1) begin
            $display("mem[%0d] \t= %0d", i, cpu.data_memory.mem[i]); //printing sorted array
        end
        $finish;
    end
endmodule