package main

import r "vendor:raylib"

main :: proc() {
	r.InitWindow(800, 600, "Odin Ray Tracer")

	for !r.WindowShouldClose() {
		r.BeginDrawing()
		r.ClearBackground(r.RAYWHITE)

		r.DrawText("TEST!", 190, 200, 20, r.MAROON)

		r.EndDrawing()
	}


	generate_image()
}
