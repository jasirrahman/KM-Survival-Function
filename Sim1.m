%% Step 1: Simulate Data
number_simulations = 1000;
sample_size = 400;
censoring_rate = 0.8;
num_ones = round(sample_size * 0.0);  % term multiplied by sample_size will be amt of data censored!!

%Generate array with 20% ones and 80% zeros (80% censored)
censored_array = [ones(num_ones, 1); zeros(sample_size - num_ones, 1)];

%shuffle array to randomize order)
Censored = censored_array(randperm(sample_size));

FailureTime = randi([0,14],400,1); 
% Next step make distribution of data based on averages from
% actual mouse data to ensure statistical accuracy
% then can do similar thing with FT array as w/ Censored

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