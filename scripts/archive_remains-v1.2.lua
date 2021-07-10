-- Remains v1.2

local watermark = true

local on,off = true,false

-- Toggle with On/Off
local config = {
	Zombie_ESP = {
		Enabled = on,
		FillBG = on,
		Color = {50,200,75}, -- Choose a RGB Color or "Rainbow"
		Tracers = false,
	},
	Zombie_Aimbot = {
		Enabled = on,
		FOVEnabled = on, -- If OFF then it'll aim at anything on screen.
		FOV = 180,
		ShowFOV = on,
		Smoothing = 1,
		Sensitivity = 3,
		Aimtype = "Mouse", -- "Mouse" or "Distance"
	},
	Pickups_ESP = {
		Enabled = on,
		dots = on,
		names = on,
		namescolor = on,
	},
}
local pickups_config = {
Ammo = {Blacklisted = 0, Color = {28,128,78},Name="Ammo"},
BodyArmor = {Blacklisted = 0, Color = {180,180,180},Name="Body Armor"},
Frag = {Blacklisted = 0, Color = {0,155,0},Name="Frag"},
ClapBomb = {Blacklisted = 0, Color = {100,255,0},Name="Clap Bomb"},
Molotov = {Blacklisted = 0, Color = {255,255,0},Name="Molotov"},
Medkit = {Blacklisted = 0, Color = {255,0,255},Name="Medkit"},
Bandages = {Blacklisted = 1, Color = {255,0,100},Name="Bandages"},
EnergyDrink = {Blacklisted = 0, Color = {255,255,0},Name="Energy Drink"},
Jack = {Blacklisted = 1, Color = {255,255,0},Name="Jack"},
BarbedWire = {Blacklisted = 1, Color = {100,100,100},Name="Barbed Wire"},
Cal50 = {Blacklisted = 0, Color = {0,255,255},Name="50 Cal"},
}

local Datamodel = dx9.GetDatamodel()
local Workspace = dx9.FindFirstChild(Datamodel, "Workspace")
local closest = nil
local mouse = dx9.GetMouse()

--Functions
function checkpickup(name)
    for i,v in pairs(pickups_config) do
        if v.Name == name then
            return v
        end
    end
    return {Blacklisted = 1, Color = {0,0,0},Name="Unknown Item"}
end

function fill(startpos,endpos,color,gap)
	if gap < 0.5 then gap = 0.5 end
	local comp = (endpos[2]-startpos[2])
	for i=0,comp/gap do
		dx9.DrawLine({startpos[1],startpos[2]+(i*gap)},{endpos[1]+(1),startpos[2]+(i*gap)},{color[1],color[2],color[3]})
	end
end

-- Fill({x,y},{x,y},{r,g,b},gap)
-- Gap in Fill() should often be used to simulate slight transparency.

function getdist(pos1,pos2)
    return math.sqrt((pos1.x-pos2.x)^2+(pos1.y-pos2.y)^2)
end


-- Zombie Stuff
local Ents = dx9.FindFirstChild(Workspace, "Entities")
local NPCs = dx9.GetChildren(dx9.FindFirstChild(Ents, "Infected"))
for i,v in next, NPCs do
    local head = dx9.FindFirstChild(v, "Head")
    local pos = dx9.GetPosition(head)
    local pos1 = dx9.WorldToScreen({pos.x,pos.y,pos.z})
    local epos1 = dx9.WorldToScreen({pos.x,pos.y-2,pos.z})
    local dist = math.max(math.min(((epos1.y-pos1.y)/3),50),0)
    if pos1.x ~= 0 then
        if config.Zombie_ESP.Enabled == true then
			local color = config.Zombie_ESP.Color
			if type(color) == "string" then
				local siner = (math.sin((os.clock()+1)*4)+1)/2
				local sineg = (math.sin((os.clock()+2)*4)+1)/2
				local sineb = (math.sin((os.clock()+3)*4)+1)/2
				color = {siner*255,sineg*255,sineb*255}
			end
			if config.Zombie_ESP.Tracers == true then
				local centerx = dx9.size().width/2
				local bottomy = dx9.size().height
				dx9.DrawLine({pos1.x,pos1.y},{centerx,bottomy},color)
			end
			dx9.DrawBox({pos1.x-dist,pos1.y-dist},{pos1.x+dist,pos1.y+dist},color)
			if config.Zombie_ESP.FillBG == true then
				fill({pos1.x-dist,pos1.y-dist},{pos1.x+dist,pos1.y+dist},color,.5)
			end
		end
	if config.Zombie_Aimbot.Enabled == true then
		local mdist = getdist(pos1,mouse)
			if mdist < config.Zombie_Aimbot.FOV or not config.Zombie_Aimbot.FOVEnabled then
				if closest == nil then
					closest = {position=pos1,distance=mdist,size=dist}
				else
					if config.Zombie_Aimbot.Aimtype == "Mouse" then
						if closest.distance > mdist then
							closest = {position=pos1,distance=mdist,size=dist}
						end
					elseif config.Zombie_Aimbot.Aimtype == "Distance" then
						if closest.size < dist then
							closest = {position=pos1,distance=mdist,size=dist}
						end
					end
				end
			end
		end
	end
end

if config.Zombie_Aimbot.ShowFOV == true and config.Zombie_Aimbot.FOVEnabled == true then
	dx9.DrawCircle({mouse.x,mouse.y},{255,255,255},config.Zombie_Aimbot.FOV)
end

if config.Pickups_ESP.Enabled == true then
    local World = dx9.FindFirstChild(Workspace, "Ignore")
    local Objectives = dx9.GetChildren(dx9.FindFirstChild(World, "Items"))
    for i,v in next, Objectives do
        local check = checkpickup(dx9.GetName(v))
        if check.Blacklisted == 0 then
            local part = dx9.FindFirstChild(v, "Box")
            local pos = dx9.GetPosition(part)
            local pos1 = dx9.WorldToScreen({pos.x,pos.y,pos.z})
            local color = check.Color
            if pos1.x ~= 0 then
                if config.Pickups_ESP.dots == true then
                    dx9.DrawCircle({pos1.x,pos1.y},{color[1],color[2],color[3]},1)
                end
                if config.Pickups_ESP.names == true then
                    if config.Pickups_ESP.namescolor == true then
                        dx9.DrawString({pos1.x, pos1.y},{color[1],color[2],color[3]},check.Name)
                    else
                        dx9.DrawString({pos1.x, pos1.y},{255,255,255},check.Name)
                    end
                end
	    end
        end
    end
end

if watermark then
    local sine = (math.sin(os.clock()*2)+1)/2
    local col = sine*255
    local str="Remains - v1.2"
	fill({0,0},{100,14},{0,0,0},1.65)
    dx9.DrawString({1,2},{0,0,0},str)
    dx9.DrawString({1,0},{255,0,0},str)
end

if config.Zombie_Aimbot.Enabled == true then
	if closest then
		dx9.FirstPersonAim({closest.position.x,closest.position.y},config.Zombie_Aimbot.Sensitivity,config.Zombie_Aimbot.Smoothing)
	end
end