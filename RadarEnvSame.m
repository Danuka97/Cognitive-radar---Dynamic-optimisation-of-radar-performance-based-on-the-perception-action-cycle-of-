function [NextObs,Reward,IsDone,LoggedSignals,datalog] = RadarEnvSame(Action,LoggedSignals,AverageReward,datalog)

            

            load('CranfieldMScParms.mat')
            parm = saved.Parameters;
            load('/Users/danukatheja/Downloads/IRP/Cranfield Dropoff Service-pS9cskDSAD72goFo/BeamformingAgentEnvironment/Data/FreqData_2019-07-04-10-20-57.260_IDI1-D.mat');
            load('/Users/danukatheja/Downloads/IRP/Cranfield Dropoff Service-pS9cskDSAD72goFo/BeamformingAgentEnvironment/Data/FreqData_2019-07-04-10-20-57.260_IDI1-D_TargetXYZ.mat')
            beamFormingEnvironment = BeamformingAgentEnvironment(parm);

            State = LoggedSignals.State;
            beamRowFrac = State(1);
            beamColFrac = State(2);
            obsNum =State(4);

            fdata = squeeze(fullFlightFFT(obsNum,:,:,:));
            fdata = squeeze(fullFlightFFT(obsNum,:,:,:));
            reaVals = fullFlightREA_indexes(obsNum,:);
            xyz = xyzForThisFlight(obsNum,:);
            targetRangeIndex = reaVals(1);
            [beamRowFrac, beamColFrac] = beamFormingEnvironment.customBeamformer.getNearestBeams(xyz,targetRangeIndex);
            targetElevationIndex = round(beamRowFrac);
            targetAzimuthIndex = round(beamColFrac); 
            tgtDopplerBin = bins(obsNum);

            Observation = [beamRowFrac/4;beamColFrac/6;targetRangeIndex/13];
            beamRowFrac/4;
            beamColFrac/6;
            targetRangeIndex/13;
            % Get reward
            beamFormingEnvironment.updateBeam(targetRangeIndex, targetAzimuthIndex, Action)
            Rewardout = beamFormingEnvironment.getSCRReward(targetRangeIndex, targetAzimuthIndex, targetElevationIndex, fdata, tgtDopplerBin);

            

            obsNum = obsNum+1;

            fdata = squeeze(fullFlightFFT(obsNum,:,:,:));
            fdata = squeeze(fullFlightFFT(obsNum,:,:,:));
            reaVals = fullFlightREA_indexes(obsNum,:);
            xyz = xyzForThisFlight(obsNum,:);
            targetRangeIndex = reaVals(1);
            [beamRowFrac, beamColFrac] = beamFormingEnvironment.customBeamformer.getNearestBeams(xyz,targetRangeIndex);
            targetElevationIndex = round(beamRowFrac);
            targetAzimuthIndex = round(beamColFrac); 
            tgtDopplerBin = bins(obsNum);
            
            ls =[];

            if isempty(Rewardout)
                Reward = AverageReward;
                
            else
                Reward = Rewardout;
            end

            IsDone = Action > 3 || Reward > 10000 || isempty(Rewardout);


            LoggedSignals.State = [beamRowFrac/4; beamColFrac/6; targetRangeIndex/13; obsNum;];

            NextObs = [beamRowFrac/4;beamColFrac/6;targetRangeIndex/13];
            
            AverageReward = Reward;
            AverageReward;
            beamRowFrac/4;
            beamColFrac/6;
            targetRangeIndex/13;
            Action;
            obsNumofS = obsNum -1;
            datalog = [obsNumofS Action AverageReward Observation(1) Observation(2) Observation(3)];

            Filename = sprintf('DDQN30/DataLogDDPG_%d_.csv',obsNumofS);
            writematrix(datalog,Filename);
            %writematrix(LoggedSignals,'LoggedSignals.csv');

        end