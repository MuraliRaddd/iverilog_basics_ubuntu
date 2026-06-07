// Design:      subs
// File:        subs.v
// Description: Combinational subtractor examples in Verilog
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        24/11/2023 (initial version)

/*
   Lesson 5.2: Arithmetic circuits. Subtractors.

   Subtractors are similar to adders and are easily modelled in Verilog using
   arithmetic operators. Subtractors may be designed using a basic subtractor
   circuit equivalent to the full-adder, the full-subtractor, but we will do
   all our examples in this lesson with arithmetic operators. In practice, the
   subtraction operation can also be done with a regular adder as we will see
   below.

   In this lesson, we will describe two simple subtractors, one using the
   subtraction operand and another one using the addition operand. This will
   be useful to briefly introduce the properties of binary subtraction.
 */
`timescale 1ns / 1ps


//////////////////////////////////////////////////////////////////////////
// 8-bit subtractor using the subtraction arithmetic operator           //
//////////////////////////////////////////////////////////////////////////

module sub8 (
    input wire [7:0] a,     // first operand
    input wire [7:0] b,     // second operand
    input wire bwin,        // borrow input
    output wire [7:0] d,    // difference output
    output wire bwout       // borrow output
    );

    /* Describing a subtractor with arithmetic operators is straightforward.
     * A convenient subtractor has borrow input and output bits. The borrow
     * input (bwin) is also subtracted from the first operand and the borrow
     * output (bwout) indicates that a borrow bit had been used when
     * subtracting from the most significant bit of the first operand. This
     * is equivalent to add 2^n to the result when using n-bit numbers and
     * it also means that the correct results is a negative number, thus an
     * overflow in positive integer subtraction. It can be proven that:
     *
     *      d = (a - b - bwin) mod 2^n
     *      {bwout, d} = (a - b - bwin) mod 2^(n+1) */

    assign {bwout, d} = a - b - bwin;

endmodule // sub8

//////////////////////////////////////////////////////////////////////////
// 8-bit subtractor using the addition arithmetic operator              //
//////////////////////////////////////////////////////////////////////////

module sub8_add (
    input wire [7:0] a,     // first operand
    input wire [7:0] b,     // second operand
    input wire bwin,        // borrow input
    output wire [7:0] d,    // difference output
    output wire bwout       // borrow output
    );

    /* It can be demonstrated that the subtraction modulus 2^n can also be
     * performed using the addition operator like this:
     *
     *      d = (a + ~b + ~bwin) mod 2^n
     *
     * So the subtraction operation can be performed by a regular magnitude
     * adder. It can also be proven that the borrow output of the subtraction
     * can be obtained by complementing the carry bit of the adder. */

    wire cout;

    assign {cout, d} = {1'b0, a} + {1'b0, ~b} + {8'd0, ~bwin};
    assign bwout = ~cout;

    /* Note how the widths of a, ~b and ~bwin have been extended to 9 bits
     * explicitly before doing the assignment. This is to avoid the Verilog
     * compiler to apply the standard Verilog's width expansion rules by
     * which all operands are first extended to the width of the left-hand-side
     * of the assignment before applying the operators. With these rules:
     *   ~b becomes ~{1'b0, b}, and
     *   ~bwin becomes ~{8'd0, bwin}
     * which is not what we want.
     * (The explicit extension of a is not necessary, but done for
     * homogeinity). */

endmodule // sub8_add

/*
   EXERCISE

   1. Compile the modules in this file with:

        $ iverilog subs.v

      Check that there are not syntax errors.

      (this exercise continues in file 'adders_tb.v)
*/
