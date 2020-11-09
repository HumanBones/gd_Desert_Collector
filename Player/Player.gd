extends KinematicBody2D

export var normal_speed = 400
export var max_speed = 1200
export var jump_power = 1800
export var gravity = 200
export var max_grav = 600

var speed = normal_speed

var velocity : Vector2
var dead = false

var grounded = false

var lives = 3 #lives?
var score = 0

var is_sliding = false


onready var spiret = $Sprite
onready var anim_player = $AnimationPlayer
onready var audio_player = $AudioStreamPlayer
onready var restart_layer = $CanvasLayer/Label
onready var audio_slide = $Slide



func _ready():
	update_ui()


func _process(delta):
	
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()


func _physics_process(delta):
	if !dead:
		restart_layer.visible = false
		movment()
	else:
		self.visible = false
		restart_layer.visible = true

func movment():

	if Input.is_action_just_pressed("jump") && grounded && !is_sliding:
		velocity.y = -jump_power
		anim_player.play("Jumping")
		audio_player.play()

	if Input.is_action_just_pressed("slide"):
		is_sliding = true

	
	

	if is_on_floor():
		if is_sliding:
			anim_player.play("Slide")
		else:
			anim_player.play("Runing")
		velocity.x = speed
		grounded = true
	else:
		velocity.y += gravity
		grounded = false
		
	if velocity.y > max_grav:
		velocity.y = max_grav
	
	move_and_slide(velocity,Vector2.UP)


func _on_Hitbox_body_entered(body):
	if body.is_in_group("collectables"):
		print("collected")
		score += 1
		update_ui()
		body.queue_free()
		
	else:
		print(body)
		dead = true
	
func update_ui():
	get_parent().get_node("CanvasLayer/Label").text = str(score)


func sliding_finished():
	is_sliding = false

func play_audio_slide():
	audio_slide.play()
