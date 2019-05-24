%renderNGCM - render a torpedo on the current axes
%
% renderNGCM(State) renders a Next Generation Countermeasure given state.
% The origin of the NGCM is at the nose
%
% Copywrite 2011 BBN Technologies, Matt Daily author
function renderNGCM(State,varargin)

HoldState = ishold;
hold on;

% The NGCM is 3 inches diameter. The nose is 10 cm long
% and rounded (sort of). It is black
CurrentOffset = 0;
HullRadius = (3/12)*.3048;
NoseLength = 0.1;
[Z,Y,X] = cylinder([(sqrt(HullRadius^2 - (0:0.01:HullRadius).^2)) 0]);
X = X * NoseLength;
renderComponent(X,Y,Z,State,varargin{:},'FaceColor',[0 0 0]);
drawnow;

% The forward section, 30 cm long, grey
ForwardSectionLength = 0.3;
[Z,Y,X] = cylinder(HullRadius);
X = X * ForwardSectionLength - ForwardSectionLength;
renderComponent(X,Y,Z,State,varargin{:},'FaceColor',[0.5 0.5 0.5]);
CurrentOffset = CurrentOffset + ForwardSectionLength;
drawnow;

% The middle section, 15 cm long, red
MiddleSectionLength = 0.15;
[Z,Y,X] = cylinder(HullRadius);
X = X * MiddleSectionLength - MiddleSectionLength - CurrentOffset;
renderComponent(X,Y,Z,State,varargin{:},'FaceColor',[0.5 0 0]);
CurrentOffset = CurrentOffset + MiddleSectionLength;
drawnow;

% The aft section, 35 cm long, grey again
AftSectionLength = 0.35;
[Z,Y,X] = cylinder(HullRadius);
X = X * AftSectionLength - AftSectionLength - CurrentOffset;
renderComponent(X,Y,Z,State,varargin{:},'FaceColor',[0.5 0.5 0.5]);
CurrentOffset = CurrentOffset + AftSectionLength;
drawnow;

% Now the tail cone, 10 cm long, tapering to 1 cm, green
TailLength = 0.1;
Ramp = (1:10) * 0.1*HullRadius;
[Z,Y,X] = cylinder((1:10)*0.1*HullRadius);
X = X * TailLength - TailLength - CurrentOffset;
renderComponent(X,Y,Z,State,varargin{:},'FaceColor',[0 0.75 0]);
drawnow;

% And now the shroud, black, same width as the hull radius tapering
% to 30 CM.
CurrentOffset = CurrentOffset + TailLength
ShroudLength = 0.075;
[Z,Y,X] = cylinder(max(.5,(3:10)*0.1)*HullRadius);
X = X * ShroudLength - CurrentOffset;
renderComponent(X,Y,Z,State,varargin{:},'FaceColor',[0 0 0]);
drawnow;

%  Now, render the towed array, another 1 meter long.
ArrayLength = 1
[Z,Y,X] = cylinder(0.1*HullRadius);
X = X * ArrayLength - ArrayLength - CurrentOffset;
renderComponent(X,Y,Z,State,varargin{:},'FaceColor',[0 0 0]);


if (~HoldState)
  hold off;
end
