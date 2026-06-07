// Design:      voter
// File:        voter.v
// Description: Voter circuit. Simulation with test bench
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        19-10-2010 (initial version)

/*
   Lesson 2-1: Simulation with test bench

   In this lesson we will see how to separate the description of a circuit
   module from the statements used to simulate the module: the test bench.

   The automatic logic synthesis process consists on using software tools that
   translate the functional and/or procedural circuit descriptions into
   structural descriptions consisting in the interconnection of basic blocks
   that can be directly "implemented" of converted to hardware. A hardware
   description needs to fulfill some requirements and restrictions so that it
   can be automatically synthesizable. In this course, all the hardware
   descriptions are intended to be synthesizable by standard synthesis tools.
   The documentation from the tool vendor and the technology provider has
   valuable information about the best way to describe a circuit in an HDL so
   that it can be later synthesized and implemented by the tools.

   In previous lessons we have done some design examples with a single module
   containing both the description of the circuit and the statements used for
   its simulation. These statements used to simulate and check the results are
   known as the "test bench".

   In general, it is not a good idea to describe a circuit design and its
   test bench in the same module since it prevents the use of the design in a
   more complex system and the automatic synthesis of the design since test
   bench statements like '$monitor' or '$dumpvars' cannot be synthesize. The
   way to proceed is to define the circuit functionality in one module and the
   test bench in a different module. In most cases, the test bench is defined in
   a different file, but this is not strictly necessary.

   This file you are reading contains the design of a voter circuit that we will
   use as an example. The test bench module used to test this design is in file
   'voter_tb.v'

   A voter circuit implements the so-called 'majority' function. The output
   value of the circuit is the value present in most of its inputs. The voter
   circuit in our example has three inputs, so the output will be '1' whenever
   two or more inputs are '1', and will be '0' otherwise. Voter circuits have
   applications in redundant systems where it is necessary to decide what is the
   most probable correct value among the outputs of several identical systems
   that may present failures. As long as most of the systems give the right
   output, the voter circuit will provide the right value and the whole system
   will be inmune to failures of one or more of its redundant elements.
 */

// Time scale and resolution for simulation
`timescale 1ns / 1ps

/* In this module we define the input and output signals that will connect the
 * module to the outside world. This way the module can be used as a component
 * in a bigger system. The types of the signals associated to the input and
 * output ports is also declared here. If types are omitted, the signal
 * associate to the port is considere to be a 'wire'. */
module voter (
    output reg v,
    input wire a,
    input wire b,
    input wire c
    );

    /* The circuit is described using an 'always' procedure and a 'case'
     * statement. 'case' is a better option than 'if-else' if all the conditions
     * depend on a single variable. The 'default' condition in the 'case' is
     * evaluated if all the previous conditions fail to match the value of the
     * 'case' expression. Including a 'default' is optional, be it ensures that
     * the out 'v' is always assigned a value, as it is necessary in a
     * combinational function. */
    always @(a, b, c)
        case(a)     // we do one thing or the other depending o the
                    // value of 'a'
        1:          // do this if a=0
            v = b | c;
        default:    // do this if a=1 (a!=0)
            v = b & c;
        endcase

endmodule // voter

/*
   EXERCISES

   1. Check that the design has no syntax errors with:

        $ iverilog voter.v

   The lesson continues in file voter_tb.v.
*/
