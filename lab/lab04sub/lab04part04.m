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
% ----- create signals -----
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
%% STEP 5
%
%% 5(a) Setup
%
% ----- create the filter: -----
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

N1 = 200;
b770 = fir1(  N1, Wn1, rectwin(N1+1)  );
b852 = fir1(  N1, Wn2, rectwin(N1+1)  );
b1209 = fir1(  N1, Wn3, rectwin(N1+1)  );
b1336 = fir1(  N1, Wn4, rectwin(N1+1)  );

% 
% ----- create a noisy signal -----
%
a = 0.8;  % your personal noise level 
testDn = testD + a*randn(  1, length(testD)  );
testDn = testDn/(max(abs(testDn)));

% %
% % ----- filtered output for testD signal -----
% %
% % (1) using convolution 
% % 
% y770d = conv(testD, b770);
% y852d = conv(testD, b852);
% y1209d = conv(testD, b1209);
% y1336d = conv(testD, b1336);
%
% (2) using filter function
% 
y770d = filter(b770, 1, testDn);
y852d = filter(b852, 1, testDn);
y1209d = filter(b1209, 1, testDn);
y1336d = filter(b1336, 1, testDn);

%
% ----- use mydetector.m function to fix -----
%
Lsmooth = 200;
y770dr1 = mydetector(y770d, Lsmooth);
y852dr1 = mydetector(y852d, Lsmooth);
y1209dr1 = mydetector(y1209d, Lsmooth);
y1336dr1 = mydetector(y1336d, Lsmooth);

%
% ----- use mydetectorMod.m function to improvec -----
%
thres = 0.05;
y770dr2 = mydetectorMod(y770d, Lsmooth, thres);
y852dr2 = mydetectorMod(y852d, Lsmooth, thres);
y1209dr2 = mydetectorMod(y1209d, Lsmooth, thres);
y1336dr2 = mydetectorMod(y1336d, Lsmooth, thres);

title1a='your input signal: testDn with N1 = ';
title1b='your input signal (with mydetector): testD with Lsmooth = ';
title1c='your input signal (with mydetectorMod): testD with thres = ';
title2='your filtered output signal @ 770 Hz';
title3='your filtered output signal @ 852 Hz';
title4='your filtered output signal @ 1209 Hz';
title5='your filtered output signal @ 1336 Hz';

% 
% ----- plot input / output signals (noise signal vs. mydetector)----- 
%
figure();
subplot(5,2,1)
plot(tv4, testDn);
title(  horzcat(title1a, num2str(N1))  );
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
title(title5);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(5,2,2)
plot(tv4, testDn);
title(  horzcat(title1b, num2str(Lsmooth))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(5,2,4)
plot(tv4, y770dr1);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(5,2,6);
plot(tv4, y852dr1);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(5,2,8);
plot(tv4, y1209dr1);
title(title4);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(5,2,10);
plot(tv4, y1336dr1);
title(title5);
xlabel('t [sec.]'); ylabel('amplitude');

% 
% ----- plot input / output signals (noise signal vs. mydetectorMod) ----- 
%
figure();
subplot(5,2,1)
plot(tv4, testDn);
title(  horzcat(title1a, num2str(N1))  );
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
title(title5);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(5,2,2)
plot(tv4, testDn);
title(  horzcat(title1c, num2str(thres))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(5,2,4)
plot(tv4, y770dr2);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(5,2,6);
plot(tv4, y852dr2);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(5,2,8);
plot(tv4, y1209dr2);
title(title4);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(5,2,10);
plot(tv4, y1336dr2);
title(title5);
xlabel('t [sec.]'); ylabel('amplitude');

%% 5(b) 
%
% ---- create a detector for the button 8 -----
%
fc2 = 852;
fc4 = 1336;

Wn2 = [fc2-w, fc2+w]/(fs/2);
Wn4 = [fc4-w, fc4+w]/(fs/2);

N1 = 200;
b852 = fir1(  N1, Wn2, rectwin(N1+1)  );
b1336 = fir1(  N1, Wn4, rectwin(N1+1)  );

y852d = filter(b852, 1, testDn);
y1336d = filter(b1336, 1, testDn);
y8d = y852d .* y1336d;
%
% ----- use mydetector.m function to fix -----
%
Lsmooth = 100;
y852dr1 = mydetector(y852d, Lsmooth);
y1336dr1 = mydetector(y1336d, Lsmooth);
y8dr1 = mydetector(y8d, Lsmooth);
%
% ----- use mydetector.m function to improve -----
%
thres = 0.05;
y852dr2 = mydetectorMod(y852d, Lsmooth, thres);
y1336dr2 = mydetectorMod(y1336d, Lsmooth, thres);
y8dr2 = y852dr2 .* y1336dr2;

title1a='your input signal: testDn with N1 = ';
title1b='your input signal (with mydetector): testD with Lsmooth = ';
title1c='your input signal (with mydetectorMod): testD with thres = ';
title2='your filtered output signal @ 852 Hz';
title3='your filtered output signal @ 1336 Hz';
title4='your filtered output signal for button 8';

% 
% ----- plot input / output signals (noise signal vs. mydetector)----- 
%
figure();
subplot(4,2,1)
plot(tv4, testDn);
title(  horzcat(title1a, num2str(N1))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,2,3)
plot(tv4, y852d);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,2,5);
plot(tv4, y1336d);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,2,7);
plot(tv4, y8d);
title(title4);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,2,2)
plot(tv4, testDn);
title(  horzcat(title1b, num2str(Lsmooth))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,2,4)
plot(tv4, y852dr1);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,2,6);
plot(tv4, y1336dr1);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,2,8);
plot(tv4, y8dr1);
title(title4);
xlabel('t [sec.]'); ylabel('amplitude');

% 
% ----- plot input / output signals (noise signal vs. mydetectorMod) ----- 
%
figure();
subplot(4,2,1)
plot(tv4, testDn);
title(  horzcat(title1a, num2str(N1))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,2,3)
plot(tv4, y852d);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,2,5);
plot(tv4, y1336d);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,2,7);
plot(tv4, y8d);
title(title4);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,2,2)
plot(tv4, testDn);
title(  horzcat(title1c, num2str(thres))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,2,4)
plot(tv4, y852dr2);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,2,6);
plot(tv4, y1336dr2);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,2,8);
plot(tv4, y8dr2);
title(title4);
xlabel('t [sec.]'); ylabel('amplitude');


%% 5(c) 
%
% ---- create a detector for the button 4 -----
%
fc1 = 770;
fc3 = 1209;

Wn1 = [fc1-w, fc1+w]/(fs/2);
Wn3 = [fc3-w, fc3+w]/(fs/2);

N1 = 200;
b770 = fir1(  N1, Wn1, rectwin(N1+1)  );
b1209 = fir1(  N1, Wn3, rectwin(N1+1)  );

y770d = filter(b770, 1, testDn);
y1209d = filter(b1209, 1, testDn);
y4d = y770d .* y1209d;
% 
% ----- use mydetector.m function to fix -----
% 
Lsmooth = 100;
y770dr1 = mydetector(y770d, Lsmooth);
y1209dr1 = mydetector(y1209d, Lsmooth);
y4dr1 = mydetector(y4d, Lsmooth);

% 
% ----- use mydetectorMod.m function to improve -----
% 
thres = 0.05;
y770dr2 = mydetectorMod(y770d, Lsmooth, thres);
y1209dr2 = mydetectorMod(y1209d, Lsmooth, thres);
y4dr2 = y770dr2 .* y1209dr2;

title1a='your input signal: testDn with N1 = ';
title1b='your input signal (with mydetector): testD with Lsmooth = ';
title1c='your input signal (with mydetectorMod): testD with thres = ';
title2='your filtered output signal @ 852 Hz';
title3='your filtered output signal @ 1336 Hz';
title4='your filtered output signal for button 8';

% 
% ----- plot input / output signals (noise signal vs. mydetector)----- 
%
figure();
subplot(4,2,1)
plot(tv4, testDn);
title(  horzcat(title1a, num2str(N1))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,2,3)
plot(tv4, y770d);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,2,5);
plot(tv4, y1209d);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,2,7);
plot(tv4, y4d);
title(title4);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,2,2)
plot(tv4, testDn);
title(  horzcat(title1b, num2str(Lsmooth))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,2,4)
plot(tv4, y770dr1);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,2,6);
plot(tv4, y1209dr1);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,2,8);
plot(tv4, y4dr1);
title(title4);
xlabel('t [sec.]'); ylabel('amplitude');

% 
% ----- plot input / output signals (noise signal vs. mydetectorMod) ----- 
%
figure();
subplot(4,2,1)
plot(tv4, testDn);
title(  horzcat(title1a, num2str(N1))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,2,3)
plot(tv4, y770d);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,2,5);
plot(tv4, y1209d);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,2,7);
plot(tv4, y4d);
title(title4);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,2,2)
plot(tv4, testDn);
title(  horzcat(title1c, num2str(thres))  );
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,2,4)
plot(tv4, y770dr2);
title(title2);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,2,6);
plot(tv4, y1209dr2);
title(title3);
xlabel('t [sec.]'); ylabel('amplitude');

subplot(4,2,8);
plot(tv4, y4dr2);
title(title4);
xlabel('t [sec.]'); ylabel('amplitude');

% 
% ----- sound output -----
% you will hear higher hiss sound.

% % play button: 1-12
% sound(testDn, fs);
% pause(3.6);

% % play button: 4 5 6
% sound(y770d, fs);
% pause(3.6);

% % play button: 7 8 9 
% sound(y852d, fs);
% pause(3.6);

% % play button: 1 4 7 * 
% sound(y1209d, fs);
% pause(3.6);

% % play button: 2 5 8 0 
% sound(y1336d, fs);
% pause(3.6);

% play button: 8
% sound(y8d, fs);
% pause(3.6);
% 
% play button: 4
% sound(y4d, fs);
% pause(3.6);

