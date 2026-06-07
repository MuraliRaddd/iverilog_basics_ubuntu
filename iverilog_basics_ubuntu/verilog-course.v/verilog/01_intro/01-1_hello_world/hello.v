// Design:       hello
// File:         hello.v
// Description:  Course's introduction
// Author:       Jorge Juan-Chico <jjchico@gmail.com>
// Date:         05-11-2009 (initial)

/*
   Lesson 1.1: Introducción a Verilog

   In this lesson we will make a very simple Verilog design and will learn how
   to compile and simulate it. We will also introduce some general concepts
   about this course, Verilog and hardware description languages in general.

   Note that this text you are reading right now is a Verilog comment. Verilog
   comments are similar to comments in C and C++: use bars and asterisks for
   comments than can span multiple lines or double bars for single line
   comments.

   Verilog is a hardware description language (HDL). Its syntax is similar to
   the C programming language but in Verilog we model the behaviour of a digital
   electronic circuit and not a computer program.

   Verilog and other HDL's (like VHDL) are useful maninly for two things: to
   simulate the behaviour of a circuit before implementation and fabrication
   and, if the Verilog code is adequate, to give it to a synthesis tool that
   will automatically generate an implementation of the circuit.

   HDL's are a fundamental tool in modern digital circuit desing that allows the
   design, simulation and implementation of complex circuits in an easier and
   faster way.

   For additional information about Verilog and hardware description languages
   you can visit the Wikipedia (wikipedia.org).

   This course assumes the student has a Verilog languge reference at hand with
   the details of the language's syntax. At the time of writting, an excelent
   reference to the languge written by Stuart Suntherland is availabe at:

   Verilog® HDL Quick Reference Guide based on the Verilog-2001 standard
   http://www.sutherland-hdl.com/pdfs/verilog_2001_ref_guide.pdf
*/

/*
   Let's go with the first example: the traditional "Hello, world!". Every
   Verilog description is inside a 'module'. The module declaration consists
   of the name of the module and list of input and output signals to the
   circuit. It is like and external view of the circuit you are designing.
   Our first module is so simple that it has no inputs or outputs, so its
   list of signals is empty.
*/

module hello ();

    /* Inside a module there can be different kinds of descriptions. In our
     * first example we use an 'initial' block, that consists in a sequence
     * of instructions that the Verilog simulator will execute in series, like
     * in any programming language. */

    initial begin

        $display("Hello, world!");

        /* $display is the equivalent to 'print' in other languages. It just
         * prints a text message to the standard output, most probably the
         * terminal or console the simulator runs in. $display does not
         * represent any functionality of a circuit. It is a system function
         * executed by the simulator. System functions are used to control
         * the simulator and to obtain data from it. All system functions
         * start with the '$' sign. Like in C, statements end with a ';'. */

    end
endmodule // hello

/*
   EXERCISE

   To simulate this module with Icarus, open a terminal, change to the folder
   with the file 'hello.v' and execute:

     $ iverilog hello.v

   (You do not have to write the '$', it means your are in the command line)

   This will make Icarus to compile the design and generate any error message in
   case there are syntax errors. If everything is fine, the compiled design is
   written to the 'a.out' file. To simulate the desing the 'vpp' command included
   with Icarus:

     $ vvp a.out

   This will execute the simulation of the module and the terminal should print
   the message "Hello, world!".

   ¡Congratulations! ¡You just made your first Verilog project!
*/
