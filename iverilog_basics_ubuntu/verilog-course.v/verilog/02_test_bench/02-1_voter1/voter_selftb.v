// Testbench for 'voter_self.v'. 

// Configuration of the timescale (identical to the timescale in previous examples)

`timescale 1ns / 1ps

// The testbench is a portless module, i.e. devoid of any input and output ports, since the inputs and outputs configured are reserved solely for simulation purposes. 

module test();

	wire f; 
	reg a, b, c;
	
	// Create an instance of the 'voter_self.v' file via UUT
	// instantiation (Unit Under Test), which is a widely accepted
	// method of pulling input and output ports, alongside an extensive
	// description of the combinational logic from a target file, to be instantiated in this
	// testbench and simulated for prototyping purposes, thereby verifying
	// the functional capabilities of the current RTL design. 
	
	voter uut (.f(f), .a(a), .b(b), .c(c)); // The output and input port variables directly align with one another. 

	// Signal initialisation and simulation control
	// 'initial begin' denotes the commencement of the simulation phase.
	// Data is thereafter dumped periodically into a 'vcd' file for
	// visualisation on gtkwave. 
	
	initial begin
		a = 0;
		b = 0;
		c = 0; // Set all testbench-native variables to zero. 

		// Employing an identical method to previous exercises,
		// utilise $dumpvars to dump simulation data episodically
		// within an newly created file. 

		$dumpfile("voter_tb.vcd"); // Waveform generation. 
		$dumpvars(0, test);

		// Establish the transient simulation range (in nanoseconds)

		#100 $finish;


	end 

	// Configure time interval patterns for variable inversions
	
        always
	    #5 a = ~a;
	always 
	    #10 b = ~b;
	always
	    #20 c = ~c;
endmodule    



