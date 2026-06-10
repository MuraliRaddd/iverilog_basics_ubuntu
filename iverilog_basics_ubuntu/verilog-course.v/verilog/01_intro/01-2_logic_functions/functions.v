// Design:      logic_function
// File:        functions.v
// Description: Logic functions and simulation
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Fecha:       05-11-2009 (initial version)

/*
   Lesson 1.2: Logic functions and simulation

   In this lesson we will see how to describe a combinational circuit that does
   a logic function, how to simulate its behavior and how to see the simulation
   results. Besides, we introduce some fundamental concepts about signal types,
   expressions, operators and delays.
*/

/* In Verilog there is not a default time unit. With '`timescale' we define
 * the time unit we want to use (1ns in this case) and the precision that we
 * want to use to represent time (1ps in this case). This way it is easier to
 * use and understand time values. `timescale is a simulator directive.
 * Simulator directives are preceded by an inverted apostrophe. */
`timescale 1ns / 1ps

/* Our example has a single module and does not have any ports (external
 * connections). All signal are internal to the module. The module describes
 * the logic function 'f = a & ~b | ~a & b' written with Verilog logic
 * operators. Some of these operators are:
 *   & - AND
 *   | - OR
 *   ~ - NOT (complement)
 *   ^ - exclusive OR
 * Function 'f' is equivalent to 'f = a ^ b', that is, the exclusive OR of
 * 'a' and 'b'. */
module logic_function ();

    /* Next we define the internal signals we are going to use in our design.
     * Signals are similar to variables in programming languages, but here
     * they represent electrical connections and circuit elements. */

    /* 'a' and 'b' are signals of type 'variable' and are declared with the
     * keyword 'reg'. We initialize this variables to 0. These signals behave in
     * a similar way to software variables: can be assigned a value now and a
     * different value later. We will use these as the input variables to our
     * function. */
    reg a = 0, b = 0;

    /* 'f' is a signal of type 'wire' which represents signals that are
     * permanently assigned a single expression or signals that permanently
     * connect the terminals of different modules. */
    wire f;

    /* Now we define the function we want to model. We simply assign 'f' with
     * the desired expression using Verilog logic operands. Signal of type
     * 'wire' are assigned with the 'assign' keyword that means it is a
     * continuous permanent assignment. */
    assign f = a & ~b | ~a & b;

    /* The rest of the code in the module is used to test function 'f'. With
     * the following code we assign values to the variables 'a' and 'b' and the
     * simulator we then calculate the value of 'f'. Since 'f' is defined with
     * a continuous assignment, whenever there is a change in any of the
    * variables, the simulator will calculate a new value of 'f'. To assign
     * 'a' and 'b' we use 'always' blocks. These blocks are used to define
     * 'procedures'. We will see more about that in the next lessons. */

    /* 'always' procedures repeat indefinitely. The next procedure constantly
     * complements the value of 'a'. The modifier '#10' introduces a delay of
     * 10ns before the assignment, so the procedure complements 'a' every 10ns
     * producing a square signal in 'a' with a 20ns period. */
    always
        #10 a = ~a;

    /* We do the same with 'b' but this time the delay is 20ns, so after 40ns
     * 'a' and 'b' have go through all their possible combinations and the
     * simulator should have calculated all possible values of 'f'. */
    always
        #20 b = ~b;

    /* 'initial' procedures are similar to 'always' but they are executed only
     * once by the simulator. They are useful to set the initial value of the
     * signals and to configure the simulation process through system
     * functions. */
    initial begin
        /* '$monitor' is a system function, like '$display', and works in a
         * similar way: it print a text string whenever any of the signals in
         * $monitor statement changes its value. The string passed to monitor is
         * a format string where symbols preceded by '%' are placeholdes that
         * are substituted in order by the values of the rest of parameters. In
         * the example, '%b' is substituted by the corresponding value in binary
         * format. */
        $monitor("a=%b, b=%b, f=%b", a, b, f);

        /* '$dumpvars' is another system function that tells the simulator to
         * generate a waveform file for its future analysis. Parameter '0' to
         * $dumpvars means that we want to save all the internal signals of
         * the module given as second parameter, 'function'. */
        $dumpfile("functions.vcd");
        $dumpvars(0, logic_function);

        /* '$finish' is yet another simulator system function that makes the
         * simulator to stop working. The execution of '$finish' happens with
         * a delay of 100ns so the simulation will finish at 100ns simulation
         * time, which is more than enough to test our design. */
        #100 $finish;
    end

endmodule // function

/*
   EXERCISE

   1. Compile the design with:

        $ iverilog functions.v

   2. Execute the simulation with:

        $ vvp a.out

      Take a look at the results printed in the terminal and generated by the
      $monitor system function. You can see the value of 'f' as 'a' and 'b' take
      the different values generated by the always blocks. It is possible that the
      corresponding value of 'f' is printed later than the change in 'a' of 'b'
      since the simulator may consider that the change in 'f' is delayed with
      respect 'a' and 'b'.

   3. Take a look at the generated waveform file using the Gtkwave waveform
      viewer (the '&' at the end of the next command prevents the terminal from
      stay blocked while Gtkwave is executing):

        $ gtkwave functions.vcd &

      On the left panel of Gtkwave you can select the signals of simulated module
      and add them to the plotting area. Add 'a', 'b' and 'f' and zoom out to see
      the whole simulated time frame. Check that the periods of 'a' and 'b' are
      correct and that the value of 'f' is correct too (since 'f' is the exclusive
      OR of 'a' and 'b', 'f' should be '1' only when 'a' and 'b' differ).

   4. Describe and simulate the following functions in Verilog:
      a) f(a, b) = a & b | ~a & ~b
      b) f(a, b, c) = (a|b|~c) & (a|~b|c) & (~a|b|c)
*/
