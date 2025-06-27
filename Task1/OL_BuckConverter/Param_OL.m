% Muhammad Ghiyats AR Rahmaniey (22/503896/TK/55089)
% Parameter Open Loop
% Will be placed in the same folder as OL_BuckConverter.plecs
vin = 12.7;        % Input voltage [V]
vo = 3.3;        % Output voltage [V]
fs = 50e3;       % Switching frequency [Hz]
R = 1.2;         % Load resistance [Ohm]
dI = 0.2;        % Current ripple fraction
dV = 0.02;       % Voltage ripple fraction
Rloss = 0.001;	  % R losses


% Duty cycle
D = vo / vin;

% Voltage and Current ripple
Io = vo / R;
Ir = Io * dI;    % Ripple current
Vr = vo * dV;    % Ripple voltage

% Calculate Inductor and Capacitor
L = vo * (1 - D) / (Ir * fs);
C = vo * (1 - D) / (8 * Vr * L * fs^2);

fprintf('Induktor : %.6f H\n', L);
fprintf('Kapasitor: %.6f F\n', C);