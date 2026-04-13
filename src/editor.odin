package main

import imgui "../vendor/odin-imgui"
import "core:fmt"

render_editor :: proc() {
	imgui.DockSpaceOverViewport()

	if imgui.Begin("Editor") {
		imgui.Text("Hello from Dear ImGui.")

		if imgui.Button("Print Hello") {
			fmt.println("hello world")
		}
	}
	imgui.End()
}
