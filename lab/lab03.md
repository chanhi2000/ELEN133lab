# lab03
Dual-Tone Multi-Frequency Old-style Telephone Dialing: Signal Generation

## OBJECTIVES:
In this lab, learning about the way old push-button telephones worked is used as a tool to gain familiarity with generating useful sequences, filtering for sequences and learn more about the importance of sampling frequencies.

## BACKGROUND NOTES:
A telephone keypad has 12 buttons for the digits 0-9, the * and the #. The signals indicating which numbers are dialed were designed to use the same telephone channels as voice signals, so the dialing signals were kept below 4 kHz in frequency. In this context, tones or combinations of tones are preferable to square wave coded signals which require higher bandwidth. __VOCAB: Bandwidth is a term that defines the width of the range of frequencies used for a particular application.__ One possibility would have been to assign a unique tone to each of the 12 buttons and then create 12 filters - each tuned to respond to one of the tones. However, the telephone system was instead designed to use two tones (at once) for each button. This design results in needing only 7 distinct tones instead of 12. A unique ‘high’ tone is assigned to each of the three keypad columns, and a unique ‘low’ tone is assigned to each of the four keypad rows. Thus, when a button is pressed, it generates a tone based on a high tone (corresponding to the column) and a low tone (corresponding to the row). This coding is called dual-tone-multiple-frequency or DTMF and the table below shows the buttons and the corresponding low and high frequency assignments for each row and column, respectively. (A fourth column tone is also defined with a column frequency of 1633Hz for a 16 button keypad, but it is not used on typical keypads.)

![]

Specifications:
- Frequency tolerance $$\pm1.5\%$$
- minimum pulse width: $$50\:\text{ms}$$
- minimum time between digits: $$45\:\text{ms}$$

This dual tone method has __several advantages__ over assigning individual tones to each button:
1. Only 7 tones are used instead of 12, so the frequencies can be spread out more within a fixed frequency band. Increasing the difference between frequencies means they can be identified using a shorter observation time interval.
2. Since a two tone combination must be present for a valid button signal, this approach is less likely to generate a false button signal due to other unrelated sounds. The tones are selected to avoid harmonic relationships between them.
3. Other telephone signals are also generated with two tones:
	- The dial tone has a low tone of $$350\:\text{Hz}$$ and a high tone of $$440\:\text{Hz}$$.
	- The busy signal has a low tone of $$480\:\text{Hz}$$ and a high tone of $$620\:\text{Hz}$$ with 60 interruptions per minute.
	- The ringing signal has a low tone of $$440\:\text{Hz}$$ and a high tone of $$480\:\text{Hz}$$. It is on for 2 seconds then off for 4 seconds.

## PRELAB
1. Read and understand the Background Notes section above.
2. Press the buttons on your telephone (most smartphones will still generate the tones as you push
the buttons) in increasing order and listen to the tones generated. Listen to the single tones associated with each row or column by pressing all the buttons in the row or column. Do you hear the tones increasing as you go down the rows and then again as you move right across the columns?
3. For each of the seven frequencies used for DTMF dialing signals, compute the following
	- The number of samples per cycle if the sampling rate is $$8000\:\text{Hz}$$
	- The number of cycles in the minimum $$50\:\text{ms}$$ interval.
4. Review the signal generating `m`-files you used in previous laboratories. Draw a flow chart for a function that will create a signal vector for a telephone dialing signal. The function will have four inputs and one output as defined below. (You will write and test your function in the lab.)
```matlab
function dial_sig = my_dtmf(tone_time, quiet_time, fs, dial_vals)
% INPUTS:
% tone_time is the tone duration in seconds
% quiet_time is quiet time duration between tones in seconds fs is the sampling frequency in Hz
% dial_vals is a vector of integers from 1 to 12 representing the
% button numbers of the sequence of numbers to be dialed Note that the dialed "0" is button number 11!!!!!!
%
% OUTPUT:
% dial_sig is the vector of sampled values of the DTMF output signal for the number sequence
```
5. Determine the output vector created by the following MATLAB instructions where concatenation is used to build up a vector by computing components and appending them.
```matlab
out_vec = [ ];
for k = 1:4
	out_vec = [out_vec k*ones(1,5) ];
end
out_vec
```
6. Determine the length in samples of the vector created by the following MATLAB instruction using your function. Determine the time duration of the sound created. (__NOTE__: You will create the function in the lab period, but you can answer this question based on the function description.)
```matlab
sample_freq = 8000;
dt = 0.2;
qt = 0.1;
dial_scu = [ 1 4 11 8 5 5 4 4 11 11 11 ] ; % note that dialed 0 is button 11
sig_1 = my_dtmf( dt, qt, sample_freq, dial_scu);
sound( sig_1, sample_freq);
```


## LAB

### STEP 1: 
Create and debug a function to generate a DTMF signal as described in the preLab

#### 1(a) 
Write your m-file to implement the function `my_dtmf`. Save it in a file called `my_drmf.m` in your MATLAB working directory. Save it in your MATLAB current folder.

__implementation notes__:
1. It is not necessary to specify the length of dial_vals in the function inputs. The function can compute the length using: `num=length(dial_vals);`
2. The output vector can be computed for each button value and concatenated to form the output signal:
``matlab
dial_sig = [ ]; % initializes the output to an empty vector
dial_sig = [ dial_sig new_sig quiet_sig];
```
concatenates the vector `new_sig`, computed for a single button, and `quiet_sig`, a vector of zeros for the quiet interval, with the current value of `dial_sig`.
3. The vector `new_sig` can be computed for each button value using the cosine function as in previous laboratories. Be sure the total amplitude is $$<1$$.
4. The `dial_vals` vector can use 11 to represent 0 because it is “button 11” or 0 can be detected and handled differently from the other numeric vales.
5. Although dial_vals in the example given in the prelab is a vector of numeric values corresponding to button numbers, you can choose to have the input be a character string using 0, *, and # as shown on the keypad. In MATLAB the function abs converts a text string to a numeric vector of ASCII code values. You can also design your function to ignore spaces, -, (, and ) for a more user friendly input.
6. The vector quiet_sig can be computed once using
```matlab
quiet_sig = zeros( 1, fs*quiet_time);
```
7. The comments immediately following the first line function declaration in your `m`-file will be printed whenever you type “help my_dtmf” at the MATLAB “>>” prompt.
8. You may want to include error checking of the input parameters. What will happen if the requested intervals are too short or if an invalid value appears in `dial_vals`?

> __NOTE__: Type "`help my_dtmf`” to read your comments describing how the function works.

#### 1(b)
- Call your function with a sampling frequency of $$8000$$, a tone time of $$0.5\:\text{sec}$$, a quiet time of $$0.1\:text{sec}$$, and a dial value vector with a single number. Debug the m-file until there are no errors.
- When the function runs without detected errors:
	- Use sound to listen to your signal. Does it sound right? Compare it to a telephone when the same button is pressed. Be sure that you divided the output signal by the maximum value so that the output values will be between $$-1$$ and $$+1$$. Otherwise the nonlinear clipping will create additional frequencies in the sound.
	- Use the plot instruction to plot your signal. Describe the display of the complete signal.
	- Use the zoom feature of the figure display to show regions that are about 200 samples wide. (Or use axis to do this.) Describe the zoomed-in display. (An example for comparison is shown below.) Does it look like the sum of two sinusoids that have no harmonic relationship? If one were a harmonic of the other, how would the display be different?
- Repeat your test with a dial value vector containing two different numbers.
- Demonstrate this to your laboratory assistant.

#### 1(c)
Example of a signal created with `my_dtmf`:

![fig02](lab03/lab03-fig02.png)

A signal for three dialed numbers is plotted vs time in the top plot. The next two plots show zoomed in regions for the dialed number 3 and the dialed number 7. Note the values on the time axis.

### STEP 2:
Create an `m`-file to test and explore the DTMF signal generated by your function.

#### 2(a)
Create a script `m`-file named `Lab3_Tests1` to make some test signals with your function. For all signals, use a sampling frequency of `$$8000\:\text{Hz}$$. These signals will be used in Laboratory 4 with filters that will detect the dialed sequence.
- Make signal my_phone with a tone time of 0.5 seconds, a quiet time of 0.1 seconds and a dial value vector set to a phone number you use.
- Make sig5, for the '5' button using the same parameters
- Make the following four additional test signals:

| Signal name | `dial_vals` | Tone time (sec.) | Quiet time (sec.) |
| :---------- | :---------- | :--------------: | :---------------: |
| `testSig1` | `dial_vals = [3 5 7 11]` | 0.25 | 0.05 |
| `testSig2` | `dial_vals = [3 5 7 11]` | 0.10 | 0.02 |
| `testSig3` | `dial_vals = [3 5 7 11]` | 0.50 | 0.10 |
| `testSig4` | `dial_vals = 1:12` | 0.25 | 0.05 |

- Use sound to play each of these signals and compare the first three. Use the sound instruction in the command window and wait until the sound is finished before typing the next sound instruction. __Do not put a sequence of sound instructions in an `m`-file script__.

#### 2(b) 
What is the total duration of each of the six signals in samples? in time?

#### 2(c)
Demonstrate the sounds to your laboratory assistant.


### STEP 3:
Explore the effect of the sampling frequency.

#### 3(a)
Create a script m-file named `Lab3_Tests2` to make some additional test signals with your function. Except for the sampling frequency, use the same parameters used for `testSig1` above.
- Make `testSig1_16000` using a sampling frequency of 16000.
- Make `testSig1_4000` using a sampling frequency of 4000.
- Make `testSig1_2000` using a sampling frequency of 2000.

#### 3(b)
Use sound to listen to these three new signals and compare each to testSig1. In each case for the sound instruction use the sampling frequency that was used to create the signal.
- Is the time duration of each signal the same?
- Do all the signals sound the same? Explain any differences you hear.
- What is the length of each signal in samples?

#### 3(c)
Demonstrate the sounds to your laboratory assistant.

## LAB REPORT:
Submit 
- a listing of your three m-files, 
- the function file and the two test file scripts, and 
- the answers


