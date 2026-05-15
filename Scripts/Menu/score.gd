extends Control

@onready var points_display: Label = $MarginContainer/PointsDisplay
@onready var level_cleared_display: Label = $MarginContainer/LevelClearedDisplay

var points : int = 0;

func _ready() -> void:
	points_display.pivot_offset_ratio = Vector2(0.5, 0.5)
	level_cleared_display.pivot_offset_ratio = Vector2(0.5, 0.5)

func update_display(new_points : int):
	var display_tween = create_tween();
	
	var score_rotation = randf_range(- PI / 24, PI / 24);
	var score_scale = Vector2.ONE * randf_range(1.25, 1.4);
	var score_pos = points_display.position + Vector2(randf_range(-3, 3), randf_range(-3, 3));
	var score_color = Color.GREEN;
	
	var score_normal_rotation = 0;
	var score_normal_scale = Vector2.ONE
	var score_normal_pos = points_display.position;
	var score_normal_color = Color.WHITE;
	
	display_tween.\
	tween_property(points_display, "rotation", score_rotation, 0.08).\
	set_trans(Tween.TRANS_BACK)
	
	display_tween.\
	parallel().\
	tween_property(points_display, "scale", score_scale, 0.08)
	
	display_tween.\
	parallel().\
	tween_property(points_display, "position", score_pos, 0.08)
	
	display_tween.\
	parallel().\
	tween_property(points_display, "modulate", score_color, 0.08);
	
	# Back to normal
	
	display_tween.\
	tween_property(points_display, "rotation", score_normal_rotation, 0.08)
	
	display_tween.\
	parallel().\
	tween_property(points_display, "scale", score_normal_scale, 0.08).\
	set_trans(Tween.TRANS_BOUNCE);
	
	display_tween.\
	parallel().\
	tween_property(points_display, "position", score_normal_pos, 0.08)
	
	display_tween.\
	parallel().\
	tween_property(points_display, "modulate", score_normal_color, 0.08);

	stepped_counting(points, new_points);
	points = new_points

func stepped_counting(from : int, to : int):
	var duration = 0.15;
	
	var steps = abs(to - from);
	
	if steps == 0:
		return;
	
	for step in range(steps):
		var value = from + step + 1;
		
		points_display.text = str(value) + " Points";
		
		await get_tree().create_timer(duration / steps).timeout

func display_level_cleared():
	level_cleared_display.show();
	
	var display_tween = create_tween();
	
	var lc_rotation = randf_range(- PI / 24, PI / 24);
	var lc_scale = Vector2.ONE * randf_range(1.25, 1.4);
	var lc_color = Color.GREEN;
	
	var lc_normal_rotation = 0;
	var lc_normal_scale = Vector2.ONE
	var lc_normal_color = Color.WHITE;
	
	display_tween.\
	tween_property(level_cleared_display, "rotation", lc_rotation, 0.08).\
	set_trans(Tween.TRANS_BACK)
	
	display_tween.\
	parallel().\
	tween_property(level_cleared_display, "scale", lc_scale, 0.08)
	
	display_tween.\
	parallel().\
	tween_property(level_cleared_display, "modulate", lc_color, 0.08);
	
	# Back to normal
	
	display_tween.\
	tween_property(level_cleared_display, "rotation", lc_normal_rotation, 0.08)
	
	display_tween.\
	parallel().\
	tween_property(level_cleared_display, "scale", lc_normal_scale, 0.08).\
	set_trans(Tween.TRANS_BOUNCE);
	
	display_tween.\
	parallel().\
	tween_property(level_cleared_display, "modulate", lc_normal_color, 0.08);
