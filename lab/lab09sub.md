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


## LAB:

### PART 1: 
Set up the equipment as you did in the previous laboratory.

- Turn on the signal generator and the oscilloscope so they can warm up. 
- Connect the board to the computer using the built-in USB connector. 
- Set up the signal generator to produce a 500 Hz sinusoidal signal with amplitude of 0.5 V peak to peak. Using a BNC T connector, connect the output of the signal generator to an oscilloscope input and to the board input. Display the signal on the scope and verify the amplitude and frequency. Set this channel up to be the sync trigger for the scope.
- Connect the output from the board to a second scope input.

![setup](lab09sub/setup.jpg)


### PART 2: 
Modify a project with Code Composer to output sinusoidal signals at selected frequencies.

- Open the project "ELEN133_Lab9_SineTableInt.2." Change the length of the table from 10 to 32.
- Set up your code to cycle through, for approximately two seconds each, the four increments.
	- in `main.c`, set up likewise.
	```c
	#define TABLE_SIZE	32			// size of sine table
	#define GAIN		10000	 	// gain of sine table
	#define TIME_INT	2			// time interval per increment
	#define INC_MAX	4				// maximum increment value
	```
- __Compute the frequency you expect for your output signal for each of the 4 increment values.__
	- It is __246__, __493__, __740__, and __990__.


### Part 3: 
Test your program and explore modifications.

- Run your program and listen to the four tones produced.
- Look at the output signal on the scope and check the frequency for each increment. 
	- __What is the signal amplitude? If you want to edit your code to stay on each frequency for longer, feel free to.__
		- [output waveform](https://youtu.be/tnZ4CzlkW-w?list=PLTuOKAhhBkumMJRQMwPLwMV-cfVC747v2). The amplitude of signal output is $$V_{pp}\approx0.6$$
		- [sound](https://youtu.be/Jrp7jH9wq0U?list=PLTuOKAhhBkumMJRQMwPLwMV-cfVC747v2)

- Modify your program to use the sinusoidal signal with sampled data input. Make it so that the program reads an input value and adds it to the current sinusoidal signal to produce each output value.
	- in `main.c`, modify
	```c
	read_right();
	write_right((Int16)(GAIN*sine_table[i]));
	```
	to 
	```c
	input = read_right();
	write_right(  (Int16)(GAIN*sine_table[i])+input  ); 	// output sample to codec
	```
	__NOTE__: make sure to initialize `input` as a datatype of `Int16` 
- Test this new modification by connecting the signal generator to the input and varying the frequency of the signal. When the frequency gets close to the sinusoidal signal you are generating, you should hear a characteristic “beat” at the difference of the two frequencies. Using this, you can check the calibration of the signal generator relative to your signal frequency. On the scope you should be able to see the envelope of the output signal varying very slowly when the signal generator frequency is close to your sinusoidal signal frequency.
	- see video.
		- [How it does to the sound](https://youtu.be/vXZkRNI2hzU?list=PLTuOKAhhBkumMJRQMwPLwMV-cfVC747v2).
		- [Waveform @ 246 Hz](https://youtu.be/1a2fIzcjwiE?list=PLTuOKAhhBkumMJRQMwPLwMV-cfVC747v2)
		- [Waveform @ 493 Hz](https://youtu.be/FzGU-2oEQYo?list=PLTuOKAhhBkumMJRQMwPLwMV-cfVC747v2)
		- [Waveform @ 739 Hz](https://youtu.be/iIH2_qktabg?list=PLTuOKAhhBkumMJRQMwPLwMV-cfVC747v2)
		- [Waveform @ 990 Hz](https://youtu.be/Kn9cArCVsA0?list=PLTuOKAhhBkumMJRQMwPLwMV-cfVC747v2)
- Adjust the program so it reads an input value at each loop and multiplies it by the current sinusoidal signal to produce the output value. Be sure that you normalize everything to prevent overflow.
	- __First, normalize gain value by 10__
	From
	```c 
	#define GAIN		10000		// gain of sine table
	```
	to 
	```c 
	#define GAIN		10			// gain of sine table
	```
	- And modify 
	```c
	read_right();	
	write_right((Int16)(GAIN*sine_table[i]));
	```
	to
	```c
	input = read_right();					
	write_right(  (Int16)(GAIN*(sine_table[i]))*input  ); 
	```
- Test this new mode by observing the output for each of the four frequencies generated by your program when the signal generator output is at $$1\:\text{kHz}$$. Describe the output on the scope and describe the sound.  What happens to the sound as you decrease the signal generator frequency from $$1\:\text{kHz}$$ to $$400\:\text{Hz}$$? Change the input to an audio input. 
	- __What does this do to voice and music?__
		- [sound](https://youtu.be/kDWyGMn5X8E?list=PLTuOKAhhBkumMJRQMwPLwMV-cfVC747v2)
		- [waveform](https://youtu.be/WD65IsJDd-A?list=PLTuOKAhhBkumMJRQMwPLwMV-cfVC747v2)


## PART 4: 
Explore the use a floating point index

- Open the project "ELEN133_Lab9_SineTableFloat". Note that you will need to write a function to compute the frequency step as a floating point value with the inputs being the desired frequency, the sampling rate, and the sine table size.
	- write a function called `get_inc`:
	```c
	float get_inc(float note, Uint32 sf, Uint32 tsize)
	{
		return tsize * note / sf;
	}
	```
- Verify that the program works by listening to the output. You may use your own sequence of tones as long as there are at least 4 different tone frequencies. Look at “music.h” to see the different durations and notes that you can use. Use the file “diddly.h” to change the tones, durations, and BPM.
- Compare the performance for `N=1024` with the performance for `N=32`. For both lengths, compare the performance using a floating point value for the sine table step for each frequency vs using a rounded short value for the increment. For the rounded short value, simply round the increment value when it is generated.
- TEST COMPARISON with floating point values
	- `#define TABLE_SIZE	1024`: [see video](https://www.youtube.com/watch?v=ncNlPAg3UlE&list=PLTuOKAhhBkumMJRQMwPLwMV-cfVC747v2&index=11)
	- `#define TABLE_SIZE	32`: [see video](https://youtu.be/4tREaCY2wgw?list=PLTuOKAhhBkumMJRQMwPLwMV-cfVC747v2)
- TEST COMPARISON with rounded short values
	- `#define TABLE_SIZE	1024`: [see video](https://www.youtube.com/watch?v=8wnAyeqNsZw&list=PLTuOKAhhBkumMJRQMwPLwMV-cfVC747v2&index=13)
	- `#define TABLE_SIZE	32`: [see video](https://www.youtube.com/watch?v=L2OcyX5UAJA&list=PLTuOKAhhBkumMJRQMwPLwMV-cfVC747v2&index=12)


## PART 5:
Modify a program to implement echo generation

- Open the project ELEN133_Lab9_Echo.
- Verify the program to implement the echo using a circular queue with a delay of 0.25 seconds. Try three different values of b: 0.1, 0.5, or 0.9.
	- in `main.c`, change the value of macro GFB, *e.g.*
	from 
	```c
	#define GFB 		0.6
	```
	to
	```c
	#define GFB 		0.1
	```
- Test your program on audio input. Play around with different delays and feedback gains and note the effects on sound of the output.
- Modify your program to have three different echoes with fixed reflection values. You will need to add two more index values that are updated after each output is produced. You can select values for the delay and reflection strength of each echo.	
	- [see video](https://www.youtube.com/watch?v=szJNWoj9uFA&list=PLTuOKAhhBkumMJRQMwPLwMV-cfVC747v2&index=14)
- Modify your program to have three different echoes with fixed reflection values. You will need to add two more index values that are updated after each output is produced. You can select values for the delay and reflection strength of each echo. 
	- create new macros, *i.e.* change 
	from
	```c
	#define DELAY		2000	// delay size in samples
	#define GFB 		0.6		// feedback gain
	```
	to 
	```c
	#define DELAY1		2000
	#define GFB1 		0.3	
	#define DELAY2		1600
	#define GFB2 		0.3	
	#define DELAY3		800
	#define GFB3 		0.3
	 ```
	- create variables that store delayed output, *i.e.* change
	from 
	```c
	Uint32 ind_out = BUF_SIZE - DELAY;
	```
	to
	```c
	Uint32 ind_out1 = BUF_SIZE - DELAY1;
	Uint32 ind_out2 = BUF_SIZE - DELAY2;
	Uint32 ind_out3 = BUF_SIZE - DELAY3;
	```
	- in a while loop, change each output, *i.e.* change
	from
	```c
	if(++ind_out >= BUF_SIZE)		
		ind_out -= BUF_SIZE;
	```
	to
	```c
	if(++ind_out1 >= BUF_SIZE)		
		ind_out1 -= BUF_SIZE;
	if(++ind_out2 >= BUF_SIZE)		
		ind_out2 -= BUF_SIZE;
	if(++ind_out3 >= BUF_SIZE)		
		ind_out3 -= BUF_SIZE;
	```
	- Lastly, change
	from
	```c
	buf[ind_in] += (Int16)(GFB*buf[ind_out]);
	```
	to
	```c
	buf[ind_in] += (Int16)(GFB1*buf[ind_out1]);
	buf[ind_in] += (Int16)(GFB2*buf[ind_out2]);
	buf[ind_in] += (Int16)(GFB3*buf[ind_out3]);
	```
	- [see the result](https://www.youtube.com/watch?v=VZsW0SKw7NY&list=PLTuOKAhhBkumMJRQMwPLwMV-cfVC747v2&index=15)


## QUESTIONS:

### 1. 
Write the equation that expresses the sum of two cosines at different frequencies as the product of two sinusoidal signals at the sum and difference frequencies? When the two signals being added are very close to the same frequency, show how this explains the slow “beat’ sound you heard in the lab. This method is sometimes used to tune musical instruments.

### 2. 
Write the equation that expresses the product of two cosines at different frequencies as the sum of two sinusoidal signals at the sum and difference frequencies? How is this related to the double sideband modulation of the third output mode (Part 3, Number 5)?

### 3. 
How does changing the table size and increment type effect the performance of the sine generator? Is there an audible difference?



### 4. 
Discuss your observations from the echo filter section. Why do we not set the feedback gain greater than or equal to 1?


## APPENDIX:
- Youtube vidoes on experimental results: [https://www.youtube.com/playlist?list=PLTuOKAhhBkumMJRQMwPLwMV-cfVC747v2](https://www.youtube.com/playlist?list=PLTuOKAhhBkumMJRQMwPLwMV-cfVC747v2)
- 