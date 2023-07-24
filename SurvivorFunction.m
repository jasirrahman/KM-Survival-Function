%% Step 1: Load and organize sample data
load('S187_13.mat');
%%
%data has failure time and censoring data

%%
% Create a matrix of failure time and censoring data
data = [FailureTime, Censored];

%% Step 2: Estimate and plot cdf
% Plot KME of cdf
figure()
ecdf(gca, data(:,1), 'Censoring',data(:,2));


%% Step 3: Plot survivor functions
figure()
ax1 = gca;
ecdf(ax1,data(:,1),'Censoring',data(:,2),'function','survivor');
xlim([0,14])