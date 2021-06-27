-- this one is currently modified for ZOMBIES RECOIL

-- Coded by Lock the hobo that steals your trash
local settings = {
	['Aimbot'] = {
		['enabled'] = true,
		['offset'] = {
			['x'] = 0,
			['y'] = 0,
		},

		['show_fov'] = true, -- false > off | true > on
		['fov_size'] = 220, 
		['fov_color'] = {255,255,255},


		['smoothness'] = 1,
		['sensitivity'] = 2,

		['target_dot'] = true, -- false > off | true > on
		['target_dot_size'] = 3,
		['target_dot_color'] = {100,100,255},
	},

	['Esp'] = {
		['enabled'] = true, -- false > off | true > on

		['tracer'] = false, -- false > off | true > on
		['tracer_color'] = {100,100,255},

		['name'] = true,
		['name_custom_text'] = 'Zombie',
		['name_offset'] = {20,-7},
		['name_color'] = {100,100,255},

		['head_dot'] = true, -- false > off | true > on
		['head_dot_size'] = 1,
		['head_dot_color'] = {255,255,255},
	},

	['Npc Path'] = { -- the path from game to the folder/model where the npc is located and you can make it select more then one model/folder
		[1] = {'Workspace','ClientZambies'},
	}, 
	['In Npc Path'] = {'Head'}, -- the path from the npc model to the target part
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

		local head = gtffc(b,settings['In Npc Path'])
		if head then 
			local headpos = v.GetPosition(head)
			local headwts = v.WorldToScreen({headpos.x,headpos.y, headpos.z})
			local headwts2 = {headwts.x,headwts.y}
			local distance2 = caldist(headwts,mouse,false)

			if (headwts.x > 0 or headwts.y > 0) then
				if closest ~= nil then 
					if closest.dis > distance2 and distance2 < settings['Aimbot']['fov_size']  then 
						closest = {
							pos = headpos,
							pos2 = headwts,
							dis = distance2,
						}
					end
				else 
					if distance2 < settings['Aimbot']['fov_size'] then 
						closest = {
							pos = headpos,
							pos2 = headwts,
							dis = distance2,
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