extends Node2D

@onready var in_game_menu: Control = $UI/InGameMenu

func _input(event: InputEvent) -> void:
	## Pauses when "Menu" button is pressed (default -> esc)
	
		
