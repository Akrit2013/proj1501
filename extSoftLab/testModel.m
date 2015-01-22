% ===========================================================
% This script test the fine tuned model by pascal voc
% The purpose of this script is to check whether the matlab
% interface of caffe and the python interface perform the
% same or not.
% ===========================================================

tic;
% Define the valid index file
gValidIdxFile='valid.txt';


% Add path for the caffe matlab interface
addpath('../matcaffe');
% Add the common utility path
addpath('../comm');

% init caffe network (spews logging info)
use_gpu=1;
matcaffe_init_m(use_gpu);

% Load the imagenet mean image
load ilsvrc_2012_mean.mat;

% Init the counter
nMatchCounter=0;

[ids, labels]=textread(gValidIdxFile, '%s %d');
nSample=length(ids);

for i=1:nSample
	if toc>1
		fprintf('Processing: %d/%d\n', i, nSample);
		tic;
	end

	im=imread(ids{i});
	input_data={fnOversample(im,image_mean)};
	scores=caffe('forward', input_data);

	scores = scores{1};
	%size(scores)
	scores = squeeze(scores);
	scores = mean(scores,2);

	[~,maxlabel] = max(scores);

	if maxlabel==labels(i)+1
		nMatchCounter=nMatchCounter+1;
	end
end

fprintf('Finished, the accuracy is %f\n', nMatchCounter./nSample);
