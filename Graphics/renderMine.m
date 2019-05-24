%renderMine - render a mine
%
% renderMine(State) renders a mine with the given state. It is a
% simple sphere with cones sticking out of it in a regular pattern,
% thus conforming to the Gilligan's Island Mine Appearance
% Specification
%
% Copywrite 2011 BBN Technologies, Matt Daily author
function renderMine(State,varargin{:})

HoldState = ishold;
hold on;

% First, create the sphere that is the mine. The mine is 1 meter in
% diameter
[X,Y,Z] = sphere(50);
renderComponent(X,Y,Z,State,[0.9 0.9 0]);

% Now, we place little protuberances on the sphere. These are cones
% 0.1 meters high and 0.05 cm at the base
[Z, Y, X] = cylinder([0.15 0]);
X = X * 1;
Y = Y * 1;
Z = Z * 1;

% Now, lift that in Z by the radius of the sphere (a little less
% actually)
X = X + 0.95;

% These are the rotations around which the protuberances are
% created. In essence, these are angles of the cones out of the
% sphere
Angles = [0 0 0
	 0 0 45
	 0 0 90
	 0 0 135
	 0 0 180
	 0 0 225
	 0 0 270
	 0 0 315
	 0 45 0
	 0 45 60
	 0 45 120
	 0 45 180
	 0 45 240
	 0 45 300
	 0 -45 0
	 0 -45 60
	 0 -45 120
	 0 -45 180
	 0 -45 240
	 0 -45 300
	 0 90 0
	 0 -90 0]';
for Index = 1:size(Angles,2)
  State.Attitude = Angles(:,Index)*pi/180;
  renderComponent(X,Y,Z,State,'FaceColor',[0.9 0 0]);
end
drawnow;	 
	 
if (~HoldState)
  hold off;
end
