local Settings = {
   SilentEnabled = false,
   Iron = false,
  Sulfur = false,
  Stone = false,
   LockedWoodenCrate = false,
   LockedSteelCrate = false,
   LockedMetalCrate = false,
   FoodCrate = false,
   WoodenCrate = false,
   OilBarrel = false,
   TrashCan = false,
   NoRecoil = true,
   NoSpread = false,
   InstantHit = false,
   NoSway = false,
   NoMaxRange = false,
   ESPEnabled = true,
   NameESP = true,
   Health = true,
  SilentFOV = true,
  FOVSides = 24,
  SelectedPart = "Head",
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = game.Workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = cloneref(game:GetService("UserInputService"))
local unit = Mouse.UnitRay

local services = {
   workspaceService = cloneref(game:GetService("Workspace")),
   
}
local ToolNames = {
   ["Bruno's M4A1"] = true, ["Crossbow"] = true, ["Salvaged Shovel"] = true, ["Salvaged Pipe Rifle"] = true,
   ["Steel Axe"] = true, ["Salvaged RPG"] = true, ["Small Medkit"] = true, ["Yellow Keycard"] = true,
   ["Salvaged Pump Action"] = true, ["Pink Keycard"] = true, ["Salvaged SMG"] = true, ["Salvaged AK47"] = true,
   ["Boulder"] = true, ["Care Package Signal"] = true, ["Salvaged AK74u"] = true, ["ez shovel"] = true,
   ["Dynamite Stick"] = true, ["Military Barrett"] = true, ["Nail Gun"] = true, ["Iron Shard Hatchet"] = true,
   ["Military M4A1"] = true, ["Wooden Spear"] = true, ["Dynamite Bundle"] = true, ["Stone Spear"] = true,
   ["Salvaged P250"] = true, ["Iron Shard Pickaxe"] = true, ["Military PKM"] = true, ["Steel Shovel"] = true,
   ["Timed Charge"] = true, ["Steel Pickaxe"] = true, ["Lighter"] = true, ["Blueprint"] = true,
   ["Salvaged M14"] = true, ["Machete"] = true, ["Stone Hatchet"] = true, ["Bandage"] = true,
   ["Saw Bat"] = true, ["Wooden Bow"] = true, ["Military Grenade"] = true, ["Health Pen"] = true,
   ["Candy Cane"] = true, ["Hammer"] = true, ["Military AA12"] = true, ["Salvaged Python"] = true,
   ["Purple Keycard"] = true, ["Bone Tool"] = true, ["Stone Pickaxe"] = true, ["Salvaged Skorpion"] = true,
   ["Salvaged Break Action"] = true
}

local circle = Drawing.new("Circle")
circle.Transparency = 1
circle.Thickness = 2
circle.Color = Color3.fromRGB(231, 84, 128)
circle.Filled = false
circle.Radius = 180
circle.NumSides = Settings.FOVSides
local function updateCircle()
  if (circle) then
       circle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)

       -- // Return circle
       return circle
   end
end
RunService.Heartbeat:Connect(updateCircle)
local function GetPlayerTool(Character)
   for _, v in ipairs(Character:GetChildren()) do
       if ToolNames[v.Name] then 
           return v.Name 
       end
   end
   return "none"
end



local function NewQuad(thickness, color)
   local quad = Drawing.new("Quad")
   quad.Visible = false
   quad.PointA = Vector2.new(0,0)
   quad.PointB = Vector2.new(0,0)
   quad.PointC = Vector2.new(0,0)
   quad.PointD = Vector2.new(0,0)
   quad.Color = color
   quad.Filled = false
   quad.Thickness = thickness
   quad.Transparency = 1
   return quad
end

local function NewLine(thickness, color)
   local line = Drawing.new("Line")
   line.Visible = false
   line.From = Vector2.new(0, 0)
   line.To = Vector2.new(0, 0)
   line.Color = color 
   line.Thickness = thickness
   line.Transparency = 1
   return line
end

local function Visibility(state, lib)
   for u, x in pairs(lib) do
       x.Visible = state
   end
end
local function Remove(lib)
   for u, x in pairs(lib) do
       x:Remove()
   end
end
local function CreateNameTag(size, color)
   local nameTag = Drawing.new("Text")
   nameTag.Visible = false
   nameTag.Center = true
   nameTag.Outline = true
   nameTag.Font = Drawing.Fonts.Plex
   nameTag.Size = size
   nameTag.Color = Color3.new(1, 1, 1)
   return nameTag
end

local function ToColor3(col) --Function to convert, just cuz c;
   local r = col.r --Red value
   local g = col.g --Green value
   local b = col.b --Blue value
   return Color3.new(r,g,b); --Color3 datatype, made of the RGB inputs
end

local black = Color3.fromRGB(0, 0 ,0)
local function ESP(obj, typ, b)
   local library = {
       --//Tracer and Black Tracer(black border)

       --//Bar and Green Health Bar (part that moves up/down)
       healthbar = NewLine(3, black),
       greenhealth = NewLine(1.5, black),
       nameTag = CreateNameTag(15)
   }

   function Updater()
       local connection
       connection = game:GetService("RunService").RenderStepped:Connect(function()
           if typ == "Players" then
               if obj.Character and obj.Character:FindFirstChild("Humanoid") and obj.Character:FindFirstChild("HumanoidRootPart") and obj.Character:FindFirstChild("Head") and obj.Character:FindFirstChild("Humanoid").Health > 0 then
                   local HumPos, OnScreen = Camera:WorldToViewportPoint(obj.Character:FindFirstChild("HumanoidRootPart").Position)
                   if OnScreen and Settings.ESPEnabled then
                       local head = Camera:WorldToViewportPoint(obj.Character:FindFirstChild("Head").Position)
                       local DistanceY = math.clamp((Vector2.new(head.X, head.Y) - Vector2.new(HumPos.X, HumPos.Y)).magnitude, 2, math.huge)
                       
                       

                       if Settings.NameESP then

                           library.nameTag.Position = Vector2.new(HumPos.X, HumPos.Y + DistanceY * 2 + 10) -- Adjust Y position for name tag
                           library.nameTag.Text = obj.Name .. " " .. "(" .. GetPlayerTool(obj.Character) .. ")"
                           library.nameTag.Visible = true
                       else
                           library.nameTag.Visible = false
                       end
                       --//Tracer 

                       if Settings.Health then
                           local d = (Vector2.new(HumPos.X - DistanceY, HumPos.Y - DistanceY*2) - Vector2.new(HumPos.X - DistanceY, HumPos.Y + DistanceY*2)).magnitude 
                           local healthoffset = obj.Character:FindFirstChild("Humanoid").Health/obj.Character:FindFirstChild("Humanoid").MaxHealth * d

                           library.greenhealth.From = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY*2)
                           library.greenhealth.To = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY*2 - healthoffset)

                           library.healthbar.From = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY*2)
                           library.healthbar.To = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y - DistanceY*2)

                           local green = Color3.fromRGB(0, 255, 0)
                           local red = Color3.fromRGB(255, 0, 0)

                           library.greenhealth.Color = red:lerp(green, obj.Character:FindFirstChild("Humanoid").Health/obj.Character:FindFirstChild("Humanoid").MaxHealth);
                           library.healthbar.Visible = true
                           library.greenhealth.Visible = true
                       else
                           library.healthbar.Visible = false
                           library.greenhealth.Visible = false
                       end
                   else 
                       Visibility(false, library)
                   end
               else 
                   Visibility(false, library)
                   Remove(library)
                   connection:Disconnect()
               end
           elseif typ == "Node" then
               if obj and workspace.Nodes:FindFirstChild(obj.Name) and obj:FindFirstChild("Main") then
                   local item_pos, item_onscreen = Camera:WorldToViewportPoint(obj:FindFirstChild("Main").Position)
                   if item_onscreen then
                       if obj.Name == "Stone_Node" and Settings.Stone then
                           library.nameTag.Position = Vector2.new(item_pos.X, item_pos.Y)
                           library.nameTag.Text = "Stone"
                           library.nameTag.Visible = true
                           library.nameTag.Color = Color3.fromRGB(128, 128, 128)
                       elseif obj.Name == "Phosphate_Node" and Settings.Sulfur then
                           library.nameTag.Position = Vector2.new(item_pos.X, item_pos.Y)
                           library.nameTag.Text = "Sulfur"
                           library.nameTag.Visible = true
                           library.nameTag.Color = Color3.fromRGB(255, 255, 0)
                       elseif obj.Name == "Metal_Node" and Settings.Iron then
                           library.nameTag.Position = Vector2.new(item_pos.X, item_pos.Y)
                           library.nameTag.Text = "Iron"
                           library.nameTag.Visible = true
                           library.nameTag.Color = Color3.fromRGB(101, 67, 33)
                       else
                           Visibility(false, library)
                       end
                   else 
                       Visibility(false, library)
                   end
               else 
                   Visibility(false, library)
                   Remove(library)
                   connection:Disconnect()
               end
           elseif typ == "Crate" then
               if obj and workspace.Bases.Loners:FindFirstChild(obj.Name) and obj:FindFirstChild(b.Name) and obj:FindFirstChild(b.Name):FindFirstChild("Main") then
                   local item_pos, item_onscreen = Camera:WorldToViewportPoint(obj:FindFirstChild(b.Name):FindFirstChild("Main").Position)
                   if item_onscreen then
                       if string.match(b.Name, "Locked Metal Crate") and Settings.LockedMetalCrate then
                           library.nameTag.Position = Vector2.new(item_pos.X, item_pos.Y)
                           library.nameTag.Text = "Locked Metal Crate"
                           library.nameTag.Visible = true
                           library.nameTag.Color = Color3.fromRGB(128, 128, 128)
                       elseif string.match(b.Name, "Locked Steel Crate") and Settings.LockedSteelCrate then
                           library.nameTag.Position = Vector2.new(item_pos.X, item_pos.Y)
                           library.nameTag.Text = "Locked Steel Crate"
                           library.nameTag.Visible = true
                           library.nameTag.Color = Color3.fromRGB(0, 0, 0)
                       elseif string.match(b.Name, "Locked Wooden Crate") and Settings.LockedWoodenCrate then
                           library.nameTag.Position = Vector2.new(item_pos.X, item_pos.Y)
                           library.nameTag.Text = "Locked Wooden Crate"
                           library.nameTag.Visible = true
                           library.nameTag.Color = Color3.fromRGB(101, 67, 33)
                       elseif string.match(b.Name, "Wooden Crate") and Settings.WoodenCrate then
                           library.nameTag.Position = Vector2.new(item_pos.X, item_pos.Y)
                           library.nameTag.Text = "Wooden Crate"
                           library.nameTag.Visible = true
                           library.nameTag.Color = Color3.fromRGB(101, 67, 33)
                       elseif string.match(b.Name, "Trash Can") and Settings.TrashCan then
                           library.nameTag.Position = Vector2.new(item_pos.X, item_pos.Y)
                           library.nameTag.Text = "Trash Can"
                           library.nameTag.Visible = true
                           library.nameTag.Color = Color3.fromRGB(128, 128, 128)
                       elseif string.match(b.Name, "Food Crate") and Settings.FoodCrate then
                           library.nameTag.Position = Vector2.new(item_pos.X, item_pos.Y)
                           library.nameTag.Text = "Food Crate"
                           library.nameTag.Visible = true
                           library.nameTag.Color = Color3.fromRGB(255, 255, 0)
                       elseif string.match(b.Name, "Oil Barrel") and Settings.OilBarrel then
                           library.nameTag.Position = Vector2.new(item_pos.X, item_pos.Y)
                           library.nameTag.Text = "Oil Barrel"
                           library.nameTag.Visible = true
                           library.nameTag.Color = Color3.fromRGB(255, 0, 0)
                       else
                           Visibility(false, library)
                       end
                   else 
                       Visibility(false, library)
                   end
               else 
                   Visibility(false, library)
                   Remove(library)
                   connection:Disconnect()
               end
           end
       end)
   end
   coroutine.wrap(Updater)()
end




for i,v in pairs(game.Players:GetPlayers()) do
   if v ~= game.Players.LocalPlayer then
       v.CharacterAdded:connect(function(char)
           char.ChildAdded:connect(function(child)
               if char:FindFirstChild("HumanoidRootPart") then
                   ESP(v, "Players")
               end
           end)
       end)
       if v.Character then
           if v.Character:FindFirstChild("HumanoidRootPart") then
               ESP(v, "Players")
           end
           task.wait()
           v.Character.ChildAdded:connect(function(child)
               if child.Name == "HumanoidRootPart" then
                   ESP(v, "Players")
               end
           end)
       end
   end
end
Players.PlayerAdded:Connect(function(player)
   player.CharacterAdded:Connect(function(cr)
       cr.ChildAdded:connect(function(child)
           if child.Name == "HumanoidRootPart" then
               ESP(player, "Players")
           end
       end)
   end)
end)
