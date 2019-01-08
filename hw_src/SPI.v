`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2018 01:11:00 PM
// Design Name: 
// Module Name: Axi4LiteRegs
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


module SPI #(parameter C_S_AXI_ADDR_WIDTH = 6, parameter C_S_AXI_DATA_WIDTH = 32)
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
        output      reg SCK,
        output      reg SDI,
        output      reg CS_,
        input       SDO
    );
    
     wire wr,rd;
     wire [C_S_AXI_ADDR_WIDTH-1:0] wrAddr,rdAddr;
     wire [C_S_AXI_DATA_WIDTH-1:0] wrData;
     reg [C_S_AXI_DATA_WIDTH-1:0] rdData;
     
     //bit 31 for read of rdData
     reg [0:0]  valid_d, valid_q = 0;
     reg [0:0]  validRaw_d, validRaw_q = 0;
     
     reg [23:0] rdData_d, rdData_q;
     reg [23:0] rdRaw_d, rdRaw_q;
     reg [31:0] wrData_d, wrData_q;
     reg [31:0] wrRaw_d, wrRaw_q;
     reg [2:0]  state, nxt_state = IDLE_state;
     reg [0:0]  enable_d, enable_q = 0;
     reg [4:0]  num_bits_d, num_bits_q = 0;
     reg [4:0]  index_d, index_q =0;
     reg [14:0] clk_cnt_d, clk_cnt_q = 0;
     reg [14:0] cnt_limit_d, cnt_limit_q = 3000;
     reg [0:0] SCK_d, SCK_q; 
     reg [0:0] SDI_d, SDI_q, CS_q, CS_d;
     reg [7:0] SCK_cnt_d, SCK_cnt_q;
     
    
     // CONV, SDI, SCK, SDO;
     
     //FSM states
     parameter IDLE_state = 0, START_state = 1, SDI_state = 2, SDO_state = 3, INIT_state = 4, DELAY_state = 5;
     
     //INIT ADDRESS
     parameter INIT_ADDR = 0, VALUE_ADDR = 2, ENABLE_ADDR = 1;
     
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

        
    always@(posedge S_AXI_ACLK) begin
      if (!S_AXI_ARESETN) begin
           state <= IDLE_state;
           index_q <= 0;
           num_bits_q <= 16;
           rdData_q <= 0;
           wrData_q <= 0;
           wrRaw_q <= 0;
           rdRaw_q <= 0;
           valid_q <= 0;
           validRaw_q = 0;
           enable_q <= 0;
           clk_cnt_q <= 0;
           cnt_limit_q <= 300;
           SCK_q <= 0;
           SDI_q <= 0;
           SCK_cnt_q <= 0;
         
      end
      else begin   
            state <= nxt_state;
            index_q <= index_d;
            num_bits_q <= num_bits_d;
            wrRaw_q <= wrRaw_d;
            wrData_q <= wrData_d;
            rdRaw_q <= rdRaw_d;
            rdData_q <= rdData_d;
            valid_q <= valid_d;
            validRaw_q <= validRaw_d;
            enable_q <= enable_d;
            clk_cnt_q <= clk_cnt_d;
            cnt_limit_q <= cnt_limit_d;
            SCK_cnt_q <= SCK_cnt_d;
            SDI_q <= SDI_d;
            SCK_q <= SCK_d;
            valid_q <= valid_d;
            
      end
    end
    
    always @ * begin
        nxt_state = state;
        valid_d = valid_q;
        validRaw_d = validRaw_q;
        index_d = index_q;
        rdData_d = rdData_q;
        rdRaw_d = rdRaw_q;
        enable_d = enable_q;
        num_bits_d = num_bits_q;
        wrRaw_d  = wrRaw_q; 
        wrData_d = wrData_q;
        clk_cnt_d = clk_cnt_q + 1;
        CS_ = 1;
        SDI = SDI_q;
        SDI_d = SDI_q;
        SCK = SCK_q;
        SCK_d = SCK_q;
        SCK_cnt_d = SCK_cnt_q;
        cnt_limit_d = cnt_limit_q;
        rdData = 0;
        
       
        
        //only update the wrData 
        //if we are in the IDLE state
        if(state == IDLE_state || state == START_state) begin
            wrData_d = wrRaw_q;
            rdRaw_d = rdData_q;
            validRaw_d = valid_q;
        end

        
       if(wr) begin
            case(wrAddr) 
               INIT_ADDR: begin
                    num_bits_d = wrData[4:0];
                    cnt_limit_d = wrData[19:5];      
               end
               ENABLE_ADDR: begin
                    enable_d = wrData[0];
               end
               VALUE_ADDR: begin
                    wrRaw_d = wrData[23:0];
               end
               default: begin
                    wrRaw_d = wrData[23:0];
               end 
             endcase
       end
       
       if(rd) begin 
            rdData = {validRaw_q[0:0], 7'd0 , rdRaw_q[23:0] };
            if(validRaw_q) begin
                valid_d = 0;
            end
       end
       
         case(state) 
            IDLE_state: begin
               
                SDI_d = 0;
                if(clk_cnt_q >= cnt_limit_q && enable_q) begin
                    nxt_state = START_state;
                    //valid_d = 0;
                     
                end
            end
            START_state: begin

                clk_cnt_d = 0;
                SCK_cnt_d = 0;
                //rdData_d = 16'd0;
                //CS_d = 0;
                SCK_d = 0;
                index_d = num_bits_q - 1;
                nxt_state = SDI_state;
             
                      
            end
            SDI_state: begin
                CS_ = 0;
                if(SCK_cnt_q == 0) begin
                    SDI_d = wrData_q[index_q];   
                    index_d = index_q - 1;
                end
                //don't raise on last cycle
                if((SCK_cnt_q == 2 || SCK_cnt_q == 4) && (clk_cnt_q != num_bits_q*6 +2)) begin
                    SCK_d = 1;
                end
                SCK_cnt_d = SCK_cnt_q + 1;
                nxt_state = SDO_state;
            end
            SDO_state: begin
                CS_ = 0;
                if(SCK_cnt_q == 3)begin
//                    move to falling edge in if(cnt = 5) for  ADC
                    if(index_q == 5'h1f) begin
                          rdData_d[0] = SDO;
                    end
                    else begin
                        rdData_d[index_q + 1] = SDO;
                    end
                    SCK_d = 1;
                   
                end
                SCK_cnt_d = SCK_cnt_q + 1;
                if(SCK_cnt_q == 5) begin
                    SCK_cnt_d = 0;
                    SCK_d = 0;
                end
                //think about count loops instead of clk
                if(clk_cnt_q  >= num_bits_q * 6 + 3) begin
                    nxt_state = IDLE_state;
                    CS_d =  1;
                    valid_d = 1;
                    SCK_d = 0;
                end
                else begin
                    nxt_state = SDI_state;
                end
            end
            default: begin
                nxt_state = IDLE_state;
            end
         endcase
       end
            
       
endmodule
