# lab06
FIR and IIR Filters for Audio Processing

## OBJECTTIVES:
In this laboratory, we will use MATLAB to process audio files using several filters and we will note the effects of the filters on sounds from `.wav` files. We will use low pass and band pass filters designed with `fir1` used in previous laboratories and notch filters as described below. We will also test echo filters and a nonlinear filter which modulates the frequencies.


## BACKGROUND NOTES:
For some filtering applications, a lower order infinite impulse response (IIR) filter with feedback from delayed outputs may be preferable to a long FIR filter such as those designed using the MATLAB function fir1. Although there are a number of methods for mapping analog filter designs to IIR digital designs, a simple method for controlling the frequency response involves selecting poles and zeros in the Z transform which maps directly into a difference equation.

As we will see (or have seen) in class, the Z-transform for the complex variable $$z$$ is defined by
$$
X(z)=\sum_{n=-\infty}^{\infty}{x[n]z^{-n}}
$$
Writing $$z$$ in terms of magnitude and phase as $$z=re^{j\omega}$$ shows that the DTFT is a special case of the Z transform when $$r=1$$.
If
$$
x_2[n]=x_1[n-1]
$$
then
$$
X_2(z)=X_1(z)z^{-1}
$$
so $$z^{-1}$$ represents a unit delay. We saw this early in class as we defined a block with a $$z^{−1}$$ in it as a unit delay.

For a second order system, the difference equation and corresponding transfer function are:
$$
\begin{align*}
y[n]&=b_0x[n]+b_1x[n-1]+b_2x[n-2]-a_1y[n-1]-a_2y[n-2]\\
y[n]+a_1y[n-1]+a_2y[n-2]&=b_0x[n]+b_1x[n-1]+b_2x[n-2]\\\\
Y(z)\left(1+a_1z^{-1}+a_2z^{-2}\right)&=X(z)\left(b_0+b_1z^{-1}+b_2z^{-2}\right)\\
H(z)&=\frac{Y(z)}{X(z)}=\frac{b_0+b_1z^{-1}+b_2z^{-2}}{1+a_1z^{-1}+a_2z^{-2}}
\end{align*}
$$

The zeros of the polynomial in the denominator are the poles of the transfer function $$H(z)$$, and the zeros of the polynomial in the numerator are the zeros of the function.


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
	- Use `freqz` to plot the frequency response of this filter. How would you characterize the width and depth of the notch at $$1\:\text{kHz}$$? Print the plot.
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


## LAB:

### STEP 1:
Use the MATLAB function spectrogram to view the time varying frequency content of signals.

- In MATLAB type “`help spectrogram`” to read about the function that computes the DFT of short overlapping segments of a signal and displays the results as an image where the strength of each frequency in a specific short segment is indicated by a color. Blue is the lowest strength and red is the highest. When '`yaxis`' is used, the time axis is the horizontal axis and the frequency axis is the vertical axis. This is a short-time Fourier transform and it allows us to do frequency analysis with some time localization.
- Use `testSig3` from Laboratory 3 for an initial test because you are very familiar with its structure. With `fs0` set to `8000`, type the following to view three versions of the spectrogram in three different figure windows:
```matlab
figure(1) % window = 1024, overlap=512, fftlength = 1024
spectrogram(testSig3, 1024, 512,1024,fs0, 'yaxis')
figure(2) % window = 512, overlap=256, fftlength = 512
spectrogram(testSig3, 512, 256,512,fs0, 'yaxis')
figure(3) % window = 200, overlap=100, fftlength = 512
spectrogram(testSig3, 200, 100,512,fs0, 'yaxis')
```
	- Identify the parameters in the spectrogram function call and for each display, determine the length of the signal segment analyzed in terms of samples and time.
	- Compare the three displays with respect to the following to determine the effect of changing the length of the segments used to compute the Fourier transform
		- Which display has the sharpest frequency resolution? How wide are the red lines indicating the strong signals at the tones used to identify the four buttons?
		- Can you reliably distinguish the individual button tones in all three displays?
		- Which display has the best time resolution? How wide and distinct are the dark blue horizontal strips indicating the “quiet time”?
		- Can you reliably distinguish the quiet time between buttons in all three displays?
- Read the `.wav` file tone1026 and save its sampling frequency to use with sound and
spectrogram.
```matlab
[yA, fsA, nbitsA]=wavread('tone_1026.wav')
```
	- Listen to the signal using sound.
	- View the spectrogram computed with a “`window`” parameter of `2048`, and overlap of `1024`, and an `fft` length of `2048`. The parameters are increased because this sampling rate is $$22\:\text{kHz}$$, not $$8\:\text{kHz}$$. Explain how the spectrogram represents the sound you heard.
- Repeat the previous step for a short music file (*e.g.* `xtheme.wav`) and a short speech file (*e.g.* `ghostbusters.wav`). Consider the sampling rate when selecting spectrogram parameters. The overlap should be half the window width and the fft length should be the same as the window width or twice as big as the window width.

### STEP 2:
Create frequency selective filters and listen to the effect of the filters.

Use the function `fir1` as you did in lab 4 to create the following three FIR filters for the sampling rate for a `.wav` file. All filters have a length of 200 samples.
	 - low frequency edge = 200 Hz, high frequency edge = 500 Hz
	 - low frequency edge = 800 Hz, high frequency edge = 1000 Hz
	 - low frequency edge = 2000 Hz, high frequency edge = 3000 Hz
- Use the function filter to create the filtered output of the `.wav` file. Reread the help information on filter and find out how it is implemented.
- Test your filters on `tone-1026` and note the effect of the selected frequency range.
- Test your filters on a speech and music `.wav` file. Can you understand the speech in all three bands? Use spectrogram to verify that the pass-bands are at the frequencies you specified.

### STEP 3:
Create notch filters and listen to the effect of the filters.
A good notch filter should be able to remove an interfering signal in a narrow frequency range without disturbing nearby frequencies. Read a wav file with speech in it. Create a modified file with interference that is the sum of the wav file multiplied by 0.5 and a cosine with an amplitude of 0.5 and a frequency of $$1000\:\text{Hz}$$. Listen to the speech with interference using sound.
- Find the value of $$\omega_0$$ that corresponds to $$1000\:\text{Hz}$$ for the sampling rates of your wav file.
- Using this value for $$\omega_0$$ , compute the coefficients for the two filters you explored in the Prelab with
$$
H(z)=\frac{\left(z-e^{j\omega_0}\right)\left(z-e^{-j\omega_0}\right)}{z^2}
$$
and
$$
H(z)=\frac{\left(z-e^{j\omega_0}\right)\left(z-e^{-j\omega_0}\right)}{\left(z-\rho{e}^{j\omega_0}\right)\left(z-\rho{e}^{-j\omega_0}\right)}
$$
- Use the function filter to create outputs from the sample speech file for each of the two filters and listen to the output using sound. How much difference can you hear between the FIR output and the IIR output?
- Use the function filter to create outputs from a speech file with the interfering tone for each of the two filters and listen to the output using sound. How much difference can you hear between the FIR output and the IIR output?
- Use spectrogram to verify that the notch is at the frequency you specified.


### STEP 4:
Modulate the audio signal.

Modulation is a nonlinear process which shifts the frequencies in a signal. If a signal $$x[n]$$ is multiplied by $$s[n]=\cos{\left(2\pi\left(\tfrac{f_0}{F_s}\right)n\right)}$$, it creates the sum of $$x[n]$$ shifted up in frequency by $$f_0$$ and $$x[n]$$ shifted down in frequency by $$f_0$$.
- Select a file with speech. Use its sampling frequency and length to create a signal $$s[n]$$ of the same length for $$f_0=100\:\text{Hz}$$. Create the product of your signal and s[n] using the `.*` multiply in MATLAB, not the `*` multiply.
- Listen to the result and describe how it sounds. Can you still understand it?
- Repeat for $$f_0=\tfrac{F_s}{4}$$
- Repeat for $$f_0=\tfrac{F_s}{2}$$.
- Try all three modulations with `tone1026`.


## LAB REPORT:

__Submit the answers to the questions and the information requested in the laboratory procedure__.
