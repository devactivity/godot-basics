extends Node

var player_current_attack = false
var current_scene = "world"
var transition_scene = false
var player_exit_cliffside_posx = 448
var player_exit_cliffside_posy = 9
var player_start_posx = 385
var player_start_posy = 204
var game_first_loadin = true

func finish_change_scene():
	if transition_scene == true:
		transition_scene = false
		
		if current_scene == "world":
			current_scene = "cliff_side"
		else:
			current_scene = "world"
