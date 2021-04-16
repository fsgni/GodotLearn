extends Camera2D

onready var topLeft = $Limits/TopLeft
onready var bottomRight = $Limits/BottomRight

func _ready():  #在这里我们获取里两个点的位置把limit值限制为它们的位置
	limit_top = topLeft.position.y
	limit_left = topLeft.position.x
	limit_bottom = bottomRight.position.y
	limit_bottom = bottomRight.position.x
