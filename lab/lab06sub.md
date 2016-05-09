# lab06sub
FIR and IIR Filters for Audio Processing

## OBJECTTIVES:
- use MATLAB to process audio files using several filters and we will note the effects of the filters on sounds from `.wav` files. 
- use low pass and band pass filters designed with `fir1` used in previous laboratories and notch filters as described below. 
- test echo filters and a nonlinear filter which modulates the frequencies.


## PRELAB:

### 1. 
In MATLAB type “`help wavread`” to read about the function that will read a `.wav` file into an array. Some of the information is shown here.
> `[Y,FS,NBITS]=WAVREAD(FILE)` returns the sample rate (`FS`) in Hertz and the number of bits per sample (`NBITS`) used to encode the data in the file.

### 2.
A short voice and music file will be supplied in the lab. Find a short `.wav` file that you would like to test in the lab and read it with MATLAB. Use sound to verify. (Be sure to use `FS` in the sound function.) 

### 3.
Design an FIR notch filter by specifying the placement of two zeros.
- For a sampling rate of $$8000\:\text{Hz}$$, design an FIR filter to notch out $$1000\:\text{Hz}$$ by placing two zeros on the unit circle at the value of $$\omega_0$$ that corresponds to $$1000\:\text{Hz}$$. Define $$\omega_0$$ and the sampling frequency as parameters so you will only have to make a change in one place if a different value is needed.
	- Compute the filter coefficients for this filter which has two zeros. Note that for two zeros on the unit circle at $$\pm\omega_0$$, 
	$$
	H(z)=\frac{\left(z-e^{j\omega_0}\right)\left(z-e^{-j\omega_0}\right)}{z^2}
	$$
	- Use `freqz` to plot the frequency response of this filter. How would you characterize the width and depth of the notch at $$1\:\text{kHz}? Print the plot.
- Repeat for a sampling frequency of $$11\:\text{kHz}$$.

### 4.
Design an IIR notch filter
- Repeat the FIR design but in addition to the two zeros, add two poles at $$z=\rho{e}^{\pm{j}\omega_0}$$ so that
$$
H(z)=\frac{\left(z-e^{j\omega_0}\right)\left(z-e^{-j\omega_0}\right)}{\left(z-\rho{e}^{j\omega_0}\right)\left(z-\rho{e}^{-j\omega_0}\right)}
$$
	- For both sampling frequencies from part 3, compute the filter coefficients for this filter (which has two zeros and two poles) when $$\rho=0.9$$.
	- Use `freqz` to plot the frequency response of these filters. How would you characterize the width and depth of the notch at $$1\:\text{kHz}$$?

__Submit the answers to the questions and the requested plots.__