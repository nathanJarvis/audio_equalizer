#include "platform.h"
#include "xil_printf.h"
#include "xil_io.h"
#include  "taps.h"

#define SAMPLE_FREQ 100 //kHz
#define MB_clk 30000 //clock speed kHz

//Define base addresses
#define ATTEN_BASE   0x44a00000
#define C_BASE 	     0x44a10000
#define FILTER_BASE  0x44a20000

//Controller offsets
#define CONFIG_ADC 0
#define CONFIG_DAC 1
#define ENABLE_ADC 2
#define ENABLE_DAC 3
#define ENABLE_EQUALIZER 4
#define DAC_MODE 5

//Filter
//offsets
#define NUM_TAPS_FILTER 0
#define WR_TAPS 1
//constants'


//DAC constants
#define num_bits_DAC 24
#define DAC_A 0x00000000
#define DAC_B 0x00010000
#define DAC_FAST_MODE 0x00500000

//ADC constants
#define num_bits_ADC 16

int main()
{
	unsigned int config_DAC = 0;
    unsigned int config_ADC = 0;
    unsigned int clk_cnt =  MB_clk / SAMPLE_FREQ;

    config_ADC = (clk_cnt << 5) | num_bits_ADC;
    config_DAC = (clk_cnt << 5) | num_bits_DAC;

    Xil_Out32(FILTER_BASE + NUM_TAPS_FILTER, 279);
    Xil_Out32(C_BASE + CONFIG_ADC, config_ADC);
    Xil_Out32(C_BASE + CONFIG_DAC, config_DAC);


    Xil_Out32(C_BASE + ENABLE_DAC, TRUE);

    Xil_Out32(C_BASE + DAC_MODE, DAC_FAST_MODE | DAC_A);
	//Xil_Out32(C_BASE + DAC_MODE, DAC_FAST_MODE | DAC_B);

    for(int i = 0; i<13; i++){
    	for(int j =0 ; j< 279; j++){
    		 //Xil_Out32(FILTER_BASE + WR_TAPS, tap_values[i*279+j]);
    		Xil_Out32(FILTER_BASE + WR_TAPS, (i<<28) | (0xffff & tap_values[i][j]));
    	}
    }
    Xil_Out32(C_BASE + DAC_MODE, DAC_FAST_MODE | DAC_B);


    Xil_Out32(C_BASE + ENABLE_ADC, TRUE);
    Xil_Out32(C_BASE + ENABLE_EQUALIZER, TRUE);
    //Xil_Out32(C_BASE + DAC_MODE, TRUE);

    int x = 0;
	for(x= 0; x<13; x++){
		Xil_Out32(ATTEN_BASE+x,  0x4000);

	}
}
