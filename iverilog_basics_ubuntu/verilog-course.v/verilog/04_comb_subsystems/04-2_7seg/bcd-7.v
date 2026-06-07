// Design:      bcd-7
// File:        bcd-7.v
// Description: BCD to 7-segment converter
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        28/10/2010 (initial version)

/*
   Lesson 4.2: BCD to 7-segment converter.

   BCD to 7-segment converters take a 4-bit BCD digit and generate 7-bit
   segment that, when applied to a 7-segment display device, make it to
   display a representation of the digit. 7-segment displays build up the
   numbers by activating LED segments organized as shown below. Depending
   on the type of device, a segment may be activated using a high level
   (logic 1) or a low level (logic 0).
   
         0
        ---                               ---
     5 |   | 1                               |
        --- 6       Ej: número 3 --->     ---
     4 |   | 2                               |
        ---                               ---
         3

   As an example, to represent number 3 in an active high display we should
   apply code 1111001, wheres we would apply code 0000110 to an active low
   display.
*/

`timescale 1ns / 1ps

// BCD to 7 segments converter with active low outputs

module sseg (
    input wire [3:0] d,     // BCD input
    output reg [0:6] seg    // 7-segment output
    );

    always @*
        case (d)
            4'h0: seg = 7'b0000001;
            4'h1: seg = 7'b1001111;
            /* complete */
            default: seg = 7'b1111110;	// input is not BCD
        endcase
endmodule // sseg

/*
   EXERCISES

   Complete the description and check that the design syntax is correct by
   compiling the file with:

      $ iverilog bcd-7.v

   (This example continues in file bcd-7_tb.v)
*/
