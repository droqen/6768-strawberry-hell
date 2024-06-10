extends Node2D

signal displayed(message)
signal dismissed

@export var label : Label

var char_delay : int = 0
var _delay : int = 0

func display_message(message : String, custom_char_delay : int = 1):
	label.text = message
	label.visible_characters = 0
	displayed.emit(message) # unnecessary but whatever
	self.char_delay = custom_char_delay
	self._delay = self.char_delay

func _physics_process(delta: float) -> void:
	if label.visible_characters >= 0:
		if _delay > 0:
			_delay -= 1
		else:
			if label.visible_ratio >= 1:
				label.visible_characters = -1
			else:
				label.visible_characters += 1
			_delay = char_delay
		$continue_blinker.hide()
		if Input.is_action_just_pressed("action"):
			label.visible_ratio = 1
	else:
		$continue_blinker.show()
		if Input.is_action_just_pressed("action"):
			dismissed.emit.call_deferred()
