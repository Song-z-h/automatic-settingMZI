# Mach-Zehnder Interferometer (MZI) Simulation in MATLAB

This project simulates a Mach-Zehnder Interferometer (MZI) system and explores its behavior under ideal and non-ideal conditions, with feedback control for precision. The goal is to evaluate the system's effectiveness and accuracy as a photonic computing primitive.

---

## ✅ Project Overview

### Step 0: Understand the Concept
- ✔ Clarified the role of phase shifters, feedback loops, detectors, and ambiguity in MZI systems.

---

## 🔷 Simulation Steps

### Step 1: Simulate an Ideal MZI
- Implement the MZI transfer function as a function of phase shifts ϕ and θ.
- Simulate how:
  - Output power ratio `PR(C)`
  - Phase difference `χ_C`
  vary with inputs.
- Visualize ambiguity: demonstrate how multiple settings yield the same output.

### Step 2: Simulate Tolerances (Imperfections)
- Add real-world imperfections:
  - Random phase offsets (±x% variation)
  - Insertion losses (reduced amplitude)
  - Sensor noise (randomized PR(C))
- ✔ Goal: Demonstrate incorrect outputs without compensation.

### Step 3: Implement Feedback Control
- Simulate feedback loop:
  - Use `target_PR_B` and `target_PR_C`
  - Compute error: `actual PR - target PR`
  - Adjust ϕ and θ using integral control
  - Use derivative sign to resolve ambiguity
- ✔ Goal: Recover correct behavior despite imperfections.

### Step 4: Test Phase Stability Over Time
- Simulate slow drift in ϕ or θ (e.g., thermal effects).
- Without feedback: observe drift in PR.
- With feedback: demonstrate correction and stability.
- ✔ Goal: Validate long-term phase stability with feedback.

### Step 5: Analyze Accuracy, Precision, Resolution
- Apply paper’s formulas:
  - **Accuracy** = `mean(abs(PR_measured - PR_target))`
  - **Precision** = `std(PR_measured)`
  - **Resolution** (from Eq. 5):

    ```matlab
    resolution = log2((PR_max - PR_min) / sigma);
    ```

- ✔ Goal: Quantify performance in bits.

---

## 🔷 Optional Extensions

### Step 6: Matrix-Vector Multiplication
- Simulate: `VC = TMZI * VA`
- Validate correctness for varying inputs.
- ✔ Goal: Demonstrate MZI as a matrix-vector multiplier.

### Step 7: Scaling to Mesh (Advanced)
- Simulate a 4x4 mesh (e.g., Clements topology) using multiple MZIs.
- ✔ Goal: Explore scalability for larger photonic systems.

---

## 📁 File Structure (Suggested)
```plaintext
MZI_Simulation/
├── Step1_IdealMZI.m
├── Step2_Tolerances.m
├── Step3_FeedbackControl.m
├── Step4_ThermalDrift.m
├── Step5_Analysis.m
├── utils/
│   └── mzi_transfer.m
├── plots/
│   └── *.png
└── README.md
