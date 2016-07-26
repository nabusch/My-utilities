function [pairs] = my_pairchannels(chanlocs);
% [pairs] = my_pairchannels(chanlocs);
%
% Finds pairs of homologous channels (e.g. Fp1 and Fp2). 
% Takes an EEGLAB chanlocs structure as input.
% Output:
% 1st column: running index of channels
% 2nd column: index of the pair this channel belongs to. Zero means it does
% not belong to any channel.
% 3rd channel: code for left/midline/right (-1/0/1)

nchans = length(chanlocs);
chanmat = [ [chanlocs.X]; [chanlocs.Y]]';
chanmat = round(chanmat);

pairs_index = 0;
pairs = zeros(length(chanmat),3);

for row = 1:length(chanmat)
    pairs(row, 1) = row; % first column is just a running index of the channels
    
    if pairs(row,3); continue; end;
    
    % Skip channels on the midline
    if chanmat(row, 2) == 0
        pairs(row, 2) = 0; % second column codes membership to a pair; zero means not a member of a pair
        pairs(row, 3) = 0; % third column codes left, midline or right
    else        
        for row2=row+1:length(chanmat)            
            if chanmat(row,1)==chanmat(row2,1) && abs(chanmat(row,2))==abs(chanmat(row2,2))
                pairs_index = pairs_index + 1;
                pairs(row, 2)  = pairs_index; % second column codes membership to a pair
                pairs(row2, 2) = pairs_index;     
                
                pairs(row, 3)  = -sign(chanmat(row,2)); % third column codes left, midline or right
                pairs(row2, 3) = -sign(chanmat(row2,2));  
                break
            end
        end
    end
end
