// Design:      adders
// File:        adders.v
// Description: Combinational adder examples in Verilog
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        13/11/2010 (initial version)

/*
   Lesson 5.1: Arithmetic circuits. Adders.

   The adder of integer numbers is the main element in most arithmetic units.
   An adder circuit can be coded in Verilog in a very simple way by using
   arithmetic operators. Later, an automatic synthesis tool may produce an
   optimized adder circuit for the underlying technology. However, an adder
   circuito can also be described at a lower level, for example, by
   interconnecting basic adder circuits. The main basic adder circuit is the
   Full Adder (FA).

   In this lesson we start with the description of a full adder circuit that
   will be the foundation for two equivalent structural descriptions of an
   8-bit adder. Next, we will design another equivalent adder by using
   arithmetic operators. The correct operation of all these examples and
   some variantes are checked by simulation in the proposed exercises.
 */
`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////
// Full Adder (FA)                                                      //
//////////////////////////////////////////////////////////////////////////

/* A full adder (FA) is a basic circuit that adds three bits. The result is
 * two bits, the sum 's' bit and the carry bit 'cout'.
 *   a b cin s cout
 *   0 0 0   0 0
 *   0 0 1   1 0
 *   0 1 0   1 0
 *   0 1 1   0 1
 *   1 0 0   1 0
 *   1 0 1   0 1
 *   1 1 0   0 1
 *   1 1 1   1 1
 *
 * The FA is intended to add each column when adding two binary number. It adds
 * one bit of each operand ('a' and 'b') together with the the bit carried from
 * the previous column 'cin', and generates the corresponding bit of the result
 * 's' and the value to be carried to the next column 'cout'. */
module fa (
    input [7:0] a,      // first operand
    input [7:0] b,      // second operand
    input cin,          // carry input
    output [7:0] s,     // sum output
    output cout         // carry output
    );

    /* The logic expression of 's' and 'cout' can be easily derived from the
     * table above by using reduction techniques or by observing that 's' is
     * '1' whenever the number of inputs at '1' is odd (as in the XOR
     * operation), and 'cout' is '1' whenever two or more inputs are '1'. */
    assign  s = a ^ b ^ cin;
    assign  cout = a & b | a & cin | b & cin;
endmodule // fa

//////////////////////////////////////////////////////////////////////////
// 8-bit adder using FA's (structural description)                      //
//////////////////////////////////////////////////////////////////////////

module adder8_s (
    input [7:0] a,      // first operand
    input [7:0] b,      // second operand
    input cin,          // carry input
    output [7:0] s,     // sum output
    output cout         // carry output
    );

    /* The adder is build up by a cascade connection of FA's. 'c' is an
     * auxiliary signal to connect the carry output of one stage with the the
     * carry input of the next one. */
    wire [7:1] c;

    /* The carry input to the first FA is the carry input of the adder. */
    fa fa0 (.a(a[0]), .b(b[0]), .cin(cin ), .s(s[0]), .cout(c[1]));
    fa fa1 (.a(a[1]), .b(b[1]), .cin(c[1]), .s(s[1]), .cout(c[2]));
    fa fa2 (.a(a[2]), .b(b[2]), .cin(c[2]), .s(s[2]), .cout(c[3]));
    fa fa3 (.a(a[3]), .b(b[3]), .cin(c[3]), .s(s[3]), .cout(c[4]));
    fa fa4 (.a(a[4]), .b(b[4]), .cin(c[4]), .s(s[4]), .cout(c[5]));
    fa fa5 (.a(a[5]), .b(b[5]), .cin(c[5]), .s(s[5]), .cout(c[6]));
    fa fa6 (.a(a[6]), .b(b[6]), .cin(c[6]), .s(s[6]), .cout(c[7]));
    /* The carry output of the last FA is the carry output of the adder. */
    fa fa7 (.a(a[7]), .b(b[7]), .cin(c[7]), .s(s[7]), .cout(cout));

endmodule // adder8_s

//////////////////////////////////////////////////////////////////////////
// 8-bit adder using FA's and "generate"                                //
//////////////////////////////////////////////////////////////////////////

/* This is a description equivalent to adder8_s but using the 'generate'
 * construction. */
module adder8_g (
    input [7:0] a,      // first operand
    input [7:0] b,      // second operand
    input cin,          // carry input
    output [7:0] s,     // sum output
    output cout         // carry output
    );

    /* In this case the intermediate carry bits are defined from 0 to 8 so
     * that all the instances of FA can be instantiated in an identical way
     * except for the index number. The first carry bit c[0] corresponds to the
     * carry input signal 'cin' and the last one c[8] is the carry-out bit
     * 'cout'. */
    wire [8:0] c;
    assign c[0] = cin;
    assign cout = c[8];

    /* 'generate' blocks in Verilog allow the automatic generation of various
     * Verilog items based on an index or variable. It can greatly simplify
     * the description of repetitive structural designs or generate different
     * code depending on the value of parameters. The variables that
     * control the code generation must be declared with 'genvar' and are
     * non-negative integers. Inside a generate block most Verilog constructions
     * may be used, like modules instantiation, continuous assignments and
     * procedural blocks, but you can also use 'if', 'case' and 'for' control
     * structures, not to be confused with the similar structures that are
     * used inside procedural blocks. The control variable in the 'for' loop
     * must be a 'genvar' variable. A generate block is defined between
     * 'generate' and 'endgenerate' keywords in Verilog 2001, but these
     * keywords are optional starting with Verilog 2005.
     * In our module 'adder8_g' we are going to use a generate 'for' loop to
     * automate the instantiation of 8 'fa' blocks. It will give us basically
     * the same circuit that in 'adder8_s' but it is much easier to write, can
     * be easily extended to use more bits and even the number of bits could
     * be a module's parameter. */
    generate
        /* Genvar declaration (can go inside or outside of the 'generate'
         * block). */
        genvar i;
        /* Generate 'for' loop. Looks similar but it is conceptually
         * different to the 'for' loop in procedural blocks like 'always' or
         * 'initial'. */
        for (i=0; i < 8; i=i+1)
            /* An instance of 'fa' will be generated for every value of 'i'. */
            fa fa_ins (.a(a[i]), .b(b[i]), .cin(c[i]), .s(s[i]), .cout(c[i+1]));
    endgenerate

endmodule // adder8_g


//////////////////////////////////////////////////////////////////////////
// 8-bit adder using arithmetic operators                               //
//////////////////////////////////////////////////////////////////////////

module adder8(
    input [7:0] a,      // first operand
    input [7:0] b,      // second operand
    input cin,          // carry input
    output [7:0] s,     // sum output
    output cout         // carry output
    );

    /* Using the concatenation operator the extra bit of a + b is
     * automatically stored in cout. */
    assign {cout, s} = a + b + cin;

endmodule // adder8

/*
   EXERCISE

   1. Compile the modules in this file with:

        $ iverilog adders.v

      Check that there are not syntax errors.

   2. Write a test bench for module 'fa' in a file 'fa_tb.v' to check the
      correct operation of the module for all its input values. You can use
      the file 'adders_tb.v' as a reference. Compile the design with:

        $ iverilog adders.v fa_tb.v

      and check its operation with:

        $ vvp a.out

      (this exercise continues in file 'adders_tb.v)
*/
