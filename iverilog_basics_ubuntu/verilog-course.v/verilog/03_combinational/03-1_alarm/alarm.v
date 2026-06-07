// Design:      alarm
// File:        alarm.v
// Description: Simple car alarm
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        20-10-2010 (initial version)

/*
   Lesson 3.1: Combinational examples. Car alarm.

   This example is a possible solution to the following problem:

   We want to design an alarm system for a car to prevent the driver from
   leaving the car with the doors open and/or the engine running. The car has
   sensors in the driver's door, the engine and the lights. A digital signal
   for each sensor indicates the state of the element so that:
     - Engine sensor: 0-off, 1-on.
     - Door sensor: 0-closed, 1-open.
     - Lights sensor: 0-off, 1-on.
   The alarm's siren is controlled by a digital signal and is activated when
   this signal is '1'.
   We have to design a circuit that activates the siren when:
     - The engine is on and the door is open.
     - The engine is off, lights are on and the door is open.

   File alarm_tb.v includes a test bench for the proposed solution.

   This example also introduces the following Verilog concepts:

     - Combinational sensibility list "@*"
*/

`timescale 1ns / 1ps

/* We define an input for every element that need be considered to decide if
 * the alarm should be activated. */
module alarm(
    input wire door,    // door sensor: 0-closed, 1-open
    input wire engine,  // engine sensor: 0-off, 1-on
    input wire lights,  // lights sensor: 0-off, 1-on
    output reg siren    // alarm siren. 0-off, 1-on
                        /* The output is declared as 'reg' because it will be
                         * assigned from an 'always' block. */
    );

  /* The function is described in a procedural block using 'if-else'
   * statements. The sensitivity list "@(*)" automatically includes all
   * the signals in the block which is the right way to describe a
   * combinational operation, so it is called "combinational sensitivity
   * list". This way we can avoid to forget any of the involved signals.
   * The equivalent sensitivity list in this case is
   * "@(engine, door, lights). */

    always @(*)
        if (engine == 1 && door == 1)
            siren = 1;  // activate when 1st condition is met
        else if (engine == 0 && lights == 1 && door == 1)
            siren = 1;  // also activate when 2nd condition is met
        else
            siren = 0;  // in any other case, the siren is off

endmodule	// alarm

/*
   This lesson continues in file alarm_tb.v.
*/
