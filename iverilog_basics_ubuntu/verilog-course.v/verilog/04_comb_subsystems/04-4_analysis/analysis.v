// Design:      analysis
// File:        analysis.v
// Description: Example of circuit analysis using Verilog
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        27/11/2009 (initial version)

/*
   Lesson 4.4: Analysis of a combinational circuit.

   In this unit we have seen how to describe combinational blocks that we can
   reuse in other designs, like the BCD to 7 segments converter or the 
   binary and Gray code converters. Although we have also seen how to describe
   other basic blocks (multiplexers, decoders, comparators, etc.) we do not
   normally need to to define these blocks explicitly to be later connected
   to the main circuit, it is often easier, faster and more efficient to 
   describe the behavior we want to model and let the synthesis tools to 
   choose and interconnect the appropriate blocks. For example, the following
   code activates two signals depending on the result of a comparison:

        always @(*)
            if (a < b) begin
                y = 1;
                z = 0;
            end else begin
                y = 0;
                z = 1;
            end
    
   It is easy to figure out what the code does and it is not necessary to
   know in detail what blocks must be used and how to interconnect them to
   build up the circuit, but it is very useful for the designer to understand
   that "a < b" will requiere a comparator and that the 'if' statement will
   likely involve the use of a multiplexer or decoder.

   This lesson proposes an exercise to practice the definition and 
   interconnection of combinational modules, together with the design of 
   alternative implementations.

   We want to design the circuit in the schema below and simulate it to 
   obtain the truth table of function f(x,y,z). To do so, the most direct way
   is to describe each block in Verilog (except the NAND gate that is a
   Verilog primitive) and to do a structural description of the complete 
   circuit, as in the code template below.

       +---------+       +---+
       |DEC2:4  0|o------| & |
       |         |       |   |o------+
   y---|1       1|o------|   |    +--+-+
       |         |       +---+    |  E  \
   z---|0       2|o---------------|0     \__ f
       |         |                |      /
       |        3|o---------------|1    /
       +---------+                +--+-+
                                     |
                                     x
*/

module dec4 (
    input  wire [1:0] in,
    output reg  [3:0] out
    );

    /* Decoder implementation goes here */

endmodule // dec4

module mux2 (
    input  wire [1:0] in,
    input  wire       sel,
    input  wire       en,
    output reg        out
    );

    /* Multiplexer implementation goes here */

endmodule // mux2

module system (
    input  wire x,
    input  wire y,
    input  wire z,
    output wire f
    );

    /* Signal declaration for interconnections goes here */

    // Instanciación y conexión de módulos
    dec4 dec4_1(/* complete signal connections */);
    nand nand_1(/* complete signal connections */);
    mux2 mux2_1(/* complete signal connections */);

endmodule // system

/*
   EXERCISE

   1. Complete the structural description of the proposed circuit.

   2. Write the test bench in a file named 'analysis_tb.v'. The test bench
      should obtain the complete truth table of the function implemented by
      the circuit by, for example, going through all possible values of the 
      input signals and printing the input value together with the 
      corresponding output value. Use the test benches of the other examples in
      the unit as reference.

   3. Write an alternative description of 'system' using a procedural style.
      Check that the new description produces the same output values than
      the original circuit by using the test bench written above.

   4. Write an alternative description of 'system' using a functional style.
      Check that the new description produces the same output values than
      the previous versions by using the test bench written above.
*/