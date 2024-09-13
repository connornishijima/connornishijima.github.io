---
title: Emotiscope
layout: page
nav_order: 1
---

<video class="youtube-video" autoplay loop muted>
    <source src="https://github.com/connornishijima/connornishijima.github.io/blob/main/img/EMOTISCOPE_LOOP.mp4?raw=true" type="video/mp4">
    Your browser does not support the video tag.
</video>

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

<br>
[Read The Firmwware (C/C++)](https://github.com/Lixie-Labs/Emotiscope/blob/2.0/main/Emotiscope.c){: .btn .btn-green }

--------------------------------------------

<blurb>I designed Emotiscope as a powerful bridge between sight and sound, with a focus on imperceptable latency and minimalist design.</blurb>

--------------------------------------------

<iframe class="youtube-video" src="https://www.youtube.com/embed/n2YH9V63OQo" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## Hardware Design Overview

**Stunning when you need it, invisible when you don't**

With a show that’s reactive to notation, vibrato, tempo, and more, Emotiscope uses a powerful dual-core microcontroller to produce very unique and pleasant-to-look-at light shows which synchronize to your music without any perceptible latency.

It features a magic black diffuser covering 128 of the world’s smallest addressable LEDs, which are being refreshed at 300-500 FPS. This combination produces a beautiful, analog appearance with a very high dynamic range and apparent spatial resolution.

--------------------------------------------

![EMOTISCOPE PCB](https://raw.githubusercontent.com/connornishijima/connornishijima.github.io/main/img/emotiscope_pcb_fade.png)

## Part Highlights

### ESP32-S3 Microcontroller

- Dual-core 240 MHz (CPU and "GPU")
- Emotiscope Engine FW built on new ESP-IDF 5.x
- Uses Espressif's ESP-DSP library to perform SIMD operations on 32-bit floating point registers
- **GPU** / Core 0:
    - Runs at a variable 300-500 FPS depending on shader complexity
    - ["Light Mode" Renderers (Shaders)](https://github.com/Lixie-Labs/Emotiscope/blob/2.0/main/light_modes/active/fft.h)
    - [Simulated Phosphor Decay](https://github.com/Lixie-Labs/Emotiscope/blob/92e14bdd36d96f1da59f852a4a769af0639b7116/main/leds.h#L547)
    - [Temporal Dithering](https://github.com/Lixie-Labs/Emotiscope/blob/92e14bdd36d96f1da59f852a4a769af0639b7116/main/led_driver.h#L240)
    - [Incandescent LUT](https://github.com/Lixie-Labs/Emotiscope/blob/92e14bdd36d96f1da59f852a4a769af0639b7116/main/leds.h#L386)
    - [RMT output to LEDs](https://github.com/Lixie-Labs/Emotiscope/blob/92e14bdd36d96f1da59f852a4a769af0639b7116/main/led_driver.h#L94)
- **CPU** / Core 1: 
    - Runs at a fixed 100 FPS
    - [IO/touch reading](https://github.dev/Lixie-Labs/Emotiscope/tree/2.0)
    - [Audio acquisition](https://github.com/Lixie-Labs/Emotiscope/blob/92e14bdd36d96f1da59f852a4a769af0639b7116/main/microphone.h#L87)
    - [Goertzel (160 instances)](https://github.com/Lixie-Labs/Emotiscope/blob/92e14bdd36d96f1da59f852a4a769af0639b7116/main/goertzel.h#L195)
    - [FFT](https://github.com/Lixie-Labs/Emotiscope/blob/92e14bdd36d96f1da59f852a4a769af0639b7116/main/fft.h#L45)
    - [Tempo/phase estimation](https://github.com/Lixie-Labs/Emotiscope/blob/92e14bdd36d96f1da59f852a4a769af0639b7116/main/tempo.h#L152)
    - [WiFi](https://github.com/Lixie-Labs/Emotiscope/blob/92e14bdd36d96f1da59f852a4a769af0639b7116/main/wireless.h#L299)
    - [Websockets](https://github.com/Lixie-Labs/Emotiscope/blob/92e14bdd36d96f1da59f852a4a769af0639b7116/main/packets.h#L12)
    - [HTTP](https://github.com/Lixie-Labs/Emotiscope/blob/92e14bdd36d96f1da59f852a4a769af0639b7116/main/wireless.h#L130)
    - [Self Profiling](https://github.com/Lixie-Labs/Emotiscope/blob/92e14bdd36d96f1da59f852a4a769af0639b7116/main/profiler.h#L99)

### XL-1010RGBC (x128)

- World's smallest 8-bit RGB Adressable LEDs (1mm x 1mm)
- Error diffusion algorithm for temporal dithering
- Approx. 11-bit range visible to eye after dither trick

### SPH-0645 MEMS Microphone

- I2S Bottom-firing Digital Microphone
- Sample Rate: 12,800Hz (Custom)
- Mounted to custom daughter board to allow for drop-in replacement microphones if needed

### 2300K LED Power Indicator

- Not yellow, but a calm, warm, incandescent-looking 2600K white
- Certainly not *bright blue* like a maniac

------------------------------------------------

<iframe class="youtube-video" src="https://www.youtube.com/embed/4Tvr3uwxelA" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## LEDs Pretending To Be More

The RGB LEDs are 1.5mm apart and only 1mm in size. Even though these tiny LEDs already have a high pixel density, I also use subpixel rendering techniques that allow me to move (the apparent position of) dots on the screen less than 0.1mm at a time. The effect gives the illusion of a display with a spatial resolution >250 DPI.

Important to the illusion was the use of per-LED Temporal Dithering. These WS2812B-compatible LEDs only have 8-bits per color channel, which leads to awful banding artifacts at low brightnesses. However, they can be updated 500 times a second, which is much faster than your eyes can make out. By dithering the 8-bit color channels of each LED every few frames, your eyes are tricked into seeing a color depth of approximately 11-bits per channel. That's 2048 brightness levels instead of just 256, which leads to darker possible colors and better gradients at low brightnesess.

---------------------------------------------------

<iframe class="youtube-video" src="https://www.youtube.com/embed/HZR-9pEwA5I" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## Reversible Panels

Beneath the display is a wooden panel of either Walnut or Bamboo, with the Emotiscope logo in the center. Both the wooden panel and the diffuser are reversible: The wood can be reversed to hide the logo, and the diffuser has either a matte side which is fingerprint resistant, or a classy gloss side with slightly higher contrast.

--------------------------------------------------

![TOUCH](https://raw.githubusercontent.com/lixie-labs/emotiscope/main/extras/img/emotiscope_spectrum_crop.jpg?raw=true)

## 3D Printed Components

The plastic parts such as the feet and USB port cover are manufactured in-house with a Prusa Mini+ printer, in Galaxy Black PLA filament. They're designed to print quickly and without supports. I use a smooth print bed so that the faces of Emotiscope's feet are smooth to the touch.

--------------------------------------------------

![TOUCH](https://raw.githubusercontent.com/lixie-labs/emotiscope/main/extras/img/emotiscope_spectrum_crop.jpg?raw=true)

## A Cushion Of Cork

Beneath Emotiscope's feet are laser-cut cork pads, which protect furniture from damage and provide a good grip on surfaces.

--------------------------------------------------

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

![EMOTISCOPE APP](https://raw.githubusercontent.com/connornishijima/connornishijima.github.io/main/img/remote_control.jpg)

## The Remote Control

**An app built by a hardware designer to be fun, responive, and ergonomic.**

You don’t need an account, there’s no ads, there’s no subscription. You can save it to your homescreen via the browser’s menu and it’ll get an icon just like a “real” app.

<iframe class="youtube-video" src="https://www.youtube.com/embed/SXX167ymKAM" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

------------------------------------------------

![TOUCH](https://raw.githubusercontent.com/lixie-labs/emotiscope/main/extras/img/emotiscope_spectrum_crop.jpg?raw=true)