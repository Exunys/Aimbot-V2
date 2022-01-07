getgenv().WallHack.Visuals = {
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

getgenv().WallHack.Crosshair = {
    CrosshairSettings = {
        Enabled = true,
        Type = 1, -- 1 - Mouse; 2 - Center
        Color = "255, 255, 255",
        Transparency = 1,
        Thickness = 1,
        Size = 20
    },

    Parts = {
        X = getgenv().WallHack.Crosshair.CrosshairSettings.Parts.X,
        Y = getgenv().WallHack.Crosshair.CrosshairSettings.Parts.Y
    }
}

getgenv().WallHack.Settings = {
    SendNotifications = true,
    SaveSettings = true, -- Re-execute upon changing
    ReloadOnTeleport = true,
    Enabled = true,
    TeamCheck = false,
    AliveCheck = true
}

getgenv().WallHack.Functions:Restart()
