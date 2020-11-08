extends Node2D


var timer : Timer
var player : KinematicBody2D
var cell_size = 32
var screen_y : int
var offset = 10

onready var tile_map = $TileMap

onready var ground_enemy_pr = preload("res://Enemy/Ground_enemy/Ground_Enemy.tscn")
onready var flying_enemy_pr = preload("res://Enemy/Flying_enemy.tscn")
onready var trash_pr = preload("res://Collectables/Trash.tscn")

var start_pt = 0
var end_pt : int

var tiles_to_set = 30

var spawn_limit = 15
var spawn_limit_const = 15

var player_pos_x : float

var ground_enemy : StaticBody2D
var sky_enemy : StaticBody2D
var trash : StaticBody2D

var old_enemy_x : float

var remove_start_pt : int
var remove_end_pt : int

var f_spawn_cap = 1000
var f_spawn_cap_const = 500


func _ready():
	randomize()
	init_timer()
	timer.start()
	get_player()
	screen_y = get_viewport().size.y/cell_size - offset
	end_pt = start_pt + tiles_to_set
	spawn_tiles()

	
func _physics_process(delta):
	
	
	
	player_pos_x = player.position.x/cell_size
	
	if player_pos_x + tiles_to_set/2 > start_pt:
		spawn_tiles()
		
	if player_pos_x - tiles_to_set*2 > remove_start_pt:
		remove_tiles()
	

		
	
func spawn_tiles():
	for i in range(start_pt,end_pt):
		tile_map.set_cell(i,screen_y,0)
		tile_map.set_cell(i,screen_y+1,0)
		tile_map.set_cell(i,screen_y+2,0)
	remove_tiles()
	start_pt = end_pt

	end_pt += tiles_to_set
	
func remove_tiles():
	remove_start_pt = player_pos_x - tiles_to_set*2
	remove_end_pt = remove_start_pt + tiles_to_set
	for i in range(remove_start_pt,remove_end_pt):
		if tile_map.get_cell(i,screen_y) != -1:
			tile_map.set_cell(i,screen_y,-1)
			tile_map.set_cell(i,screen_y+1,-1)
			tile_map.set_cell(i,screen_y+2,-1)
	
func get_player():
	player = get_parent().get_node("Player")

		
func spawning_enemies():
	if spawn_ground_enemy:
		pass
	else:
		spawn_flying_enemy


func spawn_flying_enemy():
	if player_pos_x > f_spawn_cap:
		f_spawn_cap += f_spawn_cap_const
	
		var enemy_x = rand_range(start_pt,end_pt) * cell_size
		var enemy_y = screen_y * cell_size - 256

		if enemy_x > old_enemy_x + 194:
			flying_enemy = flying_enemy_pr.instance()
			flying_enemy.position = Vector2(enemy_x,enemy_y)
			get_parent.add_child(flying_enemy)
		
func spawn_ground_enemy():
	print("spawning")
	var enemy_x = rand_range(start_pt,end_pt) * cell_size
	var enemy_y = screen_y * cell_size - cell_size
	
	
	if enemy_x < old_enemy_x + 256:
		return false
	else:
		ground_enemy = ground_enemy_pr.instance()
		ground_enemy.position = Vector2(enemy_x,enemy_y)
		get_parent().add_child(ground_enemy)
		old_enemy_x = enemy_x
		trash = trash_pr.instance()
		trash.position = Vector2(enemy_x,enemy_y-128)
		get_parent().add_child(trash)
		return true

func init_timer():
	timer = Timer.new()
	timer.wait_time = 1
	timer.connect("timeout",self,"spawn_ground_enemy")
	add_child(timer)
