function [rec, det, lam, corm, Rec_matrix] = rqa(xcoor, ycoor, Rshow, radius, linelength)
% RQA This script calculates the four recurrence analysis measures as mentioned in the following paper. 
% If using the code, please cite the paper 'Recurrence quantification analysis reveals eye-movement behavior differences between experts and novices
% P Vaidyanathan, J Pelz, C Alm, P Shi, A Haake - Proceedings of the Symposium on Eye Tracking Research Application, ETRA 2014

%   To run this code and obtain recurrence measures, data should be provided. 
%   This function calculates the recurrence, determinism, laminarity and
%   center of recurrence mass as defined by the equations in Anderson et.
%   al.,(Behavioral Res, 2013).
%  INPUT:   xcoor      --- x coordinates for eye movement fixations (column vector Nx1)
%           ycoor      --- y coordinates for eye movement fixations (column vector Nx1)
%           Rshow      --- whether to plot the recurrence values 
%           radius     --- dist. b/w fixations for recurrence (default = 64, based on foveal approximation)
%           linelength --- line length for vert., horiz. and diagnoal lines (scalar, default = 2)
%  OUTPUT:  rec        --- recurrence measure (scalar)
%           det        --- determinism measure (scalar)
%           lam        --- laminarity measure (scalar)
%           corm       --- center of recurrence mass (scalar)
%           REC_matrix --- recurrence matrix for plotting (matrix)

% Default parameters
if nargin <3
     Rshow = 0;
end
if nargin <4
    radius = 64;       
end
if nargin < 5
    linelength = 2;   
end


% Number of fixations
NofFix = size(xcoor,1);

% Distance matrix - distance between each fixation to the other fixation
dist_matrix = sqrt((bsxfun(@minus, xcoor, xcoor')).^2+(bsxfun(@minus, ycoor, ycoor')).^2);

% Threshold for the given radius (fixation distance)
Rec_matrix = (dist_matrix <= radius);

% Get only the upper triangle without the lin of incidence
UT_Rec_matrix = triu(Rec_matrix,1);

% Recurrence measures
R = sum(UT_Rec_matrix(:));

% Diagonal lines
[Rdiagonals,Idiagonals] = spdiags(UT_Rec_matrix);

Diag_Lines = [];
for i = 1:length(Idiagonals)
    d = [0;Rdiagonals(:,i);0];
    diagchange = diff(d);
    dl = find(diagchange == -1) - find(diagchange == 1);
    dl = dl(dl >= linelength);
    Diag_Lines = [Diag_Lines;dl];
end
Diag_Lines = sum(Diag_Lines);

% Horizontal & Vertical lines
VertHorz_Lines = [];
% remove line of incidence - main diagonal but keep rest
paddedRM = [zeros(NofFix, 1) Rec_matrix-eye(NofFix) zeros(NofFix, 1)];
paddedRM = max(paddedRM,0);
for i = 1:NofFix
    v = paddedRM(i,:);
    vchange = diff(v);
    vl = find(vchange==-1)-find(vchange==1);
    vl = vl(vl >= linelength);
    VertHorz_Lines = [VertHorz_Lines vl];
end
VertHorz_Lines = sum(VertHorz_Lines);

% Recurrence REC
rec = 100*2*R/(NofFix*(NofFix-1));

% Determinism DET
det = 100*Diag_Lines/R;

% Laminarity LAM
lam = 100*VertHorz_Lines/(2*R);

% CORM - center of recurrence mass
corm = NaN;
if ~isempty(Rdiagonals)&& ~isempty(Idiagonals)
corm = 100*sum(sum(Rdiagonals)'.*Idiagonals)/((NofFix-1)*R);
end

% show the recurrence plot
if Rshow == 1
    image(Rec_matrix*255);
    colormap(gray),set(gca,'YDir','normal');
end    
end

