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

% ---- define the following: -----
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

%% STEP 4 
%
%% 4(a) Setup
%
% ----- create the filter -----
%
fs = 8000;
fc1 = 770;
fc2 = 852;
fc3 = 1209;
fc4 = 1336;

w = 10;
Wn1 = [fc1-w, fc1+w]/(fs/2);
Wn2 = [fc2-w, fc2+w]/(fs/2);
Wn3 = [fc3-w, fc3+w]/(fs/2);
Wn4 = [fc4-w, fc4+w]/(fs/2);

N1 = 100;
b770 = fir1(  N1, Wn1, rectwin(N1+1)  );
b852 = fir1(  N1, Wn2, rectwin(N1+1)  );
b1209 = fir1(  N1, Wn3, rectwin(N1+1)  );
b1336 = fir1(  N1, Wn4, rectwin(N1+1)  );

title1a='your input signal: testD with Lsmooth = ';
title1b='your input signal (with mydetector): testD with N1 = ';
title2='your filtered output signal @ 770 Hz';
title3='your filtered output signal @ 852 Hz';
title4='your filtered output signal @ 1209 Hz';
title5a='your filtered output signal @ 1336 Hz';
title5b='your filtered output signal @ 1336 Hz (zoomed in)';
%
% ----- filtered output for testD signal -----
%
% (1) using convolution 
%
% y770d = conv(testD, b770);
% y852d = conv(testD, b852);
% y1209d = conv(testD, b1209);
% y1336d = conv(testD, b1336);
%
% (2) using filter function
%
y770d = filter(b770, 1, testD);
y852d = filter(b852, 1, testD);
y1209d = filter(b1209, 1, testD);
y1336d = filter(b1336, 1, testD);
%
% ----- use mydetector.m function to fix -----
%
Lsmooth = 200;
y770dr = mydetector(y770d, Lsmooth);
y852dr = mydetector(y852d, Lsmooth);
y1209dr = mydetector(y1209d, Lsmooth);
y1336dr = mydetector(y1336d, Lsmooth);
%
% ----- plot input and output signals ----- 
%
figure();
subplot(5,2,1)
plot(tv4, testD);
title(  horzcat(title1a, num2str(Lsmooth))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(5,2,3)
plot(tv4, y770d);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(5,2,5);
plot(tv4, y852d);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(5,2,7);
plot(tv4, y1209d);
title(title4);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(5,2,9);
plot(tv4, y1336d);
title(title5a);
xlabel('t [sec.]'); ylabel('amplitude');
%
% ----- plot input and output signals (with my detector) ----- 
%
subplot(5,2,2)
plot(tv4, testD);
title(  horzcat(title1b, num2str(Lsmooth))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(5,2,4)
plot(tv4, y770dr);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(5,2,6);
plot(tv4, y852dr);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(5,2,8);
plot(tv4, y1209dr);
title(title4);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(5,2,10);
plot(tv4, y1336dr);
title(title5a);
xlabel('t [sec.]'); ylabel('amplitude');

%
% ----- check if -----
% the oscillation in the pulses with highest amplitude have 10% of the
% amplitude in the oscillation
figure();
subplot(2,1,1);
plot(tv4, y1336dr);
title(title5a);
xlabel('t [sec.]'); ylabel('amplitude');


subplot(2,1,2);
plot(tv4, y1336dr);
title(title5b);
xlabel('t [sec.]'); ylabel('amplitude');
axis([tv4(2400), tv4(4700), min(y1336dr), max(y1336dr)]);

sampleSig = y1336dr(2688:4416);
loamp = min(sampleSig);
hiamp = max(sampleSig);
x = rms(sampleSig)
z = hiamp - loamp

if (z < 0.1 * x)
    sprintf('amplitude within 10%%')
end


%% 4(b) 
%
% ---- create a detector for the button 8 -----
%
fc2 = 852;
fc4 = 1336;

Wn2 = [fc2-w, fc2+w]/(fs/2);
Wn4 = [fc4-w, fc4+w]/(fs/2);

N1 = 100;
b852 = fir1(  N1, Wn2, rectwin(N1+1)  );
b1336 = fir1(  N1, Wn4, rectwin(N1+1)  );

y852d = filter(b852, 1, testD);
y1336d = filter(b1336, 1, testD);
y8d = y852d .* y1336d;

%
% ----- use mydetector.m function to fix -----
%
Lsmooth = 200;
y852dr = mydetector(y852d, Lsmooth);
y1336dr = mydetector(y1336d, Lsmooth);
y8dr = mydetector(y8d, Lsmooth);


title1='your input signal (with mydetector): testD with N1 = ';
title2='your filtered output signal @ 852 Hz';
title3='your filtered output signal @ 1336 Hz';
title4a='your filtered output signal for button 8';
title4b='your filtered output signal for button 8 (zoomed in)';
title4c='your filtered output signal outside button 8 (2nd highest amp)';
%
% ----- plot input and output signals (with my detector) ----- 
%
figure();
subplot(4,1,1)
plot(tv4, testD);
title(  horzcat(title1, num2str(Lsmooth))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,1,2)
plot(tv4, y852dr);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,1,3);
plot(tv4, y1336dr);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,1,4);
plot(tv4, y8dr);
title(title4a);
xlabel('t [sec.]'); ylabel('amplitude');

%
% ---- plot zoom in -----
%
figure();
subplot(3,1,1)
plot(tv4, y8dr);
title(title4a);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(3,1,2)
plot(tv4, y8dr);
title(title4b);
xlabel('t [sec.]'); ylabel('amplitude');
axis([2.0991, 2.387, min(y8dr), max(y8dr)]);

subplot(3,1,3)
plot(tv4, y8dr);
title(title4c);
xlabel('t [sec.]'); ylabel('amplitude');
axis([tv4(14400), tv4(16705), min(y8dr), max(y8dr)]);

%
% ----- finding the lowest value of the pulse (inside the number 8) -----
%
loamp1a = y8dr(17095);
loamp2a = y8dr(18816);
loampa = min(y8dr(17095:18816))

%
% ----- finding the width of each pulse  -----
%
Lpulse1a = 2.387 - 2.0991;
Lpulse2a = t4/12;
Lpulsea = mean([Lpulse1a, Lpulse2a])

%
% ----- finding the highest of the pulse (outside the number 8) -----
%
hiamp1a = y8dr(14400);
hiamp2a = y8dr(16705);
hiampa = max(y8dr(14400:16705))

%% 4(c) 
%
% ---- create a detector for the button 4 -----
%
fc1 = 770;
fc3 = 1209;

Wn1 = [fc1-w, fc1+w]/(fs/2);
Wn3 = [fc3-w, fc3+w]/(fs/2);

N1 = 100;
b770 = fir1(  N1, Wn1, rectwin(N1+1)  );
b1209 = fir1(  N1, Wn3, rectwin(N1+1)  );

y770d = filter(b770, 1, testD);
y1209d = filter(b1209, 1, testD);
y4d = y770d .* y1209d;
%
% ----- use mydetector.m function to fix -----
%
Lsmooth = 200;
y770dr = mydetector(y770d, Lsmooth);
y1209dr = mydetector(y1209d, Lsmooth);
y4dr = mydetector(y4d, Lsmooth);

title1b='your input signal (with mydetector): testD with N1 = ';
title2='your filtered output signal @ 770 Hz';
title3='your filtered output signal @ 1209 Hz';
title4a='your filtered output signal for button 4';
title4b='your filtered output signal for button 4 (zoomed in)';
title4c='your filtered output signal outside button 4 (2nd highest amp)';
%
% ----- plot input and output signals (with my detector) ----- 
%
figure();
subplot(4,1,1)
plot(tv4, testD);
title(  horzcat(title1, num2str(N1))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,1,2)
plot(tv4, y770dr);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,1,3);
plot(tv4, y1209dr);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,1,4);
plot(tv4, y4dr);
title(title4);
xlabel('t [sec.]'); ylabel('amplitude');

%
% ---- plot zoom in -----
%
figure();
subplot(3,1,1)
plot(tv4, y4dr);
title(title4a);
xlabel('t [sec.]'); ylabel('amplitude');
%
subplot(3,1,2)
plot(tv4, y4dr);
title(title4b);
xlabel('t [sec.]'); ylabel('amplitude');
axis([tv4(7200), tv4(9500), min(y4dr), max(y4dr)]);
% 
subplot(3,1,3)
plot(tv4, y4dr);
title(title4c);
xlabel('t [sec.]'); ylabel('amplitude');
axis([tv4(9600), tv4(11900), min(y4dr), max(y4dr)]);
%
% ----- finding the lowest value of the pulse (inside the number 4) -----
%
loamp1b = y4dr(7200);
loamp2b = y4dr(9500);
loampb = min(y4dr(7478:9211))

%
% ----- finding the width of each pulse  -----
%
Lpulse1b = tv4(9500) - tv4(7200);
Lpulse2b = t4/12;
Lpulseb = mean([Lpulse1b, Lpulse2b])

%
% ----- finding the highest of the pulse (outside the number 8) -----
%
hiamp1b = y4dr(9600);
hiamp2b = y4dr(11900);
hiampb = max(y4dr(9600:11900));
