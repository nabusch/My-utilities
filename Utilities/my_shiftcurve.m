function outcurve = my_shiftcurve(incurve, timepoint, shift, sd, method);
% function outcurve = my_shiftcurve(incurve, timepoint, shift, sd, method);
% Modifies a time series by a factor.
%
% incurve - input time series
% timepoint - which point should be the center of modification?
% shift - by which factor?
% sd - standard deviation of the gaussian
% method - 'add' or 'mult'



% create a gaussia distribution and scale it, so that the peak of the bell
% curve has a magnitude equal to the desired new modification.
ngausspoints = sd * 10;
x = [-ngausspoints:ngausspoints];
y = normpdf(x,0,sd);
y = shift .* (1/max(y)) .* y;

if (strcmp(method,'add'))
    gausscurve = zeros(size(incurve));
    gausscurve(timepoint-(ngausspoints):timepoint+(ngausspoints)) = y;
    outcurve = gausscurve + incurve;
elseif (strcmp(method,'mult'))
    gausscurve = ones(size(incurve));
    gausscurve(timepoint-(ngausspoints):timepoint+(ngausspoints)) = y+1;
    outcurve = gausscurve .* incurve;    
end


