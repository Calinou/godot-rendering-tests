extends Node

# Arrays of strings with scene file names (no extension).
var test_scenes_3d := []
var test_scenes_2d := []


func _ready() -> void:
	var dir := Directory.new()
	dir.make_dir_recursive("res://results/2d")
	dir.make_dir_recursive("res://results/3d")
	
	# Run 2D scenes.
	if dir.open("res://tests/2d") == OK:
		dir.list_dir_begin(true)
		var file_name := dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".tscn"):
				test_scenes_2d.push_back(file_name.trim_suffix(".tscn"))

			file_name = dir.get_next()

		# Results may not be sorted alphabetically, so ensure this to improve determinism.
		test_scenes_2d.sort()
		print("Found %d 2D test scenes in the `tests/2d` folder." % test_scenes_2d.size())
	else:
		push_error("An error occurred when trying to access res://tests/2d.")

	for test_scene in test_scenes_2d:
		print("Loading 2D test scene: %s" % test_scene)
		var test: Node = load("res://tests/2d/%s.tscn" % test_scene).instantiate()
		add_child(test)

		await take_screenshot("res://results/2d/%s.png" % test_scene)

		test.queue_free()
	
	dir = Directory.new()
	
	# Run 3D scenes.
	if dir.open("res://tests/3d") == OK:
		dir.list_dir_begin(true)
		var file_name := dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".tscn"):
				test_scenes_3d.push_back(file_name.trim_suffix(".tscn"))

			file_name = dir.get_next()

		# Results may not be sorted alphabetically, so ensure this to improve determinism.
		test_scenes_3d.sort()
		print("Found %d 3D test scenes in the `tests/3d` folder." % test_scenes_3d.size())
	else:
		push_error("An error occurred when trying to access res://tests/3d.")

	for test_scene in test_scenes_3d:
		print("Loading 3D test scene: %s" % test_scene)
		var test: Node = load("res://tests/3d/%s.tscn" % test_scene).instantiate()
		add_child(test)

		await take_screenshot("res://results/3d/%s.png" % test_scene)

		test.queue_free()
	
	# Done saving all images. Nothing more to do.
	get_tree().quit()


func take_screenshot(output_path: String) -> void:
	var viewport := get_viewport()
	
	# Wait some frames to get an up-to-date screenshot.
	await get_tree().process_frame

	# FIXME: Changing the render target clear mode is not needed anymore?
	#viewport.render_target_clear_mode = SubViewport.CLEAR_MODE_ONCE
	var image: Image = viewport.get_texture().get_image()
	#viewport.render_target_clear_mode = SubViewport.CLEAR_MODE_ALWAYS
	
	print("Saving screenshot: %s" % output_path)
	image.save_png(output_path)
	
