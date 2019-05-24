%renderTorpedo - render a torpedo on the current axes
%
% renderTorpedo(State) renders a torpedo with the given state. The
% orientation is taken from the velocity. The origin of the torpedo
% is 1 meter aft of the nose cone.
%
% Copywrite 2011 BBN Technologies, Matt Daily author
function renderTorpedo(State,varargin)

Properties.NoseColor = [0 0 0];
Properties.BodyColor = [0 0.25 0];
Properties.NoseColor = [0 0 0];
Properties.FinColor = [0.4 0.4 0.4];
Properties.ShroudColor = [0 0 0];

[Properties,varargin] = setProperties(Properties,varargin{:});
HoldState = ishold;
hold on;

% The torpedo is 1/2 meter in diameter (19 inches, close
% enough). The nose is 20 cm long, 1 meter forward of the origin,
% and rounded (sort of). It is black
HullRadius = 0.5;
NoseLength = 0.2;
NoseOffset = 1;
[Z,Y,X] = cylinder([(sqrt(HullRadius^2 - (0:0.01:0.4).^2)) 0]);
X = X * NoseLength + NoseOffset;
renderComponent(X,Y,Z,State,'FaceColor',Properties.NoseColor,varargin{:});


% The body, 7 meters long, tapering to 20 CM from 50, green
BodyLength = 7;
BodyOffset = -6;
[Z,Y,X] = cylinder(HullRadius);
X = X * BodyLength + BodyOffset;
renderComponent(X,Y,Z,State,'FaceColor',Properties.BodyColor,varargin{:});

% Now the tail cone, 1 meter long, tapering to 10 CM from 50, also
% green
TailLength = 1;
TailOffset = -7;
[Z,Y,X] = cylinder(0.2:0.1:HullRadius);

X = X * TailLength + TailOffset;
renderComponent(X,Y,Z,State,'FaceColor',Properties.BodyColor,varargin{:});

% Now the four control surfaces.
ControlSurfaceOffset = -7;
ControlSurfaceThickness = 0.02;
ControlSurfaceLength = 0.2;
ControlSurfaceHeight = HullRadius;

[X,Y,Z] = cylinder([ControlSurfaceThickness * ones(1,30) 0]);
Z = Z * ControlSurfaceHeight;
X = ControlSurfaceLength * X/ControlSurfaceThickness + ...
    ControlSurfaceLength + ...
    ControlSurfaceOffset;
renderComponent(X,Y,Z,State,'FaceColor',Properties.FinColor,varargin{:});

% And the bottom
Z = -Z;
renderComponent(X,Y,Z,State,'FaceColor',Properties.FinColor,varargin{:});

% And the left
Temp = Z; Z = Y; Y = Temp;
renderComponent(X,Y,Z,State,'FaceColor',Properties.FinColor,varargin{:});

% And the right
Y = -Y;
renderComponent(X,Y,Z,State,'FaceColor',Properties.FinColor,varargin{:});

% And now the shroud, black, same width as the hull radius tapering
% to 30 CM.
ShroudLength = 0.6;
ShroudOffset = -7;
[Y,Z,X] = cylinder([0.3:0.1:HullRadius]);
X = X * ShroudLength + ShroudOffset;
renderComponent(X,Y,Z,State,'FaceColor',Properties.ShroudColor,varargin{:});
drawnow;

if (~HoldState)
  hold off;
end
