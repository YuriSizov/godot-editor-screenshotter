tool
extends Control

# Node references
onready var screenshot_button : ToolButton = $TakeThePic

signal screenshot_requested()
signal partial_screenshot_requested()

func _ready() -> void:
	_update_theme()
	
	screenshot_button.connect("pressed", self, "_on_screenshot_button_pressed")

func _input(event) -> void:
	if (event is InputEventKey && event.is_pressed() && !event.is_echo()):
		if (event.scancode == KEY_F11 && event.alt):
			emit_signal("partial_screenshot_requested")
			get_tree().set_input_as_handled()
		elif (event.scancode == KEY_F11):
			emit_signal("screenshot_requested")
			get_tree().set_input_as_handled()

func _update_theme() -> void:
	if (!Engine.editor_hint || !is_inside_tree()):
		return
	
	screenshot_button.icon = get_icon("Node", "EditorIcons")

func _on_screenshot_button_pressed() -> void:
	emit_signal("screenshot_requested")
