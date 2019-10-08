% find the 4 corners of the court in the video recording using readPoints
% than compute the transsformation to sqaure court

court_orig=   [     140         125;
    1466         125;
    1120         615;
    482         615];

court_square=[     140         125;
    1466         125;
    1466         615;
    140         615];

court_trans = cp2tform(court_orig,  court_square, 'projective');
% A = tformfwd(court_orig, court_trans);