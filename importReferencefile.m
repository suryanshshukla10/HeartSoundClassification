function REFERENCE = importReferencefile(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as a matrix.
%   REFERENCE = IMPORTFILE(FILENAME) Reads data from text file FILENAME for
%   the default selection.
%
%   REFERENCE = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from rows
%   STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   REFERENCE = importfile('REFERENCE.csv', 1, 409);
%
%    See also TEXTSCAN.
% Copyright (c) 2016, MathWorks, Inc. 
% Auto-generated by MATLAB on 2016/06/18 16:21:14

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 1;
    endRow = inf;
end

%% Format string for each line of text:
%   column1: text (%s)
%	column2: double (%f)
% For more information, see the TEXTSCAN documentation.
% formatSpec = '%s%f%[^\n\r]';
formatSpec = '%c';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.
%% Create output variable
REFERENCE = table(dataArray{1:end-1}, 'VariableNames', {'record_name','record_label'});
