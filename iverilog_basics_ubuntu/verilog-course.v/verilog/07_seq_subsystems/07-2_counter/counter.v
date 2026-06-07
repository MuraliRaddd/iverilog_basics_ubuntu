// Design:      counter
// File:        counter.v
// Description: Up/down counter.
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        22-12-2010 (initial version)

/*
   Lesson 7.2: Up/down counter

   Not surprisingly, counter's main taks is to count: they store a number and
   at every clock event they increment or decrement (down counter) the number
   in one unit. The numbers use to be codified in natura binary format, but
   other encondings are posible: Gray code, etc.

   A counter module may implement some of the common operation of registers,
   like the clear or data load operations, therefore a counter may be seen as
   particular type of register that includes the count operation. The
   description of counters in Verilog is analogous to that of registers.

   In this lesson we describe a reversible counter (one that can count up
   or down) with a synchronous clear option.
*/

`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////
// Up/down counter                                                      //
//////////////////////////////////////////////////////////////////////////
/*
   The operation of the counter is determined by control inputs 'cl', 'en' and
   'ud' as shown in the following table:

      cl  en  ud    Operation
    --------------------------
      1   x   x     Sinchronous clear
      0   0   x     Inhibition (no operation)
      0   1   0     Up count
      0   1   1     Down count

   Additional inputs and outputs:
       clk: clock signal.
       c:   end of count (carry). Active while in the last count state.
 */

module counter #(
    parameter W = 8		// counter width
    )(
    input wire clk,         // clock
    input wire cl,          // clear
    input wire en,          // enable
    input wire ud,          // count direction (0-up, 1-down)
    output wire [W-1:0] z,  // counter output (count state)
    output reg c            // end of count
    );

    // counter state variable
    reg [W-1:0] count;

    // Counter control process
    always @(posedge clk) begin
        if (cl)                 // clear
            count <= 0;
        else if (en)            // the counter is enabled
            if (ud == 0)        // cuenta ascendente
                count <= count + 1;
            else                // cuenta descendente
                count <= count - 1;
        /* the counter is not enabled, do nothing */
    end

    // End of count calculation process
    /* 'c' should active when count=2^W-1 if counting up, and when
     * count=0 if counting down. */
    always @* begin
        if (ud == 0)
            c = &count;     /* all the bits of 'count' are '1' */
        else
            c = ~(|count);  /* all the bits of 'count' are '0' */
    end

    /* Output is just the state of the counter */
    assign z = count;

endmodule // counter

/*
   (This lesson continues in file 'counter_tb.v'.)
*/
