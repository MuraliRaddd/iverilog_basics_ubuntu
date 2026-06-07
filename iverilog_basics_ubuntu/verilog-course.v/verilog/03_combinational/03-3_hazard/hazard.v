// Design:      hazard
// File:        hazard.v
// Description: Delay and hazards demonstrator
// Author: 	    Jorge Juan-Chico <jjchico@gmail.com>
// Date:        09/11/2009 (initial version)

/*
   Lesson 3.3. Combinational examples. Delays and hazards.

   A "hazard" is a transient value at the output of a combinational circuit
   before it reaches its final value. Hazards happen due to the presence of
   a propagation delay in combinational basic block (logic gates) and because
   there can be more than one path from an input to an output port, each path
   presenting different total delay.and1
   
   The presence of hazards does no mean that the circuit behaves incorrectly
   because these are only transient value and the final stable value at
   the output will be the correct one, but hazards may be inconvenient in
   some situations like, for example, when the incorrect value at the output
   may trigger an unwanted process even if this incorrect value only lasts
   for a very short time. Therefore it is interesting to detect when hazards
   may happen and even redesign a circuit to avoid having hazards at all.and1

   To detect the presence of hazards it is necessary to know the internal
   structure of the circuit and the delays of the logic gates that build it
   up.

   This file contains the design of the function:
      f(a,b) = ~a & b | a & b

   The implementation of this simple function may present a hazard when b=1
   and 'a' changes from 0 to 1 or from 1 to 0. It is due to the fact that
   even if f=1 for both a=0 and a=1, it becomes 1 by the activation of 
   different terms in each case. If we take delays into account, a term may
   become 0 before the other term becomes 1 so the output may be 0 for a
   short time producing the hazard.

   This example includes two implementations of the function. One using a
   functional description and another one using a structural description
   by interconnecting logic gates with some delays assigned.

   The file 'hazard_tb.v' contains a test bench for the design described in 
   this file.

   In this example we also introduce the parameter definition in modules and
   the use of preprocessor macros.
*/

`timescale 1ns / 1ps

//
// Functional description
//
module hazard_f (
    input wire a,
    input wire b,
    output wire f
    );

    assign f = ~a & b | a & b;

endmodule // hazard_f

//
// Structural description
//
module hazard_e #(
    // Default delay for logic operators
    /* Parameters can be defined in a module declaration before declaring
     * the module's ports. Parameters are constants that can be used in the
     * design to make it more general or configurable. Parameters are
     * defined with a default value that can be changed with every
     * instance of the module. */
    parameter delay = 5	
    )(
    input wire a,
    input wire b,
    output wire f
    );

    /* Parameters can also be defined in the body of the module description
     * (Verilog 1995 style) but they are much easier to locate if defined
     * with the module declaration as we did (Verilog 2001 style). */
    // parameter delay = 5;

    // Internal signals
    wire x, y, z;

    // Structural description using logic gates. All the gates have the
    // same delay taken from parameter 'delay'.
    /*  Verilog allows the definition of a gate's delay using 
     * "#<delay_spec>" before the name of the instance. "<delay_spec>" may
     * have different formats:
     *         d: a number. It is the value of the delay in time units.
     *     (h,l): differentiated low-to-high (output changes to 1) 
     *            and high-to-low (output changes to 0) delays.
     *   (h,l,z): differentiated low-to-high, high-to-low and change to high
     *            impedance delays.
     * Additionally, each number can be a set of three values separated by ":"
     * meaning the minimum, typical and maximum values respectively. E.g.: 
     * '#(1:2:3,2:4:5)'.
     * In this example we use a single value. */
    not #delay inv(x, a);
    and #delay and1(y, a, b);
    and #delay and2(z, x, b);
    or #delay or1(f, y, z);

endmodule // hazard_e

/*
   This example continues in file 'hazard_tb.v'.
*/