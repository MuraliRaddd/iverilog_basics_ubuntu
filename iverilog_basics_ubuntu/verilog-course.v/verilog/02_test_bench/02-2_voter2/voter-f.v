// Design:      voter
// File:        voter-f.v
// Description: Simulation with test bench
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        15-10-2010 (original version)

/*
   Lesson 2.2: Simulation with test bench

   In this file we will describe the same voter circuit but using a functional
   description. Later on we will compare the simulation results of this
   description and the procedural description in file voter.v

   In general, a functional description is closer to the final implementation
   of the circuit than the procedural description, the former is also easier
   to synthesize and more efficient to simulate, but it requires a some
   previous work from the designer than the latter in most cases. Therefore,
   functional descriptions are mostly useful when the function is already 
   known or when the nature of the problem makes it easier to describe using
   a function.
 */

// Time scale and resolution for simulation
`timescale 1ns / 1ps

/* We call this module 'voter_f' so it can be distinguished from the 
 * procedural version 'voter' */

module voter_f (
    output wire v,
    input wire a,
    input wire b,
    input wire c
    );

    /* As we have already seen, unconditional functions are described with
     * an 'assign' statement. From the expression, it is easy to note that
     * the circuit's output will be '1' whenever two ore more inputs will
     * be '1'. */
    assign v = a&b | a&c | b&c;

endmodule // voter_f

/*
   EXERCISES

   1. Check that the design is correct by compiling the file with:

     $ iverilog voter-f.v

   (This lesson continues in file voter-f_tb.v)
*/
