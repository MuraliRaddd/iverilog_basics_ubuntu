// Design:      sync_ram
// File:        sync_ram.v
// Description: Synchronous RAM design.
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        15/01/2023 (initial version)

/*
   Lesson 8.3. Synchronous RAM design.

   This file includes the description of two types of synchronous RAM, both
   with separate input and output data lines. These are examples of recommended
   styles for RAM descriptions. The synchronous operation allows a better
   control of reading and writing operations and the introduction of pipeline
   stages in the memory design that will improve the memory's performance.
   The separate input and output lines avoid having nodes in high impedance and
   allow writing and reading the memory in the same clock cycle.

   In the examples below the reading operation is unconditional: the memory is
   always read at the position in the address bus with each active edge of the
   clock even if a writing operation is taking place. In this case, each
   example has a slightly different behavior:

   * Reading-before-writing (read-first): the output takes the value stored in
     the memory before the new content is written.

   * Reading-after-writing (write-first): the output takes the same value that
     is being stored.

   Other behavior may also be described in Verilog if needed, like a global
   enable signals or a specific reading control signal.

   Current FPGA chips include RAM blocks named Block RAM or simple BRAM that
   can be used by synthesis tools to implement synchronous RAM in an efficient
   way. To be sure which types of synchronous RAM can be implemented in a given
   platform and the best way to describe them it may be useful to read the
   platform's manuals.
 */

`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////
// RAM 32x8 reading-before-writing (read-first)                            //
//////////////////////////////////////////////////////////////////////////

module ram32x8_rf (
    input wire clk,         // clock signal
    input wire [4:0] a,     // address lines
    input wire we,          // write enable
    input wire [7:0] din,   // data lines (input)
    output reg [7:0] dout   // data lines (output)
    );

    // Memory contents
    reg [7:0] mem [0:31];

    // Writing and reading operations
    always @(posedge clk) begin
        if (we == 1'b1)
            mem[a] <= din;
        dout <= mem[a];
    end
endmodule // ram32x8_rf

//////////////////////////////////////////////////////////////////////////
// RAM 32x8 reading-after-writing (write-first)                          //
//////////////////////////////////////////////////////////////////////////

module ram32x8_wf (
    input wire clk,         // clock signal
    input wire [4:0] a,     // address lines
    input wire we,          // write enable
    input wire [7:0] din,   // data lines (input)
    output wire [7:0] dout  // data lines (output)
    );

    // Memory contents
    reg [7:0] mem [0:31];

    // Registered address value
    reg [5:0] read_a;

    // Writing operation and address registering
    always @(posedge clk) begin
        if (we == 1'b1)
            mem[a] <= din;
        /* The address being read/written is registered */
        read_a <= a;
    end

    // Reading
    /* The reading is continuously done over the registered address so the
     * value read after a writing operation is the same value that has just
     * been written. */
    assign dout = mem[read_a];

endmodule // ram32x8_wf

/*
   EXERCISES

   1. Compile the module in this file with:

        $ iverilog sync_ram.v

      to check that there are not syntax errors.
*/
