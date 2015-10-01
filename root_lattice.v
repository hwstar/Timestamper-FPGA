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
 
 /*
 * This is the top level or 'root' of the design.
 *
 * This level should contain device-specific changes, signal inversions,
 * tri-state and testability logic.
 *
 * For example, PLL's and other device specific things would
 * be instantiated at this level. 
 *
 *
 * Modules further down in the heirarchy should be generic so that
 * different FPGA's can be retargeted with minimal fuss.
 *
 */
  
module root(clk, rstn, datain_ch0, datain_ch1, datain_ch2, datain_ch3, serialout);
	input clk;
	input rstn;
	input datain_ch0;
	input datain_ch1;
	input datain_ch2;
	input datain_ch3;
	output serialout;
	
	system sys0(
		.clk(clk),
		.rstn(rstn),
		.datain_ch0(datain_ch0),
		.datain_ch1(datain_ch1),
		.datain_ch2(datain_ch2),
		.datain_ch3(datain_ch3),
		.serialout(serialout)
	
	);
endmodule


	
