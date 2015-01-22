% This script generate the image patches from the PASCAL VOC 2012 dataset
% Also it will generate the patches index list which should contain the full path of each patches and in addition with the class label from 0 to 19

tic;

% The location of the dev kits
gVOCdevkit='/VOCdevkit';
gVOCcode='/VOCcode';
gPatchLoc='./dataset';

% The file name of the index file contain the train images
gTrainIdxFile='train.txt';
gValidIdxFile='valid.txt';
gTextIdxFile='text.txt';

% should igore the 'difficult' target or not
bIncludeDifficult=0;

% Open the index files
fTrain=fopen(gTrainIdxFile, 'w');
fValid=fopen(gValidIdxFile, 'w');
fTest=fopen(gTextIdxFile, 'w');

if fTrain==-1 || fValid==-1 || fTest==-1
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


% First start with the train set
disp('Start to iterate the trainset');
% Iter the classes

% load training set 
[ids]=textread(sprintf(VOCopts.imgsetpath,VOCopts.trainset),'%s');

% iterate the images
for i=1:length(ids)
	% Show the progress
	if toc>1
		fprintf('Train image:%d/%d\n',i,length(ids));
		tic;
	end

	% load the image and extract the object patch
	I=imread(sprintf(VOCopts.imgpath,ids{i}));
	% Read annotation
	rec=PASreadrecord(sprintf(VOCopts.annopath,ids{i}));
	
	% Parse the annotation
	for j=1:length(rec.objects)
		bb=rec.objects(j).bbox;
		lbl=rec.objects(j).class;
		if rec.objects(j).difficult && bIncludeDifficult==false
			continue;
		end

		% Get the class index
		clsidx=fnFindInCell(VOCopts.classes, lbl);
		if clsidx==-1
			fprintf('Error: can not find the match class name %s\n', lbl);
			keyboard;
		end

		% extract the patch
		objPatch=I(bb(2):bb(4),bb(1):bb(3),:);
		% Generate the patch file name
		fileName=sprintf('%s/%05d.jpg', gPatchLoc, gNameIndex);
		gNameIndex=gNameIndex+1;
		imwrite(objPatch, fileName, 'jpeg');
		% Write the index file
		fprintf(fTrain,[cd '/' fileName ' %d\n'],clsidx-1);
	end
end

% Close the train index file
fclose(fTrain);

% First start with the valid set
disp('Start to iterate the validset');
% Iter the classes

% load training set 
[ids]=textread(sprintf(VOCopts.imgsetpath,VOCopts.testset),'%s');

% iterate the images
for i=1:length(ids)
	% Show the progress
	if toc>1
		fprintf('Valid image:%d/%d\n',i,length(ids));
		tic;
	end

	% load the image and extract the object patch
	I=imread(sprintf(VOCopts.imgpath,ids{i}));
	% Read annotation
	rec=PASreadrecord(sprintf(VOCopts.annopath,ids{i}));
	
	% Parse the annotation
	for j=1:length(rec.objects)
		bb=rec.objects(j).bbox;
		lbl=rec.objects(j).class;
		if rec.objects(j).difficult && bIncludeDifficult==false
			continue;
		end

		% Get the class index
		clsidx=fnFindInCell(VOCopts.classes, lbl);
		if clsidx==-1
			fprintf('Error: can not find the match class name %s\n', lbl);
			keyboard;
		end

		% extract the patch
		objPatch=I(bb(2):bb(4),bb(1):bb(3),:);
		% Generate the patch file name
		fileName=sprintf('%s/%05d.jpg', gPatchLoc, gNameIndex);
		gNameIndex=gNameIndex+1;
		imwrite(objPatch, fileName, 'jpeg');
		% Write the index file
		fprintf(fValid,[cd '/' fileName ' %d\n'],clsidx-1);
	end
end

% Close the index file
fclose(fValid);
