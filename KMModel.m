%% Mouse Data Distribution

%% Step 1: Load Mouse Data
load("S187_13.mat");
load("W3894_22.mat");
load("W3894_25.mat");
load("W3894_42.mat");
% pool survival + censoring data
agg_data = [S187_13; W3894_22; W3894_25; W3894_42];
censored_val = 1;
column_index = 2;
exclude_Indices = agg_data(:,column_index) == censored_val;
uncensored_data = agg_data(~exclude_Indices, :);

%% Step 2: Get Statistics on Distribution
% Average survival data
% Find censoring rate of data
censored = mean(agg_data(:,2) == 1) * 100;
disp(censored);

%% Step 3: Create Survival Distributions
%% Estimate and plot cdf
% Plot KME of cdf
figure()
ecdf(gca, agg_data(:,1), 'Censoring',agg_data(:,2));
hold(gca, 'on');
ecdf(gca, uncensored_data(:,1),'Censoring',uncensored_data(:,2));
title('KME of cdf');
legend('Censored','Uncensored');

%% Plot survivor functions
figure()
ax1 = gca;
ecdf(ax1,agg_data(:,1),'Censoring',agg_data(:,2),'function','survivor');
xlim([0,14]);
title('Survivor function');