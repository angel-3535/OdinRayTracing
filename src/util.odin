package main


import "core:fmt"

point3 :: [3]f64
vec3 :: [3]f64
color :: [3]f64
icolor :: [3]int


write_ppm_header :: proc(width: int, height: int) {
	fmt.printf("P3\n%d %d\n255\n", width, height)
}

write_color :: proc(pixel: color) {
	//translate pixel color from [0,1] range into [0,255]
	res: icolor = {
		cast(int)(255.999 * pixel.r),
		cast(int)(255.999 * pixel.g),
		cast(int)(255.999 * pixel.b),
	}
	fmt.printf("%d %d %d\n", res.r, res.g, res.b)
}
