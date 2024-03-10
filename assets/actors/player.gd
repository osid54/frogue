extends CharacterBody2D

@export var speed := 100.0
@export var accel := 300.0
@export var friction := 300.0

var dir : Vector2

var dashing := false
var dashable := true
var startSpeed : float

@onready var animTreeIdle = $AnimationTree.get("parameters/idle/blend_position")
@onready var animTreeRun = $AnimationTree.get("parameters/run/blend_position")

func _ready():
	
	startSpeed = speed

func _process(_delta):
	if Input.is_action_just_pressed("dash"):
		if dashable:
			dashable = false
			dash()
	
func _physics_process(delta):
	dir = Vector2.ZERO
	dir = Input.get_vector("left", "right", "up", "down")
	dir = dir.normalized()
	
	if dashing:
		speed = startSpeed * 10
	else:
		speed = startSpeed
	if dir != Vector2.ZERO:
		velocity = velocity.move_toward(speed * dir, accel * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	updateAnimation()
	
	move_and_slide()

func dash():
	#$AnimatedSprite2D/ColorRect.color = "CYAN"
	dashing = true
	#$dashParticles.modulate = "CYAN"
	#$dashParticles.emitting = true
	#$AnimationPlayer.play("hit")
	await get_tree().create_timer(.2).timeout
	dashing = false
	await get_tree().create_timer(.1).timeout
	#$dashParticles.emitting = false
	await get_tree().create_timer(1).timeout
	dashable = true

func updateAnimation():
	if dir != Vector2.ZERO:
		$AnimationTree.set("parameters/run/blend_position",dir)
		$AnimationTree.set("parameters/idle/blend_position",dir)
		$AnimationTree.get("parameters/playback").travel("run")
	else:
		$AnimationTree.get("parameters/playback").travel("idle")
