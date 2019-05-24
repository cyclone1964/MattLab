%initializeReceiver  sets up a receiver for signal generation
%
% Receiver = initializeReceiver({PropertyList}) initializes parameters
% necessary to define the nature of a receiver. Supported
% properties are
%
% Gain - Gain of receiver (dB)
% Array - Array connected to receiver
% Bandwidth - Bandwidth of receiver (also baseband sample rate)
% NoiseFloor - Noise floor (dB re 1uV per root Hz at 1 m)
% CenterFrequency - Center frequency in Hz
%
% Copywrite 2010 BBN Technologies, Matt Daily author

function Receiver = initializeReceiver(varargin)

Receiver.Gain = 0;
Receiver.Array = initializeArray(varargin{:});
Receiver.Bandwidth = 3000;
Receiver.NoiseFloor = 100;
Receiver.CenterFrequency = 30000;

Receiver = setProperties(Receiver,varargin{:});
