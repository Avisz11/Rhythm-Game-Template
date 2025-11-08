extends Node2D

var spawn_info = [0.2, 0.5, 0.7, 0.9, 1.2] #Time when the keys spawn
var spawn_index = 0
var spawn_positions = [500,700] #ADJUST FOR THE AMOUNT OF KEYS
var notes = []
var current_time = 0.0
var y_threshold = 600
var good_threshold = 100
var perfect_threshold = 50
var combo = 0
const FALLING_KEY = preload("res://game/falling_key.tscn")
const LABEL_POP_UP = preload("res://game/label_pop_up.tscn")
@export var perfect_color : Color
@export var good_color : Color
@export var miss_color : Color
@export var perfect_text : String = "300"
@export var good_text : String = "100"
@export var miss_text : String = "X"

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	current_time += delta
	get_input()
	if spawn_index < spawn_info.size() and current_time >= spawn_info[spawn_index]:
		var inst = FALLING_KEY.instantiate()
		var rand = randi_range(0, spawn_positions.size() -1)
		inst.global_position.y = -48
		inst.global_position.x = spawn_positions[rand]
		get_tree().current_scene.add_child(inst)
		notes.append(inst)
		spawn_index += 1
	for note in notes:
		if note.global_position.y > y_threshold:
			miss()
			notes.erase(note)
			note.queue_free()
	

func hit_perfect():
	combo += 1
	var inst = LABEL_POP_UP.instantiate()
	inst.set_label(perfect_text, perfect_color)
	inst.global_position = $LabelPos.global_position
	get_tree().current_scene.add_child(inst)
	print("perfect")

func hit_good():
	combo += 1
	var inst = LABEL_POP_UP.instantiate()
	inst.set_label(good_text, good_color)
	inst.global_position = $LabelPos.global_position
	get_tree().current_scene.add_child(inst)
	print("good")

func miss():
	combo = 0
	var inst = LABEL_POP_UP.instantiate()
	inst.set_label(miss_text, miss_color)
	inst.global_position = $LabelPos.global_position
	get_tree().current_scene.add_child(inst)
	print("miss")

func get_input():
	if Input.is_action_just_pressed("key_1"): #Adjust for as many keys you have
		check_hit(spawn_positions[0])
	if Input.is_action_just_pressed("key_2"):
		check_hit(spawn_positions[1])

func check_hit(x_pos):
	for note in notes:
		if note.global_position.x == x_pos:
			if abs(note.global_position.y - y_threshold) <= perfect_threshold:
				hit_perfect()
				notes.erase(note)
				note.queue_free()
			elif abs(note.global_position.y - y_threshold) <= good_threshold:
				hit_good()
				notes.erase(note)
				note.queue_free()
