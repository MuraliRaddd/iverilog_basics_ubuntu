// Design:      chrono
// File:        chrono2.v
// Description: Digital chronometer. Version 2.
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        14/06/2010 (initial version)

/*
   Lesson 7.3: Digital chronometer.

   This file contains an alternative design to the module 'chrono1' using
   a single procedural block.
*/

`timescale 1 ns / 1 ps

//////////////////////////////////////////////////////////////////////////
// Chronometer                                                          //
//////////////////////////////////////////////////////////////////////////

module chrono2 #(
    // System frequency in Hz
    parameter SYSFREQ = 50000000
    )(
    input wire clk,         // clock
    input wire cl,          // clear (active high)
    input wire start,       // enable (active high)
    output reg [3:0] h0,    // hundredth units
    output reg [3:0] h1,    // hundredth tens
    output reg [3:0] s0,    // second units
    output reg [3:0] s1     // second tens
    );

    // Ajuste del divisor de frecuencia. Milisegundos
    localparam FDIV = SYSFREQ/100;

    /* With 24 bits for the frequency divider we can use system clock up to
     * 1.6GHz. You are free so save some bits if you know you can. */
    reg [23:0] dcount;    // Frequency divider counter


    // Frequency divider
    always @(posedge clk) begin
        if (cl == 1)
            dcount <= FDIV - 1;
        else if (start == 1)
            if (dcount == 0)
                dcount <= FDIV - 1;
            else
                dcount <= dcount - 1;
    end

    // Frequency divider's output enable signal
    assign cnt = ~|dcount;

    // Chronometer
    /* With each active edge of the clock, a single process calculates the new
     * value of all the chronometer's digits. We start with the units of
     * hundredths: if it is not in its maximum value it is incremented, if not,
     * the digit is reset and the next digit is incremented, and so on. */
    always @(posedge clk) begin
        if (cl) begin
            /* If 'cl' is activated, do a reset. */
            h0 <= 0;
            h1 <= 0;
            s0 <= 0;
            s1 <= 0;
        end else if (cnt) begin
            /* If 'cnt' is active, we must increment the chronometer. */
            if (h0 < 9)             // normal increment
                h0 <= h0 + 1;
            else begin              // reset and check next digit
                h0 <= 0;
                if (h1 < 9)         // normal increment
                    h1 <= h1 + 1;
                else begin          // reset and check next digit
                    h1 <= 0;
                    if (s0 < 9)     // normal increment
                        s0 <= s0 + 1;
                    else begin      // reset and check next digit
                        s0 <= 0;
                        if (s1 < 5) // normal increment
                            s1 = s1 + 1;
                        else        // reset
                            s1 <= 0;
                    end
                end
            end
        end
    end

endmodule // chrono2
