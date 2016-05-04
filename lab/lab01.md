# lab01
Discrete Time Signals with MATLAB

## OBJECTIVES:
- Learn and/or review the basic usage of MATLAB as a tool for computation and visualization.
- Use MATLAB to create sampled signals.
- Learn the units for and relationships between sampling intervals, sampling frequency, number of samples observed, total time observed, signal frequency and normalized frequency.


## BACKGROUND NOTES:
__Sampled Signals__: A mathematically defined continuous signal is a signal that exists for every possible value of t. It has infinite resolution as there is no value of $$t$$ for which the signal is not defined. A function defining a continuous signal uses “$$(t)$$” to denote the argument of continuous time, for example, $$x(t)$$.

A continuous signal can be "sampled" by simply evaluating it at integer multiples of a *sampling interval (or sampling period)*, $$T$$. The corresponding *sampling frequency* is $$F_T=\tfrac{1}{T}$$.

If $$T$$ is the sampling interval in seconds per sample, then $$F_T$$   is the sampling frequency in $$\text{Hertz}$$ (*i.e.* samples per second).

- An analog sinusoidal signal with frequency $$f_0$$ in $$\text{Hertz}$$ (*i.e.* cycles per second) is defined by
$$
x_a(t)=A\cos{(2\pi{f}_0t+\varphi)}
$$
where $$A$$ represents amplitude and $$\varphi$$ represents phase.
- The discrete time signal representaion for a sampling interval $$T$$ is given by
$$
x[n]=A\cos{(2\pi{f}_0(nT)+\varphi)}=A\cos{(2\pi\nu{n}+\varphi)}
$$
where $$\nu=\tfrac{f_0}{F_T}=f_0T$$ cycles per sample.

For sinusoidal signals, we will often use the normalized frequency, $$\nu$$. If the actual frequency of the sinusoid to be sampled is $$f_0$$ cycles per second, the *normalized frequency,* $$\nu$$, is the ratio of the actual frequency to the sampling frequency, $$\nu=\tfrac{f_0}{F_T}$$. Unit analysis shows that the units of the normalized frequency are:
$$
\frac{\text{cycles per second}}{\text{samples per second}}=\text{cycles per sample}
$$

The value of the normalized frequency, $$\nu$$ , should be between $$-0.5$$ and $$0.5$$ for accurate representation of the continuous sinusoidal signal by the discrete time sampled signal.


## MATLAB
There are several ways to generate MATLAB instructions.
- __MATLAB can be used interactively, like a calculator__. Type statements in response to the >> prompt and see the result of the statement immediately after it is typed. The arrow keys allow previous statements to be executed again or edited. This can be tedious if many statements need to be repeated. MATLAB allows for a number of autocomplete options, arrowing up after typing part of a command, etc. Experiment and use it often to increase familiarity.
- __MATLAB can be used like a programming language__.
	- MATLAB scripts (generally called an m-file as it ends with the “`.m`” file extension) contains a list of statements. The `m`-file is executed by simply typing the file name in response to the prompt in the interactive mode. This has the same effect as typing all the individual m-file statements in the interactive mode. Used in this way, the `m`-file script is not a function as no parameters are passed and no outputs are returned. The statements in the `m`-file have access to variables in the workspace that were defined before the [m[-file is used (thus, if you expect to have variables reset with each running of a script, you should include a “clear” statement). After the `m`-file instructions are complete, the interactive instructions that follow it in the command window or other `m`-files have access to all data created by the `m`-file instructions.
	- MATLAB functions can also be created and saved with the `.m` extension. When used as a function, it is self contained, it only knows about variables that were passed directly to it and only passes back output variables for the rest of the environment to use. You can experiment with writing MATLAB functions as you see fit, but we will not be focusing on them in this lab.


## LABORATORY:

### Part 1 - Interactive creation of vectors and plots
A discrete time signal in MATLAB is represented as an array or vector. Many operations are available for point by point operations on a vector, so that explicit "for loops" are rarely needed.

Start MATLAB on your workstation. Create a directory for this class, and move to it for all lab work. In the “Command Window” type the statements listed in the left column of the table below and observe the responses. Then answer the associated questions. Note that semicolons are not placed at the end of these statements, so the result of each statement will be displayed in the command window. This is sometimes useful for short vectors, but should be avoided for larger data vectors.

#### QUESTION#1:
How long is the vector `test1`? (Look in the workspace window or type "whos" in response to the >> prompt.

Is element 4 of vector test1 equal to 4? Why or why not?

```matlab
test1=0:8
test1(4)
```

----

#### QUESTION#2:
Explain each of the vectors created with these four statements.

How is `expv1` different from `expv2`?

> It is generally easier to view the structure of a signal by viewing its plot rather than reading a sequence of numbers.

```matlab
powv = 2 .^ test1;
cosv = cos(2 * pi * (1/8) * test1)
expv1 = exp(2 * pi * (1/8) * test1)
expv2 = exp(2 * pi * j*(1/8) * test1)
```

----

#### QUESTION#3
What does this plot show?

What is the horizontal axis?

```matlab
plot(expv1)
```

----

#### QUESTION#4
How is this plot different from the previous plot?

```matlab
plot(test1, expv1)
```

----

#### QUESETION #5
Describe this plot and differences from the previous ones.

```matlab
stem(test1, expv1)
```

----
#### QUESTION#6
What does this plot show?

Explain it in terms of the values displayed when it was created.

```matlab
plot(expv2)
```


----
#### QUESTION#7
How is this plot different from the previous one?

```matlab
plot( test1, real(expv2), test1, imag(expv2) )
```

----
### Part 2 - Interactive creation of vectors and plots Interactive Mode statements:

#### Interactive Mode Statements:
__(1)__: Type these statements and observe the plots in the Figure window. (*Note* the __semicolons__ at the end of each statement.) Type "help plot" to find more information about plotting. Both plots are plotting the same set of sampled values with linear interpolation between the samples. Verify that the titles and scaling of each plot are correct.
```matlab
N1 = 2000;
freq1 = 0.02;		% in units of cycles per sample phase=0.0;
%
svec1 = 0:N1;
sig1 = cos(2*pi*freq1*svec1+phase);
whos
%
subplot(2,1,1)
plot(svec1,sig1)
xlabel('sample number')
title([ 'cosine at normalized frequency = ' num2str(freq1)...
' cycles/sample'])
%
% The ... allows a statement to be continued on the next line
%
subplot(2,1,2)
Ts = .005; 			% sample interval
plot(svec1*Ts, sig1)
xlabel('time in seconds')
title([ 'Cosine at frequency = ' num2str(freq1/Ts) ...
' Hz with Ts = ' num2str(1000*Ts) ' ms'])
```

#### Using `m`-file scripts:
__(2)__: The interactive statements above will be put into two `m`-files so they can be used many times without retyping them all. The “Input” statement will allow you to change the value of parameters. Using the MATLAB editor, create and save the following text as an `m`-file named `getCosSig.m`. This `m`-file is not a function.
```matlab
N1 = input('Enter number of samples: ');
freq1 = input('Enter normalized frequency in cycles/sample: ');
phase=0.0;
svec1 = 0:(N1-1);
sig1 = cos(  2 * pi * freq1 * svec1 + phase  );
```

__(3)__:  Using the MATLAB editor, create and save the following text as an `m`-file named `plotCosSig.m`.
```matlab
subplot(2, 1, 1)
plot(svec1, sig1)
xlabel('sample number')
title([ 'cosine at normalized frequency = ' num2str(freq1) ' cycles/sample'])
%
subplot(2,1,2)
Ts = input('Enter sample time interval in seconds: ') plot(svec1*Ts, sig1)
xlabel('time in seconds')
title([ 'Cosine at frequency = ' num2str(freq1/Ts) ...
' Hz with Ts = ' num2str(1000*Ts) ' ms'])
```

__(4)__: Use the two `m`files to do the following.
- Reproduce the plots from part 2, step 1 above. How many statements do you need to type in the interactive mode? If you get error messages on the screen from either `m`-file, edit the `m`-file to correct the error and then run it again.
- After you have successfully reproduced the results from step 1, use the two `m`-files to make plots of the signals specified below. In each case answer the following questions:
	- What is the sampling interval?
	- What is the sampling frequency?
	- How many samples are there per cycle of the input signal?
	- What is the time duration of one cycle on your plot?
	- What parameters values should be used for `getCosSig` and `plotCosSig`?
- For `N1 = 1000`, find the correct parameters to plot $$10\:\text{sec}$$ of a $$2.5\:\text{Hz}$$ signal.
- For $$T_S=0.002$$, find the correct parameters to plot $$5\:\text{sec}$$ of a $$1.2\:\text{Hz}$$ signal.
- For $$\nu=0.1$$, find the correct parameters to plot $$0.4\:\text{sec}$$ of a $$5\:\text{Hz}$$ signal.
- For `N1 = 20`, find the correct parameters to plot $$0.4\:\text{sec}$$ of a $$55\:\text{Hz}$$ signal. Does this plot match its labels? Why or why not?


----
### Part 3 - Sound Output
- Using `getCosSig`, create `sig1` with `N1 = 8000` and $$\nu=0.075$$.
- Type `help sound` to learn how to make sound output.
- Listen to the output sound using `sound(sig1, 8000)`. Estimate the duration of the tone and a relative frequency. Is this consistent with $$F_T=8000\:\text{Hz}$$?
- Listen to the output sound using `sound(sig1, 4000)`. Compare the duration and frequency to the previous sound output. Is this consistent with $$F_T=4000\:\text{Hz}$$? Explain.
- Listen to the output sound using `sound(sig1, 12000)`. Compare the duration and frequency to the previous sound output. Is this consistent with $$F_T=12000\:\text{Hz}$$? Explain.
- What is the relationship of ν to the actual frequency of the tone you hear? How can the same sequence of data points make different frequency sounds?
- Listen to the output sound using `sound(0.5*sig1, 8000)`. Compare it to the first sound output you created. What is different? Why?
- Listen to the output sound using `sound(5.0*sig1, 8000)`. Compare it to the first sound output you created. What is different? Why? (You may want to reread the information about the sound function by typing “`help sound`”.)


## Laboratory Report:
For your laboratory report submit:
- the answers to all questions in the laboratory procedure
- the plots from Parts 2 and 3
- the `m`-files from Parts 2 and 3

