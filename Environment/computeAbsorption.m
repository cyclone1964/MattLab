%computeAbsorption - compute absorption according to Thorp's Model
%
% Absorption = computeAbsorption(Frequency) computes
% the absorption of the water at the given frequency according to
% Thorp's model, with the result being returned in db/m
%
% Copywrite 2009 BBN Technlogies, Matt Daily author
function Absorption = computeAbsorption(Frequency)

Frequency = Frequency * 0.001;
Term1 = 0.1 * Frequency.^2./(1 + Frequency.^2);
Term2 = 40 * Frequency.^2./(4100 + Frequency.^2);
Term3 = 2.75e-4 * Frequency.^2;

Absorption = 0.001 * (Term1 + Term2 + Term3 + 0.003) /.9144;
