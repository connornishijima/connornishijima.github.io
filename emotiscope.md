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

- 8-bit RGB Adressable LEDs
- Error diffusion algorithm for temporal dithering
- Approx. 11-bit range visible to eye after dither trick

### SPH-0645 MEMS Microphone

- I2S Bottom-firing Digital Microphone
- Sample Rate: 12,800Hz (Custom)
- Mounted to custom daughter board

------------------------------------------------

# The "God Damn Fast Transform"

Actually, "GDFT" is what I call a Goertzel-based Discrete Fourier Transform. Instead of an FFT where there's ***N / 2*** frequency bins spaced linearly on the scale, I've opted to calculate 64 bins of my own choosing one at a time.

This way, they can be allocated logarithmically to represent every note of the western musical scale between A2 (110Hz) and C8 (4186Hz). That's the upper 64 keys of a grand piano!

I used the Goertzel algorithm to quickly calculate each bin sequentially. This allows me to set custom window lengths for every bin to best balance them betweem time and frequency resolution.

    float calculate_magnitude_of_bin(uint16_t bin_number) {
        float magnitude;
        float magnitude_squared;
        float normalized_magnitude;

        float q1 = 0;
        float q2 = 0;
        float window_pos = 0.0;

        const uint16_t block_size = frequencies_musical[bin_number].block_size;

        float coeff = frequencies_musical[bin_number].coeff;
        float window_step = frequencies_musical[bin_number].window_step;

        float* sample_ptr = &sample_history[(SAMPLE_HISTORY_LENGTH - 1) - block_size*2];

        for ( uint16_t i = 0; i < block_size; i++ ) {
            float windowed_sample = sample_ptr[i*2] * window_lookup[(uint32_t)window_pos];
            float q0 = coeff * q1 - q2 + windowed_sample;
            q2 = q1;
            q1 = q0;

            window_pos += window_step;
        }

        magnitude_squared = (q1 * q1) + (q2 * q2) - q1 * q2 * coeff;
        magnitude = sqrtf(magnitude_squared);
        normalized_magnitude = magnitude_squared / (block_size / 2.0);

        return normalized_magnitude;
    }

------------------------------------------------

# Live Tempo Detection

------------------------------------------------

# Tricking Your Eyes

------------------------------------------------

# The Remote Control

------------------------------------------------


![TOUCH](https://github.com/lixie-labs/emotiscope/blob/main/extras/img/emotiscope_spectrum_crop.jpg?raw=true)