---
title: Emulating An NES APU on an ESP32
layout: page
---

<iframe class="youtube-video" src="https://www.youtube.com/embed/UeyzAdZLLOk" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

# **Emulating An NES APU on an ESP32 (2018)**

#### I've already forgotten how the weird NES APU registers work!

<br>
[Cartridge Library](https://github.com/connornishijima/Cartridge){: .btn .btn-green }

--------------------------------------------

# Zero-Component Nostalgia

I took the chore upon myself to emulate the quirky Ricoh 2A03 APU from the Nintendo Entertainment System on an ESP32, playing analog audio channels over [delta sigma modulation](https://en.wikipedia.org/wiki/Delta-sigma_modulation) with nothing but a speaker and some wires.

The resulting Cartridge Arduino Library can read .VGM files stored as uint8_t arrays in memory, which describe the timing of changes to the registers of an APU. Included is a Python script for converting .vgz files to C arrays.

--------------------------------------------

