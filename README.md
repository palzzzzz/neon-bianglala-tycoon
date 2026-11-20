# Bianglala Brainrot

[![make.fun roblox-brainrot-01](https://make.fun/badge/roblox-brainrot-01.svg)](https://make.fun/bounty/roblox-brainrot-01)
[![rank](https://make.fun/badge/roblox-brainrot-01/palzzzzz/neon-bianglala-tycoon/rank.svg)](https://make.fun/bounty/roblox-brainrot-01)
[![reward](https://make.fun/badge/roblox-brainrot-01/palzzzzz/neon-bianglala-tycoon/reward.svg)](https://make.fun/bounty/roblox-brainrot-01)

[Mainkan di Roblox](https://www.roblox.com/games/97111459276883)

Pasar malam di pulau kecil: naik bianglala untuk mengoleksi penghuni pasar absurd,
bawa pulang ke pedestal, lalu gunakan pendapatan untuk fusion dan pertahanan banjir.

## Kontrol

WASD untuk berjalan, Space untuk melompat. E membeli karakter dari gondola dan
menaruh bawaan di pedestal kosong. R meningkatkan tiang; T mengunci lapak.
F memilih dua bahan fusion; E di Gerobak Fusion menggabungkannya.
Gerbang Buka Cabang mereset koleksi untuk pengali income dan dua pedestal tambahan.

## Aturan pasar

Mulai dengan $25K dan enam pedestal. Enam belas karakter utama memiliki enam tingkat
rarity. Dua belas gondola berputar setiap 60 detik; posisi tinggi memberi peluang
rarity tinggi. Koleksi di pedestal membayar setiap detik.

Siklus 240 detik terdiri dari 180 detik senja dan 60 detik malam. Banjir Rob naik
lima tingkat. Tiang L5 dan dua hibrida tahan air tetap menghasilkan saat terendam.
Tikus Pasar mencuri uang; kunci $50K melindungi selama 60 detik, lalu cooldown 30 detik.
Enam pasangan fusion khusus dan resep dua Legendary memberi jalur menuju Tralalero Halolala.
Mutasi Gold, Diamond, Sambal-Lava, dan Rainbow mengalikan pendapatan.

## Sumber dan build

Implementasi ditulis ulang dari dokumen desain dalam sesi pengganti. Sumber utama
adalah `src/`; `game.rbxl` selalu keluaran Rojo, bukan hasil save Studio.

```powershell
D:\brainrot-tools\rojo-7.7.1\rojo.exe build default.project.json --output game.rbxl
```

`main.ts` menyalin payload dan membuat dossier dengan vendor kit yang tidak diubah.
Validasi transcript hanya dapat dibuktikan oleh server make.fun. Folder `screenshots/`
berisi empat tangkapan playtest Studio (sampul, fusion, Kios Lotre, Banjir Rob).
