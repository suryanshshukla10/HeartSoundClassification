% addpath(genpath(pwd));
% addpath('./HelperFunctions');
% warning off;  
% expecting the training data in subfolders of 'Data\training\*': "training-a", etc
training_fds = fileDatastore('set_a', 'ReadFcn', @importAudioFile, 'FileExtensions', '.wav','IncludeSubfolders',true);

%% Error starts
data_dir = fullfile(pwd, 'Data','set_a, 'training');
folder_list = dir([data_dir filesep 'training*']);
%%

S = dir(fullfile('.','training*'));
N = {S([S.isdir]).name};
C = cell(1,numel(N));
for k = 1:numel(N)
    F = fullfile('.',N{k},'REFERENCE.csv');
    C{k} = importReferencefile(F);
end
reference_table = table();

%%
for ifolder = 1:length(folder_list)
    disp(['Processing files from folder: ' folder_list(ifolder).name])
    current_folder = [data_dir filesep folder_list(ifolder).name];
    
    % Import ground truth labels (1, -1) from reference. 1 = Normal, -1 = Abnormal
    reference_table = [reference_table; importReferencefile([current_folder filesep 'REFERENCE.csv'])];
end

%%
% runExtraction = false; % control whether to run feature extraction (will take several minutes)
%    % Note: be sure to have the training data downloaded before executing
%    % this section!
% if runExtraction | ~exist('FeatureTable.mat')%#ok 
%     % Window length for feature extraction in seconds
%     win_len = 5;
%     
%     % Specify the overlap between adjacent windows for feature extraction in percentage
%     win_overlap = 0;
%     
%     % Initialize feature table to accumulate observations
%     feature_table = table();
%     
%     % Use Parallel Computing Toobox to speed up feature extraction by distributing computation across available processors
%     
%     % Create partitions of the fileDatastore object based on the number of processors
%     n_parts = numpartitions(training_fds, gcp);
%     
%     % Note: You could distribute computation across available processors by using 
%     % parfor instead of "for" below, but you'll need to omit keeping track
%     % of signal lengths
%     parfor ipart = 1:n_parts
%         % Get partition ipart of the datastore.
%         subds = partition(training_fds, n_parts, ipart);
%         
%         % Extract features for the sub datastore
%         [feature_win,sampleN] = extractFeatures(subds, win_len, win_overlap, reference_table);
%         
%         % and append that to the overall feature table we're building up
%         feature_table = [feature_table; feature_win];
%         
%         % Display progress
%         disp(['Part ' num2str(ipart) ' done.'])
%     end
%     save('FeatureTable', 'feature_table');
% 
% else % simply load the precomputed features
%     load('FeatureTable.mat');
% end

% Take a look at the feature table
%disp(feature_table(1:5,:))