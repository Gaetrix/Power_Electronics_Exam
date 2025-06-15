% Parameter dasar
vin = 12;        % Input voltage [V]
vo = 3.3;        % Output voltage [V]
fs = 10e3;       % Switching frequency [Hz]
R = 1.2;         % Load resistance [Ohm]
dI = 0.2;        % Current ripple fraction
dV = 0.02;       % Voltage ripple fraction
Rloss = 0.001;	  % R losses


% Duty cycle dan periode switching
D = vo / vin;
Ts = 1 / fs;

% Arus beban rata-rata dan ripple
Io = vo / R;
Ir = Io * dI;    % Ripple current
Vr = vo * dV;    % Ripple voltage

% Induktansi dan kapasitansi hasil desain
L = vo * (1 - D) / (Ir * fs);
C = vo * (1 - D) / (8 * Vr * L * fs^2);

% KP dan KI
Fbp = fs/20;     % Bandwith Propotional
Fbi = Fbp/10;    % Bandwith Integral
Kp  = 2*pi*Fbp*C % Konstanta Proptional
Ki  = 2*pi*Fbi*Kp% Konstanta Integral

