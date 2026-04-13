package main

point3 :: [3]f64
vec3 :: [3]f64
vec2 :: [2]f64
uvec2 :: [2]u32
fvec2 :: [2]f32
color :: [3]f64
icolor :: [3]int

ucolor_8 :: [3]u8


print_vec :: proc(v: $T/[$N]$E) {
	fmt.print("[")
	for i in 0 ..< N {
		if i > 0 do fmt.print(", ")
		fmt.print(v[i])
	}
	fmt.println("]")
}
