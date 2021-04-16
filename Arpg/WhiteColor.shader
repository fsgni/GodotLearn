shader_type canvas_item; //着色器语言类似与c++,着色器会检测每一个像素然后附着

uniform bool active = true;  //相当与exprot可在编辑器里设定

void fragment(){
	vec4 previous_color = texture(TEXTURE, UV);     //访问哪个texture的语句 
	vec4 white_color = vec4(1.0, 1.0, 1.0, previous_color.a); //a代表阿尔法值
	vec4 new_color = previous_color;
	if(active == true){
		new_color = white_color;
	}
	COLOR = new_color;        //vec4分别代表红，绿，蓝，透明度
} 

