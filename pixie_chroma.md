---
title: Pixie Chroma
layout: page
parent: Products
nav_order: 3
---

<iframe class="youtube-video" src="https://www.youtube.com/embed/don7XKYEpeE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

# Pixie Chroma

#### My Most Colorful Display

--------------------------------------------

I designed Pixie Chroma to enable both beginners and professionals to quickly deploy alpha-numeric displays using an intuitive Arduino Library.

--------------------------------------------

```c
#include "Pixie_Chroma.h" // Include library
PixieChroma pix;
#define PIXIES_X  6  // Total amount and         x x x x x x
#define PIXIES_Y  2  // arrangement of Pixies =  x x x x x x

void setup() {
  pix.begin( 13, PIXIES_X, PIXIES_Y ); // ... Use Pin 13
  pix.color( CRGB::Blue ); // ............... Set color to blue
}

void loop() {
  pix.clear(); // ..................... Clear display
  pix.println( "Hello World!" ); // ... Write text on first row
  pix.print( millis() ); // ........... Write the value of millis() on the second row
  pix.show(); // ...................... Show changes
}
```