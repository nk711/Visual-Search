%% EEE3032 - Computer Vision and Pattern Recognition (ee3.cvpr)
%%
%% ComputeFD.m
%% Compute the centroid distance Fourier descriptors of a closed polygon
%%
%% Usage:  [FD] = ComputeFD (P,[n],[debug])
%%
%% IN:  P            - regularly sample polygon, vertices [x1,x2..;y1,y2..]
%%                     To create a reguarly sampled polygon use the
%%                     SamplePolygonPerimeter function
%%      n            - OPTIONAL e.g. [1:5] compute first 5 FDs. 
%%      debug        - OPTIONAL 0 or 1, the latter will plot signal pre-FFT
%%
%% OUT: FD           - The fourier descriptor/s requested [fd1 fd2..etc]
%%
%% (c) John Collomosse 2010  (J.Collomosse@surrey.ac.uk)
%% Centre for Vision Speech and Signal Processing (CVSSP)
%% University of Surrey, United Kingdom

function FD = ComputeFD (p, n, debug)

% handle second argument if absent
if nargin==1
    n=1:floor(size(p,2)/2);
    debug=0;
end
if nargin==2
    debug=0;
end

% compute centroid
mn=mean(p')';

% compute distance of each point to centroid
p=p-repmat(mn,1,size(p,2));
centdist=sqrt(sum(p.^2));
if (debug)
    figure;
    plot(centdist)
end
% fourier decomposition of signal "centdist"
F=fft(centdist);
% only interested in the magnitude of each frequency component
mag=sqrt(real(F).^2 + imag(F).^2);

% return the descriptors we are interested in
FD=mag(n);





