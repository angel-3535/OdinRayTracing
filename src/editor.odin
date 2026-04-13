package main

import imgui_rl "../imgui_impl_raylib"
import imgui "../vendor/odin-imgui"
import "core:fmt"
import r "vendor:raylib"

WINDOW_TITLE :: "Odin Ray Tracer - Editor"
WINDOW_WIDTH :: 1280
WINDOW_HEIGHT :: 720

SCENE_WINDOW_TITLE :: "Editor"
VIEWPORT_WINDOW_TITLE :: "Viewport"
EDITOR_DOCKSPACE_ID :: "EditorDockSpace"


init_editor :: proc() {
	r.SetConfigFlags({.WINDOW_RESIZABLE, .MSAA_4X_HINT})
	r.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_TITLE)
	r.SetTargetFPS(60)

	imgui.CreateContext()

	io := imgui.GetIO()
	io.ConfigFlags |= {.DockingEnable}

	imgui_rl.init()

	if err := imgui_rl.build_font_atlas(); err != nil {
		fmt.eprintf("failed to build Dear ImGui font atlas: %v\n", err)
		return
	}
}
destroy_editor :: proc() {
	//dont change order
	imgui_rl.shutdown()
	imgui.DestroyContext()
	r.CloseWindow()
}

editor_loop :: proc() {
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

@(private)
initialize_editor_layout :: proc(dockspace_id: imgui.ID) {

	// init docking layout
	fmt.printfln("initializing editor layout")
	work_pos: fvec2 = imgui.GetMainViewport().WorkPos
	work_size: fvec2 = imgui.GetMainViewport().WorkSize
	defer imgui.DockBuilderFinish(dockspace_id)

	imgui.DockBuilderRemoveNodeDockedWindows(dockspace_id)
	imgui.DockBuilderRemoveNodeChildNodes(dockspace_id)
	imgui.DockBuilderSetNodeSize(dockspace_id, work_size)
	imgui.DockBuilderSetNodePos(dockspace_id, work_pos)

	main_dock_id := dockspace_id
	scene_dock_id := imgui.DockBuilderSplitNode(main_dock_id, .Left, 0.15, nil, &main_dock_id)
	imgui.DockBuilderDockWindow(SCENE_WINDOW_TITLE, scene_dock_id)
	imgui.DockBuilderDockWindow(VIEWPORT_WINDOW_TITLE, main_dock_id)

}

first_render := true
render_editor :: proc() {
	dockspace_id := imgui.GetID(EDITOR_DOCKSPACE_ID)
	imgui.DockSpaceOverViewport(dockspace_id)

	if first_render {
		initialize_editor_layout(dockspace_id)
		first_render = false
	}

	if imgui.Begin(VIEWPORT_WINDOW_TITLE) {
		imgui.Text("Hello from Dear ImGui.")
	}
	imgui.End()

	if imgui.Begin(SCENE_WINDOW_TITLE) {
		imgui.Text("Hello from Dear ImGui.")

		if imgui.Button("Print Hello") {
			fmt.println("hello world")
		}
	}
	imgui.End()
}
