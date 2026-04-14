package main

import math "core:math"
import linalg "core:math/linalg"

Camera :: struct {
	origin:            point3,
	lower_left_corner: point3,
	horizontal:        vec3,
	vertical:          vec3,
}

Hit_Record :: struct {
	t:      f64,
	p:      point3,
	normal: vec3,
}

Hit_Proc :: proc(self: rawptr, ray: Ray, t_min, t_max: f64, rec: ^Hit_Record) -> bool

Hittable :: struct {
	self: rawptr,
	hit:  Hit_Proc,
}

Sphere :: struct {
	center: point3,
	radius: f64,
}

Scene :: struct {
	spheres: []Sphere,
	objects: []Hittable,
	camera:  Camera,
}

global_scene: Scene

make_sphere_hittable :: proc(sphere: ^Sphere) -> Hittable {
	return Hittable{self = sphere, hit = sphere_hit}
}

sphere_hit :: proc(self: rawptr, ray: Ray, t_min, t_max: f64, rec: ^Hit_Record) -> bool {
	sphere := cast(^Sphere)self

	oc := ray.origin - sphere.center
	a := linalg.dot(ray.direction, ray.direction)
	half_b := linalg.dot(oc, ray.direction)
	c := linalg.dot(oc, oc) - sphere.radius * sphere.radius

	discriminant := half_b * half_b - a * c
	if discriminant < 0 {
		return false
	}

	sqrt_discriminant := math.sqrt(discriminant)

	root := (-half_b - sqrt_discriminant) / a
	if root < t_min || root > t_max {
		root = (-half_b + sqrt_discriminant) / a
		if root < t_min || root > t_max {
			return false
		}
	}

	rec.t = root
	rec.p = point_at(ray, root)
	rec.normal = (rec.p - sphere.center) / sphere.radius
	return true
}

world_hit :: proc(scene: ^Scene, ray: Ray, t_min, t_max: f64, rec: ^Hit_Record) -> bool {
	hit_anything := false
	closest_so_far := t_max
	temp_record: Hit_Record

	for object in scene.objects {
		if object.hit(object.self, ray, t_min, closest_so_far, &temp_record) {
			hit_anything = true
			closest_so_far = temp_record.t
			rec^ = temp_record
		}
	}

	return hit_anything
}

init_scene :: proc() {
	if len(global_scene.spheres) > 0 {
		return
	}

	spheres := make([]Sphere, 2)
	spheres[0] = Sphere {
		center = point3{0, 0, -1},
		radius = 0.5,
	}
	spheres[1] = Sphere {
		center = point3{0, -100.5, -1},
		radius = 100,
	}

	objects := make([]Hittable, len(spheres))
	for i in 0 ..< len(spheres) {
		objects[i] = make_sphere_hittable(&spheres[i])
	}

	global_scene = Scene {
		spheres = spheres,
		objects = objects,
		camera = Camera {
			origin = point3{0, 0, 0},
			lower_left_corner = point3{-2.0, -1.0, -1.0},
			horizontal = vec3{4.0, 0.0, 0.0},
			vertical = vec3{0.0, 2.0, 0.0},
		},
	}
}

destroy_scene :: proc() {
	if len(global_scene.objects) > 0 {
		delete(global_scene.objects)
	}
	if len(global_scene.spheres) > 0 {
		delete(global_scene.spheres)
	}
	global_scene = {}
}
