function params = check_imperfection_fields(imperfections)
% check random parameters simulating fabrication and environmental variations
% Output: struct 'params' containing MZI imperfections

    %noise = 0.01 * randn();
    noise=0.00;
    %Phase shifter loss in dB
     if isfield(imperfections, 'loss_ps')
        params.loss_ps = imperfections.loss_ps + noise;
     else 
         params.loss_ps = 0.0;
     end
        
     % Directional coupler imbalance, (50/50) ? (48/52)
     if isfield(imperfections, 'epsilon')
        params.epsilon = imperfections.epsilon + noise;
     else 
         params.epsilon = 0.0;
     end

     %define arm imbalance loss
     if isfield(imperfections, 'alpha_top')
        params.alpha_top = imperfections.alpha_top + noise;
     else 
         params.alpha_top = 1.0;
     end
     if isfield(imperfections, 'alpha_bottom')
        params.alpha_bottom = imperfections.alpha_bottom + noise;
     else 
         params.alpha_bottom = 1.0;
     end

     % Temperature drift  (A periodic shift in time )​
      if isfield(imperfections, 'thermal_drift')
        params.thermal_drift = imperfections.thermal_drift + noise ;
     else 
         params.thermal_drift = 0.0;
      end

      
      %photo detector
       if isfield(imperfections, 'model_photo_detector')
        params.model_photo_detector = true;
      else 
         params.model_photo_detector = false;
       end

       if isfield(imperfections, 'R_responsivity')
          params.R_responsivity = imperfections.R_responsivity;
       else 
           params.R_responsivity = 18e-6; % 18 nA/mW = 18e-6 A/mW
       end

       if isfield(imperfections, 'I_dark')
        params.I_dark = imperfections.I_dark;
      else 
         params.I_dark = 30e-12;       % 30 pA dark current;
       end

      
end
