---
title: Emotiscope
layout: page
nav_order: 1
---

<iframe class="youtube-video" src="https://www.youtube.com/embed/n2YH9V63OQo" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

HARDWARE
{: .label }

FIRMWARE
{: .label }

OPTIMIZATION
{: .label }

DSP ALGORITHMS
{: .label }

MANUFACTURING
{: .label }

I2S
{: .label }

MEMS
{: .label }

# **Emotiscope (2024)**

#### A Music Visualizer From The Future - [emotiscope.rocks](https://emotiscope.rocks)

--------------------------------------------

<blurb>I designed Emotiscope as a powerful bridge between sight and sound, with a focus on imperceptable latency and minimalist design.</blurb>

--------------------------------------------

<video class="youtube-video" autoplay loop muted>
    <source src="https://github.com/connornishijima/connornishijima.github.io/blob/main/img/EMOTISCOPE_LOOP.mp4?raw=true" type="video/mp4">
    Your browser does not support the video tag.
</video>

![EMOTISCOPE PCB](https://raw.githubusercontent.com/connornishijima/connornishijima.github.io/main/img/emotiscope_pcb_fade.png)

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

<iframe class="youtube-video" src="https://www.youtube.com/embed/FeMDX4kWn0s" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## The "God Damn Fast Transform"

**Actually, "GDFT" is what I call a Goertzel-based Discrete Fourier Transform.**

Instead of an FFT where there's ***N / 2*** frequency bins spaced linearly on the scale, *I've opted to calculate 64 bins of my own choosing*, one at a time. This way, they can be allocated logarithmically to represent every note of the western musical scale between A2 (110Hz) and C8 (4186Hz). That's the upper 64 keys of a grand piano!

I used the Goertzel algorithm to quickly calculate each bin sequentially. This allows me to set custom window lengths (block sizes) for every bin to best balance them betweem time/frequency resolution and performance. Since Emotiscope is not a measurement tool, I was able to find compromises to the DSP code for the sake of speed without sacrificing the final look.

```c
float calculate_magnitude_of_bin(uint16_t bin_number) {
    float magnitude;
    float magnitude_squared;
    float normalized_magnitude;

    float q1 = 0;
    float q2 = 0;
    float window_pos = 0.0;

    // blocksize*2 for downsampling
    const uint16_t block_size = frequencies_musical[bin_number].block_size << 1;
    const float coeff = frequencies_musical[bin_number].coeff;
    const float window_step = frequencies_musical[bin_number].window_step;

    float* sample_ptr = &sample_history[(SAMPLE_HISTORY_LENGTH - 1) - block_size];

    for ( uint16_t i = 0; i < block_size; i++ ) {
        float windowed_sample = sample_ptr[i] * window_lookup[(uint32_t)window_pos];

        // Perform Goertzel step
        float q0 = coeff * q1 - q2 + windowed_sample;
        q2 = q1;
        q1 = q0;

        window_pos += window_step;
    }

    // Calculate magnitude, no phase
    magnitude_squared = (q1 * q1) + (q2 * q2) - q1 * q2 * coeff;
    magnitude = sqrtf(magnitude_squared);
    normalized_magnitude = magnitude_squared / (block_size / 2.0);

    return normalized_magnitude;
}
```

By having varying window lengths per bin, the highest notes can be detected with minimal sample data, and the lowest notes can still have good frequency-domain resolution with minimal latency.

Also employed is a lookup table to a Gaussian window. The index into this table is a floating point number incremented by "window_step", another non-integer. This allows for nearest-neighbor interpolation of the 4096-sample-long LUT at crazy speeds.

```c
void init_window_lookup() {
    for (uint16_t i = 0; i < 2048; i++) {
        // Gaussian window
        float sigma = 0.8;
        float n_minus_halfN = i - 2048 / 2;
        float gaussian_weighing_factor = exp(-0.5 * pow((n_minus_halfN / (sigma * 2048 / 2)), 2));
        float weighing_factor = gaussian_weighing_factor;

        window_lookup[i] = weighing_factor;
        window_lookup[4095 - i] = weighing_factor; // Mirror the value for the second half
    }
}
```

------------------------------------------------

## Live Tempo Detection

**Emotiscope knows how to "tap its foot" to the beat of your music**

------------------------------------------------

## Tricking Your Eyes

**These aren't the colors you're looking at**

------------------------------------------------

## The Remote Control

**An app built by a hardware designer to be fun, responive, and ergonomic.**

![EMOTISCOPE APP](https://raw.githubusercontent.com/connornishijima/connornishijima.github.io/main/img/remote_control.jpg)

You don’t need an account, there’s no ads, there’s no subscription. You can save it to your homescreen via the browser’s menu and it’ll get an icon just like a “real” app.

------------------------------------------------

![TOUCH](https://github.com/lixie-labs/emotiscope/blob/main/extras/img/emotiscope_spectrum_crop.jpg?raw=true)