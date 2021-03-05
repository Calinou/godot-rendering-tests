extends Node

# Array of strings with scene file names (no extension).
var test_scenes := []

func _ready() -> void:
	var dir := Directory.new()
	if dir.open("res://tests/3d") == OK:
		dir.list_dir_begin(true)
		var file_name := dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".tscn"):
				test_scenes.push_back(file_name.trim_suffix(".tscn"))

			file_name = dir.get_next()

		print("Found %d 3D test scenes in the `tests/3d` folder." % test_scenes.size())
	else:
		push_error("An error occurred when trying to access res://tests/3d.")

	dir.make_dir_recursive("res://results/3d")

	for test_scene in test_scenes:
		print("Loading 3D test scene: %s" % test_scene)
		var test: Node = load("res://tests/%s.tscn" % test_scene).instance()
		add_child(test)

		# FIXME: Take screenshots of every scene.

		var viewport := get_viewport()

		#viewport.set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
		var image := viewport.get_texture().get_data()

		#viewport.set_clear_mode(Viewport.CLEAR_MODE_ALWAYS)

		# Screenshot file name with ISO 8601-like date
		var datetime := OS.get_datetime()
		for key in datetime:
			datetime[key] = str(datetime[key]).pad_zeros(2)

		var error := image.save_png("res://results/3d/%s.png" % test_scene)
		if error != OK:
			push_error("Couldn't save screenshot.")

		test.queue_free()
