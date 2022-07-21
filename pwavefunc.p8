pico-8 cartridge // http://www.pico-8.com
version 36
__lua__

left,right,up,down,fire1,fire2=0,1,2,3,4,5
black,dark_blue,dark_purple,dark_green,brown,dark_gray,light_gray,white,red,orange,yellow,green,blue,indigo,pink,peach=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
width, height = 128,128
tile_width, tile_height = width \ 8, height \ 8
sprite_edges = {
	--{up, right, down, left}
	{0, 0, 0, 0},
	{0, 1, 1, 1},
	{1, 1, 0, 1},
	{1, 0, 1, 1},
	{1, 1, 1, 0}
}

function create_tile(index, location, sprites, assign)
	add(screen_grid,{
		index = index,
		location = location,
		sprite = sprites,
		assigned = assign,
		edges = {},
	})
end

function is_empty(t)
	for _,_ in pairs(t) do
		return false
	end
	return true
end

function assign_sprite()
	p_tiles = {}
	entropy = 10

	for tile in all(screen_grid) do

		if tile.assigned == false and #tile.sprite == entropy then
			add(p_tiles, tile)
		elseif tile.assigned == false and #tile.sprite < entropy then
			p_tiles = {tile}
			entropy = #tile.sprite
		end

	end

	if is_empty(p_tiles) == false then
		index = rnd(p_tiles).index
		screen_grid[index].sprite = rnd(screen_grid[index].sprite)
		screen_grid[index].assigned = true
		screen_grid[index].edges = sprite_edges[screen_grid[index].sprite]

		if screen_grid[index].sprite == nil then
			screen_grid[index].sprite = 0
		else

			--Adjust Entropy
			--Up
			if index - tile_height > 0 and screen_grid[index - tile_height].assigned == false then
				if screen_grid[index].edges[1] == 1 then 
					del(screen_grid[index - tile_height].sprite, 1)
					del(screen_grid[index - tile_height].sprite, 3)

				else
					del(screen_grid[index - tile_height].sprite, 2)
					del(screen_grid[index - tile_height].sprite, 4)
					del(screen_grid[index - tile_height].sprite, 5)
				end
			end

			--Right
			if index + 1 <= #screen_grid and screen_grid[index + 1].assigned == false then
				if screen_grid[index].edges[2] == 1 then 
					del(screen_grid[index + 1].sprite, 1)
					del(screen_grid[index + 1].sprite, 5)
				else
					del(screen_grid[index + 1].sprite, 2)
					del(screen_grid[index + 1].sprite, 3)
					del(screen_grid[index + 1].sprite, 4)
				end
			end

			--Down
			if index + tile_height <= #screen_grid and screen_grid[index + tile_height].assigned == false then
				if screen_grid[index].edges[3] == 1 then 
					del(screen_grid[index + tile_height].sprite, 1)
					del(screen_grid[index + tile_height].sprite, 2)
				else
					del(screen_grid[index + tile_height].sprite, 3)
					del(screen_grid[index + tile_height].sprite, 4)
					del(screen_grid[index + tile_height].sprite, 5)
				end
			end

			--Left
			if index - 1 > 0 and screen_grid[index - 1].assigned == false then
				if screen_grid[index].edges[4] == 1 then 
					del(screen_grid[index - 1].sprite, 1)
					del(screen_grid[index - 1].sprite, 4)
				else
					del(screen_grid[index - 1].sprite, 2)
					del(screen_grid[index - 1].sprite, 3)
					del(screen_grid[index - 1].sprite, 5)
				end
			end
		end

	end

end

function _init()
	screen_grid = {}
	for i=0, (tile_width * tile_height) - 1 do
		create_tile(i + 1, {x = i % tile_width, y = i \ tile_height}, {1, 2, 3, 4, 5}, false)
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
			mset(tile.location.x, tile.location.y, tile.sprite)
		end
	end

end

__gfx__
00000000111111111111111111177111111771111117711100000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111111111111111177111111771111117711100000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111111111111111177111111771111117711100000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111117777777777777777777771111117777700000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111117777777777777777777771111117777700000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111111117711111111111111771111117711100000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111111117711111111111111771111117711100000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111111117711111111111111771111117711100000000000000000000000000000000000000000000000000000000000000000000000000000000
