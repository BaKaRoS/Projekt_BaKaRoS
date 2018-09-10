function [ data, time ] = loadData( filename )
    %load file
    content = load(filename, 'data', 'time');
    data = content.data;
    time = content.time;
    disp(sprintf('loaded data from %s (%s)', char(filename), char(time))); 
end