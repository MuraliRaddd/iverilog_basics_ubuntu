// Design:      rommul_bcd
// File:        rommul_bcd.v
// Description: ROM-based 4-bit BCD multiplier
// Author:      Jorge Juan-Chico <jjchico@dte.us.es>
// Date:        16-01-2013 (initial version)

/*
   Lesson 8.1. ROM-based 4-bit BCD multiplier.

   A common application of ROM memories is to store pre-calculated data. This
   is normally easier and faster than designing a circuit that does the
   calculation using an algorithm. However, this solution is only feasible if
   the number of data to be stored is relatively small so that the needed ROM
   is not too big.

   In this example we will use a ROM with 256 positions of 8 bits each (a
   256x8 ROM) to implement a multiplier of decimal number represented with
   four bits (BCD). At each ROM position, the result in BCD of multiplying
   the two BCD digits represented by the address number. For example,
   address 'b01111000 will store data 'b01011100 since:

        0111 x 1000 = 0101 1100
           7 x    8 =    5    6

   We will use Verilog's hexadecimal representation in the example because it is
   specially convenient to represent BCD numbers since, for example, the BCD
   representation of number 56 corresponds to the data that is represented in
   hexadecimal format as 'h56.
 */

`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////
// ROM-based 4-bit BCD multiplier                                       //
//////////////////////////////////////////////////////////////////////////

// ROM 256x8
module rom256x8 (
    input wire [7:0] a,     // address bus
    output reg [7:0] d      // data bus
    );

    // ROM design and contents
    /* The most straightforward way to describe a ROM in Verilog is by using
     * a 'case' statement where only one variable is assigned (the output data
     * port) depending on the value of the address. This behavior matches
     * the operation of a ROM exactly. Synthesis tools will not have any problem
     * to identify this structure and derive an efficient implementation of the
     * ROM. In the code below, the output is assigned for every input address
     * as explained above. Non-BCD inputs are assigned the unknown or don't
     * care value 'x'.*/
    always @(*)
        case (a)
        8'h00:  d = 8'h00;      8'h50:  d = 9'h00;
        8'h01:  d = 8'h00;      8'h51:  d = 9'h05;
        8'h02:  d = 8'h00;      8'h52:  d = 9'h10;
        8'h03:  d = 8'h00;      8'h53:  d = 9'h15;
        8'h04:  d = 8'h00;      8'h54:  d = 9'h20;
        8'h05:  d = 8'h00;      8'h55:  d = 9'h25;
        8'h06:  d = 8'h00;      8'h56:  d = 9'h30;
        8'h07:  d = 8'h00;      8'h57:  d = 9'h35;
        8'h08:  d = 8'h00;      8'h58:  d = 9'h40;
        8'h09:  d = 8'h00;      8'h59:  d = 9'h45;
        8'h10:  d = 8'h00;      8'h60:  d = 9'h00;
        8'h11:  d = 8'h01;      8'h61:  d = 9'h06;
        8'h12:  d = 8'h02;      8'h62:  d = 9'h12;
        8'h13:  d = 8'h03;      8'h63:  d = 9'h18;
        8'h14:  d = 8'h04;      8'h64:  d = 9'h24;
        8'h15:  d = 8'h05;      8'h65:  d = 9'h30;
        8'h16:  d = 8'h06;      8'h66:  d = 9'h36;
        8'h17:  d = 8'h07;      8'h67:  d = 9'h42;
        8'h18:  d = 8'h08;      8'h68:  d = 9'h48;
        8'h19:  d = 8'h09;      8'h69:  d = 9'h63;
        8'h20:  d = 8'h00;      8'h70:  d = 9'h00;
        8'h21:  d = 8'h02;      8'h71:  d = 9'h07;
        8'h22:  d = 8'h04;      8'h72:  d = 9'h14;
        8'h23:  d = 8'h06;      8'h73:  d = 9'h21;
        8'h24:  d = 8'h08;      8'h74:  d = 9'h28;
        8'h25:  d = 8'h10;      8'h75:  d = 9'h35;
        8'h26:  d = 8'h12;      8'h76:  d = 9'h42;
        8'h27:  d = 8'h14;      8'h77:  d = 9'h49;
        8'h28:  d = 8'h16;      8'h78:  d = 9'h56;
        8'h29:  d = 8'h18;      8'h79:  d = 9'h73;
        8'h30:  d = 8'h00;      8'h80:  d = 9'h00;
        8'h31:  d = 8'h03;      8'h81:  d = 9'h08;
        8'h32:  d = 8'h00;      8'h82:  d = 9'h16;
        8'h33:  d = 8'h00;      8'h83:  d = 9'h24;
        8'h34:  d = 8'h12;      8'h84:  d = 9'h32;
        8'h35:  d = 8'h15;      8'h85:  d = 9'h40;
        8'h36:  d = 8'h18;      8'h86:  d = 9'h48;
        8'h37:  d = 8'h21;      8'h87:  d = 9'h56;
        8'h38:  d = 8'h24;      8'h88:  d = 9'h64;
        8'h39:  d = 8'h27;      8'h89:  d = 9'h72;
        8'h40:  d = 8'h00;      8'h90:  d = 9'h00;
        8'h41:  d = 8'h04;      8'h91:  d = 9'h09;
        8'h42:  d = 8'h08;      8'h92:  d = 9'h18;
        8'h43:  d = 8'h12;      8'h93:  d = 9'h27;
        8'h44:  d = 8'h16;      8'h94:  d = 9'h36;
        8'h45:  d = 8'h20;      8'h95:  d = 9'h45;
        8'h46:  d = 8'h24;      8'h96:  d = 9'h54;
        8'h47:  d = 8'h28;      8'h97:  d = 9'h63;
        8'h48:  d = 8'h32;      8'h98:  d = 9'h72;
        8'h49:  d = 8'h36;      8'h99:  d = 9'h81;
        default: d = 8'hxx;
        endcase
endmodule // rom256x8

// Multiplier: 4-bit input, 8-bit output

module rommul_bcd (
    input wire [3:0] x,     // first operand
    input wire [3:0] y,     // second operand
    output wire [7:0] z     // output
    );

    // Multiplier
    /* Results are pre-calculated in the ROM so it is enough to make the
     * appropriate connections to the buses. */
    rom256x8 rom_instance1 (.a({x, y}), .d(z));

endmodule // rommul_bcd

/*
   EXERCISE

   1. Compile the module in this file with:

        $ iverilog rommul_bcd.v

      to check that there are not syntax errors.
*/
