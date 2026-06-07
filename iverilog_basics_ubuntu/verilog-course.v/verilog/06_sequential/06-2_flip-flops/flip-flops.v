// Design:      flip-flops
// File:        flip-flops.v
// Description: Flip-flop examples
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        25-11-2010 (initial version)

/*
   Lesson 6.2: Flip-flops

   In this lesson we will do desciptions of the most typical flip-flops: SR,
   JK, D and T including asynchronous set and reset inputs. All flip-flops
   here are positive edge-triggered with active-low asynchronous inputs.

   Asynchronous control signals in flip-flops, when present, have precedence
   over synchronous inputs controlled by the clock. It means, for example, that
   while the asynchronous clear is active, the flip-flop will stay at state '0'
   no matter what the synchronous input values are or what may happen with
   the clock.
 */
`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////
// SR flip-flop                                                         //
//////////////////////////////////////////////////////////////////////////

module srff (
    input wire clk, // clock
    input wire s,   // set input
    input wire r,   // reset input
    input wire cl,  // asynchronous clear
    input wire pr,  // asynchronous preset
    output reg q    // state
    );

    always @(posedge clk, negedge cl, negedge pr)
        if (!cl)
            q <= 1'b0;
        else if (!pr)
            q <= 1'b1;
        else
            case ({s, r})
            2'b01: q <= 1'b0;
            2'b10: q <= 1'b1;
            2'b11: q <= 1'bx;
            endcase
endmodule // srff

//////////////////////////////////////////////////////////////////////////
// JK flip-flop                                                         //
//////////////////////////////////////////////////////////////////////////

module jkff (
    input wire clk, // clock
    input wire j,   // input 'j'
    input wire k,   // input 'r'
    input wire cl,  // asynchronous clear
    input wire pr,  // asynchronous preset
    output reg q    // state
    );

    always @(posedge clk, negedge cl, negedge pr)
        if (!cl)
            q <= 1'b0;
        else if (!pr)
            q <= 1'b1;
        else
            case ({j, k})
            2'b01: q <= 1'b0;
            2'b10: q <= 1'b1;
            2'b11: q <= ~q;
            endcase
endmodule // jkff

//////////////////////////////////////////////////////////////////////////
// D flip-flop                                                          //
//////////////////////////////////////////////////////////////////////////

module dff (
    input wire clk, // clock
    input wire d,   // data input
    input wire cl,  // asynchronous clear
    input wire pr,  // asynchronous preset
    output reg q    // state
    );

    always @(posedge clk, negedge cl, negedge pr)
        if (!cl)
            q <= 1'b0;
        else if (!pr)
            q <= 1'b1;
        else
            q <= d;
endmodule // dff

//////////////////////////////////////////////////////////////////////////
// T flip-flop                                                          //
//////////////////////////////////////////////////////////////////////////

module tff(
    input wire clk, // clock
    input wire t,   // toggle input
    input wire cl,  // asynchronous clear
    input wire pr,  // asynchronous preset
    output reg q    // state
    );

    always @(posedge clk, negedge cl, negedge pr)
        if (!cl)
            q <= 1'b0;
        else if (!pr)
            q <= 1'b1;
        else if (t)
            q <= ~q;
endmodule // tff

/*
   (This lesson continues in 'flip-flops_tb.v'.)
*/
