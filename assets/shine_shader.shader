shader_type canvas_item;
render_mode blend_mix;

uniform vec4 color : hint_color;
uniform float shine_value : hint_range(0.0,1.0,0.05) = 0.4;
uniform float time_scale : hint_range(0.0,100.0,0.5) = 4.0;

void fragment()
{
	COLOR = texture(TEXTURE,UV);
	COLOR += texture(TEXTURE,UV) * shine_value * abs(cos(TIME*time_scale));
}
void vertex()
{
	//VERTEX.x += cos(TIME*4.0 + VERTEX.x +VERTEX.y)* 10.0;
	//VERTEX.y += cos(TIME*3.0 + VERTEX.x +VERTEX.y)* 5.0;
}
