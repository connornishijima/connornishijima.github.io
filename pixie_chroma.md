---
title: Pixie Chroma
layout: page
parent: Products
nav_order: 3
---

<iframe class="youtube-video" src="https://www.youtube.com/embed/don7XKYEpeE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

# Pixie Chroma

#### Colorful Displays For Those In A Damn Hurry

--------------------------------------------

I designed Pixie Chroma to enable both beginners and professionals to quickly deploy alphanumeric LEDs displays using an intuitive Arduino Library and only 3 wires.

--------------------------------------------

## Part Highlights

### SK6805-EC15 (x70)

- 1.5mm-sized 8-bit RGB Addressable LEDs

----------------------------------------------------------------

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

## Fast Lookups with Mark Bytes

Pixie Chroma allows users to add raster icons to their projects with special writing inside of C strings, like this:

```c
    pix.print("You have a nice [:SMILE:]");
```

These are called "Shortcodes", and over 200 of them are included with the Pixie Chroma library.

Whenever pix.print() is called, the input is checked for shortcodes by looking for the `[:` and `:]` markers.

When found, the name between the markers is used to traverse a lookup table for the correct bitmap data:

```c
static const uint8_t PIXIE_SHORTCODE_LIBRARY[] = {
// SHORTCODE           COLUMN DATA               MARK  NAME                TERMINATOR
/* [:HEART:]        */ 0x0C,0x12,0x24,0x12,0x0C, 212, 'H','E','A','R','T', 0,
/* [:SAD:]          */ 0x44,0x26,0x20,0x26,0x44, 210, 'S','A','D', 0,
/* [:HAPPY:]        */ 0x16,0x22,0x20,0x22,0x16, 212, 'H','A','P','P','Y', 0,
/* [:ANGRY:]        */ 0x49,0x2A,0x20,0x2A,0x49, 212, 'A','N','G','R','Y', 0,
/* [:SMILE:]        */ 0x10,0x26,0x20,0x26,0x10, 212, 'S','M','I','L','E', 0,
/* [:FROWN:]        */ 0x20,0x16,0x10,0x16,0x20, 212, 'F','R','O','W','N', 0,
/* [:NO:]           */ 0x1C,0x32,0x2A,0x26,0x1C, 209, 'N','O', 0,
/* [:MAIL:]         */ 0x3E,0x26,0x2A,0x26,0x3E, 211, 'M','A','I','L', 0,
/* [:PHONE_CALL:]   */ 0x00,0x63,0x77,0x3E,0x00, 217, 'P','H','O','N','E','_','C','A','L','L', 0,
/* [:WIRELESS:]     */ 0x12,0x49,0x69,0x49,0x12, 215, 'W','I','R','E','L','E','S','S', 0,
/* [:FAIL:]         */ 0x22,0x14,0x08,0x14,0x22, 211, 'F','A','I','L', 0,
/* [:PASS:]         */ 0x10,0x20,0x10,0x08,0x04, 211, 'P','A','S','S', 0,
```

This table employs a simple trick to increase access speed: **mark bytes**. To find the raster data for the shortcode `[:SMILE:]`, do the following:

- Start at the first mark byte, at index 5.
- Peek at the following byte, compare to the "SMILE" shortcode name ('H' != 'S')
- Since not equal, skip MARK-200 bytes forward in the array (Next mark byte is 12 steps forward)
- Peek at following byte again
- This time, an "S" was correctly found
- Peek one more index forward to the second character
- 'A' != 'M' ("SAD" != "SMILE")
- Since not equal, skip MARK-200 bytes forward in the array (Next mark byte)
- This continues until both "SMILE" and the NULL terminator are found
- The five bytes proceeding the MARK byte of the found Shortcode contain the raster data to return

This lookup saves memory by storing all shortcodes in variable-length space, while still allowing for fast traversal to get results in microseconds.

While I've nicely formatted the shortcode lookup table, the microcontroller only sees it as a large 1D array, like this:

```c
static const uint8_t PIXIE_SHORTCODE_LIBRARY[] = { 
//  ----- RASTER ------ MARK H   E   A   R   T   0  ----- RASTER ------ MARK S   A   D   0
    12, 18, 36, 18, 12, 212, 72, 69, 65, 82, 84, 0, 68, 38, 32, 38, 68, 210, 83, 65, 68, 0,  ...
}
```
