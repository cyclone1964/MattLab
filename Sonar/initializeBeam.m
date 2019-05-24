%createBeam  computes the K-space beam table for a given array and shading
%
% Beam = createBeam computes a response table for a given
% array. This table is stored in wavenumber space, and thus can be
% easily steered assuming that the steering is done with simple
% phase-delay beamforming. The table size is fixed when the beam is
% created, but can be defined as a property. The Sound speed and
% frequency are set to 1, so that if the element locations are
% given as fractions of a wavelength, the answer is consistent.
%
% The k-space beam table support works in two distinctly different
% modes based upon wether the array being modelled is a "regular"
% array or not. 
%
% Regular Arrays
%
% A regular array is defined as an array with
% elements placed on a rectangular grid. Note that other array
% geometries (for instance hexagonal arrays) can be modelled as
% rectangular with proper handling of the shading
% vectors. Rectangular arrays have the advantage that their
% array-responses are repetitive in wavenumber space and so we can
% handle arrays of any aperture and steered in any way at any
% frequency using the same table by using modulo arithmetic.
%
% Non-regular arrays
%
% Arrays with elements not arranged on a grid cannot be handled in
% this way and so the beam tables have to be built assuming a maximum
% acoustic wavenumber. As long as later computations do not specify an
% aperture wavenumber in excess of this initialization then all is
% well.
%
% Element Response Functions
%
% All elements are modelled as being circular elements with a
% simple baffling model. 
%
% Copyright 2006 BBN Technologies, Matthew Daily Author
function Beam = initializeBeam(varargin)

% Save the array Beam
Beam.Array = initializeArray;

% By default, the table is 128 x 128 entries deep for regular arrays
% and 257x257 for irregular arrays. Again, we specify this as a
% scalar, but again support it being a 2 vector, with the vertical and
% horizontal being the two entries in that order.
Beam.TableSize = 128;

% We now set a series of simple physical parameters from which we
% can compute the response. We expect these to change from time to
% time, and since we don't presume any units in our world, let us
% presume the frequency is 1 and the sound speed 1. This gives us
% reasonable wavelength of 1, and this, if the element locations are
% in terms of wavelengths, provides a direct mapping for table lookup.
Beam.Frequency = 1;
Beam.SoundSpeed = 1;

% Set a default shading table for the array elements
Beam.Shading = [];

% This defines the minimum output level of the beam in dB. Think of
% it as a leakage
Beam.Minimum = -60;

% Set the properties
Beam = setProperties(Beam,varargin{:});

% If shading was not set, it's uniform shading.
if (isempty(Beam.Shading))
  Beam.Shading = ones(size(Beam.Array.ElementLocations,2),1);
end

% Check the size of the input Shading to make sure it's consistent with the
% array
if (length(Beam.Shading) ~= size(Beam.Array.ElementLocations,2))
  error 'Shading is not right size for array'
end

% Compute the normalization
Norm = sum(abs(Beam.Shading(:)));

switch Beam.Array.Type
  case 'Rectangular'
    % For rectangular arrays, we can use an FFT to compute the
    % response. This ASSUMES a lambda/2 separation, which we have
    % to take into account when we dereference the array. Note that
    % the size of the table here is entirely determined by the
    % fidelity you want in the output and not in any way by the
    % relative aperture of the array.
    NumRows = Beam.Array.NumRows;
    NumColumns = Beam.Array.NumColumns;
    Beam.ArrayResponse = zeros(Beam.TableSize);
    Beam.ArrayResponse(1:NumRows,1:NumColumns) = ...
	reshape(Beam.Shading,NumRows,NumColumns);
    Beam.ArrayResponse = fft2(Beam.ArrayResponse)/Norm;
  otherwise
    
    % Otherwise, we have to do the summation directly, and the
    % resultant table has to include all possible combinations of
    % wavenumber and steering since we can't do the modulo trick. 
    %
    % We attempt to optimize the computations through the use of
    % outer-products. 
    %
    % Note that the values of phase correspond to twice the normal
    % range, and that the table is twice as large as for rectangular
    % arrays and has a center point as well. This is so that we can
    % steer the beams later without running off the edge of the map.
    XPhase = ...
	(Beam.Frequency/Beam.SoundSpeed) * ...
	(4*pi *((-Beam.TableSize:Beam.TableSize)/Beam.TableSize))' * ...
	Beam.Array.ElementLocations(1,:);
    
    YPhase = ...
	(Beam.Frequency/Beam.SoundSpeed) * ...
	(4*pi * ((-Beam.TableSize:Beam.TableSize)/Beam.TableSize))' * ...
	Beam.Array.ElementLocations(2,:);

    % And now add the shading in there
    XPhase = exp(j*XPhase) .* repmat(Beam.Shading(:)',2*Beam.TableSize+1,1);
    YPhase = exp(j*YPhase');
    Beam.ArrayResponse = XPhase * YPhase/Norm;
end

% Now compute the element response table. Unlike the array response
% above, this does not repeat hence again we need to treat the
% inputs as defining a maximum wavenumber. The element response is
% a function of the projection onto the normal only, and these need
% to be inverted because it's a function of the sin, not the
% cosine.
%
% In order to keep the functino from blowing up at 0, we set the 0
% value to 1e-12, which generates a 1 as it should.
Directions = (0:Beam.TableSize)/Beam.TableSize;
Directions(1) = 1e-12; 
Directions = Directions(end:-1:1);
Argument = Directions * ...
    (2 * pi * Beam.Frequency/Beam.SoundSpeed) * Beam.Array.ElementSize;
Beam.ElementResponse = abs(2 * besselj(1,Argument) ./ Argument);

