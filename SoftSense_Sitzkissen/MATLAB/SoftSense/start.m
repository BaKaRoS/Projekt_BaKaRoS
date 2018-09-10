%clear all
clear all;
clc;

%config
samples = 1000;
portnumber = 4; %/dev/cu.usbmodem621', /dev/cu.linvor-DevB
filename = 'rawdata.mat';
baudrate = 9600;

%record and save samples
recordData(portnumber, samples, filename, baudrate);

%load samples
[data time] = loadData(filename);
samples = size(data, 2);

%data
sensor1 = data(1, 1:end);
sensor2 = data(2, 1:end);
battery = data(3, 1:end);
x = 1:samples;

%plot raw data
f1 = figure(1);
plot(x, sensor1, x, sensor2, 'r', x, battery, 'y');
set(zoom(f1),'Motion','horizontal');
y_max = max(max(data, [], 2));
axis([0 samples 0 y_max]);
xlabel(['samples (recorded on ' char(time) ')']);
ylabel('capacity');
title('SchoolBuddy');
legend('left sensor','right sensor');

%removing spikes
sensor1 = filtersignal(sensor1);
sensor2 = filtersignal(sensor2);

%plot for signal processing
y_max = max(max(sensor1), max(sensor2));
f2 = figure(2);
subplot(3,1,1);
p = plot(x, sensor1, x, sensor2, 'r');
set(zoom(f2),'Motion','horizontal');
axis([0 samples 0 y_max]);
xlabel(['samples (recorded on ' char(time) ')']);
ylabel('capacity');
title('SchoolBuddy');
legend('left sensor','right sensor');

%FFT
sensor1_f = fft(sensor1);
sensor2_f = fft(sensor2);
samplingrate = 25; % Sampling frequency in Hz

P2 = abs(sensor1_f/samples);
P1 = P2(1:samples/2+1);
P1(2:end-1) = 2*P1(2:end-1);

P4 = abs(sensor2_f/samples);
P3 = P4(1:samples/2+1);
P3(2:end-1) = 2*P3(2:end-1);

f = samplingrate*(0:(samples/2))/samples;

subplot(3,1,2);
p2 = plot(f, P1, f, P3, 'r'); %semilogy
title('Single-Sided Amplitude Spectrum')
xlabel('f [Hz]')
ylabel('|F(f)|')
legend('left sensor','right sensor');

subplot(3,1,3);
p3 = plot(x, battery*3.3/128, 'y');
axis([0 samples 3.7 4.2]);
title('Battery Voltage')
xlabel(['samples (recorded on ' char(time) ')']);
ylabel('voltage [V]')
legend('battery');

%make sure connection is closed
delete(instrfindall);