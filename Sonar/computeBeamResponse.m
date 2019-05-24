%computeBeamResponse  Returns the composite response of an array
%
% Response = computeBeamResponse( Beam, Directions, 'Property', Value, ...)  
%
% Computes the response of an array, including the array gain and
% the element response. The element response assumes the elements
% are tightly packed so that the element aperture is equal to the
% element separation. 
%
% Beam - the beam to be steered
% Directions - a 3xN set of pointing direction cosine triplets
%
% Properties
%
% DE - right handed rotation about the X axis
% Bearing - right handed rotation about the Y axis
% Steering - a 2 entry column vector [Bearing DE]
% LookDirection - a 3x1 steering vector (direction cosine triplet)
% 
% It should be noticed that, if used, the input Bearing, DE and steering
% angles do NOT conform to the normal coordinate system definitions of
% Yaw and Pitch. This is a result of the assumption that the array
% lies in the X/Y plane so that it's normal is the Z axis, where as
% the main axis of the standard coordinate system is the X axis.
%
% This is in direct contrast to the input steering vector, which
% DOES conform to the standard coordinate system. Thus, the user
% can specify steering in array relative angles OR directly in
% standard coordinate system steering vectors.
%
% IMPORTANT NOTES ABOUT BEAM TABLES
%
% The beam tables are computed differently for rectangular .vs. 
% circular or irregular beams. Rectangular arrays are computed
% assuming 1/2 wavelength separation, and because they are
% regularly sampled, that is all we need have. For others, we have
% to know the frequency, and so we just presume that the wavenumber
% of the table matches the wavenumber requested.

% Copyright 2006 BBN Technologies, Matthew Daily Author
function Response = computeBeamResponse( Beam, Directions, varargin)

% Properties that are settable from the command line using
% Property/Value pairs.
Properties.DE = [];
Properties.Bearing = [];
Properties.Steering = [];
Properties.LookDirection = [];

Properties.Frequency = Beam.Frequency;
Properties.SoundSpeed = Beam.SoundSpeed;

Properties = setProperties(Properties, varargin{:});

% This is the scaling from the input wavenumber to the one in the
% tables
Scale = (Properties.Frequency/Properties.SoundSpeed)/ ...
	 (Beam.Frequency/Beam.SoundSpeed);
if (Scale > 1)
  warning 'Wavenumber higher than table was computed for'
end

% If the steering is empty, then we check the HSA and VSA to see if
% we can set the steering from those
if (isempty(Properties.Steering))
  
  % Set defaults for the steerings
  if (isempty(Properties.Bearing))
    Properties.Bearing = 0;
  end

  if (isempty(Properties.DE))
    Properties.DE = 0;
  end
  
  % And the look direction
  Properties.Steering = [Properties.Bearing; Properties.DE];

end

% If only a single steering was set, set the other to 0
if (length(Properties.Steering) ~= 3)
  Properties.Steering(3) = 0;
end

% Now, compute the steering vector from the look direction. The
% deal here is that the look angles are in a different coordinate
% system than the "normal" one: they are specified with respect to
% the normal of the array, which is in the X/Y plane and thus the
% normal is the Z axis. Thus, we need to post-rotate the
% converted steering direction when they are specified by the look
% angles.
if (isempty(Properties.LookDirection))
  Properties.LookDirection = computeDirection(Properties.Steering(end:-1:1));
end

% If the input direction vector contains a single row, presume it
% to be bearing only. Default the DE to 0
if (size(Directions,1) == 1)
  Directions = [Directions; zeros(size(Directions))];
end

% If there are only two rows to the Directions vector, we presume it is a
% matrix of "Look" vectors.
if (size(Directions,1) == 2)
  Directions = [cos(Directions(2,:)) .* cos(Directions(1,:))
	       cos(Directions(2,:)) .* sin(Directions(1,:))
	       sin(Directions(2,:))];
end

% Check that the input Directions is properly sized, including X, Y, and Z
% components
if (size(Directions,1) ~= 3)
  error('Bad Directions input');
end

% Initialize response with the element response function
Response = computeElementResponse(Beam,Directions,Properties);

% Rotate said directions to account for attitude of the array on
% the body
Directions = computeRotationMatrix(Beam.Array.Attitude) * Directions;

% Now add the steering vector. At this point we presume that the
% steering vector was properly computed for the given frequency and
% sound speed defined. If there was an error, we would have to
% model that separately. 
Directions = Directions - ...
    repmat(Properties.LookDirection,1,size(Directions,2));

% Now compute the indices. We do this starting with 0 based indexing
% in each dimension before convert to 1-based indexing. However, it
% has to be done differently for rectangular and non-rectangular
% arrays.
TableSize = Beam.TableSize;
if (strcmp(Beam.Array.Type,'Rectangular'))

  % For rectangular array, the k-space beam pattern repeats in both
  % directions. Thusly, we can convert these to indices via modulo
  % math. We use modulo and not rem to get the proper effect for
  % negative values.
  Scale = Scale * TableSize;
  RowIndex = mod(round(Scale * Directions(3,:)), TableSize);
  ColumnIndex = mod(round(Scale * Directions(2,:)), TableSize);
  Index = (RowIndex * TableSize) + ColumnIndex + 1;
else
  % For non-rectangular arrays, we use the directions directly, and
  % the scaling is different as the pattern does not repeat. Also
  % recall that the meaning of table size is different.
  RowIndex = ...
      max(-TableSize, ...
	  min(TableSize,round(0.5*TableSize * Scale * Directions(3,:)))) + ...
      TableSize;
  ColumnIndex = ...
      max(-TableSize, ...
	  min(TableSize,round(0.5*TableSize * Scale * Directions(2,:)))) + ...
      TableSize;
  Index = (RowIndex * (2*Beam.TableSize+1)) + ColumnIndex + 1;
end

% Finally use it to dereference the table and add the beam response
% to the element response
Response = Response .* Beam.ArrayResponse(Index);
