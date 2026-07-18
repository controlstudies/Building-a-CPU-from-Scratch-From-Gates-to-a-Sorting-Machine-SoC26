module tb;
    reg clk;
    reg reset;
     Multicyclecpu cpu (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk; // every 5 ns clk signal changes to its compliment
integer i;
    initial begin
        $display("unsorted array :");
        //displaying the unsorted array
        for (i = 23; i < 39; i = i + 1) begin
            $display("mem[%0d] \t= %0d", i, cpu.memory.mem[i]);
        end
        clk = 0;
        reset = 1;
        #20;
        reset = 0;
        #120000; //lol multicycle is taking more time than singlecycle 
		  $display("Array Sorted :");
        for (i = 23; i < 39; i = i + 1) begin
            $display("mem[%0d] \t= %0d", i, cpu.memory.mem[i]); //printing sorted array
        end
        $finish;
    end
endmodule