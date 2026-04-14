package main
import linalg "core:math/linalg"

Ray :: struct {
	origin, direction: vec3,
}

point_at :: proc(ray: Ray, t: f64) -> point3 {
	return ray.origin + t * ray.direction
}

ray_color :: proc(ray: Ray) -> color {
	record: Hit_Record
	if world_hit(&global_scene, ray, 0.001, 1e30, &record) {
		return 0.5 * color{record.normal[0] + 1.0, record.normal[1] + 1.0, record.normal[2] + 1.0}
	}
	unit_dir := linalg.normalize(ray.direction)
	a := 0.5 * (unit_dir.g + 1.0)
	return ((1.0 - a) * color{1, 1, 1}) + (a * color{0.5, 0.7, 1.0})
}
