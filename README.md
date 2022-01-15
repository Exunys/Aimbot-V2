# Aimbot V2
## Information
This script is a universal aim-locking script. Works on all games which use the default character. This specific version has lots of crucial improvements such as:
- More Functions / Features & Settings
- Security / Decreased Detection Risk
- Optimized & Organized Code
- Speed / Faster Execution & Functionality
- Customization
- Storing
- Execution / Precise & Efficient
### License
This project is completely free and open sourced. But, that does not mean you own rights to it. Read this [document](https://github.com/Exunys/Aimbot-V2/blob/main/LICENSE) for more information.
You can re-use / stitch this script or any system of this project into any of your repositories, as long as you credit the developer [Exunys](https://github.com/Exunys).
## Notices
* This script will not run unless your exploit supports / includes these following functions / libraries:
  - `isfolder()`, `makefolder()` & `delfolder()`
  - `isfile()`, `writefile()` & `delfile()`
  - `Drawing`
  - `getgenv()`
  - `syn.queue_on_teleport()`
* This script will store your changed settings every 10 seconds passed. You can also disable this feature, tutorial on how will appear later on in this document.
* This script is indeed universal, but it might not run on games with specific character constructions (custom characters).
* A recommended exploit to run this script on is [Synapse X](https://x.synapse.to).
## Environment
The script's environment is stored as:
```lua
getgenv().Aimbot
```
More on how to configure the aimbot below this part.
## Configuration
This script includes settings which can be easily configured to your preference.
### Preview Of The Settings
```lua
getgenv().Aimbot.Settings = {
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
    LockPart = "Head" -- Body part to lock on (Character part's name)
}

getgenv().Aimbot.FOVSettings = {
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
```
⚠️WARNING⚠️ - ***The WallCheck function is very laggy, it is recommended you have it set as*** **false** ***at all times!***
* You can also find the JSON format (which is the way they get stored) [here](https://github.com/Exunys/Wall-Hack/tree/main/Resources/Settings).
* The Lua format of the settings / the factory reset script can be found [here](https://github.com/Exunys/Aimbot-V2/blob/main/Resources/Scripts/Manual%20Factory%20Reset%20Settings.lua).

By reading the visual representation of the configuration part of the environment table, it should be pretty easy to configure the script afterwards. Here are some examples:

### Script Examples

The following script will disable the aimbot temporarily: 
```lua
getgenv().Aimbot.Settings.Enabled = false
```
You can also change the color of the of the FOV Circle:
```lua
getgenv().Aimbot.FOVSettings.Color = "50, 255, 70" -- The colors must be fed as strings in RGB format. [(R)ed (0 - 255); (G)reen (0 - 255); (B)lue (0 - 255)]
```
**The script only accepts RGB configurations in strings as colors, if you input anything else, the script will break and not execute. Read below on how to fix this.**

You can also disable FOV Checking incase you don't find it useful / don't need it:
```lua
getgenv().Aimbot.FOVSettings.Enabled = false
```
The options are endless, you can configure the script in any way you desire.

Read about the input types and more information about the drawing library in use for the FOV Circle (to learn how to configure it) [here](https://x.synapse.to/docs/reference/drawing_lib.html).
## Fixes
If the script is not running upon execution, try a few of the solutions below:
### Solutions
* There is possibly a configuration that is unacceptable at most cases. Execute [this script](https://github.com/Exunys/Aimbot-V2/blob/main/Resources/Scripts/Delete%20Settings%20-%20Fix%20Script.lua) and restart your game for changes to take effect.
* Open your exploit's root folder, find a folder named `workspace` and look for a folder named `Exunys Developer`. Once you find it, delete this folder and restart your game.

If none of these solutions work, check if your exploit is supported (read the **Notices** part). If the script still doesn't work, contact Exunys & report the problem you are experiencing in detail.

Check if your exploit is supported [here](https://github.com/Exunys/Aimbot-V2/blob/main/Resources/Scripts/Support%20Checker.lua).
## Hotkey
If you want to change the key you want to press to trigger the Aimbot, configure the ***TriggerKey*** setting.
- *Examples* :
```lua
getgenv().Aimbot.Settings.TriggerKey = "E" -- E is the key's name (This is equivalent to Enum.KeyCode.E, except, the script only handles strings)
```
```lua
getgenv().Aimbot.Settings.TriggerKey = "MouseButton1" -- MouseButton1 is the key's name [LMB] (This is equivalent to Enum.UserInputType.MouseButton1, except, the script only handles strings)
```
This script will work if the input type selected is either a *KeyCode* or *UserInputType* so all you have to input is the last part / the key's name.
- Read: [KeyCode](https://developer.roblox.com/en-us/api-reference/enum/KeyCode), [UserInputType](https://developer.roblox.com/en-us/api-reference/enum/UserInputType) 
## Functions
This script includes built-in functions to control the Aimbot.
The functions can be accessed by indexing **Functions** in the Environment. Example:
```lua
getgenv().Aimbot.Functions
```
### Their purposes
* `Functions:Exit()`
  - Exits (unexecutes) the script and leaves no traces back.
* `Functions:Restart()`
  - Restarts the script, good for incase the script starts lagging.
* `Functions:ResetSettings()`
  - Factory resets the settings and wipes the previous ones that were saved to the workspace.

- Exit
```lua
getgenv().Aimbot.Functions:Exit()
```
- Restart
```lua
getgenv().Aimbot.Functions:Restart()
```
- Reset Settings
```lua
getgenv().Aimbot.Functions:ResetSettings()
```
## Previews

https://user-images.githubusercontent.com/76539058/148576112-928455f3-b071-4650-b2a6-5fb45cbfcf04.mp4

Settings used in the video above:
```lua
getgenv().Aimbot.Settings.Sensitivity = 0.5
getgenv().Aimbot.FOVSettings.Amount = 300
getgenv().Aimbot.FOVSettings.Sides = 18
getgenv().Aimbot.FOVSettings.Transparency = 1
getgenv().Aimbot.FOVSettings.Thickness = 2
getgenv().Aimbot.FOVSettings.Color = "25, 70, 200"
```

https://user-images.githubusercontent.com/76539058/148576459-11e0d92b-6658-4dc5-9841-2c18f61adde9.mp4

The video above presents the `Environment.Functions:ResetSettings()` function. Read the **Functions** part for more.
```lua
getgenv().Aimbot.Functions:ResetSettings()
```

https://user-images.githubusercontent.com/76539058/148576715-c90af8c4-a530-45b3-8b76-a014797b3eb5.mp4

The video above presents the `Environment.Functions:Exit()` function. Read the **Functions** part for more.
```lua
getgenv().Aimbot.Functions:Exit()
```

## Script
Load the script by copying it from [here](https://github.com/Exunys/Aimbot-V2/blob/main/Resources/Scripts/Main.lua) or by executing the code below.
```lua
--// Script

loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V2/main/Resources/Scripts/Main.lua"))()
```
## Contact Information
- [Email](mailto:exunys@gmail.com)
- [Discord](https://discord.com/users/611111398818316309)
- [Roblox](https://www.roblox.com/users/330279990/profile)
