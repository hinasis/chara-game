shader_type canvas_item;
render_mode blend_mix;

uniform float speed :hint_range(0.0,100.0,0.5) = 4.0;
uniform vec4 for_red :hint_color = vec4(1.0,1.0,1.0,1.0);
uniform vec4 for_green :hint_color = vec4(1.0,1.0,1.0,1.0);
uniform vec4 for_blue :hint_color = vec4(1.0,1.0,1.0,1.0);
uniform vec4 for_white :hint_color = vec4(1.0,1.0,1.0,1.0);
uniform vec4 for_black :hint_color = vec4(1.0,1.0,1.0,1.0);

void fragment(){
	vec4 white_color = vec4(1.0,1.0,1.0,1.0);
	COLOR = texture(TEXTURE,UV - vec2(1.0,0.00) * speed * TIME);
	
	// replacement:
		
	if (COLOR == vec4(1.0,0.0,0.0,1.0)){ //red
		if(for_red != white_color){
			COLOR = for_red;
		}
	} else if (COLOR == vec4(0.0,1.0,0.0,1.0)){ //green
		if(for_green != white_color){
			COLOR = for_green;
		}
	} else if (COLOR == vec4(0.0,0.0,1.0,1.0)){ //blue
		if(for_blue != white_color){
			COLOR = for_blue;
		}
	} else if (COLOR == vec4(1.0,1.0,1.0,1.0)){ //white
		if(for_white != white_color){
			COLOR = for_white;
		}
	} else if (COLOR == vec4(0.0,0.0,0.0,1.0)){ //black
		if(for_black != white_color){
			COLOR = for_black;
		}
	}
}