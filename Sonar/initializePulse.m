%initializePulse  create a pulse
%
% Pulse = initializePulse({PropertyList}) creates a new pulse. The
% Properties that define a pulse are:
%
% Time - time of the pulse
% Beam - the beam that was used for the pulse
% Level - level of the pulse (dB re 1 uPa @ 1m)
% Length - Length of the pulse
% Frequency - Frequency of the pulse
% Steering - Steering of the pulse (a Direction)
%
% Copywrite 2010 BBN Technologies, Matt Daily author
function Pulse = initializePulse(varargin)

Pulse.Time = 0.0;
Pulse.Beam = [];
Pulse.Level = 200;
Pulse.Length = 0.100;
Pulse.Frequency = 0.0;
Pulse.Steering = [1 0 0]';

Pulse = setProperties(Pulse,varargin{:});

if (isempty(Pulse.Beam))
  Pulse.Beam = initializeBeam('Frequency',Pulse.Frequency);
end
