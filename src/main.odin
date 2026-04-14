package main


main :: proc() {
	init_scene()
	defer destroy_scene()

	init_editor()
	defer destroy_editor()
	editor_loop()

}
