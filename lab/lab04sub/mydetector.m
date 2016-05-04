function Y = mydetector(x, smoothLength)
% % INPUTS:
% - x is output of one of your filter.
% - smoothLength is length of moving average filter to smooth out the
% variations.
% - thresh is the threshold level for amplitude to flip to 0 or 1.
%
% OUTPUT:
% - Y is the vector filtered output with better amplitude 

xa = abs(x);   % rectified output (nonnegative)
b = (ones(1,smoothLength)/smoothLength);
Y = filter(b, 1, xa);
end