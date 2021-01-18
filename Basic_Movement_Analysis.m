
%% Load Data from server

% Add matlab pathway to my directory
addpath(genpath('E:\Evyn'))

% Stimulus selection:
stim = 'loomingRetinotopic_dark_r5to30_v20';
% Genotype name:
genotype = 'IsoD1_Evyn';

% Data directory access: (depends on the computer accessing the folder)
sysConfig = GetSystemConfiguration;
% concatenate those to create the path
dataPath = [sysConfig.dataPath,'/',genotype,'/',stim];


analysisFiles={'PlotTimeTracesAbs'};

% Prepare input arguments for RunAnalysis function
args = {'analysisFile',analysisFiles,...
        'dataPath',dataPath,...
        'combOpp',0}; % combine left/right symmetric parameters? (defaulted to 1)

% Extract formatted data and pull parameters
package = RunAnalysis(args{:});
num.flies = length(package.analysis{1,1}.indFly);   % number of flies
data = package.analysis{1};
num.time = data.timeX/1000; % convert ms to s

% Add in program clean up 
initial_vars = who; 
initial_vars{end+1} = 'initial_vars';

%% Basic analysis:

% Plot average time course with SEM for ALL flies and ALL trials:


fig = getfig('',1);
hold on





meanmat = a.analysis{1}.respMatPlot;
semmat  = a.analysis{1}.respMatSemPlot;
% Use in-house prettier plot functions for visualization...
MakeFigure; hold on
% showing only first three epochs
PlotXvsY(timeX,meanmat(:,1:3,1),'error',semmat(:,1:3,1));
PlotConstLine(0,1); % horizontal 0 line
PlotConstLine(0,2); % vertical 0 line
ConfAxis('labelX','time (s)','labelY','Angular velocity (deg/s)')




indmat = [];
for ff = 1:nFly
    % needs some reformatting from cell to matrix...
    thisFlyMat = cell2mat(permute(a.analysis{1}.indFly{ff}.p8_averagedRois.snipMat,[3,1,2]));
    indmat(:,:,ff) = thisFlyMat(:,:,1); % only care about turning here...
end
% average over time (for 3 s, for example)
integmat = permute(mean(indmat(timeX>0 & timeX<3, :, :),1),[3,2,1]);
% visualize them
easyBar(integmat,'connectPaired',1);

















