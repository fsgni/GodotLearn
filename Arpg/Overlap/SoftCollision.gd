extends Area2D

func is_colliding():
	var areas = get_overlapping_areas() #用于检测是否与其他物体碰撞
	return areas.size() > 0
	
func get_push_vector():  #设置碰撞后的相互作用
	var areas = get_overlapping_areas()
	var push_vector = Vector2.ZERO
	if is_colliding():
		var area = areas[0]
		push_vector = area.global_position.direction_to(global_position) #也就是我们获取来一个从它的位置到我们的位置的向量
		push_vector = push_vector.normalized()#让向量为一个圆=1
	return push_vector                         #如果没有与其他区域相撞就会返回0
