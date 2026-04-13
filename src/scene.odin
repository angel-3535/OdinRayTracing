package main

camera :: struct {
	origin:            point3,
	lower_left_corner: point3,
	horizontal:        vec3,
	vertical:          vec3,
}

scene :: struct {
	spheres: []sphere,
}

sphere :: struct {
	center: point3,
	radius: f64,
}
