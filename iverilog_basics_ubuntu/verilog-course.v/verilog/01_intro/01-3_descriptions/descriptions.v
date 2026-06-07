// Design:      descriptions
// File:        descriptions.v
// Description: Description types in Verilog
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        05-11-2009 (initial version)

/*
   Lesson 1.3: Hardware description types in Verilog

   In this lesson we will see the three styles to describe digital circuits in
   Verilog. These are:

   - Functional descriptions: the circuit behaviour is described through logic
     (or other types) of expressions as we have seen in the previous lesson.

   - Procedural descriptions: the circuit is described using control structures
     (if-else, for, while, case, etc.) in a similar way as algorithms are
     described in software.

   - Structural descriptions: these describe a circuit by specifying the
     interconnection of modules. These modules can be logic primitives (AND, 
     OR, NOT, etc.) or other modules previously described by the designer.

   Among the types of descriptions, the procedural description allow the 
   specification of circuits at the highest level and in an easier way in most
   cases. The functional description is ideal when the expression giving the
   output is already known. These use the 'assign' keyword and the regular
   variable assignment inside procedures. Structural descriptions are in
   general closer to the actual implementation of the circuit. It can be used
   both to specify the detailed interconnection of small circuit components or
   to connect big modules already designed using any type of description.

   In this lesson we will describe three versions of the same circuit using 
   the three types of descriptions. It is the circuit that produces a result
   corresponding to the following function:
       f = a & ~b | ~a & b
*/

/* Set the time scale and time resolution */
`timescale 1ns / 1ps

/* For now, we will use a single module including the three types of
 * descriptions. All our signals are internal in our example so the module
 * has no input or output ports. */
module descriptions ();

    /* 'a' and 'b' are the input variables for our three descriptions. The
     * following statement declares and initialize the variables. */
    reg a = 0, b = 0;

    //// Functional description ////

    /* 'f_func' is the result of the functional description. First, the signal
     * is declared as 'wire' and then it is assigned using 'assign' like in
     * the previous lesson. */
    wire f_func
    assign f_func = a & ~b | ~a & b;

    /* The declaration and the continuous assignmente can be combined in a 
     * single line like:
     *     wire f_func = a & ~b | ~a & b;
     * Here the 'assign' is implicit. */

    //// Procedural description ////

    /* 'f_proc' corresponds to the procedural implementation. In contrast to
     * 'wire' signals, which are always connected or assigned in a continuous
     * way, signals in procedures can be assigned multiple times or not be
     * assigned at all. For this use case Verilog uses 'variable' signals 
     * declared with the keyword 'reg'. As a general rule, signal assigned in
     * a Verilog procedure should be of type 'reg'. [1] */
    reg f_proc;


    /* A procedural description of a logic circuit is always inside an 
     * 'always' block. The block is evaluated when ever any signal in the
     * sensitivity list at the begining of the 'always' block changes its
     * value. The variables in the sensitivity list can be separated by 'or'
     * (old style) or by ',' (new style). In the the description of a 
     * combinational circuit, the sensitivity list must include all the
     * signals the circuit depends on, since the circuit's output may change
     * as a response to a chenge in any of its input signals: */
    always @(a, b)
    /* When a block statement like 'always' contains more than one statement,
     * these must be grouped using the 'begin' and 'end' keywords. In this case,
     * the 'always' block contains a single 'if-else' statement, but 
     * 'begin-end' delimiters nonetheless for clarity. */
    begin
        /* An 'if-else' statement can be used to make conditional assignments.
         * Any expression the evaluates to true (non zero) or false (zero) can
         * be used as the 'if' condition. Relational operators are very useful
         * here. For example:
         *  == - equal
         *  != - not equal
         *  && - both are true
         *  || - any is true */
        if (a == 0)
            f_proc = b;
        /* When an 'always' block is used to describe a combinational signal,
         * the signal must be assigned in any case. If not, the variable will
         * retains its old value and will represent an storage element which is
         * not a combinational function (more about this in forthcoming
         * lessons. */
        else
            f_proc = ~b;
    end

    //// Structural description ////

    /* An structural description consists in the placement and interconnection
     * of previously designed modules and/or logic primitives. Logic primitives
     * are basic modules built in the Verilog language like logic gates (and,
     * or, xor, nand, nor, xnor, not, buf, etc.). The structural description is
     * a direct one-by-one representation of a circuit diagram, that is, a
     * drawing of the circuit's modules and the way they are interconnected. In
     * fact, the easiest way to produce a structural description is from a
     * circuit diagram previously drawn in paper or otherwise. */

    // Structural description output
    /* Signals interconnecting modules should be of type 'wire'. */
    wire f_est;
    // Internal signals for interconnecting the modules
    wire not_a, not_b, and1_out, and2_out;

    /* When "instanciating" a module in a structural description the format is:
     *     module_name instance_name (list_of_signals) 
     * For our design we are going to use some of the Verilog's built-in logic
     * primitives. When instantiating logic primitives, the first signal in the
     * list is the output port of the gate, followed by the list of inputs. A
     * variable number of inputs can be used with gates that support multiple
     * inputs like 'and' or 'or'. The structural description of our circuit can
     * be easily derived from the functional description above. If in doubt,
     * draw the diagram the corresponds to the following description and
     * compare with the function expression. */
    not not1 (not_a, a);
    not not2 (not_b, b);
    and and1 (and1_out, a, not_b);
    and and2 (and2_out, not_a, b);
    or  or1  (f_est, and1_out, and2_out);

    //// Signal generation and test configuration ////

    /* The rest of the statements in the module are used to generate the test
     * signals and to control the simulation. */

    // Periodic signal generation in inputs 'a' and 'b'
    always
        #10 a = ~a;
    always
        #20 b = ~b;

    // Simulation initialization and control
    initial
    begin
        // We save all the waveforms
        $dumpfile("descripciones.vcd");
        $dumpvars(0, descripciones);

        // Print signal value changes
        /* Like in the previous lesson, we use '$monitor' to print the values of
         * as they change. We are also going to print the time at which signals
         * change their values. The '$timeformat' system function is used to
         * define the time printing format that will be later used by 
         * '$monitor'. '$timeformat' arguments are:
         *   -9: use 10^(-9) as unit (nanoseconds)
         *    0: number of decimal digits (none)
         *   ns: units sufix printed after the number
         *    5: maximum number of digits ./
        $timeformat(-9, 0, "ns", 5);
        /* We use '$display' to print a header at the begining of the 
         * simulation. '\t' in the format string is a tab character. */
        $display("t\ta\tb\tf_func\tf_proc\tf_est");
        /* The format string in '$monitor' includes a number in time format 
         * '\t' (difined with '$timeformat') and binary values '%b' for the
         * signals. The '$stime' system function returns the current simulation
         * each time it is invoked. */
        $monitor("%t\t%b\t%b\t%b\t%b\t%b", $stime, a, b, f_func, f_proc, f_est);

        // End simulation at 100ns
        #100 $finish;
    end

    /* Note about concurrency: it is very important to understand that in a
     * hardware description language like Verilog, every procedure (always or
     * initial), continuous assignment (assign) or module's instance works 
     * concurrently with all other elements. That means that we can alter the 
     * order in which these elements have been has been defined in the file 
     * without changing the modelled circuit behaviour or the result of its
     * simulation. This concurrent behaviour of the HDL's is derived from the
     * elements they represent: circuit devices that work independently and 
     * concurrently with the rest of the devices. The only statements that are
     * evaluated sequentially (like in software) are the statements inside 
     * always or initial procedures. */

endmodule // descripciones

/*
   [1] One of the most confusing aspects of Verilog for newbies is the diference
   between 'wire' and 'reg' types, and it is also one of the most critisized 
   aspects of verilog for two reasons:
   (1) 'wire' is used to represent connections, as with real wires, but it is
   also used to hold the result of continuous assignments.
   (2) The name 'reg' of the variable type is easily identified with a circuit
   'register' which is a digital storage element. However, a variable in
   Verilog may represent a register but also other types of signals that have
   nothing to do with registers, so a better name may have been 'var' for the
   'variable' type.
   To solve this source of confusion, SystemVerilog, a super-set of the Verilog
   language, introduced the type 'logic' that can be used to represent any 
   type of signal.
*/

/*
   EXERCISE

   1. Compile the design with:

     $ iverilog descriptions.v

   2. Execute the simulation with:

        $ vvp a.out

      Take a look at the results generated with '$monitor' for the three types
      of descriptions.

   3. Take a look at the generated waveform file using the Gtkwave waveform
      viewer (the '&' at the end of the next command prevents the terminal from
      stay blocked while Gtkwave is executing):

        $ gtkwave descriptions.vcd &

      Check that the results of the three implementations are the same and 
      correct.
*/
