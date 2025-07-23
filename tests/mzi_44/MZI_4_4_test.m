%hadamard
%U_target = 1/2 * [1  1  1  1;
 %                        1 -1  1 -1;
  %                       1  1 -1 -1;
   %  
   %1 -1 -1  1];

  %A = [ 0.9927 + 0.1025i,  -0.0382 - 0.0441i,  -0.0011 - 0.0006i,   0.0000 + 0.0000i;
   %   0.0538 + 0.0061i,   0.1576 + 0.9844i,   0.0309 + 0.0159i,  -0.0008 - 0.0009i;
    % -0.0151 - 0.0287i,   0.0016 - 0.0078i,  -0.9697 - 0.2335i,   0.0194 - 0.0561i;
     % 0.0020 + 0.0039i,   0.0104 - 0.0498i,  -0.0627 - 0.0013i,   0.1278 + 0.9900i ];
   
 A =      [ 0.9956 + 0.0760i,   0.0445 + 0.0027i,  -0.0010 - 0.0001i,  -0.0000 - 0.0000i;
            0.0445 + 0.0034i,  -0.9938 - 0.0918i,   0.0313 + 0.0031i,   0.0010 + 0.0001i;
            0.0000 + 0.0000i,  -0.0000 + 0.0002i,   0.9869 + 0.1483i,  -0.0443 - 0.0040i;
            0.0315 + 0.0010i,  -0.0033 + 0.0445i,   0.0537 + 0.0089i,   0.9928 + 0.1109i ];    
imperfections.loss_ps = 0;
%imperfections.epsilon = 0;
%imperfections.alpha_top = 1;  % 0.5 dB loss top arm
%imperfections.alpha_bottom = 1;         % no loss bottom arm
%imperfections.thermal_drift = 0; %0.05
imperfections.model_photo_detector = false;
imperfections.I_dark = 30e-10;
[U_total, VC, fidelity, output_intensities] = simulate_MZI_4_4(imperfections, A);
