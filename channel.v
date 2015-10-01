/*
 * Copyright 2015, Stephen A. Rodgers. All rights reserved.
 *
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 * 
 */

`default_nettype none

// FIFO words per channel. Parameter is the power of 2 for a given depth.
// Mess with this to try on different FPGA's.
// The Lattice ICEstick can support a maximum depth of 9 or 512 bytes

`define FIFO_DEPTH 9 
//`define FIFO_DEPTH 8 // MAX depth for Lattice design with 4 channels.

// Edge detector

module edgedet(clk, rstn, datain, dataout, edgeseen);
	input clk;
	input rstn;
	input datain;
	output dataout;
	output reg edgeseen;
	reg [2:0] shiftreg;
	reg lastdata;
	reg initialsent;
	
	
	// After 2 stages of clock synchronization, re-output the data bit
	assign dataout = shiftreg[2];
	
	always @(posedge clk or negedge rstn) begin
		if(rstn == 0) begin
			edgeseen <= 0;
			shiftreg <= 3'b000; 
			lastdata <= 0; 
			initialsent <= 0; // This ensures an initial data bit is written into the FIFO after reset
			
		end else begin
			edgeseen <= 0;
			// Shift once to the right
			shiftreg[1:0] <= shiftreg[2:1];
			// Put the unsynchonized data in the msb
			shiftreg[2] <= datain;
			// Check for edge
			if((initialsent == 0) | (lastdata ^ shiftreg[0])) begin
				edgeseen <= 1;
				initialsent <= 1;
				lastdata <= shiftreg[0];
			end	
		end
	end
endmodule

			
/*
* Event logger channel
*/	


module channel(clk, rstn, datain, unload, counterin, byteaddr, clearoverrun, overrun, attention, dataout);
	input clk;			// Counter and fifo clock
	input rstn;			// Global reset, low true
	input datain;		// Data bit in
	input unload;		// Unloads a word from the fifo
	input [62:0] counterin; // Free running counter in
	input [2:0] byteaddr; // Byte address in long long word
	input clearoverrun;  // Clears overrun condition
	output overrun;		// Indicates an overrun condition occurred
	output attention;	// Indicates there is something needing attention
	output[7:0] dataout; // byte data out

	
	wire empty;
	wire full;
	wire datain_sync;
	wire [`FIFO_DEPTH-1:0] itemsinfifo;
	wire [63:0] fifooutputword;
	wire [63:0] fifoinputword;
	wire loaden;
	wire attention_int;
	
	reg overrun_int;
	reg attention_delayed;

	// Instantiate an edge detector
	edgedet ed0(
		.clk(clk),
		.rstn(rstn),
		.datain(datain),
		.dataout(datain_sync),
		.edgeseen(loaden)
	);
	
	
	// Instantiate a fifo
	ptrfifo fifo0(
	.clk(clk),
	.rstn(rstn),
	.loaden(loaden),
	.unloaden(unload),
	.datain(fifoinputword),
	.dataout(fifooutputword),
	.empty(empty),
	.full(full),
	.itemsinfifo(itemsinfifo)
	);
	
	defparam fifo0.WIDTH = 64;
	defparam fifo0.DEPTH = `FIFO_DEPTH;
	
	// Instantiate a mux
	mux64to8 mux0(
		.sel(byteaddr),
		.inword(fifooutputword),
		.outbyte(dataout)
	);
	
	// Merge the data and the free running counter
	// The data is in the lsb
	assign fifoinputword = {counterin, datain_sync};
	
	// Set attention if the FIFO isn't empty, or there was an overrun condition
	assign attention_int = ~empty | overrun_int;
	// Set external attention to attention_delayed
	assign attention = attention_delayed;
	// Set the external overun bit to the internal state
	assign overrun = overrun_int;

	// This detects and latches a FIFO overrun condition
	// and delays attention by one clock

	always @(posedge clk or negedge rstn) begin
		if(rstn == 0) begin
			overrun_int = 0;
			attention_delayed = 0;
		end else begin
			// Delay attention by a clock cycle
			attention_delayed = attention_int;
			// Clear the overrun flag if requested
			if(clearoverrun == 1)
				overrun_int = 0;
			else if(full & loaden)
				// Set the overrun flag on an error
				overrun_int = 1;
		end
	end
			
endmodule


	
	
