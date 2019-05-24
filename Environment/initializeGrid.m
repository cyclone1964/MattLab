%initializeGrid - initializes a grid
%
% Grid = initializeGrid(X,Y,Z,{PropertyList}) initializes a grid
% for a boundary. Specifically, it sets vectors for the X entries,
% the Y entries, and the depths at every crossing of that grid. In
% addition, one can define any number of associated grid point
% values as additional properties pairs
function Grid = initializeGrid(X,Y,Z,varargin)

Grid.X = X(:);
Grid.Y = Y(:);
Grid.Z = Z;

% Check that the dimensions of the first three arguments are
% consistent.
if (isscalar(Grid.Z))
  Grid.Z = Grid.Z * ones(length(Grid.X),length(Grid.Y));
else
  if (size(Z,1) ~= length(X) || ...
      size(Z,2) ~= length(Y))
    error ('Inconsisent Depth Grid Dimensions');
  end
end

% Now, we allow the user to specify property/value pairs. These
% properites of the grid are assumed defined at all values of X and
% Y. IF provided as scalars, we replicate them into a grid
% consistent with the length of the X and Y vectors
while (length(varargin) > 1)
  
  % Get the name/value
  PropertyName = varargin{1};
  PropertyValue = varargin{2};

  % Check that the name is a character
  if (~ischar(PropertyName))
    error('Bad Property Name');
  end
  
  if (isscalar(PropertyValue))
    PropertyValue = PropertyValue * ones(length(Grid.X),length(Grid.Y));
  else
    if (size(PropertyValue,1) ~= length(X) || ...
	size(PropertyValue,2) ~= length(Y))
      error ('Inconsistent Property Dimensions');
    end
  end
  Grid.(PropertyName) = PropertyValue;
  
  if (length(varargin > 2))
    varargin = varargin(3:end);
  else
    break;
  end
end

if (length(varargin) > 0)
  error('Unmatched Grid Property');
end
