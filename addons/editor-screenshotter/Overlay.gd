tool
extends Control

var editor_control : Control
var target_control : Control
var _target_was_updated : bool = false

signal partial_screenshot_cancelled()
signal screenshot_requested(control)

func _input(event) -> void:
	if (!visible):
		return
	
	if (event is InputEventKey && event.is_pressed() && !event.is_echo()):
		if (event.scancode == KEY_ESCAPE):
			emit_signal("partial_screenshot_cancelled")
			get_tree().set_input_as_handled()
		elif (event.scancode == KEY_PAGEUP):
			var parent_node = target_control.get_parent()
			if (parent_node && parent_node is Control):
				target_control = parent_node
				update()
			get_tree().set_input_as_handled()
	elif (event is InputEventMouseButton && event.is_pressed()):
		if (event.button_index == BUTTON_LEFT && target_control):
			emit_signal("screenshot_requested", target_control)
			get_tree().set_input_as_handled()
	elif (event is InputEventMouseMotion):
		_find_target_control()
		update()

func _draw() -> void:
	if (!visible || !target_control):
		return
	
	var shape = Rect2(target_control.rect_global_position, target_control.rect_size)
	var background_color = get_color("accent_color", "Editor")
	background_color.a = 0.15
	var border_color = get_color("accent_color", "Editor")
	
	draw_rect(shape, background_color, true)
	draw_rect(shape, border_color, false, 1, true)

func _find_target_control() -> void:
	var base_control = get_parent()
	var mouse_position = base_control.get_global_mouse_position()
	
	var top_modal = get_viewport().get_modal_stack_top()
	target_control = top_modal if top_modal && is_instance_valid(top_modal) else base_control
	while (target_control):
		var found = false
		for child in target_control.get_children():
			if (!(child is Control) || !child.visible):
				continue
			
			var control_rect = child.get_global_rect()
			if (control_rect.has_point(mouse_position)):
				target_control = child
				found = true
				break
		
		if (!found):
			break
	
	if (!target_control || !is_instance_valid(target_control)):
		target_control = base_control
