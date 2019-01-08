`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/04/2018 02:27:49 PM
// Design Name: 
// Module Name: Axi4LiteSupporter
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

// Axi4Lite Supporter module declaration
module Axi4LiteSupporter # 
    (parameter C_S_AXI_ADDR_WIDTH = 6, C_S_AXI_DATA_WIDTH = 32)
    (
        // Simple Bus
        output reg  [C_S_AXI_ADDR_WIDTH-1:0] wrAddr,
        output reg  [C_S_AXI_DATA_WIDTH-1:0] wrData,
        output reg  wr,
        output reg  [C_S_AXI_ADDR_WIDTH-1:0] rdAddr,
        input       [C_S_AXI_DATA_WIDTH-1:0] rdData,
        output reg  rd,
        // Axi4Lite Bus
        input       S_AXI_ACLK,
        input       S_AXI_ARESETN,
        input       [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_AWADDR,
        input       S_AXI_AWVALID,
        output reg  S_AXI_AWREADY,
        input       [C_S_AXI_DATA_WIDTH-1:0] S_AXI_WDATA,
        input       [3:0] S_AXI_WSTRB,
        input       S_AXI_WVALID,
        output reg  S_AXI_WREADY,
        output reg  [1:0] S_AXI_BRESP,
        output reg  S_AXI_BVALID,
        input       S_AXI_BREADY,
        input       [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_ARADDR,
        input       S_AXI_ARVALID,
        output reg  S_AXI_ARREADY,
        output reg  [C_S_AXI_DATA_WIDTH-1:0] S_AXI_RDATA,
        output reg  [1:0] S_AXI_RRESP,
        output reg  S_AXI_RVALID,
        input       S_AXI_RREADY
    );

//FSM States
parameter IDLE=0, RD1=1;
reg [3:0] nextState, currentState;
//Read Flops
reg [C_S_AXI_DATA_WIDTH-1:0] rdDataD, rdDataQ;

//Combinational logic
always@ * begin
    nextState = currentState;
    
    rdDataD = rdDataQ;
    wrData = 0;
    wrAddr = 0;
    rdAddr = 0;
    rd = 0;
    wr = 0;
    
    S_AXI_AWREADY = 0;
    S_AXI_WREADY = 0;
    S_AXI_BVALID = 0;
    S_AXI_BRESP = 0;
    
    S_AXI_ARREADY = 0;
    S_AXI_RRESP = 0;
    S_AXI_RVALID = 0;
    S_AXI_RDATA = 0;
    
    case(currentState)
        IDLE : begin
            if(S_AXI_ARVALID) begin
                S_AXI_ARREADY = 1;
                rdAddr = S_AXI_ARADDR;
                rdDataD = rdData;
                rd = 1;
                nextState = RD1;
            end
            if(S_AXI_AWVALID & S_AXI_WVALID & S_AXI_BREADY) begin
                wr = 1;
                wrAddr = S_AXI_AWADDR;
                wrData = S_AXI_WDATA;
                S_AXI_AWREADY = 1;
                S_AXI_WREADY = 1;
                S_AXI_BVALID = 1;
            end
        end
        RD1 : begin
            S_AXI_RDATA = rdDataQ;
            S_AXI_RVALID  = 1;
            if (S_AXI_RREADY) begin
                nextState = IDLE;
            end
        end
        endcase
        
end

//Sequential Logic
always @ (posedge S_AXI_ACLK) begin
    if (!S_AXI_ARESETN) begin
        currentState <= IDLE;
        rdDataQ <= 0;
    end else begin
        currentState <= nextState;
        rdDataQ <= rdDataD;
    end
end
endmodule
