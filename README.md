# Constructing an open-source test dataset for MEP analyses

This repository contains:

- code to convert data from an existing (HandLab) structure to the standard BIDS (-EMG and -NIBS) structure
- example files for the NIBS-BIDS data struture (currently: Version 6)
- data in BIDS format

This directory will also contain scripts to process these open datasets allowing analyses of multiple TMS-EMG datasets and to test TMS, EMG, and MEP analysis methods.

## Guidance

### 1. BIDSifying a dataset

For each dataset included in this repository, there is an anonymised copy of the code used to convert the dataset to BIDS format, for example:

- [HandLab_P10_E14_anon_BIDSify.m](https://github.com/TheHandLab/TestData/blob/main/HandLab_P10_E14_anon_BIDSify.m)

These examples may help you convert your own data to the BIDS format.

### 2. Retrieving TMS-EMG datasets

The best way to download the data is to use git commands to clone the repository to a directory on your local machine. You may also be able to downloard the data directly from the webpage.

### 3. Analysing the dataset

Some example analysis scripts will be shared when ready. We encourage you to develop your own scripts and share back to the repository for others to use.


## Notes

### Data analysis format

A common data analysis format may be helpful. Here are notes from a previous analysis attempt (pre-BIDS):
- Data file (2D array, with one EMG epoch per row and one column per sample, e.g., 10000 rows and 2000 columns)
- Metadata file (2D array, with one row per row of the data file, and one column per metadata variable e.g., 10000 rows and 20 columns)
- Subjects file (2D array, with one row per subject and one column per subject metadata variable)

### Development

Future plans:
- Include all available metadata from the [TMS-RAT](https://tms-rat.org)  - see [notes here](https://github.com/TheHandLab/TMSMultiLab/edit/main/TestData/TMS-RAT.md)
- Include all available metadata from the NIBS-DAS

### TMS-RAT v1.0 metadata compliance

To ensure that analysed data are compliant with the TMS-RAT reporting recommendations, the following metadata should be included with all datasets (where relevant and available!).

Upper case letters A-N relate to the reporting categories in [Version 1.0](https://tms-rat.org/?page=rat&version=1)

A) Age, sex, handedness, height and weight

B) Medication, CNS, Neuro, Medical, Cognitive, Sleep, Posture

C) Studies, Population, Groups, Protocol, TimeofDay, SessionDuration/Interval, Attention, Control, Attenuation

D) Stimulator, CoilShape/Model, CoilDiameter, PulseWaveform

E) Neuronavigation, CoilLocationSkin, TargetCNS, CoilOrientation, CoilCurrentDirection, CoilStability

F) IntensityMethod, MachineIntensity, ParticipantIntensity

G) TrialInterval, NumberPulses, ResponseRaw

H) ThresholdLocation, ThresholdType, ThresholdCriterion, ThresholdAlgorithm, ThresholdValues

I) MotorSkills, PriorMotorActivity, MuscleActivity

J) EMGHardware, EMGSoftware, SkinPreparation, ElectrodeMaterial/Size, ElectrodeLocation, ElectrodeMontage, Sampling/Filtering, EMGMeasure, EMGAmplitudeNormalisation

K) AfferentStimulationHardware, AfferentElectrodes, AfferentLocation, AfferentTarget, AfferentDuration/Waveform, AfferentThresholdType, AfferentThreshold

L) ConditioningIntensityMachine, ConditioningIntensityParticipant, Condition-TestInterval(s), ConditionedUnconditionedOrder, ConditionedPulseNumber, ConditionedResponseRaw, ConditionedResponseRelative

M) SEPFrequency/Repetitions, EEGMontage, EEGFeature, EEGValues

N) BurstFrequency, WithinBurstPulses, BetweenBurstInterval, BurstNumber, BetweenTrainInterval, TrainNumber, TMSTaskInterval, RepeatNumber

### NIBS-DAS metadata compliance

