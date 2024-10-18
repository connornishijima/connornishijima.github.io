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

Now that I'd proved the ultra fast refresh rates and vector font method were possible, I wanted to design the communication method used to control each display.

<iframe class="youtube-video" src="https://www.youtube.com/embed/l5XtuTuHbco" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

----------------------------------------

## A UART chain

A *what?* It's a strange method, but Super Pixie chains UART ports together to operate instead of a more common method like SPI or I2C. It's stil very performant, but has some distict advantages of its own:

### SPI

- Fast AF
- Uses three GPIO
- Addressed with one extra GPIO per device (ehh)

### I2C

- Relatively slower, still plenty fast
- Not self-addressing
- Impossible to automatically discover physical device order

### UART CHAIN

- Whatever maximum common baud rate is possible for all devices in the chain (fast enough for my application)
- Self-addressing
- Uses only two GPIO for the whole chain
- Works out of box on any microcontroller with a UART or SoftSerial

Super Pixies inherently exist in a physical position relative to one another that must be known when showing data so that the chain correctly reads "hello world" and not "doll howler". The easier answer would be to just shift ASCII data down the line until latching it, but Super Pixies are a little more involved. They support custom vectors, different transitions, any color combo you want, a backlight, etc..

To handle this complexity, Super Pixies instead send tiny packets back and forth, which contain descriptors about their purpose and content. Instead of shifting "A" directly to a display, you'd send a packet telling the Super Pixie at that position to begin a transition to a the vector of "A" already stored in its flash. It's a few bytes extra, but the overhead is worth the flexibility.

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

Once the chain is established, the MAIN controller can individually command any single unit by sending data to their physical address. Below was my very first UART chain, where an ESP8266 is commanding three ESP32s to blink their LEDs in sequence.

<iframe class="youtube-video" src="https://www.youtube.com/embed/ak5L2RLOQnI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

------------------------------------

## A much, much smaller prototype

While designing the UART chain method, I repurposed my own [Pixie Chroma](https://connor.nishiji.ma/products/pixie_chroma) boards as debug displays, showing dots of various colors to indicate things like "is propagation enabled" or displaying their assigned addresses.

Originally, Super Pixie was meant to have an 8x16 display, but I had a weird realization: two Pixie Chroma PCBs make up a strangely spaced but *TINY* 7x15 matrix with some leftover LEDs below for debugging. Since I wrote the whole system around vectors instead of rasters, I just updated a few variables and suddenly my Pixie Chromas functioned as tiny Super Pixie displays, just with one less row and column.

I'd lost the high refresh rates since it was now 140 pixels on a single GPIO instead of 16 pixels on 8 (>8x slower) but that still resulted in 235 FPS. Now I was able to prototype both the rasterization code *and* the UART chain code in a single device.

<iframe class="youtube-video" src="https://www.youtube.com/embed/0Y3tDgQeQdY" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

----------------------------------

## Fancy transitions are here

Remember the scaling and rotation? Now I had them working along with self-addressing, so that you can send a single packet down the line with a number to show, and each Super Pixie will decide whether or not to flip to a new character onscreen.

<iframe class="youtube-video" src="https://www.youtube.com/embed/3vnzpUjgBBc" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

----------------------------------

## Very satisfying to watch

I always love watching odometers turn past 9, or digital clocks change to midnight. I made sure that anyone else as weird as myself gets a good show:

<iframe class="youtube-video" src="https://www.youtube.com/embed/thfjp7ciXKs" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

--------------------------------

## How about a hundred more characters?

A hundred more charcters? What is this, The Simpsons?

(I added the full printable ASCII charset)

<iframe class="youtube-video" src="https://www.youtube.com/embed/lD4lZDL1xP8" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

-------------------------------

## Further optimization

I was able to identify and reduce errors that caused chain de-sync or jitter. Now they even perform perfectly in slow motion:

<iframe class="youtube-video" src="https://www.youtube.com/embed/jBIulcIhz4c" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

-------------------------------

## Self-healing chain

If anything goes wrong with a given Super Pixie, the Watchdog Timer resets it. This causes it to lose an address, which can break comms. When this happens anywhere in the chain the MAIN controller will no longer recieve its own data back in time, causing it to quickly reset and reassign the chain units.

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