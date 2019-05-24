%renderArrow - create an arrow 
%
% renderArrow(State,Scale,{PropertyList}) creates an arrow modelled as a
% cylinder with a cone oriented along the X, Y, or Z axis.
%
% Copywrite 2008 BBN Technologies, Matt Daily author
function renderArrow(State,varargin)

HoldState = ishold;
hold on;

Arrow.Color = [0.4 0.4 0.4];
Arror.Scale = 1;
Arrow.Length = 1;
Arrow.Radius = 0.1;
Arrow.HeadRadius = 0.2;
Arrow.HeadHeight = 0.2;
Arrow.NumFacets = 50;

[Arrow, varargin] = setProperties(Arrow,varargin{:});
% Create the arrowhead patches as if they were going to be along
% the X axis. We can then make them y or z by swapping
% coordinates. This is made easy by the use of the cylinder
% function.
[Y, Z, X] = ...
    cylinder([Arrow.Length * Arrow.HeadRadius 0],Arrow.NumFacets);
X = X * Arrow.Length * Arrow.HeadHeight + Arrow.Length;
renderComponent(X,Y,Z,State,varargin{:});
    
% Now, create the shaft points
[Y, Z, X] = ...
    cylinder([Arrow.Radius*Arrow.Length Arrow.Radius*Arrow.Length],...
	     Arrow.NumFacets);
X = X * Arrow.Length;
renderComponent(X,Y,Z,State,Arrow.Color,Scale);

if (~HoldState)
  hold off;
end
