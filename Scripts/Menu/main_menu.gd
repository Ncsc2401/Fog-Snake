extends Control

enum Menus {
	SETTINGS,
	CREDITS
}

@onready var credits: Control = $Credits
@onready var settings: Control = $Settings

## All opened menus, should be only one at time
var opened_menus : Array[Menus]

func _on_play_button_pressed() -> void:
	SceneManager.change_scene_to_map();

func _on_settings_button_pressed() -> void:
	if opened_menus.has(Menus.SETTINGS):
		close_settings()
	else:
		open_settings()

func _on_credits_button_pressed() -> void:
	if opened_menus.has(Menus.CREDITS):
		close_credits()
	else:
		open_credits();

func _on_quit_button_pressed() -> void:
	SceneManager.close_game()

func close_opened_menus():
	for menu in opened_menus:
		match menu:
			Menus.SETTINGS:
				close_settings()
			Menus.CREDITS:
				close_credits()

func open_credits():
	close_opened_menus()
	opened_menus.append(Menus.CREDITS)
	credits.show();

func close_credits():
	opened_menus.erase(Menus.CREDITS)
	credits.hide();

func open_settings():
	close_opened_menus()
	opened_menus.append(Menus.SETTINGS)
	settings.activate();
func close_settings():
	opened_menus.erase(Menus.SETTINGS)
	settings.hide()
