// Design:      alu
// File:        alu.v
// Description: Simple Arithmetic-Logic Unit (ALU). Test bench.
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        22-11-2013 (initial version)

/*
   Lesson 5.4. Arithmetic-Logic Units

   This file contains a test bench for module 'alu'.
 */
`timescale 1ns / 1ps

// This test bench applies a configurable number of random input patterns to
// the circuit under test.

// Simulation macros and default values:
//   NP: number of test patterns
//   SEED: initial seed for pseudo-random number generation
//   OP: type of operation (see 'alu.v')

`ifndef NP
    `define NP 20
`endif
`ifndef SEED
    `define SEED 1
`endif
`ifndef OP
    `define OP 0
`endif

module test ();
    
    reg signed [7:0] a;     // input 'a'
    reg signed [7:0] b;     // input 'b'
    reg [2:0] op = `OP;     // type of operation
    wire signed [7:0] r;    // output
    wire c;                 // carry/borrow output
    wire v;                 // overflow output
    integer np;             // number of patterns (auxiliary signal)
    integer seed = `SEED;   // seed (auxiliary signal)

    // Circuit under test
    /* Alu width is parametrized. We instantiate an 8 bit ALU. */
    alu #(.N(8)) uut(.a(a), .b(b), .op(op), .r(r), .c(c), .v(v));

    initial begin
        /* 'np' is a counter that holds the remaining number of patterns
         * to be applied. The initial value is taken from macro NP. */
        np = `NP;
        
        // Waveform generation (optional)
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, test);
        
        // Output printing
        $write("Operation: %d ", op);
        case (op)
        0:       $display("ADD");
        1:       $display("SUB");
        2:       $display("INCREMENT");
        3:       $display("DECREMENT");
        4:       $display("AND");
        5:       $display("OR");
        6:       $display("XOR");
        default: $display("NOT");
        endcase

        /* Inputs and output are displayed in decimal and in binary
         * formats so that both arithmetic and logic operations can be
         * esily checked. */
        $display("       A                B",
                 "                 R         c  v");
        $monitor("%b (%d)  %b (%d)   %b (%d)  %b  %b",
                   a, a, b, b, r, r, c, v);
    end

    // Test generation process
    /* Each 20ns 'a', 'b' are assigned random values. Simulation
     * ends after applying NP patterns. The pattern sequence can be 
     * changed by defining a different value for SEED. Macros NP and SEED
     * can be changed in the file or using compilation options. */
    always begin
        #20
        a = $random(seed);
        b = $random(seed);
        np = np - 1;
        if (np == 0)
            $finish;
    end
endmodule

/*
   EXERCISES
    
   2. Compile the design with:
    
        $ iverilog alu.v alu_tb.v
      
      and simulate the design with:
      
        $ vvp a.out
      
      Check that the operation is correct for the addition case by looking at
      the test output and the waveforms with Gtkwave.
      
      Check the rest of the operations in a similar way by defining a different
      value for macro OP (between 0 and 7). For example:
      
      $ iverilog -DOP=1 alu.v alu_tb.v
      
      NOTE: to check the correct operation of the overflow for increment and
      decrement operations you may have to increase the number of patterns to
      simulate by defining a higher value of macro 'NP'.
      
   3. Do additional simulations using different values for 'OP', 'NP' and 
      'SEED' and see what happens. For example:
      
      $ iverilog -DOP=1 -DNP=40 -DSEED=2 alu.v alu_tb.v
      $ vpp a.out

   4. Add additional status outputs to the ALU:
        - Zero (z): set to 1 when the result (r) is zero.
        - Negative (n): set to 1 when the result is a negative number:
            n = r[N-1]
        - Sign (s): sign of the result even when the sign in r is wrong:
            s = v ^ n
      These status bits should be set for all ALU's operations.

   5. Design an arithmetic unit similar to the example with the following 
      operations (there are no logic operations):
 
      op[2:0]   Operation       r
      -------------------------------
      000       Addition        a + b
      001       Subtraction     a - b
      010       Increment 1     a + 1
      011       Decrement 1     a - 1
      100       Increment 2     a + 2
      101       Decrement 2     a - 2
      110       Increment 4     a + 4
      111       Decrement 4     a - 4
      
      Include status outputs c, v, z, n and s.
*/