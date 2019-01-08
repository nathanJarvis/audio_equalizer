`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2018 11:53:17 AM
// Design Name: 
// Module Name: Bus_Mux
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


module Bus_Mux#(C_S_AXI_ADDR_WIDTH = 6, C_S_AXI_DATA_WIDTH = 32, TAP_WIDTH=16)
    (
    //Axi4Lite Bus
    input       S_AXI_ACLK_0,
    input       S_AXI_ARESETN_0,
    input       [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_AWADDR_0,
    input       S_AXI_AWVALID_0,
    output reg     S_AXI_AWREADY_0,
    input       [C_S_AXI_DATA_WIDTH-1:0] S_AXI_WDATA_0,
    input       [3:0] S_AXI_WSTRB_0,
    input       S_AXI_WVALID_0,
    output reg     S_AXI_WREADY_0,
    output reg    [1:0] S_AXI_BRESP_0,
    output reg     S_AXI_BVALID_0,
    input       S_AXI_BREADY_0,
    input       [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_ARADDR_0,
    input       S_AXI_ARVALID_0,
    output reg     S_AXI_ARREADY_0,
    output reg     [C_S_AXI_DATA_WIDTH-1:0] S_AXI_RDATA_0,
    output reg     [1:0] S_AXI_RRESP_0,
    output reg     S_AXI_RVALID_0,
    input       S_AXI_RREADY_0,
      
    //controller
    input       S_AXI_ACLK_1,
    input       S_AXI_ARESETN_1,
    input       [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_AWADDR_1,
    input       S_AXI_AWVALID_1,
    output  reg   S_AXI_AWREADY_1,
    input       [C_S_AXI_DATA_WIDTH-1:0] S_AXI_WDATA_1,
    input       [3:0] S_AXI_WSTRB_1,
    input       S_AXI_WVALID_1,
    output  reg    S_AXI_WREADY_1,
    output  reg    [1:0] S_AXI_BRESP_1,
    output  reg    S_AXI_BVALID_1,
    input       S_AXI_BREADY_1,
    input       [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_ARADDR_1,
    input       S_AXI_ARVALID_1,
    output  reg    S_AXI_ARREADY_1,
    output  reg    [C_S_AXI_DATA_WIDTH-1:0] S_AXI_RDATA_1,
    output  reg    [1:0] S_AXI_RRESP_1,
    output  reg    S_AXI_RVALID_1,
    input       S_AXI_RREADY_1,
        
    //output
    output   reg    S_AXI_ACLK_MUX_OUT,
    output   reg   S_AXI_ARESETN_MUX_OUT,
    output   reg    [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_AWADDR_MUX_OUT,
    output   reg    S_AXI_AWVALID_MUX_OUT,
    input      S_AXI_AWREADY_MUX_OUT,
    output   reg    [C_S_AXI_DATA_WIDTH-1:0] S_AXI_WDATA_MUX_OUT,
    output   reg    [3:0] S_AXI_WSTRB_MUX_OUT,
    output   reg    S_AXI_WVALID_MUX_OUT,
    input      S_AXI_WREADY_MUX_OUT,
    input      [1:0] S_AXI_BRESP_MUX_OUT,
    input      S_AXI_BVALID_MUX_OUT,
    output   reg    S_AXI_BREADY_MUX_OUT,
    output   reg    [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_ARADDR_MUX_OUT,
    output   reg    S_AXI_ARVALID_MUX_OUT,
    input      S_AXI_ARREADY_MUX_OUT,
    input      [C_S_AXI_DATA_WIDTH-1:0] S_AXI_RDATA_MUX_OUT,
    input      [1:0] S_AXI_RRESP_MUX_OUT,
    input      S_AXI_RVALID_MUX_OUT,
    output   reg    S_AXI_RREADY_MUX_OUT,  
      
    //Select signal
    input select 
    );
    
    always @ * begin
    S_AXI_AWREADY_0 = 0;
    S_AXI_AWREADY_1 = 0;
    S_AXI_WREADY_0 = 0;
    S_AXI_WREADY_1 = 0;
    S_AXI_BRESP_0 = 0;
    S_AXI_BRESP_1 = 0;
    S_AXI_BVALID_0 = 0;
    S_AXI_BVALID_1 = 0;
    S_AXI_ARREADY_0 = 0;
    S_AXI_ARREADY_1 = 0;
    S_AXI_RDATA_0 = 0;
    S_AXI_RDATA_1 = 0;
    S_AXI_RRESP_0 = 0;
    S_AXI_RRESP_1 = 0;
    S_AXI_RVALID_0 = 0;
    S_AXI_RVALID_1 = 0;
    
    
    if(select == 0) begin
         S_AXI_ACLK_MUX_OUT = S_AXI_ACLK_0;
         S_AXI_ARESETN_MUX_OUT = S_AXI_ARESETN_0;
         S_AXI_AWADDR_MUX_OUT =  S_AXI_AWADDR_0;
         S_AXI_AWVALID_MUX_OUT =  S_AXI_AWVALID_0;
         S_AXI_AWREADY_0      = S_AXI_AWREADY_MUX_OUT;
         S_AXI_WDATA_MUX_OUT =  S_AXI_WDATA_0;
         S_AXI_WSTRB_MUX_OUT =  S_AXI_WSTRB_0;
         S_AXI_WVALID_MUX_OUT =  S_AXI_WVALID_0;
         S_AXI_WREADY_0 = S_AXI_WREADY_MUX_OUT;
         S_AXI_BRESP_0 = S_AXI_BRESP_MUX_OUT;
         S_AXI_BVALID_0  = S_AXI_BVALID_MUX_OUT;
         S_AXI_BREADY_MUX_OUT = S_AXI_BREADY_0;
         S_AXI_ARADDR_MUX_OUT =  S_AXI_ARADDR_0;
         S_AXI_ARVALID_MUX_OUT = S_AXI_ARVALID_0;
         S_AXI_ARREADY_0 = S_AXI_ARREADY_MUX_OUT;
         S_AXI_RDATA_0 = S_AXI_RDATA_MUX_OUT;
         S_AXI_RRESP_0 =  S_AXI_RRESP_MUX_OUT;
         S_AXI_RVALID_0  =   S_AXI_RVALID_MUX_OUT;
         S_AXI_RREADY_MUX_OUT = S_AXI_RREADY_0;
    end
    else begin
         S_AXI_ACLK_MUX_OUT = S_AXI_ACLK_1;
         S_AXI_ARESETN_MUX_OUT = S_AXI_ARESETN_1;
         S_AXI_AWADDR_MUX_OUT =  S_AXI_AWADDR_1;
         S_AXI_AWVALID_MUX_OUT =  S_AXI_AWVALID_1;
         S_AXI_AWREADY_1      = S_AXI_AWREADY_MUX_OUT;
         S_AXI_WDATA_MUX_OUT =  S_AXI_WDATA_1;
         S_AXI_WSTRB_MUX_OUT =  S_AXI_WSTRB_1;
         S_AXI_WVALID_MUX_OUT =  S_AXI_WVALID_1;
         S_AXI_WREADY_1 = S_AXI_WREADY_MUX_OUT;
         S_AXI_BRESP_1 = S_AXI_BRESP_MUX_OUT;
         S_AXI_BVALID_1  = S_AXI_BVALID_MUX_OUT;
         S_AXI_BREADY_MUX_OUT = S_AXI_BREADY_1;
         S_AXI_ARADDR_MUX_OUT =  S_AXI_ARADDR_1;
         S_AXI_ARVALID_MUX_OUT = S_AXI_ARVALID_1;
         S_AXI_ARREADY_1 = S_AXI_ARREADY_MUX_OUT;
         S_AXI_RDATA_1 = S_AXI_RDATA_MUX_OUT;
         S_AXI_RRESP_1 =  S_AXI_RRESP_MUX_OUT;
         S_AXI_RVALID_1  =   S_AXI_RVALID_MUX_OUT;
         S_AXI_RREADY_MUX_OUT = S_AXI_RREADY_1;
    end
    end
   
endmodule
