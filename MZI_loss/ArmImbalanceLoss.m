function T_loss = ArmImbalanceLoss(alpha_top, alpha_bottom)
    T_loss = [alpha_top, 0; 0, alpha_bottom];
end