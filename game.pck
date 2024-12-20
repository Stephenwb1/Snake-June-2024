GDPC                �                                                                         P   res://.godot/exported/133200997/export-609f762188a68253d349ec58c4f3a8d3-game.scn        �      ,mB'�,�}0��s,�l    ,   res://.godot/global_script_class_cache.cfg  �.             ��Р�8���8~$}P�    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex�            ：Qt�E�cO���    X   res://.godot/imported/tetris tileset-export.png-8bf9b66525bb177be1b38ebafaf312f7.ctex   �,            ���,Іm`�_GÌ       res://.godot/uid_cache.bin  �2      d       ��C�Ԃbf���d�       res://game.tscn.remap   �.      a       �?��� �ު��y�       res://game_script.gd       �      4���X,�/���'�       res://icon.svg  /      �      k����X3Y���f       res://icon.svg.import   �+      �       �u�*?�y*�J�oc�	       res://project.binary@3      �      �3�/eR@.�+瞽$    (   res://tetris tileset-export.png.import  �-      �       \����$�@=��	�/    RSRC                    PackedScene            ��������                                            "      resource_local_to_scene    resource_name    texture    margins    separation    texture_region_size    use_texture_padding    0:0/0    0:0/0/script    1:0/0    1:0/0/script    2:0/0    2:0/0/script    3:0/0    3:0/0/script    4:0/0    4:0/0/script    5:0/0    5:0/0/script    6:0/0    6:0/0/script    7:0/0    7:0/0/script    script    tile_shape    tile_layout    tile_offset_axis 
   tile_size    uv_clipping 
   sources/0    tile_proxies/source_level    tile_proxies/coords_level    tile_proxies/alternative_level 	   _bundled    
   Texture2D     res://tetris tileset-export.png ��~Jx�5   Script    res://game_script.gd ��������   !   local://TileSetAtlasSource_fsqi2 �         local://TileSet_e7u4e V         local://PackedScene_cwl30 ~         TileSetAtlasSource                                 	          
                                                                                                               TileSet                          PackedScene    !      	         names "         TileMap    texture_filter    scale 	   tile_set    format    layer_0/name    layer_0/tile_data    layer_1/name    layer_1/tile_data    script    Timer 
   wait_time    _on_timer_timeout    timeout    	   variants    
         
     �@  �@                     board     �                                                                                               	          
                                                                                                            	          
                                                                                                                           	         
                                                                                                                      	         
                                                                                                                               	         
                                                                                                            	         
                                                                                                            	         
                                                                                                            	         
                                                                                                            	         
                                                                                                            	         
                                                                                                            	         
                                                                                                            	         
                                   	         	         	         	         	         	         	         	         	 	        	 
        	         	         	         
         
         
         
         
         
         
         
         
 	        
 
        
         
         
                                                                                  	         
                                                                                                            	         
                                                                                                            	         
                                         active                       @?      node_count             nodes     "   ��������        ����	                                                    	                  
   
   ����      	             conn_count             conns                                      node_paths              editable_instances              version             RSRC  extends TileMap

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
           GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�m�m۬�}�p,��5xi�d�M���)3��$�V������3���$G�$2#�Z��v{Z�lێ=W�~� �����d�vF���h���ڋ��F����1��ڶ�i�엵���bVff3/���Vff���Ҿ%���qd���m�J�}����t�"<�,���`B �m���]ILb�����Cp�F�D�=���c*��XA6���$
2#�E.@$���A.T�p )��#L��;Ev9	Б )��D)�f(qA�r�3A�,#ѐA6��npy:<ƨ�Ӱ����dK���|��m�v�N�>��n�e�(�	>����ٍ!x��y�:��9��4�C���#�Ka���9�i]9m��h�{Bb�k@�t��:s����¼@>&�r� ��w�GA����ը>�l�;��:�
�wT���]�i]zݥ~@o��>l�|�2�Ż}�:�S�;5�-�¸ߥW�vi�OA�x��Wwk�f��{�+�h�i�
4�˰^91��z�8�(��yޔ7֛�;0����^en2�2i�s�)3�E�f��Lt�YZ���f-�[u2}��^q����P��r��v��
�Dd��ݷ@��&���F2�%�XZ!�5�.s�:�!�Њ�Ǝ��(��e!m��E$IQ�=VX'�E1oܪì�v��47�Fы�K챂D�Z�#[1-�7�Js��!�W.3׹p���R�R�Ctb������y��lT ��Z�4�729f�Ј)w��T0Ĕ�ix�\�b�9�<%�#Ɩs�Z�O�mjX �qZ0W����E�Y�ڨD!�$G�v����BJ�f|pq8��5�g�o��9�l�?���Q˝+U�	>�7�K��z�t����n�H�+��FbQ9���3g-UCv���-�n�*���E��A�҂
�Dʶ� ��WA�d�j��+�5�Ȓ���"���n�U��^�����$G��WX+\^�"�h.���M�3�e.
����MX�K,�Jfѕ*N�^�o2��:ՙ�#o�e.
��p�"<W22ENd�4B�V4x0=حZ�y����\^�J��dg��_4�oW�d�ĭ:Q��7c�ڡ��
A>��E�q�e-��2�=Ϲkh���*���jh�?4�QK��y@'�����zu;<-��|�����Y٠m|�+ۡII+^���L5j+�QK]����I �y��[�����(}�*>+���$��A3�EPg�K{��_;�v�K@���U��� gO��g��F� ���gW� �#J$��U~��-��u���������N�@���2@1��Vs���Ŷ`����Dd$R�":$ x��@�t���+D�}� \F�|��h��>�B�����B#�*6��  ��:���< ���=�P!���G@0��a��N�D�'hX�׀ "5#�l"j߸��n������w@ K�@A3�c s`\���J2�@#�_ 8�����I1�&��EN � 3T�����MEp9N�@�B���?ϓb�C��� � ��+�����N-s�M�  ��k���yA 7 �%@��&��c��� �4�{� � �����"(�ԗ�� �t�!"��TJN�2�O~� fB�R3?�������`��@�f!zD��%|��Z��ʈX��Ǐ�^�b��#5� }ى`�u�S6�F�"'U�JB/!5�>ԫ�������/��;	��O�!z����@�/�'�F�D"#��h�a �׆\-������ Xf  @ �q�`��鎊��M��T�� ���0���}�x^�����.�s�l�>�.�O��J�d/F�ě|+^�3�BS����>2S����L�2ޣm�=�Έ���[��6>���TъÞ.<m�3^iжC���D5�抺�����wO"F�Qv�ږ�Po͕ʾ��"��B��כS�p�
��E1e�������*c�������v���%'ž��&=�Y�ް>1�/E������}�_��#��|������ФT7׉����u������>����0����緗?47�j�b^�7�ě�5�7�����|t�H�Ե�1#�~��>�̮�|/y�,ol�|o.��QJ rmϘO���:��n�ϯ�1�Z��ը�u9�A������Yg��a�\���x���l���(����L��a��q��%`�O6~1�9���d�O{�Vd��	��r\�՜Yd$�,�P'�~�|Z!�v{�N�`���T����3?DwD��X3l �����*����7l�h����	;�ߚ�;h���i�0�6	>��-�/�&}% %��8���=+��N�1�Ye��宠p�kb_����$P�i�5�]��:��Wb�����������ě|��[3l����`��# -���KQ�W�O��eǛ�"�7�Ƭ�љ�WZ�:|���є9�Y5�m7�����o������F^ߋ������������������Р��Ze�>�������������?H^����&=����~�?ڭ�>���Np�3��~���J�5jk�5!ˀ�"�aM��Z%�-,�QU⃳����m����:�#��������<�o�����ۇ���ˇ/�u�S9��������ٲG}��?~<�]��?>��u��9��_7=}�����~����jN���2�%>�K�C�T���"������Ģ~$�Cc�J�I�s�? wڻU���ə��KJ7����+U%��$x�6
�$0�T����E45������G���U7�3��Z��󴘶�L�������^	dW{q����d�lQ-��u.�:{�������Q��_'�X*�e�:�7��.1�#���(� �k����E�Q��=�	�:e[����u��	�*�PF%*"+B��QKc˪�:Y��ـĘ��ʴ�b�1�������\w����n���l镲��l��i#����!WĶ��L}rեm|�{�\�<mۇ�B�HQ���m�����x�a�j9.�cRD�@��fi9O�.e�@�+�4�<�������v4�[���#bD�j��W����֢4�[>.�c�1-�R�����N�v��[�O�>��v�e�66$����P
�HQ��9���r�	5FO� �<���1f����kH���e�;����ˆB�1C���j@��qdK|
����4ŧ�f�Q��+�     [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://dsxy7wdpumnd0"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
                GST2   �         ����               �         �   RIFF�   WEBPVP8L�   /� pZ۶�� ��f�*�*I:��
�+Ho��n�ȶ�lG� �W�%P�"�CAR��ڶ�hw( ��IFƍ��������E8�A��7��|yŧ�W���v�w� �f��:@؞Izt�:�����"�)�&�o�\#����"��dw�l�a���9��u�/N ��	��:�� lO'@�s'l?    [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://busfqa8g2ghpt"
path="res://.godot/imported/tetris tileset-export.png-8bf9b66525bb177be1b38ebafaf312f7.ctex"
metadata={
"vram_texture": false
}
               [remap]

path="res://.godot/exported/133200997/export-609f762188a68253d349ec58c4f3a8d3-game.scn"
               list=Array[Dictionary]([])
     <svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 814 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H446l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z" fill="#478cbf"/><path d="M483 600c0 34 58 34 58 0v-86c0-34-58-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
              �)�<��'   res://game.tscns�V�_�u   res://icon.svg��~Jx�5   res://tetris tileset-export.png            ECFG      application/config/name         snake      application/run/main_scene         res://game.tscn    application/config/features$   "         4.2    Forward Plus       application/config/icon         res://icon.svg  "   display/window/size/viewport_width      8  #   display/window/size/viewport_height      8     display/window/stretch/mode         viewport         