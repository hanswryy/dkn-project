extends TextureButton

@export var character_id: String
@export var character_name: String

@onready var monodialog_manager = $MonodialogManager
@onready var monodialog_resource: Monodialog = Monodialog.new()

@export var start_duration: float
@export var hide_duration: float

var current_state = "start"
var current_branch_index = 0

func _ready() -> void:
	monodialog_resource.read_from_json("res://Scripts/Monodialog/monodialog_data.json")

func start_monodialog():
	print("Entered trigger")
	var monodialogs = monodialog_resource.get_chara_monodialog(character_id)
	if monodialogs.is_empty():
		return
	if character_name.is_empty():
		character_name = monodialogs[current_branch_index]["character_name"]
	monodialog_manager.start_monodialog(self)

func get_current_monodialog():
	var monodialogs = monodialog_resource.get_chara_monodialog(character_id)
	if current_branch_index < monodialogs.size():
		for monodialog in monodialogs[current_branch_index]["monodialogs"]:
			if monodialog["state"] == current_state:
				return monodialog
	return null

func set_monodialog_tree(branch_index):
	current_branch_index = branch_index
	current_state = "start"

func set_monodialog_state(state):
	current_state = state

func _on_body_entered(body: Node2D) -> void:
	start_monodialog()
