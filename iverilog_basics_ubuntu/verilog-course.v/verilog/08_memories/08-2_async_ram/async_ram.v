// Design:      async_ram
// File:        async_ram.v
// Description: Asynchronous RAM memory design.
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        16/02/2018 (initial version)

/*
   Lesson 8.2. Asynchronous RAM with single input/output data bus.

   The module in this file is classical example of RAM. The module has a set
   of address lines (a) and a set of data lines (d). Data lines are used both
   for data input and output (they are bidirectional). The writing of new data
   in the memory is controlled by signal "we" (write enable) and the reading
   of data is controlled by signal "oe" (output enable). As soon as any of
   these signals is activated the writing or reading of the memory takes place
   respectively, that is why it is an "asynchronous" RAM: the operation does
   not depend on clock signal.

   Asynchronous RAM with bidirectional data ports were very popular in the past
   because the its simple control mechanism and the saving in the number of data
   pins when implemented in a chip. This type of RAM is not recommended in most
   modern digital design for various reasons:

   * Synchronous memories are faster in general because it can include
     pipelining stages to improve the memory's throughput.

   * Current digital circuit design platforms like FPGA's are optimized to
     implement synchronous memories. Describing an asynchronous memory will
     make the tool to use general logic and a less efficient implementation.

   * Bidirectional input/output ports requiere the use of tri-state buffers and
     introduce nodes that can be in high-impedance state, making the circuits
     more complex and more prune to failure due to electromagnetic
     interferences and other phenomena.

   * In most modern digital designs, memories are internal elements to the
     chip so saving input/output ports by introducing bidirectional ports does
     not normally provide any advantage.

   Nonetheless, this lesson is useful to introduce basic concepts of RAM
   design and how to use tri-state signals.
 */

`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////
// Asynchronous 256x8 RAM                                               //
//////////////////////////////////////////////////////////////////////////

module async_ram256x8 (
    input wire [7:0] a,     // address lines
    inout tri [7:0] d,      // data lines (input/output)
    input wire we,          // write control signal (write enable)
    input wire oe           // read control signal (output enable)
    );
    /* Signals of type "tri" are identical to "wire" signals. Type "tri" is
     * often used with signals that may be assigned from different drivers
     * or signal that can be left unassigned or in "high impedance", like the
     * input/output signals in this example. */

    // Memory contents
    /* A RAM is represented in Verilog by an "array" of vectors. Each vector
     * corresponds to a data word stored in the memory and the related index of
     * the array is the address of the data word in the memory. RAM data
     * preserves the assigned value so the array should be of type "reg". */
    reg [7:0] mem [0:255];

    // Initial memory contents
    /* In Verilog, it is possible to load initial data in the RAM array by
     * just assigning array elements in an "initial" procedural block, but it
     * is more convenient in general to use system functions "$readmemb()" or
     * "$readmemh()". The argument to these functions is a text file with
     * the data to be stored in the array in order, one line per datum.
     * $readmemb() expects numbers in binary format while $readmemh() expects
     * number in hexadecimal format. Most synthesis tools support comments and
     * address marks in the file. Elements in the array not assigned in the
     * data file will remain as unknown values "x". See file "mem.list" as an
     * example */
    initial
        $readmemh("mem.list", mem);

    // Write operation
    /* The write operation to the memory address selected by the address lines
     * takes place as soon as the "we" signal is activated. */
    always @(*)
        if (we == 1'b1)
            mem[a] <= d;

    // Read operation
    /* The memory is read whenever signal "oe" is activated but as long as
     * signal "we" is not in order to avoid a collision with the write
     * operation. When the memory is read, the data lines are assigned with
     * the data stored at the address selected by the address lines. If the
     * read operation is not activated and the data lines are not being driven
     * externally, the data lines will be assigned the value "z", which is
     * equivalent to leave the lines unassigned or in "high impedance" state.
     * Once the circuit is implemented, signal in high impedance state will
     * be "slightly" connected to the any of the power supply terminal of the
     * circuit through a pull-up or pull-down resistor. While in high impedance
     * state, the signal is more likely to be affected by internal or
     * external electromagnetic interferences. */
    assign d = (oe && !we) ? mem[a] : 8'bz;

endmodule // async_ram256x8

/*
   EXERCISES

   1. Compile the module in this file with:

        $ iverilog async_ram.v

      to check that there are not syntax errors.
*/
