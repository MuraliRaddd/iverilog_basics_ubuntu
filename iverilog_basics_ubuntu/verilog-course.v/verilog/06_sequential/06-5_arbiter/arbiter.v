// Design:	    arbiter
// File:        arbiter.v
// Description: Finite State Machine (FSM). Arbiter example.
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        01-12-2010 (initial version)

/*
   Lesson 6.5: Finite State Machine (FSM). Arbiter example.

   In this example, a Mealy's and Moore's implementation of an arbiter circuit
   is developed.

   An arbiter circuit controls the access to a common resource by a number
   of clients. The arbiter has a 'request' and 'grant' signal for every client
   and should take care to grant access only to one client at a time from the
   set of requesting clients.

   The purpose of this example is to show how in some applications Moore's
   machines are more convenient than Mealy's machines. In general, Moore's
   machines are more robust and less prone to fail due to timing problems. They
   also provide synchronized outputs (outputs only change at the active clock
   edge) which make these machines more reliable. For these reasons, Moore's
   machines are normally preferred over Mealy machines.
*/

`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////
// Arbiter (Mealy)                                                      //
//////////////////////////////////////////////////////////////////////////

/*
 * Arbiter behavior: if two requests are activated at the same time, the
 * resource is granted to device 1, so this device is assigned higher priority.
 *
 *              Inputs (r1 r2)
 * State   00     01     10     11
 *       ----------------------------
 *  S0  | S0,00  S2,01  S1,10  S1,10 |  S0: no requests
 *  S1  | S0,00  S2,01  S1,10  S1,10 |  S1: resource granted to device 1
 *  S2  | S0,00  S2,01  S1,10  S2,01 |  S2: resource granted to device 2
 *       ----------------------------
 *            Next state, g1 g2
 */
 module arbiter1 (
    input wire clk, // clock
    input wire r1,  // request 1
    input wire r2,  // request 2
    output reg g1,  // grant 1
    output reg g2   // grant 2
     );

     // State encoding
     parameter [1:0]
         S0 = 2'b00,
         S1 = 2'b01,
         S2 = 2'b10;

    // State and next state variables
    reg [1:0] state, next_state;

    // State change process (sequential)
    always @(posedge clk)
        state <= next_state;

    // Next state calculation (combinational)
    always @* begin
        next_state = 2'bxx;
        case (state)
        S0: begin
            if (r1)
                next_state = S1;
            else if (r2)
                next_state = S2;
            else
                next_state = S0;
        end
        S1: begin
              if (r1)
                  next_state = S1;
              else if (r2)
                  next_state = S2;
              else
                  next_state = S0;
        end
        S2: begin
            if (r2)
                next_state = S2;
            else if (r1)
                next_state = S1;
            else
                next_state = S0;
        end
        default:
            next_state = S0;
        endcase
    end

    // Output calculation (combinational)
    always @(state, r1, r2) begin
        // default values
        g1 = 0; g2 = 0;

        /* For each state, we derive the equation of 'g1' and 'g2'
         * as a function of the inputs. */
        case (state)
        S0: begin
            g1 = r1;
            g2 = r2;
        end
        S1: begin
            g1 = r1;
            g2 = ~r1 & r2;
        end
        S2: begin
            g1 = r1 & ~r2;
            g2 = r2;
        end
        endcase
    end
endmodule // arbiter1

//////////////////////////////////////////////////////////////////////////
// Arbiter (Moore)                                                      //
//////////////////////////////////////////////////////////////////////////

/*
 * Moore's description is very similar to Mealy's and is conceptually easier
 * to understand because the output is clearly associated to the state.
 *
 *          Inputs (r1 r2)
 * State   00   01   10   11   Outputs (g1 g2)
 *        -------------------
 *   S0  | S0   S2   S1   S1 | 00   S0: no requests
 *   S1  | S0   S2   S1   S1 | 01   S1: resource granted to device 1
 *   S2  | S0   S2   S1   S2 | 10   S2: resource granted to device 2
 *        -------------------
 *            Next state
 */
 module arbiter2(
     input wire clk,    // clock
    input wire r1,      // request 1
     input wire r2,     // request 2
     output reg g1,     // grant 1
     output reg g2      // grant 2
     );

     // State encoding
     parameter [1:0]
         S0 = 2'b00,
         S1 = 2'b01,
         S2 = 2'b10;

    // State and next state variables
    reg [1:0] state, next_state;

    // State change process (sequential)
    always @(posedge clk)
        state <= next_state;

    // Next state calculation (combinational)
    always @* begin
        next_state = 2'bxx;
        case (state)
        S0: begin
            if (r1)
                next_state = S1;
            else if (r2)
                    next_state = S2;
            else
                next_state = S0;
        end
        S1: begin
            if (r1)
                next_state = S1;
            else if (r2)
                next_state = S2;
            else
                next_state = S0;
        end
        S2: begin
            if (r2)
                next_state = S2;
            else if (r1)
                next_state = S1;
            else
                next_state = S0;
        end
        default:
            next_state = S0;
        endcase
    end

    // Output calculation (combinational)
    always @* begin
        // Default values
        g1 = 0; g2 = 0;

        /* In the Moore's case, outputs are much easier to derive. */
        if (state == S1)
            g1 = 1;
        if (state == S2)
            g2 = 1;
    end
endmodule // arbiter2

/*
   (This lesson continues in 'arbiter_tb.v'.)
*/
