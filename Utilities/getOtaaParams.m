%getOtaaParams  return a structure of Otaa Parameters
%
% Params = getOtaaParams defines the OTAA parameters, including
% subarray and gain enumerations and various parameters for each of
% the subarrays and gains, including element locations. It also
% returns ship to otaa relative rotation matrices.
%
% A Note About Coordinates
%
% The element positions are defined in "array relative" coordinates,
% which is to say that the Y axis runs from the center of the LFSA to
% the center of the HFSA, and the X axis is perpendicular and to the
% right of that as looking from the water. This puts the Z axis normal
% to the array and out into the ocean.
%
% Note that none of the OTAAs have this as their orientation: each
% is oriented differently on the submarine, and these orientations
% are defined in terms of the standard submarine coordinate system:
% Origin at the conning tower, X axis to forward, Y axis to
% starboard, Z axis down. 
%
% $Source: /cygdrive/c/Users/MDailyE4500/Documents/Three\040Eyes/RCS/getOtaaParams.m,v $ $Revision: 1.0 $
%
% Copyright 2007 BBN Technologies, Matt Daily author
function Params = getOtaaParams(Configuration)

% These are the otaa configuration for the different ship types stored as a
% cell array for now
ConfigurationData.Down = {
    'SF-MIDLINE'  [   0.0694     0.2787   -0.9579]
    'SF-NORMAL'   [  -0.1050     0.9569    0.2708]
    'SF-POSITION' [-554.7900    65.1500  -85.5190]
    'PF-MIDLINE'  [   0.0694    -0.2787   -0.9579]
    'PF-NORMAL'   [  -0.1050    -0.9569    0.2708]
    'PF-POSITION' [-554.7900  -293.1500  -85.5190]
    'SA-MIDLINE'  [   0.7071    -0.7071    0.0000]
    'SA-NORMAL'   [   0.7071     0.7071    0.0000]
    'SA-POSITION' [3108.9300   170.2000 -141.6000]
    'PA-MIDLINE'  [   0.7071     0.7071    0.0000]
    'PA-NORMAL'   [   0.7071    -0.7071    0.0000]
    'PA-POSITION' [3112.1100  -409.8900 -141.6000]};
ConfigurationData.Up = {
    'SF-MIDLINE'  [  -0.0278    -0.3050    -0.9519]
    'SF-NORMAL '  [  -0.1459     0.9433    -0.2980]
    'SF-POSITION' [-726.05      46.1300  -186.6600]
    'PF-MIDLINE'  [  -0.0278    0.3050     -0.9519]
    'PF-NORMAL'   [  -0.1459   -0.9433     -0.2980]
    'PF-POSITION' [-726.0500 -274.1300   -186.6600]
    'SA-MIDLINE'  [   0.7071   -0.7071      0.0000]
    'SA-NORMAL'   [   0.7071    0.7071      0.0000]
    'SA-POSITION' [3108.9300  170.2000   -141.6000]
    'PA-MIDLINE'  [   0.7071    0.7071      0.0000]
    'PA-NORMAL'   [   0.7071   -0.7071      0.0000]
    'PA-POSITION' [3112.1100 -409.8900   -141.6000]};

if (nargin < 1)
  Configuration = 'Down';
end

% Check that the configuration is valid
if (~isfield(ConfigurationData,Configuration))
  error 'Bad Otaa Configuration';
end

% Otaa Sample Rate (this is not the real number but a place holder)
Params.SampleRate = 256 * 1024;

% Get the threholds for the high gain to low gain crossover and saturation.
Params.HighGainThreshold = 16 * 1024;
Params.SaturationThreshold = 30 * 1024 * 100;

% "enumerations".
Params.Enum.LowGain = 1;
Params.Enum.HighGain = 2;
Params.Enum.LFSA = 1;
Params.Enum.HFSA = 2;

LFSA = Params.Enum.LFSA;
HFSA = Params.Enum.HFSA;
LowGain = Params.Enum.LowGain;
HighGain = Params.Enum.HighGain;

Params.LFSA.ElementSize = 0.026;
Params.LFSA.Rings.Radius = [0.2614 0.21 0.18 0.15];
Params.LFSA.Rings.Offsets = [0 pi/18 pi/17 0];
Params.LFSA.Rings.NumElements = [20 18 15 11];

Params.HFSA.ElementSize = 0.01;
Params.HFSA.Rings.Radius = [0.17 0.13 0.041];
Params.HFSA.Rings.Offsets = [0 pi/25 pi/10];
Params.HFSA.Rings.NumElements = [25 18 10];

for Subarray = {'HFSA' 'LFSA'}
  Subarray = Subarray{1};
  
  Positions = [];
  Ring = Params.(Subarray).Rings;
  
  for Index = 1:length(Ring.NumElements)
    Angle = 2 * pi * (0:(Ring.NumElements(Index)-1))/Ring.NumElements(Index);
    Angle = Angle + Ring.Offsets(Index);
    Position = Ring.Radius(Index) * [cos(Angle); sin(Angle)];
    Positions = [Positions Position];
  end
  
  Params.(Subarray).Positions = Positions;
end

% Now define the receive channel maps This matrix cut-and-pasted from
% libotaa and properly re-formatted and re-named for matlab. Note
% that, since libotaa is a C file, the third column is 0 based, not
% one based: we make it one based after we load it through a simple
% addition.
ReceiveChannelMap = [
    LFSA   LowGain   0
    LFSA   LowGain  10
    LFSA   LowGain   2
    LFSA   LowGain   8
    LFSA   LowGain   4
    LFSA   LowGain  16
    LFSA  HighGain   1
    LFSA  HighGain   9
    LFSA  HighGain   7
    LFSA  HighGain  13
    HFSA  HighGain   5
    HFSA  HighGain   9
    HFSA   LowGain   2
    HFSA   LowGain   6
    HFSA   LowGain   8
    0  HighGain  -1
    LFSA   LowGain   6
    LFSA   LowGain  14
    LFSA   LowGain  12
    LFSA   LowGain  18
    LFSA  HighGain   3
    LFSA  HighGain  17
    LFSA  HighGain   5
    LFSA  HighGain  15
    LFSA  HighGain  11
    LFSA  HighGain  19
    HFSA   LowGain   0
    HFSA   LowGain   4
    HFSA  HighGain   1
    HFSA  HighGain   7
    HFSA  HighGain   3
    0  HighGain  -1
    LFSA   LowGain   1
    LFSA   LowGain   9
    LFSA   LowGain   7
    LFSA   LowGain  13
    LFSA  HighGain   0
    LFSA  HighGain  10
    LFSA  HighGain   2
    LFSA  HighGain   8
    LFSA  HighGain   4
    LFSA  HighGain  16
    HFSA   LowGain   5
    HFSA   LowGain   9
    HFSA  HighGain   2
    HFSA  HighGain   6
    HFSA  HighGain   8
    0  HighGain  -1
    LFSA   LowGain   3
    LFSA   LowGain  17
    LFSA   LowGain   5
    LFSA   LowGain  15
    LFSA   LowGain  11
    LFSA   LowGain  19
    LFSA  HighGain   6
    LFSA  HighGain  14
    LFSA  HighGain  12
    LFSA  HighGain  18
    HFSA  HighGain   0
    HFSA  HighGain   4
    HFSA   LowGain   1
    HFSA   LowGain   7
    HFSA   LowGain   3
    0  HighGain  -1];
ReceiveChannelMap(:,3) = ReceiveChannelMap(:,3) + 1;

% Store these in the parameters structure in properly named properties.
Params.Receive.NumChannels = size(ReceiveChannelMap,1);
Params.Receive.Gain = ReceiveChannelMap(:,2);
Params.Receive.Element = ReceiveChannelMap(:,3);
Params.Receive.Subarray = ReceiveChannelMap(:,1);
Params.Receive.Channel = (1:length(Params.Receive.Subarray))';

% Now, compute the positions of each of the channels using those
% channel parameters. This is easily done by indexing into the
% subarray element positions by the element positions above, but we
% have to offset for the HFSA receive ring being the last and not
% the first ring.
Indices = find(ReceiveChannelMap(:,1) == HFSA);
Offset = sum([Params.HFSA.Rings.NumElements(1:end-1)]);
ReceiveChannelMap(Indices,3) = ReceiveChannelMap(Indices,3) + Offset;

Params.Receive.Positions = zeros(2,Params.Receive.NumChannels);

Indices = find(ReceiveChannelMap(:,1) == LFSA);
Params.Receive.Positions(:,Indices) = ...
    Params.LFSA.Positions(:,ReceiveChannelMap(Indices,3));

Indices = find(ReceiveChannelMap(:,1) == HFSA);
Params.Receive.Positions(:,Indices) = ...
    Params.HFSA.Positions(:,ReceiveChannelMap(Indices,3));


% Lastly, define the OTAA orientations and positions from the
% configuration given
Configuration = ConfigurationData.(Configuration);
Params.OtaaNames = {'SF' 'PF' 'SA' 'PA'};
for Index = 1:size(Configuration,1)
  OtaaName = Configuration{Index,1}(1:2);
  Keyword = Configuration{Index,1}(4:end);
  Data = Configuration{Index,2};
  switch Keyword
    case 'MIDLINE'
      Params.(OtaaName).YAxis = (Data .* [-1 1 -1])';
    case 'NORMAL'
      Params.(OtaaName).ZAxis = (Data .* [-1 1 -1])';
    case 'POSITION'
      Params.(OtaaName).Offset = ...
          (.9144/36)*(Data .* [-1 1 -1])';
    otherwise
      error 'Bad Configuration Name'
  end
end
 
for OtaaName = Params.OtaaNames
  OtaaName = OtaaName{1};
  Params.(OtaaName).XAxis = cross(Params.(OtaaName).YAxis, ...
                                  Params.(OtaaName).ZAxis);
  Params.(OtaaName).RotationMatrix = [Params.(OtaaName).XAxis ...
                                      Params.(OtaaName).YAxis ...
                                      Params.(OtaaName).ZAxis];
end
