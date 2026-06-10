// A voter function evaluates the mode of an array of system outputs, some of which may be erroneous. Based on the assumption that the majority of outputs are not corrupted by any means, this function utilises simple bitwise logic to evaluate the majority bit. 

// Timescale configuration

`timescale 1ns / 1ps

// Configure the module, and its respective input and output ports. Defining
// these within the module block itself assures global usage; these inputs and
// outputs may be invoked remotely in a different file/testbench. By default,
// input and output ports are assigned as 'wires', unless stated otherwise. 
module voter (
	output reg f, 
	input wire a,
	input wire b,
	input wire c
	);

	// Combinational logic defined procedurally must always be embedded
	// within 'always' blocks, with a list of parameters (typically the
	// inputs). 
	always @(a, b, c)
	begin 
		// For sake of simplicity and readability, a 'case'
		// conditional statement was included instead of an if-else
		// statement. This cross-references the value of 'a' with
		// different cases; when a = 1, an 'OR' comparison between 'b'
		// and 'c' is computed, since either 'b' or 'c' (or both) must
		// be high for the mode to be '1'. Conversely, the 'default'
		// case (optional, but included to prevent any floating states)
		// is applicable when a = 0, triggering an 'AND' comparison
		// between 'b' and 'c', since both of these inputs must be
		// high for the mode to equate to '1'.
		case(a)
		
		1:
			f = b | c;
		
		default: 
			f = b & c;
		endcase
	end
endmodule
