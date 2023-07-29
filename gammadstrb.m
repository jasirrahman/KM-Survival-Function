%% Gamma Cumulative Distribution Function

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
censored_data = agg_data(exclude_Indices, :);
agg_FA_data = agg_data(:,1);
agg_censor_data = agg_data(:,2);

%% Step 2: Get Statistics on Distribution
% Average survival data
% Find censoring rate of data
censored = mean(agg_data(:,2) == 1) * 100;
n = numel(agg_data(:,1));
%display distribution of failure times
figure()
histogram(agg_data(:,1))
title('FA Distribution')
xlabel('Time (sec)')
ylabel(['Frequency of FA (n = ', num2str(n), ')']);

%get count of censored data
logical_array = logical(agg_data(:,2));
n_censored = sum(logical_array);
%display distribution of censored times
figure()
histogram(censored_data(:,1))
title('Censored Data Distribution')
xlabel('Time (sec)')
ylabel(['Frequency of Censored Observations (n =', num2str(n_censored), ')']);
%%Note: Approx same distribution for censored and uncensored (not random)

%% Step 3: Plot Gamma Distribution
%%use 'gamcdf' function to compute the cdf of the standard gamma
%%distribution

gd = fitdist(agg_data(:,1), 'gamma');
gd;
x = 0:0.1:14;
y1 = gampdf(x,gd.a,gd.b);
figure;
plot(x,y1);
hold on
ecdf(gca,agg_data(:,1),'Censoring',agg_data(:,2),'function','survivor');
hold(gca, 'on');
ecdf (gca, uncensored_data(:,1),'Censoring',uncensored_data(:,2),'function','survivor');
xlim([0,14]);
title('Survivor Function for Session Times');
xlabel('Time (sec)');
ylabel('Survival Function S(t)');
legend('Gamma','Censored','Uncensored');
%%compare gamma to cdfcurve



