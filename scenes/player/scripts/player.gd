extends CharacterBody2D


@export var player_name: String = "Player"
@export var speed: float = 80.0
@export var jump_velocity: float = -400.0
@export var up_key: String = ""
@export var left_key: String = ""
@export var down_key: String = ""
@export var right_key: String = ""

@onready var label_name: Label = $PlayerName
@onready var animate: AnimatedSprite2D = $AnimatedSprite
@onready var detect_player_push: Area2D = $DetectPlayerPush

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var other_player: CharacterBody2D = null

var _detect_player_push_flag: bool = false

func _ready() -> void:
	label_name.text = player_name


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed(up_key) and is_on_floor():
		velocity.y = jump_velocity

	var direction: float = Input.get_axis(left_key, right_key)
	if direction:
		velocity.x = direction * speed

		_push_other_player()

		animate.play("walk")

		if velocity.x > 0:
			animate.flip_h = true
			detect_player_push.scale.x = -1
		else:
			animate.flip_h = false
			detect_player_push.scale.x = 1

	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		animate.play("idle")

	move_and_slide()


func _push_other_player() -> void:
	if other_player:
		if _detect_player_push_flag:
			other_player.velocity = Vector2(scale.x, 0) * velocity
			other_player.move_and_slide()


func _on_detect_player_entered(body: Node2D) -> void:
	if body != self:
		other_player = body


func _on_detect_player_body_exited(_body: Node2D) -> void:
	other_player = null


func _on_detect_player_push_entered(_body: Node2D) -> void:
	_detect_player_push_flag = true


func _on_detect_player_push_exited(_body: Node2D) -> void:
	_detect_player_push_flag = false
