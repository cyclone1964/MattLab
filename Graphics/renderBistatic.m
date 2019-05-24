% This function renders a submarine, a torpedo, and a beam pointed
% at the torpedo that is direct path. 
Otaa = getOtaaParams;
useNamedFigure('DirectPath'); clf; hold on;

WaterColumn = initializeWaterColumn('Depth',[0 200],'SoundSpeed',[1500 1500]);
Environment = initializeEnvironment('WaterColumn',WaterColumn);
renderEnvironment(Environment,[-250 250; -300 300]);

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
Steerings = pi/180* ...
    [30 45 45 30
     -35 -70 -110 -145]';
Scales = [300 200 200 300];
for SteeringIndex = 1:size(Steerings,1)
  BeamPosition = SubPosition + Otaa.PF.Offset;
  BeamAttitude = [0 Steerings(SteeringIndex,:)]';
  BeamState = initializePlatformState('Position',BeamPosition, ...
				      'Attitude',BeamAttitude);
  renderBeamPattern(BeamState,...
		    'AngleLimit',pi/10, ...
		    'Scale',Scales(SteeringIndex),...
		    'FaceAlpha',0.5, ...
		    'FaceColor',[0.7 0.0 0.0], ...
		    'LineStyle','-', ...
		    'EdgeColor',[0.7 0.0 0.0]);
end

axis tight; axis equal;
view(100,5);
set(gca,'XTick',[],'YTick',[],'ZTick',[]);



