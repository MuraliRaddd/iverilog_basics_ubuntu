module hello_self();
// No inputs and outputs required for this task, since we are merely outputting a line of text in a newly created file. 

	initial begin // Dictates the beginning of sequence of events/commands to be sequentially executed by the console. 
		$display("Hello World!"); // Primary method of displaying line/s of text on the serial output.
	end // Signals the end of the sequential array of commands. 
endmodule // Terminates the module and its associated inputs and outputs. 
