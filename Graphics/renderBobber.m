%renderBobber - draw a bobber
%
% renderBobber(State, Scale) renders a bobber given the input state,
% which defines the position and orientation of the bobber. the Bobber
% consists of a ring transducer, the body, and an antenna. It can
% be scaled to be more visible
%
% Copywrite 2014 BBN Technologies, YourNameHere Author
function renderBobber(State,varargin)

Options.AddLineArray = false;
Options.AddCircularArray = false;

[Options, varargin] = setProperties(Options,varargin{:});

% First, rende the transmit transducer. If it's a line array,
% render that, if not, render a simple ring transducer
HoldState = ishold;
hold on;
if (Options.AddLineArray)
  
  ArrayRadius = 0.01;
  ArrayHeight = 0.1;
  
  % This is rendered as a 5 element array. The elements are grey,
  % the array is black. So render the black array first
  [X,Y,Z] = cylinder(ArrayRadius,50);
  Z = Z * ArrayHeight - ArrayHeight;
  renderComponent(X,Y,Z,State, varargin{:},'FaceColor',[0 0 0]);
  
  % Now, lets draw an endcap on the ring transducer to make it nice
  % by creating a cylinder with a radius that decreases along a
  % circular arc.
  Delta = ArrayRadius/50;
  Height = ArrayRadius:-Delta:0;
  Radii = sqrt(ArrayRadius^2 - Height.^2);
  [X,Y,Z] = cylinder(Radii,50);
  Z = Z * ArrayRadius - ArrayHeight-ArrayRadius;
  renderComponent(X,Y,Z,State,varargin{:},'FaceColor',[0  0 0]);

  % Now, let's go through and render grey elements over those
  ElementHeight = 0.01;
  ElementSpacing = 0.0025;
  for ElementIndex = 1:7
    Height = ElementIndex * (ElementHeight+ElementSpacing);
    [X,Y,Z] = cylinder(1.01*ArrayRadius,50);
    Z = Z * ElementHeight - Height;
    renderComponent(X,Y,Z,State, varargin{:}, 'FaceColor',[0.6 0.6 0.6]);
  end
    
else

  % Render the ring transducer. We render this twice as
  % high as necessary because we want it to penetrate into the bobber
  RingRadius = 0.01;
  RingHeight = 0.01;
  [X, Y, Z] = cylinder(RingRadius,50);
  Z = 2*Z * RingHeight - RingHeight;
  renderComponent(X,Y,Z,State,varargin{:},'FaceColor',[0 0 0]);
  
  % Now, lets draw an endcap on the ring transducer to make it nice
  % by creating a cylinder with a radius that decreases along a
  % circular arc.
  Delta = RingRadius/50;
  Height = RingRadius:-Delta:0;
  Radii = sqrt(RingRadius^2 - Height.^2);
  [X,Y,Z] = cylinder(Radii,50);
  Z = Z * RingRadius - 2 * RingHeight;
  renderComponent(X,Y,Z,State,varargin{:},'FaceColor', [0 0 0]);
end

% Now the bottom endcap of the bobber proper, again with  cylinder
% whose radius decreases as a circular arc.
BobberRadius = .05;
BobberHeight = .20;
EndCapHeight = BobberRadius;
if (Options.AddCircularArray)
  TubeHeight = .75 * (BobberHeight - 2 * EndCapHeight);
  CircularArrayHeight = 0.25 * (BobberHeight - 2 * EndCapHeight);
else
  TubeHeight = BobberHeight - 2 * EndCapHeight;
  CircularArrayHeight = 0;
end
  
Delta = EndCapHeight/50;
Height = EndCapHeight:-Delta:0;
Radii = sqrt(BobberRadius^2 - Height.^2);
[X,Y,Z] = cylinder(Radii,50);
Z = Z * EndCapHeight;
renderComponent(X,Y,Z,State,varargin{:},'FaceColor',[0 0.5 0]);

% And a little blue band around the bottom endcap
BandWidth = 0.005;
[X,Y,Z] = cylinder(BobberRadius+0.001,50);
Z = BandWidth * Z + EndCapHeight;
renderComponent(X,Y,Z,State,varargin{:},'FaceColor',[0 0 1]);

% Now the tube part
[X,Y,Z] = cylinder(BobberRadius,50);
Z = Z * TubeHeight + EndCapHeight;
renderComponent(X,Y,Z,State,varargin{:},'FaceColor',[0 0.5 0]);

% If we have a ring array, render that 
if (Options.AddCircularArray)
  [X,Y,Z] = cylinder(1.01*BobberRadius,24);
  Z = Z * CircularArrayHeight + EndCapHeight + TubeHeight;
  renderComponent(X,Y,Z,State,varargin{:}, ...
    'FaceColor',[0.6 0.6 0.6], ...
    'LineWidth',2,'EdgeColor','k','LineStyle','-');
end

% Now the top endcap
Radii = Radii(end:-1:1);
[X,Y,Z] = cylinder(Radii,50);
Z = Z * EndCapHeight + EndCapHeight + TubeHeight + CircularArrayHeight;
renderComponent(X,Y,Z,State,varargin{:},'FaceColor',[0 0.5 0]);

% And a little blue band around the top endcap
if (~Options.AddCircularArray)
  [X,Y,Z] = cylinder(BobberRadius+0.001,50);
  Z = BandWidth * Z + EndCapHeight + TubeHeight - BandWidth;
  renderComponent(X,Y,Z,State,varargin{:},'FaceColor',[0 0 1]);
end

% And now, the bottom of the attenna, rendered as another
% spherical thing in black.
AntennaOffset = BobberHeight - 0.01;
AntennaBaseRadius = 0.02;
AntennaBaseHeight = 0.02;
Delta = AntennaBaseHeight/50;
Height = 0:Delta:AntennaBaseHeight;
Radii = sqrt(AntennaBaseRadius^2 - Height.^2);
[X,Y,Z] = cylinder(Radii,50);
Z = Z * AntennaBaseHeight + AntennaOffset;
renderComponent(X,Y,Z,State,varargin{:},'FaceColor',[0 0 0]);

% And the shaft of the antenna
AntennaShaftHeight = .07;
AntennaShaftRadius = 0.005;
[X,Y,Z] = cylinder(AntennaShaftRadius,50);
Z = Z * AntennaShaftHeight + AntennaOffset;
renderComponent(X,Y,Z,State,varargin{:},'FaceColor',[0 0 0]);

% And lastly, the little round ball at the end of the antenna,
% a cylinder with a radius that increases/decreases along a
% circular arc.
AntennaBallRadius = 0.01;
Delta = AntennaBallRadius/25;
Height = AntennaBallRadius:-Delta:0;
Radii = sqrt(AntennaBallRadius^2 - Height.^2);
Radii = [Radii Radii(end:-1:1)];
[X,Y,Z] = cylinder(Radii,50);
Z = Z * 2*AntennaBallRadius + ...
    AntennaOffset + AntennaShaftHeight - AntennaBallRadius;
renderComponent(X,Y,Z,State,varargin{:},'FaceColor',[0 0 0]);

if (~HoldState)
  hold off;
end
