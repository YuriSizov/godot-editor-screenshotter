tool
extends EditorPlugin

var control_instance : Control
var overlay_instance : Control

func _enter_tree() -> void:
	control_instance = preload("res://addons/editor-screenshotter/Control.tscn").instance()
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, control_instance)
	control_instance.connect("screenshot_requested", self, "_take_screenshot")
	control_instance.connect("partial_screenshot_requested", self, "_start_partial_screenshot")
	
	overlay_instance = preload("res://addons/editor-screenshotter/Overlay.tscn").instance()
	var base_control = get_editor_interface().get_base_control()
	base_control.add_child(overlay_instance)
	overlay_instance.hide()
	overlay_instance.connect("screenshot_requested", self, "_take_screenshot")
	overlay_instance.connect("partial_screenshot_cancelled", self, "_cancel_partial_screenshot")

func _exit_tree() -> void:
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, control_instance)
	control_instance.queue_free()
	control_instance = null
	
	var base_control = get_editor_interface().get_base_control()
	base_control.remove_child(overlay_instance)
	overlay_instance.queue_free()
	overlay_instance = null

func _take_screenshot(target_control : Control = null) -> void:
	overlay_instance.hide()
	var editor_tree = get_editor_interface().get_base_control().get_tree()
	yield(editor_tree, "idle_frame")
	yield(editor_tree, "idle_frame")
	
	var base_control = get_editor_interface().get_base_control()
	var main_viewport = (base_control.get_tree().get_root() as Viewport)
	var viewport_image = main_viewport.get_texture().get_data()
	viewport_image.flip_y()
	
	var cropped_image
	if (target_control && is_instance_valid(target_control) && target_control is Control):
		cropped_image = Image.new()
		cropped_image.create(target_control.rect_size.x, target_control.rect_size.y, false, viewport_image.get_format())
		cropped_image.blit_rect(viewport_image, Rect2(target_control.rect_global_position, target_control.rect_size), Vector2.ZERO)
	else:
		cropped_image = viewport_image
	
	var datetime = OS.get_unix_time()
	cropped_image.save_png("res://.output/godot-editor-" + str(datetime) + ".png")

func _start_partial_screenshot() -> void:
	overlay_instance.raise()
	overlay_instance.show()

func _cancel_partial_screenshot() -> void:
	overlay_instance.hide()
