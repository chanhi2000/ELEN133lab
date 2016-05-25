# lab08
Low Pass and Multiple Notch Filters Using the TI TMS320C5505

## OBJECTIVES:
In this lab, we explore the design of multiple band and multiple notch filters derived from prototype filters. We will also compare FIR and IIR filters using sinusoidal and square wave inputs. Finally, we will test these filters with real time signals.


## INTRODUCTION:
In Laboratory 7 we implemented a second order IIR filter in Direct Form I to create a narrow notch filter and observed its effectiveness on sinusoidal signals from a signal generator. The same code for the IIR filter implementation could be used for other filters such as a Butterworth, Chebyshev, or elliptic filters, and also for low pass FIR filters. The only changes needed are changing the filter coefficient vectors and the length of the queues storing the previous input and output values. In this laboratory, we will use comb filters to create multiple notch filters and we will compare the performance of FIR and IIR low pass filters.

Consider the effect of replacing $$z$$ in $$H(z)$$ by $$z$$ raised to an integer power. For example, let
$$
H_2(z)=H_0(z^2)
$$
There are two complementary ways to look at the effect of this change. The frequency response will be
$$
H_2\left(e^{j\omega}\right)=H_0\left(e^{j2\omega}\right)
$$
, and now the range $$0\leq\omega<2\pi$$ for $$H_2\left(e^{j2\omega}\right)$$ will include two cycles, or $$0\leq\omega<4\pi$$ from $$H_0\left(e^{j\omega}\right)$$, the original periodic frequency response. For a notch filter, this will add a second notch and for a low pass filter there will be an additional corresponding pass band at the highest frequencies. Midrange frequencies will be suppressed. A second perspective would consider the positions of the poles and zeros. Any pole or zero of the original system function would be of the general form $$z=\rho{e}^{j\phi}$$.  For the new system function this pole or zero would correspond to two poles or zeros of the form shown below, and this will create two cycle of the original frequency response.
$$
\begin{align*}
z^2&=\rho{e}^{j\phi}\\
&=\rho{e}^{j(\theta-2\pi{l})},&&\text{for }l=0,\:1\\
z&=\sqrt{\rho}e^{j\tfrac{\theta}{2}}\\
&=\sqrt{\rho}e^{j\left(\pi+\tfrac{\theta}{2}\right)}\\
\end{align*}
$$
To create the new filter, the same coefficients are used, but they are spread out using only even valued indices. The odd valued indices will have coefficient values of $$0$$. Thus a second order system will become a fourth order system with the following coefficients, where $$a$$ and $$b$$ represent coefficients of the original system and $$a2$$ and $$b2$$ represent coefficients of the new system.
$$
\begin{matrix}
\begin{matrix}
a2_{2n}=a0_n,&0\leq{n}\leq2
\end{matrix}&&
\begin{matrix}
a2_{2n+1}=0,&0\leq{n}\leq1
\end{matrix}\\
\begin{matrix}
b2_{2n}=b0_n,&0\leq{n}\leq2
\end{matrix}&&
\begin{matrix}
b2_{2n+1}=0,&0\leq{n}\leq1
\end{matrix}
\end{matrix}
$$
Similarly, for $$H_3(z)=H_0(z^3)$$ a second order system would become a sixth order system by using the original coefficients at indices that are integral multiple of 3 and setting the rest of the coefficients to 0.

A more general method for generating new filters is to use all pass transformations to warp the unit circle so that a low pass filter can generate an arbitrary low pass, band pass, or high pass filter. For FIR filters, a shift in frequency can be obtained by multiplication with a sampled cosine at the desired new center frequency.


## PRELAB:
### 1.
Using the method of Step 4 of Prelab 6, get the coefficients of a notch filter at a frequency of $$2000\:\text{Hz}$$ with poles at a radius of $$0.9$$. Assume a sampling rate of $$8000\:\text{Hz}$$. Verify your design with MATLAB. Use the `freqz` function to compute the frequency response and plot the magnitude as a function of frequency. Use `zplane` to plot the poles and zeros.

### 2.
Using the filter of Step 1 with a notch at $$2000\:text{Hz}$$, find the coefficients of a 6th order filter $$H_3(z)=H_0(z^3)$$. Plot the frequency response and the pole/zero plot for this filter. At what frequencies do you have notches?

### 3.
Repeat the previous step to create an 8th order filter $$H_4(z)=H_0(z^4)$$.

### 4.
Repeat step 1 for a notch at a frequency of $$666.67\:\text{Hz}$$.

### 5.
Type "`help butter`" in MATLAB to see how to get coefficients for a Butterworth low pass filter. Using the MATLAB function `[b, a] = butter(N, w)`, compute the coefficients for a second order Butterworth filter with a cutoff frequency of $$1200\:\text{Hz}$$. (Be careful to scale the cutoff frequency correctly to get the value for w in the function call.) Verify your design with MATLAB by plotting the frequency response and the pole/zero plot for this filter.

### 6.
Using the filter of Step 5, find the coefficients of a 6th order filter $$H_3(z)=H_0(z^3)$$ as you did in Step 2. Plot the frequency response and the pole/zero plot for this filter.


## QUESTIONS:
### 1.
How are the positions of the poles and zeros in the 6th order filters related to the positions of the poles and zeros of the second order filters used to create the sixth order filters? How do they move for the eighth order filter?

### 2.
How does the width of the notch at $$666.67\:\text{Hz}$$ in Step 4 compare to the width of the notch at that frequency in Step 2? Why?

### 3.
If a notch filter were needed to remove an interfering sinusoidal signal at $$666.67\:\text{Hz}$$, would the filters from Step 2 and Step 3 give approximately similar results? How would your answer change if the interfering signal were a non-sinusoidal periodic signal with a repetition frequency of 666.67 Hz? Consider, for example, a square wave interference.

### 4.
Explain the frequency response of the 6th order filter in Step 6.

__Submit the answers to the questions and the plots of the frequency responses and pole/zero diagrams.__


## LABORATORY PROCEDURE:
This laboratory will use the same board for real time signal processing as the previous laboratory. Programs will be able to switch from one filter to another based on loading different coefficient files. In this laboratory, we will observe filter performance on controlled signals from a signal generator and also on audio signals.

### PART 1
__Set up the equipment as you did in the previous laboratory.__

1. Turn on the signal generator and the oscilloscope so they can warm up.
2. Connect the board to the computer using the USB cable and connect power to the board.
3. Set up the signal generator to produce a $$500\:\text{Hz}$$ sinusoidal signal with an amplitude of $$0.5\:\text{V}$$ peak to peak. Using a BNC T connector, connect the output of the signal generator to an oscilloscope input and to the board input. Display the signal on the scope and verify the amplitude and frequency. Set this channel up to be the sync trigger for the scope.
4. Connect the analog output from the DSK board to a second scope input.


### PART 2:
__Create a project with Code Composer as you did in the previous laboratory.__

1. Create two coefficient files that set the values for a and b. One filter should be the second order notch filter from your prelab with a notch at $$666.67\:\text{Hz}$$. The second filter should be the 6th order filter from your prelab that was created using coefficients from the second order notch filter with a notch at $$2000\:\text{Hz}$$. This filter should produce three notches.
Code should be flexible so that you can easily switch between these coefficient files so set $$N$$ to the appropriate length in each file.
2. Include your new coefficient file in your main.c.
3. Compile and debug your code.

### PART 3:
__Explore the performance of the two notch filters.__

1. Include the appropriate coefficients file to select the second order notch filter.
2. Set the signal generator up to output a sinusoidal signal. First, listen to the filtered output as you increase the frequency from $$100\:\text{Hz}$$ to $$4000\:\text{Hz}$$ and note frequencies at which the sound amplitude changes. Based on that, select some specific frequencies that will allow you to sketch the frequency response, and record the amplitude of the output at those frequencies. Try to accurately represent the frequency of the notch and the width of the notch.
3. Change the signal generator to a square wave output and repeat step 2. Also observe the shape of the waveform for the frequencies from $$100$$ to $$700\:\text{Hz}$$ and note changes as the frequency increases. Describe the output waveform at $$667\:\text{Hz}$$. What frequency is the main frequency present?
4. Now, include the coefficient file to use the second filter and repeat steps 2 and 3. Compare the results of the two filters for sinusoidal inputs.
5. Compare the results of the two filters for square wave inputs. If you wanted to filter out interference from a signal that was not a perfect sinusoidal signal, how would the additional notches of the second filter help?


### PART 4:
__Make a new program and coefficient files for low pass and high pass filters. In the end, you should have eight coefficient files for the eight combinations of: low pass and high pass, cutoff frequency of $$1200\:\text{Hz}$$ and $$2000\:\text{Hz}$$, and FIR or IIR Butterworth.__

1. Get filter coefficients for eight filters:
	1. Use MATLAB to generate coefficient files for two low pass Butterworth filters of order 10, one with a cutoff frequency of $$1200\:\text{Hz}$$ and one with a cutoff frequency of $$2000\:\text{Hz}$$ using `[b, a] = butter(N,w);`, as you did in the PreLab. Use `[b, a] = butter(N,w,'high');` to get coefficients for the two corresponding high pass filters. These should go in four appropriately named and easily identifiable coefficients files.
	2. Use MATLAB to generate coefficient files for two low pass FIR filters of order 10, one with a cutoff frequency of $$1200\:\text{Hz}$$ and one with a cutoff frequency of $$2000\:\text{Hz}$$ using `b = fir1(N, w, rectwin(N+1), 'noscale');`, as you did in previous labs. For these filters the a vectors will each be a length 11 vector with the first coefficient set to 1 and the rest set to zero. However, in the implementation, the a[0] coefficient is never used because it is the multiplier for y[n]. Use `b = fir1(N, w, 'high', rectwin(N+1), 'noscale');` to get coefficients for the two corresponding high pass filters. These should go in four additional appropriately named and easily identifiable coefficients files.
2. Make a new program based on your previous program for the notch filters to allow the code to work simply by selecting the appropriate coefficients file.
3. Run your new program eight times (once with each coefficients file) with signal generator input and verify that that the filters are performing correctly. Use both sinusoidal inputs and square wave inputs. What are the differences between the FIR and IIR filters in attenuating frequencies above the cutoff frequency? What are the difference between the FIR and IIR filters on the wave shape of the square wave?


## QUESTIONS:
1. For the eight filters in Part 4, plot pole-zero diagrams and frequency responses using MATLAB. What is the difference between the high pass and low pass IIR filter locations of the poles and zeroes? What is the difference between the high pass and low pass FIR filter locations of the zeroes? For the FIR filter, how are the b coefficients different for the low and high pass filters?
2. How would you design a notch filter to filter out all periodic signals at a fundamental frequency of $$500\:\text{Hz}$$ with only odd harmonics?


__Submit the answers to the questions above and the questions in the laboratory procedure as well as the data and sketches requested in the procedure. Submit a listing of`C code instructions and your coefficients for Parts 3-5.__
