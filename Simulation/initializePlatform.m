%initializePlatform - create a platform'
%
% Platform = initializePlatform({PropertyList}) creates a new
% platform for later computation. The properties that define a
% platform are:
%
% State - the state of the platform
% Pulses - the pulses a platform makes
% Receiver - the receiver on the platform (if any)
% Highlights - the hilights on the platform
%
% Copywrite 2010 BBN Technologies, Matt Daily author
function Platform = initializePlatform(varargin)

Platform.State = initializePlatformState;
Platform.Pulses = [];
Platform.Receiver = [];
Platform.Highlights = initializeHighlights;

Platform = setProperties(Platform,varargin{:});
