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

I designed Pixie Chroma to enable both beginners and professionals to quickly deploy alphanumeric LEDs displays using an intuitive Arduino Library and only 3 wires.

--------------------------------------------

## Intuitive Arduino Library

The Pixie Chroma Arduino Library comes with many examples explained line-by-line so that anybody can understand them. I also include template Arduino Sketches to skip the parts newcomers find tedious, like #include directives and class definitions.

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

--------------------------------------------------

![Shortcodes Demo](https://github.com/connornishijima/Pixie_Chroma/blob/main/extras/img/shortcodes.jpg?raw=true)

## Fast String Parsing

```c
    pix.print("You have a nice [:SMILE:]!");
```

```c
static const uint8_t PIXIE_SHORTCODE_LIBRARY[] = {
// SHORTCODE           COLUMN DATA               MARK  NAME                TERMINATOR
/* [:HEART:]        */ 0x0C,0x12,0x24,0x12,0x0C, 212, 'H','E','A','R','T', 0,
/* [:SMILE:]        */ 0x10,0x26,0x20,0x26,0x10, 212, 'S','M','I','L','E', 0,
/* [:FROWN:]        */ 0x20,0x16,0x10,0x16,0x20, 212, 'F','R','O','W','N', 0,
/* [:HAPPY:]        */ 0x16,0x22,0x20,0x22,0x16, 212, 'H','A','P','P','Y', 0,
/* [:SAD:]          */ 0x44,0x26,0x20,0x26,0x44, 210, 'S','A','D', 0,
/* [:ANGRY:]        */ 0x49,0x2A,0x20,0x2A,0x49, 212, 'A','N','G','R','Y', 0,
/* [:NO:]           */ 0x1C,0x32,0x2A,0x26,0x1C, 209, 'N','O', 0,
/* [:MAIL:]         */ 0x3E,0x26,0x2A,0x26,0x3E, 211, 'M','A','I','L', 0,
/* [:PHONE_CALL:]   */ 0x00,0x63,0x77,0x3E,0x00, 217, 'P','H','O','N','E','_','C','A','L','L', 0,
/* [:WIRELESS:]     */ 0x12,0x49,0x69,0x49,0x12, 215, 'W','I','R','E','L','E','S','S', 0,
/* [:FAIL:]         */ 0x22,0x14,0x08,0x14,0x22, 211, 'F','A','I','L', 0,
/* [:PASS:]         */ 0x10,0x20,0x10,0x08,0x04, 211, 'P','A','S','S', 0,
```

## Only As Powerful As You Need



```c
static float iter = 0;  
float x = (((sin(iter*0.111)+1)/2.0)*0.75)+0.125; // This generates UV coordinates
float y = (((cos(iter*0.234)+1)/2.0)*0.50)+0.250; // that smoothly drift around over time
iter+=0.25;

pix.dim(8); // ...................... Fade the mask by 8/256ths
pix.mask[ pix.uv(x,y) ] = 255; // ... Show the drifting dot with UV coords
pix.show(); // ...................... Send the updated image to the Pixies
```