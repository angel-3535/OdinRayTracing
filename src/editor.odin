package main

import "core:fmt"
import imgui "../vendor/odin-imgui"

render_editor :: proc() {
	if imgui.Begin("Editor") {
		imgui.Text("Hello from Dear ImGui.")

		if imgui.Button("Print Hello") {
			fmt.println("hello world")
		}
	}
	imgui.End()
}
