extends Node

const SETTINGS_PATH := "user://settings.cfg"
const SETTINGS_SECTION := "display_and_audio"
const MIN_VOLUME := 0
const MAX_VOLUME := 100
const MIN_BRIGHTNESS = 0.8
const MAX_BRIGHTNESS = 1.2


# These values match the 0-100 range used by the sliders.
var master_volume := 50
var sfx_volume := 50
var brightness := 1.0
signal brightness_changed(value: float)

# 0 = fullscreen, 1 = borderless, 2 = windowed. 
# (for option button in settings panel)
var window_mode := 0

func _ready() -> void:
	load_settings()
	
func save_settings() -> void:
	var config := ConfigFile.new()
	config.set_value(SETTINGS_SECTION, "master_volume", master_volume)
	config.set_value(SETTINGS_SECTION, "sfx_volume", sfx_volume)
	config.set_value(SETTINGS_SECTION, "brightness", brightness)
	config.set_value(SETTINGS_SECTION, "window_mode", window_mode)

	var error := config.save(SETTINGS_PATH)
	if error != OK:
		push_error("Could not save settings: %s" % error)

func load_settings() -> void:
	var config := ConfigFile.new()
	var error := config.load(SETTINGS_PATH)

	# A missing file is normal on the first launch; keep the defaults above.
	if error != OK and error != ERR_FILE_NOT_FOUND:
		push_error("Could not load settings: %s" % error)
		return

	master_volume = clampi(int(config.get_value(SETTINGS_SECTION, "master_volume", master_volume)), MIN_VOLUME, MAX_VOLUME)
	sfx_volume = clampi(int(config.get_value(SETTINGS_SECTION, "sfx_volume", sfx_volume)), MIN_VOLUME, MAX_VOLUME)
	brightness = float(config.get_value(SETTINGS_SECTION, "brightness", brightness))
	window_mode = clampi(int(config.get_value(SETTINGS_SECTION, "window_mode", window_mode)), 0, 2)
	apply_settings()

func set_master_volume(value: float) -> void:
	master_volume = clampi(roundi(value), MIN_VOLUME, MAX_VOLUME)
	apply_master_volume()
	save_settings()

func set_sfx_volume(value: float) -> void:
	sfx_volume = clampi(roundi(value), MIN_VOLUME, MAX_VOLUME)
	apply_sfx_volume()
	save_settings()

func set_brightness(value: float) -> void:
#	for the sake of simplicity since min and max volume is just 0, 100
#	I can just use those variables here.
	brightness = value
	# Brightness is persisted now. Apply it from the eventual display shader or
	brightness_changed.emit(brightness)
	save_settings()

func set_window_mode(value: int) -> void:
	window_mode = clampi(value, 0, 2)
	apply_window_mode()
	save_settings()

func apply_settings() -> void:
	apply_master_volume()
	apply_sfx_volume()
	apply_window_mode()

func apply_master_volume() -> void:
	apply_volume_to_bus("Master", master_volume)

func apply_sfx_volume() -> void:
	# This will begin working automatically once an "SFX" bus exists in the
	# project's audio bus layout. Until then, the user's choice is still saved.
	apply_volume_to_bus("SFX", sfx_volume)

func apply_volume_to_bus(bus_name: String, volume: int) -> void:
	var bus_index := AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		return

	AudioServer.set_bus_volume_db(bus_index, linear_to_db(float(volume) / MAX_VOLUME))

func apply_window_mode() -> void:
	match window_mode:
		0: # Fullscreen
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		1: # Borderless window
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		2: # Windowed
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
