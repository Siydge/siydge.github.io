
-- this one is currently modified for SCP-TASK-FORCE

-- Coded by Lock the hobo that steals your trash
local settings = {
	['Aimbot'] = {
		['enabled'] = true,
		['max_distance'] = 200,
		['closes_to_crosshair'] = true,
		['offset'] = {
			['x'] = 0,
			['y'] = 0,
		},

		['show_fov'] = true, -- false > off | true > on
		['fov_size'] = 220, 
		['fov_color'] = {255,255,255},


		['smoothness'] = 10,
		['sensitivity'] = 5,

		['target_dot'] = true, -- false > off | true > on
		['target_dot_size'] = 2,
		['target_dot_color'] = {255,100,100},
	},

	['Esp'] = {
		['enabled'] = true, -- false > off | true > on

		['tracer'] = false, -- false > off | true > on
		['tracer_color'] = {100,100,255},

		['name'] = true,
		['name_custom_text'] = '',
		['name_offset'] = {20,-7},
		['name_color'] = {255,255,255},

		['distance'] = false, -- false > off | true > on
		['distance_behind_text'] = ' distance',
		['distance_offset'] = {20,5},
		['distance_color'] = {100,100,255},

		['head_dot'] = true, -- false > off | true > on
		['head_dot_size'] = 1,
		['head_dot_color'] = {255,255,255},
	},

	['Npc Path'] = { -- the path from game to the folder/model where the npc is located and you can make it select more then one model/folder
		[1] = {'Workspace'},
	}, 
	['In Npc Path'] = {}, -- the path from the npc model to the target part
} 

local v = dx9
local player = v.get_localplayer()
local game = v.GetDatamodel()

function caldist(p1,p2,whichvec)
	if whichvec then 
		local a = (p1.x-p2.x)*(p1.x-p2.x)
		local b = (p1.y-p2.y)*(p1.y-p2.y)
		local c = (p1.z-p2.z)*(p1.z-p2.z)
		return math.sqrt(a+b+c)
	else 
		local a = (p1.x-p2.x)*(p1.x-p2.x)
		local b = (p1.y-p2.y)*(p1.y-p2.y)
		return math.sqrt(a+b)
	end
end

function ffc(p1,p2)
	return v.FindFirstChild(p1, p2)
end

function gtffc(pt,pt2)
	local dirpath = nil
	for i,v in next, pt2 do 
		if dirpath == nil then
			dirpath = ffc(pt,v)
		else 
			dirpath = ffc(dirpath,v)
		end 
	end 
	return dirpath
end

local closest = nil
local mouse = v.GetMouse()
local mouse2 = {mouse.x,mouse.y}

function com(d2,d3)
	local a = d3
	if settings['Aimbot']['closes_to_crosshair'] then 
		a = d2
	end 
	return a
end

if settings['Aimbot']['enabled'] and settings['Aimbot']['show_fov'] then
	v.DrawCircle(mouse2,settings['Aimbot']['fov_color'],settings['Aimbot']['fov_size'])
end

function createsetup(loc)

	for a,b in next, v.GetChildren(loc) do 
		local head = gtffc(b,{'HumanoidRootPart'})
		if head then 
			local headpos = v.GetPosition(head)
			local playerpos = player.Position
			local headwts = v.WorldToScreen({headpos.x,headpos.y+2, headpos.z})
			local headwts2 = {headwts.x,headwts.y}
			local distance2 = caldist(headwts,mouse,false)
			local distance3 = caldist(headpos,playerpos,true)

			if (headwts.x > 0 or headwts.y > 0) and distance3 < settings['Aimbot']['max_distance'] and distance3 >= 3 then
				if closest ~= nil then 
					if com(closest.dis,closest.dis3) > com(distance2,distance3) and distance2 < settings['Aimbot']['fov_size']  then 
						closest = {
							pos = headpos,
							pos2 = headwts,
							dis = distance2,
							dis3 = distance3,
						}
					end
				else 
					if distance2 < settings['Aimbot']['fov_size'] then 
						closest = {
							pos = headpos,
							pos2 = headwts,
							dis = distance2,
							dis3 = distance3,
						}
					end
				end
				local setesp = settings['Esp']
				if setesp['enabled'] then 
					
					if setesp['head_dot'] then 
						v.DrawCircle(headwts2,setesp['head_dot_color'],setesp['head_dot_size'])
					end

					if setesp['name'] then 
						local text = v.GetName(b)
						if setesp['name_custom_text'] ~= '' then 
							text = setesp['name_custom_text']
						end 
						v.DrawString({headwts.x+setesp['name_offset'][1],headwts.y+setesp['name_offset'][2]},setesp['name_color'],text)
					end

					if setesp['distance'] then
						local text = math.floor(distance3)
						text = text..setesp['distance_behind_text']
						v.DrawString({headwts.x+setesp['distance_offset'][1],headwts.y+setesp['distance_offset'][2]},setesp['distance_color'],text)
					end

					if setesp['tracer'] then  -- "v.size().width / 2, v.size().height" is from https://cultofintellect.com/dx9ware/docs/lua/examples.html, didn't made it 
						v.DrawLine({v.size().width / 2, v.size().height},headwts2,setesp['tracer_color'])
					end

				end
			end
		end
	end
end

for a,b in next, settings['Npc Path'] do 
	createsetup(gtffc(game,b))
end 

if settings['Aimbot']['enabled'] then 
	v.FirstPersonAim({closest.pos2.x+settings['Aimbot']['offset']['x'],closest.pos2.y+settings['Aimbot']['offset']['y']},settings['Aimbot']['smoothness'],settings['Aimbot']['sensitivity'])
	if settings['Aimbot']['target_dot'] then 
		v.DrawCircle({closest.pos2.x,closest.pos2.y},settings['Aimbot']['target_dot_color'],settings['Aimbot']['target_dot_size'])
	end
end