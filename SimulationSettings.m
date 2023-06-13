classdef SimulationSettings
    methods(Static)
        function [sp,N,dt] = Standard()
            dt = 1; % time step [s]
            t_start = 0; % simulating starting time [ min]
            t_stop = 27; %simulating stopping time[ min]
            N = ceil(60*(t_stop - t_start)/ dt ); % simulating steps

            sp = zeros(6,N);
            for m = 1:N
                if m<=N/3
                    sp(:,m) = [15; 0; 1; 0; 0*pi/180; 0];% north, east, yaw setpoint
                elseif m> N/3 && m<=2*N/3
                    sp(:,m)= [6; 0; 13; 0; 45*pi/180; 0];
                elseif m> 2*N/3
                    sp(:,m)= [12; 0; 19; 0; 25*pi/180; 0];
                end
            end
        end
        function [sp,N,dt] = Long()
            dt = 1; % time step [s]
            t_start = 0; % simulating starting time [ min]
            t_stop = 1000; %simulating stopping time[ min]
            N = ceil(60*(t_stop - t_start)/ dt ); % simulating steps

            sp = zeros(6,N);
            for m = 1:N
                if m<=N/3
                    sp(:,m) = [15; 0; 1; 0; 0*pi/180; 0];% north, east, yaw setpoint
                elseif m> N/3 && m<=2*N/3
                    sp(:,m)= [6; 0; 13; 0; 45*pi/180; 0];
                elseif m> 2*N/3
                    sp(:,m)= [12; 0; 19; 0; 25*pi/180; 0];
                end
            end
        end
        function [sp,N,dt] = Medium()
            dt = 1; % time step [s]
            t_start = 0; % simulating starting time [ min]
            t_stop = 15; %simulating stopping time[ min]
            N = ceil(60*(t_stop - t_start)/ dt ); % simulating steps

            sp = zeros(6,N);
            for m = 1:N
                if m<=N/3
                    sp(:,m) = [0; 0; 0; 0; 0; 0];% north, east, yaw setpoint
                elseif m> N/3
                    sp(:,m)= [16; 0; 0; 0; 0; 0];
                end
            end
        end
        function [sp,N,dt] = Short()
            dt = 1; % time step [s]
            t_start = 0; % simulating starting time [ min]
            t_stop = 2.50; %simulating stopping time[ min]
            N = ceil(60*(t_stop - t_start)/ dt ); % simulating steps

            sp = zeros(6,N);
            for m = 1:N
                if m<=N/3
                    sp(:,m) = [0; 0; 0; 0; 0; 0];% north, east, yaw setpoint
                elseif m> N/3
                    sp(:,m)= [16; 0; 0; 0; 0; 0];
                end
            end
        end
    end
end
