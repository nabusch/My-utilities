function my_tfmark(f, tmin, tmax, fmin, fmax)
%function my_tfmark(f, tmin, tmax, fmin, fmax);

% [~,fmin] = min(abs(f-fmin));
% [~,fmax] = min(abs(f-fmax));

plot3([tmin tmax tmax tmin tmin],[fmin fmin fmax fmax fmin],[100 100 100 100 100], 'linewidth', 2, 'color', 'w')