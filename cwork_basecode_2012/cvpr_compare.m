% This function calculates the distance between two images
function dst=cvpr_compare(F1, F2)
%dst2 = sqrt(sum((F1-F2).^2));
dst=norm(F1-F2);
% Double check if norm gives us the same result as the euclidian distance.
%if dst==dst2
%   disp("true");
%end
return;
