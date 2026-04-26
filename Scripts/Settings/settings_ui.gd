extends Control

@onready var music_slider: HSlider = $PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/MusicVolume/MusicSlider
@onready var sound_effects_slider: HSlider = $PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/SoundEffectsVolume/SoundEffectsSlider
@onready var ambiance_slider: HSlider = $PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/AmbianceVolume/AmbianceSlider
@onready var jumpscare_checkbox: CheckBox = $PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/Jumpscares/JumpscareCheckbox
@onready var full_screen_checkbox: CheckBox = $PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/FullScreen/FullScreenCheckbox

func activate():
	show();
	load_values();

func load_values():
	music_slider.value = SaveManager.current_settings.music_volume
	sound_effects_slider.value = SaveManager.current_settings.sound_effects_volume
	ambiance_slider.value = SaveManager.current_settings.ambiance_volume
	jumpscare_checkbox.button_pressed = SaveManager.current_settings.jumpscares
	full_screen_checkbox.button_pressed = SaveManager.current_settings.full_screen

func _on_music_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		SaveManager.save_settings_field(music_slider.value, SettingsData.SettingsFields.MUSIC_VOLUME);

func _on_sound_effects_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		SaveManager.save_settings_field(sound_effects_slider.value, SettingsData.SettingsFields.SOUND_EFFECTS_VOLUME);

func _on_ambiance_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		SaveManager.save_settings_field(ambiance_slider.value, SettingsData.SettingsFields.AMBIANCE_VOLUME);

func _on_jumpscare_checkbox_pressed() -> void:
	SaveManager.save_settings_field(jumpscare_checkbox.button_pressed, SettingsData.SettingsFields.JUMPSCARES);

func _on_full_screen_checkbox_pressed() -> void:
	SaveManager.save_settings_field(full_screen_checkbox.button_pressed, SettingsData.SettingsFields.FULL_SCREEN)
