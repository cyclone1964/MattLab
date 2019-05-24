%renderComponent - render a component at a location
%
% renderComponent(X,Y,Z,State,Color) renders the shape defined by
% X, Y, and Z at the location given by the state, oriented along
% the direction of the velocity (if any), otherwise along the line
% of sight
%
% Copywrite 2011 BBN Technologies, Matt Daily author
function renderComponent(X,Y,Z,State,varargin)

Properties.Scale = 1;
Properties.XLimits = [-inf inf];
Properties.YLimits= [-inf inf];
Properties.ZLimits = [-inf inf];
[Properties, varargin] = setProperties(Properties,varargin{:});

Shape = size(X);

RotationMatrix = computeRotationMatrix(State.Attitude);

Points = [X(:) Y(:) Z(:)] * RotationMatrix;

X = Properties.Scale * reshape(Points(:,1),Shape) + State.Position(1);
Y = Properties.Scale * reshape(Points(:,2),Shape) + State.Position(2);
Z = Properties.Scale * reshape(Points(:,3),Shape) + State.Position(3);

X = max(Properties.XLimits(1),min(Properties.XLimits(2),X));
Y = max(Properties.YLimits(1),min(Properties.YLimits(2),Y));
Z = max(Properties.ZLimits(1),min(Properties.ZLimits(2),Z));
surf(X,Y,Z,'LineStyle','none',varargin{:});

