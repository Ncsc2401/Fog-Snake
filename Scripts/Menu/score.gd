extends Control

@onready var score_display: Label = $MarginContainer/Label

func update_display(points : int):
	score_display.text = str(points) + " Points";
