package main

import "core:c"
import "core:fmt"
import linalg "core:math/linalg"
import r "vendor:raylib"

to_ucolor_8 :: proc(pixel: color) -> ucolor_8 {
	return ucolor_8 {
		cast(u8)(255.999 * pixel.r),
		cast(u8)(255.999 * pixel.g),
		cast(u8)(255.999 * pixel.b),
	}

}


generate_image :: proc() {
	image_width := 400
	camera := global_scene.camera

	viewport_aspect_ratio := linalg.length(camera.horizontal) / linalg.length(camera.vertical)
	image_height := cast(int)(cast(f64)(image_width) / viewport_aspect_ratio)
	if image_height <= 0 {
		image_height = 1
	}
	image_size := image_width * image_height

	pixel_delta_u := camera.horizontal / cast(f64)(image_width)
	pixel_delta_v := -camera.vertical / cast(f64)(image_height)
	viewport_upper_left := camera.lower_left_corner + camera.vertical
	pixel_origin := viewport_upper_left + 0.5 * (pixel_delta_u + pixel_delta_v)

	//allocate memory for image data
	image_data := make([]ucolor_8, image_size)
	defer delete(image_data)

	for h in 0 ..< image_height {
		fmt.eprintf("\rScanlines remaining: %d ", image_height - h)
		for w in 0 ..< image_width {
			pixel_center :=
				pixel_origin + cast(f64)(w) * pixel_delta_u + cast(f64)(h) * pixel_delta_v
			ray_dir := pixel_center - camera.origin
			ray := Ray{camera.origin, ray_dir}
			//write ray color to image data
			image_data[h * image_width + w] = to_ucolor_8(ray_color(ray))
		}

	}

	image := r.Image{
		data = raw_data(image_data),
		width = c.int(image_width),
		height = c.int(image_height),
		mipmaps = 1,
		format = .UNCOMPRESSED_R8G8B8,
	}

	if !r.ExportImage(image, "output.png") {
		fmt.eprintln("Failed to export output.png")
		return
	}

	fmt.eprint("\rDone.                        \n")
}
