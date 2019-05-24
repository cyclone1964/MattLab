% A simple script that attempts to render an OTAA in MATLAB
% None of these dimensions are right but chosen to make a shape that looks about
% right to me

% Create a cylinder that is 2 high and 1 across
Radius = ones(40,1);
[X,Y,Z] = cylinder(Radius,40);
X = 0.5 * X;
Y = 0.5 * Y;
Z = 2 * Z;
Z = Z - mean(Z(:));

% Now cut the top at 45 degrees
Positions = [X(:) Y(:) Z(:)]';
Indices = find(Positions(3,:) > 0);
Positions(3,Indices) = Positions(3,Indices) - Positions(1,Indices);

X = reshape(Positions(1,:),size(X));
Y = reshape(Positions(2,:),size(Y));
Z = reshape(Positions(3,:),size(Z));

% Close both ends;
X(1,:) = 0;
Y(1,:) = 0;
X(end,:) = 0;
Y(end,:) = 0;
Z(end,:) = 1;

% Now draw the two subarrays as black circles
Angles = 0:1:360;
Circle = [sind(Angles); cosd(Angles); zeros(size(Angles))];

LFSA = Circle * 0.4;
LFSA(1,:) = LFSA(1,:) + 0.25;
LFSA(3,:) = 0;

LFSA = computeRotationMatrix([0;pi/4; 0]) * LFSA;
LFSA(3,:) = LFSA(3,:) + 1;

HFSA = Circle * 0.2;
HFSA(1,:) = HFSA(1,:) - 0.4;
HFSA(3,:) = 0;

HFSA = computeRotationMatrix([0;pi/4; 0]) * HFSA;
HFSA(3,:) = HFSA(3,:) + 1;

% Render them
figure(1); clf; hold on;
surf(X,Y,Z,'FaceColor',[0.5 0.5 0.5],'EdgeColor','none'); axis equal
fill3(LFSA(1,:),LFSA(2,:),LFSA(3,:),[0 0 0]);
fill3(HFSA(1,:),HFSA(2,:),HFSA(3,:),[0 0 0]);
xlabel('X'); ylabel('Y'); zlabel('Z');

% Make it look nice
light
view(45,45);
