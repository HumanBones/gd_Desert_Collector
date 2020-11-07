extends KinematicBody2D

export var speed = 400
export var jump_power = 2000
export var gravity = 200
export var max_grav = 1000

var velocity : Vector2
var dead = false

var grounded = false

var lives = 3 #lives?

onready var spiret = $Sprite
onready var anim_player = $AnimationPlayer


func _ready():
	pass



func _process(delta):
	
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()


func _physics_process(delta):
	if !dead:
		movment()
	else:
		print("dead")
		#display death screen

func movment():

	if Input.is_action_just_pressed("jump") && grounded:
		velocity.y = -jump_power
		anim_player.play("Jumping")

	if Input.is_action_just_pressed("slide"):
		pass
		#slide

	velocity.x = speed
	

	if is_on_floor():
		anim_player.play("Runing")
		grounded = true
	else:
		velocity.y += gravity
		grounded = false
		
	if velocity.y > max_grav:
		velocity.y = max_grav
	
	move_and_slide(velocity,Vector2.UP)
