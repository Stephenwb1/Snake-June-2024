extends TileMap

@onready var tile_map = $"."
@onready var timer = $Timer

#variables

#movement variables
const directions := [Vector2i.LEFT, Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN]
var dir: int = -1 #for switching direction based on input
var speed: float = 2.5
var steps : Array
var steps_req: int = 50
var previous_positions = [Vector2i(5, 5)]

#game piece variables
var snake_length := 1 

var tile_id: int = 0
var board_layer: int = 0
var active_layer: int = 1

var snake_position:= Vector2i(5, 5)
var snake_color := Vector2i(4,0) #green!

var apple_position : Vector2i
var apple_color := Vector2i(3, 0)


func _ready():
	new_game()
	timer.start()

#to make a snake, we need to make a certain tile on the tilemap green
func _process(delta):
	
	if not game_over():
		if Input.is_action_pressed("ui_left"): #0, 1, 2, 3 is left, up, right, down
			if dir != 2:
				dir = 0
		elif Input.is_action_pressed("ui_up"):
			if dir != 3:
				dir = 1
		elif Input.is_action_pressed("ui_right"):
			if dir != 0:
				dir = 2
		elif Input.is_action_pressed("ui_down"):
			if dir != 1:
				dir = 3
		
		#snake only moves after user input
		if(dir != -1):
			steps[dir] += speed
		
		for i in range(steps.size()):
			if steps[i] > steps_req:
				move_piece(directions[i])
				steps[i] = 0
		
		#check to see if the snake eats an apple
		if snake_position == apple_position:
			snake_length += 1
			create_apple()
	
	if game_over():
		erase_cell(active_layer, apple_position)
		if timer.time_left < 0.75 and timer.time_left > 0.75/2:
			set_layer_enabled(active_layer, true)
			print("2!")
		
		elif timer.time_left < 0.75/2 and timer.time_left > 0.0:
			set_layer_enabled(active_layer, false)
			print("1!")
		
func new_game():
	create_snake()
	create_apple()

func move_piece(dir):
	previous_positions.append(snake_position)
	clear_piece()
	snake_position += dir
	draw_piece(1, snake_position, snake_color) # seem to only need a 1 here

#snake_length * directions[dir]
func clear_piece(): #we need to delay clearing the piece depending on how long the snake is
	for i in 1:
		erase_cell(active_layer, previous_positions[previous_positions.size() - snake_length]) #got this working!

func draw_piece(piece, pos, color):
	for i in piece:
		set_cell(active_layer, pos, tile_id, color)

func create_snake():
	steps = [0, 0, 0, 0]
	draw_piece(1, snake_position, snake_color)

func create_apple():
	apple_position = make_random_location()
	draw_piece(1, apple_position, apple_color)

func make_random_location(): #in rare cases, this can still spawn an apple on top of the snake, too lazy to fix
	var rand_vect := Vector2i(randi_range(0, 14), randi_range(0, 14))
	for i in snake_length - 1:
		if rand_vect == previous_positions[previous_positions.size() - i - 1]:
			rand_vect = Vector2i(randi_range(0, 14), randi_range(0, 14))
			pass
	
	return rand_vect

func game_over():
	#if the snake hits a border
	if snake_position.x > 14 or snake_position.x < 0 or snake_position.y < 0 or snake_position.y > 14:
		return true
	
	#if the snake hits itself
	for i in snake_length - 1:
		if snake_position == previous_positions[previous_positions.size() - i - 1]:
			return true
	
	
	
	return false



func _on_timer_timeout():
	print("bruh!")
