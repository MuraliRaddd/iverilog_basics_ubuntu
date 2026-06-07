// Design:      block
// File:        block.v
// Description: Blocking and non-blocking assignments.
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        05/06/2010 (initial version)

/*
   Lesson 6.3: Blocking and non-blocking assignments.

   A very important concept when describing circuits in Verilog is the
   difference between blocking (using '=') and non-blocking (using '<=')
   assignments that may appear inside processes (like 'always' or 'initial').
   Verilog simulators and synthesis tools will treat both types of assignments
   differently even if in some cases the may yield the same functionality.

   Blocking assignments
   --------------------

   In blocking assignments ('=') the right-hand side of the assignment is
   evaluated and assigned to the left-hand side "before" evaluating the
   next statement. This is equivalent to how variables assignment work in
   software. The order of the asignments is important so the code:

   q1 = 0; q2 = 1;
   q1 = q2;
   q2 = q1;

   will result in q1 = q2 = 1, while the code:

   q1 = 0; q2 = 1;
   q2 = q1;
   q1 = q1;

   will yield q1 = q2 = 0.

   Blocking assignments are used to describe combinational behavior inside
   procedural blocks, where a variable can be assigned several time and it
   is the final value at the end of the process that matters.

   Non-blocking assignments
   ------------------------

   In non-blocking assignments ('<=') the right-hand side of each statement
   is evaluated but it is not assigned to the left-hand side immediately. It
   is stored and assigned only at the end of the process when all the
   expressions in the block have been evaluated. Thus, the order of the
   non-blocking assignments in the code is irrelevant and the following code:

   q1 = 0; q2 = 1;
   q1 <= q2;
   q2 <= q1;

   will yield exactly the same result than:

   q1 = 0; q2 = 1;
   q2 <= q1;
   q1 <= q1;

   that is, q1 = 1, q2 = 0

   Non-blocking assignments accurately represent the behavior of sequential
   elements: the right-hand side of the assignment represents the next
   state, that will not become the current state until the event that triggers
   the evaluation of the process takes place, like a 'posedge' or a 'negedge'
   condition.

   As a general rule, we use '=' to assign variables tha represent a
   combinational function, and we use '<=' to assign a variable that
   represents and storage element like a latch or flip-flop.

   In this lesson we will see two versions of a circuit with two memory
   elements 'q1' and 'q2'. The circuit swaps the value of 'q1' and 'q2'
   at each positive edge of the clock, but it can also be loaded with new
   data: when input 'load' is activated, 'q1' loads a new value from input 'd'
   so the device can be initialized with some particular data.

   The first description (swap1) uses blocking assignments and the result
   will not be what we expect, while the second version (swap2) uses
   non-blocking assignments and solves the problem.
*/

`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////
// Swapper 1 (using blocking assignments)                               //
//////////////////////////////////////////////////////////////////////////

module swap1 (
    input wire clk,     // clock
    input wire load,    // load control signal
    input wire d,       // data input to q1
    output reg q1,      // storage element 1
    output reg q2       // storage element 2
    );

    always @(posedge clk)
        if (load) begin // load mode
            q1 = d;
            /* from here on, q1 is d */
            q2 = q1;
            /* from here on, q2 is also d:
             * d value is assigned both to q1 and q2 */
        end else begin  // swap mode
            q1 = q2;
            /* from here on, q1 takes the value of q2, that is d */
            q2 = q1;
            /* q2 takes the value of q1, which is the same it
             * already had, that is d */
        end
endmodule // swap1

//////////////////////////////////////////////////////////////////////////
// Swapper 2 (using non-blocking assignments)                           //
//////////////////////////////////////////////////////////////////////////

module swap2 (
    input wire clk,     // clock
    input wire load,    // load control signal
    input wire d,       // data input to q1
    output reg q1,      // storage element 1
    output reg q2       // storage element 2
    );

    always @(posedge clk)
        if (load) begin // load mode
            q1 <= d;
            /* the value of d is scheduled to be assigned to q1,
             * but q1 keeps its original value for the moment */
            q2 <= q1;
            /* the original value of q1 is scheduled to be
             * assigned to q2 */
        end else begin  // swap mode
            /* finally, if load = 1, the variables are assigned
             * the scheduled values:
            *   q1 takes the valu of d
            *   q2 takes the original value of q1 */
            q1 <= q2;    /* the original value of q2 is scheduled
                          * to be assigned to q1 */
            q2 <= q1;    /* the original value of q1 is scheduled
                          * to be assigned to q2 */
        end
        /* q1 is assigned with the original value of q2 and the
         * other way around: the values of q1 and q2 get swapped */
endmodule // swap2

/*
   (This lesson continues in 'block_tb.v'.)
*/
