T = readtable('registerlist.xls');
matrNr=T.mat;
len=length(matrNr);
version_ind= [1 2 3 4 5];
versions = {'ver1','ver2','ver3','ver4','ver5'};
M = containers.Map(version_ind,versions);
% randomly generate examation sheets for all registered students
% with combination of 5 different version from 8 questionsets
r = randi(5,len,8);
keySet = num2cell(r);
valueSet = values(M,keySet);
% modify the tex file
for i=1:len
    text=fileread(template_main.tex);
    % in main.tex file the sub tex files with 
    % name aufgabe1___.tex, aufgabe2___.tex,... 
    % are runed with coresponding versions.
    old = '___';
    new = string(valueSet(i,:));
    textnew = strrep(text,old,new);
    texFileName = ['klausur_' num2str(MatrNr(i)) '.tex'];
    fileID = fopen(texFileName,'w');
    fprintf(fileID,'%s',newtext);
    fclose(fileID);
    %complie the tex and output the pdf
    texcommand='pdflatex texFileName.tex';
    status1 = system(texcommand);
end
% protect the pdf with password AES128
pdfcommand=('pdftk texFileName.pdf output texFileName                                                                                                                                                                                                                                                                                                                                                                                                           .128.pdf owner_pw mypw user_pw stupw')
status2 = system(pdfcommand);
% zip the pdf with password 'mypassword'
zipcommand=('7za a myfile.zip test.pdf -tzip -mem=AES256 -mx9 -pmypassword';
%-mem=ZipCrypto, AES128, AES192, AES256 for different encryption method
status3 = system(zipcommand);