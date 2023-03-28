clear all;

sympref('FloatingPointOutput', true)
syms Pr_received_power_dBW % received power in dBW
syms Pt_transmitted_power_dBW % transmitted power in dBW

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

c_speed_of_light_ms = 3e8; % m/s
k_boltzmann_constant = 1.380649e-23 % boltzmann constant

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f_frequency_hz = 14e9; % Hz
R_distance_m = 38500e3; % m
Ts_receiving_system_noise_temperature_K = 500 %k
Bn_IF_noise_bandwidth_hz = 36e6 % Hz
C_by_N_carrirer_to_noise_ratio_dB = 35 % dB or greater
ne_appature_efficiency = 0.65
D_diameter_of_antenna_m = 3 % m
Gr_receiver_antenna_Gain_dB = 25 % db
Lant_antenna_loss_dB = 1.5 % dB
Lmisc_misc_loss_dB = 1.5 % dB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Equations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

lambda_wave_length_m = c_speed_of_light_ms / f_frequency_hz; % wavelength = c/f

Lp_path_loss_dB = 20 * log10(4 * pi * R_distance_m / lambda_wave_length_m) % path loss

Gt_transmitter_antenna_Gain_dB = 10 * log10(ne_appature_efficiency * ((4 * pi) / lambda_wave_length_m) ...
    * ((pi * D_diameter_of_antenna_m) / lambda_wave_length_m) ^ 2) % gain of transmitter antenna

Nr_received_noise_power_dBW = 10 * log10(k_boltzmann_constant) ...
    + 10 * log10(Bn_IF_noise_bandwidth_hz) ...
    + 10 * log10(Ts_receiving_system_noise_temperature_K) % noise power in dBW

eqn1 = C_by_N_carrirer_to_noise_ratio_dB == Pr_received_power_dBW - Nr_received_noise_power_dBW % carrier to noise ratio

eqn2 = Pr_received_power_dBW == Pt_transmitted_power_dBW + Gt_transmitter_antenna_Gain_dB ...
    + Gr_receiver_antenna_Gain_dB ...
    - Lp_path_loss_dB ...
    - Lant_antenna_loss_dB ...
    - Lmisc_misc_loss_dB % received power in dBW

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Solve
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[transmitted_power_dBW received_power_dBW] = solve([eqn2, eqn1], Pt_transmitted_power_dBW, Pr_received_power_dBW)

Transmitter_power_W = 10.^(transmitted_power_dBW/10) % transmitter power in watts
transmitter_antenna_Gain_db = Gt_transmitter_antenna_Gain_dB % transmitter antenna gain in dB

