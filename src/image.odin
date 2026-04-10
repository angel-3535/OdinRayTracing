package main

import "core:fmt"

to_ucolor_8 :: proc(pixel: color) -> ucolor_8 {
	return ucolor_8 {
		cast(u8)(255.999 * pixel.r),
		cast(u8)(255.999 * pixel.g),
		cast(u8)(255.999 * pixel.b),
	}
}
