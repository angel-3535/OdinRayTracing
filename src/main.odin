package main

import "core:fmt"

main :: proc() {

	image_width, image_height :: 256, 256

	fmt.print("P3\n 256 256\n255\n")

	for h in 0 ..< image_height {
		for w in 0 ..< image_width {
			r: f64 = (cast(f64)w) / (image_width - 1)
			g: f64 = (cast(f64)h) / (image_height - 1)

			ir: int = cast(int)(255.999 * r)
			ig: int = cast(int)(255.999 * g)

			fmt.print(ir)
			fmt.print(" ")
			fmt.print(ig)
			fmt.print(" ")
			fmt.println(0)
		}

	}

}
