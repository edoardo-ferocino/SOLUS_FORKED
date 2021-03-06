%==========================================================================
%%  SETTING SOURCES (QVEC), DETECTORS (MVEC) AND THEIR PERMUTATIONS (DMASK)
%==========================================================================
% SOLUS SOURCES - DETECTOR POSITIONS
xd = linspace(-15,15,4);
yd = [-10,10];
zd = 0;

xs = xd;
ys = yd + [6,-6];
zs = zd;
[xxs,yys,zzs] = ndgrid(xs,ys,zs);
[xxd,yyd,zzd] = ndgrid(xd,yd,zd);

DOT.Source.Pos = [xxs(:),yys(:),zzs(:)];
DOT.Detector.Pos = [xxd(:),yyd(:),zzd(:)];

% non-contact PTB setup 40x40 mm2 scan with 8x8 and s-d 5mm
% rhozero
% rhosd = 5;
% % 8x8
% % DOT.Source.Pos = RasterScan(-20-rhosd/2,20-rhosd/2,-20,20,8,8,0);
% % DOT.Detector.Pos = RasterScan(-20+rhosd/2,20+rhosd/2,-20,20,8,8,0);
% % 16x16
% DOT.Source.Pos = RasterScan(-20-rhosd/2,20-rhosd/2,-20,20,16,16,0);
% DOT.Detector.Pos = RasterScan(-20+rhosd/2,20+rhosd/2,-20,20,16,16,0);

DOT.Source.Ns=size(DOT.Source.Pos,1);
DOT.Detector.Nd=size(DOT.Detector.Pos,1);
%% Define permutation matrix
% ALL COMBINATIONS: null-distances + all the other combinations
%DOT.dmask = logical(ones(DOT.Detector.Nd,DOT.Source.Ns));

% NULL-DISTANCE ONLY
%DOT.dmask = logical(eye(DOT.Detector.Nd,DOT.Source.Ns));

% ALL EXCEPT NULL-DISTANCE
DOT.dmask = logical(ones(DOT.Detector.Nd,DOT.Source.Ns) - ...
diag(diag(ones(DOT.Detector.Nd,DOT.Source.Ns)))); 
% SELECT A MEASUREMENT
% DOT.dmask = false(DOT.Detector.Nd,DOT.Source.Ns); 
% DOT.dmask(1,8) = true;
% -------------------------------------------------------------------------
