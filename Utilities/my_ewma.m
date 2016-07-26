function [ewma, ci, sort_rt, sort_correct, sortinds] = my_ewma(rts, correct, lambda)
% function [ewma, ci, sort_rt] = my_ewma(rts,correct, lambda)
%
% Computes the "expontentially weighted moving average" according to the
% formula given in 
% Milosavljevic M, Madsen E, Koch C, Rangel A.
% Fast saccades toward numbers: simple number comparisons can be made in as little as 230 ms.
% J Vis. 2011 Apr 6;11(4)
%
% rts: a vector of response times (needs not to be sorted).
% correct: for each of these rts a value indicating correctness of the
% response (1=correct; 0=incorrect).
% lambda: "memory" of the moving average. Smaller values mean longer
% memory; smoother curves and slower response to changes in performance.
%
% ewma: exponentially weighted moving average
% ci: confidence interval
% sort_rt: sorted rts, sorted the same way as the ewma


[sort_rt, sortinds] = sort(rts);
sort_correct = correct(sortinds);

ewma = [];

for i = 1:length(sort_rt)   
    if i==1
        ewma(end+1) = lambda*sort_correct(i) + (1-lambda)*0.5;         
    else
        ewma(end+1) = lambda*sort_correct(i) + (1-lambda)*ewma(end); 
    end
   
    ci(1,i) = 0.5 + 1.5 * 0.5 * sqrt( (lambda/(2-lambda)) * (1-(1-lambda)^(2*i)) );        
    ci(2,i) = 0.5 - 1.5 * 0.5 * sqrt( (lambda/(2-lambda)) * (1-(1-lambda)^(2*i)) );     
end