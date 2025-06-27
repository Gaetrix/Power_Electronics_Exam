% Muhammad Ghiyats AR Rahmaniey (22/503896/TK/55089)
% Parameter 3-PH Inverter
% Will be placed in the same folder as 3P_PV_Grid_Inverter.plecs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Grid parameters (50 Hz 3-phase)
V_gpeak = 230*sqrt(2);     % 230 Vrms phase voltage → 325.3 V peak
R_g = 2;                   % Grid resistance (typical)
L_g = 1e-3;                % Grid inductance
f_g = 50;                  % Grid frequency [Hz]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DC-link voltage
C_dc = 80e-3;              % DC-link capacitance [F] → naikkan sedikit karena daya besar
V_dc = 810;                % DC-link voltage sesuai PV array output

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Grid-side converter
P_n = 13000;               % Nominal power [W], sesuai output array
f_sw = 10e3;               % Switching frequency [Hz] – dinaikkan untuk perbaikan kualitas sinyal

V_grms = V_gpeak/sqrt(2);  % = 230 V
I_grms_max = P_n / (3 * V_grms);       % Phase current (RMS)
I_gpeak_max = I_grms_max * sqrt(2);    % Peak current
I_gpp_max = 2 * I_gpeak_max;           % Peak-to-peak current (2 × peak)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LCL Filter Design
THD = 0.04;                           % Target max THD (4%)
I_hfpp_max = 0.2 * I_gpeak_max;       % 20% ripple current
% Induktor filter sisi inverter:
L_f1 = V_gpeak / (V_dc/sqrt(3)) * cos(pi/6) * (2/3*V_dc - V_gpeak) / (I_hfpp_max * f_sw);
R_f1 = 0;                             % Resistansi filter sisi inverter
L_f2 = L_f1 * 0.15;                   % Induktor sisi grid (biasanya 10–20% dari L1)
% Kapasitor filter:
C_f = 1 / (L_f2 * (2 * pi * f_sw * 10^(20 * log10(I_gpp_max * THD / I_hfpp_max)/40))^2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Limitation
I_f_max = 20;  % Arus maksimum yang diizinkan (limit proteksi kontrol arus)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Current Control Gains (inner loop)
alpha_f = 100;                           % Bandwidth (gain multiplier)
R_res_a = 1e-3;                          % Active damping resistance

R_gc_a = alpha_f * (L_f1 + L_f2) - R_f1;
K_gc_pd = alpha_f * (L_f1 + L_f2);       % Proportional gain (d-axis)
K_gc_id = alpha_f * (R_f1 + R_gc_a);     % Integral gain (d-axis)
K_gc_pq = alpha_f * (L_f1 + L_f2);       % Proportional gain (q-axis)
K_gc_iq = alpha_f * (R_f1 + R_gc_a);     % Integral gain (q-axis)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DC-link voltage controller (outer loop)
alpha_W = 10;  % PI gain multiplier
G_gc_a_W = alpha_W * C_dc / (6 * V_gpeak * sqrt(3)/2);     % plant gain
K_gc_pW = -alpha_W * C_dc / (6 * V_gpeak * sqrt(3)/2);     % proportional gain
K_gc_iW = -alpha_W * G_gc_a_W;                             % integral gain
K_gc_b = 10;  % anti-windup gain

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PV Module: HSL60 240W
% Array configuration: 27 series × 2 parallel = 54 modules total
% Output approx. 13 kW, 810 V, 16.04 A at STC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PV_HSL60.V_vec = linspace(0, 45, 22);  % 0–45 V, Voc = 37.3 V, lebih lebar sedikit untuk margin
PV_HSL60.Sun_vec = 0:0.1:1;

% Arus saat irradiance 1 kW/m² (100%) – linear approximation
I_1000 = [0 1.05 2.10 3.15 4.20 5.25 6.30 7.00 7.50 7.90 8.02 8.05 8.00 7.80 7.50 7.00 6.00 4.50 3.00 1.50 0.5 0];
% Skala linear arus berdasarkan irradiance:
for i = 1:length(PV_HSL60.Sun_vec)
    PV_HSL60.I(i,:) = I_1000 * PV_HSL60.Sun_vec(i);
end
