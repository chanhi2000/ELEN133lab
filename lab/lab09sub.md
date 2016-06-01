# lab09sub
Generating Periodic Signals and Modulation with Sinusoidal Signals

## OBJECTIVES:
- generate a sinusoidal signal output and then implement simple modulation with a cosine wave.
	- For a single frequency input, this creates two different output frequencies which are the sum and difference frequencies.
	- For a general audio signal it creates an output that is the sum of the input shifted up and the input shifted down by the cosine frequency.

## PRELAB
Frequency control from table look-up:

### TEST 1:
To simulate real-time operation, you will create an array, which holds a complete output sequence, and then you will listen to it in MATLAB with sound. Write and test a program that will do the following;

-Let `N` be a variable that controls the length of a single cycle of a sampled sine so that `sn=sin( (0:N-1)*2*pi/N)`. In a real-time program, this could be computed in the initialization part of the program. Start with `N=128`.
- Let `FT=8000` be the sampling frequency.
- Let `tone_d=0.5` be the tone duration in seconds. The number of output samples will then be `M=(tone_d*FT)`.
- Let frequency=`440` be the desired output frequency. Compute `f_step`, the __floating point value__ of the increment to the index that would advance through the sine table at the correct rate to make this desired frequency output. Show this computation in your preLab report.
- Initialize the floating point sine index and the time index to 1
- Generate `M` output samples by doing the following;
	- Compute an integer index by rounding the sine index and accessing that value in the sine table. Save it as the next element in the output array.
	- Increment the time index. If it exceeds `M`, stop generating output samples. Otherwise add `f_step` to the floating point sine index.
	- If sine index > N + 0.5, subtract `N` from sine index.
	- Continue.
- When the outputs have been generated, plot the output waveform and use sound to listen to the result. If it does not look line a sinusoidal signal or sound like the correct frequency, debug the code and try again.
- When you have the `m`-file working, compare the result for `N=128` with the result for `N=16`.
- Submit your m-file listing with your Prelab.

### TEST 2:
- Let tone_list be a list of frequencies for tones that will be generated for `tone_d` seconds as was done in Test 1.
- Initialize an array of length = (M*number_of_tones) to zero.
- Compute the floating point value of the increment through the sine table for each frequency as you did in Test 1.
- Initialize the sine index, the time index, and the tone index to 1
- Compute values as follows:
	- Get f_step for the current tone
	- Generate M output samples for this tone as was done in Test1.
	- When the time index exceeds its limit, reset it to 1 and increment the tone index.
	- If the tone index is longer than the list, stop. Otherwise go back to the first step and get a new `f_step` value.
- For the initial test use `tone_list=[440 220]` with `N=256`. Listen to the output and debug until you hear two different tones for half a second each.
- When that works, create a tone list from the table below for `[ C D E F g a b c]`. Compare the results for `N=256` and `N=2048`. Submit an `m`-file listing and a list of the step values for each frequency at `N=256` and `N=2048`.
- Test with a tone list of `[d e c C G]`.

| Note | Frequency |
| :--: | :-------: |
| A | 220.00 |
| | 233.08 |
| B | 246.94 |
| C | 261.63 |
| | 277.18 |
| D | 293.66 |
| | 311.13 |
| E | 329.63 |
| F | 349.23 |
| | 369.99 |
| G | 392.00 |
| | 415.30 |
| a | 440.00 |
| | 466.16 |
| b | 493.88 |
| c | 523.25 |
| | 554.37 |
| d | 587.33 |
| | 622.25 |
| e | 659.26 |
| f | 698.46 |
| | 739.99 |
| g | 783.99 |
| | 830.61 |
| aa | 880.00 |


## QUESTIONS:
### 1.
What are the benefits of increasing the length of the sine table? What are the drawbacks?

### 2.
Here we used a floating point value for f_step and then used a rounded value of the sine index for the table index. Compare that to simply using a rounded value of `f_step` and always doing an integer update to sine index. Again, what would be the benefits and drawbacks?

### 3.
Could this method be used with waveshapes other than a sinusoidal waveshape? Explain.

__Submit the answers to the questions and requested m-file listings and tables of step values.__
