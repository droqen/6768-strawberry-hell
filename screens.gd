extends Node2D

func _ready():
	$dialogbox.displayed.connect(func(_m):
		$gameworld.game_pause.call_deferred()
	)
	$dialogbox.dismissed.connect(func():
		$gameworld.game_resume.call_deferred()
	)
	
	$dialogbox.show();
	$dialogbox.display_message("RED\nRED\nRED\nRED\nRED\nRED\nRED\nRED\nRED", 2);
	await $dialogbox.dismissed;
	$dialogbox.hide();
	await $gameworld.player_entered_door;
	$gameworld.loadlevel_frompath.call_deferred("res://levels/level_2.tscn")
	$dialogbox.show();
	$dialogbox.display_message("BLUE\nBLUE\nBLUE\nBLUE\nBLUE\nBLUE\nBLUE\nBLUE\nBLUE", 3);
	await $dialogbox.dismissed;
	$dialogbox.hide();
