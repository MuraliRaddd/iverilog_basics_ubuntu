// Design:      alarm
// File:        alarm.tb
// Description: Simple car alarm. Test bench
// Author:      Jorge Juan-Chico <jjchico@gmail.com
// Date:        20-10-2010 (initial version)

/*
   Lesson 3.1: Combinational examples. Car alarm.

   This file contains a test bench for module 'alarm'.
 */

   `timescale 1ns / 1ps

module test();

    // Inputs
    reg door, engine, lights;

    // Output
    wire siren;

    // Unit Under Test (UUT) instance
    /* It is good practice to use a line of code for every connected signal.
     * This way it is easier to check if all the signal of the module have been
     * connected, and to add or remove signal in the future if needed. */
    alarm uut (
        .door(door),
        .engine(engine),
        .lights(lights),
        .siren(siren)
        );

    // Input initialization and simulation control
    initial begin
        // Input initialization
        door = 0;     // closed
        engine = 0;   // off
        lights = 0;   // off

        // Waveform generation statements
        $dumpfile("alarm_tb.vcd");
        $dumpvars(0,test);

        // Circuit test
        /* We change the input signals so that the circuit should activate
         * the alarm (the siren rings). We test the cases of interest:
         *   - door open with engine on,
         *   - door open with engine off and lights on. */

        // Door open and engine on
        #10 engine = 1;     // start engine
        #10 door = 1;       // open door
                            // siren should activate here
        #10 door = 0;       // close door
                            // siren should deactivate here
        #10 engine = 0;     // engine off
        #10 lights = 1;     // lights on
        #10 door = 1;       // open door
                            // siren should activate here
        #10 lights = 0;     // lights off
                            // siren should deactivate here
        #10 door = 0;       // close door

        // Simulation ends
        #20 $finish;
    end

endmodule // test

/*
   EXERCISES

   1. Compile the test bench with:

        $ iverilog alarm.v alarm_tb.v

   2. Simulate the design with:

        $ vvp a.out

   3. Plot the resulting waveforms with:

        $ gtkwave alarm_tb.vcd &

      To better check the results select the "uut" module and add the signals
      in this order: engine, door, lights and siren. Check that the value of
      'siren' is correct compared to the conditions of the problem.

   4. This alarm system can be a little disgusting. Add a control input signal
      to the system (you can call it 'control') so that when control=0 the
      siren is always off, and when control=1, the alarm works as in the
      previous system. Modify the test bench to test the new functionality,
      simulate the circuit and fix any problems you may encounter.
*/
