%% LAB04: Detecting DTMF Tones with FIR FIlters
% 
% *Name*: Chan Hee Lee
% 
% *Student ID*: W0721296
%
%% OBJECTIVES:
%
% 1) use MATLAB to help us specify the most appropriate filter
% length and filter parameters to distinguish the button frequencies
% 
% 2) test the selected filter using test signals similar to those 
% generated in Laboratory 3.
%
%% intialize
clear, clc, clf, cla, close all;
%
%% STEP 1
%
% ----- initialize: create signals -----
%
fs = 8000;

dial_vals1 = [5 8 11 7 8 9];
t_tone1 = 0.25;
t_quiet1 = 0.05;
testA = my_dtmf(t_tone1, t_quiet1, fs, dial_vals1);

t_tone2 = 0.10;
t_quiet2 = 0.02;
testB = my_dtmf(t_tone2, t_quiet2, fs, dial_vals1);

t_tone3 = 0.50;
t_quiet3 = 0.10;
testC = my_dtmf(t_tone3, t_quiet3, fs, dial_vals1);

dial_vals2 = 1:12;
testD = my_dtmf(t_tone1, t_quiet1, fs, dial_vals2);
%
% ---- define the following: -----
%
% (1) sample size
% (2) time duration
% (3) time vector.

Ns1=length(testA);
t1=Ns1/fs;
tv1=(0:Ns1-1)/fs;

Ns2=length(testB);
t2=Ns2/fs;
tv2=(0:Ns2-1)/fs;

Ns3=length(testC);
t3=Ns3/fs;
tv3=(0:Ns3-1)/fs;

Ns4=length(testD);
t4=Ns4/fs;
tv4=(0:Ns4-1)/fs;
%% STEP 3
%
% ----- create the filter: -----
%
%% 3(a)
%
% ----- EXERCISE 1: N1=N1/4 -----
%
fs = 8000;
fc1 = 852;
fc2 = 770;

w = 10;
Wn1 = [fc1-w, fc1+w]/(fs/2);
Wn2 = [fc2-w, fc2+w]/(fs/2);

N1a = 200;
N1b = N1a / 4;

b852a = fir1(  N1a, Wn1, rectwin(N1a+1)  );
b770a = fir1(  N1a, Wn2, rectwin(N1a+1)  );

b852b = fir1(  N1b, Wn1, rectwin(N1b+1)  );
b770b = fir1(  N1b, Wn2, rectwin(N1b+1)  );
%
% ----- create a frequency response of the filter -----
%
% N2 = 1024;
% [H852, fv] = freqz(  b852, 1, N2, fs, 'whole'  );
% [H770, fv] = freqz(  b770, 1, N1, fs, 'whole'  );

title1a='your input signal: testC with N1 = ';
title1b='your input signal: testB with N1 = ';
title2='your filtered output signal @ 852 Hz';
title3='your filtered output signal @ 770 Hz';
%
% ----- filtered output for testC signal -----
%
% (1) using convolution 
%
% y852 = conv(testC, b852);
% y770 = conv(testC, b770);
%
% (2) using filter function
%
y852c1 = filter(b852a, 1, testC);
y770c1 = filter(b770a, 1, testC);
y852b1 = filter(b852a, 1, testB);
y770b1 = filter(b770a, 1, testB);

y852c2 = filter(b852b, 1, testC);
y770c2 = filter(b770b, 1, testC);
y852b2 = filter(b852b, 1, testB);
y770b2 = filter(b770b, 1, testB);
%
% ----- plot input and output signals (step 2 vs step 3) ----- 
%
figure();
subplot(3,2,1)
plot(tv3, testC);
title(  horzcat(title1a, num2str(N1a))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,3)
plot(tv3, y852c1);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,5);
plot(tv3, y770c1);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,2)
plot(tv3, testC);
title(  horzcat(title1a, num2str(N1b))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,4)
plot(tv3, y852c2);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,6);
plot(tv3, y770c2);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');
%
% ---- filtered output for testB signal -----
%
% (1) using convolution 
%
% y852 = conv(testC, b852);
% y770 = conv(testC, b770);
%
% (2) using filter function
%
y852b = filter(b852a, 1, testB);
y770b = filter(b770a, 1, testB);
%
% ----- plot input and output signals ----- 
%
figure();
subplot(3,2,1)
plot(tv2, testB);
title(  horzcat(title1b, num2str(N1a))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,3)
plot(tv2, y852b1);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,5);
plot(tv2, y770b1);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,2)
plot(tv2, testB);
title(  horzcat(title1b, num2str(N1b))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,4)
plot(tv2, y852b2);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,6);
plot(tv2, y770b2);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');

%% 3(b)
%
% ----- EXERCISE 2: N1=N1*2 -----
%
N1a = 200;
N1c = N1a * 2;

b852a = fir1(  N1a, Wn1, rectwin(N1a+1)  );
b770a = fir1(  N1a, Wn2, rectwin(N1a+1)  );

b852c = fir1(  N1c, Wn1, rectwin(N1c+1)  );
b770c = fir1(  N1c, Wn2, rectwin(N1c+1)  );

title1a='your input signal: testC with N1 = ';
title1b='your input signal: testB with N1 = ';
title2='your filtered output signal @ 852 Hz';
title3='your filtered output signal @ 770 Hz';
%
% ---- filtered output for testC signal -----
%
% (1) using convolution 
%
% y852c1 = conv(testC, b852a);
% y770c1 = conv(testC, b770a);
% y852c1 = conv(testB, b852a);
% y770c1 = conv(testB, b770a);
%
% y852c3 = conv(testC, b852c);
% y770c3 = conv(testC, b770c);
% y852c3 = conv(testB, b852c);
% y770c3 = conv(testB, b770c);

%
% (2) using filter function
%
y852c1 = filter(b852a, 1, testC);
y770c1 = filter(b770a, 1, testC);
y852b1 = filter(b852a, 1, testB);
y770b1 = filter(b770a, 1, testB);

y852c3 = filter(b852c, 1, testC);
y770c3 = filter(b770c, 1, testC);
y852b3 = filter(b852c, 1, testB);
y770b3 = filter(b770c, 1, testB);
%
% ----- plot input and output signals (1) ----- 
%
figure();
subplot(3,2,1)
plot(tv3, testC);
title(  horzcat(title1a, num2str(N1a))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,3)
plot(tv3, y852c1);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,5);
plot(tv3, y770c1);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,2)
plot(tv3, testC);
title(  horzcat(title1a, num2str(N1c))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,4)
plot(tv3, y852c3);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,6);
plot(tv3, y770c3);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');

%
% ----- plot input and output signals (2) ----- 
%
figure();
subplot(3,2,1)
plot(tv2, testB);
title(  horzcat(title1b, num2str(N1a))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,3)
plot(tv2, y852b);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,5);
plot(tv2, y770b);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,2)
plot(tv2, testB);
title(  horzcat(title1b, num2str(N1c))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,4)
plot(tv2, y852b3);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,6);
plot(tv2, y770b3);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');

%% 3(c) i: setup
%
% ----- EXERCISE 3: N1 of your pick -----
%
fs = 8000;
fc1 = 852;
fc2 = 770;

w = 10;
Wn1 = [fc1-w, fc1+w]/(fs/2);
Wn2 = [fc2-w, fc2+w]/(fs/2);

N1 = 100;
b852 = fir1(  N1, Wn1, rectwin(N1+1)  );
b770 = fir1(  N1, Wn2, rectwin(N1+1)  );

title1a='your input signal: testC with N1 = ';
title1b='your input signal: testB with N1 = ';
title2='your filtered output signal @ 852 Hz';
title3='your filtered output signal @ 770 Hz';
%
% ---- filtered output for testC signal -----
%
% (1) using convolution 
%
% y852 = conv(testC, b852);
% y770 = conv(testC, b770);
% y852 = conv(testC, b852);
% y770 = conv(testC, b770);

%
% (2) using filter function
%
y852c = filter(b852, 1, testC);
y770c = filter(b770, 1, testC);
y852b = filter(b852, 1, testB);
y770b = filter(b770, 1, testB);

%% 3(b) ii: plot comparison (1)
% ------------------------------------ %
% ----- 1. N1 = 100 vs. N1a = 200 ---- %
% ------------------------------------ %
%
% ----- plot input and output signals (N1a for testC)----- 
%
figure();
subplot(3,2,1)
plot(tv3, testC);
title(  horzcat(title1a, num2str(N1))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,3)
plot(tv3, y852c);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,5);
plot(tv3, y770c);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,2)
plot(tv3, testC);
title(  horzcat(title1a, num2str(N1a))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,4)
plot(tv3, y852c1);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,6);
plot(tv3, y770c1);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');
%
% ----- plot input and output signals (N1a for testB) ----- 
%
figure();
subplot(3,2,1)
plot(tv2, testB);
title(  horzcat(title1b, num2str(N1))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,3)
plot(tv2, y852b);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,5);
plot(tv2, y770b);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,2)
plot(tv2, testB);
title(  horzcat(title1b, num2str(N1a))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,4)
plot(tv2, y852b1);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,6);
plot(tv2, y770b1);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');

%% 3(b) ii: plot comparison (2)
%
% ------------------------------------ %
% ----- 2. N1 = 100 vs. N1b = 50 ---- %
% ------------------------------------ %
%
% ----- plot input and output signals (N1a for testC)----- 
%
figure();
subplot(3,2,1)
plot(tv3, testC);
title(  horzcat(title1a, num2str(N1))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,3)
plot(tv3, y852c);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,5);
plot(tv3, y770c);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,2)
plot(tv3, testC);
title(  horzcat(title1a, num2str(N1b))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,4)
plot(tv3, y852c2);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,6);
plot(tv3, y770c2);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');
%
% ----- plot input and output signals (N1a for testB) ----- 
%
figure();
subplot(3,2,1)
plot(tv2, testB);
title(  horzcat(title1b, num2str(N1))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,3)
plot(tv2, y852b);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,5);
plot(tv2, y770b);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,2)
plot(tv2, testB);
title(  horzcat(title1b, num2str(N1b))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,4)
plot(tv2, y852b2);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,6);
plot(tv2, y770b2);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');

%% 3(b) ii: plot comparison (3)
%
% ------------------------------------ %
% ----- 3. N1 = 100 vs. N1c = 400 ---- %
% ------------------------------------ %
%
% ----- plot input and output signals (N1a for testC)----- 
%
figure();
subplot(3,2,1)
plot(tv3, testC);
title(  horzcat(title1a, num2str(N1))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,3)
plot(tv3, y852c);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,5);
plot(tv3, y770c);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,2)
plot(tv3, testC);
title(  horzcat(title1a, num2str(N1c))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,4)
plot(tv3, y852c3);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,6);
plot(tv3, y770c3);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');
%
% ----- plot input and output signals (N1a for testB) ----- 
%
figure();
subplot(3,2,1)
plot(tv2, testB);
title(  horzcat(title1b, num2str(N1))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,3)
plot(tv2, y852b);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,5);
plot(tv2, y770b);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,2)
plot(tv2, testB);
title(  horzcat(title1b, num2str(N1c))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,4)
plot(tv2, y852b3);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,2,6);
plot(tv2, y770b3);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');