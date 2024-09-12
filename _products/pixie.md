---
title: Pixie (Classic)
layout: page
nav_order: 4
---

<iframe class="youtube-video" src="https://www.youtube.com/embed/ov4PKlrrAWs" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

# **Pixie Classic (2020)**

#### Easy Micro LED Displays - [WEBSITE](https://connor.nishiji.ma/Pixie)

--------------------------------------------

<blurb>I designed Pixies to enable both beginners and professionals to quickly deploy alphanumeric LEDs displays using an intuitive Arduino Library and only 2 GPIO.</blurb>

--------------------------------------------

## Part Highlights

### IS37FL3130

- I<sup>2</sup>C LED driver
- Capable of driving a 16x8 matrix
- Instead used to drive two 5x7 matrices

### ATTINY45

- 16 MHz, single core
- Controls the IS37FL3130 driver
- Passes clocked data in and out to other displays in the chain **[with high-speed ASM code](https://github.com/connornishijima/Pixie/blob/0244ab2d765876a36647734ee5bcd1ff8f17be7c/examples/PIXIE_FIRMWARE/Pixie_Firmware_120/Pixie_Firmware_120.ino#L81)**

### LTP-305G (x2)

- 5x7 Micro-LED display

![Pile of Pixies](https://raw.githubusercontent.com/connornishijima/connornishijima.github.io/main/img/pixie_classic_pile.jfif)

![Pixie CLassic PCB](https://raw.githubusercontent.com/connornishijima/connornishijima.github.io/main/img/pixie_classic_pcb.jpg)

----------------------------------------------------------------

## Do You Like Datasheets?

**(I do, I wrote one.)**

**Below is the full datasheet I designed and wrote for Pixie displays which thoroughly explains both the hardware and firmware, including how the internal data buffer is laid out and how Pixies communicate.**

![PAGE 1](https://raw.githubusercontent.com/connornishijima/connornishijima.github.io/main/img/datasheet_page_1.jpg)

![PAGE 2](https://raw.githubusercontent.com/connornishijima/connornishijima.github.io/main/img/datasheet_page_2.jpg)

![PAGE 3](https://raw.githubusercontent.com/connornishijima/connornishijima.github.io/main/img/datasheet_page_3.jpg)

![PAGE 4](https://raw.githubusercontent.com/connornishijima/connornishijima.github.io/main/img/datasheet_page_4.jpg)

![PAGE 5](https://raw.githubusercontent.com/connornishijima/connornishijima.github.io/main/img/datasheet_page_5.jpg)

![PAGE 6](https://raw.githubusercontent.com/connornishijima/connornishijima.github.io/main/img/datasheet_page_6.jpg)

![PAGE 7](https://raw.githubusercontent.com/connornishijima/connornishijima.github.io/main/img/datasheet_page_7.jpg)

![PAGE 8](https://raw.githubusercontent.com/connornishijima/connornishijima.github.io/main/img/datasheet_page_8.jpg)

![PAGE 9](https://raw.githubusercontent.com/connornishijima/connornishijima.github.io/main/img/datasheet_page_9.jpg)

![PAGE 10](https://raw.githubusercontent.com/connornishijima/connornishijima.github.io/main/img/datasheet_page_10.jpg)

--------------------------------------------------
