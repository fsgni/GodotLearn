extends Control

var hearts = 4 setget set_hearts  #通过setget设定hearts的值即hp
var max_hearts = 4 setget set_max_hearts

onready var heartUIFull = $HeartUIFull
onready var heartUIEmpty = $HeratUIEmpty

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts) #clamp的值要大于0小于max
	if heartUIFull != null: #如果收到伤害
		heartUIFull.rect_size.x = hearts * 15 #15为图片的像素尺寸

func set_max_hearts(value): 
	max_hearts = max(value, 1) #这样max就永远大于1
	self.hearts = min(hearts, max_hearts) #返回最小值，两个
	if heartUIEmpty != null: #如果收到伤害
		heartUIEmpty.rect_size.x = max_hearts * 15 #15为图片的像素尺寸
	
func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hearts" ) #从health_changed传来的信号变为hearts
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")
