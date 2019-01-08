`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2018 11:40:13 AM
// Design Name: 
// Module Name: Eq_Controller_tb
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


module Eq_Controller_tb(

    );
    
    parameter C_S_AXI_ADDR_WIDTH = 6, C_S_AXI_DATA_WIDTH = 32;
    
    //Clock and reset
    reg S_AXI_ACLK;
    reg S_AXI_ARESETN;
    
    // Simple bus for Controller<->MB
    reg wr_CONTROLLER,rd_CONTROLLER;
    reg [C_S_AXI_ADDR_WIDTH-1:0] wrAddr_CONTROLLER,rdAddr_CONTROLLER;
    reg [C_S_AXI_DATA_WIDTH-1:0] wrData_CONTROLLER;
    wire [C_S_AXI_DATA_WIDTH-1:0] rdData_CONTROLLER;
    wire wrDone_CONTROLLER,rdDone_CONTROLLER;
    // Axi4Lite signals for Controller<->MB
    wire [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_AWADDR_CONTROLLER;
    wire  S_AXI_AWVALID_CONTROLLER;
    wire S_AXI_AWREADY_CONTROLLER;
    wire  [C_S_AXI_DATA_WIDTH-1:0] S_AXI_WDATA_CONTROLLER;
    wire  [3:0] S_AXI_WSTRB_CONTROLLER;
    wire  S_AXI_WVALID_CONTROLLER;
    wire S_AXI_WREADY_CONTROLLER;
    wire [1:0] S_AXI_BRESP_CONTROLLER;
    wire S_AXI_BVALID_CONTROLLER;
    wire  S_AXI_BREADY_CONTROLLER;
    wire  [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_ARADDR_CONTROLLER;
    wire  S_AXI_ARVALID_CONTROLLER;
    wire S_AXI_ARREADY_CONTROLLER;
    wire [C_S_AXI_DATA_WIDTH-1:0] S_AXI_RDATA_CONTROLLER;
    wire [1:0] S_AXI_RRESP_CONTROLLER;
    wire S_AXI_RVALID_CONTROLLER;
    wire  S_AXI_RREADY_CONTROLLER;
    
    Axi4LiteManager #(.C_M_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH), .C_M_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH)) Axi4LiteManager_CONTROLLER
        (
        // Simple Bus
        .wrAddr(wrAddr_CONTROLLER),                    // input    [C_M_AXI_ADDR_WIDTH-1:0]
        .wrData(wrData_CONTROLLER),                    // input    [C_M_AXI_DATA_WIDTH-1:0]
        .wr(wr_CONTROLLER),                            // input    
        .wrDone(wrDone_CONTROLLER),                    // output
        .rdAddr(rdAddr_CONTROLLER),                    // input    [C_M_AXI_ADDR_WIDTH-1:0]
        .rdData(rdData_CONTROLLER),                    // input    [C_M_AXI_DATA_WIDTH-1:0]
        .rd(rd_CONTROLLER),                            // input    
        .rdDone(rdDone_CONTROLLER),                    // output
        // Axi4Lite Bus
        .M_AXI_ACLK(S_AXI_ACLK),            // input
        .M_AXI_ARESETN(S_AXI_ARESETN),      // input
        .M_AXI_AWADDR(S_AXI_AWADDR_CONTROLLER),        // output   [C_M_AXI_ADDR_WIDTH-1:0] 
        .M_AXI_AWVALID(S_AXI_AWVALID_CONTROLLER),      // output
        .M_AXI_AWREADY(S_AXI_AWREADY_CONTROLLER),      // input
        .M_AXI_WDATA(S_AXI_WDATA_CONTROLLER),          // output   [C_M_AXI_DATA_WIDTH-1:0]
        .M_AXI_WSTRB(S_AXI_WSTRB_CONTROLLER),          // output   [3:0]
        .M_AXI_WVALID(S_AXI_WVALID_CONTROLLER),        // output
        .M_AXI_WREADY(S_AXI_WREADY_CONTROLLER),        // input
        .M_AXI_BRESP(S_AXI_BRESP_CONTROLLER),          // input    [1:0]
        .M_AXI_BVALID(S_AXI_BVALID_CONTROLLER),        // input
        .M_AXI_BREADY(S_AXI_BREADY_CONTROLLER),        // output
        .M_AXI_ARADDR(S_AXI_ARADDR_CONTROLLER),        // output   [C_M_AXI_ADDR_WIDTH-1:0]
        .M_AXI_ARVALID(S_AXI_ARVALID_CONTROLLER),      // output
        .M_AXI_ARREADY(S_AXI_ARREADY_CONTROLLER),      // input
        .M_AXI_RDATA(S_AXI_RDATA_CONTROLLER),          // input    [C_M_AXI_DATA_WIDTH-1:0]
        .M_AXI_RRESP(S_AXI_RRESP_CONTROLLER),          // input    [1:0]
        .M_AXI_RVALID(S_AXI_RVALID_CONTROLLER),        // input
        .M_AXI_RREADY(S_AXI_RREADY_CONTROLLER)         // output
        );
        
    // Simple bus for Controller<->MB_MUX
    reg wr_MB_MUX,rd_MB_MUX;
    reg [C_S_AXI_ADDR_WIDTH-1:0] wrAddr_MB_MUX,rdAddr_MB_MUX;
    reg [C_S_AXI_DATA_WIDTH-1:0] wrData_MB_MUX;
    wire [C_S_AXI_DATA_WIDTH-1:0] rdData_MB_MUX;
    wire wrDone_MB_MUX,rdDone_MB_MUX;
    // Axi4Lite signals for Controller<->MB_MUX
    wire [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_AWADDR_MB_MUX;
    wire  S_AXI_AWVALID_MB_MUX;
    wire S_AXI_AWREADY_MB_MUX;
    wire  [C_S_AXI_DATA_WIDTH-1:0] S_AXI_WDATA_MB_MUX;
    wire  [3:0] S_AXI_WSTRB_MB_MUX;
    wire  S_AXI_WVALID_MB_MUX;
    wire S_AXI_WREADY_MB_MUX;
    wire [1:0] S_AXI_BRESP_MB_MUX;
    wire S_AXI_BVALID_MB_MUX;
    wire  S_AXI_BREADY_MB_MUX;
    wire  [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_ARADDR_MB_MUX;
    wire  S_AXI_ARVALID_MB_MUX;
    wire S_AXI_ARREADY_MB_MUX;
    wire [C_S_AXI_DATA_WIDTH-1:0] S_AXI_RDATA_MB_MUX;
    wire [1:0] S_AXI_RRESP_MB_MUX;
    wire S_AXI_RVALID_MB_MUX;
    wire  S_AXI_RREADY_MB_MUX;
    
    Axi4LiteManager #(.C_M_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH), .C_M_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH)) Axi4LiteManager_MB_MUX
        (
        // Simple Bus
        .wrAddr(wrAddr_MB_MUX),                    // input    [C_M_AXI_ADDR_WIDTH-1:0]
        .wrData(wrData_MB_MUX),                    // input    [C_M_AXI_DATA_WIDTH-1:0]
        .wr(wr_MB_MUX),                            // input    
        .wrDone(wrDone_MB_MUX),                    // output
        .rdAddr(rdAddr_MB_MUX),                    // input    [C_M_AXI_ADDR_WIDTH-1:0]
        .rdData(rdData_MB_MUX),                    // input    [C_M_AXI_DATA_WIDTH-1:0]
        .rd(rd_MB_MUX),                            // input    
        .rdDone(rdDone_MB_MUX),                    // output
        // Axi4Lite Bus
        .M_AXI_ACLK(S_AXI_ACLK),            // input
        .M_AXI_ARESETN(S_AXI_ARESETN),      // input
        .M_AXI_AWADDR(S_AXI_AWADDR_MB_MUX),        // output   [C_M_AXI_ADDR_WIDTH-1:0] 
        .M_AXI_AWVALID(S_AXI_AWVALID_MB_MUX),      // output
        .M_AXI_AWREADY(S_AXI_AWREADY_MB_MUX),      // input
        .M_AXI_WDATA(S_AXI_WDATA_MB_MUX),          // output   [C_M_AXI_DATA_WIDTH-1:0]
        .M_AXI_WSTRB(S_AXI_WSTRB_MB_MUX),          // output   [3:0]
        .M_AXI_WVALID(S_AXI_WVALID_MB_MUX),        // output
        .M_AXI_WREADY(S_AXI_WREADY_MB_MUX),        // input
        .M_AXI_BRESP(S_AXI_BRESP_MB_MUX),          // input    [1:0]
        .M_AXI_BVALID(S_AXI_BVALID_MB_MUX),        // input
        .M_AXI_BREADY(S_AXI_BREADY_MB_MUX),        // output
        .M_AXI_ARADDR(S_AXI_ARADDR_MB_MUX),        // output   [C_M_AXI_ADDR_WIDTH-1:0]
        .M_AXI_ARVALID(S_AXI_ARVALID_MB_MUX),      // output
        .M_AXI_ARREADY(S_AXI_ARREADY_MB_MUX),      // input
        .M_AXI_RDATA(S_AXI_RDATA_MB_MUX),          // input    [C_M_AXI_DATA_WIDTH-1:0]
        .M_AXI_RRESP(S_AXI_RRESP_MB_MUX),          // input    [1:0]
        .M_AXI_RVALID(S_AXI_RVALID_MB_MUX),        // input
        .M_AXI_RREADY(S_AXI_RREADY_MB_MUX)         // output
        );
            
    // Simple bus for Controller<->ATTEN
    reg wr_ATTEN,rd_ATTEN;
    reg [C_S_AXI_ADDR_WIDTH-1:0] wrAddr_ATTEN,rdAddr_ATTEN;
    reg [C_S_AXI_DATA_WIDTH-1:0] wrData_ATTEN;
    wire [C_S_AXI_DATA_WIDTH-1:0] rdData_ATTEN;
    wire wrDone_ATTEN,rdDone_ATTEN;
    // Axi4Lite signals for Controller<->ATTEN
    wire [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_AWADDR_ATTEN;
    wire  S_AXI_AWVALID_ATTEN;
    wire S_AXI_AWREADY_ATTEN;
    wire  [C_S_AXI_DATA_WIDTH-1:0] S_AXI_WDATA_ATTEN;
    wire  [3:0] S_AXI_WSTRB_ATTEN;
    wire  S_AXI_WVALID_ATTEN;
    wire S_AXI_WREADY_ATTEN;
    wire [1:0] S_AXI_BRESP_ATTEN;
    wire S_AXI_BVALID_ATTEN;
    wire  S_AXI_BREADY_ATTEN;
    wire  [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_ARADDR_ATTEN;
    wire  S_AXI_ARVALID_ATTEN;
    wire S_AXI_ARREADY_ATTEN;
    wire [C_S_AXI_DATA_WIDTH-1:0] S_AXI_RDATA_ATTEN;
    wire [1:0] S_AXI_RRESP_ATTEN;
    wire S_AXI_RVALID_ATTEN;
    wire  S_AXI_RREADY_ATTEN;
    
    Axi4LiteManager #(.C_M_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH), .C_M_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH)) Axi4LiteManager_ATTEN
        (
        // Simple Bus
        .wrAddr(wrAddr_ATTEN),                    // input    [C_M_AXI_ADDR_WIDTH-1:0]
        .wrData(wrData_ATTEN),                    // input    [C_M_AXI_DATA_WIDTH-1:0]
        .wr(wr_ATTEN),                            // input    
        .wrDone(wrDone_ATTEN),                    // output
        .rdAddr(rdAddr_ATTEN),                    // input    [C_M_AXI_ADDR_WIDTH-1:0]
        .rdData(rdData_ATTEN),                    // input    [C_M_AXI_DATA_WIDTH-1:0]
        .rd(rd_ATTEN),                            // input    
        .rdDone(rdDone_ATTEN),                    // output
        // Axi4Lite Bus
        .M_AXI_ACLK(S_AXI_ACLK),            // input
        .M_AXI_ARESETN(S_AXI_ARESETN),      // input
        .M_AXI_AWADDR(S_AXI_AWADDR_ATTEN),        // output   [C_M_AXI_ADDR_WIDTH-1:0] 
        .M_AXI_AWVALID(S_AXI_AWVALID_ATTEN),      // output
        .M_AXI_AWREADY(S_AXI_AWREADY_ATTEN),      // input
        .M_AXI_WDATA(S_AXI_WDATA_ATTEN),          // output   [C_M_AXI_DATA_WIDTH-1:0]
        .M_AXI_WSTRB(S_AXI_WSTRB_ATTEN),          // output   [3:0]
        .M_AXI_WVALID(S_AXI_WVALID_ATTEN),        // output
        .M_AXI_WREADY(S_AXI_WREADY_ATTEN),        // input
        .M_AXI_BRESP(S_AXI_BRESP_ATTEN),          // input    [1:0]
        .M_AXI_BVALID(S_AXI_BVALID_ATTEN),        // input
        .M_AXI_BREADY(S_AXI_BREADY_ATTEN),        // output
        .M_AXI_ARADDR(S_AXI_ARADDR_ATTEN),        // output   [C_M_AXI_ADDR_WIDTH-1:0]
        .M_AXI_ARVALID(S_AXI_ARVALID_ATTEN),      // output
        .M_AXI_ARREADY(S_AXI_ARREADY_ATTEN),      // input
        .M_AXI_RDATA(S_AXI_RDATA_ATTEN),          // input    [C_M_AXI_DATA_WIDTH-1:0]
        .M_AXI_RRESP(S_AXI_RRESP_ATTEN),          // input    [1:0]
        .M_AXI_RVALID(S_AXI_RVALID_ATTEN),        // input
        .M_AXI_RREADY(S_AXI_RREADY_ATTEN)         // output
        );
        
    wire ADC_SCK;
    wire ADC_SDI;
    wire ADC_SDO;
    wire ADC_CS_;
        
    AdcTester ADC1
        (
        .SCK(ADC_SCK),
        .SDI(ADC_SDI),
        .SDO(ADC_SDO),
        .CS_(ADC_CS_)
        );
        
    wire DAC_SCK;
    wire DAC_SDI;
    wire DAC_SDO;
    wire DAC_CS_;
    
    DacTester DAC1
        (
        .SCK(DAC_SCK),
        .SDI(DAC_SDI),
        .SDO(DAC_SDO),
        .CS_(DAC_CS_)
        );
    
    Eq_Controller Eq_Controller1
        (
        //Axi4Lite bus
        .S_AXI_ACLK(S_AXI_ACLK),            // input
        .S_AXI_ARESETN(S_AXI_ARESETN),      // input
        .S_AXI_AWADDR_CONTROLLER(S_AXI_AWADDR_CONTROLLER),        // input    [C_S_AXI_ADDR_WIDTH-1:0]
        .S_AXI_AWVALID_CONTROLLER(S_AXI_AWVALID_CONTROLLER),      // input
        .S_AXI_AWREADY_CONTROLLER(S_AXI_AWREADY_CONTROLLER),      // output
        .S_AXI_WDATA_CONTROLLER(S_AXI_WDATA_CONTROLLER),          // input    [C_S_AXI_DATA_WIDTH-1:0]
        .S_AXI_WSTRB_CONTROLLER(S_AXI_WSTRB_CONTROLLER),          // input    [3:0]
        .S_AXI_WVALID_CONTROLLER(S_AXI_WVALID_CONTROLLER),        // input
        .S_AXI_WREADY_CONTROLLER(S_AXI_WREADY_CONTROLLER),        // output        
        .S_AXI_BRESP_CONTROLLER(S_AXI_BRESP_CONTROLLER),          // output   [1:0]
        .S_AXI_BVALID_CONTROLLER(S_AXI_BVALID_CONTROLLER),        // output
        .S_AXI_BREADY_CONTROLLER(S_AXI_BREADY_CONTROLLER),        // input
        .S_AXI_ARADDR_CONTROLLER(S_AXI_ARADDR_CONTROLLER),        // input    [C_S_AXI_ADDR_WIDTH-1:0]
        .S_AXI_ARVALID_CONTROLLER(S_AXI_ARVALID_CONTROLLER),      // input
        .S_AXI_ARREADY_CONTROLLER(S_AXI_ARREADY_CONTROLLER),      // output
        .S_AXI_RDATA_CONTROLLER(S_AXI_RDATA_CONTROLLER),          // output   [C_S_AXI_DATA_WIDTH-1:0]
        .S_AXI_RRESP_CONTROLLER(S_AXI_RRESP_CONTROLLER),          // output   [1:0]
        .S_AXI_RVALID_CONTROLLER(S_AXI_RVALID_CONTROLLER),        // output    
        .S_AXI_RREADY_CONTROLLER(S_AXI_RREADY_CONTROLLER),         // input
        
        //Axi4Lite bus
      
        .S_AXI_AWADDR_MB_MUX(S_AXI_AWADDR_MB_MUX),        // input    [C_S_AXI_ADDR_WIDTH-1:0]
        .S_AXI_AWVALID_MB_MUX(S_AXI_AWVALID_MB_MUX),      // input
        .S_AXI_AWREADY_MB_MUX(S_AXI_AWREADY_MB_MUX),      // output
        .S_AXI_WDATA_MB_MUX(S_AXI_WDATA_MB_MUX),          // input    [C_S_AXI_DATA_WIDTH-1:0]
        .S_AXI_WSTRB_MB_MUX(S_AXI_WSTRB_MB_MUX),          // input    [3:0]
        .S_AXI_WVALID_MB_MUX(S_AXI_WVALID_MB_MUX),        // input
        .S_AXI_WREADY_MB_MUX(S_AXI_WREADY_MB_MUX),        // output        
        .S_AXI_BRESP_MB_MUX(S_AXI_BRESP_MB_MUX),          // output   [1:0]
        .S_AXI_BVALID_MB_MUX(S_AXI_BVALID_MB_MUX),        // output
        .S_AXI_BREADY_MB_MUX(S_AXI_BREADY_MB_MUX),        // input
        .S_AXI_ARADDR_MB_MUX(S_AXI_ARADDR_MB_MUX),        // input    [C_S_AXI_ADDR_WIDTH-1:0]
        .S_AXI_ARVALID_MB_MUX(S_AXI_ARVALID_MB_MUX),      // input
        .S_AXI_ARREADY_MB_MUX(S_AXI_ARREADY_MB_MUX),      // output
        .S_AXI_RDATA_MB_MUX(S_AXI_RDATA_MB_MUX),          // output   [C_S_AXI_DATA_WIDTH-1:0]
        .S_AXI_RRESP_MB_MUX(S_AXI_RRESP_MB_MUX),          // output   [1:0]
        .S_AXI_RVALID_MB_MUX(S_AXI_RVALID_MB_MUX),        // output    
        .S_AXI_RREADY_MB_MUX(S_AXI_RREADY_MB_MUX),         // input
        
         //Axi4Lite bus
       
        .S_AXI_AWADDR_ATTEN(S_AXI_AWADDR_ATTEN),        // input    [C_S_AXI_ADDR_WIDTH-1:0]
        .S_AXI_AWVALID_ATTEN(S_AXI_AWVALID_ATTEN),      // input
        .S_AXI_AWREADY_ATTEN(S_AXI_AWREADY_ATTEN),      // output
        .S_AXI_WDATA_ATTEN(S_AXI_WDATA_ATTEN),          // input    [C_S_AXI_DATA_WIDTH-1:0]
        .S_AXI_WSTRB_ATTEN(S_AXI_WSTRB_ATTEN),          // input    [3:0]
        .S_AXI_WVALID_ATTEN(S_AXI_WVALID_ATTEN),        // input
        .S_AXI_WREADY_ATTEN(S_AXI_WREADY_ATTEN),        // output        
        .S_AXI_BRESP_ATTEN(S_AXI_BRESP_ATTEN),          // output   [1:0]
        .S_AXI_BVALID_ATTEN(S_AXI_BVALID_ATTEN),        // output
        .S_AXI_BREADY_ATTEN(S_AXI_BREADY_ATTEN),        // input
        .S_AXI_ARADDR_ATTEN(S_AXI_ARADDR_ATTEN),        // input    [C_S_AXI_ADDR_WIDTH-1:0]
        .S_AXI_ARVALID_ATTEN(S_AXI_ARVALID_ATTEN),      // input
        .S_AXI_ARREADY_ATTEN(S_AXI_ARREADY_ATTEN),      // output
        .S_AXI_RDATA_ATTEN(S_AXI_RDATA_ATTEN),          // output   [C_S_AXI_DATA_WIDTH-1:0]
        .S_AXI_RRESP_ATTEN(S_AXI_RRESP_ATTEN),          // output   [1:0]
        .S_AXI_RVALID_ATTEN(S_AXI_RVALID_ATTEN),        // output    
        .S_AXI_RREADY_ATTEN(S_AXI_RREADY_ATTEN),         // input
        
        .ADC_SCK(ADC_SCK),
        .ADC_SDI(ADC_SDI),
        .ADC_CS_(ADC_CS_),
        .ADC_SDO(ADC_SDO),
        
        .DAC_SCK(DAC_SCK),
        .DAC_SDI(DAC_SDI),
        .DAC_CS_(DAC_CS_),
        .DAC_SDO(DAC_SDO)
        );
    
    parameter CLK_PERIOD = 33.33, CLK_PERIOD_2 = 33.33/2;
    
    //Generate clock
    always begin
        #CLK_PERIOD_2 S_AXI_ACLK = ~S_AXI_ACLK;
    end
    
    reg [15:0] taps[3626:0];
    
    //Loop counters
    reg [31:0] i;
    reg [9:0] j;
    
    initial begin
    $readmemh("Taps.txt", taps);
    
    //Set values to zero
    S_AXI_ARESETN = 0;
    S_AXI_ACLK = 0;
    //CONTROLLER manager signals
    rdAddr_CONTROLLER = 0;
    rd_CONTROLLER = 0;
    wrAddr_CONTROLLER = 0;
    wrData_CONTROLLER = 0;
    wr_CONTROLLER = 0;
    //MB_MUX manager signals
    rdAddr_MB_MUX = 0;
    rd_MB_MUX = 0;
    wrAddr_MB_MUX = 0;
    wrData_MB_MUX = 0;
    wr_MB_MUX = 0;
    //ATTEN manager signals
    rdAddr_ATTEN = 0;
    rd_ATTEN = 0;
    wrAddr_ATTEN = 0;
    wrData_ATTEN = 0;
    wr_ATTEN = 0;
    
    //Generate reset
    #(CLK_PERIOD_2+2);
    S_AXI_ARESETN = 1; 
    #(CLK_PERIOD*10);
    
    //Write the number of taps
    wrAddr_MB_MUX = 0;
    wrData_MB_MUX = 32'd279;
    wr_MB_MUX = 1;
    #(CLK_PERIOD);
    wr_MB_MUX = 0;
    wrAddr_MB_MUX = 0;
    wrData_MB_MUX = 0;
    #(3 * CLK_PERIOD)
    
    
    //Configure ADC
        wrAddr_CONTROLLER = 0;
        wrData_CONTROLLER = 32'h00002590;
        wr_CONTROLLER = 1;
        #(CLK_PERIOD);
        wrAddr_CONTROLLER = 0;
        wrData_CONTROLLER = 0;
        wr_CONTROLLER = 0;
        
         #(CLK_PERIOD*3);
        
        //Configure DAC
        wrAddr_CONTROLLER = 1;
        wrData_CONTROLLER = 32'h00002598;
        wr_CONTROLLER = 1;
        #(CLK_PERIOD);
        wrAddr_CONTROLLER = 0;
        wrData_CONTROLLER = 0;
        wr_CONTROLLER = 0;
        
    #(CLK_PERIOD*3);
    //Write the taps
    for (j=0; j < 13; j=j+1) begin
        for (i=0; i < 279; i=i+1) begin
            wrAddr_MB_MUX = 1;
            wrData_MB_MUX = {j[3:0], 12'd0, taps[(279*j) + i]};
            wr_MB_MUX = 1;
            #(CLK_PERIOD);
            wr_MB_MUX = 0;
            wrAddr_MB_MUX = 0;
            wrData_MB_MUX = 0;
            #(CLK_PERIOD*3);
        end
    end
    
    //Write 0.5 to all attenuation values
    /*
    for (j = 0; j < 13; j=j+1) begin
        wrAddr_ATTEN = j;
        wrData_ATTEN = 32'h00002000;
        wr_ATTEN = 1;
        #(CLK_PERIOD);
        wr_ATTEN = 0;
        wrAddr_ATTEN = 0;
        wrData_ATTEN = 0;
        #(CLK_PERIOD*3);
    end
    */
    /*
   for(j= 0; j<13; j=j+1) begin
        wr_ATTEN = 1;
        wrAddr_ATTEN = j;
        wrData_ATTEN = 16'h2000;
         #(2*CLK_PERIOD);
    end
    #(CLK_PERIOD);
     wr_ATTEN = 0;
     */
    
    //write the DAC FAST MODE HERE For each channel!!!
    
    
     #(CLK_PERIOD*3);
      //Enable ADC
        wrAddr_CONTROLLER = 2;
        wrData_CONTROLLER = 0;
        wr_CONTROLLER = 1;
        #(CLK_PERIOD);
        wrAddr_CONTROLLER = 0;
        wrData_CONTROLLER = 0;
        wr_CONTROLLER = 0;
        
        #(CLK_PERIOD*3);
        //Enable DAC
        wrAddr_CONTROLLER = 3;
        wrData_CONTROLLER = 1;
        wr_CONTROLLER = 1;
        #(CLK_PERIOD);
        wrAddr_CONTROLLER = 0;
        wrData_CONTROLLER = 0;
        wr_CONTROLLER = 0;
        
        #(CLK_PERIOD*3);
        //Enable Equalizer
        wrAddr_CONTROLLER = 4;
        wrData_CONTROLLER = 1;
        wr_CONTROLLER = 1;
        #(CLK_PERIOD);
        wrAddr_CONTROLLER = 0;
        wrData_CONTROLLER = 0;
        wr_CONTROLLER = 0;
    
        
        #(CLK_PERIOD * 1000);
        /*
        //Disable equalizer
        wrAddr_CONTROLLER = 4;
        wrData_CONTROLLER = 0;
        wr_CONTROLLER = 1;
        #(CLK_PERIOD);
        wrAddr_CONTROLLER = 0;
        wrData_CONTROLLER = 0;
        wr_CONTROLLER = 0;
        
        #(CLK_PERIOD * 1000);
        
        //Reenable equalizer
        wrAddr_CONTROLLER = 4;
        wrData_CONTROLLER = 1;
        wr_CONTROLLER = 1;
        #(CLK_PERIOD);
        wrAddr_CONTROLLER = 0;
        wrData_CONTROLLER = 0;
        wr_CONTROLLER = 0;
        */

         
        #(CLK_PERIOD * 2500000);     
      
    $stop;
    end
    
endmodule
