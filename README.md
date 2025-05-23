Overview: Full Project Steps
✅ Step 0: Understand the concept
✅ Done — we clarified ambiguity, feedback loops, phase shifters, and detectors.

🔷 Step 1: Simulate an Ideal MZI
Implement the MZI transfer function as a function of ϕ and θ.

Simulate how output power ratio PR(C) and phase difference χ_C vary.

Visualize ambiguity: show that multiple settings can give the same outputs.

🔷 Step 2: Simulate Tolerances (Imperfections)
Introduce “real-world” imperfections:

Random phase offsets (±x%) to ϕ, θ

Insertion losses (reduce output amplitude)

Sensor noise (add random noise to PR(C))

✅ Goal: Show how these deviations cause incorrect outputs without correction.

🔷 Step 3: Implement Feedback Control
Replicate the paper’s feedback system:

Use target_PR_B and target_PR_C

Compute control error: actual PR - target PR

Use simple integral control to adjust ϕ, θ until target PR is matched

Also use sign of the derivative to disambiguate multiple solutions

✅ Goal: Show that feedback can recover correct behavior despite tolerances.

🔷 Step 4: Test Phase Stability Over Time
Simulate thermal drift: slowly change ϕ or θ over time (e.g., linearly)

Show how PR drifts without feedback

Re-enable feedback and show it restores target PR

✅ Goal: Confirm feedback maintains precision over time.

🔷 Step 5: Analyze Accuracy, Precision, Resolution
Use formulas from paper:

Accuracy: mean(abs(PR_measured - PR_target))

Precision: std(PR_measured)

Resolution (Eq. 5):

matlab
Copia
Modifica
resolution = log2((PR_max - PR_min) / sigma);
✅ Goal: Quantify system performance in bits.

🔷 Step 6 (Optional): Matrix-Vector Multiplication
Simulate VC = TMZI * VA for different inputs VA

Validate that expected outputs are correct

Vary input phase differences and power ratios

✅ Goal: Show the MZI works as a matrix-vector multiplier.

🔷 Step 7 (Optional Advanced): Scaling to Mesh
Use multiple MZIs to simulate a 4x4 matrix (like Clements topology)

Not required unless you want to go deep

