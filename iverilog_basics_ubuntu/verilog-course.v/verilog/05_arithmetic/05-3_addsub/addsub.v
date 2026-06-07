// Design:      addsub
// File:        addsub.v
// Description: Signed/unsigned adder-subtractors
// Author:      Jorge Juan <jjchico@gmail.com>
// Date:        22-11-2013 (initial version)

/* Lesson 5.3. Adder-subtractors

   In this lesson we will see two examples of adder/subtractors. The first
   example is good both for unsigned and signed (two's complement) numbers. The
   only difference when doing an addition or subtraction in two's complement is
   that the carry/borrow output is not an overflow indicator so the correct
   overflow for signed numbers must be generated. The second example is intended
   to be used with signed numbers since only the overflow (v) and not the
   carry/borrow (c) output signal is generated.

   This lesson also introduces a very important concept in hardware description
   languages: signed signals. The use of Verilog 'parameters' is also revisited
   in this lesson in order to design modules with an arbitrary data width. Local
   variables in named code blocks are also introduced in this lesson.
 */

//////////////////////////////////////////////////////////////////////////
// Signed/unsigend adder-subtractor                                     //
//////////////////////////////////////////////////////////////////////////

/* This description uses arithmetic operators. The operation is controlled by
 * input 'op' (0-add, 1-subtract) and the module includes an overflow signal
 * 'o' that activates ('1') when the result of the operation cannot be
 * represented with the bits available at the output.
 *
 * The data width of the module is indicated with parameter N. The default for
 * the parameter value is 8 as stated by the 'parameter' directive, but can be 
 * changed when the module is instantiated as we have already seen, so the same 
 * code can produce adder/subtractors of any data  width. In general, the more 
 * characteristics of a module that are parametrized, the more flexible and 
 * reusable the module is, so the designer might use parameters whenever it is 
 * possible. */

module addsub_su #(
    parameter N = 8
    )(
    input wire [N-1:0] a,   // first operand
    input wire [N-1:0] b,   // second operand
    input wire cin,         // carry/borrow input
    input wire op,          // operation (0-suma, 1-resta)
    output reg [N-1:0] r,   // result
    output reg cout,        // carry/borrow output
    output reg v            // overflow
    );

    always @* begin
        case (op)
        1'b0: begin
            /* The result and the carry output are calculated in a single
             * assignment using the chain operator. The overflow is calculated
             * using the sign bits of the operands and the result: overflow
             * happens when two positive number yields a negative result or
             * two negative numbers yields a positive result. */
            {cout, r} = a + b + cin;
            v = ~a[N-1] & ~b[N-1] & r[N-1] | a[N-1] & b[N-1] & ~r[N-1];
        end
        default: begin
            /* The result and the borrow output are calculated in a single
             * assignment using the chain operator. The overflow is calculated
             * using the sign bits of the operands and the result: overflow
             * happens when subtracting a negative from a positive yields a 
             * negative result or subtracting a positive from a negative yields
             * a positive result. */
            {cout, r} = a - b - cin;
            v = ~a[N-1] & b[N-1] & r[N-1] | a[N-1] & ~b[N-1] & ~r[N-1];
        end
        endcase
    end

endmodule // addsub_su

//////////////////////////////////////////////////////////////////////////
// Signed (Two's complement) Adder-subtractor                           //
//////////////////////////////////////////////////////////////////////////

/* In this subtractor we eliminate the carry/borrow input and output. Only an
 * overflow bit is generated because this circuit is intended to work only with
 * signed numbers, so inputs and output are declared as 'signed' signals so
 * that the simulator and synthesizer will assume two's complement notation and
 * arithmetic, and sigh extensions will behave accordingly, together with the
 * display format of '$display'.
 *
 * Signed variables were introduced in the 2001 standard of the Verilog
 * language. */

 module addsub_s #(
    parameter N = 8                 // number of bits
    )(
    input wire signed [N-1:0] a,    // first operand
    input wire signed [N-1:0] b,    // second operand
    input wire op,                  // operation (0-add, 1-subtract)
    output reg signed [N-1:0] r,    // output
    output reg v                    // overflow
    );

    /* Remember: 'r' and 'v' are declare as type 'reg' because they are
     * going to be assigned inside a procedural 'always' block. */

    always @* begin :sub
        /* We define a variable local to the 'always' block to hold the
         * intermediate value of the operation with one additional bit. The
         * definition of variables local to a block is only possible if the
         * block has a name, indicated with ':sub' in this case. */
        reg signed [N:0] f;
        case (op)
          0:
            f = a + b;
          default:
            f = a - b;
        endcase

        // Output
        r = f[N-1:0];

        // Overflow output
        /* 'f' always holds the correct value of the operation because
         * it has one extra bit. Overflow can be easily detected by comparing
         * the correct sign bit in f[N] with the corresponding sign bit
         * of the N bits representation (f[N-1]). */
        if (f[N] != f[N-1])
            v = 1;
        else
            v = 0;
    end

endmodule // addsub_s

/*
   EXERCISES

   1. Compile the example with:

      $ iverilog addsub.v

      and check that there are no syntax errors.

   (continues in 'addsub_tb.v')
*/
