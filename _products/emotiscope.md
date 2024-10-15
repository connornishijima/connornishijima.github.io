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
{: .no_toc }

#### A Music Visualizer From The Future - [emotiscope.rocks](https://emotiscope.rocks)
{: .no_toc }

<br>
[Read The Firmwware (C/C++)](https://github.com/Lixie-Labs/Emotiscope/blob/2.0/main/Emotiscope.c){: .btn .btn-green }

--------------------------------------------

<blurb>I designed Emotiscope as a powerful bridge between sight and sound, with a focus on imperceptable latency, invisible design, and novel DSP techniques.</blurb>

--------------------------------------------

<iframe class="youtube-video" src="https://www.youtube.com/embed/n2YH9V63OQo" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## Table of Contents
{: .no_toc }

1. TOC
{:toc}

-----------------------------------------------

## Hardware Design Overview

**Stunning when you need it, invisible when you don't**

With a show that’s reactive to notation, vibrato, tempo, and more, Emotiscope uses a powerful dual-core microcontroller to produce very unique and pleasant-to-look-at light shows which synchronize to your music without any perceptible latency.

It features a magic black diffuser covering 128 of the world’s smallest addressable LEDs, which are being refreshed at 300-500 FPS. This combination produces a beautiful, analog appearance with a high dynamic range and apparent spatial resolution.

<iframe class="youtube-video" src="https://www.youtube.com/embed/4Tvr3uwxelA" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

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
- Sample Rate: 12,800Hz (Custom rate to process 128-sample frames at 100Hz)
- Mounted to custom daughter board to allow for replacement I2S microphones if needed

### 2300K LED Power Indicator

- Not yellow, but a calm, warm, incandescent-looking 2600K white
- Certainly not *bright blue* like a *maniac*

### Laser-cut / 3D-printed Enclosure

- Faceplate laser-cut from a walnut veneer
- Matte black rear acrylic plate
- Printed PLA feet with cork pads

------------------------------------------------

## LEDs Pretending To Be More

**Your eyes can't see the tricks, just the results**

The RGB LEDs are 1.5mm apart and only 1mm in size. Even though these tiny LEDs already have a high pixel density, I also use subpixel rendering techniques that allow me to move (the apparent position of) dots on the screen less than 0.1mm at a time. The effect gives the illusion of a display with a spatial resolution >250 DPI while only having 16.93 DPI in reality. Paired with a uniquely high refresh rate (300-500 FPS) Emotiscope doesn’t look like a screen. It looks more like some kind of neon-gas display from the far future or recent past depending on your settings.

<iframe class="youtube-video" src="https://www.youtube.com/embed/HZR-9pEwA5I" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

Important to the illusion was the use of per-LED Temporal Dithering. These WS2812B-compatible LEDs only have 8-bits per color channel, which leads to awful banding artifacts at low brightnesses. However, they can be updated 500 times a second, which is much faster than your eyes can make out. By dithering the 8-bit color channels of each LED every few frames, your eyes are tricked into seeing a color depth of approximately 11-bits per channel. That's 2048 brightness levels instead of just 256, which leads to darker possible colors and better gradients at low brightnesess.

![TEMPORAL DITHERING](https://raw.githubusercontent.com/connornishijima/connornishijima.github.io/main/img/emotiscope_dithering.jpg?raw=true)

This is a photo demonstrating the temporal dithering in action. By taking a photo while flinging my phone through the air, I've effectively used the Y-axis of this photo to show the passage of time. When seen normally with your eyes, this appears as a smooth rainbow gradient from red to blue (with a spectral peak and a harmonic lit brightly in the center) at 1% brightness with no banding. You can see here how Emotiscope preserves color at low brightness with its limited LEDs.

{: .info }
Hardware brag: You're seeing entire rendered + dithered frames drawn by the second ESP32-S3 core (and then transferred to the display) in about the same time my keyboard LEDs take to do a single PWM pulse in the picture above.

--------------------------------------------------

## The "God Damn Fast Transform"

**Actually, "GDFT" is what I call a Goertzel-based Discrete Fourier Transform.**

<iframe class="youtube-video" src="https://www.youtube.com/embed/FeMDX4kWn0s" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

Instead of an FFT where there's ***N / 2*** frequency bins spaced linearly on the scale, *I've opted to calculate 64 bins of my own choosing*, one at a time. This way, they can be allocated logarithmically to represent every note of the western musical scale between A2 (110Hz) and C8 (4186Hz). That's the upper 64 keys of a grand piano!

I used [The Goertzel Algorithm](https://en.wikipedia.org/wiki/Goertzel_algorithm) to quickly calculate each bin sequentially. This allows me to set custom window lengths (block sizes) for every bin to best balance them betweem time/frequency resolution and performance. Since Emotiscope is not a measurement tool, I was able to find compromises to the DSP code for the sake of speed without sacrificing the final look.

```c
float calculate_magnitude_of_bin(uint16_t bin_number) {
    float magnitude, magnitude_squared, normalized_magnitude;
    float q1, q2;
    float window_pos = 0.0;

    // How many samples this specific bin needs (pre-calculated to balance time/freq resolution)
    const uint16_t block_size = frequencies_musical[bin_number].block_size;
    
    // Coefficients were pre-calculated
    const float coeff = frequencies_musical[bin_number].coeff;

    // Used to iterate through the Gaussian window LUT with substeps
    const float window_step = frequencies_musical[bin_number].window_step;

    // Input audio chunk
    float* sample_ptr = &sample_history[(SAMPLE_HISTORY_LENGTH - 1) - block_size];

    // Run Goertzel on this bin
    for ( uint16_t i = 0; i < block_size; i++ ) {
        // Apply window
        float windowed_sample = sample_ptr[i] * window_lookup[(uint32_t)window_pos];
        window_pos += window_step;

        // Perform Goertzel step
        float q0 = coeff * q1 - q2 + windowed_sample;
        q2 = q1;
        q1 = q0;
    }

    // Calculate magnitude, no phase
    magnitude_squared = (q1 * q1) + (q2 * q2) - q1 * q2 * coeff;
    magnitude = sqrtf(magnitude_squared);
    normalized_magnitude = magnitude_squared / (block_size / 2.0);

    return normalized_magnitude;
}
```

By having varying window lengths per bin, the highest notes can be detected with minimal sample data, and the lowest notes can still have good frequency-domain resolution with minimal latency.

---------------------------------------------------

## Live Tempo Detection

**Emotiscope knows how to "tap its foot" to the beat of your music**

<iframe class="youtube-video" src="https://www.youtube.com/embed/g1X5JhoE_lc" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

**It's not a simple problem to solve. We take for granted just how easily our brains are able to quickly identify and synchronize our movements to the tempo of a song.** Here's how I approached genre-agnostic tempo detection and synchronization by "DFT'ing the DFT".

You can see the result of what I'm about to describe when Emotiscope is in Metronome Mode. The LEDs quickly synchronize themselves to the beat of a song, swaying patterns back and forth right on cue. It’s not only aware of what the current tempo (BPM, speed) of your music is, it also knows the magnitude of all common tempi at a given time and displays all predictions in parallel. For example, if the snare drum hits at 90 BPM but the hi-hat hits at 120 BPM, both patterns are detected and shown at the same time.

But how? By using 96 *MORE* instances of the Goertzel algorithm described above, for a total of 160 on every single audio frame. (100Hz)

Imagine this: First, an FFT is taken of the time-domain audio with a sliding window of the last 1024 samples, which yields a spectral response frame. Next, the spectral response is modified so that only the positive changes in spectral power since the last frame are present (Note/beat onsets), before summing up all frequency bins into a single value, the "spectral flux" of the given audio frame.

*(Hang in there, here's the cool part.)*

<iframe class="youtube-video" src="https://www.youtube.com/embed/_y0_qLfevxY" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

**Now we have a time-domain signal again where the amplitude is modulated by how much spectral change is occurring on each frame so that spectrally interesting "beats" like drums or rhythmic playing cause spikes, but sustained notes don't affect the signal.** The final step is to run the 96 leftover instances of the Goertzel algorithm on this (much lower sample rate) signal to detect the presence of different tempi in the currently playing music. Each Goertzel bin is tuned to a specific tempo between 60 and 156 BPM, (60 BPM == 1Hz) meaning the presence of music played at 80 BPM will cause a lone peak centered at the 80 BPM / 1.33 Hz bin!

Now that Emotiscope knows the magnitude/presence of all tempi in your music, it has to synchronize animations to it as well, which means tracking not only the rate of beats but their phase as well, to make the metronome animation look correct.

Luckily, this is quite easy, since our DFT calculations from Goertzel also yield phase information that tells exactly where we are in the time of one beat, returning one synchonized sine wave for every single tempi. This even works when two different songs are played over top of one another, since all possible tempi are tracked in parallel.

This results in robust real-time tempo detection that's genre agnostic and quick to react to changes. By the way - every single type of audio measurement Emotiscope *can* do is done on every single frame, regardless of what light mode is selected. So even when Metronome Mode isn't shown, all of this tempo tracking is still being done in the background on the CPU core so that if you decide to switch modes, measurements like the spectrum, tempi or auto-corellation are already accurate on the first frame.

------------------------------------------------

## The Remote Control

**An app built by a hardware designer to be fun, responive, and ergonomic.**

<iframe class="youtube-video" src="https://www.youtube.com/embed/SXX167ymKAM" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

You don’t need an account, there’s no ads, there’s no subscription. You can save it to your homescreen via the browser’s menu and it’ll get an icon just like a “real” app. Low-latency communication happens over a WS connection, while the underlying HTML/JS is stored and served from Emotiscope's filesystem. 

![EMOTISCOPE APP](https://raw.githubusercontent.com/connornishijima/connornishijima.github.io/main/img/remote_control.jpg)

-------------------------------------------------

## Magic Touch

**Just because!**

<iframe class="youtube-video" src="https://www.youtube.com/embed/5U7R8rfteFw" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

Many of Emotiscope's features are accesible without the app via touch on the top, left and right of the display. You can change modes with a tap on the top, hold to toggle Sleep Mode, or touch the sides to change color and toggle Mirror Mode.

Using intentionally oversized electrodes on the edges of the PCB, Emotiscope is not only sensitive to touch, but proximity as well! As your hand approaches a given side, the LEDs react proportionally to your distance. Upon contact, the visual feedback turns gold to confirm touches.

-------------------------------------------------

## Reversible Panels

**A logo you can hide!**

Beneath the display is a wooden panel of either Walnut or Bamboo, with the Emotiscope logo in the center. Both the wooden panel and the diffuser are reversible: The wood can be reversed to hide the logo, and the diffuser has either a matte side which is fingerprint resistant, or a classy gloss side with slightly higher contrast.

--------------------------------------------------

## 3D Printed Components

**Smooth, glittery, strong**

The plastic parts such as the feet and USB port cover are manufactured in-house with a Prusa Mini+ printer, in Galaxy Black PLA filament. They're designed to print quickly and without supports. I use a smooth print bed so that the faces of Emotiscope's feet are smooth to the touch.

--------------------------------------------------

## A Cushion Of Cork

**Thank me later**

Beneath Emotiscope's feet are laser-cut cork pads, which protect furniture from damage and provide a good grip on surfaces.

------------------------------------------------

![TOUCH](https://raw.githubusercontent.com/lixie-labs/emotiscope/main/extras/img/emotiscope_spectrum_crop.jpg?raw=true)