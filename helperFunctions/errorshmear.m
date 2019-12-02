function hh = errorshmear(varargin)
%ERRORSHMEAR Error shmear plot.
%   ERRORSHMEAR(X,Y,L,U) plots the graph of vector X vs. vector Y with
%   error bars specified by the vectors L and U.  L and U contain the
%   lower and upper error ranges for each point in Y.  Each error bar
%   is L(i) + U(i) long and is drawn a distance of U(i) above and L(i)
%   below the points in (X,Y).  The vectors X,Y,L and U must all be
%   the same length.  If X,Y,L and U are matrices then each column
%   produces a separate line.
%
%   ERRORSHMEAR(X,Y,E) or ERRORSHMEAR(Y,E) plots Y with error bars [Y-E Y+E].
%   ERRORSHMEAR(...,'LineSpec') uses the color and linestyle specified by
%   the string 'LineSpec'.  The color is applied to the data line and
%   error bars while the linestyle and marker are applied to the data
%   line only.  See PLOT for possibilities.
%
%   ERRORSHMEAR(AX,...) plots into AX instead of GCA.
%
%   H = ERRORSHMEAR(...) returns a vector of errorbarseries handles in H.
%
%   For example,
%      x = 1:10;
%      y = sin(x);
%      e = std(y)*ones(size(x));
%      errorshmear(x,y,e)
%   draws symmetric error bars of unit standard deviation.

% Parse possible Axes input
% error(nargchk(2,,nargin,'struct'));
% NOTE: 'linestyle' property applies to both main line and errorshmear

% adapted from errorbar by JLY (c) 2012
[cax,args,nargs] = axescheck(varargin{:});


vargs = cell(nargs,1);
for ii = 1:nargs
    if ischar(args{ii})
        vargs{ii} = lower(args{ii});
    else
        vargs{ii} = args{ii};
    end
end

x = args{1};
y = args{2};
sx = size(x);
sy = size(y); 

if sx(1) > sx(2), x = x'; end
if sy(1) > sy(2), y = y'; end


if ischar(args{3})
    l = zeros(1,length(x));
    u = zeros(1,length(y));
    targs = args(3:end);
else
    l  = args{3};
    sl = size(l);
    if sl(1) > sl(2), l = l'; sl = size(l); end
    
    if sl(1) == 2
        u = l(2,:);
        l = l(1,:);
        targs = args(4:end);
    elseif sl(1) == 1
    	if ischar(args{4}) 
            l = l(1,:);
            u = l;
            targs = args(4:end);
        elseif ~ischar(args{4}) 
            l = l(1,:);
            u = args{4};
            su = size(u);
            if su(1) > su(2)
                u = u';
            end
            targs = args(5:end);
        end
    
    end
end
        

polyx = [x fliplr(x)];
polyy = [y+abs(u) fliplr(y-abs(l))];


hh = fill(polyx,polyy, targs{:}); 


end



