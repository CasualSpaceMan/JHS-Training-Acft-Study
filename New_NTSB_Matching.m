% % The following program imports the NTSB database, FAA database, FAA
% % deregistered aircaft database, and plane information files to match all 
% % accidents to the all the planes registered to the FAA with their 
% % characteristics. It then sorts and cleans the dataset based on our
% % research questions.
% %
% % Author: Lacey Littleton
% % Last Edited Date: 2/28/2020
% 
% %--------------------------------------------------------------------------
% % ************************
% % ***** IMPORT FILES *****
% % ************************
% 
% f = waitbar(0,'Step 1 of 5: Importing Data');
% % Import the complete NTSB database (that includes plane serial numbers)
% NTSB = readtable('aircraft_NewNTSB.xlsx');
% waitbar(1/6);
% 
% % Import the original NTSB database with more complete information
% original_NTSB = readtable('AviationData.txt');
% waitbar(2/6);
% 
% % Import the FAA registered and deregistered databases
% FAA_reg = readtable('FAA Registry/MASTER.txt');
% waitbar(3/6);
% FAA_dereg = readtable('FAA Registry/DEREG.txt');
% waitbar(4/6);
% 
% % Import the FAA plane information databases
% ENGINE = readtable('FAA Registry/ENGINE.txt');
% waitbar(5/6);
% ACFTREF = readtable('FAA Registry/ACFTREF.txt');
% waitbar(6/6);
% delete(f);
% 
% % --------------------------------------------------------------------------
% % *******************************
% % **** Combine FAA Databases ****
% % *******************************
% 
% f = waitbar(0, 'Step 2 of 5: Combining FAA Databases');
% % Current registry columns
% for i = 1:length(FAA_reg.N_NUMBER)
%     cur_nnumber{i} = FAA_reg.N_NUMBER{i}(~isspace(FAA_reg.N_NUMBER{i}));
% end
% waitbar(1/10);
% for i = 1:length(FAA_reg.SERIALNUMBER)
%     cur_serial{i} = FAA_reg.SERIALNUMBER{i}(~isspace(FAA_reg.SERIALNUMBER{i}));
% end
% waitbar(2/10);
% cur_nnumber = cur_nnumber';
% cur_serial = cur_serial';
% cur_MFRcode = FAA_reg.MFRMDLCODE;
% cur_ENGcode = FAA_reg.ENGMFRMDL;
% cur_yearMFR = FAA_reg.YEARMFR;
% cur_city = FAA_reg.CITY;
% cur_state = FAA_reg.STATE;
% cur_airdate = FAA_reg.AIRWORTHDATE;
% cur_certification = FAA_reg.CERTIFICATION;
% cur_canceldate = zeros(length(cur_nnumber),1); %array of zeros
% waitbar(3/10);
% 
% % Deregistered columns
% for i = 1:length(FAA_dereg.N_NUMBER)
%     old_nnumber{i}= FAA_dereg.N_NUMBER{i}(~isspace(FAA_dereg.N_NUMBER{i}));
% end
% waitbar(4/10);
% for i = 1:length(FAA_dereg.SERIAL_NUMBER)
%     old_serial{i}= FAA_dereg.SERIAL_NUMBER{i}(~isspace(FAA_dereg.SERIAL_NUMBER{i}));
% end
% waitbar(5/10);
% old_nnumber = old_nnumber';
% old_serial = old_serial';
% old_MFRcode = FAA_dereg.MFR_MDL_CODE;
% old_ENGcode = FAA_dereg.ENG_MFR_MDL;
% old_yearMFR = FAA_dereg.YEAR_MFR;
% old_city = FAA_dereg.CITY_MAIL;
% old_state = FAA_dereg.STATE_ABBREV_MAIL;
% old_airdate = FAA_dereg.AIR_WORTH_DATE;
% old_certification = FAA_dereg.CERTIFICATION;
% old_canceldate = FAA_dereg.CANCEL_DATE;
% waitbar(6/10);
% 
% % Create mask to distinguish between old and new registry
% CurrentRegistrants = cell(length(cur_nnumber),1); %empty cell array
% CurrentRegistrants(:) = {1}; %cell array of ones
% PastRegistrants = cell(length(old_nnumber),1); %empty cell array
% PastRegistrants(:) = {0}; %cell array of zeros
% waitbar(7/10);
% 
% % Combine each column individually
% nnumber = [cur_nnumber; old_nnumber];
% serial = [cur_serial; old_serial];
% MFRcode = [cur_MFRcode; old_MFRcode];
% ENGcode = [cur_ENGcode; old_ENGcode];
% yearMFR = [cur_yearMFR; old_yearMFR];
% city = [cur_city; old_city];
% state = [cur_state; old_state];
% airdate = [cur_airdate; old_airdate];
% certification = [cur_certification; old_certification];
% canceldate = [cur_canceldate; old_canceldate];
% is_current = [CurrentRegistrants; PastRegistrants];
% waitbar(8/10);
% 
% % Combine columns into large database table. 
% Complete_Registry = table(nnumber, serial, MFRcode, ENGcode, yearMFR,...
%     city, state, airdate, certification, canceldate, is_current, 'VariableNames',...
%     {'N_Number', 'Serial_Number', 'MFRcode', 'ENGcode', 'yearMFR',...
%     'city', 'state', 'airdate', 'certification', 'canceldate', 'iscurrent'});
% waitbar(9/10);
% 
% % Sort the registry alphabetically by serial number then by N Number
% Sorted_Registry = sortrows(Complete_Registry, [2 1]);
% waitbar(10/10);
% delete(f);
% 
% % -------------------------------------------------------------------------
% % ******************************
% % *** Generate NTSB Database ***
% % ******************************
% 
% f = waitbar(0,'Step 3 of 5: Matching NTSB event numbers');
% % Get event numbers in order to match with new database
% og_eventNumbers = original_NTSB.EventId;
% eventNumbers = NTSB.ev_id;
% 
% % Get n number vector from NTSB
% NTSB_n_numbers = NTSB.regis_no;
% og_NTSB_n_numbers = original_NTSB.RegistrationNumber;
% 
% % Clean the numbers (remove the first 'N' to make them match the FAA
% % format)
% for i = 1:length(NTSB_n_numbers)
%     NTSB_n_numbers{i,1} = NTSB_n_numbers{i}(2:end);
%     NTSB_n_numbers{i,1} = NTSB_n_numbers{i}(~isspace(NTSB_n_numbers{i}));
% end
% 
% for i = 1:length(og_NTSB_n_numbers)
%     og_NTSB_n_numbers{i,1} = og_NTSB_n_numbers{i}(2:end);
%     og_NTSB_n_numbers{i,1} = og_NTSB_n_numbers{i}(~isspace(og_NTSB_n_numbers{i}));
% end
% 
% % Match the event ID's from the new NTSB database to the old one in order to
% % combine their data
% for i=1:height(original_NTSB)
%    [tf] = ismember(eventNumbers, og_eventNumbers{i}(1:end-1));
%    CrashDate(tf,:)=original_NTSB{i,4};
%    CrashYear(tf,:)=original_NTSB{i,4}.Year;
%    CrashLocation(tf,:)=original_NTSB{i,5};
%    location=strsplit(original_NTSB{i,5}{1},',');
%    sizelocal = size(location);
%    if ~isempty(location{1})
%        CrashCity(tf,:) = location(1);
%        if sizelocal(2) > 1
%            if ~isempty(location{2})
%                CrashState(tf,:) = location(2);
%            end
%        end
%    end
%    CrashAirportCode(tf,:)=original_NTSB{i,9};
%    CrashAirport(tf,:)=original_NTSB{i,10};
%    CrashInjury(tf,:)=original_NTSB{i,11};
%    CrashDamage(tf,:)=original_NTSB{i,12};
%    CrashPurposeOfFlight(tf,:)=original_NTSB{i,22};
%    CrashPhaseOfFlight(tf,:)=original_NTSB{i,29};
%    waitbar(i/height(original_NTSB))
% end
% delete(f);
% 
% % Create a combined registry for sorting
% NTSB_Registry = table(NTSB_n_numbers, NTSB.acft_serial_no, CrashDamage,...
%     NTSB.acft_make, NTSB.acft_model, NTSB.acft_series, NTSB.acft_category,...
%     NTSB.homebuilt, NTSB.total_seats, NTSB.num_eng, NTSB.type_last_insp,...
%     NTSB.date_last_insp, NTSB.afm_hrs_last_insp, NTSB.afm_hrs,...
%     CrashPurposeOfFlight, CrashPhaseOfFlight, NTSB.acft_year,...
%     CrashDate, CrashYear, CrashLocation, CrashCity, CrashState,...
%     CrashAirportCode, CrashAirport, CrashInjury, 'VariableNames',...
%     {'N_Number_NTSB', 'Serial_Number_NTSB', 'Damage', 'Acft_Make', 'Acft_Model',...
%     'Acft_Series', 'Acft_Category', 'Homebuilt', 'Total_seats', 'Num_eng',...
%     'type_last_insp', 'date_last_insp', 'afm_hrs_last_insp', 'afm_hrs',...
%     'CrashPurposeOFFlight', 'CrashPhaseOfFlight', 'acft_year',...
%     'CrashDate', 'CrashYear', 'CrashLocation', 'CrashCity', 'CrashState',...
%     'CrashAirportCode', 'CrashAirport', 'CrashInjury'});
% 
%  % Sort the registry by serial number then n number
%  Sorted_NTSB_Registry = sortrows(NTSB_Registry, [2 1]);
% 
% % -------------------------------------------------------------------------
% % ********************************************************
% % *** MATCH FAA and NTSB by Serial Number AND N Number ***
% % ********************************************************
% 
% f = waitbar(0, 'Step 4 of 5: Matching FAA and NTSB data');
% % Create empty NTSB columns
% col1 = cell(height(Sorted_Registry),1); %1,2,3,4,5,6,7,8,11,15,19,20,21,22,23,24
% col9 = zeros(height(Sorted_Registry),1); %9 10 13 14 16 18
% col12 = NaT(height(Sorted_Registry),1); %12 17
% 
% % Create table with sorted FAA data and empty values for the NTSB columns
% Combined_Table_a = addvars(Sorted_Registry,col1,col1,col1,col1,col1,col1,col1,col1,col9,col9,col1,col12,...
%     col9,col9,col1,col1,col9,col12,col9,col1,col1,col1,col1,col1,col1,...%col1,col1,...
%     'NewVariableNames',[Sorted_NTSB_Registry.Properties.VariableNames]);
% 
% % Match the Serial and N number from combined NTSB to combined FAA
% [tf_serial_logical, tf_serial_index] = ismember(Sorted_Registry.Serial_Number,Sorted_NTSB_Registry.Serial_Number_NTSB);
% [tf_n_logical, tf_n_index] = ismember(Sorted_Registry.N_Number,Sorted_NTSB_Registry.N_Number_NTSB);
% 
% both_logical = tf_serial_logical & tf_n_logical;
% both_index = tf_n_index(both_logical);
% Combined_Table_a(both_logical,:) = [Sorted_Registry(both_logical,:), Sorted_NTSB_Registry(both_index,:)];
% Combined_Table_a.hascrashed = both_logical;
% 
% delete(f);
% 
% % -------------------------------------------------------------------------
% % *******************************************************
% % *** Add Engine and Aircraft data from FAA databases ***
% % *******************************************************
% 
% f = waitbar(0, 'Step 5 of 5: Adding Engine and Aircraft data');
% % 
% %Get all Engine Data
% [tf,pos] = ismember(Combined_Table_a.ENGcode,ENGINE{:,1});
% matched_pos = pos(tf);
% 
% %Get all Aircraft Data
% [tf_a,pos_a] = ismember(Combined_Table_a.MFRcode,ACFTREF{:,1});
% matched_pos_a = pos_a(tf_a);
% 
% %Preallocate
% ENG_Make = col1;
% ENG_Model = col1;
% ENG_Horsepower = col9;
% 
% ACFT_Make = col1;
% ACFT_Model = col1;
% ACFT_EngNo = col9;
% ACFT_NoSeats = col9;
% ACFT_Weight = col1;
% ACFT_Type = col1;
% 
% %Fill with data
% ENG_Make(tf,1)=ENGINE{matched_pos,2};
% ENG_Model(tf,1)=ENGINE{matched_pos,3};
% ENG_Horsepower(tf,1)=ENGINE{matched_pos,5};
% 
% ACFT_Make(tf_a,1) = ACFTREF{matched_pos_a,2};
% ACFT_Model(tf_a,1) = ACFTREF{matched_pos_a,3};
% ACFT_EngNo(tf_a,1) = ACFTREF{matched_pos_a,8};
% ACFT_NoSeats(tf_a,1) = ACFTREF{matched_pos_a,9};
% ACFT_Weight(tf_a,1) = ACFTREF{matched_pos_a,10};
% ACFT_Type(tf_a,1) = ACFTREF{matched_pos_a,4};
% 
% %Add engine and aircraft data to combined table
% Combined_Table_a.ENG_Make = ENG_Make;
% Combined_Table_a.ENG_Model = ENG_Model;
% Combined_Table_a.ENG_Horsepower = ENG_Horsepower;
% Combined_Table_a.ACFT_Make = ACFT_Make;
% Combined_Table_a.ACFT_Model = ACFT_Model;
% Combined_Table_a.ACFT_EngNo = ACFT_EngNo;
% Combined_Table_a.ACFT_NoSeats = ACFT_NoSeats;
% Combined_Table_a.ACFT_Weight = ACFT_Weight;
% Combined_Table_a.ACFT_Type = ACFT_Type;
% 
% delete(f);
% 
% % -------------------------------------------------------------------------
% % ******************************
% % *** Clean up the database! ***
% % ******************************

% %Remove non-unique plane instances (looking for both duplicate n-number and
% %serial numbers
% [~,idx]=unique(  strcat(Combined_Table_a.Serial_Number,Combined_Table_a.N_Number));
% No_duplicate_table = Combined_Table_a(idx,:);
% 
% %Only single engine
% single_eng_mask = No_duplicate_table.ACFT_EngNo == 1;
% 
% %Only fixed wing single engine
% fixed_single_mask = strcmp(No_duplicate_table.ACFT_Type,'4');
% 
% %Only keep data points if we know the engine type
% engine_not_empty_mask = ~cellfun('isempty', No_duplicate_table.ENG_Make);
% 
% %Keep only class 1 aircraft weights
% weight_mask = strcmp(No_duplicate_table.ACFT_Weight,'CLASS 1');
% 
% %Combine masks
% mask = single_eng_mask & fixed_single_mask & engine_not_empty_mask ...
%     & weight_mask;
% 
% %Filter the table
% filtered_table = No_duplicate_table(mask,:);
% 
% %Filter out uncommon engine types
% A = filtered_table.ENG_Make;
% [engine_makes,j,k] = unique(A);
% number_makes = histc(k,1:numel(j));
% common_engines = number_makes > 300;  %  <----------- CHANGE THIS TO ALLOW FOR MORE ENGINE TYPES
% common_eng_mask = ismember(A,engine_makes(common_engines));
% 
% filtered_table = filtered_table(common_eng_mask,:);
% 
% %Filter out experimental planes (I think?) and only report standard
% %certifications
% 
% %get rid of empty certifications
% not_empty_certs = ~cellfun('isempty', filtered_table.certification);
% filtered_table = filtered_table(not_empty_certs,:);
% 
% %get rid of certifications that aren't standard
% first_cert_nums = cellfun(@(x) x(1), filtered_table.certification, 'un', 0);
% standard_certs = strcmp('1',first_cert_nums);
% filtered_table = filtered_table(standard_certs,:);
% 
% %add age of plane and only positive ages
% planeAges = filtered_table.CrashYear - filtered_table.yearMFR;
% planeAges(~filtered_table.hascrashed) = 0;
% filtered_table.planeAge = planeAges;
% ageMask = (planeAges >= 0);
% filtered_table = filtered_table(ageMask,:);
% 
% %add hours of usage per year
% hours_per_year = filtered_table.afm_hrs ./ filtered_table.planeAge;
% filtered_table.hours_per_year = hours_per_year;
% 
% %Filter out uncommon aircraft types
% B = filtered_table.ACFT_Make;
% [aircraft_makes,ja,ka] = unique(B);
% number_a_makes = histc(ka,1:numel(ja));
% common_makes = number_a_makes > 300;  %  <----------- CHANGE THIS TO ALLOW FOR MORE AIRCRAFT TYPES
% common_air_mask = ismember(B,aircraft_makes(common_makes));
% 
% filtered_table = filtered_table(common_air_mask,:);

%Get just the accidents
% filtered_accidents_table = filtered_table(filtered_table.hascrashed,:);
% 
% writetable(filtered_table,'Dataset_Post_Cleaning.csv');
% writetable(filtered_accidents_table,'Dataset_Post_Cleaning_accidents.csv');

%Filter out uncommon aircraft models
C = filtered_table.ACFT_Model;
[aircraft_models,ja,ka] = unique(C);
number_a_models = histc(ka,1:numel(ja));
common_a_models = number_a_models > 300;  %  <----------- CHANGE THIS TO ALLOW FOR MORE AIRCRAFT TYPES
common_air_mask = ismember(B,aircraft_makes(common_makes));

% %Filter out uncommon engine models
% C = filtered_table.ACFT_Model;
% [aircraft_models,ja,ka] = unique(C);
% number_a_models = histc(ka,1:numel(ja));
% common_a_models = number_a_models > 300;  %  <----------- CHANGE THIS TO ALLOW FOR MORE AIRCRAFT TYPES
% common_air_mask = ismember(B,aircraft_makes(common_makes));




