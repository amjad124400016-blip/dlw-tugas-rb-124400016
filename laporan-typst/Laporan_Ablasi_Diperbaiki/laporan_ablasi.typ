// Laporan hasil tugas ablasi — berdasarkan output tugas_ablasi.ipynb
#import "@preview/charged-ieee:0.1.4": ieee

#set text(lang: "id")
#let hasil(isi) = text(fill: black)[#isi]

#show: ieee.with(
  title: [Studi Ablasi ANN, RNN, LSTM, dan GRU untuk Prediksi Trafik Seluler],
  abstract: [
    Penelitian ini mengevaluasi pengaruh konfigurasi model terhadap prediksi trafik internet per jam menggunakan data Telecom Italia di area Duomo, Milan, serta menguji generalisasi pada Parco Sempione. Empat model dibandingkan: ANN, RNN, LSTM, dan GRU. Eksperimen meliputi panjang jendela, ukuran hidden, jumlah lapisan, learning rate, kelompok fitur, optimizer, dan patience. Setiap konfigurasi dievaluasi dengan tiga seed; pemilihan konfigurasi mengacu pada rata-rata MAE validasi, sedangkan kinerja akhir dilaporkan pada minggu test dan periode Natal. Pada konfigurasi acuan, RNN memperoleh test MAE 229,6 ± 5,1 dan GRU 237,2 ± 9,3, lebih rendah daripada LSTM dan ANN. Ablasi menunjukkan bahwa panjang jendela pendek membantu ANN, tetapi RNN relatif stabil pada jendela yang lebih panjang. Learning rate 0,0001 dan optimizer SGD tidak mencapai hasil sebaik Adam pada batas 300 epoch. Konfigurasi gabungan yang diuji tidak mengubah konfigurasi acuan, sehingga hasil “terbaik” sama dengan acuan. Pada Parco Sempione, RNN menjadi model dengan test MAE terendah, yaitu 99,5 ± 2,7. Kesalahan seluruh model meningkat pada periode Natal, menandakan perubahan pola trafik dan tantangan generalisasi temporal.
  ],
  authors: (
    (name: "Amjad Rozan", department: [NIM 12440016], organization: [Teknik Telekomunikasi, ITERA], email: "amjad.124400016@student.itera.ac.id"),
    
  ),
  index-terms: ("prediksi trafik seluler", "ANN", "RNN", "LSTM", "GRU", "studi ablasi"),
  bibliography: bibliography("references.bib", style: "ieee"),
)

= Pendahuluan
Prediksi trafik seluler membantu operator memperkirakan kebutuhan kapasitas jaringan dan mengenali perubahan beban dari waktu ke waktu. Trafik bersifat temporal: penggunaan pada suatu jam dapat dipengaruhi oleh jam sebelumnya serta pola harian dan mingguan. Karena itu, model yang memanfaatkan urutan seperti recurrent neural network (RNN), long short-term memory (LSTM), dan gated recurrent unit (GRU) layak dibandingkan dengan artificial neural network (ANN) yang menerima jendela data sebagai masukan tetap.

Studi ablasi mengubah satu faktor pada satu waktu untuk mengetahui seberapa sensitif hasil terhadap pilihan desain. Laporan ini (1) membandingkan empat arsitektur pada konfigurasi acuan, (2) menguji lima faktor wajib dan dua faktor pilihan, serta (3) mengevaluasi model pada lokasi lain di Milan. Seluruh angka hasil eksperimen diambil dari output notebook yang dijalankan.

= Data dan Metode
== Dataset dan pembagian waktu
Data berisi 1.344 observasi per jam dengan fitur trafik internet (`net`), panggilan (`call`), SMS (`sms`), serta representasi siklik jam dan hari (`jam_sin`, `jam_cos`, `hari_sin`, `hari_cos`). Dataset aktivitas perkotaan Milan yang menjadi konteks data ini diperkenalkan oleh Barlacchi et al. @barlacchi2015milan. Eksperimen utama menggunakan kotak Duomo (kode lokasi `duomo`, kotak 5060). Uji generalisasi memakai lokasi kode 6, Parco Sempione (kotak 5455).

Pembagian mengikuti urutan waktu: train 11 November–8 Desember, validasi 9–15 Desember, test 16–22 Desember, dan periode Natal 23–29 Desember. Jendela historis membentuk masukan untuk memprediksi trafik satu jam berikutnya (`horizon = 1`). Fitur distandarisasi menggunakan statistik sebelum minggu validasi agar informasi masa depan tidak bocor ke proses praproses. Data deret waktu tidak diacak karena urutan dan pemisahan waktu perlu dipertahankan.

== Model dan konfigurasi acuan
ANN meratakan jendela masukan lalu meneruskannya ke lapisan dense. RNN memproses urutan secara rekuren, sedangkan LSTM dan GRU menggunakan gerbang untuk mengatur informasi yang dibawa antarwaktu. Arsitektur LSTM diperkenalkan oleh Hochreiter dan Schmidhuber @hochreiter1997lstm, sedangkan GRU digunakan dalam pendekatan encoder--decoder berbasis RNN oleh Cho et al. @cho2014gru. Konfigurasi acuan memakai jendela 24 jam, horizon 1 jam, Adam dengan learning rate 0,001, batch size 64, dropout 0, patience 30, dan maksimum 300 epoch. Ukuran hidden acuan adalah ANN 32, RNN 68, LSTM 33, dan GRU 38; ANN menggunakan dua lapisan tersembunyi, sedangkan model rekuren satu lapisan. Fitur acuan mencakup seluruh tujuh fitur. Training menggunakan early stopping dan bobot terbaik berdasarkan loss validasi.

== Protokol evaluasi
Setiap konfigurasi diuji dengan tiga seed. Hasil diringkas sebagai rata-rata ± simpangan baku. Metrik utama untuk pemilihan konfigurasi adalah MAE validasi; MAE test dan MAE Natal dipakai untuk mengevaluasi kinerja pada periode terpisah. Notebook mencatat 348 run dan total waktu training sekitar 131,1 menit. Lingkungan komputasi yang digunakan tidak dicatat secara eksplisit dalam output, sehingga tidak disimpulkan apakah seluruh training berjalan pada CPU atau GPU.

= Hasil
== Baseline naif dan konfigurasi acuan
Baseline naif di Duomo menunjukkan bahwa tidak ada satu metode naif yang unggul pada semua split. Pada horizon satu jam, MAE test adalah 552,2 untuk prediksi “kemarin”, 467,6 untuk “minggu lalu”, dan 600,9 untuk “nilai terakhir”. Seluruh model terlatih memiliki MAE test lebih rendah daripada baseline tersebut.

#figure(
  caption: [Hasil konfigurasi acuan di Duomo. Nilai ditampilkan sebagai MAE rata-rata ± simpangan baku dari tiga seed.],
  table(
    columns: 4,
    align: (left, center, center, center),
    stroke: none,
    table.hline(),
    table.header([*Model*], [*Val MAE*], [*Test MAE*], [*Natal MAE*]),
    table.hline(stroke: 0.5pt),
    [ANN], [250,1 ± 8,6], [313,9 ± 9,9], [675,7 ± 44,6],
    [RNN], [206,1 ± 7,4], [229,6 ± 5,1], [421,2 ± 2,4],
    [LSTM], [230,5 ± 12,2], [273,6 ± 25,4], [586,0 ± 56,8],
    [GRU], [207,5 ± 3,8], [237,2 ± 9,3], [468,2 ± 21,8],
    table.hline(),
  ),
) <tab:acuan>

RNN mencatat MAE test terendah pada konfigurasi acuan (229,6), diikuti GRU (237,2), LSTM (273,6), dan ANN (313,9). RNN juga memiliki simpangan baku test yang relatif kecil. Pada periode Natal, kesalahan meningkat pada semua model, paling jelas pada ANN dan LSTM. Hal ini menunjukkan bahwa performa pada minggu test tidak sepenuhnya mewakili periode dengan pola trafik berbeda.

#figure(
  image("gambar/fig1_baseline.png", width: 100%),
  caption: [Perbandingan MAE test pada empat arsitektur di Duomo. Batang galat menunjukkan simpangan baku dari tiga seed.],
) <fig:baseline>

== Ablasi wajib
=== A1. Panjang jendela
Panjang jendela yang diuji adalah 6, 12, 24, 48, dan 168 jam. Untuk ANN, jendela 6 jam memberikan val MAE 212,5 ± 5,2 dan test MAE 271,1 ± 13,9; ketika jendela menjadi 168 jam, val MAE naik menjadi 298,2 ± 18,2 dan test MAE menjadi 402,0 ± 12,5. Jumlah parameter ANN juga meningkat dari 2.465 menjadi 38.753. Sebaliknya, RNN memiliki val MAE terendah pada jendela 48 jam (200,1 ± 5,3) dan test MAE 224,5 ± 11,7. Jadi, jendela yang lebih panjang tidak otomatis lebih baik; dampaknya bergantung pada arsitektur dan kapasitas model.

#figure(
  image("gambar/fig2_window.png", width: 100%),
  caption: [Contoh hasil panjang jendela yang dilaporkan secara eksplisit pada notebook. Perbandingan ditampilkan sebagai titik konfigurasi, bukan kurva lengkap seluruh nilai W.],
) <fig:window>

=== A2. Ukuran hidden
Ukuran hidden diuji pada 16, 32, 64, dan 128. Pada GRU, val MAE turun dari 216,8 ± 21,2 pada hidden 16 menjadi 188,7 ± 4,2 pada hidden 128; test MAE juga membaik dari 246,9 ± 10,4 menjadi 220,3 ± 10,6. LSTM juga membaik pada ukuran lebih besar, dengan test MAE 245,6 ± 6,7 pada hidden 128. Namun ukuran lebih besar menambah parameter secara signifikan, misalnya GRU dari 1.217 menjadi 52.737 parameter. Hasil ini memperlihatkan manfaat kapasitas tambahan pada beberapa model, tetapi tetap perlu ditimbang terhadap biaya komputasi dan risiko generalisasi.

=== A3. Jumlah lapisan
Jumlah lapisan diuji pada 1, 2, dan 3. Penambahan lapisan tidak konsisten meningkatkan akurasi. RNN satu lapisan memiliki val MAE 206,1 ± 7,4 dan test MAE 229,6 ± 5,1; pada tiga lapisan, test MAE memburuk menjadi 245,5 ± 19,1. LSTM mengalami penurunan paling besar saat tiga lapisan: val MAE 338,9 ± 16,9 dan test MAE 412,6 ± 54,2. Hasil tersebut konsisten dengan dugaan bahwa model yang lebih dalam lebih sulit dilatih pada data terbatas dan dapat mengalami generalisasi lebih buruk.

=== A4. Learning rate
Learning rate 0,0001, 0,001, dan 0,01 diuji dengan batas maksimum 300 epoch. Pada learning rate 0,0001, semua model mencapai 300 epoch dan memperoleh val MAE yang tinggi; contohnya RNN 285,0 ± 13,7. Ini mengindikasikan bahwa laju belajar tersebut terlalu kecil untuk konvergen secara efektif dalam batas yang tersedia. Learning rate 0,001 menghasilkan val MAE RNN 206,1 ± 7,4. Learning rate 0,01 membantu LSTM (val MAE 215,9 ± 14,2), tetapi simpangan baku ANN pada test meningkat menjadi 53,2. Dengan demikian, learning rate optimal dapat berbeda menurut arsitektur, dan laju yang lebih tinggi tidak selalu stabil.

=== A5. Kelompok fitur
Empat kelompok fitur dibandingkan: hanya `net`, `net+call+sms`, `net+waktu`, dan seluruh fitur. Untuk RNN, fitur `net+call+sms` memberi test MAE 227,6 ± 2,2, sedikit lebih baik daripada fitur lengkap (229,6 ± 5,1). Untuk GRU, fitur `net+waktu` menghasilkan val MAE 213,2 ± 18,2 dan test MAE 239,7 ± 25,4, sementara fitur lengkap menghasilkan val MAE 207,5 ± 3,8 dan test MAE 237,2 ± 9,3. Fitur tambahan tidak selalu memperbaiki hasil secara konsisten. Pada ANN, penggunaan hanya `net` memberi test MAE 271,7 ± 13,9, lebih baik daripada konfigurasi fitur lengkap yang mencapai 313,9 ± 9,9.

== Ablasi pilihan
Dua faktor pilihan yang aktif pada notebook adalah optimizer (B3) dan patience (B5).

=== B3. Optimizer
Adam, AdamW, dan SGD dibandingkan. Adam dan AdamW menghasilkan hasil yang sangat mirip pada model rekuren: RNN memiliki test MAE sekitar 229,6, sedangkan GRU sekitar 237,2. SGD mencapai batas 300 epoch untuk semua model dan memberi val MAE lebih tinggi, misalnya 299,2 ± 10,2 untuk RNN dan 413,6 ± 14,3 untuk LSTM. Dalam konfigurasi yang diuji, Adam/AdamW lebih efektif daripada SGD tanpa penyesuaian lain.

=== B5. Patience
Patience 10, 30, dan 60 diuji untuk early stopping. Pada patience 10, RNN memperoleh val MAE 220,2 ± 11,4 dan test MAE 232,3 ± 3,2. Patience 30 memberi val MAE 206,1 ± 7,4 dan test MAE 229,6 ± 5,1. Patience 60 sedikit memperbaiki test MAE GRU menjadi 229,7 ± 7,5, tetapi nilai validasinya 205,6 ± 9,9. Secara umum, patience 30 memberi kompromi yang baik pada RNN; peningkatan patience tidak menjamin perbaikan besar pada semua arsitektur.

== Konfigurasi terbaik
Konfigurasi gabungan pada Bagian C tidak mengubah parameter dari acuan (`TERBAIK` berisi `dict()` untuk setiap model). Oleh karena itu, tabel hasil terbaik sama dengan hasil acuan, bukan hasil tuning gabungan yang independen. Berdasarkan val MAE, RNN memiliki nilai terendah (206,1 ± 7,4), diikuti GRU (207,5 ± 3,8). Pada test, RNN tetap terbaik dengan MAE 229,6 ± 5,1. Nilai Natal RNN adalah 421,2 ± 2,4, jauh di atas test, sehingga generalisasi ke periode Natal masih menjadi keterbatasan.

== Uji generalisasi: Parco Sempione
Pada lokasi kode 6, Parco Sempione (kotak 5455), baseline naif test MAE adalah 137,8 untuk “nilai terakhir”, 231,2 untuk “kemarin”, dan 167,8 untuk “minggu lalu”. RNN memiliki test MAE terendah di antara model terlatih, yaitu 99,5 ± 2,7; GRU memperoleh 108,4 ± 8,9, ANN 116,6 ± 4,7, dan LSTM 119,8 ± 19,2. RNN lebih baik daripada baseline naif terbaik (137,8). Karena konfigurasi terbaik Duomo sama dengan acuan, nilai acuan dan terbaik di Parco Sempione identik. MAE Natal kembali meningkat: RNN 185,3 ± 13,8, GRU 217,4 ± 28,3, ANN 242,3 ± 24,7, dan LSTM 309,6 ± 55,3.

#figure(
  image("gambar/fig3_generalization.png", width: 100%),
  caption: [Perbandingan test MAE antara Duomo dan Parco Sempione. Skala nilai berbeda antarlokasi, sehingga grafik digunakan untuk membandingkan pola umum, bukan besar trafik secara langsung.],
) <fig:generalization>

= Pembahasan
Eksperimen memperlihatkan bahwa pilihan arsitektur dan pengaturan training memengaruhi kesalahan prediksi. RNN memberi hasil paling konsisten pada konfigurasi acuan dan lokasi generalisasi. GRU kompetitif, khususnya ketika ukuran hidden diperbesar. LSTM tidak unggul dalam konfigurasi acuan dan sangat sensitif terhadap penambahan lapisan, yang tampak dari kenaikan MAE pada tiga lapisan. ANN mendapat manfaat dari jendela pendek; memperpanjang jendela membuat masukan ANN jauh lebih besar karena data diratakan, sekaligus meningkatkan jumlah parameter.

Dampak hyperparameter tidak seragam. Learning rate terlalu kecil menyebabkan training mencapai batas epoch, sedangkan SGD pada pengaturan yang diuji juga belum menghasilkan performa kompetitif. Fitur tambahan berupa call, SMS, dan waktu tidak selalu meningkatkan akurasi dibandingkan hanya atau sebagian fitur. Perbedaan ini menguatkan perlunya mengevaluasi konfigurasi pada validasi, bukan memilih berdasarkan test. Simpangan baku antar-seed relatif kecil pada beberapa hasil RNN, tetapi lebih besar pada konfigurasi tertentu, misalnya LSTM dan learning rate tinggi.

Ada beberapa keterbatasan. Eksperimen berfokus pada satu kota dan satu lokasi utama untuk ablasi, menggunakan pembagian waktu yang tetap, serta hanya tiga seed per konfigurasi. Periode Natal memiliki distribusi trafik berbeda dan menimbulkan kesalahan lebih besar. Selain itu, Bagian C tidak melakukan pencarian gabungan parameter karena seluruh `TERBAIK` dibiarkan kosong; kesimpulan “konfigurasi terbaik” karenanya berarti konfigurasi acuan yang diuji ulang, bukan optimum global.

= Kesimpulan
Pada Duomo, RNN merupakan model terbaik dalam konfigurasi acuan dengan test MAE 229,6 ± 5,1, diikuti GRU 237,2 ± 9,3. Ablasi menunjukkan bahwa jendela panjang tidak selalu membantu, kedalaman tambahan dapat memperburuk generalisasi, dan learning rate maupun optimizer perlu disesuaikan dengan arsitektur. Pada Parco Sempione, RNN juga memperoleh test MAE terendah (99,5 ± 2,7) dan mengungguli baseline naif terbaik. Seluruh model mengalami peningkatan kesalahan pada periode Natal, sehingga adaptasi terhadap perubahan pola temporal perlu diteliti lebih lanjut.


#heading(numbering: none)[Pernyataan Penggunaan AI]
ChatGPT digunakan untuk membantu menyusun struktur laporan dan merapikan bahasa berdasarkan output notebook. Seluruh angka eksperimen merujuk pada output `tugas_ablasi.ipynb` yang disediakan.

#heading(numbering: none)[Kode dan Data]
https://github.com/amjad124400016-blip/dlw-tugas-rb-124400016?utm_source=chatgpt.com  