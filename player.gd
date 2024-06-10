extends Node2D

signal entered_door(door_node)

enum {
	IDLE, WALKING, AIR,
	
	JUST_USED_DOOR_BUF,
}

@onready var spr = $SheetSprite
@onready var plast = TinyState.new(IDLE, func(_then,now):
	match now:
		IDLE: spr.setup([10,11,12],8)
		WALKING: spr.setup([20,21,22] if spr.frame != 20 else [21,22,20],8)
		AIR: spr.setup([20,20,30],6)
)
@onready var bufs = Bufs.Make(self, [JUST_USED_DOOR_BUF, 3])

var velocity : Vector2

func _ready():
	# wiggle
	$mover.try_slip_move(self, $mover/solidcast, VERTICAL, -1.1)
	$mover.try_slip_move(self, $mover/solidcast, VERTICAL,  0.75)
	
	$door_detector.area_entered.connect(func(door):
		if not bufs.has(JUST_USED_DOOR_BUF):
			bufs.on(JUST_USED_DOOR_BUF)
			entered_door.emit(door)
	)

func _physics_process(delta: float) -> void:
	var pinx : float = (1 if Input.is_action_pressed("right") else 0) - (1 if Input.is_action_pressed("left") else 0)
	velocity.x = move_toward(velocity.x, pinx * 1.0, 0.1)
	velocity.y = move_toward(velocity.y, 1.0, 0.1)
	if pinx: spr.flip_h = pinx < 0
	var onfloor = velocity.y >= 0 and $mover.cast_fraction(self, $mover/solidcast, VERTICAL, 1.0) < 1

	if Input.is_action_just_pressed("jump"):
		if onfloor: velocity.y = -2.0
		else: velocity.y = -1.0
	
	# apply velocities
	if not $mover.try_slip_move(self, $mover/solidcast, HORIZONTAL, velocity.x):
		velocity.x = 0
	if not $mover.try_slip_move(self, $mover/solidcast, VERTICAL, velocity.y):
		velocity.y = 0
	
	if onfloor:
		if pinx:
			plast.goto(WALKING)
		else:
			plast.goto(IDLE)
	else:
		plast.goto(AIR)

	position.x = fposmod(position.x, 300)
	position.y = fposmod(position.y, 260)
