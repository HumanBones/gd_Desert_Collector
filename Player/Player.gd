extends KinematicBody2D

export var speed = 400
export var jump_power = 2000
export var gravity = 200
export var max_grav = 1000

var velocity : Vector2
var dead = false

var grounded = false

var lives = 3 #lives?
var score = 0


onready var spiret = $Sprite
onready var anim_player = $AnimationPlayer
onready var audio_player = $AudioStreamPlayer



func _ready():
	update_ui()

func _process(delta):
	
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()


func _physics_process(delta):
	if !dead:
		movment()
	else:
		self.visible = false
		print("dead")
		#display death screen

func movment():

	if Input.is_action_just_pressed("jump") && grounded:
		velocity.y = -jump_power
		anim_player.play("Jumping")
		audio_player.play()

	if Input.is_action_pressed("slide"):
		anim_player.play("Slide")

	
	

	if is_on_floor():
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
