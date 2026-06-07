// Design:      combinational_subsystems
// File:        combinational_subsystems.v
// Description: Combinational subsystems examples in Verilog
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        27/11/2009 (initial version)

/*
   Unidad 4: Combinational subsystems

   Digital circuits automatic synthesis tools use algorithms to infer the
   circuit elements (decoders, multiplexers, comparators, etc.) better suited 
   to implement the functionality described by a hardware description 
   language. For the synthesis process to be efficient, the designer may pay
   attention in order to produce simple descriptions that are compatible with
   the logic synthesis algorithms. Descriptions that are good for automatic
   synthesis are called "synthesizable descriptions".

   Many criteria and recommendations exist in order to write a synthesizable
   description, but they all can be summarized as follows:

     If the designer cannot forsee the synthesis of a particular description,
     the synthesis tool probably neither.

   During the logic synthesis process, the tools inform about the circuit
   elements that are going to be used to implement the description. It is a
   good exercise to consult this information and check if we can make
   sense of it.

   This unit consists of four lessons:

   Lesson 4.1 (subsystems.v): sample design of different basic subsystems and
   a test bench for each one.

   Lesson 4.2 (bcd-7.v): includes the specification of a BCD to seven segments
   code converter, that must be designed as an exercise.

   Lesson 4.3 (gray.v): design of binary to Gray and Gray to binary code
   converters using parameters.

   Lesson 4.4 (analysis.v): includes an exercise that consists in describing
   in Verilog a circuit given as an schematic.
*/

module combinational_subsystems ();

    initial
        $display("Combinational subsystems.");

endmodule