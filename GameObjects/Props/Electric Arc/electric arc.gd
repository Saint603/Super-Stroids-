##Credit github.com/AshirRashid/Pulse/

extends Line2D
@onready var start = %Start
@onready var end = %End

var offset = 360 ##i dont know why i need this. but i also dont know why the start is the end and the end is the start. Borrowed code
var offset_vector = Vector2(offset, offset)

func _process(_delta):
	pulse_between(self, end.global_position - offset_vector, start.global_position - offset_vector)
	
func pulse_between(line2d: Line2D, start:Vector2, end:Vector2, line_num:=3, points_num:=20, max_amp:=20):
	var end2start = end-start
	var dir = end2start.normalized()
	var segment_length = end2start.length()/points_num
	line2d.points = [start]
	
	for j in range(line_num):
		var pulse_points = PackedVector2Array()
		for i in range(1, points_num):
			var point_offset = (randi()%max_amp*2)-max_amp
			var current_point = start + i*dir*segment_length + point_offset*Vector2(-dir.y, dir.x)
			# Notice that Vector2(-dir.y, dir.x) is perpendicular to dir
			pulse_points.append(current_point)
			
		if j%2 == 0:
			pulse_points.append(end)
		else:
			#pulse_points.invert()
			pulse_points.append(start)
		line2d.points += pulse_points
