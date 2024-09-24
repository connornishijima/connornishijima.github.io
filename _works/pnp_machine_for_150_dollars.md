---
title: Pick and Place Machine for $150
layout: page
---

<iframe class="youtube-video" src="https://www.youtube.com/embed/Us7oQIRNjYY" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

# **Pick and Place Machine for $150 (2018)**

#### I can't even recommend it, but it was neat!

--------------------------------------------

<blurb>I converted an awful entry level 3D printer from Wanhao into a PNP machine which only assembles one very specific type of PCB.</blurb>

--------------------------------------------

![EMOTISCOPE PCB](https://raw.githubusercontent.com/connornishijima/connornishijima.github.io/main/img/patrick.jfif)

## Part Highlights

### ESP32-S3 Microcontroller

- Dual-core 240 MHz (CPU and "GPU")
- Emotiscope Engine FW built on new ESP-IDF 5.x
- Uses Espressif's ESP-DSP library to perform SIMD operations on 32-bit floating point registers
- **GPU** / Core 0:
    - "Light Mode" Renderers (Shaders)
    - Simulated Phosphor Decay
    - Temporal Dithering
    - Incandescent LUT
    - RMT output to LEDs
    - 300-500 FPS
- **CPU** / Core 1: 
    - IO/touch reading
    - Audio acquisition
    - Goertzel (160 instances)
    - FFT
    - Tempo/phase estimation
    - Autocorrelation
    - WiFi
    - Websocket
    - HTTP
    - Self Profiling
    - 100 FPS

### XL-1010RGBC (x128)

- World's smallest 8-bit RGB Adressable LEDs (1mm x 1mm)
- Error diffusion algorithm for temporal dithering
- Approx. 11-bit range visible to eye after dither trick

### SPH-0645 MEMS Microphone

- I2S Bottom-firing Digital Microphone
- Sample Rate: 12,800Hz (Custom)
- Mounted to custom daughter board

------------------------------------------------

## The "God Damn Fast Transform"

**Actually, "GDFT" is what I call a Goertzel-based Discrete Fourier Transform.**

Instead of an FFT where there's ***N / 2*** frequency bins spaced linearly on the scale, *I've opted to calculate 64 bins of my own choosing*, one at a time. This way, they can be allocated logarithmically to represent every note of the western musical scale between A2 (110Hz) and C8 (4186Hz). That's the upper 64 keys of a grand piano!
