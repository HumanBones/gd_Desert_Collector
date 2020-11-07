extends Node2D

var player : KinematicBody2D
var cell_size = 32

onready var tile_map = $TileMap

onready var ground_enemy_pr = preload("res://Enemy/Ground_enemy/Ground_Enemy.tscn")
onready var flying_enemy_pr = preload("res://Enemy/Flying_enemy.tscn") 

var tile_count = 0
var tiles_to_set = 10

var screen_y : int
var screen_x = 0

var player_cur_x_pos : float
var spawn_tile_cap  = 200
var const_tile_cap = 200

var remove_cap_cons = 400
var remove_tile_cap = 400

var remove_tile_x = -10

var ground_enemy : StaticBody2D
var sky_enemy : StaticBody2D


func _ready():
	var screen_size = get_viewport().size
	screen_y  = (screen_size.y / cell_size) - 10
	spawn_tiles()
	get_player()
	spawning_enemies()
	
func _physics_process(delta):
	player_cur_x_pos = player.position.x
	if player_cur_x_pos >= spawn_tile_cap:
		spawn_tile_cap += const_tile_cap
		spawn_tiles()
		
		
	if Input.is_action_just_pressed("ui_left"):
		remove_tiles()
	
	if player_cur_x_pos >= remove_tile_cap:
		remove_tile_cap += remove_cap_cons
		print(remove_tile_cap)
		remove_tiles()
		
		
	
func get_player():
	player = get_parent().get_node("Player")


	
func spawn_tiles():
	
	for i in range(tiles_to_set):
		tile_map.set_cell(screen_x,screen_y,0)
		tile_map.set_cell(screen_x,screen_y+1,0)
		tile_map.set_cell(screen_x,screen_y+2,0)
		tile_count += 1
		screen_x += 1
	


#work in progress
func remove_tiles():
	for i in range(tiles_to_set):
		tile_map.set_cell(remove_tile_x,screen_y,-1)
		tile_map.set_cell(remove_tile_x,screen_y+1,-1)
		tile_map.set_cell(remove_tile_x,screen_y+2,-1)
		remove_tile_x += 1
	
		
func spawning_enemies():
	pass

func spawn_flying_enemy():
	pass
	
func spawning_ground_enemy():
	pass
