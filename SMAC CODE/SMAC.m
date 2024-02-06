% SMAC (Sensors Medium Access Control) PROTOCOL FOR WIRELESS SENSOR NETWORKS%
% IMPLEMENTED BY LARAIB AZMAT
% GITHUB -> Laraib-Azmat 

% Comprehensive S-MAC Simulation with Visualization in MATLAB

% Parameters
totalNodes = 10; % Total number of nodes in the network
simulationTime = 100; % Simulation time in seconds
packetSize = 100; % Size of each data packet in bytes
trafficLoad = 0.6; % Probability of a sensing event occurring

% Initialize node states
sleepDuration = zeros(1, totalNodes); % Array to store sleep duration for each node%%array is intialize with zero
transmissionTime = zeros(1, totalNodes); % Array to store transmission time for each node

% Packet aggregation parameters

aggregatedPackets = zeros(1, totalNodes); % Initialize an array to store aggregated packets for each node


% Dynamic sleep adjustment parameters
SleepPeriod = 3; % fixed sleep duration of node
syncInterval = 50; % Synchronization interval
AwakePeriods = syncInterval - SleepPeriod;

% Duty cycle parameters%%%The duty cycle is the fraction of time that a node is active or awake compared to the total time

currentDutyCycle = 0.1; % Initial duty cycle

% Synchronization parameters
syncInterval = 50; % Synchronization interval
syncDuration = 1; % Duration for which SYNC is transmitted
rtsThreshold = 0.5; % RTS threshold for initiating RTS/CTS
rtsDuration = 2; % Duration for which RTS is transmitted
ctsDuration = 1; % Duration for which CTS is transmitted
syncPeriod = 10; % Synchronization period for sending SYNC packets periodically


% Simulation loop
for time = 1:simulationTime % Loop over simulation time
    for senderNode = 1:totalNodes % Loop over each node as a potential sender
        % Check if a sensing event occurs
        if rand() < trafficLoad   %rand function genrate random value in matlab
            
   

            % Check if the node is awake before transmission
            if sleepDuration(senderNode) == 0
                % SYNC phase: Send SYNC packets periodically
                if mod(time, syncPeriod) == 0   %used to check whether the current simulation time is a multiple of the synchronization period
                    disp(['Node ' num2str(senderNode) ' sends SYNC at time ' num2str(time)]); %display message
                    transmissionTime(senderNode) = transmissionTime(senderNode) + syncDuration;  %updating transmission time
%asuming that all the nodes are neighbour nodes%%%%%otherwise we can
%calculate through distance and using cluster concept
                    % Broadcast SYNC packet to neighbors
                    for neighborNode = 1:totalNodes
                        % In a real scenario, you would need to handle collisions
                        % Here, we simplify by assuming no collisions in the SYNC phase
                        if neighborNode ~= senderNode && rand() < rtsThreshold
                            
                            %%node receives SYNC 
                             disp(['Node ' num2str(neighborNode) ' receives SYNC from Node ' num2str(senderNode)]);
                            
                             
                                  % RTS phase: Neighbor initiates RTS
                            disp(['Node ' num2str(neighborNode) ' initiates RTS at time ' num2str(time)]);
                             
                             % Transmit RTS signal
                                transmissionTime(neighborNode) = transmissionTime(neighborNode) + rtsDuration;

                            
                            % Neighbor responds with CTS
                            disp(['Node ' num2str(senderNode) ' sends CTS at time ' num2str(time)]);
                            
                            
                            %%updating the transmission time
                            transmissionTime(senderNode) = transmissionTime(senderNode) + ctsDuration;
                            
                        
                            
                            
                           
                               
                                % Continue with data transmission (simplified)
                                disp(['Node ' num2str(neighborNode) ' transmits data after RTS/CTS at time ' num2str(time)]);
                                transmissionTime(neighborNode) = transmissionTime(neighborNode) + packetSize;

                                %record that how many packets a certain
                                %node have transmitted
                                aggregatedPackets(neighborNode) = aggregatedPackets(neighborNode) + 1;
                            
                        end
                    end
                end
                
            else
                % Node is asleep, no transmission
                disp(['Node ' num2str(senderNode) ' is asleep at time ' num2str(time)]);
            end
        else
            % No sensing event, increase sleep duration
            sleepDuration(senderNode) = sleepDuration(senderNode) + 1;
              % Update sleep duration based on duty cycle
    if sleepDuration(senderNode)>=SleepPeriod;
    sleepDuration(senderNode) = 0;
    end
        end
    end
    
    % Adjust duty cycle based on fixed sleep and awake periods
    currentDutyCycle = sum(AwakePeriods) / syncInterval;

  
  

    % Plot node states
    subplot(8, 1, 1);       %% Create a subplot in the 1st position of an 8-row grid with one column
    plot(1:totalNodes, transmissionTime, 'o-', 'LineWidth', 1.5);   %his line plots the transmission time for each node.
    title('Transmission Time');
    xlabel('Node');
    ylabel('Time (s)');
    
    subplot(8, 1, 3);
    plot(1:totalNodes, sleepDuration, 'o-', 'LineWidth', 1.5);      %'o-' specifies the line style (solid line with circles at data points), and 'LineWidth', 1.5 sets the line width to 1.5.
    title('Sleep Duration');
    xlabel('Node');
    ylabel('Time (s)');
    
    subplot(8, 1, 5);
    plot(1:totalNodes, aggregatedPackets, 'o-', 'LineWidth', 1.5);
    title('Aggregated Packets');
    xlabel('Node');        %% Adds a label to the x-axis, indicating that it represents node indices.
    ylabel('Number of Packets');
    
    subplot(8, 1, 7);
    plot(time, currentDutyCycle, 'o-', 'LineWidth', 1.5);
    title('Current Duty Cycle');
    xlabel('Time (s)');
    ylabel('Duty Cycle');
    
    pause(0.5); % Pause to observe the plot
end

% Calculate overall network statistics
totalTransmissionTime = sum(transmissionTime);
energyConsumption = totalTransmissionTime;

% Display network-wide statistics
disp(' ');
disp('Network-wide Statistics:');
disp('-------------------------');
disp(['Total Transmission Time: ' num2str(totalTransmissionTime)]);
disp(['Total Energy Consumption: ' num2str(energyConsumption)]);