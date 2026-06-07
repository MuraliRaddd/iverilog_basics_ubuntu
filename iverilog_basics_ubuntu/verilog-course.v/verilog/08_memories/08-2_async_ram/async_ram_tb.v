// Design:      async_ram
// File:        async_ram_tb.v
// Description: Asynchronous RAM memory design. Test bench.
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        16/02/2018 (initial version)

/*
   Lesson 8.2. Asynchronous RAM with single input/output data bus.

   This file contains a test bench to test the RAM module in file 'async_ram.v'.
*/

`timescale 1ns / 1ps

// Test bench

module test ();

    reg [7:0] a;    // address lines
    tri [7:0] d;    // data lines (input/output)
    reg we;         // write control signal (write enable)
    reg oe;         // read control signal (output enable)

    reg [7:0] din;  // temporal input data storage

    // Unit Under Test
    async_ram256x8 uut(.d(d), .a(a), .we(we), .oe(oe));

    // Data lines assignment
    /* Signal "din" is used throughout the test bench to hold the data that
     * is to be assigned to the data lines of the memory during the write
     * operations. din is assigned to the data lines only when a write
     * operation is selected (we=1). Note that the data lines "d" cannot be
     * assigned in a procedural block because it is a signal of type tri/wire
     * that can be left unassigned while the signal assigned in procedural
     * blocks must be of type "reg" and are always to be assigned or will keep
     * their previous value. */
    assign d = we == 1'b1 ? din : 8'bz;

    // Testing process
    /* The testing process reads the first addresses in the memory and displays
     * their contents in the terminal. Then, some positions of the memory are
     * written and their values altered. The memory is read and the values are
     * displayed again to check that the writing operation was correct. */
    initial begin
        // read the memory from 'h00 to 'h2f
        we = 1'b0;
        oe = 1'b1;
        $display("Address\tData");
        for (a=0; a<'h30; a=a+1)
            #10 $display("%h\t%h", a, d);

        // write data from 'h10 to 'h1f
        oe = 1'b0;
        for (a='h10; a<'h20; a=a+1) begin
            din = a * 2;
            #10 we = 1'b1;
            #10 we = 1'b0;
        end

        // read the memory again
        oe = 1'b1;
        $display("Address\tData");
        for (a=0; a<'h30; a=a+1)
            #10 $display("%h\t%h", a, d);
    end

endmodule // test

/*
   EXERCISES

   2. Compile and simulate the example with:

        $ iverilog async_ram.v async_ram_tb.v
        $ vvp a.out

      Check the text output on the terminal. See that the unassigned memory
      positions have unknown values "x" and how those positions have been
      filled in by the write operations.

   3. Modify the RAM design to make address and data lines width parameterized.
      Use paramenter "AW" for the address port width and "DW" for the data
      port width with a default value of 8 for each. Check that the design
      with parameters works fine using this same test bench.
*/
