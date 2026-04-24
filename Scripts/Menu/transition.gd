extends CanvasLayer

signal TransitionEnded

@onready var animation_player: AnimationPlayer = $TransitionControl/AnimationPlayer

func go_in():
	animation_player.play("In");
	await TransitionEnded
	GameState.is_in_transition = true;

func go_out():
	animation_player.play("Out");
	await TransitionEnded
	GameState.is_in_transition = false;

func transition_ended_emit():
	TransitionEnded.emit()
