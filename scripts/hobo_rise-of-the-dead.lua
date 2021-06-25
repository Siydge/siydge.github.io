local v = dx9
local game = v.GetDatamodel()

local settings = {
    ['aimbot_fov'] = 50, 
    ['aimbot_smoothness'] = 1,
    ['aimbot_sensitivity'] = 2,
}

function caldist(p1,p2)
    local a = (p1.x-p2.x)
    return math.sqrt(a ^ 2 + a ^ 2 )
end

function ffc(p1,p2)
    return v.FindFirstChild(p1, p2)
end

local workspace = ffc(game, "Workspace")

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


local npcs = ffc(workspace,'Entity')

local closest = nil
local mouse = v.GetMouse()

for a,b in next, v.GetChildren(npcs) do 
    local mainhead = ffc(b,'Head')

    if mainhead then 
        local headpos = v.GetPosition(mainhead)
        local headwts = v.WorldToScreen({headpos.x,headpos.y, headpos.z})
        local distance = caldist(headwts,mouse)

        if (headwts.x > 0 or headwts.y > 0) then
            
            if closest ~= nil then 
                if closest.dis > distance and distance < settings['aimbot_fov'] then 
                    closest = {
                        pos = headpos,
                        pos2 = headwts,
                        dis = distance
                    }
                end
            else 
                if distance < settings['aimbot_fov'] then 
                    closest = {
                        pos = headpos,
                        pos2 = headwts,
                        dis = distance
                    }
                end
            end

            v.DrawCircle(
                {headwts.x,headwts.y}, -- Circle pos
                {255,255,255}, -- Circle rbg/color
                2 -- Circle size
            )
            v.DrawString(
                {headwts.x+7,headwts.y-7}, -- String rbg/color
                {255,255,255}, -- String rbg/color
                v.GetName(b) -- String text
            )
        end
    end
end

if closest then 
    v.FirstPersonAim(
        {closest.pos2.x,closest.pos2.y}, -- Aim pos
        settings['aimbot_smoothness'], -- Aimbot Smoothness
        settings['aimbot_sensitivity'] -- Aimbot Sensitivity
    )
    v.DrawCircle(
        {closest.pos2.x,closest.pos2.y}, -- Circle pos
        {255,25,25}, -- Circle rbg/color
        5 -- Circle size
    )
end