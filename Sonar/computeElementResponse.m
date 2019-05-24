%computeElementResponse  Returns the response of a circular element
%
% Response = computeElementResponse(Array, Direction, 'Property', Value, ...)  
%
% computes the response of a circular element along the given
% Directions. The Direction can be a 1, 2, or 3 row matrix,
% where each column is presumed to be a different direction. Matrices
% with 1 or 2 rows are presumed to have columns of look angles. Matrices
% of three rows are presumed to be directions columns. 
%
% This model is a standard circular piston model with baffling.
%
% In addition, the following properties are defined
%
% Minimum - minimum response possible (db, default -60)
% Absorption - loss through covering material at boresight (dB, default 0.1)
% Frequency - Frequency for computation (Hz)
% SoundSpeed - Sound speed (m/s)
%
% Copyright 2006 BBN Technologies, Matthew Daily Author
function Response = computeElementResponse(Beam,Directions, varargin)

% Set the properties
Properties.Frequency = Beam.Frequency;
Properties.SoundSpeed = Beam.SoundSpeed;
Properties = setProperties(Properties,varargin{:});

% This is the scaling from the input wavenumber to the one in the
% tables
Scale = (Properties.Frequency/Properties.SoundSpeed)/ ...
	 (Beam.Frequency/Beam.SoundSpeed);
if (Scale > 1)
  warning 'Wavenumber higher than table was computed for'
end

% Check that the input Directions is properly sized, including X, Y, and Z
% components
if (size(Directions,1) ~= 3)
  error('Bad Directions input');
end

% Rotate the directions for the orientation of the array
Directions = computeRotationMatrix(Beam.Array.Attitude) * Directions;

% We treat response behind the array as if it was the same as at endfire
Directions(1,:) = max(0,Directions(1,:));

% Compute the indices
Indices = round(Beam.TableSize * Directions(1,:) * Scale)+1;
Response = Beam.ElementResponse(Indices);
