function figH = center_fig(figH)

% function figH = center_fig(figH)
% Simply centers the figure on the screen.

%%


old_units = figH.Units;

figH.Units = 'pixels';

figsize = figH.Position;
screensize = get(0,'screensize');

figH.OuterPosition = [0.5*screensize(3)-0.5*figsize(3), ...
    0.5*screensize(4)-0.5*figsize(4), figsize(3), figsize(4)];

figH.Units = old_units;