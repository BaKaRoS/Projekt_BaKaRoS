function [ ] = recordData( portnumber, samples, filename, baudrate )
    %delete serial objects
    close all;
    close all hidden;
    delete(instrfindall);

    %global variables
    buffer = zeros(1, 100); %small buffer
    graph = zeros(3, samples); %big data buffer
%     graph_x = 1:samples;

    data = zeros(4, samples);

    %plot
%     graph_y = 2^16;
%     f = figure(1);
%     p = plot(graph_x(1:samples), graph(1, 1:samples), graph_x(1:samples), graph(2, 1:samples), graph_x(1:samples), graph(3, 1:samples));
%     axis([0 samples 0 graph_y]);

    %establish serial communication
    obj = instrhwinfo('serial');
    portlist = obj.SerialPorts
    port = portlist(portnumber);
    s = serial(char(port));
    set(s,'BaudRate', baudrate);
%     zoom off;
%     zoom xon;

    if isvalid(s)
        disp(sprintf('connecting to port %s', char(port))); 
        fopen(s);
        disp(sprintf('connection established')); 
        
        %main program
        counter = 2;
        counter2 = 1;
        
        %find line start
        bool = 0;
        while bool == 0
            buffer(counter) = fread(s, 1);
            if (buffer(counter) == 10 && buffer(counter-1) == 13)
                bool = 1;
                counter = 0;
                disp(sprintf('start of data found, beginning recording')); 
            end
            counter = counter+1;
        end

        while counter2 <= samples
            buffer(counter:counter+9) = fread(s, 10);
            counter = 10;
                if (buffer(counter) == 10 && buffer(counter-1) == 13)
                   data(1, counter2) = (bitshift(buffer(counter-3), 8) + buffer(counter-2)); %1
                   data(2, counter2) = (bitshift(buffer(counter-5), 8) + buffer(counter-4)); %2
                   data(3, counter2) = (bitshift(buffer(counter-7), 8) + buffer(counter-6)); %3
                   data(4, counter2) = (bitshift(buffer(counter-9), 8) + buffer(counter-8)); %4
                   counter = 1;
                   counter2 = counter2+1;
                end

%                 if ishandle(p)
%                     %save zoom
%                     zoom_x = get(gca,'XLim');
%                     zoom_y = get(gca,'YLim');
% 
%                     %update/redraw graph
%                     p = plot(graph_x(1:samples), graph(1, 1:samples), graph_x(1:samples), graph(2, 1:samples), graph_x(1:samples), graph(3, 1:samples));
% 
%                     %restore zoom
%                     zoom(1,1);
%                     set(gca,'XLim', zoom_x);
%                     set(gca,'YLim', zoom_y);
%                     drawnow limitrate;
%                 else
%                     return
%                end % ishandle
        end % while
            
        time = datetime;
        save(filename, 'data', 'time');

        disp(sprintf('saved data to %s', char(filename))); 

    else
        %invalid port
        disp(sprintf('port %s invalid', char(port))); 
    end

    %close serial connection
    fclose(s);
    delete(s);
    clear s;
    delete(obj);
    clear obj;
    delete(instrfindall);
    %delete(f);

end