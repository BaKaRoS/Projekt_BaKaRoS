%clear all
clear all;
clc;

%config
samples = 10000;
portnumber = 4; %/dev/cu.usbmodem1411, /dev/cu.linvor-DevB
filename = 'rawdata.mat';
baudrate = 115200;

%record and save samples
recordData(portnumber, samples, filename, baudrate);

%load samples
[data time] = loadData(filename);
samples = size(data, 2);

%data
sensor1 = data(1, 1:end);
sensor2 = data(2, 1:end);
sensor3 = data(3, 1:end);
sensor4 = data(4, 1:end);
x = 1:samples;

%plot raw data
f1 = figure(1);
plot(x, sensor1, x, sensor2, 'r', x, sensor3, 'y', x, sensor4, 'm');
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
sensor3 = filtersignal(sensor3);
sensor4 = filtersignal(sensor4);

%plot for signal processing
y_max = max(max(max(sensor1), max(sensor2)), max(max(sensor3), max(sensor4)));
f2 = figure(2);
%subplot(2,1,1);
p = plot(x, sensor1, x, sensor2, 'r', x, sensor3, 'y', x, sensor4, 'm');
set(zoom(f2),'Motion','horizontal');
axis([0 samples 0 y_max]);
xlabel(['samples (recorded on ' char(time) ')']);
ylabel('capacity');
title('SchoolBuddy');
legend('left sensor','right sensor');

% %FFT
% sensor1_f = fft(sensor1);
% sensor2_f = fft(sensor2);
% sensor3_f = fft(sensor3);
% sensor4_f = fft(sensor4);
% samplingrate = 25; % Sampling frequency in Hz
% 
% P2 = abs(sensor1_f/samples);
% P1 = P2(1:samples/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% 
% P4 = abs(sensor2_f/samples);
% P3 = P4(1:samples/2+1);
% P3(2:end-1) = 2*P3(2:end-1);
% 
% f = samplingrate*(0:(samples/2))/samples;
% 
% subplot(2,1,2);
% p2 = plot(f, P1, f, P3, 'r'); %semilogy
% title('Single-Sided Amplitude Spectrum')
% xlabel('f [Hz]')
% ylabel('|F(f)|')
% legend('left sensor','right sensor');


%make sure connection is closed
delete(instrfindall);