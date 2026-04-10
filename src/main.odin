package main

import "core:c"
import "core:fmt"
import "vendor:stb/image"


main :: proc() {


	ASPECT_RATIO :: 16.0 / 9.0
	IMAGE_WIDTH :: 400
	img_height_calc :: cast(int)(cast(f64)IMAGE_WIDTH / ASPECT_RATIO)
	IMAGE_HEIGHT :: img_height_calc when img_height_calc > 0 else 1
	IMAGE_SIZE :: IMAGE_WIDTH * IMAGE_HEIGHT

	// Camera parameters
	//VP = VIEWPORT
	FOCAL_LENGTH :: 1.0
	VP_HEIGHT :: 2.0
	VP_WIDTH :: VP_HEIGHT * (cast(f64)IMAGE_WIDTH / cast(f64)IMAGE_HEIGHT)
	CAMERA_CENTER :: point3{0, 0, 0}

	VP_U :: vec3{VP_WIDTH, 0, 0}
	VP_V :: vec3{0, -VP_HEIGHT, 0}

	PIXEL_DELTA_U := VP_U / cast(f64)(IMAGE_WIDTH)
	PIXEL_DELTA_V := VP_V / cast(f64)(IMAGE_HEIGHT)

	VP_UPPER_LEFT := CAMERA_CENTER - vec3{0, 0, FOCAL_LENGTH} - VP_U / 2 - VP_V / 2
	PIXEL_ORIGIN := VP_UPPER_LEFT + 0.5 * (PIXEL_DELTA_U + PIXEL_DELTA_V)

	//allocate memory for image data
	image_data := make([]ucolor_8, IMAGE_SIZE)
	defer delete(image_data)

	for h in 0 ..< IMAGE_HEIGHT {
		fmt.eprintf("\rScanlines remaining: %d ", IMAGE_HEIGHT - h)
		for w in 0 ..< IMAGE_WIDTH {
			pixel_center :=
				PIXEL_ORIGIN + cast(f64)(w) * PIXEL_DELTA_U + cast(f64)(h) * PIXEL_DELTA_V
			ray_dir := pixel_center - CAMERA_CENTER
			ray := Ray{CAMERA_CENTER, ray_dir}
			//write ray color to image data
			image_data[h * IMAGE_WIDTH + w] = to_ucolor_8(ray_color(ray))
		}

	}

	image.write_png(
		"output.png",
		c.int(IMAGE_WIDTH),
		c.int(IMAGE_HEIGHT),
		3,
		raw_data(image_data),
		c.int(IMAGE_WIDTH * size_of(ucolor_8)),
	)

	fmt.eprint("\rDone.                        \n")

}
