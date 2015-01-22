% -----------------------------------------------------
% This script generate the negative sample from the pascal voc dataset
% It should be concerned that the negative sample should not overlap with the positive ones
% -----------------------------------------------------

tic;


% The location of the dev kits
gVOCdevkit='/VOCdevkit';
gVOCcode='/VOCcode';
gPatchLoc='./ndataset';

% The file name of the index file contain the train images
gNegTrainIdxFile='negTrain.txt';
gNegValidIdxFile='negValid.txt';

% Number of the total neg patches
gNegTrainNum=5000;
gNegValidNum=5000;

% The max overlap rate between the negative sample and tje positive ones
gMaxOverlapRate=0.3;

% The class label of the negative class
gLabel=20;

% The max Hight and width rate of the negative patch
gMaxHWRate=2;

% should igore the 'difficult' target or not
bIncludeDifficult=0;

% Open the index files
fTrainNeg=fopen(gNegTrainIdxFile, 'w');
fValidNeg=fopen(gNegValidIdxFile, 'w');

if fTrainNeg==-1 || fValidNeg==-1
	disp('Open index files error!');
	keyboard;
end

% The start index number of the patch name
gNameIndex=1;

% Modify the path
addpath([cd gVOCdevkit]);
addpath([cd gVOCdevkit gVOCcode]);

% initialize the VOC options
VOCinit;


% Start to extract the negative patches
disp('Start to extract the train negative sample...');

% load training set 
[ids]=textread(sprintf(VOCopts.imgsetpath,VOCopts.trainset),'%s');

% Calc the average number of patches sampled from each image
nPatches=ceil(gNegTrainNum./length(ids));
% Init the patch counter
nCounter=0;

% iterate the images
for i=1:length(ids)
	% Show the progress
	if toc>1
		fprintf('Train image:%d/%d\n',i,length(ids));
		tic;
	end

	% load the image and extract the object patch
	I=imread(sprintf(VOCopts.imgpath,ids{i}));
	[nRow, nCol, nPlan]=size(I);
	% Read annotation
	rec=PASreadrecord(sprintf(VOCopts.annopath,ids{i}));

	% Random sample the negative patch
	% Each sample will be tried 10 times maximal
	for k=1:nPatches
		for j=1:10
			candBbox=fnRandWnd(nRow,nCol,gMaxHWRate);
			bDiscard=false;
			for m=1:length(rec.objects)
				bb=rec.objects(m).bbox;
				% Compare the bounding boxes
				if fnIoU(bb,candBbox)>=gMaxOverlapRate
					bDiscard=true;
					break;
				end
			end

			if bDiscard
				% If overlap too much
				continue;
			end

			% Save the patch
			negPatch=I(candBbox(2):candBbox(4),candBbox(1):candBbox(3),:);
			fileName=sprintf('%s/%05d.jpg', gPatchLoc, gNameIndex);
			gNameIndex=gNameIndex+1;
			imwrite(negPatch, fileName, 'jpeg');
			% Write the index file
			fprintf(fTrainNeg,[cd '/' fileName ' %d\n'],gLabel);
			nCounter=nCounter+1;
			break;
		end
	end
	if nCounter>=gNegTrainNum
		break;
	end
end

% Close the train index file
fclose(fTrainNeg);


% Start to extract the negative patches
disp('Start to extract the valid negative sample...');

% load training set 
[ids]=textread(sprintf(VOCopts.imgsetpath,VOCopts.testset),'%s');

% Calc the average number of patches sampled from each image
nPatches=ceil(gNegValidNum./length(ids));
% Init the patch counter
nCounter=0;

% iterate the images
for i=1:length(ids)
	% Show the progress
	if toc>1
		fprintf('Valid image:%d/%d\n',i,length(ids));
		tic;
	end

	% load the image and extract the object patch
	I=imread(sprintf(VOCopts.imgpath,ids{i}));
	[nRow, nCol, nPlan]=size(I);
	% Read annotation
	rec=PASreadrecord(sprintf(VOCopts.annopath,ids{i}));

	% Random sample the negative patch
	% Each sample will be tried 10 times maximal
	for k=1:nPatches
		for j=1:10
			candBbox=fnRandWnd(nRow,nCol,gMaxHWRate);
			bDiscard=false;
			for m=1:length(rec.objects)
				bb=rec.objects(m).bbox;
				% Compare the bounding boxes
				if fnIoU(bb,candBbox)>=gMaxOverlapRate
					bDiscard=true;
					break;
				end
			end

			if bDiscard
				% If overlap too much
				continue;
			end

			% Save the patch
			negPatch=I(candBbox(2):candBbox(4),candBbox(1):candBbox(3),:);
			fileName=sprintf('%s/%05d.jpg', gPatchLoc, gNameIndex);
			gNameIndex=gNameIndex+1;
			imwrite(negPatch, fileName, 'jpeg');
			% Write the index file
			fprintf(fValidNeg,[cd '/' fileName ' %d\n'],gLabel);
			nCounter=nCounter+1;
			break;
		end
	end
	if nCounter>=gNegValidNum
		break;
	end
end

% Close the train index file
fclose(fValidNeg);


