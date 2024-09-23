---
title: Lixie
layout: page
nav_order: 6
---

![LIXIE DISPLAY](https://raw.githubusercontent.com/connornishijima/connornishijima.github.io/main/img/lixie.gif)

HARDWARE
{: .label }

ARDUINO LIBRARY
{: .label }

MANUFACTURING
{: .label }

CAD
{: .label }

LEDS
{: .label }

# **Lixie Displays (2016)**

#### LED NIXIE TUBES FREE OF RISK - [WEBSITE](https://hackaday.io/project/18633)

<br>
[Read The Arduino Library (C/C++)](https://github.com/connornishijima/Lixie-arduino){: .btn .btn-green }

--------------------------------------------

<blurb>I designed Lixie Displays because I couldn't afford Nixie Tubes. Development costed me much more than Nixie Tubes would have.</blurb>

--------------------------------------------

![LIXIE PCB](https://raw.githubusercontent.com/connornishijima/connornishijima.github.io/main/img/lixie_bokeh.jpg)

--------------------------------------------

<iframe class="youtube-video" src="https://www.youtube.com/embed/xxs3tj32z9A" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## Part Highlights

### WS2812B (x22)

- 5mm-sized 8-bit RGB Addressable LEDs

----------------------------------------------------------------

## Make It Make Sense

**Doesn't developing and building your own fake Nixie Tubes cost more than Nixie Tubes?**

A: Yes

I've always been a fan of the Nixie Tube. Beautiful typography, endearing glow, and very clever technology. But when commercial production stopped in the 1990s, prices for surplus Nixie Tubes began to rise. Smaller tubes like the IN-16 are still only about $3.50/piece, but bigger and more desirable tubes like the IN-18 can run up to $45/piece. If you wanted to make a 6-digit clock, it can cost up to $270 just for the tubes!

![NIXIE TUBE CALCULATOR](https://raw.githubusercontent.com/connornishijima/connornishijima.github.io/main/img/nixie_calculator.jpg)

That's not to mention the potential danger of having 170VDC around children and pets, the risk that they might "burn out" next week, and that they need special switching circuitry.

----------------------------------------------------------------

![EDGE LIT DISPLAY](https://raw.githubusercontent.com/connornishijima/connornishijima.github.io/main/img/edge_lit_display.jpg)

## Back From The Dead

**Based on 1950s tech, Lixie borrows its techniques**

Edge-lighting panes of acrylic etched with a design has been done for decades, but they've always been static information like an "EXIT" sign. If you stack multiple panes of acrylic (each with a unique design) and light them individually, you can change what design the user sees! This is what the old NLS displays in the above photo do - Lixies are just a modernized take with addressable LEDs.

Lixie displays have extremely simple setup: just connect the 5V, GND, and DIN pads to an Arduino and use the Lixie library to write a digit to the display. That's it! No HV switching, PCB footprint, or worries.

Since the Lixie is just wired like a WS2812B strip, you can connect the DOUT pin of one to the next and show a number as long you'd like!

