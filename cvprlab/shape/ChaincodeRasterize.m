%% EEE3032 - Computer Vision and Pattern Recognition (ee3.cvpr)
%%
%% ChaincodeRasterize.m
%% Rasterize the region encoded by a chaincode
%%
%%
%% Usage:  [mask, polyg] = ChaincodeRasterize (cc,[startpoint])
%%
%% IN:  cc         - The chain code string [0=N,1=NE...7=NW]
%%      csize      - OPTIONAL size of canvas to draw shape on (if absent
%%                   this will default to the largest size that will fit 
%%                   the portion of the shape falling within valid/positive
%%                   space)
%%      startpoint - OPTIONAL coordinates of start point (default [0;0], or
%%                   if csize also absent, will be auto-set to bring shape 
%%                   into positive/valid space)
%%
%% OUT: mask       - The binary mask, containing a single filled region
%%      polyg      - Polygon reconstructed from chaincode
%%
%% (c) John Collomosse 2010  (J.Collomosse@surrey.ac.uk)
%% Centre for Vision Speech and Signal Processing (CVSSP)
%% University of Surrey, United Kingdom

function [mask pts]=ChaincodeRasterize(cc,canvassize,startpoint)

if nargin<=2
    startpoint=[0;0];
end

if (size(startpoint,2)==2 & size(startpoint,1)==1)
    startpoint=startpoint';
end

pts=startpoint;
currentpoint=startpoint;

for c=1:length(cc)
    currentpoint=makemove(currentpoint,cc(c));
    pts=[pts currentpoint];
end

if nargin==1
    % debug mode - just make a canvas big enough and centre the shape
    pts=round(pts);
    pts=pts-repmat([min(pts(1,:));min(pts(2,:))],1,size(pts,2));
    canvas=zeros(max(pts(2,:)),max(pts(1,:)));
    mask=roipoly(canvas,pts(1,:),pts(2,:));
else
    if nargin==2
        canvas=zeros(max(pts(2,:)),max(pts(1,:)));
    else        
        canvas=zeros(canvassize(1),canvassize(2));
    end
    mask=roipoly(canvas,pts(1,:),pts(2,:));
end


return;

function pt=makemove(pt, movecode)

    switch movecode
        case 0 %N
            pt(2)=pt(2)-1;
        case 1 %NE
            pt(1)=pt(1)+1;
            pt(2)=pt(2)-1;
        case 2 %E
            pt(1)=pt(1)+1;
        case 3 %SE
            pt(1)=pt(1)+1;
            pt(2)=pt(2)+1;
        case 4 %S
            pt(2)=pt(2)+1;
        case 5 %SW
            pt(1)=pt(1)-1;
            pt(2)=pt(2)+1;
        case 6 %W
            pt(1)=pt(1)-1;
        case 7 %NW
            pt(1)=pt(1)-1;
            pt(2)=pt(2)-1;
    end
    
return;
