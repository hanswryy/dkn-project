extends Area2D

@onready var monodialog_manager = $MonodialogManager
@onready var monodialog_resource: Monodialog = Monodialog.new()

@export var character_id: String
@export var character_name: String
@export var current_branch_index: int = 0
var current_state = "start"

@export var start_duration: float = 0.5
@export var hide_duration: float = 0.5

var active_branch_data = null

func _ready() -> void:
	monodialog_resource.read_from_json("res://Scripts/Monodialog/monodialog_data.json")

func start_monodialog(new_branch_index: int = -1):
	if new_branch_index != -1:
		set_monodialog_tree(new_branch_index)
		
	var monodialogs = monodialog_resource.get_chara_monodialog(character_id)
	assert(not character_id.is_empty(), "Monodialog: Character ID belum di-setting")
	assert(not monodialogs.is_empty(), "Monodialog: character_id tidak ditemukan")
	
	var target_branch = null
	for branch in monodialogs:
		if int(branch["branch_id"]) == current_branch_index:
			target_branch = branch
			break
	
	if character_name.is_empty():
		character_name = target_branch["character_name"]
		
	self.active_branch_data = target_branch
		
	monodialog_manager.start_monodialog(self)

func get_current_monodialog():
	if active_branch_data:
		for monodialog in active_branch_data["monodialogs"]:
			if monodialog["state"] == current_state:
				return monodialog
	return null

func set_monodialog_tree(branch_index):
	current_branch_index = branch_index
	current_state = "start"

func set_monodialog_state(state):
	current_state = state
