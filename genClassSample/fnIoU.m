% -------------------------------------------------
% Calc the IoU rate of the two given bboxes
% The bbox is defined as the pascal voc format
% bbox=[xMin, yMIn, xMax, yMax]
% -------------------------------------------------

function iou=fnIoU(bbox1,bbox2)

% create the map
map=zeros(max(bbox1(4),bbox2(4)),max(bbox1(3),bbox2(3)));

% Calc the intersection aera
imap=map;
imap(bbox1(2):bbox1(4),bbox1(1):bbox1(3))=1;
imap(bbox2(2):bbox2(4),bbox2(1):bbox2(3))=imap(bbox2(2):bbox2(4),bbox2(1):bbox2(3))+1;
imap(imap~=2)=0;
imap(imap==2)=1;
I=sum(sum(imap));
% Calc the Union aera
umap=map;
umap(bbox1(2):bbox1(4),bbox1(1):bbox1(3))=1;
umap(bbox2(2):bbox2(4),bbox2(1):bbox2(3))=1;
U=sum(sum(umap));

iou=I./U;

end
