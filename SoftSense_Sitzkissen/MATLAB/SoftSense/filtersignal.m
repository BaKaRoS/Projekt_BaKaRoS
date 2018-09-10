function [ dataOut ] = filtersignal( dataIn )

    %median filter
    %order = 9;
    %dataOut = medfilt1(dataIn, order);
    
    %butterworth lowpass filter (IRR)
    %[b,a] = butter(filterOrder, cutoff/samplingrate, 'low');
    %freqz(b,a);
    %dataOut = filter(b,a, dataIn);
    
    %kaiser window based lowpass filter (FIR)
    samplingrate = 25;
    order = 20;
    cutoff = 1;
    disp(sprintf('applying kaiser window lowpass filter with cutoff frequency of %dHz', char(cutoff))); 
    Wn = (2/samplingrate)*cutoff;
    b = fir1(order,Wn,'low',kaiser(21,3));
    %freqz(b,1);
    dataOut = filter(b, 1, dataIn);

end

