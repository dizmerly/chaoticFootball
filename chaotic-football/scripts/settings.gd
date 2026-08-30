extends Control

@onready var volume_slider: HSlider = $VBoxContainer/volume_label/volume_slider
@onready var sfx_slider: HSlider = $VBoxContainer/sfx_volume/sfx_slider
@onready var brightness_slider: HSlider = $VBoxContainer/brightness_label/brightness_slider
@onready var window_mode_button: OptionButton = $VBoxContainer/window_mode_label/OptionButton

func _ready() -> void:
	# The autoload has already loaded the saved values before this screen is created.
	volume_slider.set_value_no_signal(SettingsManager.master_volume)
	sfx_slider.set_value_no_signal(SettingsManager.sfx_volume)
	brightness_slider.set_value_no_signal(SettingsManager.brightness)
	window_mode_button.select(SettingsManager.window_mode)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("back"):
		_on_back_button_pressed()
		get_viewport().set_input_as_handled()

func _on_volume_slider_value_changed(value: float) -> void:
	SettingsManager.set_master_volume(value)


func _on_sfx_slider_value_changed(value: float) -> void:
	SettingsManager.set_sfx_volume(value)


func _on_brightness_slider_value_changed(value: float) -> void:
	SettingsManager.set_brightness(value)


func _on_option_button_item_selected(index: int) -> void:
	SettingsManager.set_window_mode(index)
	
func _on_back_button_pressed() -> void:
	hide()
	if get_parent().has_method("open_popup"):
		get_parent().open_popup()
