--// Has no teamcheck :troll: \\--
local api = dx9;
local dm = api.GetDatamodel();
local ws = api.FindFirstChild(dm, "Workspace");

local colors =  { 
    r = 255;
    g = 182;
    b = 193;
 };

for _, v in pairs(api.GetChildren(ws)) do 
    if v and api.FindFirstChild(v, "HumanoidRootPart") then
        local hrp = api.FindFirstChild(v, "HumanoidRootPart");
        local hrp_pos = api.GetPosition(hrp);
        local hrp_pos_w2s = api.WorldToScreen({hrp_pos.x, hrp_pos.y, hrp_pos.z});
        if hrp_pos_w2s.x > 1 then
            api.DrawCircle({hrp_pos_w2s.x, hrp_pos_w2s.y}, {colors.r, colors.g, colors.b}, 10);
            api.DrawString({hrp_pos_w2s.x- 25, hrp_pos_w2s.y - 30}, {colors.r, colors.g, colors.b}, api.GetName(v));
        end;
    end;
end;