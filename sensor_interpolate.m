function sensor_interpolate(exp,subjGroup,listPrefix)

dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/';
subjList = (dlmread(strcat(dataPath,'scripts/function_inputs/',listPrefix, '.txt')))';


numChan = 70;

for s = subjList

    fileName = strcat(subjGroup,int2str(s),'/ave_projoff/',subjGroup,int2str(s),'_',exp,'-ave.fif');
    subjStr = fiff_read_evoked_all(fileName); %%this holds the original data
    iStr = subjStr; %%this will hold the interpolated data
    
 
    %% Read channel info

    allChans = [316:375 379:388];
 
    %%fix subjects with different number of channels recorded
    if (s == 1 || s == 2 || s == 3 || s == 4) && strcmp(subjGroup,'ya')
        allChans = [316:375 380:389];
    end
      
    allX = [];
    allY = [];
    allZ = [];
    goodX = [];
    goodY = [];
    goodZ = [];
    goodChanIndex = [];
    badChanList = [];

    for i = 1:70
        allX(end+1) = subjStr.info.chs(allChans(i)).eeg_loc(1);
        allY(end+1) = subjStr.info.chs(allChans(i)).eeg_loc(2);
        allZ(end+1) = subjStr.info.chs(allChans(i)).eeg_loc(3);

        badTest = find(strcmp(subjStr.info.bads,subjStr.info.ch_names{allChans(i)}));
        if size(badTest,2) == 0
            goodX(end+1) = subjStr.info.chs(allChans(i)).eeg_loc(1);
            goodY(end+1) = subjStr.info.chs(allChans(i)).eeg_loc(2);
            goodZ(end+1) = subjStr.info.chs(allChans(i)).eeg_loc(3);
            goodChanIndex(end+1) = i;
        else
            badChanList(end+1) = badTest; %%make a list of bad EEG chan
        end
    end

    goodChans = allChans(goodChanIndex);  %%goodChans is in MNE indices (316-389)
    
    goodPos = [goodX;goodY;goodZ];
    allPos = [allX;allY;allZ];

    badChanList
    iStr.info.bads(badChanList) = [];  %unmark the bad EEG chan in the interp. structure
 
    
    %% Make a triangulation of the positions
    allTri = pos2tri(allPos);
    goodTri = pos2tri(goodPos);


    %% Interpolate at each time point in each condition

    numConditions = size(subjStr.evoked,2);
    numSamples = size(subjStr.evoked(1).epochs,2);

    for c = 1:numConditions
        c
        iData = zeros(numChan,numSamples);
        t = 1:numSamples;
        goodData = (subjStr.evoked(c).epochs(goodChans,:));
        iData(:,t) = interpolatedvoltages(allPos,allTri,goodPos,goodTri,goodData(:,t));
        iStr.evoked(c).epochs(allChans,:) = iData(:,:);
    end
    size(iData)


    outFileName = strcat(subjGroup,int2str(s),'/ave_projoff/',subjGroup,int2str(s),'_',exp,'-I-ave.fif');

    fiff_write_evoked(outFileName,iStr);

end


    