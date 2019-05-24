%renderCovariance - render a covariance shape on the screen
%
% renderCovariance(PlatformState, Covariance, {PropertyList})
% renders a covariance on the screen as an ellipsoid The Covariance
% is assumed to be either 2x2 or 3x3. If 2x2, it is rendered in the
% X/Y plane unless otherwise directed.
%
% The properties available are:
%
% Scale - a relative scaling
% Plane - either 'XY', 'YZ', or 'XZ'
%
% Copywrite 2014 BBN Technologies, Matt Daily Author
function renderCovariance(PlatformState, Covariance, varargin)

Properties.Scale = 1;
Properties.Plane = 'XY';

[Properties, Unused] = setProperties(Properties,varargin{:});

% For now, we limit this to 3x3 matrices.
if (size(Covariance,1) ~= 3 || length(Covariance(:)) ~= 9)
  error 'WRong Size Covariance Matrix';
end

% First, let us draw the surface of the water.
HoldState = ishold;
hold on;

% OK, the plan is this: to make an ellipse, we make a sphere,
% stretch it along the three dimensions, then rotate it into the
% proper orientation. This is easily done with an eigenvalue
% decomposition.
[Matrix, Values] = eig(Covariance);
Values = diag(Values);

% Create a sphere
[X,Y,Z] = sphere(30);

% scale according to the eigenvalues and the input scale
X = X * Values(1) * Properties.Scale;
Y = Y * Values(2) * Properties.Scale;
Z = Z * Values(3) * Properties.Scale;

% Store the size of those matrices
Temp = size(X);

% Convert to points so we can rotate them  properly
Points = [X(:)';Y(:)';Z(:)'];
Points = computeRotationMatrix(PlatformState.Attitude) * Matrix * Points;

% Now reshape back into matrices
X = reshape(Points(1,:),Temp) + PlatformState.Position(1);
Y = reshape(Points(2,:),Temp) + PlatformState.Position(2);
Z = reshape(Points(3,:),Temp) + PlatformState.Position(3);

% And render them, with the lines turned off and the proper color
surf(X,Y,Z, ...
     'LineStyle','none', ...
     'FaceColor',[0.0 0.0 0.9], ...
     'FaceAlpha',0.4,Unused{:});

if (~HoldState)
  hold off;
end
