%% N(d): CUMULATIVE STANDARD NORMAL DISTRIBUTION FUNCTION 

function Prob = N(d)
Prob = 0.5 + 0.5.*erf(d./sqrt(2));
