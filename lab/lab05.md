# lab05

## OBJECTIVES:
- Use MATLAB to help us learn the DFT and how to use it to detect DTMF tones. 
- Test the selected filter using test signals similar to those generated in Laboratories 3 and 4.


## BACKGROUND NOTES:
The MATLAB `fft` function computes the Discrete Fourier Transform (DFT) of an input signal of length $$N$$ at $$N$$ points uniformly spaced in frequency from $$0$$ to the sampling frequency. Unlike `freqz` however, it does not return a vector of those evaluation frequencies points, so if it is needed to plot the Fourier transform, we have to create it.

The DFT has no time localization within the N-point sequence, so the DFT of a sequence of tones will show energy at all the tone frequencies with no information about the time order of the tones. The `fft` output for a complete dialing sequence would clearly shows peaks at the row and column frequencies. However, from that result we cannot determine exactly which buttons were used or even how many buttons were pressed. When the DFT of short segments of the signal are used, it is possible to see the frequencies for a single button, but the peak at the button frequencies will be spread out over a much wider range because of the reduced value of N.

In this laboratory you will explore using results of the `fft` of short segments of a dial sequence to create a signal for each button that will indicate when it is active. You will look at the tradeoffs between selecting a short length so that two buttons will never occur at the same time and the quiet period can be detected or selecting longer lengths that have better frequency resolution.


## PRELAB:
In this PreLab, we will explore using the Fourier transform to identify all the frequencies in a signal at the same time. In the previous laboratory, we used the MATLAB function `freqz` to compute the frequency response of a filter that was specified by the coefficients of its difference equation. The frequency response is a function of the continuous frequency variable, so we also specified how many values of the frequency should be selected for evaluation. For example, the command line __`>> [H770, fv] = freqz(b770, 1, 512, fs);`__ specifies that the frequency response should be evaluated at 512 values uniformly spaced in frequency from $$0$$ to $$\tfrac{f_s}{2}$$. The frequency response values were placed in the output vector `H770` and the vector of frequencies evaluated was placed in the output vector `fv`.

We can compute the Discrete Fourier Transform (DFT) of a signal more efficiently using a MATLAB function called `fft`. Like `freqz`, it will select samples of the continuous frequency variable for evaluation of the Fourier transform. The number of frequencies selected by the `fft` function is the same as the number of sampled data values in the signal vector. When we use `fft`, we have to make our own `fv` vector.

### 1. 
Read the above Background Notes and start of the PreLab and understand, as much as possible, what the `fft` will be providing for you. In MATLAB, type “`help fft`” to read about the function that will generate values of the Fourier transform at selected frequency values.

### 2.
We will look at the Fourier transform of `testSig3` from your Laboratory 3 and see if we can determine which buttons were used to generate the signal.

Using your `m`-files from Laboratory 3, create `testSig3`. Verify that it is correct using the sound function.

Print a plot of testSig3 to be used later in this Prelab.

### 3.
Create `S3=fft(testSig3)`, the Fourier transform of `testSig3`, using `fft`. View the results with plot(S3). What do you observe? How do you explain this?

### 4.
Try the plot again with `plot(abs(S3))`. Now what do you see? How is it related to the DTMF test signal you generated? (__NOTE__: If your plot does not show a signal with 14 pulses in four sub-groups, check the signal you are using with sound and check the commands you are using for the `fft`.)

### 5.
The main frequencies present in a signal are hard to interpret from a plot such as the one we just created because the values of the transform are plotted as a function of the index of the transform data array. For `fs=8000` we can create a frequency vector for the frequencies used by `fft` with:
```matlab
fv = (0:length(S3)-1) * fs/length(S3);
plot(fv, abs(S3));
```

On this plot, use the zoom feature of the plot window to identify the horizontal location and height of the peak of each pulse on the left half of the display. Record the height of each pulse as well as the center frequency and width in $$\text{Hz}$$ of each pulse.

#### 5(a)
How would you characterize the shape of the pulses?

#### 5(b)
Why is one pulse on the left side larger than all the others?

#### 5(c)
What are the pulses on the right side?

#### 5(d)
Can you tell what sequence of buttons generated this signal just by looking at this result? Why or why not?

It is also important to also be comfortable with the `fftshift` command and to be able to generate plots as we have viewed them in class. Type the following to view a ‘shifted’ plot that is centered at $$f=0$$.
```matlab
plot(fv-(fs/2), fftshift(abs(S3)));
```
For remaining plots, use whichever version you are comfortable with, but make sure you understand both.


### 6. 
Create a new signal that is a short time segment of `testSig3` using
```matlab
n1=1;
n2=4000;
sig3a = testSig3(n1:n2);
```
On your printed plot of `testSig3`, mark the region corresponding to `sig3a`.
Compute the DFT and plot the results as you did for the complete `testSig3`. Note that you will have to create a new vector, `fv`, for the plot using the length of `sig3a` which is determined by `n1` or `n2`. You can also use the MATLAB function `length(sig3a)` or `size(sig3a)`.

On this plot of the Fourier transform of `sig3a`, use the zoom feature to identify the horizontal location and height of the peak of each pulse on the left half of the display. Record the height of each pulse as well as the center frequency and width in $$\text{Hz}$$ of each pulse.

#### 6(a)
Print the plot window with a zoomed in view of one of the pulses. Label it with the signal name.

#### 6(b)
How would you characterize the shape of the pulses?

#### 6(c)
Can you tell which buttons generated this signal just by looking at this result? Why or why not?


### 7. 
Repeat __Step 6__ completely for three other signals defined below. Compare the pulse shapes of these results to the result in __Step 6__. How does using a shorter signal vector for `sig3d` affect the width of the pulse?

#### 7(a) 
`sig3b` with `n1=4801` and `n2=8800`.

#### 7(b) 
`sig3c` with `n1=2401` and `n2=6400`

#### 7(c) 
`sig3d` with `n1=1901` and `n2=2100`


Submit the answers to the questions, the plot of `testSig3` with the four time segments marked, and the four plots from __steps 4 to 7__.


## LAB:

### STEP 1: 
Write a MATLAB script `m`-file to analyze a signal in sequences of short segments with 50% overlap.

Assume that you have a test signal `sig` (we will use `testSig3` from laboratory 3 for the initial tests) and that `N=length(sig)` is the number of samples in the signal.

#### 1(a)
Draw a flowchart for the following and then write and test the MATLAB instructions to implement it.
- A variable __`seg_width`__ will be the number of samples in a signal segment that is the input to the `fft`. We will start with 100 and also consider 200 and 400.
- A variable __`seg_step = 0.5`__ seg_width will indicate the distance to the start of the next segment.
- The variable __`seg_width`__ is the length of the segment that is analyzed by `fft`. So it also controls the relationship between the index of the `fft` result and the actual frequency value. As a function of __`seg_width`__, __compute the index of the `fft` result that is closest to the peak of each row and column tone__. (And remember that MATLAB starts its indexing with 1, not 0.)
- Compute __`n_seg`__, the total number of complete segments of length __`seg_width`__ that will be analyzed with 50% overlap.
- Initialize 6 arrays of length `n_seg` to 0. These arrays will contain the following information for each segment:
	- The time of the center of each segment
	- The average of the magnitude of the results of fft for a segment. (See MATLAB function `mean`.)
	- The magnitudes of the `fft` results at the frequencies for tones for `row1`, `row2`, `column1`, and `column2`.
- Initialize a segment start value, __`nstart`__, to 1 and make a loop to do the following for each segment:
	- Get a signal segment __`sig(nstart : nstart+seg_width-1)`__ and get the magnitude of its `fft`
	- Add `seg_step` to nstart.
	- Put the data values into the 6 arrays.

#### 1(b)
- Test your `m`-file for `seg_width = 100`. (You can use an input statement to prompt you to enter the value of `seg_width` each time you run the script.)

#### 1(c)
- When the instructions are debugged, plot the results of your five data arrays as a function of the center times. Compare that to a plot of the whole signal.

##### Q1c(i)
Does the average value clearly show the difference between when a button signal is present and when there is a quiet period?

##### Q1c(ii)
Do the row 2 and column 2 magnitude plots accurately show when these tones are
present?

##### Q1c(iii)
What rule would you use to decide which button had been pressed at each time
during the signal?

##### Q1c(iv)
Is there a chance for confusions or wrong detections?


#### 1(d)
Print a plot of your results


### Step 2: 
Explore the effect of changing the segment length.

In some cases the results computed in step 1 might have a problem __because the exact frequency associated with the index you are observing is not the desired tone frequency__.

#### 2(a)
Compute the actual frequencies represented by the four frequency indices you selected in __Step 1__ and compare them to the desired tone frequencies. Which is closest? Which has the most difference?

#### 2(b)
Compare the results of Step 1 to results obtained when the segment length is increased to 200 and then 400. For each length, compute the actual frequencies represented by the four frequency indices you selected and compare them to the desired tone frequencies.

#### 2(c)
Print a plot of your results for lengths of 200 and 400.


### STEP 3: 
Explore the effect of just computing more values of the Fourier transform.

The default number of points to be computed by the fft function is the same as the number of points in the discrete time signal being transformed. So if `seg = sig(nstart : nstart+seg_width-1)`, then `SS = fft(sig)` returns the Fourier transform in `SS` which also has a length of seg_width. However, you can ask the `fft` for more points to be computed in frequency so you can get closer to the actual tone frequencies of interest. To get twice as many use `SS = fft(sig, 2*segwidth)`.

- Set `seg_width` back to 100 and compute `fft` results for 200 and 400 points. Remember to recompute the indices for the DTMF frequencies.
- Print a plot of your results for 200 and 400 frequency points.
- Compare these results with the original results for `seg_width = 100`.
- Compare these results with the original results for `seg_width = 200` and `400`.
- Pick a value for seg_width that you think is the smallest value that will work well and pick a value for the number of frequency points computed by `fft` that improves results. Make a button 5 detector by multiplying the row 2 signal and the col 2 signal. (Use `.*` to multiply two vectors point by point.) How well does this work?
- Using the same values, repeat for `testSig1` and `testSig2` from Laboratory 3.

### STEP 4: 
Extra: How well does your detector work on an unknown signal?

Each lab team will be given an unknown dial sequence signal that may have different length tones and varying amounts of added noise. You might want to try your detector on variations of your test signal with added noise to see the effect. All systems must be designed to function with some allowance for random variations in the signals. Using the method from the previous laboratory, create
```matlab
testSig3n = testSig3 + a*randn(1, length(testSig3));
```

Choose values of `a` and explore the effect of the number of data points and the number of computed points on detection from the noisy signal.

Then run your detector on the unknown signal and report the results to your lab assistant. In your report, describe how well your detector worked, and, if it failed in some cases, suggest improvements in your detector that would yield better results.


## REPORT:
Submit the answers to the questions and the plots requested in the laboratory procedure. In addition, consider how the results would be different if we had used the energy at each frequency point instead of the magnitude. For example, if `S = fft(s);` `SA = abs(S);` and `SAE = SA.*SA`, how would results using `SAE` be different from results us `SA`?