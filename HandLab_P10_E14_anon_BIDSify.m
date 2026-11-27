%% EXPORT RAW DATA FROM P10_E14 TO BIDS FORMAT___________________________
% see README_BIDS.md
% 
addpath(genpath('/var/www/html/HandLabToolBox'));
addpath(genpath('/var/www/html/TMSMultiLab'));
addpath '/var/www/html/HandLab/P10_Imitation/P10_E14_BrainConnectivity';% for the across-experiment scripts
data_dir = '/var/www/html/TestData';                                    % where is the data going to be saved?
hl_dir = 'HandLab_P10_E14';                                             % top-level study directory
disp('exporting EMG data...');                                          % display info to screen
epoch = 2.0;                                                            % 1000ms before and after TMS
maxtimes = [-1, 0.99975];                                               % maximum timestamps - remove data beyond these limits
samplehz = 4000;
samples = epoch.*samplehz;
ps =  [       1,       2,      3,        4,        5,      6,        7,      8         9,     10,       11,       12]; % Participant number
hs =  [     NaN,     NaN,    NaN,      NaN,      NaN,    NaN,      NaN,    NaN,      NaN,    NaN,      NaN,      NaN]; % subject H numbers
age = [      46,      21,     21,       40,       33,     48,       25,     30,       20,     20,       24,       25]; % age in years
fem = [       0,       0,      0,        1,        0,      1,        1,      1,        0,      1,        0,        0]; % female? 0=male, 1=female
han = [       2,       0,      2,        2,        2,      2,        2,      2,        2,      2,        2,        2]; % left=0, ambi=1, right=2
hed = [ 38,36.5;   36,34;  38,38;    36,34;  40,39.5;  38,36;    36,39;  36,38;    42,40;  38,39;    38,39;    37,36;];% size of head in cm, L-R,N-I
rmt = [      55,      45,     52,       49,       48,     40,       70,    nan,       63,     46,       46,       54]; % resting motor threshold (%MSO)
amt = [      30,      30,     33,       28,       34,     21,       38,     75,       36,     30,       23,       38]; % active motor threshold (%MSO)
m1 =  [-5.5,1.5;-5.5,0.5; -5,0.5;     -5,1;     -5,1; -5.5,0;     -6,1;   -5,2;     -5,1; -5,0.5;     -5,1;     -5,1]; % M1 location, (RIGHT,ANTERIOR)
smg=[   -9,-2;   -9,-3;-8.5,-3;-8.5,-2.5;-8.5,-2.5;-9,-3.5;-9.5,-2.5;nan,nan;-8.5,-2.5;-8.5,-3;-8.5,-2.5;-8.5,-2.5];% SMG location, (RIGHT, ANTERIOR)
trials = 20;                                                            % TMS pulses in total, use variable t as index
poss = {'M1','SMG'};                                                    % All TMS positions
fs = [];                                                                % variable for data files
os = {'1','2','3','4','5','6','7'};                                     % different intensity labels (piggyback on the orientation variable)
ms = {'FDI-R','ADM-R','FDS-R','EDC-R'};                                 % muscles recorded from, use variable m as index
cs = {'Rest','Pegboard'};                                               % condition label(s)
tmstime = 1000;                                                         % TMS presented at this time, in ms relative to epoch onset
tmstime2 = round(tmstime./1000,2);                                      % TMS time in seconds

% experiment-specific
trigchan = 6;                                                           % number of the trigger channel
triglev = 3;                                                            % trigger level (typically 5V MAX)
emgchans = 2:5;                                                         % where's the EMG in the raw data?
P10_E14_latencies;                                                      % load the (manual) latency data (6=NH; 7=DG)


%% CHECK IF DATA DIRECTORY EXISTS________________________________________
if exist([data_dir,'/',hl_dir], 'dir')~=7
    mkdir([data_dir,'/',hl_dir]);
end


%% CHECK OR CREATE THE FILES_____________________________________________

%% BIDS GENERAL FILES____________________________________________________

%%  dataset_description.json_____________________________________________
if exist([data_dir,'/',hl_dir,'/dataset_description.json'], 'file')~=2  % create this manually - easier
    warning('dataset_description.json is missing');
end


%%  participants.tsv & participants.json_________________________________
if exist([data_dir,'/',hl_dir,'/participants.json'], 'file')~=2         % create this manually - easier
    warning('participants.json is missing');
end
participant_id = repmat({''},max(ps),1);                                % initialise the participant ID variable
species = repmat({'homo sapiens'},max(ps),1);                           % initialise the species variable
sex = {'M','F'};                                                        % codes for 0, 1
sex = sex(fem+1)';                                                      % participant sex
handedness = {'L','A','R'};                                             % codes for 0, 1, 2
handedness = handedness(han+1)';                                        % participant handedness
ear2ear = hed(:,1);                                                     % distance from left to right helix-tragus intersection
nas2in = hed(:,2);                                                      % distance from nasion to inion
m1lat = m1(:,1);                                                        % distance from vertex to M1 stimulation site, lateral
m1ant = m1(:,2);                                                        % distance from vertex to M1 stimulation site, anterior
smglat = smg(:,1);                                                      % distance from vertex to SMG stimulation site, lateral
smgant = smg(:,2);                                                      % distance from vertex to SMG stimulation site, anterior
% rotate some variables
age = age';
rmt = rmt';
amt = amt';


%% BIDS-EMG FILES________________________________________________________

%% check if _emg.json files exist________________________________________
if exist([data_dir,'/',hl_dir,'/task-rest_emg.json'], 'file')~=2
    warning('task-rest_emg.json is missing');
end
if exist([data_dir,'/',hl_dir,'/task-pegboard_emg.json'], 'file')~=2
    warning('task-pegboard_emg.json is missing');
end


%%  *_channels.tsv - applies to all datafiles, so written into top directory
name = {'time', ms{:}, 'TMS'}';
type = {'LATENCY'; 'EMG'; 'EMG'; 'EMG'; 'EMG'; 'TRIG'};
units = {'s'; 'mV'; 'mV'; 'mV'; 'mV'; 'V'};
signal_electrode = {'n/a', ms{:}, 'n/a'}';
reference = {'n/a'; 'bipolar'; 'bipolar'; 'bipolar'; 'bipolar'; 'n/a'};
group = {'n/a'; 'amp1'; 'amp1'; 'amp2'; 'amp2'; 'n/a'};
target_muscle = {'n/a'; 'right FDI'; 'right ADM'; 'right FDS'; 'right EDC'; 'n/a'};
description = {'time to TMS'; 'target muscle'; 'nontarget muscle'; 'nontarget muscle'; 'nontarget muscle'; 'TMS 5V TLL'};
channels = table(name, type, units, signal_electrode, reference, group, target_muscle, description);% build the channels table
writetable(channels, [data_dir,'/',hl_dir,'/channels.tsv'], 'FileType', 'Text', 'Delimiter', '\t');% save channels.tsv


%%  *_electrodes.tsv/.json - for *measured* electrode positions only; otherwise include in *_emg
%%  *_coordsystem.json - required if electrodes.tsv/.json is given


%% check if _events.json file exist_______________________________________
if exist([data_dir,'/',hl_dir,'/events.json'], 'file')~=2
    warning('events.json is missing');
end


%% BIDS NIBS FILES________________________________________________________

%% nibs.tsv file defaults_________________________________________________
nibs_event_id = {'spTMS'};
nibs_type = {'TMS'};
stimulator_id = {'Magstim'};
nibs_element_id = {'Fig8_70mm'};
stimulus_shape = {'Monophasic'};
%first_inflection = 'rising'                % CHECK THIS
current_direction = {'co-cl'};                 % CHECK THIS
%electric_field_target = 
%electric_field_max = 
stimulus_duration = 0;
intensity_reference = {'absolute'};
intensity_scaling = {'absolute'};              
%pattern1_count = 'n/a';
%pattern1_interval = 'n/a';
%pattern1_frequency = 'n/a';
%pattern1_duration = 'n/a';
%pattern1_intensity = 'n/a';
% stimulus_validation                        % CHECK THIS
subject_feedback = {'n/a'};
%status
%status_description
%timestamp
%electric_field_units
%electric_field_model_name
%electric_field_model_version


%% markers.tsv file defaults_____________________________________________
nibs_element_id = {'Fig8_70mm'};


%% coordsystem.json file defaults________________________________________
coordsystem.NIBSCoordinateSystem = "10:20";
coordsystem.NIBSCoordinateUnits = "cm";
coordsystem.HeadDimensionsAxes = {["left helix-tragus intersection","vertex", "right helix-tragus intersection"];["inion", "vertex", "nasion"];["nasion", "left helix-tragus intersection", "inion", "right helix-tragus intersection", "nasion"]};
coordsystem.HeadMeasurementsLandmark = "Vertex";
coordsystem.HeadMeasurementsAxes = ["lateral", "anterior"];
coordsystem.HeadMeasurementsUnits = ["cm", "cm"];
coordsystem.HeadMeasurementsDescription = "measured in a straight line with a flexible tape along the scalp from the vertex, first lateral, then anterior, parallel to the x- and y-axes respectively";
                

%% START THE PROCESSING__________________________________________________
for p = ps

    if p==1
        v=2;
    else
        v=1;                                                                % visit =1 for most Ps
    end
    disp(['P',int2str(p),'...']);
    if p<10
        pstr = ['sub-0',int2str(p)];
    else
        pstr = ['sub-',int2str(p)];
    end
    participant_id{p} = pstr;

    % check if the participant directory exists_________________________
    if exist([data_dir,'/',hl_dir,'/',pstr], 'dir')~=7
        mkdir([data_dir,'/',hl_dir,'/',pstr]);
    end
    
    % check if the emg directory exists_________________________________
    if exist([data_dir,'/',hl_dir,'/',pstr,'/emg'], 'dir')~=7
        mkdir([data_dir,'/',hl_dir,'/',pstr,'/emg']);
    end

    % check if the nibs directory exists________________________________
    if exist([data_dir,'/',hl_dir,'/',pstr,'/nibs'], 'dir')~=7
        mkdir([data_dir,'/',hl_dir,'/',pstr,'/nibs']);
    end
    
    % set up the Scans file_____________________________________________
    filename = {''};                                                    % filename - with modality folder
    acq_time = {''};                                                    % YYYY-MM-DDThh:mm:ss[.000000][Z|+hh:mm|-hh:mm]; YEAR can be shifted to <=1925 to preserve anonymity
    f = 0;                                                              % for counting filenames

    for c = 1:2                                                         % for each condition (rest, pegboard)
        disp([' C',int2str(c),': ',cs{c},'...']);
        folder = ['data/raw/S',int2str(p),'_H',int2str(hs(p)),'_V',int2str(v),'/'];% folder for the data
        for po = 1:numel(poss)                                          % for each position, M1, SMG
            fs = dir(['/var/www/html/HandLab/P10_Imitation/P10_E14_BrainConnectivity/',folder,'S',int2str(p),'_H',int2str(hs(p)),'*_',poss{po},'_',cs{c},'.txt']);% list the files
            for o = 1:size(fs,1)                                        % for each of the 'orientations' (intensities)
                f = f+1;                                                % increment the file counter

                % open the file in .txt format__________________________
                data = hl_powerlab_import([fs(o).folder,'/',fs(o).name],7); % import data; 1 file per position, condition, intensity: 1=sample, 2-5=EMG, 6=TMS
                data = data(:,1:6);                                     % remove redundant trigger channel

                % exclude any additional timepoints_____________________
                ix = data(:,1)>=maxtimes(1) & data(:,1)<=maxtimes(2);   % find datapoints beyond the intended sample range
                data = data(ix,:);                                        % exclude

                % build scan details____________________________________
                tmp = fs(o).name;
                offset = 4 + numel(num2str(p)) + numel(num2str(hs(p))); % how many characters before the TMS intensity
                intensity = tmp([1:2]+offset);
                filenames{f,1} = ['emg/',pstr, '_task-', lower(cs{c}), '_acq-', poss{po}, intensity, '.edf+'];
                acq_times{f,1} = datetime(fs(o).date, 'Format', 'yyyy-MM-dd''T''HH:mm:ss');               
                
                % extract the TMS triggers______________________________
                trig = diff(data(:,trigchan)>triglev);                  % samples above trigger level
                trig(trig==-1) = 0;                                     % remove the ends of triggers
                tmss = find(diff(trig)==1)+1;                           % triggers changing from below to above
                
                % define some variables_________________________________
                trials2 = size(tmss,1);                                 % trials2 = real number of trials in this dataset
                onset = tmss./(samplehz);                               % onsets in s
                duration = zeros(trials2,1);                            % event duration in s
                nibs_event_id = repmat({'spTMS'}, trials2, 1);          % event ID
                nibs_position_id = repmat(poss{po}, trials2, 1);        % position ID
                
                
                %% WRITE THE EVENTS TABLE TO FILE________________________
                events = table(onset, duration, nibs_event_id, nibs_position_id);% build the events table
                writetable(events, [data_dir,'/',hl_dir,'/',pstr,'/emg/',pstr,'_task-', lower(cs{c}), '_acq-', poss{po}, intensity, '_events.tsv'], 'FileType', 'Text', 'Delimiter', '\t');% save events.tsv
                
                
                %% BUILD THE NIBS.tsv____________________________________
                stimulus_intensity = str2num(intensity);
                stimulus_count = trials2;
                stimulus_description = {['single pulse TMS at ', intensity, '% MSO']};
                
                
                %% WRITE THE NIBS TABLE TO FILE__________________________
                nibs_event_id = {nibs_event_id{1}};
                nibs = table(nibs_event_id, nibs_type, stimulator_id, nibs_element_id, stimulus_shape, current_direction, stimulus_intensity, stimulus_duration, intensity_reference, intensity_scaling, stimulus_count, subject_feedback, stimulus_description);% build the nibs table
                writetable(nibs, [data_dir,'/',hl_dir,'/',pstr,'/nibs/',pstr,'_task-', lower(cs{c}), '_acq-', poss{po}, intensity, '_nibs.tsv'], 'FileType', 'Text', 'Delimiter', '\t');% save nibs.tsv


                %% BUILD THE MARKERS FILE________________________________
                switch po
                
                    case 1
                        position_label = {'M1_FDI_L'};
                        position_description = {'Optimal scalp location for left hand FDI MEPs'};
                        if isfinite(m1(p,1))
                            element_centre_x = m1(p,1);
                        else
                            element_centre_x = {'n/a'};
                        end
                        if isfinite(m1(p,2))
                            element_centre_y = m1(p,2);
                        else
                            element_centre_y = {'n/a'};
                        end
                        target_label = {'M1_FDI_L'};
                        
                    case 2
                        position_label = {'SMG_L'};
                        position_description = {'Estimated location of SMG_L, based on neuronavigation measurements where available'};
                        if isfinite(smg(p,1))
                            element_centre_x = smg(p,1);
                        else
                            element_centre_x = {'n/a'};
                        end
                        if isfinite(smg(p,2))
                            element_centre_y = smg(p,2);
                        else
                            element_centre_y = {'n/a'};
                        end
                        element_centre_x = smg(p,1);
                        element_centre_y = smg(p,2);
                        target_label = {'SMG_L'};
                end    


                %% WRITE THE MARKERS TABLE TO FILE_______________________
                nibs_position_id = {nibs_position_id(1,:)};
                markers = table({nibs_position_id(1,:)}, nibs_element_id, position_label, position_description, element_centre_x, element_centre_y, target_label);% build the markers table
                writetable(markers, [data_dir, '/', hl_dir, '/', pstr, '/nibs/', pstr, '_task-', lower(cs{c}), '_acq-', poss{po}, intensity, '_markers.tsv'], 'FileType', 'Text', 'Delimiter', '\t');% save markers.tsv

                
                %% BUILD THE COORDSYSTEM FILE____________________________
                coordsystem.HeadDimensions = [hed(p,1), hed(p,2)];
                coordsystem.HeadMeasurements = [element_centre_x, element_centre_y];
                coordsystemjson = jsonencode(coordsystem, PrettyPrint=true);
                
                
                %% WRITE THE COORDSYSTEM TO FILE_________________________
                fid = fopen([data_dir, '/', hl_dir, '/', pstr, '/nibs/', pstr, '_task-', lower(cs{c}), '_acq-', poss{po}, intensity, '_coordsystem.json'],'w');
                fprintf(fid, '%s', coordsystemjson);
                fclose(fid);
                

                %% CONVERT DATA TO EDF+ FORMAT___________________________
                % https://www.edfplus.info/index.html                     % the data specification
                % https://www.neutronicsai.com/learn/analyze-edf-files    % some HELP
                % https://www.teuniz.net/edfbrowser/edf%20format%20description.html % some more help
                % https://uk.mathworks.com/help/signal/ref/edfread.html   % Matlab's EDF READ function
                % https://uk.mathworks.com/help/signal/ref/edfheader.html % Matlab's EDF header structure (REFERENCE ONLY - CONTAINS METADATA!)
                % https://uk.mathworks.com/help/signal/ref/edfinfo.html   % Matlab's EDF INFO function - get info from .edf file
                % https://uk.mathworks.com/help/signal/ref/edfwrite.html  % Matlab's EDF WRITE function - write edf data and header to file
                % https://uk.mathworks.com/help/signal/ref/edffileanalyzer-app.html % Matlab's EDF APP
                % https://uk.mathworks.com/matlabcentral/answers/2149469-write-the-timetable-data-to-the-edf-file - tutorial including timetable structure
                
                
                %% BUILD THE EDF+ HEADER_________________________________
                hdr = edfheader("EDF+");                                % check the details!
                hdr.Patient = ['S',int2str(p),' ',sex{p},' X X'];       % subject ID, sex, birthdate, name
                hdr.Recording = ['Startdate ',upper(datestr(fs(o).date, "dd-mmm-yyyy")),' P10_E14 NH PowerLab_16_30_spTMS'];% recording info
                hdr.StartDate = datestr(fs(o).date, "dd.mm.yy");        % recording date
                hdr.StartTime = datestr(fs(o).date, "HH.MM.SS");        % recording time
                hdr.NumSignals = size(data,2);                          % N channels in data
                hdr.SignalLabels = ["Time", ms, "TMS"];                 % Channel labels
                hdr.TransducerTypes = ["na" "AgAgCl electrode", "AgAgCl electrode", "AgAgCl electrode", "AgAgCl electrode", "TTL 5V"];% transducer labels
                hdr.PhysicalDimensions = ["s", "mV", "mV", "mV", "mV", "V"];% physical units of signals
                hdr.PhysicalMin = [-1 -10 -10 -10 -10 -10];             % minimum possible signal recordable (in physical units)
                hdr.PhysicalMax = [ 1  10  10  10  10  10];             % maximum possible signal recordable (in physical units)        
                hdr.DigitalMin = repmat(-32000, 1, hdr.NumSignals);     % digital encoding minimum (e.g., 16bit will be ~-32768)
                hdr.DigitalMax = repmat( 32000, 1, hdr.NumSignals);     % digital encoding minimum (e.g., 16bit will be ~+32767)
                hdr.Prefilter = ["na", "10-2000Hz bandpass", "10-2000Hz bandpass", "10-2000Hz bandpass", "10-2000Hz bandpass", "na"]; % CHECK THIS!
                %hdr.SignalReserved                                     % reserved for something...
                
                %% CONTINUOUS OR DISCONTINUOUS__________________________
                hdr.Reserved = "EDF+D";                                 % EDF+C = continuous; EDF+D = discontinuous
                switch hdr.Reserved

                    case "EDF+C"                                        % for continuous recordings
                        hdr.NumDataRecords = 1;                         % number of data records (PowerLab parses each to 1000 samples; here: 8000 = 1 trial; EDF+C = all the data)
                        hdr.DataRecordDuration = seconds(trials2.*samples./samplehz);% recording duration per record                  

                    case "EDF+D"                                        % for discontinuous recordings
                        hdr.NumDataRecords = trials2;                   % number of data records (PowerLab parses each to 1000 samples; here: 8000 = 1 trial; EDF+D = all the data)
                        hdr.DataRecordDuration = seconds(samples./samplehz);% recording duration per record
                        DataRecordTimes = seconds(0:5:5.*(trials2-1));  % required for EDF+D discontinuous recordings (assume ~5s gap between starts)     

                end

                
                %% WRITE THE DATA TO EDF+ FILE___________________________
                % https://uk.mathworks.com/help/signal/ref/edfwrite.html
                % edfw = edfwrite(fileName, hdr, sigData) % creates an edfwrite object and a new EDF or EDF+ file with signal data, sigData. File properties are specified in the header structure, hdr
                filename = [data_dir, '/', hl_dir, '/', pstr, '/emg/', pstr, '_task-', lower(cs{c}), '_acq-', poss{po}, tmp([1:2]+offset), '_emg.edf'];
                switch hdr.Reserved
                    case "EDF+C"
                        edfw = edfwrite(filename, hdr, data, 'InputSampleType', 'physical');

                    case "EDF+D"
                        edfw = edfwrite(filename, hdr, data, 'InputSampleType', 'physical', 'DataRecordTimes', DataRecordTimes);
                end
                
            end                                                         % of intensity loop
        end                                                             % of position loop
    end                                                                 % of condition loop
    
    
    %% WRITE THE SCANS TABLE TO FILE_____________________________________
    scans = table(filenames, acq_times);                                % build the scans table
    writetable(scans, [data_dir,'/',hl_dir,'/',pstr,'/',pstr,'_scans.tsv',], 'FileType', 'Text', 'Delimiter', '\t');% save scans.tsv
    
end                                                                     % of subject loop


%% WRITE THE PARTICIPANTS TABLE TO FILE__________________________________
participants = table(participant_id, species, age, sex, handedness, ear2ear, nas2in, rmt, amt, m1lat, m1ant, smglat, smgant);
writetable(participants, [data_dir,'/',hl_dir,'/participants.tsv'], 'FileType', 'Text', 'Delimiter', '\t');
