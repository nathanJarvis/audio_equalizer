`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2018 01:59:10 PM
// Design Name: 
// Module Name: Eq_Controller
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


module Eq_Controller #(C_S_AXI_ADDR_WIDTH = 6, C_S_AXI_DATA_WIDTH = 32, TAP_WIDTH=16)
    (
    //Controller BUS
    input       S_AXI_ACLK,
    input       S_AXI_ARESETN,
    input       [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_AWADDR_CONTROLLER,
    input       S_AXI_AWVALID_CONTROLLER,
    output      S_AXI_AWREADY_CONTROLLER,
    input       [C_S_AXI_DATA_WIDTH-1:0] S_AXI_WDATA_CONTROLLER,
    input       [3:0] S_AXI_WSTRB_CONTROLLER,
    input       S_AXI_WVALID_CONTROLLER,
    output      S_AXI_WREADY_CONTROLLER,
    output      [1:0] S_AXI_BRESP_CONTROLLER,
    output      S_AXI_BVALID_CONTROLLER,
    input       S_AXI_BREADY_CONTROLLER,
    input       [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_ARADDR_CONTROLLER,
    input       S_AXI_ARVALID_CONTROLLER,
    output      S_AXI_ARREADY_CONTROLLER,
    output      [C_S_AXI_DATA_WIDTH-1:0] S_AXI_RDATA_CONTROLLER,
    output      [1:0] S_AXI_RRESP_CONTROLLER,
    output      S_AXI_RVALID_CONTROLLER,
    input       S_AXI_RREADY_CONTROLLER,
    
    //Microblaze direct AXI to filter
    //input       S_AXI_ACLK_MB_MUX,
    //input       S_AXI_ARESETN_MB_MUX,
    input       [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_AWADDR_MB_MUX,
    input       S_AXI_AWVALID_MB_MUX,
    output      S_AXI_AWREADY_MB_MUX,
    input       [C_S_AXI_DATA_WIDTH-1:0] S_AXI_WDATA_MB_MUX,
    input       [3:0] S_AXI_WSTRB_MB_MUX,
    input       S_AXI_WVALID_MB_MUX,
    output      S_AXI_WREADY_MB_MUX,
    output      [1:0] S_AXI_BRESP_MB_MUX,
    output      S_AXI_BVALID_MB_MUX,
    input       S_AXI_BREADY_MB_MUX,
    input       [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_ARADDR_MB_MUX,
    input       S_AXI_ARVALID_MB_MUX,
    output      S_AXI_ARREADY_MB_MUX,
    output      [C_S_AXI_DATA_WIDTH-1:0] S_AXI_RDATA_MB_MUX,
    output      [1:0] S_AXI_RRESP_MB_MUX,
    output      S_AXI_RVALID_MB_MUX,
    input       S_AXI_RREADY_MB_MUX,
    
    //Microblaze direct AXI to attenuator
    input       [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_AWADDR_ATTEN,
    input       S_AXI_AWVALID_ATTEN,
    output      S_AXI_AWREADY_ATTEN,
    input       [C_S_AXI_DATA_WIDTH-1:0] S_AXI_WDATA_ATTEN,
    input       [3:0] S_AXI_WSTRB_ATTEN,
    input       S_AXI_WVALID_ATTEN,
    output      S_AXI_WREADY_ATTEN,
    output      [1:0] S_AXI_BRESP_ATTEN,
    output      S_AXI_BVALID_ATTEN,
    input       S_AXI_BREADY_ATTEN,
    input       [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_ARADDR_ATTEN,
    input       S_AXI_ARVALID_ATTEN,
    output      S_AXI_ARREADY_ATTEN,
    output      [C_S_AXI_DATA_WIDTH-1:0] S_AXI_RDATA_ATTEN,
    output      [1:0] S_AXI_RRESP_ATTEN,
    output      S_AXI_RVALID_ATTEN,
    input       S_AXI_RREADY_ATTEN,
    
    //ADC SPI Bus
    output      ADC_SCK,
    output      ADC_SDI,
    output      ADC_CS_,
    input       ADC_SDO,
    
    //DAC SPI Bus
    output      DAC_SCK,
    output      DAC_SDI,
    output      DAC_CS_,
    input       DAC_SDO
    );
    
    // Simple bus for Microblaze<->Controller
    wire wr_CONTROLLER,rd_CONTROLLER;
    wire [C_S_AXI_ADDR_WIDTH-1:0] wrAddr_CONTROLLER,rdAddr_CONTROLLER;
    wire [C_S_AXI_DATA_WIDTH-1:0] wrData_CONTROLLER;
    reg [C_S_AXI_DATA_WIDTH-1:0] rdData_CONTROLLER;
    
    //Axi4LiteSupporter for MicroBlaze<->Controller
    Axi4LiteSupporter #(.C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH),.C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH)) Axi4LiteSupporter_C 
        (
        // Simple Bus
        .wrAddr(wrAddr_CONTROLLER),                    // output   [C_S_AXI_ADDR_WIDTH-1:0]
        .wrData(wrData_CONTROLLER),                    // output   [C_S_AXI_DATA_WIDTH-1:0]
        .wr(wr_CONTROLLER),                            // output
        .rdAddr(rdAddr_CONTROLLER),                    // output   [C_S_AXI_ADDR_WIDTH-1:0]
        .rdData(rdData_CONTROLLER),                    // input    [C_S_AXI_ADDR_WIDTH-1:0]
        .rd(rd_CONTROLLER),                            // output   
        // Axi4Lite Bus
        .S_AXI_ACLK(S_AXI_ACLK),            // input
        .S_AXI_ARESETN(S_AXI_ARESETN),      // input
        .S_AXI_AWADDR(S_AXI_AWADDR_CONTROLLER),        // input    [C_S_AXI_ADDR_WIDTH-1:0]
        .S_AXI_AWVALID(S_AXI_AWVALID_CONTROLLER),      // input
        .S_AXI_AWREADY(S_AXI_AWREADY_CONTROLLER),      // output
        .S_AXI_WDATA(S_AXI_WDATA_CONTROLLER),          // input    [C_S_AXI_DATA_WIDTH-1:0]
        .S_AXI_WSTRB(S_AXI_WSTRB_CONTROLLER),          // input    [3:0]
        .S_AXI_WVALID(S_AXI_WVALID_CONTROLLER),        // input
        .S_AXI_WREADY(S_AXI_WREADY_CONTROLLER),        // output        
        .S_AXI_BRESP(S_AXI_BRESP_CONTROLLER),          // output   [1:0]
        .S_AXI_BVALID(S_AXI_BVALID_CONTROLLER),        // output
        .S_AXI_BREADY(S_AXI_BREADY_CONTROLLER),        // input
        .S_AXI_ARADDR(S_AXI_ARADDR_CONTROLLER),        // input    [C_S_AXI_ADDR_WIDTH-1:0]
        .S_AXI_ARVALID(S_AXI_ARVALID_CONTROLLER),      // input
        .S_AXI_ARREADY(S_AXI_ARREADY_CONTROLLER),      // output
        .S_AXI_RDATA(S_AXI_RDATA_CONTROLLER),          // output   [C_S_AXI_DATA_WIDTH-1:0]
        .S_AXI_RRESP(S_AXI_RRESP_CONTROLLER),          // output   [1:0]
        .S_AXI_RVALID(S_AXI_RVALID_CONTROLLER),        // output    
        .S_AXI_RREADY(S_AXI_RREADY_CONTROLLER)         // input
    );
    
    // Simple bus for Controller<->ADC
    reg wr_ADC,rd_ADC;
    reg [C_S_AXI_ADDR_WIDTH-1:0] wrAddr_ADC,rdAddr_ADC;
    reg [C_S_AXI_DATA_WIDTH-1:0] wrData_ADC;
    wire [C_S_AXI_DATA_WIDTH-1:0] rdData_ADC;
    wire wrDone_ADC,rdDone_ADC;
    // Axi4Lite signals for Controller<->ADC
    wire [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_AWADDR_ADC;
    wire  S_AXI_AWVALID_ADC;
    wire S_AXI_AWREADY_ADC;
    wire  [C_S_AXI_DATA_WIDTH-1:0] S_AXI_WDATA_ADC;
    wire  [3:0] S_AXI_WSTRB_ADC;
    wire  S_AXI_WVALID_ADC;
    wire S_AXI_WREADY_ADC;
    wire [1:0] S_AXI_BRESP_ADC;
    wire S_AXI_BVALID_ADC;
    wire  S_AXI_BREADY_ADC;
    wire  [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_ARADDR_ADC;
    wire  S_AXI_ARVALID_ADC;
    wire S_AXI_ARREADY_ADC;
    wire [C_S_AXI_DATA_WIDTH-1:0] S_AXI_RDATA_ADC;
    wire [1:0] S_AXI_RRESP_ADC;
    wire S_AXI_RVALID_ADC;
    wire  S_AXI_RREADY_ADC;
    
    Axi4LiteManager #(.C_M_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH), .C_M_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH)) Axi4LiteManager_ADC
        (
        // Simple Bus
        .wrAddr(wrAddr_ADC),                    // input    [C_M_AXI_ADDR_WIDTH-1:0]
        .wrData(wrData_ADC),                    // input    [C_M_AXI_DATA_WIDTH-1:0]
        .wr(wr_ADC),                            // input    
        .wrDone(wrDone_ADC),                    // output
        .rdAddr(rdAddr_ADC),                    // input    [C_M_AXI_ADDR_WIDTH-1:0]
        .rdData(rdData_ADC),                    // input    [C_M_AXI_DATA_WIDTH-1:0]
        .rd(rd_ADC),                            // input    
        .rdDone(rdDone_ADC),                    // output
        // Axi4Lite Bus
        .M_AXI_ACLK(S_AXI_ACLK),            // input
        .M_AXI_ARESETN(S_AXI_ARESETN),      // input
        .M_AXI_AWADDR(S_AXI_AWADDR_ADC),        // output   [C_M_AXI_ADDR_WIDTH-1:0] 
        .M_AXI_AWVALID(S_AXI_AWVALID_ADC),      // output
        .M_AXI_AWREADY(S_AXI_AWREADY_ADC),      // input
        .M_AXI_WDATA(S_AXI_WDATA_ADC),          // output   [C_M_AXI_DATA_WIDTH-1:0]
        .M_AXI_WSTRB(S_AXI_WSTRB_ADC),          // output   [3:0]
        .M_AXI_WVALID(S_AXI_WVALID_ADC),        // output
        .M_AXI_WREADY(S_AXI_WREADY_ADC),        // input
        .M_AXI_BRESP(S_AXI_BRESP_ADC),          // input    [1:0]
        .M_AXI_BVALID(S_AXI_BVALID_ADC),        // input
        .M_AXI_BREADY(S_AXI_BREADY_ADC),        // output
        .M_AXI_ARADDR(S_AXI_ARADDR_ADC),        // output   [C_M_AXI_ADDR_WIDTH-1:0]
        .M_AXI_ARVALID(S_AXI_ARVALID_ADC),      // output
        .M_AXI_ARREADY(S_AXI_ARREADY_ADC),      // input
        .M_AXI_RDATA(S_AXI_RDATA_ADC),          // input    [C_M_AXI_DATA_WIDTH-1:0]
        .M_AXI_RRESP(S_AXI_RRESP_ADC),          // input    [1:0]
        .M_AXI_RVALID(S_AXI_RVALID_ADC),        // input
        .M_AXI_RREADY(S_AXI_RREADY_ADC)         // output
        );
    
    //ADC Instantiation
    SPI #(.C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH), .C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH)) ADC
        (
        //Axi4Lite Bus
        .S_AXI_ACLK(S_AXI_ACLK),            // input
        .S_AXI_ARESETN(S_AXI_ARESETN),      // input
        .S_AXI_AWADDR(S_AXI_AWADDR_ADC),        // input    [C_S_AXI_ADDR_WIDTH-1:0]
        .S_AXI_AWVALID(S_AXI_AWVALID_ADC),      // input
        .S_AXI_AWREADY(S_AXI_AWREADY_ADC),      // output
        .S_AXI_WDATA(S_AXI_WDATA_ADC),          // input    [C_S_AXI_DATA_WIDTH-1:0]
        .S_AXI_WSTRB(S_AXI_WSTRB_ADC),          // input    [3:0]
        .S_AXI_WVALID(S_AXI_WVALID_ADC),        // input
        .S_AXI_WREADY(S_AXI_WREADY_ADC),        // output        
        .S_AXI_BRESP(S_AXI_BRESP_ADC),          // output   [1:0]
        .S_AXI_BVALID(S_AXI_BVALID_ADC),        // output
        .S_AXI_BREADY(S_AXI_BREADY_ADC),        // input
        .S_AXI_ARADDR(S_AXI_ARADDR_ADC),        // input    [C_S_AXI_ADDR_WIDTH-1:0]
        .S_AXI_ARVALID(S_AXI_ARVALID_ADC),      // input
        .S_AXI_ARREADY(S_AXI_ARREADY_ADC),      // output
        .S_AXI_RDATA(S_AXI_RDATA_ADC),          // output   [C_S_AXI_DATA_WIDTH-1:0]
        .S_AXI_RRESP(S_AXI_RRESP_ADC),          // output   [1:0]
        .S_AXI_RVALID(S_AXI_RVALID_ADC),        // output    
        .S_AXI_RREADY(S_AXI_RREADY_ADC),        // input 
        
        //SPI Bus
        .SCK(ADC_SCK),
        .SDI(ADC_SDI),
        .CS_(ADC_CS_),
        .SDO(ADC_SDO)       
        );
        
    // Simple bus for Controller<->DAC
    reg wr_DAC,rd_DAC;
    reg [C_S_AXI_ADDR_WIDTH-1:0] wrAddr_DAC,rdAddr_DAC;
    reg [C_S_AXI_DATA_WIDTH-1:0] wrData_DAC;
    wire [C_S_AXI_DATA_WIDTH-1:0] rdData_DAC;
    wire wrDone_DAC,rdDone_DAC;
    // Axi4Lite signals for Controller<->DAC
    wire [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_AWADDR_DAC;
    wire  S_AXI_AWVALID_DAC;
    wire S_AXI_AWREADY_DAC;
    wire  [C_S_AXI_DATA_WIDTH-1:0] S_AXI_WDATA_DAC;
    wire  [3:0] S_AXI_WSTRB_DAC;
    wire  S_AXI_WVALID_DAC;
    wire S_AXI_WREADY_DAC;
    wire [1:0] S_AXI_BRESP_DAC;
    wire S_AXI_BVALID_DAC;
    wire  S_AXI_BREADY_DAC;
    wire  [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_ARADDR_DAC;
    wire  S_AXI_ARVALID_DAC;
    wire S_AXI_ARREADY_DAC;
    wire [C_S_AXI_DATA_WIDTH-1:0] S_AXI_RDATA_DAC;
    wire [1:0] S_AXI_RRESP_DAC;
    wire S_AXI_RVALID_DAC;
    wire  S_AXI_RREADY_DAC;
        
    Axi4LiteManager #(.C_M_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH), .C_M_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH)) Axi4LiteManager_DAC
        (
        // Simple Bus
        .wrAddr(wrAddr_DAC),                    // input    [C_M_AXI_ADDR_WIDTH-1:0]
        .wrData(wrData_DAC),                    // input    [C_M_AXI_DATA_WIDTH-1:0]
        .wr(wr_DAC),                            // input    
        .wrDone(wrDone_DAC),                    // output
        .rdAddr(rdAddr_DAC),                    // input    [C_M_AXI_ADDR_WIDTH-1:0]
        .rdData(rdData_DAC),                    // input    [C_M_AXI_DATA_WIDTH-1:0]
        .rd(rd_DAC),                            // input    
        .rdDone(rdDone_DAC),                    // output
        // Axi4Lite Bus
        .M_AXI_ACLK(S_AXI_ACLK),            // input
        .M_AXI_ARESETN(S_AXI_ARESETN),      // input
        .M_AXI_AWADDR(S_AXI_AWADDR_DAC),        // output   [C_M_AXI_ADDR_WIDTH-1:0] 
        .M_AXI_AWVALID(S_AXI_AWVALID_DAC),      // output
        .M_AXI_AWREADY(S_AXI_AWREADY_DAC),      // input
        .M_AXI_WDATA(S_AXI_WDATA_DAC),          // output   [C_M_AXI_DATA_WIDTH-1:0]
        .M_AXI_WSTRB(S_AXI_WSTRB_DAC),          // output   [3:0]
        .M_AXI_WVALID(S_AXI_WVALID_DAC),        // output
        .M_AXI_WREADY(S_AXI_WREADY_DAC),        // input
        .M_AXI_BRESP(S_AXI_BRESP_DAC),          // input    [1:0]
        .M_AXI_BVALID(S_AXI_BVALID_DAC),        // input
        .M_AXI_BREADY(S_AXI_BREADY_DAC),        // output
        .M_AXI_ARADDR(S_AXI_ARADDR_DAC),        // output   [C_M_AXI_ADDR_WIDTH-1:0]
        .M_AXI_ARVALID(S_AXI_ARVALID_DAC),      // output
        .M_AXI_ARREADY(S_AXI_ARREADY_DAC),      // input
        .M_AXI_RDATA(S_AXI_RDATA_DAC),          // input    [C_M_AXI_DATA_WIDTH-1:0]
        .M_AXI_RRESP(S_AXI_RRESP_DAC),          // input    [1:0]
        .M_AXI_RVALID(S_AXI_RVALID_DAC),        // input
        .M_AXI_RREADY(S_AXI_RREADY_DAC)         // output
        );
        
    //DAC Instantiation
    SPI #(.C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH), .C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH)) DAC
        (
        //Axi4Lite Bus
        .S_AXI_ACLK(S_AXI_ACLK),            // input
        .S_AXI_ARESETN(S_AXI_ARESETN),      // input
        .S_AXI_AWADDR(S_AXI_AWADDR_DAC),        // input    [C_S_AXI_ADDR_WIDTH-1:0]
        .S_AXI_AWVALID(S_AXI_AWVALID_DAC),      // input
        .S_AXI_AWREADY(S_AXI_AWREADY_DAC),      // output
        .S_AXI_WDATA(S_AXI_WDATA_DAC),          // input    [C_S_AXI_DATA_WIDTH-1:0]
        .S_AXI_WSTRB(S_AXI_WSTRB_DAC),          // input    [3:0]
        .S_AXI_WVALID(S_AXI_WVALID_DAC),        // input
        .S_AXI_WREADY(S_AXI_WREADY_DAC),        // output        
        .S_AXI_BRESP(S_AXI_BRESP_DAC),          // output   [1:0]
        .S_AXI_BVALID(S_AXI_BVALID_DAC),        // output
        .S_AXI_BREADY(S_AXI_BREADY_DAC),        // input
        .S_AXI_ARADDR(S_AXI_ARADDR_DAC),        // input    [C_S_AXI_ADDR_WIDTH-1:0]
        .S_AXI_ARVALID(S_AXI_ARVALID_DAC),      // input
        .S_AXI_ARREADY(S_AXI_ARREADY_DAC),      // output
        .S_AXI_RDATA(S_AXI_RDATA_DAC),          // output   [C_S_AXI_DATA_WIDTH-1:0]
        .S_AXI_RRESP(S_AXI_RRESP_DAC),          // output   [1:0]
        .S_AXI_RVALID(S_AXI_RVALID_DAC),        // output    
        .S_AXI_RREADY(S_AXI_RREADY_DAC),        // input 
        
        //SPI Bus
        .SCK(DAC_SCK),
        .SDI(DAC_SDI),
        .CS_(DAC_CS_),
        .SDO(DAC_SDO)       
        );
        
    // Simple bus for Controller<->filter
    reg wr_CONT_MUX,rd_CONT_MUX;
    reg [C_S_AXI_ADDR_WIDTH-1:0] wrAddr_CONT_MUX,rdAddr_CONT_MUX;
    reg [C_S_AXI_DATA_WIDTH-1:0] wrData_CONT_MUX;
    wire [C_S_AXI_DATA_WIDTH-1:0] rdData_CONT_MUX;
    wire wrDone_CONT_MUX,rdDone_CONT_MUX;
    // Axi4Lite signals for Controller<->filter
    wire S_AXI_ACLK_CONT_MUX;
    wire S_AXI_ARESETN_CONT_MUX;
    wire [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_AWADDR_CONT_MUX;
    wire  S_AXI_AWVALID_CONT_MUX;
    wire S_AXI_AWREADY_CONT_MUX;
    wire  [C_S_AXI_DATA_WIDTH-1:0] S_AXI_WDATA_CONT_MUX;
    wire  [3:0] S_AXI_WSTRB_CONT_MUX;
    wire  S_AXI_WVALID_CONT_MUX;
    wire S_AXI_WREADY_CONT_MUX;
    wire [1:0] S_AXI_BRESP_CONT_MUX;
    wire S_AXI_BVALID_CONT_MUX;
    wire  S_AXI_BREADY_CONT_MUX;
    wire  [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_ARADDR_CONT_MUX;
    wire  S_AXI_ARVALID_CONT_MUX;
    wire S_AXI_ARREADY_CONT_MUX;
    wire [C_S_AXI_DATA_WIDTH-1:0] S_AXI_RDATA_CONT_MUX;
    wire [1:0] S_AXI_RRESP_CONT_MUX;
    wire S_AXI_RVALID_CONT_MUX;
    wire  S_AXI_RREADY_CONT_MUX;
        
    Axi4LiteManager #(.C_M_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH), .C_M_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH)) Axi4LiteManager_CONT_MUX
        (
        // Simple Bus
        .wrAddr(wrAddr_CONT_MUX),                    // input    [C_M_AXI_ADDR_WIDTH-1:0]
        .wrData(wrData_CONT_MUX),                    // input    [C_M_AXI_DATA_WIDTH-1:0]
        .wr(wr_CONT_MUX),                            // input    
        .wrDone(wrDone_CONT_MUX),                    // output
        .rdAddr(rdAddr_CONT_MUX),                    // input    [C_M_AXI_ADDR_WIDTH-1:0]
        .rdData(rdData_CONT_MUX),                    // input    [C_M_AXI_DATA_WIDTH-1:0]
        .rd(rd_CONT_MUX),                            // input    
        .rdDone(rdDone_CONT_MUX),                    // output
        // Axi4Lite Bus
        .M_AXI_ACLK(S_AXI_ACLK),            // input
        .M_AXI_ARESETN(S_AXI_ARESETN),      // input
        .M_AXI_AWADDR(S_AXI_AWADDR_CONT_MUX),        // output   [C_M_AXI_ADDR_WIDTH-1:0] 
        .M_AXI_AWVALID(S_AXI_AWVALID_CONT_MUX),      // output
        .M_AXI_AWREADY(S_AXI_AWREADY_CONT_MUX),      // input
        .M_AXI_WDATA(S_AXI_WDATA_CONT_MUX),          // output   [C_M_AXI_DATA_WIDTH-1:0]
        .M_AXI_WSTRB(S_AXI_WSTRB_CONT_MUX),          // output   [3:0]
        .M_AXI_WVALID(S_AXI_WVALID_CONT_MUX),        // output
        .M_AXI_WREADY(S_AXI_WREADY_CONT_MUX),        // input
        .M_AXI_BRESP(S_AXI_BRESP_CONT_MUX),          // input    [1:0]
        .M_AXI_BVALID(S_AXI_BVALID_CONT_MUX),        // input
        .M_AXI_BREADY(S_AXI_BREADY_CONT_MUX),        // output
        .M_AXI_ARADDR(S_AXI_ARADDR_CONT_MUX),        // output   [C_M_AXI_ADDR_WIDTH-1:0]
        .M_AXI_ARVALID(S_AXI_ARVALID_CONT_MUX),      // output
        .M_AXI_ARREADY(S_AXI_ARREADY_CONT_MUX),      // input
        .M_AXI_RDATA(S_AXI_RDATA_CONT_MUX),          // input    [C_M_AXI_DATA_WIDTH-1:0]
        .M_AXI_RRESP(S_AXI_RRESP_CONT_MUX),          // input    [1:0]
        .M_AXI_RVALID(S_AXI_RVALID_CONT_MUX),        // input
        .M_AXI_RREADY(S_AXI_RREADY_CONT_MUX)         // output
        );

    //AXI signales mux<->filter
    wire S_AXI_ACLK_FILTER;
    wire S_AXI_ARESETN_FILTER;
    wire [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_AWADDR_FILTER;
    wire  S_AXI_AWVALID_FILTER;
    wire S_AXI_AWREADY_FILTER;
    wire  [C_S_AXI_DATA_WIDTH-1:0] S_AXI_WDATA_FILTER;
    wire  [3:0] S_AXI_WSTRB_FILTER;
    wire  S_AXI_WVALID_FILTER;
    wire S_AXI_WREADY_FILTER;
    wire [1:0] S_AXI_BRESP_FILTER;
    wire S_AXI_BVALID_FILTER;
    wire  S_AXI_BREADY_FILTER;
    wire  [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_ARADDR_FILTER;
    wire  S_AXI_ARVALID_FILTER;
    wire S_AXI_ARREADY_FILTER;
    wire [C_S_AXI_DATA_WIDTH-1:0] S_AXI_RDATA_FILTER;
    wire [1:0] S_AXI_RRESP_FILTER;
    wire S_AXI_RVALID_FILTER;
    wire  S_AXI_RREADY_FILTER;
    
    reg select;
            
    //Bus mux instantiation
    Bus_Mux #(.C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH),.C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH)) Bus_Mux 
            (
            .S_AXI_ACLK_0(S_AXI_ACLK),
            .S_AXI_ARESETN_0(S_AXI_ARESETN),
            .S_AXI_AWADDR_0(S_AXI_AWADDR_MB_MUX),
            .S_AXI_AWVALID_0(S_AXI_AWVALID_MB_MUX),
            .S_AXI_AWREADY_0(S_AXI_AWREADY_MB_MUX),
            .S_AXI_WDATA_0(S_AXI_WDATA_MB_MUX),
            .S_AXI_WSTRB_0(S_AXI_WSTRB_MB_MUX),
            .S_AXI_WVALID_0(S_AXI_WVALID_MB_MUX),
            .S_AXI_WREADY_0(S_AXI_WREADY_MB_MUX),        
            .S_AXI_BRESP_0(S_AXI_BRESP_MB_MUX),
            .S_AXI_BVALID_0(S_AXI_BVALID_MB_MUX),
            .S_AXI_BREADY_0(S_AXI_BREADY_MB_MUX),
            .S_AXI_ARADDR_0(S_AXI_ARADDR_MB_MUX),
            .S_AXI_ARVALID_0(S_AXI_ARVALID_MB_MUX),
            .S_AXI_ARREADY_0(S_AXI_ARREADY_MB_MUX),
            .S_AXI_RDATA_0(S_AXI_RDATA_MB_MUX),
            .S_AXI_RRESP_0(S_AXI_RRESP_MB_MUX),
            .S_AXI_RVALID_0(S_AXI_RVALID_MB_MUX),  
            .S_AXI_RREADY_0(S_AXI_RREADY_MB_MUX),
            
            .S_AXI_ACLK_1(S_AXI_ACLK),
            .S_AXI_ARESETN_1(S_AXI_ARESETN),
            .S_AXI_AWADDR_1(S_AXI_AWADDR_CONT_MUX),
            .S_AXI_AWVALID_1(S_AXI_AWVALID_CONT_MUX),
            .S_AXI_AWREADY_1(S_AXI_AWREADY_CONT_MUX),
            .S_AXI_WDATA_1(S_AXI_WDATA_CONT_MUX),
            .S_AXI_WSTRB_1(S_AXI_WSTRB_CONT_MUX),
            .S_AXI_WVALID_1(S_AXI_WVALID_CONT_MUX),
            .S_AXI_WREADY_1(S_AXI_WREADY_CONT_MUX),        
            .S_AXI_BRESP_1(S_AXI_BRESP_CONT_MUX),
            .S_AXI_BVALID_1(S_AXI_BVALID_CONT_MUX),
            .S_AXI_BREADY_1(S_AXI_BREADY_CONT_MUX),
            .S_AXI_ARADDR_1(S_AXI_ARADDR_CONT_MUX),
            .S_AXI_ARVALID_1(S_AXI_ARVALID_CONT_MUX),
            .S_AXI_ARREADY_1(S_AXI_ARREADY_CONT_MUX),
            .S_AXI_RDATA_1(S_AXI_RDATA_CONT_MUX),
            .S_AXI_RRESP_1(S_AXI_RRESP_CONT_MUX),
            .S_AXI_RVALID_1(S_AXI_RVALID_CONT_MUX),  
            .S_AXI_RREADY_1(S_AXI_RREADY_CONT_MUX),
            
            .S_AXI_ACLK_MUX_OUT(S_AXI_ACLK_FILTER),
            .S_AXI_ARESETN_MUX_OUT(S_AXI_ARESETN_FILTER),
            .S_AXI_AWADDR_MUX_OUT(S_AXI_AWADDR_FILTER),
            .S_AXI_AWVALID_MUX_OUT(S_AXI_AWVALID_FILTER),
            .S_AXI_AWREADY_MUX_OUT(S_AXI_AWREADY_FILTER),
            .S_AXI_WDATA_MUX_OUT(S_AXI_WDATA_FILTER),
            .S_AXI_WSTRB_MUX_OUT(S_AXI_WSTRB_FILTER),
            .S_AXI_WVALID_MUX_OUT(S_AXI_WVALID_FILTER),
            .S_AXI_WREADY_MUX_OUT(S_AXI_WREADY_FILTER),        
            .S_AXI_BRESP_MUX_OUT(S_AXI_BRESP_FILTER),
            .S_AXI_BVALID_MUX_OUT(S_AXI_BVALID_FILTER),
            .S_AXI_BREADY_MUX_OUT(S_AXI_BREADY_FILTER),
            .S_AXI_ARADDR_MUX_OUT(S_AXI_ARADDR_FILTER),
            .S_AXI_ARVALID_MUX_OUT(S_AXI_ARVALID_FILTER),
            .S_AXI_ARREADY_MUX_OUT(S_AXI_ARREADY_FILTER),
            .S_AXI_RDATA_MUX_OUT(S_AXI_RDATA_FILTER),
            .S_AXI_RRESP_MUX_OUT(S_AXI_RRESP_FILTER),
            .S_AXI_RVALID_MUX_OUT(S_AXI_RVALID_FILTER),  
            .S_AXI_RREADY_MUX_OUT(S_AXI_RREADY_FILTER),
            
            .select(select)
            );
            
    //Attenuation values
    wire [15:0] atten0;
    wire [15:0] atten1;
    wire [15:0] atten2;
    wire [15:0] atten3;
    wire [15:0] atten4;
    wire [15:0] atten5;
    wire [15:0] atten6;
    wire [15:0] atten7;
    wire [15:0] atten8;
    wire [15:0] atten9;
    wire [15:0] atten10;
    wire [15:0] atten11;
    wire [15:0] atten12;
                    
    FIR_Filter #(.C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH),. C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH)) Filter (
          //Axi4Lite bus
          .S_AXI_ACLK(S_AXI_ACLK_FILTER),            // input
          .S_AXI_ARESETN(S_AXI_ARESETN_FILTER),      // input
          .S_AXI_AWADDR(S_AXI_AWADDR_FILTER),        // input    [C_S_AXI_ADDR_WIDTH-1:0]
          .S_AXI_AWVALID(S_AXI_AWVALID_FILTER),      // input
          .S_AXI_AWREADY(S_AXI_AWREADY_FILTER),      // output
          .S_AXI_WDATA(S_AXI_WDATA_FILTER),          // input    [C_S_AXI_DATA_WIDTH-1:0]
          .S_AXI_WSTRB(S_AXI_WSTRB_FILTER),          // input    [3:0]
          .S_AXI_WVALID(S_AXI_WVALID_FILTER),        // input
          .S_AXI_WREADY(S_AXI_WREADY_FILTER),        // output        
          .S_AXI_BRESP(S_AXI_BRESP_FILTER),          // output   [1:0]
          .S_AXI_BVALID(S_AXI_BVALID_FILTER),        // output
          .S_AXI_BREADY(S_AXI_BREADY_FILTER),        // input
          .S_AXI_ARADDR(S_AXI_ARADDR_FILTER),        // input    [C_S_AXI_ADDR_WIDTH-1:0]
          .S_AXI_ARVALID(S_AXI_ARVALID_FILTER),      // input
          .S_AXI_ARREADY(S_AXI_ARREADY_FILTER),      // output
          .S_AXI_RDATA(S_AXI_RDATA_FILTER),          // output   [C_S_AXI_DATA_WIDTH-1:0]
          .S_AXI_RRESP(S_AXI_RRESP_FILTER),          // output   [1:0]
          .S_AXI_RVALID(S_AXI_RVALID_FILTER),        // output    
          .S_AXI_RREADY(S_AXI_RREADY_FILTER),         // input
            
          .attenInput0(atten0),
          .attenInput1(atten1),
          .attenInput2(atten2),
          .attenInput3(atten3),
          .attenInput4(atten4),
          .attenInput5(atten5),
          .attenInput6(atten6),
          .attenInput7(atten7),
          .attenInput8(atten8),
          .attenInput9(atten9),
          .attenInput10(atten10),
          .attenInput11(atten11),
          .attenInput12(atten12)
          );
    
    Attenuator #(.C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH),. C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH)) Attenuator1 (
        //Axi4Lite bus
        .S_AXI_ACLK(S_AXI_ACLK),            // input
        .S_AXI_ARESETN(S_AXI_ARESETN),      // input
        .S_AXI_AWADDR(S_AXI_AWADDR_ATTEN),        // input    [C_S_AXI_ADDR_WIDTH-1:0]
        .S_AXI_AWVALID(S_AXI_AWVALID_ATTEN),      // input
        .S_AXI_AWREADY(S_AXI_AWREADY_ATTEN),      // output
        .S_AXI_WDATA(S_AXI_WDATA_ATTEN),          // input    [C_S_AXI_DATA_WIDTH-1:0]
        .S_AXI_WSTRB(S_AXI_WSTRB_ATTEN),          // input    [3:0]
        .S_AXI_WVALID(S_AXI_WVALID_ATTEN),        // input
        .S_AXI_WREADY(S_AXI_WREADY_ATTEN),        // output        
        .S_AXI_BRESP(S_AXI_BRESP_ATTEN),          // output   [1:0]
        .S_AXI_BVALID(S_AXI_BVALID_ATTEN),        // output
        .S_AXI_BREADY(S_AXI_BREADY_ATTEN),        // input
        .S_AXI_ARADDR(S_AXI_ARADDR_ATTEN),        // input    [C_S_AXI_ADDR_WIDTH-1:0]
        .S_AXI_ARVALID(S_AXI_ARVALID_ATTEN),      // input
        .S_AXI_ARREADY(S_AXI_ARREADY_ATTEN),      // output
        .S_AXI_RDATA(S_AXI_RDATA_ATTEN),          // output   [C_S_AXI_DATA_WIDTH-1:0]
        .S_AXI_RRESP(S_AXI_RRESP_ATTEN),          // output   [1:0]
        .S_AXI_RVALID(S_AXI_RVALID_ATTEN),        // output    
        .S_AXI_RREADY(S_AXI_RREADY_ATTEN),         // input
        
        .attenOutput0(atten0),
        .attenOutput1(atten1),
        .attenOutput2(atten2),
        .attenOutput3(atten3),
        .attenOutput4(atten4),
        .attenOutput5(atten5),
        .attenOutput6(atten6),
        .attenOutput7(atten7),
        .attenOutput8(atten8),
        .attenOutput9(atten9),
        .attenOutput10(atten10),
        .attenOutput11(atten11),
        .attenOutput12(atten12)
    );            
        
    //State reg declarations
    reg [3:0] state, nextState;
    parameter INIT = 0, WRITE_ADC = 1, READ_ADC = 2,
              READ_FILTER = 3, DISABLE = 4;
    
    //INIT state address
    parameter CONFIG_ADC = 0, CONFIG_DAC = 1, ENABLE_ADC = 2, ENABLE_DAC = 3, ENABLE_EQUALIZER = 4, DAC_MODE = 5;
        
    //Handle select for BUS_MUX
    always @ * begin
        select = 1;
        if (state == INIT) begin
            select = 0;
        end
    end
    
    //Parameter declarations
    parameter ADC_CHAN_0 = 16'h8000, ADC_CHAN_1 = 16'hC000;
    parameter DAC_A = 32'h00000000, DAC_B = 32'h00010000, DAC_FAST_MODE = 32'h00500000, DAC_LOAD = 32'h00300000;
    
    //State machine flops
    reg enableD, enableQ;
    reg [C_S_AXI_DATA_WIDTH-1:0] rdValue;
    reg [15:0] cw_ADC_D, cw_ADC_Q;
    reg [15:0] cw_DAC_D, cw_DAC_Q;
    
    //State machine sequential logic
    always @ (posedge(S_AXI_ACLK)) begin
        if (!S_AXI_ARESETN) begin
            //Reset flops
            enableQ <= 0;
            cw_ADC_Q <= ADC_CHAN_0;
            cw_DAC_Q <= DAC_A[31:16] | DAC_LOAD[31:16];
            
            //Reset state
            state <= INIT;
        end
        else begin
            //Update flops
            state <= nextState;
            enableQ <= enableD;
            cw_ADC_Q <= cw_ADC_D;
            cw_DAC_Q <= cw_DAC_D;
        end
    end
    
    //State machine transition process
    always @ * begin
        //Default nextState
        nextState = state;
        
        //Transitions case statement
        case (state)
        INIT : begin
            if(enableQ)begin
                nextState = WRITE_ADC;
            end         
        end
        WRITE_ADC : begin
            if (!enableQ) begin
                nextState = WRITE_ADC;
            end
            else begin
                nextState = READ_ADC;
            end
        end
        READ_ADC : begin
            if (rdValue[31]) begin
                nextState = READ_FILTER;
            end
        end
        READ_FILTER : begin
            if (rdValue[31]) begin
                nextState = WRITE_ADC;
            end
        end
        DISABLE : begin
            if (enableQ) begin
                nextState = WRITE_ADC;
            end
        end
        endcase
    end
    
    //State output process
    always @ * begin
        //Flop defaults
        cw_ADC_D = cw_ADC_Q;
        cw_DAC_D = cw_DAC_Q;
        
    //Reg defaults
        rdValue = 0;
        //ADC
        wr_ADC = 0;
        rd_ADC = 0;
        wrAddr_ADC = 0;
        rdAddr_ADC = 0;
        wrData_ADC = 0;
        //Filter
        wr_CONT_MUX = 0;
        rd_CONT_MUX = 0;
        wrAddr_CONT_MUX = 0;
        rdAddr_CONT_MUX = 0;
        wrData_CONT_MUX = 0;
        //DAC
        wr_DAC = 0;
        rd_DAC = 0;
        wrAddr_DAC = 0;
        rdAddr_DAC = 0;
        wrData_DAC = 0;
        
        //Output case statement
        case (state)
        INIT : begin
            if(wr_CONTROLLER) begin
               case(wrAddr_CONTROLLER)
                    CONFIG_ADC: begin
                        wr_ADC = 1;
                        wrAddr_ADC = 0;
                        wrData_ADC = wrData_CONTROLLER;
                    end
                    CONFIG_DAC: begin
                        wr_DAC = 1;
                        wrAddr_DAC = 0;
                        wrData_DAC = wrData_CONTROLLER;
                    end
                    ENABLE_ADC: begin
                        wr_ADC = 1;
                        wrAddr_ADC = 1;
                        wrData_ADC = 1;
                     end
                    ENABLE_DAC: begin
                         wr_DAC = 1;
                         wrAddr_DAC = 1;
                         wrData_DAC = 1;
                    end
                    DAC_MODE: begin
                          wr_DAC = 1;
                          wrAddr_DAC = 2;
                          wrData_DAC = wrData_CONTROLLER;
                    end
                endcase     
            end            
        end
        WRITE_ADC : begin
            wr_ADC = 1;
            wrAddr_ADC = 2;
            wrData_ADC = cw_ADC_Q;
        end
        READ_ADC : begin
            rd_ADC = 1;
            rdAddr_ADC = 1;
            rdValue = rdData_ADC;
            if (rdValue[31]) begin
                wr_CONT_MUX = 1;
                if (cw_ADC_Q == ADC_CHAN_0) begin
                    wrAddr_CONT_MUX = 2;
                end else begin
                    wrAddr_CONT_MUX = 3;
                end
                wrData_CONT_MUX[15:0] = rdValue[15:0] - 16'h8000;
                
            end
        end
        READ_FILTER : begin
            rd_CONT_MUX = 1;
            rdAddr_CONT_MUX = 1;
            rdValue = rdData_CONT_MUX;
            if (rdValue[31]) begin
                wr_DAC = 1;
                wrAddr_DAC = 2;
                //CHANGE TO UNISGNED
               // wrData_DAC = {cw_DAC_Q, !rdValue[15], rdValue[14:0]};
                wrData_DAC[31:16]= cw_DAC_Q;
                wrData_DAC[15:0] = rdValue[15:0] + 16'h8000;
                
                if (cw_ADC_Q == ADC_CHAN_0) begin
                    cw_ADC_D = ADC_CHAN_1;
                    cw_DAC_D = 16'h0031;
                end
                else begin
                    cw_ADC_D = ADC_CHAN_0;
                    cw_DAC_D = 16'h0030;
                end
            end
        end
        DISABLE : begin
        end
        endcase
    end
    
    //Handle disable/enable of entire equalizer
    always @ * begin
        enableD = enableQ;
        if (wr_CONTROLLER && (wrAddr_CONTROLLER == ENABLE_EQUALIZER)) begin
            enableD = wrData_CONTROLLER[0];     
        end
    end
    
endmodule
