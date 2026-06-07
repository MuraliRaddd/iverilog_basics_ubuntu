// Design:      latches
// File:        latches.v
// Description: Latches examples
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        25-11-2010 (initial version)

/*
   Lesson 6.1. Latches

   Latches are a type of bi-stable circuits, that is, circuits that have two
   stable states so they can be used to store a bit of information (0 or 1)
   and are the basic elements in sequential circuits and memory devices. The
   value stored in a latch can be changed by using its control inputs. In most
   practical cases the precise moment state can change is also controlled by (or
   synchronized to) a special signal called the clock signal.

   In this lesson we will do descriptions of SR latches using different 
   triggering techniques (ways to control the state change) in order to 
   compare the different behaviors.
 */

`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////
// Asynchronous SR latch                                                //
//////////////////////////////////////////////////////////////////////////
/*
   This latch does not have a clock input. When input 's' is activated 
   (s = 1) the latch state changes to '1', and when the input 'r' is activated
   (r = 1), the state changes to '0'. The input s = r = 1 is not defined for 
   this latch so the value of the state is set to unknown ('x') in our 
   description so signal that a prohibited input combination has taken place.
 */

module sra(
    input wire s,   // set (set to '1')
    input wire r,   // reset (set to '0')
    output reg q    // state (stored value)
    /* Variables (type 'reg' in Verilog) are the only type of signal that
     * can keep a value if not assigned, so only vaiables can used to
     * model storage elements like latches. */
    );


    always @(s, r)
        case ({s, r})
        /* Variables representing memory elements should be assigned
         * with the non-blocking assignment operator '<=' instead of
         * the normal blocking assignment operator '='. With '<=', all
         * the right-side expressions in a block are evaluated first
         * and the actual assignments only happen at the end of the
         * block. This behavior models sequential circuits better. We will
         * see more about blocking and non-blocking assignments in 
         * lesson 6.3. */
        2'b01: q <= 1'b0;
        2'b10: q <= 1'b1;
        2'b11: q <= 1'bx;

        /* The latch behavior is derived from the fact that signal 'q'
         * is not always assigned even if the 'always' block is
         * activated. When 'q' is not assigned (s = r = 0) the value of
         * 'q' is kept as it is expected in a storage element. */
        endcase
endmodule // sra

//////////////////////////////////////////////////////////////////////////
// Gated SR latch. Ative-high clock.                                   //
//////////////////////////////////////////////////////////////////////////
/*
   This latch is "synchronous" because it is controlled by a clock signal
   ('clk'). The state of the latch can only be changed when clk = 1 (the clock
   is at a high level). In a similar way, active-low latches change their
   state only when clk = 0.
*/

module srg(
    input clk,      // clock signal
    input s,        // set (set to '1')
    input r,        // reset (set to '0')
    output reg q    // state (stored value)
    );

    always @(clk, s, r)
        if (clk == 1)
            case ({s, r})
            2'b01: q <= 1'b0;
            2'b10: q <= 1'b1;
            2'b11: q <= 1'bx;
            endcase
endmodule // srg


//////////////////////////////////////////////////////////////////////////
// Master-Slave SR latch                                                //
//////////////////////////////////////////////////////////////////////////
/*
   This latch it build by the chain connection of two gated latches controlled
   by opposite clock levels. When clk = 1, the first latch (master) loads
   the new state while the second latch (slave) retains the old state. When
   'clk' changes to '0' the master's state is locked and is transferred to
   the slave latch, thus changing the output of the device.
   
   The idea behind the M-S structure is make the output changes only possible 
   at the instant the clock goes from '1' to '0' (or '0' to '1' if the latches
   are active-low). Making the output changes only possible at very precise 
   instants (the negative edge of the clock in this case) is good to make
   circuitos more robust and deterministic. However, the next state of the 
   latch is still determined by the value of 's' and 'r' whenever the clock is
   active, like in a regular gated SR latch. */

module srms (
    input wire clk,
    input wire s,
    input wire r,
    output wire q
    );

    srg master(.clk(clk), .s(s), .r(r), .q(qm));
    /* The slave inputs are connected in a way that the slave will copy
     * the state of the master. */
    srg slave(.clk(clk_neg), .s(qm), .r(qm_neg), .q(q));

    /* We now generate the negated output of the master and the
     * negated clock signal. */
    assign qm_neg = ~qm;
    assign clk_neg = ~clk;

endmodule // srms


//////////////////////////////////////////////////////////////////////////
// Edge-triggered SR latch (SR flip-flop)                               //
//////////////////////////////////////////////////////////////////////////
/*
   Edge-triggered latches (AKA flip-flops) only change their states and
   evaluate their input control signals at the clock edge, either positive
   (0 to 1) or negative (1 to 0). The provide the best control of the state
   change compared to other latches so they are the preferred choice when 
   designing sequential circuits.
*/

module srff (
    input wire clk, // clock signal
    input wire s,   // set (set to '1')
    input wire r,   // reset (set to '0')
    output reg q    // state (stored value)
    );

    /* Edge-triggered conditions are indicated by 'posedge' and 'negedge'
     * keywords in the process sensitivity list. In this case, the process
     * is only evaluated when 'clk' changes from 1 to 0 (negative edge) so
     * inputs 's' and 'r' are only evaluated and the state stored in 'q'
     * can only change at that time. */
    always @(negedge clk)
        case ({s, r})
        2'b01: q <= 1'b0;
        2'b10: q <= 1'b1;
        2'b11: q <= 1'bx;
        endcase
endmodule // srff

/*
   (The lesson continues in 'latches_tb.v')
*/
