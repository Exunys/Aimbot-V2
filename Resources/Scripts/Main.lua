--// Preventing Multiple Processes

pcall(function()
    getgenv().Aimbot.Functions:Exit()
end)

--// Environment

getgenv().Aimbot = {}
local Environment = getgenv().Aimbot

--// Services

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Camera = game:GetService("Workspace").CurrentCamera

--// Variables

local LocalPlayer = Players.LocalPlayer
local Title = "Exunys Developer"
local FileNames = {"Aimbot", "Configuration.json", "Drawing.json"}
local RequiredDistance = math.huge
local Typing = false
local Running = false
local Animation = nil
local ServiceConnections = {RenderSteppedConnection = nil, InputBeganConnection = nil, InputEndedConnection = nil, TypingStartedConnection = nil, TypingEndedConnection = nil}

--// Script Settings

Environment.Settings = {
    SendNotifications = true,
    SaveSettings = true, -- Re-execute upon changing
    ReloadOnTeleport = true,
    Enabled = true,
    TeamCheck = false,
    AliveCheck = true,
    WallCheck = false, -- Laggy
    Sensitivity = 0, -- Animation length (in seconds) before fully locking onto target
    TriggerKey = "MouseButton2",
    Toggle = false,
    LockPart = "Head" -- Body part to lock on, AND WILL BE OVERWRITTEN IN GAMES SUCH AS PHANTOM FORCES TO HEAD
}

Environment.FOVSettings = {
    Enabled = true,
    Visible = true,
    Amount = 90,
    Color = "255, 255, 255",
    LockedColor = "255, 70, 70",
    Transparency = 0.5,
    Sides = 60,
    Thickness = 1,
    Filled = false
}

Environment.FOVCircle = Drawing.new("Circle")
Environment.Locked = nil

--// Core Functions

local function Encode(Table)
    if Table and type(Table) == "table" then
        local EncodedTable = HttpService:JSONEncode(Table)

        return EncodedTable
    end
end

local function Decode(String)
    if String and type(String) == "string" then
        local DecodedTable = HttpService:JSONDecode(String)

        return DecodedTable
    end
end

local function GetColor(Color)
    local R = tonumber(string.match(Color, "([%d]+)[%s]*,[%s]*[%d]+[%s]*,[%s]*[%d]+"))
    local G = tonumber(string.match(Color, "[%d]+[%s]*,[%s]*([%d]+)[%s]*,[%s]*[%d]+"))
    local B = tonumber(string.match(Color, "[%d]+[%s]*,[%s]*[%d]+[%s]*,[%s]*([%d]+)"))

    return Color3.fromRGB(R, G, B)
end

local function SendNotification(TitleArg, DescriptionArg, DurationArg)
    if Environment.Settings.SendNotifications then
        StarterGui:SetCore("SendNotification", {
            Title = TitleArg,
            Text = DescriptionArg,
            Duration = DurationArg
        })
    end
end

--// Functions

local function SaveSettings()
    if Environment.Settings.SaveSettings then
        if isfile(Title.."/"..FileNames[1].."/"..FileNames[2]) then
            writefile(Title.."/"..FileNames[1].."/"..FileNames[2], Encode(Environment.Settings))
        end

        if isfile(Title.."/"..FileNames[1].."/"..FileNames[3]) then
            writefile(Title.."/"..FileNames[1].."/"..FileNames[3], Encode(Environment.FOVSettings))
        end
    end
end


local function peformPlayerManipulation(v,t) 
    if v.Name == game.Players.LocalPlayer.Name then return end
    if v:FindFirstChild("Humanoid") ~= nil then
        if Environment.Settings.AliveCheck and v.Humanoid.Health <= 0 then return end
    end
    if Environment.Settings.TeamCheck and t == LocalPlayer.Team then return end 
    if Environment.Settings.WallCheck and #(Camera:GetPartsObscuringTarget({v[Environment.Settings.LockPart].Position}, v:GetDescendants())) > 0 then return end
    local Vector, OnScreen = Camera:WorldToViewportPoint(v[Environment.Settings.LockPart].Position)
    local Distance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(Vector.X, Vector.Y)).Magnitude
    if Distance < RequiredDistance and OnScreen then
        RequiredDistance = Distance
        Environment.Locked = v
    end
end
local placeSupport = { -- modularly made by ExportedLocal
{292439477,function()
    SendNotification("Not supported","This game is not supported due to the heavy lock on the camera.")
    getgenv().Aimbot.Functions:Exit()
end}
}
local function GetClosestPlayer()
    if Environment.Locked == nil then
        if Environment.FOVSettings.Enabled then 
            RequiredDistance = Environment.FOVSettings.Amount
        else
            RequiredDistance = math.huge
        end
        
        local defaultAttainted = false
        for index = 1, #placeSupport do
            local v = placeSupport[index]
            if game.PlaceId == v[1] then 
                v[2](); defaultAttainted = true; 
            end
        end
        if defaultAttainted == false then
            for _,v in pairs(game.Players:GetChildren()) do
                pcall(function()
                    peformPlayerManipulation(v.Character,v.Team)
                end)
            end
        end
    elseif (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(Camera:WorldToViewportPoint(Environment.Locked[Environment.Settings.LockPart].Position).X, Camera:WorldToViewportPoint(Environment.Locked[Environment.Settings.LockPart].Position).Y)).Magnitude > RequiredDistance then
        Environment.Locked = nil
        Animation:Cancel()
        Environment.FOVCircle.Color = GetColor(Environment.FOVSettings.Color)
    end
end

--// Typing Check

ServiceConnections.TypingStartedConnection = UserInputService.TextBoxFocused:Connect(function()
    Typing = true
end)

ServiceConnections.TypingEndedConnection = UserInputService.TextBoxFocusReleased:Connect(function()
    Typing = false
end)

--// Create, Save & Load Settings

if Environment.Settings.SaveSettings then
    if not isfolder(Title) then
        makefolder(Title)
    end

    if not isfolder(Title.."/"..FileNames[1]) then
        makefolder(Title.."/"..FileNames[1])
    end

    if not isfile(Title.."/"..FileNames[1].."/"..FileNames[2]) then
        writefile(Title.."/"..FileNames[1].."/"..FileNames[2], Encode(Environment.Settings))
    else
        Environment.Settings = Decode(readfile(Title.."/"..FileNames[1].."/"..FileNames[2]))
    end

    if not isfile(Title.."/"..FileNames[1].."/"..FileNames[3]) then
        writefile(Title.."/"..FileNames[1].."/"..FileNames[3], Encode(Environment.FOVSettings))
    else
        Environment.Visuals = Decode(readfile(Title.."/"..FileNames[1].."/"..FileNames[3]))
    end

    coroutine.wrap(function()
        while wait(10) do
            SaveSettings()
        end
    end)()
else
    if isfolder(Title) then
        delfolder(Title)
    end
end

local function Load()
    ServiceConnections.RenderSteppedConnection = RunService.RenderStepped:Connect(function()
        if Environment.FOVSettings.Enabled and Environment.Settings.Enabled then
            Environment.FOVCircle.Radius = Environment.FOVSettings.Amount
            Environment.FOVCircle.Thickness = Environment.FOVSettings.Thickness
            Environment.FOVCircle.Filled = Environment.FOVSettings.Filled
            Environment.FOVCircle.NumSides = Environment.FOVSettings.Sides
            Environment.FOVCircle.Color = GetColor(Environment.FOVSettings.Color)
            Environment.FOVCircle.Transparency = Environment.FOVSettings.Transparency
            Environment.FOVCircle.Visible = Environment.FOVSettings.Visible
            Environment.FOVCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
        else
            Environment.FOVCircle.Visible = false
        end

        if Running and Environment.Settings.Enabled then
            GetClosestPlayer()

            if Environment.Settings.Sensitivity > 0 then
                Animation = TweenService:Create(Camera, TweenInfo.new(Environment.Settings.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, Environment.Locked.Character[Environment.Settings.LockPart].Position)})
                Animation:Play()
            else
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, Environment.Locked[Environment.Settings.LockPart].Position)
            end

            Environment.FOVCircle.Color = GetColor(Environment.FOVSettings.LockedColor)
        end
    end)

    ServiceConnections.InputBeganConnection = UserInputService.InputBegan:Connect(function(Input)
        if not Typing then
            pcall(function()
                if Input.KeyCode == Enum.KeyCode[Environment.Settings.TriggerKey] then
                    if Environment.Settings.Toggle then
                        Running = not Running

                        if not Running then
                            Environment.Locked = nil
                            Animation:Cancel()
                            Environment.FOVCircle.Color = GetColor(Environment.FOVSettings.Color)
                        end
                    else
                        Running = true
                    end
                end
            end)

            pcall(function()
                if Input.UserInputType == Enum.UserInputType[Environment.Settings.TriggerKey] then
                    if Environment.Settings.Toggle then
                        Running = not Running

                        if not Running then
                            Environment.Locked = nil
                            Animation:Cancel()
                            Environment.FOVCircle.Color = GetColor(Environment.FOVSettings.Color)
                        end
                    else
                        Running = true
                    end
                end
            end)
        end
    end)

    ServiceConnections.InputEndedConnection = UserInputService.InputEnded:Connect(function(Input)
        if not Typing then
            pcall(function()
                if Input.KeyCode == Enum.KeyCode[Environment.Settings.TriggerKey] then
                    if not Environment.Settings.Toggle then
                        Running = false
                        Environment.Locked = nil
                        Animation:Cancel()
                        Environment.FOVCircle.Color = GetColor(Environment.FOVSettings.Color)
                    end
                end
            end)

            pcall(function()
                if Input.UserInputType == Enum.UserInputType[Environment.Settings.TriggerKey] then
                    if not Environment.Settings.Toggle then
                        Running = false
                        Environment.Locked = nil
                        Animation:Cancel()
                        Environment.FOVCircle.Color = GetColor(Environment.FOVSettings.Color)
                    end
                end
            end)
        end
    end)
end

--// Functions

Environment.Functions = {}

function Environment.Functions:Exit()
    SaveSettings()

    for _, v in next, ServiceConnections do
        v:Disconnect()
    end

    Environment.FOVCircle:Remove()

    getgenv().Aimbot.Functions = nil
    getgenv().Aimbot = nil
end

function Environment.Functions:Restart()
    SaveSettings()

    for _, v in next, ServiceConnections do
        v:Disconnect()
    end

    Environment.FOVCircle:Remove()

    Load()
end

function Environment.Functions:ResetSettings()
    Environment.Settings = {
        SendNotifications = true,
        SaveSettings = true, -- Re-execute upon changing
        ReloadOnTeleport = true,
        Enabled = true,
        TeamCheck = false,
        AliveCheck = true,
        WallCheck = false,
        Sensitivity = 0, -- Animation length (in seconds) before fully locking onto target
        TriggerKey = "MouseButton2",
        Toggle = false,
        LockPart = "Head" -- Body part to lock on
    }

    Environment.FOVSettings = {
        Enabled = true,
        Visible = true,
        Amount = 90,
        Color = "255, 255, 255",
        LockedColor = "255, 70, 70",
        Transparency = 0.5,
        Sides = 60,
        Thickness = 1,
        Filled = false
    }

    SaveSettings()

    for _, v in next, ServiceConnections do
        v:Disconnect()
    end

    Load()
end

--// Support Check

if not Drawing or not writefile or not makefolder then
    SendNotification(Title, "Your exploit does not support this script", 3); return
end

--// Reload On Teleport

if Environment.Settings.ReloadOnTeleport then
    if syn.queue_on_teleport then
        syn.queue_on_teleport(game:HttpGet("https://pastebin.com/raw/n8wG8BZq"))
    else
        SendNotification(Title, "Your exploit does not support \"syn.queue_on_teleport()\"")
    end
end

--// Load

Load(); SendNotification(Title, "Aimbot script successfully loaded! Check the GitHub page on how to configure the script.", 5)
