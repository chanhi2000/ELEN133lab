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

%% STEP 2
%
% ----- create the filter: -----
%
fs = 8000;
fc1 = 852;
fc2 = 770;

w = 10;
Wn1 = [fc1-w, fc1+w]/(fs/2);
Wn2 = [fc2-w, fc2+w]/(fs/2);

N1 = 200;
b852 = fir1(  N1, Wn1, rectwin(N1+1)  );
b770 = fir1(  N1, Wn2, rectwin(N1+1)  );
%
% ----- create a frequency response of the filter -----
%
% N2 = 1024;
% [H852, fv] = freqz(  b852, 1, N2, fs, 'whole'  );
% [H770, fv] = freqz(  b770, 1, N1, fs, 'whole'  );

title1a='the input signal: testC';
title1b='the input signal: testB';
title2='the filtered output signal @ 852 Hz';
title3='the filtered output signal @ 770 Hz';
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
y852c = filter(b852, 1, testC);
y770c = filter(b770, 1, testC);
%
% ----- plot input and output signals ---- 
%
figure();
subplot(3,1,1)
plot(tv3, testC);
title(title1a);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,1,2)
plot(tv3, y852c);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,1,3);
plot(tv3, y770c);
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
y852b = filter(b852, 1, testB);
y770b = filter(b770, 1, testB);

figure();
subplot(3,1,1)
plot(tv2, testB);
title(title1b);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,1,2)
plot(tv2, y852b);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,1,3);
plot(tv2, y770b);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');


