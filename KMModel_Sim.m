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
censored_data = agg_data(exclude_Indices, :);
agg_FA_data = agg_data(:,1);
agg_censor_data = agg_data(:,2);

%% Step 2: Create Simulated Data Based on agg_data
num_FA_trials = 1000; %number of simulated trials
sim_FA_data = zeros(num_FA_trials, numel(agg_FA_data));
for i = 1:num_FA_trials
  indices = randi(numel(agg_FA_data, 1, numel(agg_FA_data)));
  sim_FA_data(i,:) = (agg_FA_data(indices));
end

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

%% Step 3: Create Survival Distributions
%%Estimate and plot cdf
% Plot KME of cdf
figure()
ecdf(gca, agg_data(:,1), 'Censoring',agg_data(:,2));
hold(gca, 'on');
ecdf(gca, uncensored_data(:,1),'Censoring',uncensored_data(:,2));
title('KME of cdf');
xlabel('Time(sec)');
legend('Censored','Uncensored');

%% Plot survivor functions
figure()
ecdf(gca,agg_data(:,1),'Censoring',agg_data(:,2),'function','survivor');
hold(gca, 'on');
ecdf (gca, uncensored_data(:,1),'Censoring',uncensored_data(:,2),'function','survivor');
xlim([0,14]);
title('Survivor Function for Session Times');
xlabel('Time (sec)');
ylabel('Survival Function S(t)');
legend('Censored','Uncensored');

%% Plot cumulative hazard functions
figure()
[f,x] = ecdf(agg_data(:,1),'Censoring',agg_data(:,2),'function','cumhazard');
plot(x,f)
cumhazard_c = max(f);
hold on
[f,x] = ecdf(uncensored_data(:,1),'Censoring',uncensored_data(:,2),'function','cumhazard');
plot(x,f,'--r')
cumhazard_u = max(f);
title('Cumulative Hazard Function Over Session Time');
xlabel('Time (sec)');
ylabel('Cumulative Hazard Function H(t)');
legend('Censored', 'Uncensored');

%%Use cumhazard to find S(t) - THIS GIVES HAZARD RATE FOR t = 14!!!
survfun_c = exp(-cumhazard_c);
survfun_u = exp(-cumhazard_u);

%% Add new vector with ecdf data linked to time
[unique_vals, ~, ic] = unique(agg_data(:,1));
num_unique_vals = numel(unique_vals);
disp('Unique Values:');
disp(unique_vals);
disp(['Number of Unique Values: ', num2str(num_unique_vals)]);

%% Manually Construct Jackknife (Quenouilles Method)
%%Review statistics and how you are transforming them to ensure that this
%%estimation is correct!  Unclear whether or not needs to be a
%%time-dependent function, which will change some things!  Also need to be
%%sure that a) data is smooth, b) correct data is being computed for the
%%estimate of bias, c) Quenouilles is even a valid metric anymore or is
%%there some other bias estimator?

%% Compute S: = (1/n)sigma(S(Fn)) where Fn is ecdf
n_f = numel(f);
jackknifedata = [x, f];
sigma = sum(f);
n_1 = 1/n_f;
Shat = n_1*sigma;

%% Compute Quenouille's Bias Estimate: BIASn = (n-1){S(hat) - S(Fn)}
nminus1 = n_f - 1;
Shat_SF = Shat - sigma; 
BIASn = nminus1*Shat_SF;

%% Compute Bias-Corrected Jackknife Estimate of S(F): S = S(Fn) - BIASn
BCJ = sigma - BIASn;
