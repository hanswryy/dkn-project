extends Resource
class_name ItemData

@export var id: String = ""
@export var name: String = ""
@export var icon: Texture2D
@export var description: String = ""
@export var hasDetail: bool = false
@export var magnifiable: bool = false
@export var revealedVersion: ItemData
# branch_id
@export var postRevealDialog: String
