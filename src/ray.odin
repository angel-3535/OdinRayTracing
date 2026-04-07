package main
import math "core:math/linalg"

Ray :: struct {
	origin, direction: vec3,
}

point_at :: proc(ray: Ray, t: f64) -> point3 {
	return ray.origin + t * ray.direction
}

ray_color :: proc(ray: Ray) -> color {
	if hit_shpere(vec3{0, 0, -1}, 0.5, ray) {
		return color{1, 0, 0}
	}
	unit_dir := math.normalize(ray.direction)
	a := 0.5 * (unit_dir.g + 1.0)
	return ((1.0 - a) * color{1, 1, 1}) + (a * color{0.5, 0.7, 1.0})
}

hit_shpere :: proc(center: point3, radius: f64, r: Ray) -> bool {
	// t^2 * dot(d, d) - 2t dot(oc, d) + dot(oc, oc) - r^2 = 0
	oc := center - r.origin // vector from ray origin to sphere center
	a := math.dot(r.direction, r.direction)
	b := -2.0 * math.dot(r.direction, oc)
	c := math.dot(oc, oc) - radius * radius

	discriminant := b * b - 4 * a * c

	return discriminant > 0
}
