package main

import imgui_rl "../imgui_impl_raylib"
import imgui "../vendor/odin-imgui"
import "core:fmt"
import r "vendor:raylib"

main :: proc() {
	r.SetConfigFlags({.WINDOW_RESIZABLE, .MSAA_4X_HINT})
	r.InitWindow(800, 600, "Odin Ray Tracer")
	defer r.CloseWindow()
	r.SetTargetFPS(60)

	imgui.CreateContext()
	defer imgui.DestroyContext()

	imgui_rl.init()
	defer imgui_rl.shutdown()

	if err := imgui_rl.build_font_atlas(); err != nil {
		fmt.eprintf("failed to build Dear ImGui font atlas: %v\n", err)
		return
	}

	for !r.WindowShouldClose() {
		imgui_rl.process_events()
		imgui_rl.new_frame()
		imgui.NewFrame()

		render_editor()

		r.BeginDrawing()
		r.ClearBackground(r.RAYWHITE)

		imgui.Render()
		imgui_rl.render_draw_data(imgui.GetDrawData())

		r.EndDrawing()
	}
}
