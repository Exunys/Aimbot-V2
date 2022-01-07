--// Preventing Multiple Processes

pcall(function()
    getgenv().WallHack.Functions:Exit()
end)

--// Environment

getgenv().WallHack = {}
local Environment = getgenv().WallHack

--// Services

local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Camera = game:GetService("Workspace").CurrentCamera

--// Variables

local LocalPlayer = Players.LocalPlayer
local Title = "Exunys Developer"
local FileNames = {"Wall Hack", "Settings.json", "Visuals.json", "Crosshair.json"}
local ServiceConnections = {PlayerAddedConnection = nil, PlayerRemovingConnection = nil, CrosshairConnection = nil}

--// Script Settings

Environment.WrappedPlayers = {}

Environment.Settings = {
    SendNotifications = true,
    SaveSettings = true, -- Re-execute upon changing
    ReloadOnTeleport = true,
    Enabled = true,
    TeamCheck = false,
    AliveCheck = true
}

--// Wall Hack

local function GetColor(Color)
    local R = tonumber(string.match(Color, "([%d]+)[%s]*,[%s]*[%d]+[%s]*,[%s]*[%d]+"))
    local G = tonumber(string.match(Color, "[%d]+[%s]*,[%s]*([%d]+)[%s]*,[%s]*[%d]+"))
    local B = tonumber(string.match(Color, "[%d]+[%s]*,[%s]*[%d]+[%s]*,[%s]*([%d]+)"))

    return Color3.fromRGB(R, G, B)
end

Environment.Visuals = {
    ESPSettings = {
        Enabled = true,
        TextColor = "30, 100, 255",
        TextSize = 14,
        Center = true,
        Outline = true,
        OutlineColor = "0, 0, 0",
        TextTransparency = 0.7,
        TextFont = Drawing.Fonts.Monospace, -- UI, System, Plex, Monospace
        DisplayDistance = true,
        DisplayHealth = true,
        DisplayName = true
    },

    TracersSettings = {
        Enabled = true,
        Type = 1, -- 1 - Bottom; 2 - Center; 3 - Mouse
        Transparency = 0.7,
        Thickness = 1,
        Color = "50, 120, 255"
    },

    BoxSettings = {
        Enabled = true,
        Type = 1; -- 1 - 3D; 2 - 2D;
        Color = "50, 120, 255",
        Transparency = 0.7,
        Thickness = 1,
        Filled = false, -- For 2D
        Increase = 1
    },

    HeadDotSettings = {
        Enabled = true,
        Color = "50, 120, 255",
        Transparency = 0.5,
        Thickness = 1,
        Filled = true,
        Sides = 30,
        Size = 2
    }
}

Environment.Crosshair = {
    CrosshairSettings = {
        Enabled = true,
        Type = 1, -- 1 - Mouse; 2 - Center
        Color = "255, 255, 255",
        Transparency = 1,
        Thickness = 1,
        Size = 20
    },

    Parts = {
        X = Drawing.new("Line"),
        Y = Drawing.new("Line")
    }
}

local function AddESP(Player)
    local PlayerTable = nil

    for _, v in next, Environment.WrappedPlayers do
        if v.Name == Player.Name then
            PlayerTable = v
        end
    end

    PlayerTable.ESP = Drawing.new("Text")

    PlayerTable.Connections.ESP = nil; PlayerTable.Connections.ESP = RunService.RenderStepped:Connect(function()
        if Player.Character and Player.Character.Humanoid and Environment.Settings.Enabled then
            local Vector, OnScreen = Camera:WorldToViewportPoint(Player.Character.Head.Position)

            PlayerTable.ESP.Visible = Environment.Visuals.ESPSettings.Enabled

            local function UpdateESP()
                PlayerTable.ESP.Size = Environment.Visuals.ESPSettings.TextSize
                PlayerTable.ESP.Center = Environment.Visuals.ESPSettings.Center
                PlayerTable.ESP.Outline = Environment.Visuals.ESPSettings.Outline
                PlayerTable.ESP.OutlineColor = GetColor(Environment.Visuals.ESPSettings.OutlineColor)
                PlayerTable.ESP.Color = GetColor(Environment.Visuals.ESPSettings.TextColor)
                PlayerTable.ESP.Transparency = Environment.Visuals.ESPSettings.TextTransparency
                PlayerTable.ESP.Font = Environment.Visuals.ESPSettings.TextFont

                PlayerTable.ESP.Position = Vector2.new(Vector.X, Vector.Y - 25)

                local Parts = {
                    Health = "("..tostring(Player.Character.Humanoid.Health)..")",
                    Distance = "["..tostring(math.floor((Player.Character.HumanoidRootPart.Position - (LocalPlayer.Character.HumanoidRootPart.Position or Vector3.new(0, 0, 0))).Magnitude)).."]",
                    Name = Player.Name
                }

                local Content = ""

                if Environment.Visuals.ESPSettings.DisplayName then
                    Content = Parts.Name..Content
                end

                if Environment.Visuals.ESPSettings.DisplayHealth then
                    if Environment.Visuals.ESPSettings.DisplayName then
                        Content = Parts.Health.." "..Content
                    else
                        Content = Parts.Health..Content
                    end
                end

                if Environment.Visuals.ESPSettings.DisplayDistance then
                    Content = Content.." "..Parts.Distance
                end

                PlayerTable.ESP.Text = Content
            end

            if OnScreen then
                if Environment.Visuals.ESPSettings.Enabled then
                    if Environment.Settings.TeamCheck and Player.TeamColor ~= LocalPlayer.TeamColor then
                        PlayerTable.ESP.Visible = true
                    elseif Environment.Settings.TeamCheck and Player.TeamColor == LocalPlayer.TeamColor then
                        PlayerTable.ESP.Visible = false
                    elseif not Environment.Settings.TeamCheck then
                        PlayerTable.ESP.Visible = true
                    end

                    if Environment.Settings.AliveCheck and Player.Character.Humanoid.Health > 0 then
                        PlayerTable.ESP.Visible = true
                    elseif Environment.Settings.AliveCheck and Player.Character.Humanoid.Health <= 0 then
                        PlayerTable.ESP.Visible = false
                    elseif not Environment.Settings.AliveCheck then
                        Player.ESP.Visible = true
                    end

                    if PlayerTable.ESP.Visible then
                        UpdateESP()
                    end
                end
            else
                PlayerTable.ESP.Visible = false
            end
        else
            PlayerTable.ESP.Visible = false
        end
    end)
end

local function AddTracer(Player)
    local PlayerTable = nil

    for _, v in next, Environment.WrappedPlayers do
        if v.Name == Player.Name then
            PlayerTable = v
        end
    end

    PlayerTable.Tracer = Drawing.new("Line")

    PlayerTable.Connections.Tracer = nil; PlayerTable.Connections.Tracer = RunService.RenderStepped:Connect(function()
        if Player.Character and Player.Character.Humanoid and Environment.Settings.Enabled then
            local HRPCFrame, HRPSize = Player.Character.HumanoidRootPart.CFrame, Player.Character.HumanoidRootPart.Size
            local Vector, OnScreen = Camera:WorldToViewportPoint(HRPCFrame * CFrame.new(0, -HRPSize.Y, 0).Position)

            PlayerTable.Tracer.Visible = Environment.Visuals.TracersSettings.Enabled

            local function UpdateTracer()
                PlayerTable.Tracer.Thickness = Environment.Visuals.TracersSettings.Thickness
                PlayerTable.Tracer.Color = GetColor(Environment.Visuals.TracersSettings.Color)
                PlayerTable.Tracer.Transparency = Environment.Visuals.TracersSettings.Transparency

                PlayerTable.Tracer.To = Vector2.new(Vector.X, Vector.Y)

                if Environment.Visuals.TracersSettings.Type == 1 then
                    PlayerTable.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                elseif Environment.Visuals.TracersSettings.Type == 2 then
                    PlayerTable.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                elseif Environment.Visuals.TracersSettings.Type == 3 then
                    PlayerTable.Tracer.From = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                else
                    PlayerTable.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                end
            end

            if OnScreen then
                if Environment.Visuals.TracersSettings.Enabled then
                    if Environment.Settings.TeamCheck and Player.TeamColor ~= LocalPlayer.TeamColor then
                        PlayerTable.Tracer.Visible = true
                    elseif Environment.Settings.TeamCheck and Player.TeamColor == LocalPlayer.TeamColor then
                        PlayerTable.Tracer.Visible = false
                    elseif not Environment.Settings.TeamCheck then
                        PlayerTable.Tracer.Visible = true
                    end

                    if Environment.Settings.AliveCheck and Player.Character.Humanoid.Health > 0 then
                        PlayerTable.Tracer.Visible = true
                    elseif Environment.Settings.AliveCheck and Player.Character.Humanoid.Health <= 0 then
                        PlayerTable.Tracer.Visible = false
                    elseif not Environment.Settings.AliveCheck then
                        Player.Tracer.Visible = true
                    end

                    if PlayerTable.Tracer.Visible then
                        UpdateTracer()
                    end
                end
            else
                PlayerTable.Tracer.Visible = false
            end
        else
            PlayerTable.Tracer.Visible = false
        end
    end)
end

local function AddBox(Player)
    local PlayerTable = nil

    for _, v in next, Environment.WrappedPlayers do
        if v.Name == Player.Name then
            PlayerTable = v
        end
    end

    PlayerTable.Box.Square = Drawing.new("Square")

    PlayerTable.Box.TopLeftLine = Drawing.new("Line")
    PlayerTable.Box.TopLeftLine = Drawing.new("Line")
    PlayerTable.Box.TopRightLine = Drawing.new("Line")
    PlayerTable.Box.BottomLeftLine = Drawing.new("Line")
    PlayerTable.Box.BottomRightLine = Drawing.new("Line")

    PlayerTable.Connections.Box = nil; PlayerTable.Connections.Box = RunService.RenderStepped:Connect(function()
        if Player.Character and Player.Character.Humanoid and Environment.Settings.Enabled then
            local Vector, OnScreen = Camera:WorldToViewportPoint(Player.Character.HumanoidRootPart.Position)

            local HRPCFrame, HRPSize = Player.Character.HumanoidRootPart.CFrame, Player.Character.HumanoidRootPart.Size * Environment.Visuals.BoxSettings.Increase

            local TopLeftPosition = Camera:WorldToViewportPoint(HRPCFrame * CFrame.new(HRPSize.X,  HRPSize.Y, 0).Position)
            local TopRightPosition = Camera:WorldToViewportPoint(HRPCFrame * CFrame.new(-HRPSize.X,  HRPSize.Y, 0).Position)
            local BottomLeftPosition = Camera:WorldToViewportPoint(HRPCFrame * CFrame.new(HRPSize.X, -HRPSize.Y, 0).Position)
            local BottomRightPosition = Camera:WorldToViewportPoint(HRPCFrame * CFrame.new(-HRPSize.X, -HRPSize.Y, 0).Position)

            local HeadOffset = Camera:WorldToViewportPoint(Player.Character.Head.Position + Vector3.new(0, 0.5, 0))
			local LegsOffset = Camera:WorldToViewportPoint(Player.Character.HumanoidRootPart.Position - Vector3.new(0, 3, 0))

            local function Visibility(Bool)
                if Environment.Visuals.BoxSettings.Type == 1 then
                    PlayerTable.Box.Square.Visible = not Bool

                    PlayerTable.Box.TopLeftLine.Visible = Bool
                    PlayerTable.Box.TopRightLine.Visible = Bool
                    PlayerTable.Box.BottomLeftLine.Visible = Bool
                    PlayerTable.Box.BottomRightLine.Visible = Bool
                elseif Environment.Visuals.BoxSettings.Type == 2 then
                    PlayerTable.Box.Square.Visible = Bool

                    PlayerTable.Box.TopLeftLine.Visible = not Bool
                    PlayerTable.Box.TopRightLine.Visible = not Bool
                    PlayerTable.Box.BottomLeftLine.Visible = not Bool
                    PlayerTable.Box.BottomRightLine.Visible = not Bool
                end
            end

            local function Visibility2(Bool)
                if Environment.Visuals.BoxSettings.Type == 1 then
                    PlayerTable.Box.Square.Visible = Bool

                    PlayerTable.Box.TopLeftLine.Visible = Bool
                    PlayerTable.Box.TopRightLine.Visible = Bool
                    PlayerTable.Box.BottomLeftLine.Visible = Bool
                    PlayerTable.Box.BottomRightLine.Visible = Bool
                elseif Environment.Visuals.BoxSettings.Type == 2 then
                    PlayerTable.Box.Square.Visible = Bool

                    PlayerTable.Box.TopLeftLine.Visible = Bool
                    PlayerTable.Box.TopRightLine.Visible = Bool
                    PlayerTable.Box.BottomLeftLine.Visible = Bool
                    PlayerTable.Box.BottomRightLine.Visible = Bool
                end
            end

            Visibility(Environment.Visuals.BoxSettings.Enabled)

            local function Update2DBox()
                PlayerTable.Box.Square.Thickness = Environment.Visuals.BoxSettings.Thickness
                PlayerTable.Box.Square.Color = GetColor(Environment.Visuals.BoxSettings.Color)
                PlayerTable.Box.Square.Transparency = Environment.Visuals.BoxSettings.Transparency
                PlayerTable.Box.Square.Filled = Environment.Visuals.BoxSettings.Filled

                PlayerTable.Box.Square.Size = Vector2.new(2000 / Vector.Z, HeadOffset.Y - LegsOffset.Y)
				PlayerTable.Box.Square.Position = Vector2.new(Vector.X - PlayerTable.Box.Square.Size.X / 2, Vector.Y - PlayerTable.Box.Square.Size.Y / 2)
            end

            local function Update3DBox()
                PlayerTable.Box.TopLeftLine.Thickness = Environment.Visuals.BoxSettings.Thickness
                PlayerTable.Box.TopLeftLine.Transparency = Environment.Visuals.BoxSettings.Transparency
                PlayerTable.Box.TopLeftLine.Color = GetColor(Environment.Visuals.BoxSettings.Color)

                PlayerTable.Box.TopRightLine.Thickness = Environment.Visuals.BoxSettings.Thickness
                PlayerTable.Box.TopRightLine.Transparency = Environment.Visuals.BoxSettings.Transparency
                PlayerTable.Box.TopRightLine.Color = GetColor(Environment.Visuals.BoxSettings.Color)

                PlayerTable.Box.BottomLeftLine.Thickness = Environment.Visuals.BoxSettings.Thickness
                PlayerTable.Box.BottomLeftLine.Transparency = Environment.Visuals.BoxSettings.Transparency
                PlayerTable.Box.BottomLeftLine.Color = GetColor(Environment.Visuals.BoxSettings.Color)

                PlayerTable.Box.BottomRightLine.Thickness = Environment.Visuals.BoxSettings.Thickness
                PlayerTable.Box.BottomRightLine.Transparency = Environment.Visuals.BoxSettings.Transparency
                PlayerTable.Box.BottomRightLine.Color = GetColor(Environment.Visuals.BoxSettings.Color)

                PlayerTable.Box.TopLeftLine.From = Vector2.new(TopLeftPosition.X, TopLeftPosition.Y)
                PlayerTable.Box.TopLeftLine.To = Vector2.new(TopRightPosition.X, TopRightPosition.Y)

                PlayerTable.Box.TopRightLine.From = Vector2.new(TopRightPosition.X, TopRightPosition.Y)
                PlayerTable.Box.TopRightLine.To = Vector2.new(BottomRightPosition.X, BottomRightPosition.Y)

                PlayerTable.Box.BottomLeftLine.From = Vector2.new(BottomLeftPosition.X, BottomLeftPosition.Y)
                PlayerTable.Box.BottomLeftLine.To = Vector2.new(TopLeftPosition.X, TopLeftPosition.Y)

                PlayerTable.Box.BottomRightLine.From = Vector2.new(BottomRightPosition.X, BottomRightPosition.Y)
                PlayerTable.Box.BottomRightLine.To = Vector2.new(BottomLeftPosition.X, BottomLeftPosition.Y)
            end

            if OnScreen then
                if Environment.Visuals.BoxSettings.Enabled then
                    if Environment.Settings.TeamCheck and Player.TeamColor ~= LocalPlayer.TeamColor then
                        Visibility(true)
                    elseif Environment.Settings.TeamCheck and Player.TeamColor == LocalPlayer.TeamColor then
                        Visibility2(false)
                    elseif not Environment.Settings.TeamCheck then
                        Visibility(true)
                    end

                    if Environment.Settings.AliveCheck and Player.Character.Humanoid.Health > 0 then
                        Visibility(true)
                    elseif Environment.Settings.AliveCheck and Player.Character.Humanoid.Health <= 0 then
                        Visibility2(false)
                    elseif not Environment.Settings.AliveCheck then
                        Visibility(true)
                    end

                    if PlayerTable.Box.Square.Visible and not PlayerTable.Box.TopLeftLine.Visible and not PlayerTable.Box.TopRightLine.Visible and not PlayerTable.Box.BottomLeftLine.Visible and not PlayerTable.Box.BottomRightLine.Visible then
                        Update2DBox()
                    elseif not PlayerTable.Box.Square.Visible and PlayerTable.Box.TopLeftLine.Visible and PlayerTable.Box.TopRightLine.Visible and PlayerTable.Box.BottomLeftLine.Visible and PlayerTable.Box.BottomRightLine.Visible then
                        Update3DBox()
                    end
                end
            else
                PlayerTable.Box.Square.Visible = false
                PlayerTable.Box.TopLeftLine.Visible = false
                PlayerTable.Box.TopRightLine.Visible = false
                PlayerTable.Box.BottomLeftLine.Visible = false
                PlayerTable.Box.BottomRightLine.Visible = false
            end
        else
            PlayerTable.Box.Square.Visible = false
            PlayerTable.Box.TopLeftLine.Visible = false
            PlayerTable.Box.TopRightLine.Visible = false
            PlayerTable.Box.BottomLeftLine.Visible = false
            PlayerTable.Box.BottomRightLine.Visible = false
        end
    end)
end

local function AddHeadDot(Player)
    local PlayerTable = nil

    for _, v in next, Environment.WrappedPlayers do
        if v.Name == Player.Name then
            PlayerTable = v
        end
    end

    PlayerTable.HeadDot = Drawing.new("Circle")

    PlayerTable.Connections.HeadDot = nil; PlayerTable.Connections.HeadDot = RunService.RenderStepped:Connect(function()
        if Player.Character and Player.Character.Humanoid and Environment.Settings.Enabled then
            local Vector, OnScreen = Camera:WorldToViewportPoint(Player.Character.Head.Position)

            PlayerTable.HeadDot.Visible = Environment.Visuals.HeadDotSettings.Enabled

            local function UpdateHeadDot()
                PlayerTable.HeadDot.Thickness = Environment.Visuals.HeadDotSettings.Thickness
                PlayerTable.HeadDot.Color = GetColor(Environment.Visuals.HeadDotSettings.Color)
                PlayerTable.HeadDot.Transparency = Environment.Visuals.HeadDotSettings.Transparency
                PlayerTable.HeadDot.NumSides = Environment.Visuals.HeadDotSettings.Sides
                PlayerTable.HeadDot.Filled = Environment.Visuals.HeadDotSettings.Filled
                PlayerTable.HeadDot.Radius = Environment.Visuals.HeadDotSettings.Size

                PlayerTable.HeadDot.Position = Vector2.new(Vector.X, Vector.Y)
            end

            if OnScreen then
                if Environment.Visuals.HeadDotSettings.Enabled then
                    if Environment.Settings.TeamCheck and Player.TeamColor ~= LocalPlayer.TeamColor then
                        PlayerTable.HeadDot.Visible = true
                    elseif Environment.Settings.TeamCheck and Player.TeamColor == LocalPlayer.TeamColor then
                        PlayerTable.HeadDot.Visible = false
                    elseif not Environment.Settings.TeamCheck then
                        PlayerTable.HeadDot.Visible = true
                    end

                    if Environment.Settings.AliveCheck and Player.Character.Humanoid.Health > 0 then
                        PlayerTable.HeadDot.Visible = true
                    elseif Environment.Settings.AliveCheck and Player.Character.Humanoid.Health <= 0 then
                        PlayerTable.HeadDot.Visible = false
                    elseif not Environment.Settings.AliveCheck then
                        Player.HeadDot.Visible = true
                    end

                    if PlayerTable.HeadDot.Visible then
                        UpdateHeadDot()
                    end
                end
            else
                PlayerTable.HeadDot.Visible = false
            end
        else
            PlayerTable.HeadDot.Visible = false
        end
    end)
end

local function AddCrosshair()
    ServiceConnections.CrosshairConnection = RunService.RenderStepped:Connect(function()
        local RealSize = Environment.Crosshair.CrosshairSettings.Size / 2

        Environment.Crosshair.Parts.X.Color = GetColor(Environment.Crosshair.CrosshairSettings.Color)
        Environment.Crosshair.Parts.X.Thickness = Environment.Crosshair.CrosshairSettings.Thickness
        Environment.Crosshair.Parts.X.Transparency = Environment.Crosshair.CrosshairSettings.Transparency

        Environment.Crosshair.Parts.Y.Color = GetColor(Environment.Crosshair.CrosshairSettings.Color)
        Environment.Crosshair.Parts.Y.Thickness = Environment.Crosshair.CrosshairSettings.Thickness
        Environment.Crosshair.Parts.Y.Transparency = Environment.Crosshair.CrosshairSettings.Transparency

        if Environment.Settings.Enabled then
            Environment.Crosshair.Parts.X.Visible = Environment.Crosshair.CrosshairSettings.Enabled
            Environment.Crosshair.Parts.Y.Visible = Environment.Crosshair.CrosshairSettings.Enabled
        else
            Environment.Crosshair.Parts.X.Visible = false
            Environment.Crosshair.Parts.Y.Visible = false
        end

        if Environment.Crosshair.CrosshairSettings.Type == 1 then
            Environment.Crosshair.Parts.X.From = Vector2.new(UserInputService:GetMouseLocation().X - RealSize, UserInputService:GetMouseLocation().Y)
            Environment.Crosshair.Parts.X.To = Vector2.new(UserInputService:GetMouseLocation().X + RealSize, UserInputService:GetMouseLocation().Y)

            Environment.Crosshair.Parts.Y.From = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y - RealSize)
            Environment.Crosshair.Parts.Y.To = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y + RealSize)
        elseif Environment.Crosshair.CrosshairSettings.Type == 2 then
            Environment.Crosshair.Parts.X.From = Vector2.new((Camera.ViewportSize.X / 2) - RealSize, (Camera.ViewportSize.Y / 2))
            Environment.Crosshair.Parts.X.To = Vector2.new((Camera.ViewportSize.X / 2) + RealSize, (Camera.ViewportSize.Y / 2))

            Environment.Crosshair.Parts.Y.From = Vector2.new((Camera.ViewportSize.X / 2), (Camera.ViewportSize.Y / 2) - RealSize)
            Environment.Crosshair.Parts.Y.To = Vector2.new((Camera.ViewportSize.X / 2), (Camera.ViewportSize.Y / 2) + RealSize)
        else
            Environment.Crosshair.CrosshairSettings.Type = 1
        end
    end)
end

--// Functions

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

local function SaveSettings()
    if isfile(Title.."/"..FileNames[1].."/"..FileNames[2]) then
        writefile(Title.."/"..FileNames[1].."/"..FileNames[2], Encode(Environment.Settings))
    end

    if isfile(Title.."/"..FileNames[1].."/"..FileNames[3]) then
        writefile(Title.."/"..FileNames[1].."/"..FileNames[3], Encode(Environment.Visuals))
    end

    if isfile(Title.."/"..FileNames[1].."/"..FileNames[4]) then
        writefile(Title.."/"..FileNames[1].."/"..FileNames[4], Encode(Environment.Crosshair.CrosshairSettings))
    end
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

local function Wrap(Player)
    local Value = {Name = Player.Name, Connections = {}, ESP = nil, Tracer = nil, HeadDot = nil, Box = {Square = nil, TopLeftLine = nil, TopRightLine = nil, BottomLeftLine = nil, BottomRightLine = nil}}
    local Table = nil

    for _, v in next, Environment.WrappedPlayers do
        if v[1] == Player.Name then
            Table = v
        end
    end

    if not Table then
        table.insert(Environment.WrappedPlayers, 1, Value)
        AddESP(Player)
        AddTracer(Player)
        AddBox(Player)
        AddHeadDot(Player)
        AddCrosshair()
    end
end

local function UnWrap(Player)
    local Table, Index = nil, nil

    for i, v in next, Environment.WrappedPlayers do
        if v.Name == Player.Name then
            Table, Index = v, i
        end
    end

    if Table then
        for _, v in next, Table.Connections do
            v:Disconnect()
        end

        Table.ESP:Remove()
        Table.Tracer:Remove()
        Table.HeadDot:Remove()

        Table.Box.Square:Remove()
        Table.Box.TopLeftLine:Remove()
        Table.Box.TopRightLine:Remove()
        Table.Box.BottomLeftLine:Remove()
        Table.Box.BottomRightLine:Remove()

        Environment.WrappedPlayers[Index] = nil
    end
end

local function Load()
    for _, v in next, Players:GetPlayers() do
        if v ~= LocalPlayer then
            UnWrap(v)
        end
    end

    for _, v in next, Players:GetPlayers() do
        if v ~= LocalPlayer then
            Wrap(v)
        end
    end

    ServiceConnections.PlayerAddedConnection = Players.PlayerAdded:Connect(function(v)
        if v ~= LocalPlayer then
            Wrap(v)
        end
    end)

    ServiceConnections.PlayerRemovingConnection = Players.PlayerRemoving:Connect(function(v)
        if v ~= LocalPlayer then
            UnWrap(v)
        else
            SaveSettings()
        end
    end)
end

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
        writefile(Title.."/"..FileNames[1].."/"..FileNames[3], Encode(Environment.Visuals))
    else
        Environment.Visuals = Decode(readfile(Title.."/"..FileNames[1].."/"..FileNames[3]))
    end

    if not isfile(Title.."/"..FileNames[1].."/"..FileNames[4]) then
        writefile(Title.."/"..FileNames[1].."/"..FileNames[4], Encode(Environment.Crosshair.CrosshairSettings))
    else
        Environment.Crosshair.CrosshairSettings = Decode(readfile(Title.."/"..FileNames[1].."/"..FileNames[4]))
    end

    coroutine.wrap(function()
        while wait(10) do
            if isfile(Title.."/"..FileNames[1].."/"..FileNames[2]) then
                writefile(Title.."/"..FileNames[1].."/"..FileNames[2], Encode(Environment.Settings))
            end

            if isfile(Title.."/"..FileNames[1].."/"..FileNames[3]) then
                writefile(Title.."/"..FileNames[1].."/"..FileNames[3], Encode(Environment.Visuals))
            end

            if isfile(Title.."/"..FileNames[1].."/"..FileNames[4]) then
                writefile(Title.."/"..FileNames[1].."/"..FileNames[4], Encode(Environment.Crosshair.CrosshairSettings))
            end
        end
    end)()
else
    if isfolder(Title) then
        delfolder(Title)
    end
end

--// API Check

if not Drawing then
    SendNotification(Title, "Your exploit does not support this script", 3); return
end

if not writefile then
    SendNotification(Title, "Your exploit does not support this script", 3); return
end

if not makefolder then
    SendNotification(Title, "Your exploit does not support this script", 3); return
end

--// Reload On Teleport

if Environment.Settings.ReloadOnTeleport then
    if syn.queue_on_teleport then
        syn.queue_on_teleport(game:HttpGet("https://pastebin.com/raw/uqb2dYE9"))
    else
        SendNotification(Title, "Your exploit does not support \"syn.queue_on_teleport()\"")
    end
end

--// Script Functions

Environment.Functions = {}

function Environment.Functions:Restart()
    SaveSettings()

    for _, v in next, Players:GetPlayers() do
        if v ~= LocalPlayer then
            UnWrap(v)
        end
    end

    for _, v in next, ServiceConnections do
        v:Disconnect()
    end

    ServiceConnections.CrosshairConnection:Disconnect()

    Environment.Crosshair.Parts.X:Remove()
    Environment.Crosshair.Parts.Y:Remove()

    Load()
end

function Environment.Functions:Exit()
    SaveSettings()

    for _, v in next, Players:GetPlayers() do
        if v ~= LocalPlayer then
            UnWrap(v)
        end
    end

    for _, v in next, ServiceConnections do
        v:Disconnect()
    end

    ServiceConnections.CrosshairConnection:Disconnect()

    Environment.Crosshair.Parts.X:Remove()
    Environment.Crosshair.Parts.Y:Remove()

    getgenv().WallHack.Functions = nil
    getgenv().WallHack = nil
end

function Environment.Functions:ResetSettings()
    Environment.Visuals = {
        ESPSettings = {
            Enabled = true,
            TextColor = "20, 90, 255",
            TextSize = 14,
            Center = true,
            Outline = true,
            OutlineColor = "0, 0, 0",
            TextTransparency = 0.7,
            TextFont = Drawing.Fonts.Monospace, -- UI, System, Plex, Monospace
            DisplayDistance = true,
            DisplayHealth = true,
            DisplayName = true
        },

        TracersSettings = {
            Enabled = true,
            Type = 1, -- 1 - Bottom; 2 - Center; 3 - Mouse
            Transparency = 0.7,
            Thickness = 1,
            Color = "50, 120, 255"
        },

        BoxSettings = {
            Enabled = true,
            Type = 1; -- 1 - 3D; 2 - 2D;
            Color = "50, 120, 255",
            Transparency = 0.7,
            Thickness = 1,
            Filled = false, -- For 2D
            Increase = 1
        },

        HeadDotSettings = {
            Enabled = true,
            Color = "50, 120, 255",
            Transparency = 0.5,
            Thickness = 1,
            Filled = true,
            Sides = 30,
            Size = 2
        }
    }

    Environment.Crosshair = {
        CrosshairSettings = {
            Enabled = true,
            Type = 1, -- 1 - Mouse; 2 - Center
            Color = "255, 255, 255",
            Transparency = 1,
            Thickness = 1,
            Size = 20
        },

        Parts = {
            X = Environment.Crosshair.CrosshairSettings.Parts.X,
            Y = Environment.Crosshair.CrosshairSettings.Parts.Y
        }
    }

    Environment.Settings = {
        SendNotifications = true,
        SaveSettings = true, -- Re-execute upon changing
        ReloadOnTeleport = true,
        Enabled = true,
        TeamCheck = false,
        AliveCheck = true
    }

    SaveSettings()

    for _, v in next, Players:GetPlayers() do
        if v ~= LocalPlayer then
            UnWrap(v)
        end
    end

    for _, v in next, ServiceConnections do
        v:Disconnect()
    end

    ServiceConnections.CrosshairConnection:Disconnect()

    Environment.Crosshair.Parts.X:Remove()
    Environment.Crosshair.Parts.Y:Remove()

    Load()
end

--// Main

Load(); SendNotification(Title, "Visuals script successfully loaded! Check the GitHub page on how to configure the script.", 5)
