package main


main :: proc() {
	init_editor()
	defer destroy_editor()
	editor_loop()

}
