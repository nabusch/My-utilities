function my_fixationpoint(window, x, y, diameter, fillcolor);
% my_fixationcross(window, x, y, diameter, fillcolor);
%
% Paints a fixation ponit on the screen;
% 
% window: window pointer
% x: x coordinate 
% y: y coordinate
% diameter: size of the circle
% fillcolor: RGB triplet for the cross' color
%
% Written by Niko Busch on September 12, 2012
% niko.busch@charite.de

Screen('FillOval', window, fillcolor, [x-0.5*diameter, y-0.5*diameter, x+0.5*diameter, y+0.5*diameter]);
