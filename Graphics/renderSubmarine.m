%renderSubmarine - render a submarine in three dimensions
%
% renderSubmarine(State, {PropertyList}) renders a submarine with the give
% state and at the given scale in 3 dimensions on the current
% axes. The origin of the submarine is directly under the sail. 
%
% By default, the submarine is 100 meters long and 1 meters
% wide. The components are the nose (Sonar Dome), the body, the
% tail, the shround, the four aft control surfaces, and the
% sail. The nose is taken to be 15 meters long, the tail another
% 20, and the body thus 65. The conning tower is situated so that
% it's foremost edge is 10 meters after of the nose, the and it is
% 7.5 meters long and 2 meters thick and 4 meters high. The shrooud
% is 2 meters thick and at the aft.
%
% In no way shape or form do these correspond to any submarine that
% exists, but rather these number were chosen because they were
% ball park correct and make a nice looking submarine
%
% Copywrite 2011 BBN Technologies, Matt Daily author
function renderSubmarine(State,varargin)

Properties.NoseColor = [0.6 0.6 0.6];
Properties.BodyColor = [0.8 0.8 0.8];
Properties.SailColor = Properties.NoseColor;
Properties.FinColor = Properties.NoseColor;
Properties.ShroudColor = [0 0 0];

% The nose is made to be a semi sphere and then stretched to the
% full length.
HoldState = ishold;
hold on;
HullRadius = 5;
NoseLength = 15;
NoseOffset = 10;

[Z, Y, X] = cylinder(sqrt(HullRadius^2 - (0:0.5:HullRadius).^2));
X = X * NoseLength + NoseOffset;
renderComponent(X,Y,Z,State,varargin{:},'FaceColor',Properties.NoseColor);

% Now the body
BodyLength = 65;
BodyOffset = -55;
[Z,Y,X] = cylinder(HullRadius);

X = X * BodyLength + BodyOffset;
renderComponent(X,Y,Z,State,varargin{:},'FaceColor',Properties.BodyColor);

% Now the tail cone
TailLength = 25;
TailOffset = -80;
[Z,Y,X] = cylinder(2:0.5:HullRadius);
X = X * TailLength + TailOffset;
renderComponent(X,Y,Z,State,varargin{:},'FaceColor',Properties.BodyColor);

% Now the sail. This is rendered as a "tube" for the front part and
% a wedge as the after part
SailThickness = 2;
SailHeight = 4;
SailLength = 7.5;
SailOffset = -10;
[X,Y,Z] = cylinder([SailThickness * ones(1,10) 0]);
Z = -Z * SailHeight - HullRadius;
X = SailLength * X/SailThickness - SailThickness/2 + SailOffset;
renderComponent(X,Y,Z,State,varargin{:},'FaceColor',Properties.SailColor);

% And now the four control surfaces
ControlSurfaceOffset = -72.5;
ControlSurfaceThickness = 1;
ControlSurfaceLength = 3;
ControlSurfaceHeight = 6;

% The top control surface
[X,Y,Z] = cylinder([ControlSurfaceThickness * ones(1,30) 0]);
Z = Z * ControlSurfaceHeight;
X = ControlSurfaceLength * X/ControlSurfaceThickness - ...
    ControlSurfaceThickness/2 + ControlSurfaceOffset;
renderComponent(X,Y,Z,State,varargin{:},'FaceColor',Properties.FinColor);

% And the bottom
Z = -Z;
renderComponent(X,Y,Z,State,varargin{:},'FaceColor',Properties.FinColor);

% And the left
Temp = Z; Z = Y; Y = Temp;
renderComponent(X,Y,Z,State,varargin{:},'FaceColor',Properties.FinColor);

% And the right
Y = -Y;
renderComponent(X,Y,Z,State,varargin{:},'FaceColor',Properties.FinColor);

% And now the shroud
ShroudLength = 3;
ShroudOffset = -80;
[Y,Z,X] = cylinder([0 3:0.05:4]);
X = X * ShroudLength + ShroudOffset;
renderComponent(X,Y,Z, State,varargin{:},'FaceColor',Properties.ShroudColor);

drawnow;
if (~HoldState)
  hold off;
end


