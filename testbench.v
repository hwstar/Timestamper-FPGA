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
`timescale 1ns/1ns

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
	wire testout0;
	wire testout1;
	wire testout2;
	wire testout3;
  
	
	root test_root(
		.clk(clk),
		.rstn(rstn),
		.datain_ch0(datain_ch0),
		.datain_ch1(datain_ch1),
		.datain_ch2(datain_ch2),
		.datain_ch3(datain_ch3),
		
		.serialout(serialout),
		.testout0(testout0),
		.testout1(testout1),
		.testout2(testout2),
		.testout3(testout3)
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
		#5000000
		datain_ch1 = 1;
		#1090
		datain_ch0 = 1;
		#610
		datain_ch0 = 0;
		#8300
		datain_ch1 = 0;
	
		
		//datain_ch0 = 1;
		//#2
		//datain_ch0 = 0;
		


		#10000000 $finish; 
	end
 
	always #5 clk = ~clk;


endmodule



  
