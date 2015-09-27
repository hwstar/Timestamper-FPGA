/*
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

// A parallel input shift register clocked on falling edge
`default_nettype none
`timescale 10ns/1ns

// Main test module        
  
module testbench;
  

	reg clk; 
	reg clk184;
	reg ce;
	reg rstn;
	reg load;
	reg [7:0] inbyte;
	
	wire busy;
	
	utx utx0(
		.clk(clk),
		.rstn(rstn),
		.inbyte(inbyte),
		.load(load),
		.busy(busy)
	);


	initial begin
		$dumpvars(0, testbench);	
		clk = 0;
		rstn = 0;
		load = 0;
		inbyte = 8'h55;
		# 10
		rstn = 1;
		# 10
		load = 1;
		# 10
		load = 0;
		#8700
		inbyte = 8'haa;
		load = 1;
		# 10
		load = 0;
		
		
		#100000 $finish; 
	end
 
	always #5 clk = ~clk;

endmodule



  
