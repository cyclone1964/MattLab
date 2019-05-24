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
renderTorpedo(TorpState,'Scale',6,'BodyColor',[0 0.8 0.8]);

% Transmit from the forward array
BeamPosition = SubPosition + Otaa.SF.Offset;
BeamAttitude = [0 0 pi/2];
BeamState = initializePlatformState('Position',BeamPosition, ...
				    'Attitude',BeamAttitude);
renderBeamPattern(BeamState,...
		  'AngleLimit',pi/10, ...
		  'Scale',200,...
		  'FaceAlpha',0.5, ...
		  'FaceColor',[0.7 0.0 0.0], ...
		  'LineStyle','-', ...
		  'EdgeColor',[0.7 0.0 0.0]);
axis tight; axis equal;
view(100,5);
set(gca,'XTick',[],'YTick',[],'ZTick',[]);

% Now, draw a picture of a pulse being transmitted

Range = norm(TorpPosition - SubPosition);
Ranges = (floor(0.5*Range):1:ceil(0.75*Range))';
NumWavelengths = 8;
Signal = ...
    sin(2*pi*NumWavelengths*(Ranges-min(Ranges))/(max(Ranges) - min(Ranges)));
Signal = Signal .* hanning(length(Signal));

Direction = (TorpPosition - SubPosition)/Range;

PulseLine = [Direction(1)*Ranges ...
	     Direction(2)*Ranges ...
	     Direction(3)*Ranges + 40 * Signal]';
PulseLine = PulseLine + repmat(BeamPosition,1,length(Ranges));
plot3(PulseLine(1,:),PulseLine(2,:),PulseLine(3,:),'k');




