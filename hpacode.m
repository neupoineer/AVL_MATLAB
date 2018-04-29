function [ resultST ] = hpacode( parameterChanged, enterIfMassFull)
    %% Sean Rich Nov 2017
    
    %runAVL.m
    %
    %You must edit the avlLocation variable to contain the filename and
    %location of the avl executable.
    %This script creates an avl batch script and then executes it.
    %Requires the following files to be in the same directory:
    %  h8.dat
    %  w13.dat
    %  v21.dat
    %  hpafuse.dat
    %  hpa2.avl
    %  hpa.avl %may not need this one
    %  avl.exe
    %% INPUT variables
    filename = '.\wingproject'; %this is what you load into avl, DO NOT add a .avl extension--it is later in the code
    %velocity = 10;%m/s

    %Variables used to initialize run cases
    massEmpty = 2.7973; %slugs
    massFull = 6.527; %slugs
    gravity = 386.09; %in/s^2
    airDensity = 0.000001377; % slug/in^3
    X_CG = 15.0000; %in

    %Define a base file name to save data from executed cases into
    basename = '.\sampleData\newData1';
    %Location of avl 
    avlLocation = '.\avl.exe';

    %% Directory Preparation
    %Purge Directory of interfering files
    [status,result] =dos(strcat('del ',basename,'.st'));
    [status,result] =dos(strcat('del ',basename,'.sb'));
    [status,result] =dos(strcat('del ',basename,'.run'));
    [status,result] =dos(strcat('del ',basename,'.eig'));

    %% Create run file
    %Open the file with write permission
    fid = fopen(strcat(basename,'.run'), 'w');

    %Load the AVL definition of the aircraft
    fprintf(fid, 'LOAD %s\n', strcat(filename,'.avl'));

    %Load mass parameters
    %fprintf(fid, 'MASS %s\n', strcat(filename,'.mass'));
    %fprintf(fid, 'MSET\n');
    %Change this parameter to set which run cases to apply 
    %fprintf(fid, '%i\n',   0); 

    %Disable Graphics
    fprintf(fid, 'PLOP\ng\n\n'); 

    %Open the OPER menu
    fprintf(fid, '%s\n',   'OPER');   

    %Define the run case 
    fprintf(fid, '%s\n',   'c1');
    %fprintf(fid, 'v %6.4f\n', parameterChanged); %velocity has to go first and I'm not sure why
    if nargin < 2
        fprintf(fid, 'm %6.4f\n',massEmpty);
    else
        fprintf(fid, 'm %6.4f\n',massFull);
    end
    fprintf(fid, 'g %6.4f\n',gravity);
    fprintf(fid, 'd %6.9f\n',airDensity); %need extra precision because of units
    fprintf(fid, 'x %6.4f\n',X_CG);
    fprintf(fid, '\n');
    fprintf(fid, 'a a %6.4f\n',parameterChanged);
    

    %Options for trimming
    %fprintf(fid, '%s\n',   'd1 rm 0'); %Set surface 1 so rolling moment is 0
    %fprintf(fid, '%s\n',   'd2 pm 0'); %Set surface 2 so pitching moment is 0

    %Run the Case
    fprintf(fid, '%s\n',   'x'); 

    %Save the st data
    fprintf(fid, '%s\n',   'st'); 
    fprintf(fid, '%s%s\n',basename,'.st');   
    %Save the sb data
    %fprintf(fid, '%s\n',   'sb');
    %fprintf(fid, '%s%s\n',basename,'.sb');

    %Drop out of OPER menu
    %fprintf(fid, '%s\n',   '');

    %Switch to MODE menu
    %fprintf(fid, '%s\n',   'MODE');
    %fprintf(fid, '%s\n',   'n');
    %Save the eigenvalue data
    %fprintf(fid, '%s\n',   'w');
    %fprintf(fid, '%s%s\n', basename,'.eig');   %File to save to

    %Exit MODE Menu
    fprintf(fid, '\n');     
    %Quit Program
    fprintf(fid, 'Quit\n'); 

    %Close File
    fclose(fid);

    %% Execute Run
    %Run AVL using 
    [status,result] = dos(strcat(avlLocation,' < ',basename,'.run'));

    %Parsing File
    %Download Jospher Moster's aerospace design toolbox used to parse files
    %Put all of these files in the same directory as this script and the avl
    %executable

    %[resultST] = parseST('.\sampleData\newData1.st');
    [resultST] = parseRunCaseHeader('.\sampleData\newData1.st'); 
end