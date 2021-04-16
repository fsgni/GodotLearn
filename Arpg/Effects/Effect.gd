extends AnimatedSprite

func _ready():
	connect("animation_finished",self,"_on_animation_finished") 
	#因为要组建一个effect集所以这里就不能从编辑器来发出信号需要用代码来发送信号          
	#顺序是有信号的节点，信号名称，连接到的节点，链接到的函数
	play("Animate")
   
func _on_animation_finished(): #完成动画播放后
	queue_free() #帧数结束后消灭
