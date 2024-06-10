extends Node2D

signal player_entered_door(door_node)

func _ready():
	$player.entered_door.connect(player_entered_door.emit)

func loadlevel_frompath(levelpath):
	var newlevel = load(levelpath).instantiate()
	$levelctr.remove_child($levelctr.get_child(0))
	$levelctr.add_child(newlevel)
	newlevel.owner = owner if owner else self

func game_pause():
	process_mode = PROCESS_MODE_DISABLED
func game_resume():
	process_mode = PROCESS_MODE_INHERIT
