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
| 1 | 100 | 100 | 0 | 0 | 0 | 0 |
| 2 | 220 | 120 | 100 | 0 | 0 | 0 |
| 3 | 320 | 100 | 120 | 100 | 0 | 0 |
| 4 | 400 | 80 | 100 | 120 | 100 | 0 |
| 5 | 460 | 60 | 80 | 100 | 120 | 100 |
| 6 | 500 | 40 | 60 | 80 | 100 | 120 |
| 7 | 460 | -40 | 40 | 60 | 80 | 100 |
| 8 | 360 | -100 | -40 | 40 | 60 | 80 |
| 9 | 380 | 20 | -100 | -40 | 40 | 60 |
| 10 | 480 | 100 | 20 | -100 | -40 | 40 |


### QUESTION 3:
Repeat __(3)__ for the case where $$h[N]=\{0,\:0,\:0,\:1,\:0\}$$ instead of the values shown in `ave5.cof`. What would this filter do?

| Cycle | `yn` | `x[0]` | `x[1]` | `x[2]` | `x[3]` | `x[4]` |
| :---: | :--: | :----: | :----: | :----: | :----: | :----: |
| 1 | 0 | 100 | 0 | 0 | 0 | 0 |
| 2 | 0 | 120 | 100 | 0 | 0 | 0 |
| 3 | 0 | 100 | 120 | 100 | 0 | 0 |
| 4 | 100 | 80 | 100 | 120 | 100 | 0 |
| 5 | 120 | 60 | 80 | 100 | 120 | 100 |
| 6 | 100 | 40 | 60 | 80 | 100 | 120 |
| 7 | 80 | -40 | 40 | 60 | 80 | 100 |
| 8 | 60 | -100 | -40 | 40 | 60 | 80 |
| 9 | 40 | 20 | -100 | -40 | 40 | 60 |
| 10 | -40 | 100 | 20 | -100 | -40 | 40 |


### QUESTION 4:
Modify the C code to implement a notch filter with two poles at $$\begin{matrix}z=\rho{e}^{\pm{j}\omega_0},&\text{for }\rho=0.9\end{matrix}$$ and two zeros at $$z=e^{\pm{j}\omega_0}$$ where the frequency value is selected to put the notch at $$1000\:\text{Hz}$$. Specifically indicate the changes to the coefficient file and the main program to include memory of previous outputs as well as previous inputs. Note that this is a fixed-point processor and so only integer values should be used (try to avoid floating point!). To adjust for this, simply multiply by the value obtained for the filter by 1000 and round to the nearest integer.
$$
\begin{align*}
H(z)&=\frac{\left(z-e^{j\omega_0}\right)\left(z-e^{-j\omega_0}\right)}{\left(z-0.9e^{j\omega_0}\right)\left(z-0.9e^{-j\omega_0}\right)}\\
&=\frac{z^2-z\left(e^{j\omega_0}+e^{-j\omega_0}\right)+1}{z^2-0.9z\left(e^{j\omega_0}+e^{-j\omega_0}\right)+0.81}\\
&=\frac{z^2-z\left(2\cos{\left(\omega_0\right)}\right)+1}{z^2-0.9z\left(2\cos{\left(\omega_0\right)}\right)+0.81}\\
&=\frac{z^2-z\sqrt{2}+1}{z^2-z(0.9\sqrt{2})+0.81}
\end{align*}
$$
This is an IIR filter.  We need to make coefficients for both denominator and nominator. So given the transfer function,
$$
H(z)=\frac{z^2-z\sqrt{2}+1}{z^2-z(0.9\sqrt{2})+0.81}
$$
We can find the discrete-time sequence as followed.
$$
\begin{align*}
Y(z)\left(z^2-z(0.9\sqrt{2})+0.81\right)&=X(z)\left(z^2-z\sqrt{2}+1\right)\\
Y(z)z^2-0.9\sqrt{2}Y(z)z+0.81Y(z)&=X(z)z^2-\sqrt{2}X(z)z+X(z)\\
Y(z)-0.9\sqrt{2}Y(z)z^{-1}+0.81Y(z)z^{-2}&=X(z)-\sqrt{2}X(z)z^{-1}+X(z)z^{-2}\\\\
y[n]-0.9\sqrt{2}y[n-1]+0.81y[n-2]&=x[n]-\sqrt{2}x[n-1]+x[n-2]\\
y[n]&=x[n]-\sqrt{2}x[n-1]+x[n-2]+0.9\sqrt{2}y[n-1]-0.81y[n-2]
\end{align*}
$$
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
	float x[N];						// filter delay line
	float y[N];
	Uint16 i = 0;

	/*Initialize delay lines*/
	for (i=0 ; i<N ; i++) {
		x[i] = 0;					// initialize contents of delay line to 0
		y[i] = 0;
	}

	/*Initialize DSP and CODEC*/
	Init_USBSTK5505(SF, GDAC, GADC);

	/* Infinite loop */
	while(1)
	{
		x[0] = (float)read_right();		// input sample from codec

		/* Implement filter */
		y[0] = b[0]*x[0]; 				// initialize filter output
		for (i=(N-1) ; i>0 ; i--)
		{
			y[0] += b[i]*x[i] - a[i]*y[i];

			x[i] = x[i-1]; 				// shuffle delay line contents
			y[i] = y[i-1];
		}

		write_right((Int16)(GAIN*y[0])); 	// output sample to codec
	}
}
```

### `ave5.cof`
```c
//ave5.cof Coefficient file
//Implements five point moving average filter

#define N 3 			// Filter Length
Int16 b[N] = {	 		// Filter Coefficients
	1, -1.414, 1
};

Int16 a[N] = {	 		// Filter Coefficients
	1, -1.273, 0.81
};
```

## LAB
### STEP 2:
Setup and Verify Test/Measurement Solution

#### 1.
Set up the signal generator to produce a $$500\:\text{Hz}$$ sinusoidal signal with an amplitude of $$0.5\:\text{V}$$ peak-to-peak. Using a BNC “T” connector, split the output of the signal generator so that it can go to an oscilloscope input as well as the board input.

Run the program and view the input and output signals on the scope. Be sure that the scope sync is set up to trigger on the signal generator signal for both displays.

Verify that the output signal looks like the signal generator signal. From the scope display measure and record the time between the peak of the signal generator signal and the board’s output signal.

This measures the minimum delay between capturing a sample with the ADC and then outputting it through DAC when there is no processing also known as the minimum latency. In real-time DSP solutions, latency is impossible to avoid and so phase shifts between the input and output signals are inevitable. However, as long as the chip is able to complete the necessary signal processing within the given sampling period, the system is said to be “real-time”


#### ANSWER TO 1.

| function generator | input | output |
| :----------: | :---: | :----: |
| ![fig01a](lab07sub/step02/lab07sub-fig01a.jpg) | ![fig01b](lab07sub/step02/lab07sub-fig01b.jpg) | ![fig01c](lab07sub/lab07sub-fig01c.jpg) |

The latency is measured to be roughly $$0.9\:\text{ms}$$


### STEP 3:
Explore the analog anti-aliasing and anti-imaging filters of

#### 1.
Decrease the frequency of the signal generator signal until the output amplitude is less than half the amplitude of the $$500\:\text{Hz}$$ output. Record this frequency value.

| function generator | oscilliscope |
| :-------: | :----------: |
| ![fig01a](lab07sub/step02/lab07sub-fig01a.jpg) | ![fig02a](lab07sub/step03/lab07sub-fig02a.jpg) |
| ![fig02b](lab07sub/step03/lab07sub-fig02b.jpg) | ![fig02c](lab07sub/step03/lab07sub-fig02c.jpg) |


#### 2.
Increase the frequency until the output is less than half the amplitude of the $$500\:\text{Hz}$$ output. Record this frequency value.

| function generator | oscilliscope |
| :-------: | :----------: |
| ![fig01a](lab07sub/step02/lab07sub-fig01a.jpg) | ![fig02a](lab07sub/step03/lab07sub-fig02a.jpg) |
| ![fig03a](lab07sub/step03/lab07sub-fig03a.jpg) | ![fig03b](lab07sub/step03/lab07sub-fig03b.jpg) |


#### 3.
Set the frequency of the signal generator to $$200\:\text{Hz}$$ and verify that you can see the output signal.

| function generator | oscilliscope |
| :-------: | :----------: |
| ![fig04a](lab07sub/step03/lab07sub-fig04a.jpg) | ![fig04b](lab07sub/step03/lab07sub-fig04b.jpg) |


#### 4-6.
Change the signal generator waveform to a square wave. Sketch the output waveform shape.

Increase the signal generator frequency to 500 Hz. How does the output waveform change?

Increase the frequency further and note frequencies at which there is a noticeable change in the waveform shape.

| function generator | oscilliscope |
| :-------: | :----------: |
| ![fig05a](lab07sub/step03/lab07sub-fig05a.jpg) | ![fig05b](lab07sub/step03/lab07sub-fig05b.jpg) |
| ![fig05c](lab07sub/step03/lab07sub-fig05c.jpg) | ![fig05d](lab07sub/step03/lab07sub-fig05d.jpg) |
| ![fig05e](lab07sub/step03/lab07sub-fig05e.jpg) | ![fig05f](lab07sub/step03/lab07sub-fig05f.jpg) |

The output starts to transform into more closer form of sinusoidal wave.


#### 7.
Repeat steps 3.3 to 3.6 using a __triangular wave shap__e. How does this result compare to the square wave results?

| function generator | oscilliscope |
| :-------: | :----------: |
| ![fig06a](lab07sub/step03/lab07sub-fig06a.jpg) | ![fig06b](lab07sub/step03/lab07sub-fig06b.jpg) |
| ![fig06c](lab07sub/step03/lab07sub-fig06c.jpg) | ![fig06d](lab07sub/step03/lab07sub-fig06d.jpg) |
| ![fig06e](lab07sub/step03/lab07sub-fig06e.jpg) | ![fig06f](lab07sub/step03/lab07sub-fig06f.jpg) |

#### 8-9.
Set the wave shape back to sinusoidal at $$500\:\text{Hz}$$.

Change the coefficients in test.cof to all be zero except for the `h[4]` value, which will be one. Repeat Step 2.9. How does this time interval compare to the interval measured in Step 2.9?

##### new `test.cof`
```c
// test.cof Coefficient file
// Outputs sample values with no digital signal processing

# define N 5 // Filter Length

Int16 h[N] = { // Filter Coefficients
	0, 0, 0, 0, 1,
};
```

| old `test.cof` | new `test.cof` |
| :-------: | :----------: |
| ![fig02a](lab07sub/step03/lab07sub-fig02a.jpg) | ![fig07b](lab07sub/step03/lab07sub-fig07b.jpg) |

The latency is increased. It's measured to be roughly $$1.2\:\text{ms}$$, whereas the original latency was measured as $$0.9\:\text{ms}$$.


### STEP 4.
Explore the five sample moving average FIR filteruding `ave5.cof` file instead of `test.cof` and rebuilding the project.

#### 1.
Use the version of main.c from the Step 3, but include “`ave5f.cof`” in place of “`test.cof`”.

##### `ave5f.cof`
```c


```

#### 2-3.
With a sinusoidal signal with an amplitude of 0.5 V peak-to-peak, observe the amplitude of the output signal as you vary the frequency.

Predict the frequencies that you would expect to have an output amplitude of $$0$$ from your filter, which is averaging the 5 most recent input values. Change the frequency of the signal generator and find two frequencies where the output is zero. Record the frequency values. How do they compare to your prediction?

| function generator | oscilliscope |
| :-------: | :----------: |
| ![fig08a](lab07sub/step04/lab07sub-fig08a.jpg) | ![fig08b](lab07sub/step04/lab07sub-fig08b.jpg) |
| ![fig08c](lab07sub/step04/lab07sub-fig08c.jpg) | ![fig08d](lab07sub/step04/lab07sub-fig08d.jpg) |

#### 4.
Record the amplitude of the output at other frequencies and create a rough sketch of the frequency response of your filter.

| frequency | amplitude |
| :-------: | :-------: |


### STEP 5.
Build and test a new project for a notch filter.

#### 2-3.
The notch filter should have two poles and two zeroes. Use the notch filter `C` code from your prelab work and set the notch filter parameters to create a notch at $$1\:\text{kHz}$$ when the sampling rate is $$8\:\text{kHz}$$. The poles should have a magnitude of $$0.9$$.

Test and debug your code. Be very careful that the data stored in the two queues is the correct data located at the correct index values.

#### ANSWER to 2-3.
Given
$$
\begin{align*}
f_c&=1000\:\text{kHz};\\
f_T&=8000\:\text{kHz};\\
\omega_c&=2\pi\frac{f_c}{f_T}\\
&=2\pi\frac{(1000)}{(8000))}\\
&=\frac{\pi}{4};
\end{align*}
$$
We can find the zeros
$$
\begin{align*}
H(z)&=\frac{\left(z-e^{j\omega_c}\right)\left(z-e^{-j\omega_c}\right)}{\left(z-0.9e^{j\omega_c}\right)\left(z-0.9e^{-j\omega_c}\right)}\\
&=\frac{z^2-2(0.9)\cos{\left(\omega_c\right)z+(0.9)^2}}{z^2-2\cos{\left(\omega_c\right)z+1}}\\
&=\frac{z^2-1.2727z+(0.9)^2}{z^2-1.4141z+1}
\end{align*}
$$

##### `lab7_notch.cof`
```c
//lab7_notch.cof Coefficient file
// a notch filter that cuts out 1000 Hz

#define N 3		// Filter Length

float a[N] = {	// Filter Coefficients (poles)
	1, -1.2728, 0.81
};

float b[N] = {  // Filter Coefficients (zeros)
	1, -1.4142, 1
};
```

#### 4-5.
Find a signal generator frequency an output of 0. How close is it to $$1\:\text{kHz}$$?

Find the frequencies above and below the notch frequency where the amplitude is 50% of the output level at $$1\:\text{kHz}$$. How wide is the notch?

##### TEST RESULTS

| function generator | oscilliscope |
| :----------------: | :----------: |
| ![fig09a](lab07sub/step05/lab07sub-fig09a.jpg) | ![fig09b](lab07sub/step05/lab07sub-fig09b.jpg) |
| ![fig09c](lab07sub/step05/lab07sub-fig09c.jpg) | ![fig09d](lab07sub/step05/lab07sub-fig09d.jpg) |
| ![fig09e](lab07sub/step05/lab07sub-fig09e.jpg) | ![fig09f](lab07sub/step05/lab07sub-fig09f.jpg) |
| ![fig09g](lab07sub/step05/lab07sub-fig09g.jpg) | ![fig09h](lab07sub/step05/lab07sub-fig09h.jpg) |

#### ANSWER TO 4-5.
The frequency where the output amplitude becomes 0 was, as expected, at $$1000\:\text{Hz}$$.

And the two frequencies were found were the output amplitude is 50% of the output level at $$1000\:\text{Hz}$$: $$980\:\text{Hz}$$, and $$1020\:\text{Hz}$$. It's roughly a deviation of $$20\:\text{Hz}$$ away from the cutoff frequency.


## QUESTION:
### 1.
What changes would be needed in the program to output the average of the last 15 inputs instead of the last 5?

### ANSWER to 1.
The number of inputs are changed, so the only thing needed to change is the macro `N`, which represents the length of the filter coefficient array.


### 2.
How long would the input queue need to be for an FIR filter to add an echo with a delay of $$0.5\:\text{s}$$?

### ANSWER to 2.
As observed from the delay in the STEP 1, the latency is increased, as the number of coefficients that take part in the difference equation increases.
when we placed


### 3.
Why do the square wave and triangle wave change shape as the frequency is increased? At what frequency would you expect them both to look like a sinusoidal signal? Why?

### ANSWER TO 3.
Both square wave and triangle wave, later on, change their shapes as the frequency is increased.

In the first filter, with coefficents $$h[n]=\{1,\:0,\:0,\:0,\:0\}$$, About at the less than a half of sampling frequency, we noticed the change in shape.

This occurance of losing shapes may be caused by the inherent latency we observed from the experimental result.

### 4.
How would you modify your C code to implement your notch filter in a Direct Form II transpose form?




[1a]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step02/lab07sub-fig01a.JPG
[1b]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step02/lab07sub-fig01b.JPG 
[1c]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step02/lab07sub-fig01c.JPG
[1d]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step02/lab07sub-fig01d.JPG
[1e]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step02/lab07sub-fig01e.JPG
[2a]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step03/lab07sub-fig02a.JPG
[2b]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step03/lab07sub-fig02b.JPG 
[2c]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step03/lab07sub-fig02c.JPG
[3a]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step03/lab07sub-fig03a.JPG
[3b]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step03/lab07sub-fig03b.JPG
[4a]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step03/lab07sub-fig04a.JPG
[4b]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step03/lab07sub-fig04b.JPG
[5a]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step03/lab07sub-fig05a.JPG
[5b]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step03/lab07sub-fig05b.JPG 
[5c]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step03/lab07sub-fig05c.JPG
[5d]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step03/lab07sub-fig05d.JPG
[5e]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step03/lab07sub-fig05e.JPG
[5f]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step03/lab07sub-fig05f.JPG
[6a]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step03/lab07sub-fig06a.JPG
[6b]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step03/lab07sub-fig06b.JPG 
[6c]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step03/lab07sub-fig06c.JPG
[6d]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step03/lab07sub-fig06d.JPG
[6e]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step03/lab07sub-fig06e.JPG
[6f]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step03/lab07sub-fig06f.JPG
[7a]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step03/lab07sub-fig07a.JPG
[7b]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step03/lab07sub-fig07b.JPG
[8a]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step04/lab07sub-fig08a.JPG
[8b]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step04/lab07sub-fig08b.JPG 
[8c]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step04/lab07sub-fig08c.JPG
[8d]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step04/lab07sub-fig08d.JPG
[9a]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step05/lab07sub-fig09a.JPG
[9b]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step05/lab07sub-fig09b.JPG 
[9c]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step05/lab07sub-fig09c.JPG
[9d]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step05/lab07sub-fig09d.JPG
[9e]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step05/lab07sub-fig09e.JPG
[9f]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step05/lab07sub-fig09f.JPG
[9g]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step05/lab07sub-fig09g.JPG
[9h]: https://raw.githubusercontent.com/chanhi2000/ELEN133lab/master/lab/lab07sub/step05/lab07sub-fig09h.JPG