// Design:      memories
// File:        memories.v
// Description: Description of memories in Verilog.
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        22/11/2017 (initial version)

/*
   Unit 8: Memories

   Memories are fundamental devices in complex digital systems like processors.
   There are two basic types of memories: Read-Only Memories (ROM) and Random
   Access Memories (RAM). Both types of memories behave as data storage
   elements and are accessed with two types of buses: address buses, that hold
   the address of the data that is to be accessed; and data buses, that carry
   the data to/from the memory.

   The contents of a ROM memory is fixed and defined when the circuit is
   designed. Once the ROM module is built it can only be read. The advantage is
   tha ROM memories keep their content even if disconnected from the power
   supply. On the other side, RAM memories can be read and written as many
   times as necessary. To do so, in addition to the address and datas buses,
   control signals are used to select a reading or writing operation, and
   they use to have a different data buses for the input and output data. RAM
   memories loose their content when disconnected from the power supply.

   In this unit we will see how to describe ROM and RAM memories in Verilog
   through three sample circuits:

   Lesson 8.1 (rom_mul.v): ROM-based 4-bit BCD multiplier.

   Lesson 8.2 (async_ram.v): asynchronous RAM memory design.

   Lesson 8.3 (sync_ram.v): synchronous RAM memory design.
*/

module memories ();

    initial
        $display("Memories.");
        $finish;

endmodule
