import pandas as pd
import matplotlib.pyplot as plt
import os

# Nama file CSV (ubah jika nama file berbeda)
filename = "BuckConverter.csv"

# Cek apakah file ada di direktori kerja saat ini
if not os.path.exists(filename):
    print(f"File '{filename}' tidak ditemukan di direktori saat ini: {os.getcwd()}")
else:
    # Baca file CSV
    df = pd.read_csv(filename, delimiter='\t')  # Gunakan '\t' untuk file LTspice default

    # Tampilkan nama-nama kolom
    print("Kolom yang tersedia:", list(df.columns))

    # Asumsikan kolom pertama adalah waktu
    waktu = df.iloc[:, 0]

    # Plot semua sinyal selain waktu
    plt.figure(figsize=(10, 6))
    for col in df.columns[1:]:
        plt.plot(waktu, df[col], label=col)

    plt.title("Hasil Simulasi LTspice")
    plt.xlabel("Waktu (s)")
    plt.ylabel("Nilai")
    plt.legend()
    plt.grid(True)
    plt.tight_layout()
    plt.show()
