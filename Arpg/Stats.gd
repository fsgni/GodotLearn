extends Node2D

export var max_health = 1 setget set_max_health #合理使用export可以很好的管理游戏建议查看godot文档的说明
#使用export可以自由设定数值，变量出现在右边inspector窗口可以自由调整,括号内可以定为整数或者带有小数点的
var health = max_health  setget set_health  
#使用onready把变量初始化即为设置好的最大hp量
#setget后就可以set与get变量
signal no_health  #创建信号，创建后可在信号标签看到自己的的信号
signal health_changed(value)  #创建信号联动ui
signal max_health_changed(value)

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func set_health(value): #这样即使在其他地方没有调用函数也能直接获得这个值即set
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health") #向上发送的信号
		#emit发出给定信号。该信号必须存在，因此它应该是此类或它的父类之一的内置信号，
		#或者是用户定义的信号。此方法支持可变数量的参数，因此参数以逗号分隔列表的形式传递
func _ready():
	self.health = max_health

#保持良好的代码结构，向下调用，向上信号。这样可以保持各个对象的独立性
#那么当你给其他敌人添加stats时，比如一个有三阶段的boss，你这样设置的话，向上发送no health信号
#的时候，你就可以让他进入下一个阶段，而不是直接消失
#所以敌人场景可以用来决定当它没有生命值时要做什么
