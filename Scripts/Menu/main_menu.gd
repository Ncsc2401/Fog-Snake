extends Control

enum Menus {
	SETTINGS,
	CREDITS,
	NEW_GAME_CONFIRMATION
}

@onready var credits: Control = $Credits
@onready var settings: Control = $Settings
@onready var new_game_confirmation: Control = $NewGameConfirmation

@onready var continue_button: Button = $MainMenuButtons/MarginContainer/VBoxContainer/ContinueButton

## All opened menus, should be only one at time
var opened_menus : Array[Menus]

func _ready() -> void:
	continue_button.disabled = !SaveManager.has_save();

func _on_new_game_button_pressed() -> void:
	if SaveManager.has_save():
		open_new_game_confirmation()
	else:
		SceneManager.change_scene_to_map();

func _on_continue_button_pressed() -> void:
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

func _on_new_game_confirm_pressed() -> void:
	SaveManager.wipe_save();
	SceneManager.change_scene_to_map();

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

func open_new_game_confirmation():
	new_game_confirmation.show();
	opened_menus.append(Menus.NEW_GAME_CONFIRMATION)
	close_opened_menus()

func close_new_game_confirmation():
	new_game_confirmation.hide()
	opened_menus.erase(Menus.NEW_GAME_CONFIRMATION);
