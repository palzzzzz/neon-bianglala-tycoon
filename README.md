# Bianglala Brainrot

[![make.fun](https://img.shields.io/badge/make.fun-roblox--brainrot--01-ff529d)](https://make.fun/bounty/roblox-brainrot-01)

Pasar malam di pulau kecil, dengan bianglala neon yang membawa karakter absurd Indonesia.
Klaim gondola, isi lapak, gabungkan karakter, lalu bertahan dari Banjir Rob dan Tikus Pasar.

[Main di Roblox](https://www.roblox.com/games/97111459276883)

## Cara main

- Bergerak dengan WASD, lompat dengan Space. Naik tangga di timur bianglala untuk mendekati gondola.
- Tekan E di gondola untuk membeli dan membawa karakter. Uang awal $25; Kakek Kangkung seharga $10.
- Bawa ke lapak sendiri dan tekan E untuk menaruhnya. Karakter menghasilkan uang setiap detik.
- Tekan R di lapak untuk menaikkan tiang. Tekan T untuk kunci $50 selama 60 detik; kunci siap lagi 30 detik setelah habis.
- Tekan F di dua lapak berisi untuk memilih bahan, lalu E di Gerobak Fusion. Tombol RESEP FUSION membuka daftar resep.
- Capai lifetime earnings $250.000 dan datangi gerbang Buka Cabang: uang, karakter, dan tiang direset; income permanen bertambah +1× dan lapak +2.

## Mekanik

- 12 gondola, satu putaran per 60 detik; stok berdasarkan ketinggian gondola saat pengisian.
- 16 karakter utama dan enam hibrida, dengan label nama, rarity, income, serta bentuk dari primitive 3D.
- Tujuh resep fusion, termasuk peluang 30% Maharaja Molen Pelangi dari dua Legendary.
- Mutasi Gold 4% (×2), Diamond 2% (×5), Sambal-Lava 1,5% (×9), Rainbow 0,5% (×20).
- Siklus 180 detik senja dan 60 detik malam. Rob naik lima tingkat dan surut 10 detik saat fajar.
- Lapak terendam berhenti menghasilkan; dua hibrida tahan air tetap aktif. Tiang L5 aman penuh.
- Tikus datang setiap 20 detik malam, mengincar lapak berisi yang tidak terkunci dan mencuri uang sebesar 20× rate karakter.
- Efek fusion mencakup bonus Common, aura lapak sebelah, income global saat berjoget, dan pengganda peluang mutasi.
- Profil sesi baru di Studio; DataStore digunakan pada experience terpublish. Kegagalan load menolak masuk agar data lama tidak tertimpa.

## Build dan status

Sumber utama adalah `src/` dan `default.project.json`. Jalur kerja Rojo-first: jangan menyimpan place dari Studio ke `game.rbxl`.

```powershell
D:\brainrot-tools\rojo-7.7.1\rojo.exe build default.project.json --output game.rbxl
$env:MAKEFUN_OUTPUT_DIR = 'D:\brainrot-verify\dossier'
node main.ts
```

Server memegang semua transaksi dan profil. Client menggambar HUD serta efek. `vendor/makefun-roblox.ts` tetap salinan kit tanpa perubahan.

Fase 1: starter dipublish Public, play code terverifikasi, PLAY.json dan owner.json di-commit.
Fase 2: build dan playtest dasar Studio tersedia. Interaksi klaim Kakek Kangkung, penempatan lapak, dan income $1/s telah diuji melalui prompt game. Pemeriksaan terpisah atas ekonomi, enam resep fusion, upgrade, cooldown kunci, pencurian uang, rebirth, dan tingkat banjir lulus. Persistence pada server live dan sesi multiplayer belum diuji. Screenshot akhir dan publish versi jadi masih belum selesai.
Screenshot starter belum diganti dan bukan bukti gameplay versi ini.
