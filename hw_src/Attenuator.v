`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2018 01:11:00 PM
// Design Name: 
// Module Name: Attenuator
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


module Attenuator #(parameter C_S_AXI_ADDR_WIDTH = 6, parameter C_S_AXI_DATA_WIDTH = 32)
       ( // Axi4Lite Bus
        input       S_AXI_ACLK,
        input       S_AXI_ARESETN,
        input       [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_AWADDR,
        input       S_AXI_AWVALID,
        output      S_AXI_AWREADY,
        input       [C_S_AXI_DATA_WIDTH-1:0] S_AXI_WDATA,
        input       [3:0] S_AXI_WSTRB,
        input       S_AXI_WVALID,
        output      S_AXI_WREADY,
        output      [1:0] S_AXI_BRESP,
        output      S_AXI_BVALID,
        input       S_AXI_BREADY,
        input       [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_ARADDR,
        input       S_AXI_ARVALID,
        output      S_AXI_ARREADY,
        output      [C_S_AXI_DATA_WIDTH-1:0] S_AXI_RDATA,
        output      [1:0] S_AXI_RRESP,
        output      S_AXI_RVALID,
        input       S_AXI_RREADY,
        
        //Attenuation values
        output reg  [15:0] attenOutput0,
        output reg  [15:0] attenOutput1,
        output reg  [15:0] attenOutput2,
        output reg  [15:0] attenOutput3,
        output reg  [15:0] attenOutput4,
        output reg  [15:0] attenOutput5,
        output reg  [15:0] attenOutput6,
        output reg  [15:0] attenOutput7,
        output reg  [15:0] attenOutput8,
        output reg  [15:0] attenOutput9,
        output reg  [15:0] attenOutput10,
        output reg  [15:0] attenOutput11,
        output reg  [15:0] attenOutput12
    );
    
     wire wr,rd;
     wire [C_S_AXI_ADDR_WIDTH-1:0] wrAddr,rdAddr;
     wire [C_S_AXI_DATA_WIDTH-1:0] wrData;
     reg [C_S_AXI_DATA_WIDTH-1:0] rdData;
     
     reg [15:0] attenD[0:12], attenQ[0:12];
    /*     
     reg [15:0] attenQ_0,attenD_0;
     reg [15:0] attenQ_1,attenD_1;
     reg [15:0] attenQ_2,attenD_2;
     reg [15:0] attenQ_3,attenD_3;
     reg [15:0] attenQ_4,attenD_4;
     reg [15:0] attenQ_5,attenD_5;
     reg [15:0] attenQ_6,attenD_6;
     reg [15:0] attenQ_7,attenD_7;
     reg [15:0] attenQ_8,attenD_8;
     reg [15:0] attenQ_9,attenD_9;
     reg [15:0] attenQ_10,attenD_10;
     reg [15:0] attenQ_11,attenD_11;
     reg [15:0] attenQ_12,attenD_12;
     */
     
    Axi4LiteSupporter #(.C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH),.C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH)) Axi4LiteSupporter1 (
        // Simple Bus
        .wrAddr(wrAddr),                    // output   [C_S_AXI_ADDR_WIDTH-1:0]
        .wrData(wrData),                    // output   [C_S_AXI_DATA_WIDTH-1:0]
        .wr(wr),                            // output
        .rdAddr(rdAddr),                    // output   [C_S_AXI_ADDR_WIDTH-1:0]
        .rdData(rdData),                    // input    [C_S_AXI_ADDR_WIDTH-1:0]
        .rd(rd),                            // output   
        // Axi4Lite Bus
        .S_AXI_ACLK(S_AXI_ACLK),            // input
        .S_AXI_ARESETN(S_AXI_ARESETN),      // input
        .S_AXI_AWADDR(S_AXI_AWADDR),        // input    [C_S_AXI_ADDR_WIDTH-1:0]
        .S_AXI_AWVALID(S_AXI_AWVALID),      // input
        .S_AXI_AWREADY(S_AXI_AWREADY),      // output
        .S_AXI_WDATA(S_AXI_WDATA),          // input    [C_S_AXI_DATA_WIDTH-1:0]
        .S_AXI_WSTRB(S_AXI_WSTRB),          // input    [3:0]
        .S_AXI_WVALID(S_AXI_WVALID),        // input
        .S_AXI_WREADY(S_AXI_WREADY),        // output        
        .S_AXI_BRESP(S_AXI_BRESP),          // output   [1:0]
        .S_AXI_BVALID(S_AXI_BVALID),        // output
        .S_AXI_BREADY(S_AXI_BREADY),        // input
        .S_AXI_ARADDR(S_AXI_ARADDR),        // input    [C_S_AXI_ADDR_WIDTH-1:0]
        .S_AXI_ARVALID(S_AXI_ARVALID),      // input
        .S_AXI_ARREADY(S_AXI_ARREADY),      // output
        .S_AXI_RDATA(S_AXI_RDATA),          // output   [C_S_AXI_DATA_WIDTH-1:0]
        .S_AXI_RRESP(S_AXI_RRESP),          // output   [1:0]
        .S_AXI_RVALID(S_AXI_RVALID),        // output    
        .S_AXI_RREADY(S_AXI_RREADY)         // input
        ) ;
    
    integer i;
    always @ * begin
        
        attenOutput0 = attenQ[0];
        attenOutput1 = attenQ[1];
        attenOutput2 = attenQ[2];
        attenOutput3 = attenQ[3];
        attenOutput4 = attenQ[4];
        attenOutput5 = attenQ[5];
        attenOutput6 = attenQ[6];
        attenOutput7 = attenQ[7];
        attenOutput8 = attenQ[8];
        attenOutput9 = attenQ[9];
        attenOutput10 = attenQ[10];
        attenOutput11 = attenQ[11];
        attenOutput12 = attenQ[12];
            
        
    end
        
    always@(posedge S_AXI_ACLK) begin
      if (!S_AXI_ARESETN) begin
          for (i = 0; i < 13; i = i+1) begin
              attenQ[i] <= 16'h4000;
          end
      end
      else begin   
          for (i = 0; i < 13; i = i+1) begin
              attenQ[i] <= attenD[i];
          end
      end
    end
    
    always @ * begin
        //Defaults
        rdData = 0;
        for (i = 0; i < 13; i = i+1) begin
            attenD[i] = attenQ[i];
        end
         
        if(rd) begin
            rdData = attenQ[rdAddr[3:0]];
        end
        else if(wr) begin
             attenD[wrAddr[3:0]] = wrData;
        end 
    end
endmodule
