%initializeArray  initializes an array of acoustic elements
%
% Array = initializeArray({PropertyList}) sets up an acoustic
% array in terms of element properties. These arrays can be of
% three types: rectangular, circular, or arbitrary. Rectangular is
% the default.
%
% The properties currently supported are:
%
% Type - Type of array: Rectangular, Circular, or Arbitrary. The
% supporting functions are much faster with rectangular arrays.
%
% For rectangular arrays, the geometry is defined with these
% properties.
% 
% NumRows - number of rows in a rectangular array
% NumColumns - number of columns in rectangular array
% Separation - element separation in meters for a rectangular array
% Sensitivity - sensitivity of elements (dB re 1 V/uPa @ 1 m)
%
% For circular arrays, the geometry is defined by rings of elements
% equispaced in angles. The properties that define this are
% vectors, all of the same length:
%
% RingRadius - a vector defining the radius of each ring in meters
% RingOffset - vector defining the angular offset of the first
%              element in each ring in radians
% ElementsPerRing - a vector defining the number of elements in
% each ring
%
% For arbitrary locations, the element geometry is defined as
%
% ElementLocations - the X/Y locations of each element
% Attitude - attitude of array on body
%
%
% Two other properties that define the array are:
%
% Attitude - how the array is oriented on the platform
% ElementSize - the size of the elements in the array. This
%               is set according to the separation if not defined
%
% Copywrite 2010 BBN Technologies, Matt Daily author
function Array = initializeArray(varargin)

% This interface supports several types of arrays. One is a rectangular
% array, a tight-packed planar array of identicle elements.
Array.Type = 'Rectangular';

% The default rectangular array ias 8 rows and 8 columns and
% spacing and size of 1/2 an wavelength.

% All elements are presumed equi-spaced in a tight-packed grid
% These only have meaning for arrays of type "Rectangular"
Array.NumRows = 8;
Array.NumColumns = 8;
Array.Separation = 0.5;

% On the other hand a Circular array is defined by individual rings
% of angularly equispaced elements. Each ring has an element count,
% radius, and angular offset of the first element.
Array.ElementsPerRing = [20 18 15 11];
Array.RingRadius = [0.2614 0.21 0.18 0.15];
Array.RingOffset = [0 pi/18 pi/17 0];

% By default, the array elements are planar, with locations
% specified in X and Y. Thus the array is oriented with it's MRA
% long the Z axis. This property lets one tip the array one way or
% the other with respect to the body on which it is standing
Array.Attitude = [0 0 0];

% The element size, initialized to empty then filled in later to
% defaults if not set by the user.
Array.ElementSize = [];

% These two parameters define the nature of the single element
% response pattern, and are used to model far-off-axis rolloff. The
% first is an "absorption" through the "boot" which also models
% impendance mismatch off axis. The second is a limit on the amount
% of baffling: I wouldn't mess with that one and certainly don't
% set it to 0!
Array.BootAbsorption = 20;
Array.AbsorptionLimit = 0.001;

% And sensitivity, in dB re 1 V/uPa
Array.Sensitivity = 0.0;

% This is set to empty. For type arbitrary, it has to be populated
% by the user. For the other types, it is populated below.
Array.ElementLocations = [];

Array = setProperties(Array,varargin{:});

% Now, set up the bookkeeping necessary to support beam pattern computation.
switch Array.Type
  case {'Rectangular'}
    
    % For rectangular arrays, we presume the elements are
    % close-packed, so the size is the separation.
    if (isempty(Array.ElementSize))
      Array.ElementSize = Array.Separation;
    end

    % Set up the locations of the elements based upon the
    % separation based upon the size
    XLocations = repmat((1:Array.NumColumns),Array.NumRows,1)';
    XLocations = Array.Separation * (XLocations - mean(XLocations(:)));
    YLocations = repmat((1:Array.NumRows)',1,Array.NumColumns)';
    YLocations = Array.Separation * (YLocations - mean(YLocations(:)));
    Array.ElementLocations = [XLocations(:)'; YLocations(:)'];
  case {'Circular'}
    
    % Check that the inputs are consistent
    if (isempty(Array.ElementsPerRing) || ...
	length(Array.ElementsPerRing) ~= length(Array.RingRadius) || ...
	length(Array.ElementsPerRing) ~= length(Array.RingOffset))
      error 'Invalid Ring Specification'
    end

    % For circular rings, we assume element size 1/2 the smallest
    % separation of the rings
    if (isempty(Array.ElementSize))
      Separation = 2*pi*Array.RingRadius ./ Array.ElementsPerRing;
      Array.ElementSize = min(Separation)/2;
    end

    % Now set up the element locations
    Array.ElementLocations = [];
    for RingIndex = 1:length(Array.ElementsPerRing)

      % Compute the locations of the elements
      NumElements = Array.ElementsPerRing(RingIndex);
      Angle = 2 * pi * ((1:NumElements) - 1)/NumElements + ...
	      Array.RingOffset(RingIndex);
      XLocations = Array.RingRadius(RingIndex) * cos(Angle);
      YLocations = Array.RingRadius(RingIndex) * sin(Angle);

      % Add these to the list
      Array.ElementLocations = ...
	  [Array.ElementLocations [XLocations(:)'; YLocations(:)']];
    end
    
  case {'Irregular'}
    if (isempty(Array.ElementLocations))
      error 'Must Specify Locations For Irregular Array'
    end
  otherwise
    error 'Invalid Array Type'
end

    
