import numpy as np
import matplotlib.pyplot as plt

# Konstanta
Vg_peak = 311  # V, tegangan grid (peak)
I_peak = 21.42  # A, arus (peak)
f = 50  # Hz
w = 2 * np.pi * f
L = 3.66e-3  # H

# Tegangan pada induktor: VL = jωLI → 90° leading terhadap I
V_L_peak = w * L * I_peak  # tegangan peak pada induktor

# Buat phasor sebagai bilangan kompleks
phasor_I = I_peak * np.exp(1j * 0)             # arus I sebagai referensi
phasor_Vg = Vg_peak * np.exp(1j * 0)           # Vg sefase dengan I (misal unity power factor)
phasor_VL = V_L_peak * np.exp(1j * np.pi/2)    # tegangan induktor 90° leading
phasor_Vinv = phasor_Vg + phasor_VL            # penjumlahan vektor (phasor)

# Fungsi bantu plotting
def draw_phasor(ax, z, label, color):
    ax.arrow(0, 0, np.real(z), np.imag(z), 
             head_width=5, length_includes_head=True,
             head_length=8, fc=color, ec=color)
    ax.text(np.real(z)*1.05, np.imag(z)*1.05, label, fontsize=12, color=color)

# Plotting
fig, ax = plt.subplots(figsize=(8, 8))
draw_phasor(ax, phasor_I, "I", "blue")
draw_phasor(ax, phasor_Vg, "Vg", "green")
draw_phasor(ax, phasor_VL, "VL = jωLI", "red")
draw_phasor(ax, phasor_Vinv, "Vinv", "purple")

# Styling
ax.set_title("Phasor Diagram: Vinv = Vg + jωLI", fontsize=14)
ax.grid(True)
ax.set_xlabel("Re", fontsize=12)
ax.set_ylabel("Im", fontsize=12)
ax.set_aspect('equal')
ax.set_xlim(-50, np.real(phasor_Vinv)*1.2)
ax.set_ylim(-50, np.imag(phasor_Vinv)*1.2)
plt.show()
