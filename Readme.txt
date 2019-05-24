This directory contains stuff that I tend to use a lot. Specifically,
things like geometric manipulations and environmental parameters and
drawing certain things. As such, I will give a top level breakdown of
the terminology used in this stuff

Platform - some body in a coordinate system that has its own
coordinate system defined in its space.

Position - an X/Y/Z tripet defining where something is

Location - only the X/Y parts of a position.

Attitude - A triplet of right-handed rotation angles around the X/Y/Z
axes that defines a rotation between platforms or between platform and
ground truth

Orientation - The normalized X/Y/Z pointing direction of the x axis of
one coordinate system in another. This is enough to specify the last
two entries in an Attitude, but not the third

Velocity - the X/Y/Z components of a platform

Speed - the total velocity of a platform

PlatformState - combination of Postion, Velocity, and Attitude of a
body.

Grid - an vector of X, vector of Y, and matrix of Z values along with
other user-defined poperties at every X/Y intersection

SurfaceBoundary - a description of the surface of the ocean

BottomBoundary - a description of the bottom of the ocean

WaterColumn - a description of the water in the ocean

Environment - a WaterColumn, SurfaceBoundary, and BottomBoundary

Array - a series of elements that can for beams

Beam - a beam defined on an array of elements

Pulse - a pulse transmitted by an array into the water

Receiver - an array and band that listens to sound, that can be placed
onto a platform

