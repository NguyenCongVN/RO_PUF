`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/18/2020 06:25:06 PM
// Design Name:
// Module Name: PUF
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module PUF(input clk,
           input start,
           input [7:0] challenge,
           output [255:0] response,
           output done);
    
    
    wire [7:0] c;
    wire om0,om1,winner;
    wire [31:0] oc0,oc1;
    wire lfsrEN, srEN, countEN, refEN, roEN, seed_DV, countReset;
    wire [7:0] refcount;
    wire [15:0] o0, o1;
    
    genvar i;
    
    // for(i = 0; i<16; i = i+1) begin: ring0
    //  RO ro0 (roEN, c[7:4], o0[i]);
    // end
    
    RO ro00 (roEN, c[7:4], o0[0]);
    RO ro01 (roEN, c[7:4], o0[1]);
    RO ro02 (roEN, c[7:4], o0[2]);
    RO ro03 (roEN, c[7:4], o0[3]);
    RO ro04 (roEN, c[7:4], o0[4]);
    RO ro05 (roEN, c[7:4], o0[5]);
    RO ro06 (roEN, c[7:4], o0[6]);
    RO ro07 (roEN, c[7:4], o0[7]);
    RO ro08 (roEN, c[7:4], o0[8]);
    RO ro09 (roEN, c[7:4], o0[9]);
    RO ro010 (roEN, c[7:4], o0[10]);
    RO ro011 (roEN, c[7:4], o0[11]);
    RO ro012 (roEN, c[7:4], o0[12]);
    RO ro013 (roEN, c[7:4], o0[13]);
    RO ro014 (roEN, c[7:4], o0[14]);
    RO ro015 (roEN, c[7:4], o0[15]);
    
    // for(i = 0; i<16; i = i+1) begin: ring1
    // RO ro1(roEN, c[7:4], o1[i]);
    // end
    
    RO ro10 (roEN, c[7:4], o1[0]);
    RO ro11(roEN, c[7:4], o1[1]);
    RO ro12(roEN, c[7:4], o1[2]);
    RO ro13(roEN, c[7:4], o1[3]);
    RO ro14(roEN, c[7:4], o1[4]);
    RO ro15(roEN, c[7:4], o1[5]);
    RO ro16(roEN, c[7:4], o1[6]);
    RO ro17(roEN, c[7:4], o1[7]);
    RO ro18(roEN, c[7:4], o1[8]);
    RO ro19(roEN, c[7:4], o1[9]);
    RO ro110(roEN, c[7:4], o1[10]);
    RO ro111(roEN, c[7:4], o1[11]);
    RO ro112(roEN, c[7:4], o1[12]);
    RO ro113(roEN, c[7:4], o1[13]);
    RO ro114(roEN, c[7:4], o1[14]);
    RO ro115(roEN, c[7:4], o1[15]);
    
    mux16to1 mux0(
    .in(o0),
    .select(c[3:0]),
    .out(om0));
    
    mux16to1 mux1(
    .in(o1),
    .select(c[7:4]),
    .out(om1));
    
    counter_puf counter0(
    .clk(om0),
    .en(countEN),
    .reset(countReset),
    .q(oc0));
    
    counter_puf counter1(
    .clk(om1),
    .en(countEN),
    .reset(countReset),
    .q(oc1));
    
    counter_puf #(8) refcounter(
    .clk(clk),
    .en(refEN),
    .reset(countReset),
    .q(refcount));
    
    control CU(
    .clk(clk),
    .start(start),
    .refcount(refcount),
    .lfsrDV(seed_DV),
    .countEN(countEN),
    .refEN(refEN),
    .lfsrEN(lfsrEN),
    .srEN(srEN),
    .roEN(roEN),
    .countReset(countReset),
    .done(done)
    );
    
    comparator comp(
    .count0(oc0),
    .count1(oc1),
    .winner(winner));
    
    shiftReg SR(
    .clk(clk),
    .en(srEN),
    .s_in(winner),
    .p_out(response));
    
    LFSR #(8) LFSR0(
    .clk(clk),
    .en(lfsrEN),
    .seed_DV(seed_DV),
    .seed(challenge),
    .LFSR_data(c),
    .LFSR_done(LFSR_done)
    );
    
endmodule
