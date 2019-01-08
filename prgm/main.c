/***************************** Include Files *********************************/

#include "xparameters.h"
#include "xstatus.h"
#include "xuartlite.h"
#include "xil_printf.h"
#include "xil_io.h"
#include "taps.h"



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

/************************** Constant Definitions *****************************/

/*
 * The following constants map to the XPAR parameters created in the
 * xparameters.h file. They are defined here such that a user can easily
 * change all the needed parameters in one place.
 */
#define UARTLITE_DEVICE_ID	XPAR_UARTLITE_0_DEVICE_ID

/*
 * The following constant controls the length of the buffers to be sent
 * and received with the UartLite, this constant must be 16 bytes or less since
 * this is a single threaded non-interrupt driven example such that the
 * entire buffer will fit into the transmit and receive FIFOs of the UartLite.
 */
#define TEST_BUFFER_SIZE 66

/**************************** Type Definitions *******************************/


/***************** Macros (Inline Functions) Definitions *********************/


/************************** Function Prototypes ******************************/

int UartLitePolledExample(u16 DeviceId);

/************************** Variable Definitions *****************************/

XUartLite UartLite;		/* Instance of the UartLite Device */

/*
 * The following buffers are used in this example to send and receive data
 * with the UartLite.
 */
u8 SendBuffer[TEST_BUFFER_SIZE];	/* Buffer for Transmitting Data */
char RecvBuffer[TEST_BUFFER_SIZE];	/* Buffer for Receiving Data */
char RecvBuffer2[TEST_BUFFER_SIZE];	/* Buffer for Receiving Data */





// Function to convert hexadecimal to decimal
int hexadecimalToDecimal(char* hexVal)
{
   // int len = strlen(hexVal);

    // Initializing base value to 1, i.e 16^0
    int base = 4096;
    char * ptr = hexVal;
    int dec_val = 0;
    int count = 0;

    char tmp = *ptr;
    // Extracting characters as digits from last character
    //for (int i=len-1; i>=0; i--)
    while(count <= TEST_BUFFER_SIZE)
    {

    	if(count%5 != 0 || count == 0){
			// if character lies in '0'-'9', converting
			// it to integral 0-9 by subtracting 48 from
			// ASCII value.
			if (tmp >='0' && tmp <='9')
			{
				dec_val += (tmp - 48)*base;

				// incrementing base by power
				base = base / 16;
			}

			// if character lies in 'A'-'F' , converting
			// it to integral 10 - 15 by subtracting 55
			// from ASCII value
			else if (tmp >='A' && tmp <='F')
			{
				dec_val += (tmp- 55)*base;

				// incrementing base by power
				base = base/16;
			}

    	}


    	count++;
        ptr++;
        tmp = *ptr;

    }

    return dec_val;
}




/*****************************************************************************/
/**
*
* Main function to call the Uartlite polled example.
*
* @param	None.
*
* @return	XST_SUCCESS if successful, otherwise XST_FAILURE.
*
* @note		None.
*
******************************************************************************/


int main(void)
{
	int Status;
	int ReceivedCount = 0;
	int Index = 0;
	signed short factors [13];
	int x = 0;

    //RecvBuffer[65] = '/0';


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



		Status = XUartLite_Initialize(&UartLite, UARTLITE_DEVICE_ID);
		if (Status != XST_SUCCESS) {
			return XST_FAILURE;
		}

		/*
		 * Perform a self-test to ensure that the hardware was built correctly.
		 */
		Status = XUartLite_SelfTest(&UartLite);
		if (Status != XST_SUCCESS) {
			return XST_FAILURE;
		}

		/*
		 * Initialize the send buffer bytes with a pattern to send and the
		 * the receive buffer bytes to zero.
		 */

		for (Index = 0; Index < 13; Index++) {
				factors[Index] = 0;
			}

		for (Index = 0; Index < TEST_BUFFER_SIZE; Index++) {
			SendBuffer[Index] = 0;
			RecvBuffer[Index] = 0;
		}


	while (ReceivedCount != TEST_BUFFER_SIZE) {


			ReceivedCount += XUartLite_Recv(&UartLite,
						   RecvBuffer + ReceivedCount,
						   TEST_BUFFER_SIZE - ReceivedCount); //read in factors

			if (ReceivedCount == TEST_BUFFER_SIZE) {


				for (Index = 0; Index < 13; Index++) { //write them back for verification
						factors[Index] = hexadecimalToDecimal(&(RecvBuffer[Index*5]));
				}

				for(x= 0; x<13; x++){
					Xil_Out32(ATTEN_BASE+x, factors[x]);

				}

				for (Index = 0; Index < TEST_BUFFER_SIZE; Index++) {
						RecvBuffer[Index] = '0';
				}

				ReceivedCount = 0;
			}
	}




	return XST_SUCCESS;

}



/****************************************************************************/
/**
* This function does a minimal test on the UartLite device and driver as a
* design example. The purpose of this function is to illustrate
* how to use the XUartLite component.
*
* This function sends data and expects to receive the data thru the UartLite
* such that a  physical loopback must be done with the transmit and receive
* signals of the UartLite.
*
* This function polls the UartLite and does not require the use of interrupts.
*
* @param	DeviceId is the Device ID of the UartLite and is the
*		XPAR_<uartlite_instance>_DEVICE_ID value from xparameters.h.
*
* @return	XST_SUCCESS if successful, XST_FAILURE if unsuccessful.
*
*
* @note
*
* This function calls the UartLite driver functions in a blocking mode such that
* if the transmit data does not loopback to the receive, this function may
* not return.
*
****************************************************************************/
