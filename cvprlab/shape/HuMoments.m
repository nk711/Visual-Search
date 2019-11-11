%% EEE3032 - Computer Vision and Pattern Recognition (ee3.cvpr)
%%
%% HuMoments.m
%% Computes Hu's seven invariant moments using a combination of central
%% moments.
%%
%% Usage:  D = HuMoments (mask)
%%
%% IN:  mask         - The binary mask
%% 
%% OUT: D            - 7 Hu Moments [h1 h2 h3 h4 h5 h6 h7]
%%
%% (c) John Collomosse 2010  (J.Collomosse@surrey.ac.uk)
%% Centre for Vision Speech and Signal Processing (CVSSP)
%% University of Surrey, United Kingdom

function H=HuMoments(mask)

H=zeros(1,7);


H(1)=CentralMoment(mask,[2 0]) + CentralMoment(mask,[0 2]);

H(2)=(CentralMoment(mask,[2 0]) - CentralMoment(mask,[0 2]))^2 + 4* CentralMoment(mask,[1 1])^2;

H(3) = (CentralMoment(mask,[3 0]) - 3*CentralMoment(mask,[1 2]))^2 + 3*(CentralMoment(mask,[2 1])  - CentralMoment(mask,[0 3]))^2;

H(4) = (CentralMoment(mask,[3 0]) + CentralMoment(mask,[1 2]))^2 + (CentralMoment(mask,[2 1]) + CentralMoment(mask,[0 3]))^2;

H(5) = (CentralMoment(mask,[3 0]) - 3*CentralMoment(mask,[1 2]))*(CentralMoment(mask,[3 0]) + CentralMoment(mask,[1 2]))* ( (CentralMoment(mask,[3 0]) + CentralMoment(mask,[1 2]))^2 - (CentralMoment(mask,[2 1]) + CentralMoment(mask,[0 3]))^2 );

H(6) = (CentralMoment(mask,[2 0]) - CentralMoment(mask,[0 2]))*( (CentralMoment(mask,[3 0]) + CentralMoment(mask,[1 2]))^2 - (CentralMoment(mask,[2 1]) + CentralMoment(mask,[0 3]))^2 + 4*CentralMoment(mask,[1 1])*(CentralMoment(mask,[3 0]) + CentralMoment(mask,[1 2]))*(CentralMoment(mask,[2 1]) + CentralMoment(mask,[0 3])) );

H(7) = (3*CentralMoment(mask,[2 1]) - CentralMoment(mask,[0 3]))*(CentralMoment(mask,[3 0]) + CentralMoment(mask,[1 2]))*( (CentralMoment(mask,[3 0])+CentralMoment(mask,[1 2]))^2 - 3*(CentralMoment(mask,[2 1])+CentralMoment(mask,[0 3]))^2 );

H(7) = H(7) + (CentralMoment(mask,[0 3]) - 3*CentralMoment(mask,[1 2]))*(CentralMoment(mask,[2 1]) + CentralMoment(mask,[0 3]))*( 3*(CentralMoment(mask,[3 0])+CentralMoment(mask,[1 2]))^2 - (CentralMoment(mask,[2 1])+CentralMoment(mask,[0 3]))^2  );

