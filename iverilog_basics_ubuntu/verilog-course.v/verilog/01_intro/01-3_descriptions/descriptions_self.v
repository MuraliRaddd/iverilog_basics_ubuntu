`timescale 1ns / 1ps

module descriptions ();

   // Functional descriptions tend to rely on bitwise operators, and algorithmicly represents the relationship between input and output signals via combinational logic. They can be easily mo      delled by explicitly stating the logic function in question, to indicate how pulling up or down a signal direcly impacts the output. 
	
   reg a = 0, b = 0;
   wire f_func;

   // Lead with the 'assign' command to demonstrate the input-output relationship formulaically. 
   assign f_func = (~a & b)|(a & ~b);
   

   // Procedural descriptions hinge on a more top-level representation of the
   // circuit logic, via a series of if-else conditional statements, akin to
   // typical software-native programs. This method of description is more
   // suited for interpretation by individuals with limited logic knowledge. 

   // This method is typically formed via an 'always' block, containing
   // 'begin' and 'end' delimiters for each if-else conditional statement. The
   // arguments of the 'always' block are reserved for the input signal
   // variables (a and b in this example)
   
   // Procedural syntax dictates that signals, regardless of whether they are
   // inputs or outputs, must be invoked via the 'reg' keyword as opposed to
   // the 'wire' keyword, since 'wires' are called upon only once during the
   // execution sequence, whereas 'reg' gives rise to multiple invocations of
   // that variable in the main body.

   reg f_proc;
 
   always @(a,b)
  
   begin 

	// If-else statement reflective of the circuit logic. 
	if (a == 0)
	    f_proc = b;
	
	else
	    f_proc = ~b;
   end

   // Structural descriptions closely represent the physical
   // realisation/implementation of a circuit. Each line of code corresponds to
   // a specific logic module/gate, through the usage of native Verilog logic operators. 

   wire f_est;
   wire not_a, not_b, and1_out, and2_out;

   // Instantiate the logic modules, through association with their
   // respective logic gates embedded within the circuit diagram. The arguments
   // of each instantiation represent the output, followed by the inputs. 

   not not1 (not_a, a);
   not not2 (not_b, b);
   and and1 (and1_out, not_a, b);
   and and2 (and2_out, a, not_b);
   or  or1  (f_est, and1_out, and2_out);


   // Set the timing intervals for simulation purposes
   
   always 
      #10 a = ~a;
     
   always 
      #20 b = ~b;

    // Simulation initialisation and control
    initial
    begin
        // We save all the waveforms
        $dumpfile("descriptions.vcd");
        $dumpvars(0, descriptions);

        // Print signal value changes
        /* Like in the previous lesson, we use '$monitor' to print the values of
         * as they change. We are also going to print the time at which signals
         * change their values. The '$timeformat' system function is used to
         * define the time printing format that will be later used by
         * '$monitor'. '$timeformat' arguments are:
         *   -9: use 10^(-9) as unit (nanoseconds)
         *    0: number of decimal digits (none)
         *   ns: units sufix printed after the number
         *    5: maximum number of digits */
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

endmodule








