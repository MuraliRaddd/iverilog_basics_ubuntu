// Design:      alu
// File:        alu.v
// Description: Simple Arithmetic-Logic Unit (ALU)
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        22-11-2013 (initial version)

/*
   Lesson 5.4. Arithmetic-Logic Units

   In this lesson we will improve the adder-subractor designed in lesson 5.3
   to convert it into a full (but simple) Arithmetic-Logic Unit (ALU). ALU's 
   are in the inner core of any computer or processor. It is the calculator
   of the computer where all calculations involved in the execution of the
   processor instructions take place.
 */

//////////////////////////////////////////////////////////////////////////
// Arithmetic-Logic Unit (ALU)                                          //
//////////////////////////////////////////////////////////////////////////

/* The description of the ALU is similar to the adder-subtractor in the
 * previous lesson. The operation selection input is extended to represent
 * new operation as shown in the next table:
 *
 *   op[2:0]   Operation    z
 *   ----------------------------
 *       000	Addition    a + b
 *       001	Subtraction a - b
 *       010	Increment   a + 1
 *       011	Decrement   a - 1
 *       100	AND         a & b
 *       101	OR          a | b
 *       110	XOR	        a ^ b
 *       111	NOT         ~a
 *
 * Status outputs:
 *   - c: carry when adding, borrow when subtracting.
 *   - v: overflow output.
 *
 * Status outputs are zero when doing a logic function. 
 *
 * The data width is parametrized with parameter N, with a default value
 * of 8 bits. Thus, this description can produce ALU's of any data width. */

module alu #(
    parameter N = 8         // data width
    )(
    input wire [N-1:0] a,   // first operand
    input wire [N-1:0] b,   // second operand
    input wire [2:0] op,    // operation
    output reg [N-1:0] r,   // output
    output reg c,           // carry/borrow output
    output reg v            // overflow output
    );

    /* Arithmetic and logic results are calculated independently. The specific
     * arithmetic or logic operation depends on op[1:0]. carry/borrow bit (c)
     * is calculated together with the result using the chain operator. The 
     * overflow bit is calculted from the sign bits of the operands in each
     * case. */
    always @* begin
        if (op[2] == 0)	begin       // Arithmetic operations
            case (op[1:0])
            2'b00: begin
                {c, r} = a + b;     // add
                v = ~a[N-1]&~b[N-1]&r[N-1] | a[N-1]&b[N-1]&~r[N-1];
            end
            2'b01: begin
                {c, r} = a - b;     // subtract
                v = ~a[N-1]&b[N-1]&r[N-1] | a[N-1]&~b[N-1]&~r[N-1];
            end
            2'b10: begin
                {c, r} = a + 1;     // increment
                /* v is calculated like in a+b but with b[N-1]=0 */
                v = ~a[N-1]&r[N-1];
            end
            default: begin // 2'b11
                {c, r} = a - 1;     // decrement
                /* v is calculated like in a-b but with b[N-1]=0 */
                v = a[N-1]&~r[N-1];
            end
            endcase
        end else begin              // Logic operations
            case (op[1:0])
            2'b00:
                r = a & b;          // AND
            2'b01:
                r = a | b;          // OR
            2'b10:
                r = a ^ b;          // XOR
            default: // 2'b11
                r = ~a;             // NOT
            endcase
            // Status outputs are zero in logic operations
            c = 1'b0;
            v = 1'b0;
        end
    end
endmodule // alu

/*
   EXERCISE

   1. Compile the lesson with:

        $ iverilog alu.v

      Check that there are no syntax errors.

   (continues in alu_tb.v)
*/
