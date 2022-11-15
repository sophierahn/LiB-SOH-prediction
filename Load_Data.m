%Odd cycle displays a charge cycle, even displays a discharge cycle
load('5. Battery Data Set\1. BatteryAgingARC-FY08Q4\B0005.mat');
i = 1; % damn one indexing
state = B0005.cycle(i).type;
while i < 3
    disp("cycle number: "+i)
    type = 0;
    state = B0005.cycle(i).type;
    disp("The state is: " + state)
    disch = contains( state , 'discharge' );
    imped = contains( state , 'impedance' );
    
    
    if disch == 1
        type = 2;
        %discharge cycle
    elseif imped == 1
        type = 3;
        %impedance measurement
    else
        type = 1 ;
        %charge cycle
    end
    disp("Type number: "+type)
    
    if type == 1
        
        disp("type is charge!")
        voltages = B0005.cycle(i).data(1).Voltage_measured;
        currents = B0005.cycle(i).data(1).Current_measured;
        Temps = B0005.cycle(i).data(1).Temperature_measured;
        charge_currents = B0005.cycle(i).data(1).Current_charge;
        charge_voltages = B0005.cycle(i).data(1).Voltage_charge;
        times = B0005.cycle(i).data(1).Time;

        Names = ["Voltages", "Currents", "Temperatures", "Charge Currents", "Charge Voltages", "Time step"];
        
        rows = length(times);
        B0005_cycle_data = zeros(rows, 6);
        B0005_cycle_data(:,1) = voltages;
        B0005_cycle_data(:,2) = currents;
        B0005_cycle_data(:,3) = Temps;
        B0005_cycle_data(:,4) = charge_currents;
        B0005_cycle_data(:,5) = charge_voltages;
        B0005_cycle_data(:,6) = times;
        
        
        
        matrix_name = "Battery 5\Charge Cycle\No Headers\B0005 cycle " + i + " data.xls";
        writematrix(B0005_cycle_data,matrix_name);

        B0005_cycle_data = [Names;B0005_cycle_data];

        matrix_name_with_headers = "Battery 5\Charge Cycle\Headers\B0005 cycle " + i + " data with headers.xls";
        writematrix(B0005_cycle_data,matrix_name_with_headers);
        
        
        %it worked!!
    elseif type == 2
        disp("type is discharge!")
        voltages = B0005.cycle(i).data(1).Voltage_measured;
        currents = B0005.cycle(i).data(1).Current_measured;
        Temps = B0005.cycle(i).data(1).Temperature_measured;
        charge_currents = B0005.cycle(i).data(1).Current_load;
        charge_voltages = B0005.cycle(i).data(1).Voltage_load;
        times = B0005.cycle(i).data(1).Time;
        cappy = B0005.cycle(i).data(1).Capacity;
        SOH = cappy/2;

        Names = ["Voltages", "Currents", "Temperatures", "Charge Currents", "Charge Voltages", "Time step", "Capacity", "SOH"];
        
        rows = length(times);
        B0005_cycle_data = zeros(rows, 6);
        B0005_cycle_data(:,1) = voltages;
        B0005_cycle_data(:,2) = currents;
        B0005_cycle_data(:,3) = Temps;
        B0005_cycle_data(:,4) = charge_currents;
        B0005_cycle_data(:,5) = charge_voltages;
        B0005_cycle_data(:,6) = times;
        B0005_cycle_data(:,7) = cappy;
        B0005_cycle_data(:,8) = SOH;
        
        
        j =1; 
        h=1;
        delete = 0;
        while j <= rows
            volts = voltages(j);
            if volts < 2.79
                delete = 1;
            end
            
            if delete
                B0005_cycle_data(j,:) = [];
                h = h +1; % indicator of how many data points were removed, might be something we want to track later
                j = j -1;
                rows = rows -1;
            end
            j = j +1;
        end
        
        
        matrix_name = "Battery 5\Discharge Cycle\No Headers\B0005 cycle " + i + " data.xls";
        writematrix(B0005_cycle_data,matrix_name);

        B0005_cycle_data = [Names;B0005_cycle_data];

        matrix_name_with_headers = "Battery 5\Discharge Cycle\Headers\B0005 cycle " + i + " data with headers.xls";
        writematrix(B0005_cycle_data,matrix_name_with_headers);
        
    end

    
    
    i = i + 1;
end
