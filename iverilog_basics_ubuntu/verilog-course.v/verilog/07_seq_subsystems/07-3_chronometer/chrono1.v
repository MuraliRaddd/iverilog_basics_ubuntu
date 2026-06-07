// Design:      chrono
// File:        chrono1.v
// Description: Digital chronometer
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        14/06/2010 (initial version)

/*
   Lesson 7.3: Digital chronometer.

   In this lesson we will see the design of a slightly more complex system:
   a digital chronometer with a range of one minute, that counts seconds
   and hundredths of the second. The chronometer will have an start/stop
   input and a clear input.

   When systems are a bit more complex it is necessary to think about the
   structure of the system before starting to code the description. It is
   useful to separate the problem in different block that can be designed
   independently, and connect them afterwards in by means of an structural
   description.

   In this example we will use a single Verilog module, nonetheless we will
   think in our system in terms of different blocks that work together. A
   complete specification of the system and the strategy for its implementation
   is as follows:

   - The system's clock signal 'clk' will be of a frequency greater than 100Hz
     in most cases, so we will use a frequency divider that will enable the
     counting only once every enough cycles of the clock have taken place. To
     be able to adapt the design to different system clock frequencies, the
     system frequency will be defined as a configurable module's parameter that
     will be used by the frequency divider to produce the count enable signal
     at the right pace.

   - The system will include basically four independent counters:
     * H0: hundredths of a second (units from 0 to 9).
     * H1: tenths of a second (tens from 0 to 9).
     * S0: seconds (units from 0 to 9).
     * S1: seconds (tens from 0 to 5)

   - Each counter will be described separately in its own process. Each counter
     is incremented when the count is enabled by the frequency divider and
     the previous counters have reached their end of the count.

   - Each counter will generate and end of count output that will be used by
     more significant digits in the counter.

   - Every counter will be cleared when the global clear signal 'cl' is
     activated.

   - An 'start' signal will control the frequency divider to enable the counting
     only when start=1.
*/

`timescale 1 ns / 1 ps

//////////////////////////////////////////////////////////////////////////
// Chronometer                                                          //
//////////////////////////////////////////////////////////////////////////

module chrono1 #(
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

    // Frequency divider adjustment
    /* FDIV, calculated from SYSFREQ, is the number of cycles of the system
     * clock that corresponds to one hundredth of a second. It is the number
     * of cycles to be counted by the frequency divider.
     * Local parameters (localparm) are only visible inside the module they
     * are defined and cannot be redefined at module's instantiation. */
    localparam FDIV = SYSFREQ/100;

    /* With 24 bits for the frequency divider we can use system clock up to
     * 1.6GHz. You are free so save some bits if you know you can. */
    reg [23:0] dcount;    // Frequency divider counter

    /* End-of-count internal signals for each counter that needs one. */
    wire h0end;
    wire h1end;
    wire s0end;

    // Frequency divider
    /* This is just a cyclic down counter that will activate an enable signal
     * for the rest of the counters each time it reaches a zero value. Every
     * time it reaches zero it is set to FDIV-1, making it to activate the
     * 'cnt' enable signal once every hundredth of a second. If the
     * chronometer is stopped (start=0) the frequency divider will stop and
     * hence the whole chronometer. A clear operation (cl=1) will make the
     * divider to load its initial value. */
    always @(posedge clk) begin
        if (cl == 1)
            dcount <= FDIV - 1;
        else if (start == 1)
            if (dcount == 0)
                dcount <= FDIV - 1;
            else
                dcount <= dcount - 1;
    end

    /* Enable signal generated when the divider reaches zero. */
    assign cnt = ~|dcount;

    // Units of hundredths counter (H0)
    always @(posedge clk) begin
        if (cl)
            /* If 'cl' is activated the counter is cleared. */
            h0 <= 0;
        else if (cnt) begin
            /* If 'cnt' is activated the counter is incremented */
            if (h0end)
                /* If we are at the end of the count, we restart the
                 * counter. We use the 'h0end' signal defined below to
                 * avoid using an additional comparison here. */
                h0 <= 0;
            else
                /* If not at end of count, we increment normally. */
                h0 <= h0 + 1;
        end
    end

    /* End-of-count signal for the units of hundredths counter. */
    assign h0end = (h0 == 9)? 1:0;

    // Tens of hundredths counter (H1)
    /* This counter and the rest are very similar to the first one. Only
     * the counting conditions change slightly. */
    always @(posedge clk) begin
        if (cl)
            h1 <= 0;
        else if (cnt & h0end) begin
            /* We count only if the chronometer is enables (cnt=1) and the
             * previous counter (H0) is in its end of the count (h0end=1).
             * Then, we increment the counter as the previous one. */
            if (h1end)
                h1 <= 0;
            else
                h1 <= h1 + 1;
        end
    end

    /* End-of-count signal for H1. */
    assign h1end = (h1 == 9)? 1:0;

    // Units of seconds counter (S0)
    always @(posedge clk) begin
        if (cl)
            s0 <= 0;
        else if (cnt & h1end & h0end) begin
            /* Only if counting is enabled and all previous
             * counter at at their end-of-count. */
            if (s0end)
                s0 <= 0;
            else
                s0 <= s0 + 1;
        end
    end

    /* End-of-count signal for S0. */
    assign s0end = (s0 == 9)? 1:0;

    // Tens of seconds counter (S1)
    always @(posedge clk) begin
        if (cl)
            s1 <= 0;
        else if (cnt & s0end & h1end & h0end) begin
            if (s1end)
                s1 <= 0;
            else
                s1 <= s1 + 1;
        end
    end

    assign s1end = (s1 == 5)? 1:0;

endmodule // chrono

/*
   This lesson continues in file 'chrono_tb.v'.
*/
