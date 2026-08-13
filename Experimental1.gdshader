shader_type canvas_item;

/**
The number of pixels along the X and Y axes.
Also controls the size and aspect ratio of each pixel. 
For cleaner images, use whole, even numbers.
*/
uniform vec2 pixel_grid_size = vec2(128.0);
group_uniforms Offsets;
/**
If true, then every other column of pixels will be inverted.
For cleaner images, set when texture is vertically symmetrical.
*/
uniform bool offset_x = false;
/**
If true, then every other row of pixels will be inverted.
For cleaner images, set when texture is horizontally symmetrical.
*/
uniform bool offset_y = false;
/**
Reverses the direction of triangles.
*/
uniform bool inverted = false;


//All pixel squares are cut into 2 triangles using a diagonal cut.
//By default this creates a "top-left" and "bottom_right" triangle.
//This function determines if it will instead be cut into a "top-right" and "bottom-left" triangle.
bool get_offset(vec2 uv){
	vec2 grid_index = floor(uv * pixel_grid_size); //The grid index of the current pixel cell. Ex. (2, 3)
	float grid_total = dot(grid_index, vec2(float(offset_x), float(offset_y))); //The total value of the X and Y indexes based on if their respective uniforms are enabled.
	float offset_frequency = 2.0; //Every other row/column will be offset. You could change this for different patterns/effects.
	
	bool is_offset = mod(grid_total, offset_frequency) < 1.0; 
	is_offset = (is_offset != inverted); //Another way to write "if (inverted) {is_offset = !is_offset;}"
	
	return is_offset;
}


//Returns a normalized position within the local pixel cell that points to the center of the closest triangle.
//Top Left = vec2(1.0/3.0, 1.0/3.0)
//Top Right = vec2(2.0/3.0, 1.0/3.0)
//Bottom Left = vec2(1.0/3.0, 2.0/3.0)
//Bottom Right = vec2(2.0/3.0, 2.0/3.0)
vec2 get_triangle_center(vec2 uv, bool is_offset){
	
	vec2 triangle_center; 
	
	//Split square pixel into 2 triangles using a diagonal line and select which triangle to reference.
	if (is_offset){
		bool is_top_left = (uv.x + uv.y) <= 1.0;
		if (is_top_left) {
			//Top Left
			triangle_center = vec2(1.0/3.0, 1.0/3.0);
		}
		else{
			//Bottom Right
			triangle_center = vec2(2.0/3.0, 2.0/3.0);
		}
	}
	else{
		bool is_top_right = (uv.x >= uv.y);
		if (is_top_right) {
			//Top Right
			triangle_center = vec2(2.0/3.0, 1.0/3.0);
		}
		else{
			//Bottom Left
			triangle_center = vec2(1.0/3.0, 2.0/3.0);
		}
	}
	
	return triangle_center;
}


void fragment( )
{
	vec2 pixel_origin = floor(UV * pixel_grid_size) / pixel_grid_size; //Normalized position within the texture that points to the (0,0) position of the local pixel cell.
	vec2 pixel_uv = fract(UV * pixel_grid_size); //Normalized position within the local pixel cell.
	
	bool is_offset = get_offset(UV);
	vec2 triangle_center = get_triangle_center(pixel_uv, is_offset);
	vec2 triangle_uv = pixel_origin + (triangle_center / pixel_grid_size); //Normalized position within the texture that points to the triangle's center.
	
	//Apply triangle color.
	COLOR = texture(TEXTURE, triangle_uv);
}
