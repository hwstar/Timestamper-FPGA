// FIFO words per channel. Parameter is the power of 2 for a given depth.
// Mess with this to try on different FPGA's.
// The Lattice ICEstick can support a maximum depth of 9 or 512 bytes
`define FIFO_DEPTH 9 
//`define FIFO_DEPTH 8 // MAX depth for Lattice design with 4 channels.


`define BAUDRATE_DIVISOR 433 // Set this to whatever baudrate you need according to the following:
// divisor == system_clock/desired_baud_rate

