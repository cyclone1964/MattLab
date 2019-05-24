%renderBeamPattern - render a beam pattern
%
% renderBeamPattern(State,BeamPattern, Directions) renders a beam
% pattern in three dimensions on the screen as if it were transmitted
% from the normal of an array. The beam pattern is assumed
% rotationally symmetric around the normal of an array, and is assiged
% a j1(kasin(theta))/kasin(theta) type of patter with a 2 lambda
% aperture. The pattern can be overriden using the following
% properties
%
% Scale - maximum scale of beam pattern
% Aperture - aperture of the array in wavelengths
% ArrayType - 'circular', 'rectangular', or 'table'
% BeamPatternTable - a table of beam pattern values.
%
% The beam pattern table is assumed to be equispaced in off-axis
% angle (normal) from 0 to pi/2. 
function [X,Y,Z] = renderBeamPattern(State,varargin)

Properties.Scale = 1;
Properties.Aperture = 2;
Properties.ArrayType = 'Circular';
Properties.AngleLimit = pi/2;
Properties.DonutFactor = 0;
Properties.BeamPatternTable = [];
Properties.MinDepth = 0;
Properties.MaxDepth = inf;

[Properties, varargin] = setProperties(Properties,varargin{:});

Temp = 2*pi*(0:5:180)/180;

switch(lower(Properties.ArrayType))
  case 'circular'
    Angles = 0:(pi/180):Properties.AngleLimit;
    Argument = 2*pi*Properties.Aperture*sin(Angles);
    Argument = max(Argument,1e-20);
    Properties.BeamPatternTable = ...
	abs(2*besselj(Properties.DonutFactor + 1,Argument)./Argument);
  case 'rectangular'
    Angles = 0:(pi/180):Properties.AngleLimit;
    Argument = 2*pi*Properties.Aperture*sin(Angles);
    Argument = max(Argument,1e-20);
    Properties.BeamPatternTable = abs(sin(Argument)./Argument);
  case 'table'
    Angles = (1:length(Properties.BeamPatternTable))-1;
    Angles = (pi/2)*Angles/max(Angles);
end

% Normalize beam pattern to 1
Properties.BeamPatternTable = ...
    Properties.BeamPatternTable/max(Properties.BeamPatternTable);

% Now we go through and create the beam pattern X, Y, and Z
% matrices.
NumAngles = length(Angles);
X = [];
Y = [];
Z = [];
for AngleIndex = 1:NumAngles
  X = [X
       cos(Angles(AngleIndex)) * ...
       Properties.BeamPatternTable(AngleIndex) * ...
       ones(size(Temp))];
  Y = [Y
       Properties.BeamPatternTable(AngleIndex) * ...
       sin(Angles(AngleIndex)) * cos(Temp)];
  Z = [Z
       Properties.BeamPatternTable(AngleIndex) * ...
       sin(Angles(AngleIndex)) * sin(Temp)];
end

X = X * Properties.Scale;
Y = Y * Properties.Scale;
Z = Z * Properties.Scale;

% Now, clip the depths
% Now Render
if (nargout == 0)
  renderComponent(X,Y,Z,State,'FaceColor',[0 0.5 0], varargin{:}, ...
		  'ZLimits',[Properties.MinDepth,Properties.MaxDepth]);
end
