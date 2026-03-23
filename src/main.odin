package main

import "core:fmt"
import "core:math/linalg"

vec3 :: [3]f64
color_n :: [3]f64

main :: proc() {

	image_width, image_height :: 256, 256

	fmt.print("P3\n 256 256\n255\n")
	for h in 0 ..< image_height {
		fmt.eprintf("\rScanlines remaining: %d ", image_height - h)
		for w in 0 ..< image_width {
			color: color_n = color_n {
				(cast(f64)w) / (image_width - 1),
				(cast(f64)h) / (image_height - 1),
				0,
			}
			write_color(color)
		}

	}

	fmt.eprint("\rDone.                        \n")

}

write_color :: proc(pixel: color_n) {
	//translate pixel color from [0,1] range into [0,255]
	r: int = cast(int)(255.999 * pixel.r)
	g: int = cast(int)(255.999 * pixel.g)
	b: int = cast(int)(255.999 * pixel.b)
	fmt.printf("%d %d %d\n", r, g, b)
}
