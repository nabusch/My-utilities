function [dp1 dp2] = my_dpmafc(pcorrect, m)
% function [dp1 dp2] = my_dpmafc(pcorrect, m)
% Computes d-prime for mAFC tasks.
% pcorrect: proportion of correct responses.
% m: number of alternatives.
%
% dp1 is accurate for m < 12.
% 
% Both estimates of d-prime according to:
% Smith, JE: Simple algorithms for M-alternative forced-choice calculations.
% Perception & Psychophysics, 1982, 31(1).
%
% Niko Busch (niko.busch@gmail.com)
% March 27, 2012

K = 0.86 - 0.085*log(m-1);
dp1 = K .* log( ((m-1).*pcorrect) ./ (1-pcorrect) );


A = (-4 + sqrt(16 + 25 * log(m-1)))/ 3;
B = sqrt( (log(m-1) + 2) / (log(m-1) + 1) );
dp2 = A + B .* norminv(pcorrect);