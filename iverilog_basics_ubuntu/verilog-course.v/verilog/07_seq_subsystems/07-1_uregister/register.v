// Design:      uregister
// File:        register.v
// Description: Universal register.
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        17-12-2010 (initial version)


/*
   Lesson 7.1: Universal register.

   Basic memory elements (latches and flip-flops) are typically used in
   groups called "registers". All the bits in a register are modified at the
   same time (they share the same clock signal). We normally think about
   the whole word stored in a register and not the individual bits. Registers
   can implement useful operations to load, transform of make available the
   stored data. Some of these operations are:
   - Data loading (in series or parallel).
   - Data reading (in series or parallel).
   - Set content to zero or "clear".
   - Set content to all one's or "preset".
   - Data shift (left or right).

   Registers may have input lines for all its bits so a whole word may be
   written in a single operation (parallel input). Similarly, output lines
   for all the bits may be available making it posible to read the whole
   content of the register at the same time (parallel output).

   In the shift operations, a new bit is written in the register through a
   serial input while the rest of the bits are shifted: copied to the
   adjacent place on the right or left (depending on the type of shift). This
   way, a whole word can be written by using successive shift operations
   (serial input). In this case, the content of the register can be read one bit
   at a time using only one output line (serial output).

   In this lesson we are going to design a register with several posible
   operations, some time referred to as "universal registers". These were
   typically implemented in MSI (Medium Scale of Integration) chips in order
   to a have a very versatile device that could be used in different circuits.
   When using Verilog or other HDL's, only special registers use to be defined
   as separate modules while most registers are simply variables inside more
   complex modules.

   This module also shows how to use the chain operator ({}) to implement
   shift operations.
 */
`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////
// Universal register                                                   //
//////////////////////////////////////////////////////////////////////////
/*
   Various control signals determine the operation of the register with
   a priority order. The operations are:

    load shr shl	Operation
    --------------------------
      0   0   0     Inhibition
      1   x   x     Data load
      0   1   x     Right shift
      0   0   1     Left shift

   Input and outputs of the register are:
       clk: clock signal
       xr:  right shift serial input
       xl:  left shift serial input
       x:   data input for load operation
       z:   data output (stored value)
 */

module uregister #(
    // register width
    /* The register width is parameterized with a default value of 8 bits. */
    parameter W = 8
    )(
    input wire clk,         // clock
    input wire load,        // data load
    input wire shr,         // right shift
    input wire shl,         // left shift
    input wire xr,          // serial input for shr
    input wire xl,          // serial input for shl
    input wire [W-1:0] x,   // data input for data load
    output [W-1:0] z        // output (stored value)
    );

    /* Internal signal to hold the state. Output 'z' will be directly assigned
     * from this signal. Technically, in Verilog, it is not necessary to define
     * an additional internal signal for the state becouse the output signal
     * may do the job, but doing this way may improve code's clarity and makes
     * it more in sync with the style of other HDL's. */
    reg [W-1:0] q;      // state

    always @(posedge clk) begin
        if (load)
            q <= x;
        else begin
            if (shr)
                q <= {xr, q[W-1:1]};
            else if (shl)
                q <= {q[W-2:0], xl};
        end
    end

    assign z = q;

endmodule // uregister

/*
   (This lesson continues in file 'register_tb.v').
*/
