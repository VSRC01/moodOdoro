extends Node3D

@export var zoom_speed: float = 0.1
@export var pan_speed: float = 1.0
@export var rotation_speed: float = 1.0
@export var can_pan: bool
@export var can_zoom: bool
@export var can_rotate: bool


  #_     <-. (`-')_  _  (`-')           (`-')      
 #(_)       \( OO) ) \-.(OO )     .->   ( OO).->   
 #,-(`-'),--./ ,--/  _.'    \,--.(,--.  /    '._   
 #| ( OO)|   \ |  | (_...--''|  | |(`-')|'--...__) 
 #|  |  )|  . '|  |)|  |_.' ||  | |(OO )`--.  .--' 
#(|  |_/ |  |\    | |  .___.'|  | | |  \   |  |    
 #|  |'->|  | \   | |  |     \  '-'(_ .'   |  |    
 #`--'   `--'  `--' `--'      `-----'      `--'    
func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		handle_touch(event)
	if event is InputEventScreenDrag:
		handle_drag(event)


var start_zoom: float
var start_dist: float
var touch_points: Dictionary = {}
var start_angle: float
var current_angle: float

@onready var camera: Camera3D = $CameraPivot/Camera3D
@onready var camera_pivot: Marker3D = $CameraPivot


 #(`-').-> (`-')  _ <-. (`-')_  _(`-')             (`-')  _    (`-')                                      (`-').-> 
 #(OO )__  (OO ).-/    \( OO) )( (OO ).->   <-.    ( OO).-/    ( OO).->       .->        .->    _         (OO )__  
#,--. ,'-' / ,---.  ,--./ ,--/  \    .'_  ,--. )  (,------.    /    '._  (`-')----. ,--.(,--.   \-,-----.,--. ,'-' 
#|  | |  | | \ /`.\ |   \ |  |  '`'-..__) |  (`-') |  .---'    |'--...__)( OO).-.  '|  | |(`-')  |  .--./|  | |  | 
#|  `-'  | '-'|_.' ||  . '|  |) |  |  ' | |  |OO )(|  '--.     `--.  .--'( _) | |  ||  | |(OO ) /_) (`-')|  `-'  | 
#|  .-.  |(|  .-.  ||  |\    |  |  |  / :(|  '__ | |  .--'        |  |    \|  |)|  ||  | | |  \ ||  |OO )|  .-.  | 
#|  | |  | |  | |  ||  | \   |  |  '-'  / |     |' |  `---.       |  |     '  '-'  '\  '-'(_ .'(_'  '--'\|  | |  | 
#`--' `--' `--' `--'`--'  `--'  `------'  `-----'  `------'       `--'      `-----'  `-----'      `-----'`--' `--' 
func handle_touch(event: InputEventScreenTouch):
	if event.pressed:
		touch_points[event.index] = event.position
	else:
		touch_points.erase(event.index)
	
	if touch_points.size() < 2:
		start_dist = 0
		
	if touch_points.size() == 2:
		var touch_point_positions = touch_points.values()
		start_dist = touch_point_positions[0].distance_to(touch_point_positions[1])
		start_zoom = camera.size
		
	
 #(`-').-> (`-')  _ <-. (`-')_  _(`-')             (`-')  _     _(`-')      (`-')  (`-')  _            
 #(OO )__  (OO ).-/    \( OO) )( (OO ).->   <-.    ( OO).-/    ( (OO ).-><-.(OO )  (OO ).-/     .->    
#,--. ,'-' / ,---.  ,--./ ,--/  \    .'_  ,--. )  (,------.     \    .'_ ,------,) / ,---.   ,---(`-') 
#|  | |  | | \ /`.\ |   \ |  |  '`'-..__) |  (`-') |  .---'     '`'-..__)|   /`. ' | \ /`.\ '  .-(OO ) 
#|  `-'  | '-'|_.' ||  . '|  |) |  |  ' | |  |OO )(|  '--.      |  |  ' ||  |_.' | '-'|_.' ||  | .-, \ 
#|  .-.  |(|  .-.  ||  |\    |  |  |  / :(|  '__ | |  .--'      |  |  / :|  .   .'(|  .-.  ||  | '.(_/ 
#|  | |  | |  | |  ||  | \   |  |  '-'  / |     |' |  `---.     |  '-'  /|  |\  \  |  | |  ||  '-'  |  
#`--' `--' `--' `--'`--'  `--'  `------'  `-----'  `------'     `------' `--' '--' `--' `--' `-----'   
func handle_drag(event: InputEventScreenDrag):
	touch_points[event.index] = event.position
	# handle pan
	if touch_points.size() == 1:
		if can_pan:
			camera_pivot.rotation.y -= event.relative.x * pan_speed
	# handle zoom
	if touch_points.size() == 2:
		if can_zoom:
			var touch_point_positions = touch_points.values()
			var current_dist = touch_point_positions[0].distance_to(touch_point_positions[1])
			
			var zoom_factor = start_dist / current_dist
			camera.size = start_zoom * zoom_factor
