extends Node2D


func _process(delta: float) -> void:
	change_scenes()

func _on_cliffside_exitpoint_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		Global.transition_scene = true
	pass

#func _on_cliffside_exitpoint_body_exited(body: Node2D) -> void:
	#if body.has_method("player"):
		#Global.transition_scene = false
		
#func _on_cliffside_exitpoint_body_exited(body: Node2D) -> void:
	#if body.has_method("player"):
		#Global.transition_scene = false

func change_scenes():
	if Global.transition_scene == true:
		if Global.current_scene == "cliff_side":
			get_tree().change_scene_to_file("res://scenes/world.tscn")
			Global.finish_change_scene()
