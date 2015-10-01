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

// A parallel input shift register clocked on falling edge
`default_nettype none
`timescale 10ns/1ns

// Main test module        
  
module testbench;
  

	reg clk; 
	reg rstn;
	reg datain_ch0;
	reg datain_ch1;
	reg datain_ch2;
	reg datain_ch3;
	integer i;
	wire serialout;
  
	
	root test_root(
		.clk(clk),
		.rstn(rstn),
		.datain_ch0(datain_ch0),
		.datain_ch1(datain_ch1),
		.datain_ch2(datain_ch2),
		.datain_ch3(datain_ch3),
		
		.serialout(serialout)
	
	);


	initial begin
		$dumpvars(0, testbench);
	
		clk = 0;
	
		rstn = 0;
		datain_ch0 = 0;
		datain_ch1 = 0;
		datain_ch2 = 0;
		datain_ch3 = 0;
		#10
		rstn = 1;
		#100
		
		//datain_ch0 = 1;
		//#2
		//datain_ch0 = 0;
		


		#1000000 $finish; 
	end
 
	always #1 clk = ~clk;


endmodule



  
