function [InitialObservation, LoggedSignal,DataLog] = myResetFunction()
beamRowFrac = 0.767183786055692;
beamColFrac = 0.921939796753589;
targetRangeIndex = 0.615384615384615;
obsNum = 572;

% Return initial environment state variables as logged signals.
LoggedSignal.State = [beamRowFrac;beamColFrac;targetRangeIndex;obsNum];
InitialObservation = [beamRowFrac;beamColFrac;targetRangeIndex];


end
