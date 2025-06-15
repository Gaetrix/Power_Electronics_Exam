import pandas as pd
import matplotlib.pyplot as plt
import os

# Nama file CSV hasil ekspor dari PLECS
filename = "Cascaded.csv"

# Cek apakah file ada
if not os.path.exists(filename):
    print(f"File '{filename}' tidak ditemukan di direktori: {os.getcwd()}")
else:
    # Baca CSV PLECS (default biasanya delimiter koma)
    df = pd.read_csv(filename)

    # Tampilkan nama-nama kolom
    print("Kolom yang tersedia:", list(df.columns))

    # Ambil kolom waktu
    waktu = df.iloc[:, 0]

    # Asumsikan kolom kedua adalah tegangan, ketiga adalah arus
    # Kamu bisa ganti label sesuai kolom aslinya jika perlu
    vout_col = df.columns[1]
    il_col = df.columns[2]

    # Buat dua subplot (tegangan dan arus)
    fig, axs = plt.subplots(2, 1, figsize=(10, 8), sharex=True)

    # Plot tegangan
    axs[0].plot(waktu, df[vout_col], label=vout_col, color='blue')
    axs[0].set_ylabel("Tegangan (V)")
    axs[0].set_title("Tegangan Output")
    axs[0].grid(True)
    axs[0].legend()

    # Plot arus
    axs[1].plot(waktu, df[il_col], label=il_col, color='green')
    axs[1].set_xlabel("Waktu (s)")
    axs[1].set_ylabel("Arus (A)")
    axs[1].set_title("Arus Induktor")
    axs[1].grid(True)
    axs[1].legend()

    plt.tight_layout()
    plt.show()
