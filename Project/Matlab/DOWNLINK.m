clear all;

sympref('FloatingPointOutput', true)
 
syms Pr_received_power_dBW
syms Gr_receiver_antenna_Gain_dB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

c_speed_of_light_ms = 3e8; % m/s
k_boltzmann_constant = 1.380649e-23 % boltzmann constant

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                           Parameters
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 %Pr_received_power_dBW % received power in dBW
 Pt_transmitted_power_dBW = 40% transmitted power in dBW
 f_frequency_hz = 11e9; % Hz
 R_distance_m = 38500e3; % m
 Tin_input_noise_temperature_K = 25 %k
 Trf_RF_Amplifier_noise_temperature_k = 400 %k
 Tm_mixer_noise_temperature_K = 450 %k
 Tif_IF_Amplifier_noise_temperature_K = 550 %k
 Grf_RF_Amplifier_Gain_dB = 35 % db
 Gm_mixer_Gain_dB = 0 % db
 Gif_IF_Amplifier_Gain_dB = 35 % db
 Bn_IF_noise_bandwidth_hz = 27e6 % Hz


 C_by_N_carrirer_to_noise_ratio_dB = 15 % dB or greater
% ne_appature_efficiency = 0.65
% D_diameter_of_antenna_m = 3 % m
Gt_transmitter_antenna_Gain_dB = 25 % db
Power_transmitted = 40; %W
 
 Lant_antenna_loss_dB = 2 % dB
 Lmisc_misc_loss_dB = 0.5 % dB

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                           Equations
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Grf_RF_Amplifier_Gain_linear = 10 .^ (Grf_RF_Amplifier_Gain_dB / 10) % linear
Gm_mixer_Gain_linear = 10 .^ (Gm_mixer_Gain_dB / 10) % linear
Gif_IF_Amplifier_Gain_linear = 10 .^ (Gif_IF_Amplifier_Gain_dB / 10) % linear

Pn_total_noise_power_dBW = 10*log10((Grf_RF_Amplifier_Gain_linear * Gm_mixer_Gain_linear ...
     * Gif_IF_Amplifier_Gain_linear * k_boltzmann_constant ...
     * Bn_IF_noise_bandwidth_hz * k_boltzmann_constant ...
     * (Tin_input_noise_temperature_K + Trf_RF_Amplifier_noise_temperature_k)) ...
     + (Gm_mixer_Gain_linear * Gif_IF_Amplifier_Gain_linear ...
     * k_boltzmann_constant * Bn_IF_noise_bandwidth_hz ...
     * Tm_mixer_noise_temperature_K) ...
     +(Gif_IF_Amplifier_Gain_linear * k_boltzmann_constant ...
     * Bn_IF_noise_bandwidth_hz * Tif_IF_Amplifier_noise_temperature_K)) % noise power in dBW
    

 lambda_wave_length_m = c_speed_of_light_ms / f_frequency_hz; % wavelength = c/f

 Lp_path_loss_dB = 20 * log10(4 * pi * R_distance_m / lambda_wave_length_m) % path loss

Pt_transmitted_power_dBW = 10*log10(Power_transmitted) % transmitted power in dBW

  eqn1 = C_by_N_carrirer_to_noise_ratio_dB == Pr_received_power_dBW - Pn_total_noise_power_dBW % carrier to noise ratio

  eqn2 = Pr_received_power_dBW == Pt_transmitted_power_dBW + Gt_transmitter_antenna_Gain_dB ...
      + Gr_receiver_antenna_Gain_dB ...
      - Lp_path_loss_dB ...
      - Lant_antenna_loss_dB ...
      - Lmisc_misc_loss_dB % received power in dBW

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                           Solve
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 [received_power_dBW receiver_antenna_Gain_dB] = solve([eqn2, eqn1], Pr_received_power_dBW, Gr_receiver_antenna_Gain_dB)

 received_power_W = 10 ^ log10(received_power_dBW) % transmitter power in watts
 receiver_antenna_Gain = receiver_antenna_Gain_dB % transmitter antenna gain in dB

