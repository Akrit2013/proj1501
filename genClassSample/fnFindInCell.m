% This funcion get a cell vector and find the location of the content in cell
% If no match can be found, reture -1
function idx=fnFindInCell(vec, target)

idx=-1;

for i=1:length(vec)
	if strcmp(target,vec{i})
		idx=i;
	end
end

end
