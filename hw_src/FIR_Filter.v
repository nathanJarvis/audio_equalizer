`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2018 02:06:08 PM
// Design Name: 
// Module Name: FIR_Filter
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


module FIR_Filter #(C_S_AXI_ADDR_WIDTH = 6, C_S_AXI_DATA_WIDTH = 32, TAP_WIDTH=16)
    (
    //Axi4Lite Bus
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
    input       signed [15:0] attenInput0,
    input       signed [15:0] attenInput1,
    input       signed [15:0] attenInput2,
    input       signed [15:0] attenInput3,
    input       signed [15:0] attenInput4,
    input        signed[15:0] attenInput5,
    input        signed[15:0] attenInput6,
    input        signed[15:0] attenInput7,
    input        signed[15:0] attenInput8,
    input        signed[15:0] attenInput9,
    input        signed[15:0] attenInput10,
    input        signed[15:0] attenInput11,
    input        signed[15:0] attenInput12
    );
  
//Instantiations, wires, and regs
  
    //Simple bus
    wire wr,rd;
    wire [C_S_AXI_ADDR_WIDTH-1:0] wrAddr,rdAddr;
    wire [C_S_AXI_DATA_WIDTH-1:0] wrData;
    reg [C_S_AXI_DATA_WIDTH-1:0] rdData;
    
    reg  signed [15:0] attenInput[0:12];
 
    
    //Axi4LiteSupporter
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
    );
   
   //Signals for taps RAMs
   reg [12:0] weTaps;
   reg [8:0] aTapsD, aTapsQ;
   wire signed [15:0] doTaps[0:12];
   
    //Taps RAMs
	genvar i;
	generate
		for (i = 0; i<13; i=i+1) begin
			blockRam tapRam
			(
			.clk(S_AXI_ACLK),
			.we(weTaps[i]),
			.a(aTapsQ),
			.di(wrData[15:0]),
			.do(doTaps[i])
			);
		end
	endgenerate
	
    //Signals for inputs RAM
    reg [1:0] weInputs;
    reg [8:0] aInputsD[1:0];
    reg [8:0] aInputsQ[1:0];
    wire signed [15:0] doInputs[0:1];
    
    //Inputs RAM (Circular Buffer)
	genvar j;
	generate
		for (j = 0; j<2; j=j+1) begin
			blockRam inputsRam
			(
			.clk(S_AXI_ACLK),
			.we(weInputs[j]),
			.a(aInputsQ[j]),
			.di(wrData[15:0]),
			.do(doInputs[j])
			);
		end
	endgenerate
    
//Registers   
 
    //Support mutable number of taps
    reg [15:0] numTapsD, numTapsQ;
    
    //Counter for convolution
    reg [15:0] convCounterD, convCounterQ;
    
    //Store the running sum
    reg signed [31:0] convSumD[0:12], convSumQ[0:12];
    reg signed [15:0] s_convSumD[0:12], s_convSumQ[0:12];
    
    //Store the result
    reg signed [31:0] resultD, resultQ;
    
    //channel select
    reg [0:0] selectD, selectQ;
    
//Main state machine
    
    reg [1:0] state, nextState;
    parameter IDLE=0, CONV=1, FINISH=2;
    
    parameter NUM_TAPS=0, WR_TAPS = 1, WR_INPUT_0 = 2, WR_INPUT_1 = 3;
    
    reg convDone;
    
    integer k;
    
    
    always @ * begin
        attenInput[0] = attenInput0;
        attenInput[1] = attenInput1;
        attenInput[2] = attenInput2;
        attenInput[3] = attenInput3;
        attenInput[4] = attenInput4;
        attenInput[5] = attenInput5;
        attenInput[6] = attenInput6;
        attenInput[7] = attenInput7;
        attenInput[8] = attenInput8;
        attenInput[9] = attenInput9;
        attenInput[10] = attenInput10;
        attenInput[11] = attenInput11;
        attenInput[12] = attenInput12;
    end
    
    
    //Sequential logic
    always @ (posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN) begin
            numTapsQ <= 0;
            convCounterQ <= 0;
            resultQ <= 0;
            aTapsQ <= 0;
            aInputsQ[0] <= 0;
            aInputsQ[1] <= 0;
            state <= IDLE;
            selectQ <= 0;
           
           
            
            //Iterate over 2D arrays
            for (k = 0; k < 13; k = k+1) begin
                convSumQ[k] <= 0;
                 s_convSumQ[k] <= 0 ;
            end
        end
        else begin
            numTapsQ <= numTapsD;
            convCounterQ <= convCounterD;
            resultQ <= resultD;
            aTapsQ <= aTapsD;
            aInputsQ[0] <= aInputsD[0];
            aInputsQ[1] <= aInputsD[1];     
            state <= nextState;
            selectQ <= selectD;
            
            //Iterate over 2D arrays
            for (k = 0; k < 13; k = k+1) begin
                convSumQ[k] <= convSumD[k];
                 s_convSumQ[k] <= convSumQ[k][30:15];
            end
        end
    end
    
    always @ * begin
        //Registers
        numTapsD = numTapsQ;
        convCounterD = convCounterQ;
        resultD = resultQ;
        aTapsD = aTapsQ;
        aInputsD[0] = aInputsQ[0];
        aInputsD[1] = aInputsQ[1];
        selectD = selectQ;
        //2D Registers
        for (k = 0; k < 13; k = k+1) begin
            convSumD[k] = convSumQ[k];
        end
                
        //Values
        weTaps = 0;
        weInputs = 0;
        convDone = 1;
        
        //State
        nextState = state;
    
        case (state)
            IDLE : begin
                //Reset registers
                convCounterD = 0;
                
                //Reset 2D registers
                for (k = 0; k < 13; k = k+1) begin
                  convSumD[k] = 0;
                end
                
                //Receiving data from MicroBlaze
                if (wr) begin
                    case (wrAddr)
                        NUM_TAPS : begin
                            numTapsD = wrData;
                            aTapsD = 0;
                        end
                        WR_TAPS : begin
                            //31:28 Filter select
                            //15:0 Value
                            //fill up one filter completely and then loop back
                            weTaps[wrData[31:28]] = 1;
                            if (aTapsQ == numTapsQ - 1) begin
                                aTapsD = 0;
                            end
                            else begin
                                aTapsD = aTapsQ + 1;
                            end
                        end
                        WR_INPUT_0: begin
                            //make select for CHANNEL
                            weInputs[0] = 1;
                            nextState = CONV;
                            convDone = 0;
                            selectD = 0;
                            $display("in_L: %x", wrData);
                        end
                        WR_INPUT_1: begin
                            //make select for CHANNEL
                            weInputs[1] = 1;
                            nextState = CONV;
                            convDone = 0;
                            selectD = 1;
                        end
                    endcase
                end
            end
            CONV : begin
                //Currently doing convolution
                convDone = 0;
                resultD = 0 ;
                //Increment counter
                convCounterD = convCounterQ + 1;
                
                //Decrement input index and wrap if necessary
                if (selectQ == 0) begin
                    if (aInputsQ[0] > 0) begin
                        aInputsD[0] = aInputsQ[0] - 1;
                    end
                    else begin
                        aInputsD[0] = numTapsQ - 1; 
                    end
                end else begin
                    if (aInputsQ[1] > 0) begin
                        aInputsD[1] = aInputsQ[1] - 1;
                    end
                    else begin
                        aInputsD[1] = numTapsQ - 1; 
                    end
                end
                
                //Increment taps index and wrap if necessary
                if (aTapsQ == numTapsQ - 1) begin
                    aTapsD = 0;
                end
                else begin
                    aTapsD = aTapsQ + 1;
                end                
                
                //Multiply and accumulate
                for(k =0; k< 13;k = k +1) begin
                    convSumD[k] = convSumQ[k] + (doInputs[selectQ] * doTaps[k]);
                end
                if (convCounterQ == numTapsQ - 1) begin
                    nextState = FINISH;
                  
                    for(k =0; k< 13; k = k+1) begin
                        //Round
                        convSumD[k] = convSumD[k] + 16'h4000;
                
                    end
                end
            end
            FINISH: begin
                convDone =0;
                
                 for(k =0; k< 13; k = k+1) begin
                    //sum filter results
                    resultD = resultD + (s_convSumQ[k]*attenInput[k]);
                 end
                 
                 resultD = resultD + 16'h2000;
                 
                 if(selectQ == 0) begin
                      if(aInputsQ[0] == numTapsQ - 1) begin
                        aInputsD[0] = 0;
                      end
                      else begin
                        aInputsD[0] = aInputsQ[0] + 1;
                      end
                  end
                  else begin
                      if(aInputsQ[1] == numTapsQ - 1) begin
                        aInputsD[1] = 0;
                      end
                      else begin
                        aInputsD[1] = aInputsQ[1] + 1;
                      end
                  end
                 
                 nextState = IDLE;
                
            end
            default : begin
                nextState = IDLE;
            end
        endcase
    end
  
    //Reading back result
    always @ * begin
        rdData = 0;
        if(rd) begin
            rdData = {convDone, 15'd0, resultQ[29:14]};
        end
    end  
    
endmodule