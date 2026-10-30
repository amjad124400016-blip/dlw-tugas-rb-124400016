# Analisis Hasil Eksperimen Deep Learning

## 1. Pendahuluan

Dokumentasi ini dibuat untuk membantu proses pemeriksaan dan analisis hasil eksperimen pada tugas workshop Deep Learning. Eksperimen membandingkan beberapa model, yaitu ANN, RNN, LSTM, dan GRU, dalam melakukan prediksi trafik seluler.

## 2. Data Hasil Eksperimen

Hasil eksperimen disimpan dalam file `ablasi.csv`. Data tersebut memuat konfigurasi eksperimen, model yang digunakan, seed, serta metrik evaluasi.

Metrik evaluasi yang dicatat meliputi:
- MAE (Mean Absolute Error)
- RMSE (Root Mean Squared Error)
- MAPE (Mean Absolute Percentage Error)

## 3. Analisis Eksperimen

Analisis dilakukan dengan membandingkan hasil setiap variasi konfigurasi eksperimen. Perbandingan perlu memperhatikan nilai MAE, RMSE, dan MAPE pada data validasi maupun pengujian.

Eksperimen A1 sampai A5 digunakan untuk melihat pengaruh perubahan parameter terhadap hasil prediksi. Selanjutnya, eksperimen lainnya digunakan untuk mengevaluasi konfigurasi dan kemampuan generalisasi model.

## 4. Perbandingan Model

Model ANN, RNN, LSTM, dan GRU dibandingkan berdasarkan hasil evaluasi yang tercatat dalam `ablasi.csv`. Model dengan nilai kesalahan lebih rendah menunjukkan hasil prediksi yang lebih baik pada data evaluasi terkait.

## 5. Kesimpulan

Hasil eksperimen perlu dianalisis berdasarkan keseluruhan metrik dan konfigurasi yang digunakan. Pemilihan model terbaik tidak hanya mempertimbangkan satu nilai evaluasi, tetapi juga konsistensi hasil dan kemampuan generalisasi.

Dokumentasi ini akan dilengkapi berdasarkan pemeriksaan lebih lanjut terhadap hasil eksperimen kelompok.
