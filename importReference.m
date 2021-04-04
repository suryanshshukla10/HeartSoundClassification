function reffile = importReference(filename, startRow, endRow)
delimiter = ',';
if nargin<=2
    startRow = 1;
    endRow = inf;
end

formatSpec = '%s%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

fclose(fileID);
reffile = table(dataArray{1:end-1}, 'VariableNames', {'record_name','record_label'});