# ![Aimbot V2](https://user-images.githubusercontent.com/76539058/211103495-6f208311-c282-43d7-982e-d3ead86bef26.png) [![Visitors](https://visitor-badge.glitch.me/badge?page_id=Exunys.Aimbot-V2)](https://github.com/Exunys/Aimbot-V2)
## ![Fast](https://img.shields.io/badge/Fast-blue) ![Secure](https://img.shields.io/badge/Secure-darkgreen) ![Customizable](https://img.shields.io/badge/Customizable-purple) ![Organized](https://img.shields.io/badge/Organized-red) ![Optimized](https://img.shields.io/badge/Optimized-darkblue) ![Data Storing](https://img.shields.io/badge/Data-Storing-green) ![Undetectable](https://img.shields.io/badge/Undetectable-violet) ![Simple](https://img.shields.io/badge/Simple-yellow) ![Support](https://img.shields.io/badge/Multiplatform-Support-darkred) ![Reliable](https://img.shields.io/badge/Reliable-lightblue) ![Trusted](https://img.shields.io/badge/Trusted-lightgreen)
##
| [Update Log](https://github.com/Exunys/Aimbot-V2#update-log-ddmmyyyy0) | [Notices / Dependencies](https://github.com/Exunys/Aimbot-V2#notices) | [Configuration](https://github.com/Exunys/Aimbot-V2#configuration) | [Fixes / Troubleshooting](https://github.com/Exunys/Aimbot-V2#fixes) | [Hotkey](https://github.com/Exunys/Aimbot-V2#hotkey) | [Functions](https://github.com/Exunys/Aimbot-V2#functions) | [Previews](https://github.com/Exunys/Aimbot-V2#previews) | [Script](https://github.com/Exunys/Aimbot-V2#script)
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
##
![Aimbot V2](https://user-images.githubusercontent.com/76539058/197401886-b988d375-a258-4555-a014-476295b67752.png)
## Information

### ℹ️This repository is discontinued. Use the new script [AirHub](https://github.com/Exunys/AirHub).

This script is a universal aim-locking script. Works on all games which use the default character. This specific version has lots of crucial improvements such as:
- More Functions / Features & Settings
- Security / Decreased Detection Risk
- Optimized & Organized Code
- Speed / Faster Execution & Functionality
- Configurable Settings
- Storing
- Execution / Precise & Efficient
- Third Person Support
### License
This project is completely free and open sourced. But, that does not mean you own rights to it. Read this [document](https://github.com/Exunys/Aimbot-V2/blob/main/LICENSE) for more information.
You can re-use / stitch this script or any system of this project into any of your repositories, as long as you credit the developer [Exunys](https://github.com/Exunys).

## Update Log *(DD/MM/YYYY)*
- [23/10/2022] - **Added Third Person Support** (Read [*Script Examples*](https://github.com/Exunys/Aimbot-V2#script-examples))
- [08/01/2023] - **Bug fixes, optimizations & new script - [Aimbot V2 GUI](https://github.com/Exunys/Aimbot-V2/blob/main/Resources/Scripts/Aimbot%20V2%20GUI.lua)** (Read [*Aimbot V2 GUI*](https://github.com/Exunys/Aimbot-V2#aimbot-v2-gui))
## Notices
* The script will not function properly unless your exploit fully supports / includes these following functions & libraries:
  - `isfolder()`, `makefolder()` & `delfolder()`
  - `isfile()`, `writefile()` & `delfile()`
  - `getgenv()`
  - `syn.queue_on_teleport()` / `queue_on_teleport()`
  - `Drawing`
* This script will store your changed settings every 10 seconds passed. You can also disable this feature: 
```lua
getgenv().Aimbot.Settings.SaveSettings = false
```
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
    ThirdPerson = false, -- Uses mousemoverel instead of CFrame to support locking in third person (could be choppy)
    ThirdPersonSensitivity = 3, -- Boundary: 0.1 - 5
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
**Graphic View (Horizontal Tree Diagram)**

![image](https://user-images.githubusercontent.com/76539058/167846294-9a9f023a-14a8-42f2-b693-8557bc6a8ba5.png)

⚠️WARNING⚠️ - ***The WallCheck function is very laggy, it is recommended you have it set as*** **false** ***at all times!***
* You can also find the JSON format (which is the way they get stored) [here](https://github.com/Exunys/Aimbot-V2/tree/main/Resources/Settings).
* The Lua format of the settings / the factory reset script can be found [here](https://github.com/Exunys/Aimbot-V2/blob/main/Resources/Scripts/Manual%20Factory%20Reset%20Settings.lua).

By reading the visual representation of the configuration part of the environment table, it should be pretty easy to configure the script afterwards. Here are some examples:

### Script Examples

The following script will disable the aimbot temporarily: 
```lua
getgenv().Aimbot.Settings.Enabled = false
```
You can also change the color of the FOV Circle:
```lua
getgenv().Aimbot.FOVSettings.Color = "50, 255, 70" -- The colors must be fed as strings in RGB format. [(R)ed (0 - 255); (G)reen (0 - 255); (B)lue (0 - 255)]
```
**The script only accepts RGB configurations in strings as colors, if you input anything else, the script will break and not execute. Read below on how to fix this.**

You can also disable FOV Checking incase you don't find it useful / don't need it:
```lua
getgenv().Aimbot.FOVSettings.Enabled = false
```
If you want the script to work in third person, you can enable the *ThirdPerson* setting:
```lua
getgenv().Aimbot.Settings.ThirdPerson = true
```
If you want to edit the sensitivity for the third person mode:
```lua
-- The locking animation becomes faster as you increase the value (meaning 5 = fastest). The script becomes choppy if you increase the value.
getgenv().Aimbot.Settings.ThirdPersonSensitivity = 3 -- Boundary: 0.1 - 5
```

The options are endless, you can configure the script in any way you desire.

Read about the input types and more information about the drawing library in use for the FOV Circle (to learn how to configure it) [here](https://x.synapse.to/docs/reference/drawing_lib.html).

### Disable Storage System
If you want to disable the script saving the settings & delete the saved settings, you can do that automatically by executing the code below:
```lua
getgenv().Aimbot.Settings.SaveSettings = false
loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V2/main/Resources/Scripts/Delete%20Settings%20-%20Fix%20Script.lua"))()
```

## Fixes
If the script is not running upon execution, try a few of the solutions below:
### Solutions
* There is possibly a configuration that is unacceptable at most cases. Execute [this script](https://github.com/Exunys/Aimbot-V2/blob/main/Resources/Scripts/Delete%20Settings%20-%20Fix%20Script.lua) and restart your game for changes to take effect.
* Open your exploit's root folder, find a folder named `workspace` and look for a folder named `Exunys Developer`, inside there should be another folder named `Aimbot`. Once you find it, delete this folder and restart your game.

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

https://user-images.githubusercontent.com/76539058/197402881-bb298b50-6e90-4b57-ab70-258f3f2b4521.mp4

The video above shows how the script functions when the `Environment.Settings.ThirdPerson` value is set to `true`.
```lua
getgenv().Aimbot.Settings.ThirdPerson = true
```

https://user-images.githubusercontent.com/76539058/211179224-df514393-1d7f-46fc-ad3d-eab1035b2ac3.mp4

The video above shows the [Aimbot V2 GUI](https://github.com/Exunys/Aimbot-V2/blob/main/Resources/Scripts/Aimbot%20V2%20GUI.lua).

## Raw Source
- This source does not include any Exunys Developer systems like storing the settings, sending notifications, using colors as strings, reloading the script on teleport etc.
- This source is more optimized and relatively smaller to allow the user to modify the code and freely put it into their own script. But of course, do not forget that this script has a [license](https://github.com/Exunys/Aimbot-V2/blob/main/LICENSE).
- The raw source can be found [here](https://github.com/Exunys/Aimbot-V2/blob/main/Resources/Scripts/Raw%20Main.lua).
## Aimbot V2 GUI
This script can be found [here](https://github.com/Exunys/Aimbot-V2/blob/main/Resources/Scripts/Aimbot%20V2%20GUI.lua). The script is powered by [Pepsi's UI Library](https://v3rmillion.net/showthread.php?tid=1139856) and it uses the [Raw Aimbot V2 Source](https://raw.githubusercontent.com/Exunys/Aimbot-V2/main/Resources/Scripts/Raw%20Main.lua). 

This script is the same as the raw source but implemented into a UI Library which can be used as an independent script rather then an embeddable script for other developers. 
## Script
### GUI
Load the script by copying it from [here](https://github.com/Exunys/Aimbot-V2/blob/main/Resources/Scripts/Aimbot%20V2%20GUI.lua) or by executing the code below.
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V2/main/Resources/Scripts/Aimbot%20V2%20GUI.lua"))()
```
### Default (With Exunys Developer Systems)
Load the script by copying it from [here](https://github.com/Exunys/Aimbot-V2/blob/main/Resources/Scripts/Main.lua) or by executing the code below.
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V2/main/Resources/Scripts/Main.lua"))()
```
### Raw (Without Exunys Developer Systems)
Load the script by copying it from [here](https://github.com/Exunys/Aimbot-V2/blob/main/Resources/Scripts/Raw%20Main.lua) or by executing the code below.

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V2/main/Resources/Scripts/Raw%20Main.lua"))()
```
## Developer Contact Information
 ![Untitled](https://user-images.githubusercontent.com/76539058/211099673-3d1d2025-1739-483f-b752-627097b49f44.png)

![Untitled](https://user-images.githubusercontent.com/76539058/211104101-d850c778-6273-49ee-aa48-70846ddd2d45.png) ![Untitled](https://user-images.githubusercontent.com/76539058/211103792-1546762b-03ef-453c-9f7f-78839cf3bc7a.png) [![E-Mail](https://raw.githubusercontent.com/gauravghongde/social-icons/master/PNG/White/Gmail_white.png)](mailto:exunys@gang.email) ![Untitled](https://user-images.githubusercontent.com/76539058/211103824-21b70a3c-1d65-4920-bf69-0ddb61ca59c3.png) [![Discord](https://raw.githubusercontent.com/gauravghongde/social-icons/master/PNG/White/Discord_white.png)](https://discord.com/users/611111398818316309)

 ![Untitled](https://user-images.githubusercontent.com/76539058/211099673-3d1d2025-1739-483f-b752-627097b49f44.png)
