# lab07sub
IIR Notch Filters Using the TI TMS320C5505

## OBJECTIVES:
- implement a simple filter using a digital signal processing microprocessor and the TI Code Composer development tools.
- compare the performance of different filter designs using inputs from a signal generator and viewing outputs on an oscilloscope.
- gain more comfort with filtering audio signals.


## PRELAB:

### `main.c`
```c
// program main.c
#include <stdio.h>
#include <math.h>
#include "stdint.h"
#include "usbstk5505.h"
#include "usbstk5505_i2c.h"
#include "usbstk5505_i2s.h"
#include "main.h"

/* Include filter information */
#include "ave5f.cof" 		//filter coefficient file

/* CODEC initialization defines */
#define GDAC 3				//DAC gain in dB {-6dB to 29dB in 1dB steps}
#define GADC 0				//ADC gain in dB {0dB to 47.5dB in 0.5dB steps}

void main(void)
{
	Int16 x[N];			//filter delay line
	Int32 yn = 0;		//output value

	/* Initialize the DSP */
	Init_USBSTK5505();

	/* Initialized AIC3204 */
	Init_AIC3204(SF_8KHz, GDAC, GADC);

	while(1)
	{
		Int8 i = 0;

		/* Read 16-bit right channel data */
		USBSTK5505_I2S_readRight(x);	//get new input into delay line

		yn = h[0]*x[0];				//calculate filter output

		for (i=(N-1); i>0; i--)  {
			yn += h[i]*x[i];			//calculate filter output
			x[i] = x[i-1];			//shuffle delay line contents
		}

		/* Write 16-bit right channel data */
		USBSTK5505_I2S_writeRight((Int16)(yn)); 	//output to codec
	}
}
```

### `ave5.cof`
```c
//ave5.cof Coefficient file
//Implements five point moving average filter

#define N 5 			// Filter Length
Int16 h[N] = {	 		// Filter Coefficients
	1, 1, 1, 1, 1,
};
```

#### QUESTION 1:
__What does the main program do? Why is it set up to be in an infinite loop?__

#### ANSWER 1:
The `main.c` is set up so that it will create a result of convolution output of arrays, `x` and `h`.  The array, `x`, represents the input discrete sequence, and the array, `h`, represents our filter coefficient to be used in the convolution process.

It is set up in an infinite loop, because it is assumed the input signal to be processed never stops in the system.


#### QUESTION 1(a):
__How does the main program have access to the values of `N` and the coefficients `h`?__

#### ANSWER 1(a):
the main program includes this line of code,
```c
#include "ave5f.cof"
```
to call the code that includes information about the filter coefficients, `h`, and the length of the filter, `N`.


#### QUESTION 1(b):
__What is the purpose of the `for` loop?__

#### ANSWER 1(b):
The `for` loop computes the convolution of two discrete sequence inputs, `x` and `h`.


### QUESTION 2:
If the first 10 data values that the CODEC reads are $$[100,\:120,\:100,\:80,\:60,\:40,\:-40,\:-100,\:20,\:100]$$, indicate the value that would be output for `yn` and the values that would be stored in the `x` array at the end of each while loop. Assume that when the program starts, the `x` array is initialized to have all values equal to 0. A table is provided on the next page.

| Cycle | `yn` | `x[0]` | `x[1]` | `x[2]` | `x[3]` | `x[4]` |
| :---: | :--: | :----: | :----: | :----: | :----: | :----: |
| 1 | 460 | 100 | 100 | 120 | 100 | 80 |
| 2 | 520 | 100 | 100 | 100 | 120 | 100 |
| 3 | 520 | 100 | 100 | 100 | 100 | 120 |
| 4 | 500 | 100 | 100 | 100 | 100 | 100 |
| 5 | 500 | 100 | 100 | 100 | 100 | 100 |
| 6 | 500 | 100 | 100 | 100 | 100 | 100 |
| 7 | 500 | 100 | 100 | 100 | 100 | 100 |
| 8 | 500 | 100 | 100 | 100 | 100 | 100 |
| 9 | 500 | 100 | 100 | 100 | 100 | 100 |
| 10 | 500 | 100 | 100 | 100 | 100 | 100 |


### QUESTION 3:
Repeat __(3)__ for the case where $$h[N]=\{0,\:0,\:0,\:1,\:0\}$$ instead of the values shown in `ave5.cof`. What would this filter do?

| Cycle | `yn` | `x[0]` | `x[1]` | `x[2]` | `x[3]` | `x[4]` |
| :---: | :--: | :----: | :----: | :----: | :----: | :----: |
| 1 | 80 | 100 | 100 | 120 | 100 | 80 |
| 2 | 100 | 100 | 100 | 100 | 120 | 100 |
| 3 | 120 | 100 | 100 | 100 | 100 | 120 |
| 4 | 100 | 100 | 100 | 100 | 100 | 100 |
| 5 | 100 | 100 | 100 | 100 | 100 | 100 |
| 6 | 100 | 100 | 100 | 100 | 100 | 100 |
| 7 | 100 | 100 | 100 | 100 | 100 | 100 |
| 8 | 100 | 100 | 100 | 100 | 100 | 100 |
| 9 | 100 | 100 | 100 | 100 | 100 | 100 |
| 10 | 100 | 100 | 100 | 100 | 100 | 100 |


### QUESTION 4:
Modify the C code to implement a notch filter with two poles at $$\begin{matrix}z=\rho{e}^{\pm{j}\omega_0},&\text{for }\rho=0.9\end{matrix}$$ and two zeros at $$z=e^{\pm{j}\omega_0}$$ where the frequency value is selected to put the notch at $$1000\:\text{Hz}$$. Specifically indicate the changes to the coefficient file and the main program to include memory of previous outputs as well as previous inputs. Note that this is a fixed-point processor and so only integer values should be used (try to avoid floating point!). To adjust for this, simply multiply by the value obtained for the filter by 1000 and round to the nearest integer.