%clear all
clear all;
clc;

%config
folder = 'eichung/sensor1';
samplingrate = 25;
cutoff = 10;
filterOrder = 20;

folderContent = dir(folder);

set(0, 'DefaulttextInterpreter', 'none'); %disable index (through underlining) in plot

counter = 0;
for i=1:size(folderContent, 1)
    if size(folderContent(i).name, 2) > 12
        counter = counter+1;
        disp(['file ' char(folderContent(i).name ) ' found']);
        [data time] = loadData(strcat(folder, '/', folderContent(i).name));
        samples = size(data, 2);
        
        %filtering
        data2(1, 1:samples) = filtersignal(data(1, 1:samples));
        data2(2, 1:samples) = filtersignal(data(2, 1:samples));
        
        %plot
        f = figure(counter);
        x = 1:samples;
        plot(x, data2(1, 1:end), x, data2(2, 1:end), 'r');
        %set(zoom(f),'Motion','horizontal');
        y_max = max([max(data2(1, 1:samples)) max(data2(2, 1:samples))]);
        axis([0 samples 0 y_max]);
        xlabel(['samples (recorded on ' char(time) ')']);
        ylabel('capacity');
        title(strcat(folder, '/', folderContent(i).name));
        legend('left sensor','right sensor');
        grid on;
    end
end

%load samples
%[data time] = loadData(filename);
%samples = size(data, 2);

