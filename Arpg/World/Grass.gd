extends Node2D

const GrassEffect = preload("res://Effects/GrassEffect.tscn")#预载特效
#合理分配资源只在需要时预载

func create_grass_effect():
	var grassEffect = GrassEffect.instance()
	#大小写不同的原因为大写G是个真是场景，叫做PackeScene,不是节点。
	#小写的g是场景的引用，是一个节点变量
	get_parent().add_child(grassEffect)#这样就获取了当前场景的根节点
	grassEffect.global_position = global_position#让特效全局的位置等于了草的全局位置

func _on_Hurtbox_area_entered(_area):
	create_grass_effect()
	queue_free() #会把节点添加到一个要被free，也就是从游戏种移除的列队里，通常等到帧数结束后移除。
