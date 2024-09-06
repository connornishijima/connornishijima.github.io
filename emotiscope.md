---
title: Emotiscope
layout: page
parent: Products
nav_order: 1
---

<iframe class="youtube-video" src="https://www.youtube.com/embed/n2YH9V63OQo" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

# Emotiscope

#### A Music Visualizer From The Future

--------------------------------------------

I designed Emotiscope as a powerful bridge between sight and sound, with a focus on imperceptable latency and minimalist design.

--------------------------------------------

## Part Highlights

### ESP32-S3 Microcontroller

- Dual-core 240 MHz (CPU and "GPU")
- Built on new ESP-IDF 5.x
- Uses Espressif's ESP-DSP library to perform SIMD operations on 32-bit floating point registers
- Core 0 | **CPU**: 
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
- Core 1 | **GPU**:
    - "Light Mode" Renderers (Shaders)
    - Simulated Phosphor Decay
    - Temporal Dithering
    - RMT output to LEDs
    - 300-500 FPS

### XL-1010RGBC (x128)

- 8-bit RGB Adressable LEDs

### SPH-0645 MEMS Microphone

- I2S Bottom-firing Digital Microphone
- Sample Rate: 12,800Hz (Custom)




![TOUCH](https://github.com/lixie-labs/emotiscope/blob/main/extras/img/emotiscope_spectrum_crop.jpg?raw=true)