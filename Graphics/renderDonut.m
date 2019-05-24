% This function renders a submarine, a torpedo, and a beam pointed
% at the torpedo that is direct path. 
Otaa = getOtaaParams;
useNamedFigure('DirectPath'); clf; hold on;

WaterColumn = initializeWaterColumn('Depth',[0 200],'SoundSpeed',[1500 1500]);
Environment = initializeEnvironment('WaterColumn',WaterColumn);
renderEnvironment(Environment,[-200 200; -300 300]);

SubPosition = [0 0 125]';
SubmarineState = initializePlatformState('Position',SubPosition);
renderSubmarine(SubmarineState,'Scale',2);

% Place the torpedo
TorpPosition = [0 200 125]';
TorpAttitude = [0 0 -pi/2]';
TorpState = initializePlatformState('Position',TorpPosition, ...
				    'Attitude',TorpAttitude);
renderTorpedo(TorpState,'Scale',6,'BodyColor',[0.8 0.8 0]);

% Transmit from the forward array
ArrayPosition = Otaa.SF.Offset;
BeamPosition = SubPosition + ArrayPosition;
BeamAttitude = [0 0 pi/2];
BeamState = initializePlatformState('Position',BeamPosition, ...

'Attitude',BeamAttitude);
renderBeamPattern(BeamState,...
		  'AngleLimit',pi/6, ...
		  'Scale',200,...
		  'DonutFactor',2, ...
		  'FaceAlpha',0.5, ...
		  'FaceColor',[0.7 0.0 0.0], ...
		  'LineStyle','-', ...
		  'EdgeColor',[0.7 0.0 0.0]);
axis tight; axis equal;
view(100,5);
set(gca,'XTick',[],'YTick',[],'ZTick',[]);