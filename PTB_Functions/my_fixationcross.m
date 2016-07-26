function my_fixationcross(window, x, y, cross_length, thickness, color);
% my_fixationcross(window, x, y, cross_length, thickness, color);
%
% Paints a fixation cross on the screen;
% 
% window: window pointer
% x: x coordinate 
% y: y coordinate
% cross_length: length of the cross arms
% thickness: thickness of the lines
% color: RGB triplet for the cross' color
%
% Written by Niko Busch on June 3, 2011
% niko.busch@charite.de

Screen('DrawLine', window, color, x-cross_length, y, x+cross_length, y, thickness);
Screen('DrawLine', window, color, x, y-cross_length, x, y+cross_length, thickness);
