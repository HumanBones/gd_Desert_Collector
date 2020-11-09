extends Control


onready var music = $AudioStreamPlayer

func _ready():
	music.play()


func _on_TextureButton_pressed():
	get_tree().change_scene("res://World/World.tscn")
