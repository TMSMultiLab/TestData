%% HOW TO BIDSIFY YOUR DATASET__________________________________
%
% GUIDANCE
% READ THESE:
%   https://bids-specification.readthedocs.io/en/stable/common-principles.html
%   https://bids-specification.readthedocs.io/en/stable/modality-specific-files/electromyography.html
%   https://www.edfplus.info/
%   https://www.biosemi.com/faq/file_format.htm
%
% Do not include white spaces in file names: They make scripting harder.
% Use only letters, numbers, hyphens, and underscores: Some operating systems cannot handle special characters.
% Do not rely on letter case (UPPERCASE and lowercase): For some operating systems a is the same as A.
% Use separators and case in a systematic and meaningful way: thisIsCamelCase, this_is_snake_case
% key1 - value1 _ key2 - value2 _ suffix .extension
% Suffixes are preceded by an underscore
% Entities are composed of key-value pairs separated by underscores
% There is a limited set of suffixes for each data type (anat, func, eeg, ...)
% For a given suffix, some entities are required and some others are [optional].
% Entity keys and suffixes can only contain letters and/or numbers.
% Entity values can only contain letters and/or numbers and/or the "+" character.
% Entity key-value pairs have a specific order in which they must appear in filename.
% Some entities key-value can only be used for derivative data
%
%
% VALIDATION
% check .json file formatting by opening in a web browser - should appear as a nice table without any errors


%% ALL BIDS REQUIRE THE FOLLOWING FILES__________________________
%

%% DATASET_DESCRIPTION FILES_____________________________________
% https://bids-specification.readthedocs.io/en/stable/modality-agnostic-files/dataset-description.html
%
%	dataset_description.json
%		Name				REQUIRED
%		BIDSVersion			REQUIRED
%
%		HEDVersion			RECOMMENDED
%		DatasetType			RECOMMENDED
%		License				RECOMMENDED
%		Authors				RECOMMENDED
%		GeneratedBy			RECOMMENDED	[object]		provenance of the dataset, eg derivitives generated manually or by code
%		SourceDatasets			RECOMMENDED	[objects]		URLs  / DOIs to the original data
%
%		DatasetLinks			OPTIONAL				BIDS URIs
%		Keywords			OPTIONAL				free text
%		Acknowledgements		OPTIONAL				other people/institutions not included in Authors or funding
%		HowToAcknowledge		OPTIONAL				how should re-users of the dataset acknowledge the authors
%		Funding				OPTIONAL				list of funding sources - grant numbers
%		EthicsApprovals			OPTIONAL				ethics approval committee / ID; protocol numbers
%		ReferencesAndLinks		OPTIONAL				references to additional information about the data / URLs
%		DatasetDOI			OPTIONAL				full URI to the doi (https://doi.org/...)

% 	README[.md|.rst|.txt]			REQUIRED				plain text description of the dataset
%	CITATION.cff				OPTIONAL
%	CHANGES					OPTIONAL				must follow CPAN changelog conventions
%	LICENSE[.md|.rst|.txt]			OPTIONAL				plain text descriptipon; must match the dataset_description licence field


%% DATA SUMMARY FILES____________________________________________
% https://bids-specification.readthedocs.io/en/stable/modality-agnostic-files/data-summary-files.html
%	participants.tsv			RECOMMENDED				eg age, sex, handedness, species and strain
%		participant_id			REQUIRED				first column, sub-01..., unique single row per P
%
%		species				RECOMMENDED	homo sapiens		
%		age				RECOMMENDED				number in years. for ages>88, use 89+; avoid months/weeks unless eg babies/animals
%		sex				RECOMMENDED				"male" "female" "other"
%		handedness			RECOMMENDED				"L", "R", "A" (case-insensitive, also 'left' 'right' 'ambidextrous'
%		strain				RECOMMENDED
%		strain_rrid			RECOMMENDED
%
%		HED				OPTIONAL
%		[additional columns]		OPTIONAL				any other columns must be described in meta-data file
%
%	participants.json			RECOMMENDED				for each column above, free text description, eg:
%		{
%			"age": {
%			"Description": "age of the participant",
%			"Units": "year"
%		}
%  
% Samples file					OPTIONAL				for biological samples
%	samples.tsv
%	samples.json
%
% Scans file					OPTIONAL				one row per datafile
%	*_scans.tsv
%		filename			REQUIRED				relative paths, first column
%		acq_time			OPTIONAL				YYYY-MM-DDThh:mm:ss[.000000][Z|+hh:mm|-hh:mm]; YEAR can be shifted to <=1925 to preserve anonymity
%		HED				OPTIONAL				
%
%       *_scans.json
%
% Sessions file
%	*_sessions.tsv				OPTIONAL				if multiple sessions per participant
%		session_id			REQUIRED				1st column, unique ID/number for this session, one file per participant
%
%		pathology			RECOMMENDED
%
%		acq_time			OPTIONAL
%		HED		EMGCoordinateSystem		OPTIONAL
%		[additional columns]		OPTIONAL				any other columns must be described in meta-data file


% PHENOTYPE AND ASSESSMENT FILES___________________________				eg survey results / quesitonnaires too big for participants files
% https://bids-specification.readthedocs.io/en/stable/modality-agnostic-files/phenotypic-and-assessment-data.html
%	phenotype/<measurement_tool_name>.tsv						
%	phenotype/<measurement_tool_name>.json


% CODE_____________________________________________________
% https://bids-specification.readthedocs.io/en/stable/modality-agnostic-files/code.html
%
%	code/*					OPTIONAL		


% EVENTS___________________________________________________
% https://bids-specification.readthedocs.io/en/stable/modality-agnostic-files/events.html
% 
%       *_events.json				OPTIONAL				see individual modalities for guidance
%       *_events.tsv				OPTIONAL
%		onset				REQUIRED				1st column, number, seconds from the start of this acquisition (the first stored datapoint)
%		duration			REQUIRED				2nd column, number, duration of event, where 0 = an impulse (e.g. TMS)

%		trial_type			OPTIONAL				experimental conditions
%		response_time			OPTIONAL				in seconds, n/a = missed (relative to stimulus?)
%		HED				OPTIONAL
%		stim_file			OPTIONAL				location of stimuli in /stimuli/ directory
%		channel				OPTIONAL				e.g. EEG/EMG/MEG/NIRS - when a specific channel is associated with the event
%		[additional columns]		OPTIONAL				any other columns must be described in meta-data file


%% ------------------------------------------------------------------------------------------------- %%

%% EMG BIDS (BEP 042) REQUIRES THE FOLLOWING FILES_______________

%% EMG FILE NAMING_________________________________________________________
% sub-<label>[_ses-<label>]_task-<label>[_acq-<label>][_run-<index>][_recording-<label>]_
% eg:
% sub-01_ses-01_task-rest_acq-M125_run2_recording-highres.edf
% sub-01_ses-01_task-pegboard_acq-SMG45.edf
%
% _acq - main parameters?
% _run-1, _run-2 etc - repeats of the same acquisition parameters and conditions
% _recording-sEMG, _recording-HDEMG - when multple recordings taken at the same time


% https://bids-specification.readthedocs.io/en/stable/modality-specific-files/electromyography.html
%
%	*_emg.edf
%
%
%	*_emg.json
%		EMGPlacementScheme		REQUIRED 	"Other"			Must be one of: "ChannelSpecific", "Measured", "Other".
%		EMGPlacementSchemeDescription	REQUIRED 	"[description]"		if 'Other' above - description of general scheme, not muscle-specific
%		EMGReference			REQUIRED 	"ChannelSpecific"	(Bipolar is for fixed width electrodes
%		SamplingFrequency		REQUIRED	4000
%		PowerLineFrequency		REQUIRED	50
%		RecordingType			REQUIRED	"epoched"		Must be one of: "continuous", "epoched", "discontinuous".
%		SoftwareFilters			REQUIRED	"n/a"			"n/a" or object with details
%		TaskName			REQUIRED	"rest" / "pegboard"	eg "faces n-back", "head nodding", "treatment", "control", "sleep"
%		[additional columns]		OPTIONAL				any other columns must be described in meta-data file
%
%		TaskDescription			RECOMMENDED
%		Instructions			RECOMMENDED				eg "seated", "reclined"
%		EMGChannelCount			RECOMMENDED	4			integer
%		HardwareFilters			RECOMMENDED	{"Highpass filter": {"Cutoff (Hz)": 10"}, "Lowpass filter": {"Cutoff (Hz)": 2000"}}.
%		RecordingDuration		RECOMMENDED				integer
%		EpochLength			RECOMMENDED	2			duration in seconds
%		Manufacturer			RECOMMENDED	"AD Instruments"
%		ManufacturersModelName		RECOMMENDED	"PowerLab 16/30"
%		SoftwareVersions		RECOMMENDED	"LabChart 8"
%		DeviceSerialNumber		RECOMMENDED
%		ElectrodeManufacturer		RECOMMENDED	
%		ElectrodeManufacturersModelName	RECOMMENDED	
%		InstitutionName			RECOMMENDED	"University of Birmingham"
%		InstitutionAddress		RECOMMENDED	"Edgbaston, Birmingham, B15 2TT, UK"
%		InstitutionalDepartmentName	RECOMMENDED	"School of Sport, Exercise and Rehabilitation Sciences"
%
%		ElectrodeMaterial		OPTIONAL	"Ag/AgCl"		eg Tin, Ag/AgCl, Gold
%		ElectrodeType			OPTIONAL	"nipple"		eg cup, ring, clip-on, wire, needle
%		EMGGround			OPTIONAL				eg "right radial styloid process"
%		Gain				OPTIONAL				gain between electrode and the DAQ
%		InterelectrodeDistance		OPTIONAL	2.5			distance (in cm?) between electrode centres
%		Preamplification		OPTIONAL				pre-amp within the sensor?
%		SkinPreparation			OPTIONAL	"alcohol wipe" 		eg "alcohol wipe" or "abrasive gel"
%		SubjectArtefactDescription	OPTIONAL	"n/a"			eg "Vagus Nerve Stimulator", "non-removable implant"; "n/a" - no major artefacts
%		TriggerChannelCount		OPTIONAL	2			N channels with digital or analogue triggers
%
%
%	*_channels.tsv
%		name				REQUIRED	"time" / "right FDI"	1st column, unique name for this channel
%		type				REQUIRED	LATENCY	/ EMG / TRIG	2nd column, UPPER CASE, MUST BE: ECG / EMG / EOG / HEOG / LATENCY / MISC / REF / SYSCLOCK / TRIG / VEOG
%		units				REQUIRED	"s" / "V"		3rd column, physical units
%
%		signal_electrode		RECOMMENDED				for bipolar devices - same as channel name?
%		reference			RECOMMENDED	"bipolar"		
%		group				RECOMMENDED	"device1"		eg when electrodes are clustered together within a device
%		target_muscle			RECOMMENDED	"left fdi"; "flexors"	
%		placement_scheme		RECOMMENDED	"other"			must be: "measured", "other"
%		placement_description		RECOMMENDED				description
%		interelectrode_distance		RECOMMENDED	
%
%		description			OPTIONAL				free text, eg: n/a, stimulus, response, skin conductance, battery status
%		sampling_frequency		OPTIONAL	4000			(not needed if specified in _emg.json)
%		low_cutoff			OPTIONAL	10			number
%		high_cutoff			OPTIONAL	2000			number
%		notch				OPTIONAL	"n/a"			eg 50, 60, [60, 120, 180]
%		status				OPTIONAL	"good"			must be "good" or "bad"
%		status_description		OPTIONAL				free text for why it's bad
%		[additional columns]		OPTIONAL				any other columns must be described in meta-data file
%
%
%	*_electrodes.tsv
%		name				REQUIRED
%		x				REQUIRED
%		y				REQUIRED
%
%		coordinate_system		RECOMMENDED
%		type				RECOMMENDED
%		material			RECOMMENDED
%		impedance			RECOMMENDED
%		group				RECOMMENDED	"device1"		name and group combination must be unique; matches *_channels.tsv
%
%		z				OPTIONAL
%		[additional columns]		OPTIONAL				any other columns must be described in meta-data file
%
%
%	*_coordsystem.json								REQUIRED if *_electrodes.json used
%		EMGCoordinateSystem		REQUIRED	"other"			"Other" is the only valid value until standardized names become available for EMG coordinate systems
%		EMGCoordinateUnits		REQUIRED	"n/a"			Must be one of: "m", "mm", "cm", "percent", "n/a".
%		EMGCoordinateSystemDescription	REQUIRED	[description]		
%
%		ParentCoordinateSystem		OPTIONAL
%		AnchorCoordinates		OPTIONAL				(required if parent system used)
%		AnchorElectrode			OPTIONAL				(required if parent system used)
%
%
%	*_photo.<extension>			OPTIONAL				photo of the montage


%% ------------------------------------------------------------------------------------------------- %%

%% NIBS BIDS (BEP 037) REQUIRES THE FOLLOWING FILES_______________

%% v6.3 https://github.com/nigelrogasch/nibs-bids/blob/master/specification/nibs-bids.md

% nibs/
% 	*_coordsystem.json				Coordinate system, fiducials, and anatomical landmarks for the positions in *_markers.tsv

% 	*_nibs.tsv		Temporal parameters	One row per unique stimulation parameter set. The sidecar also holds the device, intensity, and navigation metadata
%		nibs_event_id				Defined once here, can be reused multiple times in events.tsv
%		nibs_element_id				
%		stimulator_id				
%		intensity_reference

% 	*_nibs.json
%		ElementSet
%			ElementID
%		StimulatorSet
%			StimulatorID
%		IntensitySet
%			IntensityID
%		IntendedFor				points to the events.tsv in EMG directory

% 	*_markers.tsv		Spatial parameters 	One row per element position
%		nibs_position_id			Unique set of positions, can be reused multiple times in events.tsv
%		nibs_element_id

%	*_markers.json

% 	*_events.tsv		Timeline		Only when NIBS is stand-alone
%		nibs_event_id
%		nibs_position_id
%
% 	*_events.json

%	Optional
%	*_headshape.<ext>
%	*_photo.<ext>

% DELIMITERS {"nibs_element_id": {"Delimiter": "|"}}

% FORMATS    {"Format": "number"}

% To read a dataset, take a row of *_events.tsv, follow its nibs_event_id to the temporal parameters in *_nibs.tsv, and follow its nibs_position_id to the placement or placements in *_markers.tsv.


% EVENTS_________________________________________________________
% *_events.tsv / *_events.json (timeline)
%		onset 				REQUIRED 	number		same as EMG
%		duration 			REQUIRED 	number		same as EMG
%		nibs_event_id 			REQUIRED 	string
%		nibs_position_id 		OPTIONAL 	string


% NIBS___________________________________________________________
% *_nibs.tsv / 
% 		nibs_event_id 			REQUIRED 	string		must be unique
%		nibs_type 			REQUIRED 	string		one of: TMS, tES, TUS, PNS

%		stimulator_id 			RECOMMENDED 	string		The device, references StimulatorSet.StimulatorID in *_nibs.json
%		nibs_element_id 		RECOMMENDED 	string		The coil / element
%		stimulus_shape 			RECOMMENDED 	string		TMS: Monophasic, Biphasic, and Halfsine (uses first_inflection and current_direction)
%										TES: Rectangle (uses ramp_up and ramp_down), Sinusoid (uses frequency, starting_phase, and offset), Noise (uses noise_type, frequency_low, frequency_high, and distribution)
%										TUS: Sinusoid; ANY: Custom (requires stimulus_description)

% THE STIMULUS INTENSITY_________________________________________
%		stimulus_intensity 		RECOMMENDED 	number		
%		stimulus_duration 		RECOMMENDED 	number
%		intensity_reference 		OPTIONAL 	string		rMT, aMT, 1mV, e-field, absolute	References IntensitySet.IntensityID in *_nibs.json
%		intensity_scaling 		OPTIONAL 	number/string	multiplier of the reference - e.g. 0.8 for 80%; or absolute, when reference is absolute

% THE STIMULUS PATTERN___________________________________________
%		pattern<index>_count 		OPTIONAL 	number		for pattern1_ the base number of stimuli; for higher-order patterns, the number of repeats of the pattern(n-1)
%		pattern<index>_interval 	OPTIONAL 	number		onset-to-onset interval between consecutive pattern(n-1) repeats
%		pattern<index>_frequency 	OPTIONAL 	number		frequency - equal to 1/pattern(n)_interval
%		pattern<index>_duration 	OPTIONAL 	number		total duration of this layer, *including the interval after the final unit*
%		pattern<index>_intensity 	OPTIONAL 	number		if intensity changes, then list of intensities separated by | - must equal the count; n/a at the first level

% OTHERS_________________________________________________________
%		stimulus_count 			OPTIONAL 	number		total number of repeats of the pattern specification to this stimulation position
%		stimulus_validation 		OPTIONAL 	string		one of: verified, observed, not_verified, unknown
%		subject_feedback 		OPTIONAL 	string		Participant-reported perception or discomfort
%		status 				OPTIONAL 	string		Data-quality flag for the row
%		status_description 		OPTIONAL 	string		Free-text explanation of status
%		timestamp 			OPTIONAL 	string		ISO 8601 time at which the stimulation occurred or was logged
%		electric_field_units 		OPTIONAL 	string		units - V/m
%		electric_field_model_name 	OPTIONAL 	string		source model or system
%		electric_field_model_version 	OPTIONAL 	string		version

% TMS PARAMETERS_________________________________________________
%		first_inflection 		OPTIONAL 	string		rising or descending
%		current_direction 		OPTIONAL 	string		cl	circular coil, single winding, clockwise from above					QUERY HANDLE ORIENTATION HERE
%										co	circular coil, single winding, counter-clockwise from above
%										cl-co	figure-of-8 coil, left-right wings
%										co-cl	figure-of-8-coil, left-right wings
%										other	requires Levels.other in nibs.json
%		electric_field_target 		OPTIONAL 	number		electric field at the target site (eg, reported by neuronavigator)
%		electric_field_max 		OPTIONAL 	number		peak field


% TES PARAMETERS_________________________________________________
%		contact_impedance 		OPTIONAL 	number		measured impedence
%		measured_current_intensity 	OPTIONAL 	number		device-reported
%		measured_voltage_intensity 	OPTIONAL 	number		device-reported
%		current_statistics 		OPTIONAL 	string		summar stats

% TES / TFUS_____________________________________________________
%		ramp_up 			OPTIONAL 	number		Rectangular: duration in s
%		ramp_down 			OPTIONAL 	number		Rectangular: duration in s
%		frequency 			OPTIONAL 	number		Sinusoidal: frequency
%		starting_phase 			OPTIONAL 	number		Sinusoidal: starting phase
%		offset 				OPTIONAL 	number		Sinusoidal: constant offset added
%		noise_type 			OPTIONAL 	string		Noise: spectral character - eg white or pink
%		frequency_low 			OPTIONAL 	number		Noise: lower band of randomised
%		frequency_high 			OPTIONAL 	number		Noise: upper band of randomised
%		distribution 			OPTIONAL 	string		Noise: amplitude distribution

% TUS PARAMETERS_________________________________________________
%		measured_peak_negative_pressure OPTIONAL 	number		estimated peak
%		spatial_peak_pulse_average_intensity 	OPTIONALnumber		estimated peak
%		spatial_peak_temporal_average_intensity OPTIONALnumber		ISPPA
%		mechanical_index 		OPTIONAL 	number 		ISPTA
%		thermal_index 			OPTIONAL 	number 		

% OTHERS_________________________________________________________
% 		stimulus_description 		OPTIONAL 	string		optional - in case the waveform is not described by the above


% *_nibs.json
% A BIDS JSON sidecar that describes each *_nibs.tsv column (LongName, Description, Units, Levels, Delimiter) and carries structured device, intensity, and navigation metadata.
%		NIBSDescription 		RECOMMENDED 	string		free-text summary
%		ConcurrentModalities 		RECOMMENDED 	array		e.g., ["eeg"], ["emg"], ["ieeg"], or ["none"]
%		IntendedFor 			RECOMMENDED 	string or array	BIDS URI or URIs to the *_events.tsv linked to this nibs.tsv
%		TaskName 			OPTIONAL 	string		name of the task during stimulation
%		TaskDescription 		OPTIONAL 	string		description
%		Instructions 			OPTIONAL 	string		to the participant
%		InstitutionName 		OPTIONAL 	string		where study performed
%		InstitutionAddress 		OPTIONAL 	string		address
%		InstitutionalDepartmentName 	OPTIONAL 	string		department
% 		StimulatorSet 			RECOMMENDED 	array
%			StimulatorID 		REQUIRED 	string		referenced from stimulator_id
%			Manufacturer 		RECOMMENDED 	string 		name
%			ManufacturersModelName 	RECOMMENDED 	string		name
%			DeviceSerialNumber 	OPTIONAL 	string		SN
%			SoftwareVersions 	OPTIONAL 	string		control software
%		ElementSet 			RECOMMENDED 	array
%			ElementID 		REQUIRED 	string		referenced from nibs_element_id
%			ElementType 		REQUIRED 	string		coil, electrode, transducer
%			ModelName 		RECOMMENDED 	string		
%			SerialNumber 		OPTIONAL 	string
%
%			COIL-SPECIFIC
%			CoilShape 		RECOMMENDED 	string		figure-of-eight, circular
%			CoilCooling 		OPTIONAL 	string		air, liquid, passive
%			CoilDiameter 		OPTIONAL 	object
%				Value		OPTIONAL
%				Units		OPTIONAL
%				Description	OPTIONAL
%			MagneticFieldPeak 	OPTIONAL 	object
%			MagneticFieldPenetrationDepth 	OPTIONALobject
%			MagneticFieldGradient 	OPTIONAL 	object 	
%
%			ELECTRODE-SPECIFIC
%			ElectrodeRole 		REQUIRED 	string 		One of anode, cathode, return, ground, other
%			Shape 			RECOMMENDED 	string 		
%			ElectrodeSize 		RECOMMENDED 	object 		Size or area
%				Value
%				Units
%				Description
%			Thickness 		OPTIONAL 	object 		
%			Material 		OPTIONAL 	string 		Conductive material
%			ElectrodeContactMedium 	RECOMMENDED 	string 		eg gel, saline, paste, or dry
%			ElectrodePreparation 	OPTIONAL 	string 		Skin preparation procedure
%
%			TRANSDUCER-SPECIFIC
%			TransducerType 		RECOMMENDED 	string 		One of single-element, phased-array, planar, custom
%			FocusType 		OPTIONAL 	string 		Focusing method
%			CarrierFrequency 	RECOMMENDED 	object 		
%			FocalDepth 		RECOMMENDED 	object 		
%			ApertureDiameter 	OPTIONAL 	object 		
%			MaxPeakNegativePressure OPTIONAL 	object 		
%			MaxMechanicalIndex 	OPTIONAL 	number 		Maximum Mechanical Index
%			TransducerContactMedium OPTIONAL 	string 		Coupling medium
%
%			PHASED-ARRAY-SPECIFIC
%			NumberOfElements 	OPTIONAL 	number 		Number of array elements
%			ElementPitch 		OPTIONAL 	object 		Spacing between array elements
%			ArrayGeometry 		OPTIONAL 	string 		Geometry of the array

%		IntensitySet 			OPTIONAL 	array
%			IntensityID 		REQUIRED 	string 		Unique identifier, referenced from intensity_reference
%			Value 			REQUIRED 	number 		Measured value of the reference, for example the resting motor threshold
%			Units 			REQUIRED 	string 		Units of Value, eg Maximum Stimulator Output or mA
%			IntensityType 		RECOMMENDED 	string 		Reference endpoint, eg resting_motor, active_motor, phosphene, sensation, pain
%			Criterion 		RECOMMENDED 	string 		Criterion defining the reference, for example "1 mV MEP" or "perceptible phosphene"
%			Algorithm 		OPTIONAL 	string 		Estimation procedure, for example "5/10", "PEST", or a staircase
%			MeasurementMethod	OPTIONAL 	string 		Modality used to assess the response, for example EMG MEP or visual report


% *_markers.tsv
% 		nibs_position_id 		REQUIRED 	string 		Identifier of one element placement (one row). MUST be unique within the file
%		nibs_element_id 		RECOMMENDED 	string 		Element placed at this position. References ElementSet.ElementID in *_nibs.json, the same key used in *_nibs.tsv
%		position_label 			RECOMMENDED 	string 		Standardized label for the placement, for example the 10-20 or 10-10 site C3, or a site name such as M1_hand or DLPFC
%										This can be used in place of coordinates
%
%		position_description 		OPTIONAL 	string 		Free-text description of the placement and how it was located
%										This can be used in place of coordinates
%
%		position_group 			OPTIONAL 	string 		Organizational grouping label, for example montage membership. MUST NOT be used for linkage or synchronization

%		These 12 define the position
%		element_centre_x 		RECOMMENDED 	number 		x coordinate of the centre of the element
%		element_centre_y 		RECOMMENDED 	number 		y coordinate of the centre of the element
%		element_centre_z 		RECOMMENDED 	number 		z coordinate of the centre of the element
%		element_xdir_x 			OPTIONAL 	number 		x component of the element x axis
%		element_xdir_y 			OPTIONAL 	number 		y component of the element x axis
%		element_xdir_z 			OPTIONAL 	number 		z component of the element x axis
%		element_ydir_x 			OPTIONAL 	number 		x component of the element y axis, which runs along the handle or leading edge
%		element_ydir_y 			OPTIONAL 	number 		y component of the element y axis
%		element_ydir_z 			OPTIONAL 	number 		z component of the element y axis
%		element_zdir_x 			OPTIONAL 	number 		x component of the element z axis which points from the element into the head
%		element_zdir_y 			OPTIONAL 	number 		y component of the element z axis
%		element_zdir_z 			OPTIONAL 	number 		z component of the element z axis

%		element_distance 		RECOMMENDED 	number 		Physical distance from the element surface to the scalp, for example the thickness of padding, gel, or hair. This is a real, measurable quantity that affects the delivered dose, so it SHOULD be recorded whenever it is known, independently of whether neuronavigation was used

%		target_x 			OPTIONAL 	number 		x coordinate of the intended target, for example a cortical site or an acoustic focus
%		target_y 			OPTIONAL 	number 		y coordinate of the intended target
%		target_z 			OPTIONAL 	number 		z coordinate of the intended target
%		target_label 			OPTIONAL 	string 		Standardized label or anatomical name of the target
%		peeling_depth 			OPTIONAL 	number 		Depth from the scalp or cortical surface to the target, as reported by a neuronavigation system. It is specific to neuronavigation, is not produced by all systems, and is distinct from element_distance, which is the physical standoff of the element from the scalp
%		efield_max_x 			OPTIONAL 	number 		x coordinate of the location of maximum electric field, when modelled
%		efield_max_y 			OPTIONAL 	number 		y coordinate of the location of maximum electric field
%		efield_max_z 			OPTIONAL 	number 		z coordinate of the location of maximum electric field


% *_coordsystem.json
%		NIBSCoordinateSystem 		REQUIRED 	string 		Coordinate system used for the positions, for example IndividualMRI, MNI152NLin2009cAsym, or CapTrak
%		NIBSCoordinateUnits 		REQUIRED 	string 		Units of the coordinates, typically mm
%		NIBSCoordinateSystemDescription RECOMMENDED 	string 		How the coordinate system was defined, including the registration method and what the coordinates represent
%		NavigationSystem 		OPTIONAL 	object 		Description of the navigation or positioning system. See below
%			Navigation 		REQUIRED 	boolean 	Whether a navigation, tracking, or positioning system was used
%			NavigationHardwareType 	RECOMMENDED 	string 		For example optical_tracking, robot, cobot, mechanical_arm
%			NavigationModelName 	RECOMMENDED 	string 		Vendor or model
%			NavigationSoftwareVersion OPTIONAL 	string 		Software version
%			NavigationHardwareSerialNumber 	OPTIONAL string 	Serial number or identifier
%			NavigationNotes 	OPTIONAL 	string 		Setup notes, for example camera type or calibration procedure

%		IntendedFor 			RECOMMENDED 	string 		BIDS URI to the anatomical file the coordinate system refers to, for example bids::sub-01/anat/sub-01_T1w.nii.gz

%		FiducialsDescription 		OPTIONAL 	string 		How the fiducials were placed relative to anatomical landmarks and how their positions were measured
%		FiducialsCoordinates 		OPTIONAL 	object 		Labels and 3D positions of the fiducials, each an array of x, y, z in that order
%			x
%			y
%			z
%		FiducialsCoordinateSystem 	OPTIONAL 	string 		Coordinate system for the fiducials, preferably the same as NIBSCoordinateSystem
%		FiducialsCoordinateUnits 	OPTIONAL 	string 		Units for the fiducial coordinates. One of m, mm, cm, n/a
%		FiducialsCoordinateSystemDescription 	OPTIONAL string 	Description of the fiducial coordinate system

%		AnatomicalLandmarkCoordinates 	OPTIONAL 	object 		Labels and 3D positions of anatomical landmarks, each an array of x, y, z in that order
%			x
%			y
%			z
%		AnatomicalLandmarkCoordinateSystem 	OPTIONAL 	string 	Coordinate system for the anatomical landmarks
%		AnatomicalLandmarkCoordinateUnits 	OPTIONAL 	string 	Units of the landmark coordinates. One of m, mm, cm, n/a
%		AnatomicalLandmarkCoordinateSystemDescription 	OPTIONAL string Description of the landmark coordinate system
%		AnatomicalLandmarkCoordinatesDescription OPTIONAL 	string 	Description of the landmarks, for example NAS for nasion, LPA and RPA for the preauricular points
%		AnatomicalLandmarkRmsDeviation 	OPTIONAL 	object 		Per-landmark co-registration deviation values
%		AnatomicalLandmarkRmsDeviationUnits 	OPTIONAL 	string 	Units of the deviation values
%		AnatomicalLandmarkRmsDeviationDescription 	OPTIONAL 	string 	How the deviation was calculated and for which landmarks

%		HeadMeasurements 		OPTIONAL 	object 		Head measurements taken with a tape from anatomical landmarks, used to locate elements without coordinates. Each value is a numeric array
%		HeadMeasurementsUnits 		OPTIONAL 	string 		Units for all values in HeadMeasurements, for example mm
%		HeadMeasurementsDescription 	OPTIONAL 	string 		How the measurements were obtained, including the landmarks used and any conventions

%		DigitizedHeadPoints 		OPTIONAL 	string 		Relative path to the file with digitized head points, for example sub-01_headshape.pos
%		DigitizedHeadPointsNumber 	OPTIONAL 	number 		Number of digitized head points used during co-registration
%		DigitizedHeadPointsDescription 	OPTIONAL 	string 		Description of the digitized points
%		DigitizedHeadPointsUnits 	OPTIONAL 	string 		Units. One of m, mm, cm, n/a

%		TUS-SPECIFIC
%		TransducerCoordinates 		OPTIONAL 	object 		(TUS) Spatial coordinates of the transducer, and optionally an affine transformation for its orientation
%		TransducerCoordinateUnits 	OPTIONAL 	string 		(TUS) Units for the transducer coordinates
%		TransducerCoordinateSystemDescription 	OPTIONAL string 	(TUS) How the transducer coordinate system was defined and aligned with anatomy
%		TransducerCoordinatesDescription	OPTIONAL string 	(TUS) What the coordinates represent, for example transducer centre, entry point, or beam axis
%		TransducerRmsDeviation 		OPTIONAL 	number 		(TUS) Deviation of the transducer position or orientation from the planned placement
%		TransducerRmsDeviationUnits 	OPTIONAL 	string 		(TUS) Units for the deviation
%		TransducerRmsDeviationDescription 	OPTIONAL string 	(TUS) How the deviation was computed and by which method


% OPTIONAL FILES
% Head shape (*_headshape.<ext>)


% Landmark photos (*_photo.<ext>)