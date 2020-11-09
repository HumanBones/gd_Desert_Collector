extends Node2D

onready var music = $AudioStreamPlayer


func _ready():
	music.play()
