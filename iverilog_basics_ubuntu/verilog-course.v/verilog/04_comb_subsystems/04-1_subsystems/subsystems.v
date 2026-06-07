// Design:      subsystems
// File:        subsystems.v
// Description: Sample combinational subsystem design
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        04/11/2010 (initial version)

/*
   Lesson 4.1: Combinational subsystems

   Automatic logic synthesis software uses algorithms to infer what are
   the most appropriate circuit blocks to implement a circuit described 
   using a hardware description language. Among these blocks we have logic
   gates, decoders, multiplexers, comparators, etc. In order to make the
   automatic logic syntheses efficient or even possible, the designer has
   to put special attention in making simple descriptions that are compatible
   with the logic synthesis algorithms. These descriptions are referred to as
   "synthesizable descriptions".

   A large number of recommendations and criteria to make good synthesizable 
   descriptions can be enumerated, but most of them are summarized by the
   following sentence:

     "If the designer cannot foresee what the synthesized circuit will look
     like, the synthesis tool will probably don't either."

   During the synthesis process, the tools can inform about what elements they
   use to implement the circuit.

   This unit is divided in three lessons corresponding to three files:

   'subsystems.v' (this file): contains examples on how to describe some
   typical combinational subsystems, including a test bench for each.

   'bcd-7.v': this is the specification of a BCD to 7-segment code converter
   that must be designed as an exercise.

   'analysis.v': this is an exercise where the designer has to describe in
   Verilog a circuit given as a schema.
*/
   
//////////////////////////////////////////////////////////////////////////
// 3:8 decoder                                                          //
//////////////////////////////////////////////////////////////////////////

module dec8 (
    input wire en,          // active-low enable
    input wire [2:0] i,     // inputs
    output reg [7:0] o      // outputs
    /* Remember: for every input or output port the compiler defines a
     * signal of type 'wire' by default. The type of signal can be changed
     * by using an explicit declaration. Here 'o' is declared as 'reg' because
     * it is going to be used in an 'always' process as a variable. */
    );


    always @(en, i) begin
        if (en == 1)
            o = 8'h00;	    // decoder disabled
        else begin
            case (i)
            /* We use hexadecimal format for 'i' and binary format for
             * 'o' to facilitate code comprehension. '_' can be used as an
             * optional separator to easy the reading of long constants. */
            3'h0:    o = 8'b0000_0001;
            3'h1:    o = 8'b0000_0010;
            3'h2:    o = 8'b0000_0100;
            3'h3:    o = 8'b0000_1000;
            3'h4:    o = 8'b0001_0000;
            3'h5:    o = 8'b0010_0000;
            3'h6:    o = 8'b0100_0000;
            /* It is always a good idea to use 'default' for the last
             * entry in the 'case' even if it is a known value, so that
             * we can be sure to consider all the cases. */
              default: o = 8'b10000000;
            endcase
        end
    end
endmodule // dec8

//////////////////////////////////////////////////////////////////////////
// 8:1 multiplexer                                                      //
//////////////////////////////////////////////////////////////////////////

module mux8_1 (
    input wire [2:0] sel,   // selection inputs
    input wire [7:0] in,    // data inputs
    output reg out          // output
    );

    always @(sel, in)
        /* A 'case' construction is the most direct and clear way to
         * model a multiplexer. */
        case (sel)
        3'h0:    out = in[0];
        3'h1:    out = in[1];
        3'h2:    out = in[2];
        3'h3:    out = in[3];
        3'h4:    out = in[4];
        3'h5:    out = in[5];
        3'h6:    out = in[6];
          default: out = in[7];
        endcase
endmodule   // mux8_1

//////////////////////////////////////////////////////////////////////////
// Binary priority encoder                                              //
//////////////////////////////////////////////////////////////////////////

module enc8 (
    input wire [7:0] in,    // inputs
    output reg [2:0] out,   // encoded output
    output reg e            // error output (1-no active input)
    );

    always @(in) begin
        /* 'e' will be '0' unless some later assignment changes its
         * value. */
        e = 0;
        /* A priority encoder is typically described with nested
         * 'if-else' statements. An alternative is to use 'casex', a
         * special type of 'case' where unknown values 'x' are treated
         * as don't cares. */
        casex (in)
        8'b1xxxxxxx: out = 3'h7;
        8'b01xxxxxx: out = 3'h6;
        8'b001xxxxx: out = 3'h5;
        8'b0001xxxx: out = 3'h4;
        8'b00001xxx: out = 3'h3;
        8'b000001xx: out = 3'h2;
        8'b0000001x: out = 3'h1;
        8'b00000001: out = 3'h0;
        default: begin      // no active input
          out = 3'h0;
          e = 1;
        end
        endcase
    end
endmodule // cod8

//////////////////////////////////////////////////////////////////////////
// 4-bit comparator with cascade inputs and outputs                     //
//////////////////////////////////////////////////////////////////////////

module comp4 (
    input wire [3:0] a,     // number a
    input wire [3:0] b,     // number b
    input wire g0,          // cascade inputs
    input wire e0,          // and outputs
    input wire l0,          //   if a > b => (g,e,l) = (1,0,0)
    output reg g,           //   if a < b => (g,e,l) = (0,0,1)
    output reg e,           //   if a = b => (g,e,l) = (g0,e0,l0)
    output reg l
);

    /* Note the use of the chain operator '{...}' that combines various
     * signals into a wider signal. Here it is used to make the assignment
     * more clear and compact. */
    always @(a, b, g0, e0, l0) begin
        if (a > b)
            {g,e,l} = 3'b100;
        else if (a < b)
            {g,e,l} = 3'b001;
        else
            {g,e,l} = {g0,e0,l0};
    end
endmodule

//////////////////////////////////////////////////////////////////////////
// TEST BENCHES                                                         //
//////////////////////////////////////////////////////////////////////////
/*
 * The rest of the file contains test benches for all the defined modules.
 * a test bench can be simulated by defining the corresponding macro at
 * compile time (option -D or similar). These macros are:
 *	TEST_DEC: decoder
 *	TEST_MUX: multiplexer
 *	TEST_ENC: priority encoder
 *	TEST_COMP: comparator
 */

// Test bench for dec8

`ifdef TEST_DEC

module test();

    reg [3:0] count;    // counter
    wire enable;        // enable
    wire [2:0] in;      // decoder input
    wire [7:0] out;     // decoder output

    dec8 uut(.en(enable), .i(in), .o(out));

    /* 'count' is used to generate all the possible input patterns. One bit
     * of 'count' is used for the enable and the rest of the bits for the
     * decoder inputs. */
    assign enable = count[3];
    assign in = count[2:0];

    initial begin
        // Input initialization
        count = 0;

        // Output generation
        $display("en in  out");
        $monitor("%b  %h   %b", enable, in, out);

        // Simulation end
        #160 $finish;
    end

    /* To generate all the possible input values it is enough to increment
     * 'count' every few units of time. */
    always
        #10 count = count + 1;
endmodule // test

// Test bench for mux8_1

`elsif TEST_MUX

module test ();

    reg [2:0] sel;                  // selection inputs
    wire [7:0] in = 8'b01010101;    // data inputs (fixed value)
    wire out;                       // multiplexer output

    mux8_1 uut(.sel(sel), .in(in), .out(out));

    initial begin
        sel = 0;

        $display("sel out");
        $monitor("%h   %b", sel, out);

        #80 $finish;
    end

    /* To test the multiplexer we select each input in turn and check
     * that the output is correct. */

    always
        #10 sel = sel + 1;

endmodule // test

// Test bench for enc8

`elsif TEST_ENC

module test();

    reg  [23:0] data;   // auxiliary signal
    wire [7:0] in;      // encoder input
    wire [2:0] out;     // encoder output
    wire e;             // error output (1-no active input)

    /* The input to the encoder is taken from the 8 more significant bits
     * of 'data'. Note the use of the range operator '[]' to select the
     * appropriate bits. */
    assign in = data[23:16];
    enc8 uut(.in(in), .out(out), .e(e));

    initial begin
        /* 'data' is defined so that useful testing values are applied to
         * the input of the encoder. The input is changed by shifting
         * the bits of 'data' to the left with the shift operator '<<'.
         * The initial value of 'data' make the encoder to operate with
         * one active input only and also with many active inputs so
         * that the correct implementation of the priority can be
         * checked. */
        data = 24'b00000001_00000000_11111111;

        $display("in       out e");
        $monitor("%b %h   %b", in, out, e);

        #240 $finish;
    end

    /* 'data' is shifted 1 bit to the left every 10 ns. Note the
     * shift operator '<<'. */
    always
        #10 data = data << 1;
endmodule // test

// Test bench for comp4

`elsif TEST_COMP

`ifndef NP
    `define NP 20   // number of input patterns to simulate
`endif
`ifndef SEED
    `define SEED 1  // initial seed used for pseudo-random patterns
`endif

module test();

    reg g0, e0, l0;         // cascade inputs
    reg [3:0] a;            // number 'a'
    reg [3:0] b;            // number 'b'
    wire g, e, l;           // comparison result
    integer np;             // auxiliary variable (number of patterns)
    integer seed = `SEED;   // auxiliary variable (seed)

    comp4 uut(.a(a), .b(b), .g0(g0), .e0(e0), .l0(l0), .g(g), .e(e), .l(l));

    initial begin
        /* 'np' is the remaining number of patterns to be applied. The
         * initial value is taken from macro `NP. */
        np = `NP;
        /* Cascade inputs are fixed to value '010' */
        {g0,e0,l0} = 3'b010;

        $display("A B  g0e0l0  g e l");
        $monitor("%h %h  %b %b %b   %b %b %b",
                   a, b, g0, e0, l0, g, e, l);
    end

    /* Every 10ns 'a' and 'b' are assigned pseudo-random values by using
     * the system function '$random', and 'np' is decremented. The
     * simulation ends when 'np = 0' (`NP patterns have been applied).
     * A different set of patterns can be tested by defining a different
     * value for `SEED. */
    always begin
        #10
        a = $random(seed);
        b = $random(seed);
        np = np - 1;
        if (np == 0)
            $finish;
    end
endmodule

`else

// Informative test bench that prints compilation options

module info();

    initial begin
        $display("Select a test bench by defining one of the ",
          "following macros:");
        $display("  TEST_DEC: decoder");
        $display("  TEST_MUX: multiplexer");
        $display("  TEST_ENC: priority encoder");
        $display("  TEST_COMP: magnitude comparator");
        $display("    SEED: random pattern seed (optional)");
        $display("    NP: number of patterns to simulate (optional)");
        $display("Examples:");
        $display("  iverilog -DTEST_DEC subsystems.v");
        $display("  iverilog -DTEST_COMP -DNP=200 subsystems.v");
        $finish;
    end
endmodule

`endif

/*
   EXERCISES

   1. Check every module defined in this file by simulating its test bench.

   2. The description of the decoder above based on the 'case' statement is
      easy to understand but uses too much code and need to be extended if
      we increment the number of bits. Try to make more simple description
      of a decoder and simulate it with the test bench of our version to test
      its operation.

   3. Starting with the 4 bit comparator in the example, design a 8 bit
      comparator (comp8) and its test bench so that:
      - The comparator uses 8 bit data.
      - The comparator does not have cascade inputs.
      - The test bench prints numbers 'a' and 'b' in decimal.
      - The test bench simulates 100 patterns by default.
      Make the comparator and test bench designs in separate files and check
      that the operation is correct.
*/