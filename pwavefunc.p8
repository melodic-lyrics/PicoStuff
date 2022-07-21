pico-8 cartridge // http://www.pico-8.com
version 36
__lua__

left,right,up,down,fire1,fire2=0,1,2,3,4,5
black,dark_blue,dark_purple,dark_green,brown,dark_gray,light_gray,white,red,orange,yellow,green,blue,indigo,pink,peach=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
width, height = 128,128
tile_width, tile_height = width \ 8, height \ 8
d_sprites = {
	{id = 1, edges = {0, 0, 0, 0}},
	{id = 2, edges = {1, 0, 0, 0}},
	{id = 3, edges = {0, 1, 0, 0}},
	{id = 4, edges = {0, 0, 1, 0}},
	{id = 5, edges = {0, 0, 0, 1}},
	{id = 6, edges = {1, 0, 0, 1}},
	{id = 7, edges = {1, 1, 0, 0}},
	{id = 8, edges = {0, 1, 1, 0}},
	{id = 9, edges = {0, 0, 1, 1}},
	{id = 10, edges = {0, 1, 1, 1}},
	{id = 11, edges = {1, 0, 1, 1}},
	{id = 12, edges = {1, 1, 0, 1}},
	{id = 13, edges = {1, 1, 1, 0}},
	{id = 14, edges = {1, 0, 1, 0}},
	{id = 15, edges = {0, 1, 0, 1}},
	{id = 16, edges = {1, 1, 1, 1}},
}

function create_tile(index, location, sprites, assign)
	add(screen_grid,{
		index = index,
		location = location,
		sprite = sprites,
		assigned = assign,
	})
end

function is_empty(t)
	for _,_ in pairs(t) do
		return false
	end
	return true
end

function deepcopy(orig)
	local orig_type = type(orig)
	local copy
		if orig_type == 'table' then
			copy = {}
			for orig_key, orig_value in next, orig, nil do
				copy[deepcopy(orig_key)] = deepcopy(orig_value)
			end
			setmetatable(copy, deepcopy(getmetatable(orig)))
		else -- number, string, boolean, etc
			copy = orig
		end
	return copy
end

function clean_nils(t) --get rid of nil values in tables
 local ans = {}
 for _,v in pairs(t) do
  ans[ #ans+1 ] = v
 end
 return ans
end

function assign_sprite()
	p_tiles = {} --Initialize seperate tracking table
	entropy = #d_sprites + 1 --Set Starting Entropy One higher then total possibilities
	--Filter lowest entropy tiles into a seperate table for tracking
	for tile in all(screen_grid) do
		if tile.assigned == false and #tile.sprite == entropy then
			add(p_tiles, tile) -- If tile has the same entropy, gets added
		elseif tile.assigned == false and #tile.sprite < entropy then
			p_tiles = {tile} -- If lower, list gets wiped with tile as first entry
			entropy = #tile.sprite --lower entropy
		end
	end -- Tiles with greater entropy ignored

	if is_empty(p_tiles) == false then -- Check if there are tiles to collapse
		index = rnd(p_tiles).index -- Pick a tile to collapse
		screen_grid[index].sprite = rnd(screen_grid[index].sprite) -- Collapse Tile
		t_up, t_down, t_left, t_right = index - tile_height, index + tile_height, index - 1, index + 1 -- Set referenced index values	
		screen_grid[index].assigned = true -- Flip Flag

		--Adjust Entropy
		--Up
		if t_up > 0 and screen_grid[t_up].assigned == false then -- Check if tile is out of bounds or has already collapsed.
			t_spr = {}
			for spr in all(screen_grid[t_up].sprite) do -- Iterate through available sprites in that tile
				if screen_grid[index].sprite.edges[1] == spr.edges[3] then -- Check if sprite has same edge on the appropriate side
					add(t_spr, spr)
				end	
			end
			if is_empty(t_spr) == false then
				screen_grid[t_up].sprite = deepcopy(t_spr)
			end
		end
		--Right
		if t_right <= #screen_grid and screen_grid[t_right].assigned == false then
			t_spr = {}
			for spr in all(screen_grid[t_right].sprite) do
				if screen_grid[index].sprite.edges[2] == spr.edges[4] then
					add(t_spr, spr)
				end	
			end
			if is_empty(t_spr) == false then
				screen_grid[t_right].sprite = deepcopy(t_spr)
			end
		end
		--Down
		if t_down <= #screen_grid and screen_grid[t_down].assigned == false then
			t_spr = {}
			for spr in all(screen_grid[t_down].sprite) do
				if screen_grid[index].sprite.edges[3] == spr.edges[1] then
					add(t_spr, spr)
				end	
			end
			if is_empty(t_spr) == false then
				screen_grid[t_down].sprite = deepcopy(t_spr)
			end
		end
		--Left
		if t_left > 0 and screen_grid[t_left].assigned == false then
			t_spr = {}
			for spr in all(screen_grid[t_left].sprite) do
				if screen_grid[index].sprite.edges[4] == spr.edges[2] then
					add(t_spr, spr)
				end	
			end
			if is_empty(t_spr) == false then
				screen_grid[t_left].sprite = deepcopy(t_spr)
			end
		end
	end
end

function _init()
	a = 0
	screen_grid = {}
	for i=0, (tile_width * tile_height) - 1 do
		create_tile(i + 1, {x = i % tile_width, y = i \ tile_height}, d_sprites, false)
	end
end

function _update60()
	assign_sprite()
end

function _draw()
	cls()
	map()
	for tile in all(screen_grid) do
		if tile.assigned then
			mset(tile.location.x, tile.location.y, tile.sprite.id)
		end
	end

end

__gfx__
00000000111111111117711111111111111111111111111111177111111771111111111111111111111111111117711111177111111771111117711111111111
00000000111111111117711111111111111111111111111111177111111771111111111111111111111111111117711111177111111771111117711111111111
00000000111111111117711111111111111111111111111111177111111771111111111111111111111111111117711111177111111771111117711111111111
00000000111111111117711111177777111771117777711177777111111777771117777777777111777777777777711177777777111777771117711177777777
00000000111111111117711111177777111771117777711177777111111777771117777777777111777777777777711177777777111777771117711177777777
00000000111111111111111111111111111771111111111111111111111111111117711111177111111771111117711111111111111771111117711111111111
00000000111111111111111111111111111771111111111111111111111111111117711111177111111771111117711111111111111771111117711111111111
00000000111111111111111111111111111771111111111111111111111111111117711111177111111771111117711111111111111771111117711111111111
11177111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11177111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11177111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11177111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11177111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11177111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
