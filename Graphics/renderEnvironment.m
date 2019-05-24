%renderEnvironment - renders an ocean environment
%
% renderEnvironment(Environment, Extents) renders an ocean
% environment. The water is a translucent light blue, the surface a
% bit darker, and the bottom dark blue.
%
% The input Extents is a 2x2 matrix with the first row being the
% minumum and maximum X values, the second row Y. If not provided,
% this is assumed to be [-1000 1000; -1000 1000];
%
% The depth of the ocean is taken from the watercolumn depth.
%
% Copywrite 2014 BBN Technologies, YourNameHere Author
function renderEnvironment(Environment,Limits)

% If no limits are given, let's make some
if (nargin < 2)
  Limits = [-1000 1000; -1000 1000];
end

% First, let us draw the surface of the water.
HoldState = ishold;
hold on;

% Save the state of the rng an then set it to the defaults. This
% means that every time we render the same environment, it will
% look the same
GeneratorState = rng;
rng('default');

% For the surface and the bottom, we generate random colors and
% interpolate the shading between them
Strides = diff(Limits,1,2)/20;
X = Limits(1,1):Strides(1):Limits(1,2);
Y = Limits(2,1):Strides(2):Limits(2,2);
Z = zeros(length(X),length(Y));

Temp = randn(length(X),length(Y));
Temp = Temp - min(Temp(:));
Temp = Temp/max(Temp(:));
Temp = 0.5 + 0.5 * Temp;
Color = zeros(length(X), length(Y), 3);
Color(:,:,3) = Temp;
surf(X,Y,Z,Color, 'FaceColor','interp', 'LineStyle','none', 'FaceAlpha',0.75);

% Now the bottom. In order to give it some good color, we break it
% up into small patches and assign them random colors. Then when we
% render them we assign colors along a blue colormap and let the
% interpolator give it a good color.
Depth = max(Environment.WaterColumn.Depth);
Z =  Depth * ones(length(X),length(Y));
Temp = randn(length(X),length(Y));
Temp = Temp - min(Temp(:));
Temp = Temp/max(Temp(:));
Color = zeros(length(X), length(Y), 3);
Color(:,:,1) = 0.60 + 0.4*+Temp;
Color(:,:,2) = 0.4 + 0.2*Temp;
Color(:,:,3) = 0.3 + 0.1*Temp;
surf(X,Y,Z,Color, ...
     'FaceColor','interp', 'LineStyle','none', 'MarkerEdgeColor','none');

% now, the four sides
X = [Limits(1,1) Limits(1,1) Limits(1,1) Limits(1,1)];
Y = [Limits(2,1) Limits(2,2) Limits(2,2) Limits(2,1)];
Z = [ 0 0 Depth Depth];
patch(X,Y,Z,[0 0 1],'FaceAlpha',0.25,'LineStyle','none');

X = [Limits(1,2) Limits(1,2) Limits(1,2) Limits(1,2)];
Y = [Limits(2,1) Limits(2,2) Limits(2,2) Limits(2,1)];
Z = [ 0 0 Depth Depth];
patch(X,Y,Z,[0 0 1],'FaceAlpha',0.25,'LineStyle','none');

X = [Limits(1,1) Limits(1,2) Limits(1,2) Limits(1,1)];
Y = [Limits(2,1) Limits(2,1) Limits(2,1) Limits(2,1)];
Z = [0 0 Depth Depth];
patch(X,Y,Z,[0 0 1],'FaceAlpha',0.25,'LineStyle','none');

X = [Limits(1,1) Limits(1,2) Limits(1,2) Limits(1,1)];
Y = [Limits(2,2) Limits(2,2) Limits(2,2) Limits(2,2)];
Z = [0 0 Depth Depth];
patch(X,Y,Z,[0 0 1],'FaceAlpha',0.25,'LineStyle','none');

% Put the bottom on the actual bottom
set(gca,'ZDir','reverse');

% now, set the random number generator back to where it was
rng(GeneratorState);
