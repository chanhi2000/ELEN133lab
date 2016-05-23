# lab08sub
Low Pass and Multiple Notch Filters Using the TI TMS320C5505


## OBJECTIVES:
- Explore the design of multiple band and multiple notch filters derived from
prototype filters.
- Compare FIR and IIR filters using sinusoidal and square wave inputs. 
- Test these filters with real time signals.


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