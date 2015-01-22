% --------------------------------------------------------
% This function generate a random window bbox given the size of the whole image
% The bbox format is the same as the pascal voc format
% bbox=[xMin, yMin, xMax, yMax]
% --------------------------------------------------------

function bbox=fnRandWnd(orgRows, orgCols, maxHWRate)

rRange=randi(orgRows-1);
HWRate=1+abs(maxHWRate-1)*rand(1);

if randi(2)==1
    cRange=min(orgCols-1, round(rRange./HWRate));
else
    cRange=min(orgCols-1, round(rRange.*HWRate));
end

rMin=randi(orgRows-rRange);
try
cMin=randi(orgCols-cRange);
catch
    keyboard;
end

bbox=[cMin, rMin, cMin+cRange, rMin+rRange];


end
