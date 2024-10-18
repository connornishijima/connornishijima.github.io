---
title: Super Pixie
layout: page
nav_order: 20
---

<video class="youtube-video-square" autoplay loop muted>
    <source src="https://github.com/connornishijima/connornishijima.github.io/blob/main/img/SUPER_PIXIE_LOOP.mp4?raw=true" type="video/mp4">
    Your browser does not support the video tag.
</video>

HARDWARE
{: .label }

FIRMWARE
{: .label }

OPTIMIZATION
{: .label }

COMMUNICATION
{: .label }

MANUFACTURING
{: .label }

# **Super Pixie (Unreleased)**

#### A Music Visualizer From The Future - [emotiscope.rocks](https://emotiscope.rocks)

<br>
[Read The UNFINISHED Firmwware (C/C++)](https://github.com/connornishijima/SuperPixie_Firmware){: .btn .btn-green }

--------------------------------------------

<blurb>Super Pixie uses 106 RGB LEDs to display a full alphanumeric character set using vector graphics, allowing for advanced animation controlled over UART.</blurb>

--------------------------------------------

## First, a massive prototype

Made from cut sections of 60 LED/meter strips, the original prototype stood about a foot tall, and featured 8 independent lines of 16 addressable LEDs. Having only 16 LEDs per line and driving each in parallel allows for frame rates well above 1,000 FPS:

$ \text{Time per LED} = \frac{24 \text{ bits}}{800,000 \text{ bits per second}} = 0.00003 \text{ seconds} = 30 \text{ µs} $

$ \text{Time for 16 LEDs} = 30 µs × 16 + 50\text{ us (latch)} = 530\text{ µs} $

$ \text{Maximum refresh rate} = \frac{1\text{ second}}{530\text{ µs}} = 1,886\text{ Hz} $

Of course, that doesn't quite account for overhead in the actual C++ rendering process before data is tranmitted to the LEDs, but I still achieved >600 FPS in practice.

<iframe class="youtube-video" src="https://www.youtube.com/embed/GBwgY8yKXiw" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

-------------------------------------------

## Next, a fast line rasterizer

Using a slightly modified Xiolin Wu line algorithm which can draw lines less than 1px in length or width, I convert vector font data in memory to an 8x16 raster image with anti-aliasing and subpixel positioning. Applying a position, scale, and rotation to a vector image is much simpler work than rotating the equivalent raster image, so very early on I had everything necessary for fancy animations and transitions.

<iframe class="youtube-video" src="https://www.youtube.com/embed/l5XtuTuHbco" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

----------------------------------------

## A UART chain

A *what?* It's a strange method, but Super Pixie chains UART ports together to operate instead of a more common method like SPI or I2C. It's stil very performant, but has some distict advantages of its own:

### SPI

- Fast AF
- Addressed with one extra GPIO per device

### I2C

- Relatively slower, still plenty fast
- Not self-addressing

### UART CHAIN

- Whatever maximum common baud rate is possible for all devices in the chain (fast enough for my application)
- Self-addressing
- Uses only two GPIO

Super Pixies inherently exist in a physical position relative to one another that must be known when showing data so that the chain correctly reads "HELLO WORLD" and not "EHLLOLD WOR". The easier answer would be to just shift ASCII data down the line until latching it, but Super Pixies are a little more involved. They support custom vectors, different transitions, any color combo you want, a backlight, etc..

To handle this complexity, Super Pixies instead send packets back and forth, which contain descriptors about their purpose and content. Instead of shifting "A" directly to a display, you'd send a packet telling the Super Pixie at that position to begin a transition to a the vector of "A" already stored in its flash.

To make them self-addressing, the following sequence runs at boot:

```
USER CONTROLLER   ------------- SUPER PIXIES -------------

+--------+        +--------+     +--------+     +--------+
| MAIN   |        | PIX 1  |     | PIX 2  |     | PIX 3  |
|        |        |        |     |        |     |        |
| RX  TX + -----> + RX  TX + --> + RX  TX + --> + RX  TX |
+-+------+        +--------+     +--------+     +-----+--+
  ^                                                   |
  |                  <--- RETURN LINE                 |
  +---------------------------------------------------+
```

1.  MAIN sends an ASSIGN ADDRESS 1 packet @ BROADCAST
2.  PIX 1 receives this, assigns itself Address 1 (instead of default ADDRESS NULL)
3.  PIX 1 enables propagation, so that future bytes received are passed
4.  PIX 2 heard nothing yet
6.  MAIN sends an ASSIGN ADDRESS 2 packet @ BROADCAST
7.  PIX 1 ignores this (already assigned) PIX 2 has address assigned instead
8.  PIX 2 enables propagation
9.  This repeats until MAIN tries to assign a fourth address
10. There are only three devices, so this packet will fully loop back to MAIN
11. MAIN can't have it's address assigned (Permanent address of 0)
12. MAIN now knows there are three devices in the chain based on final address assignment which failed.

<iframe class="youtube-video" src="https://www.youtube.com/embed/ak5L2RLOQnI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

<iframe class="youtube-video" src="https://www.youtube.com/embed/0Y3tDgQeQdY" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

<iframe class="youtube-video" src="https://www.youtube.com/embed/3vnzpUjgBBc" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

<iframe class="youtube-video" src="https://www.youtube.com/embed/jBIulcIhz4c" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

<iframe class="youtube-video" src="https://www.youtube.com/embed/thfjp7ciXKs" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

<iframe class="youtube-video" src="https://www.youtube.com/embed/lD4lZDL1xP8" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

<iframe class="youtube-video" src="https://www.youtube.com/embed/p2QuIIpAoNE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

<iframe class="youtube-video" src="https://www.youtube.com/embed/wCqaJwUP8xE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

<iframe class="youtube-video" src="https://www.youtube.com/embed/f_DHSDJ2pIw" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

<iframe class="youtube-video" src="https://www.youtube.com/embed/3njWHFEFoPU" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

<iframe class="youtube-video" src="https://www.youtube.com/embed/PovRhiiv5b4" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

<iframe class="youtube-video" src="https://www.youtube.com/embed/nzu5DMInnug" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

<iframe class="youtube-video" src="https://www.youtube.com/embed/l4IxuRk5HS4" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

<iframe class="youtube-video" src="https://www.youtube.com/embed/0ouJRyu9kiI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

<iframe class="youtube-video" src="https://www.youtube.com/embed/MPFbY3znW9g" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

<iframe class="youtube-video" src="https://www.youtube.com/embed/XyW8tD2Pya8" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

<iframe class="youtube-video" src="https://www.youtube.com/embed/LZ80oJQVAvI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

<iframe class="youtube-video" src="https://www.youtube.com/embed/yx8r4_NiK18" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

<iframe class="youtube-video" src="https://www.youtube.com/embed/NeikLcG1wB8" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

<iframe class="youtube-video" src="https://www.youtube.com/embed/9_M6Tm0tjPU" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

<iframe class="youtube-video" src="https://www.youtube.com/embed/N0bAmDYofUo" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

<iframe class="youtube-video" src="https://www.youtube.com/embed/yZ-X6IcTUL0" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

<iframe class="youtube-video" src="https://www.youtube.com/embed/PQjJ37oHWAw" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

<iframe class="youtube-video" src="https://www.youtube.com/embed/tP_2r-4zSM4" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

<iframe class="youtube-video" src="https://www.youtube.com/embed/c5vi9gRcNQU" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

<iframe class="youtube-video" src="https://www.youtube.com/embed/GSsp4AB_fw8" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>