
// Instantiation of a timescale. The first time argument defines the time step
// (i.e. 1ns). The second time argument following the slash defines the
// maximum resolutions depicted on the waveform output. 
`timescale 1ns / 1ps


// Invocation of a module to execute simplistic combinational logic
module logic_function_self ();

   // Initialise two input signals, by representing them as variables 'a' and 'b' via the 'reg' function. These two variables are to be initially fixed at zero, subject to further
   //  variability via a series of operations.  
   reg a = 0, b = 0; 

   // In the context of the circuit, the two variables modelled above must be
   // associated with a corresponding output terminal, invoked via the 'wire'
   // function. This function is dependent on the input signals 'a' and 'b'
   // fluctuating. 

   wire f; 

   // Define the relationship between the input signals and the output
   // terminal via a series of operations (AND (&), OR(|), XOR(^) and NOT(~)). 
   
   assign f = a & ~b | ~a ^ b; 

   // Invert the input signal 'a' every 10ns (in accordance with the
   // pre-defined timestep of 1ns). 
   always
      #10 a = ~a; 
   // Invert the input signal 'b every 20ns (in accordance with the
   // pre-defined timestep of 1ns). 
   always
      #20 b = ~b;

   initial begin
      // The distinction between '$monitor' and '$display' for printing an
      // output lies in the former passively tracking if the output variable
      // 'f' is altered at any given point during the simulation. '%b'
      // represents an in-line binary-to-string conversion of the inputs and
      // outputs defined earlier, as well as indicating that this identifier
      // must be replaced in order by the parameter arguments that follow (a,b,
      // f).  
      $monitor("a=%b, b=%b, f=%b", a, b, f);

     // '$dumpvars' enables paramater value changes to be recorded into
     // a simulation history file. The first argument of this function indicates the
     // scope of module data extraction ('0' being the most), and the target
     // top-level module within the program. '$dumpfile' defines the exact
     // filename of the output simulation history file, which subsequently can
     // be displayed on gtkwave. 

     $dumpfile("logicfunction_self.vcd");
     $dumpvars(0, logic_function_self);

     // Fix the transient simulation range, via the '$finish' command
     #100 $finish;

   end
endmodule

      

