# CameraTools
Modify your camera in Vortex!

**Uses a modified version of lowpolycat's CharacterParts script. Huge thanks to them!**

This simple scripts allows you to set your camera's CFrame *without* modifying Vortex studio. However, this comes at quite a few costs, namely being:
* Sun shadows must be off, and sun brightness must be 0.
* There must be a physics and visual counterpart of every object (that's always visible)
* Player character still moves in the position of your true camera
* Multiplayer will likely have bugs (specifically characters of other players will appear in their true position)
* Very gimmicky (If vortex implements a built in way to control the camera's cframe, please use that.)

# Documentation

Before using this module, it's best to turn off sun lighting and sun shadows. You *can* still use this script with them on, however it may cause weird lighting when the new camera's rotation doesn't match the original camera's rotation.

#### Calling the camera API:
```lua
local camAPI = require(script.Parent:WaitForChild("CameraTool"))()
```

### Setup
```lua
camAPI:setup(physics,visuals)
```
This will automatically set up the visual and physics counterpart for every child under physics

Not recommended to set workspace as true.

This will also automatically set the camAPI.physics and camAPI.visuals instances

If Visuals is not given, it will create a new model labeled "Visuals" under Workspace.

#### Active : bool
```lua
camAPI.active
```
This changes if the camera is being modified. Recommended if your doing automatic movement, as setting the camera's CFrame to the original's CFrame will cause jittering.

#### CFrame : CFrame
```lua
camAPI.CFrame
```
Being the star of the show, this value allows you to set your camera's CFrame to any CFrame!

You can rotate it, move it, and anything else you can do with a regular CFrame.

#### Kill
```lua
camAPI:kill(correctParts)
```
This method allows you to stop the camera API, if correctParts is true or nil, then it will remove every visual part and adjust the physical parts back to their original transparency

## Advanced

#### Physics & Visuals : Instance
```lua
camAPI.physics
```
```lua
camAPI.visuals
```
Every part under visuals will mirror any parts under physics that match it's unique ID, or if no parts are found, then any parts that match it's name.

Physics should be 1 transparency, while Visuals should be 0 transparency and cantcollide.

#### Automatic : bool
```lua
camAPI.automatic
```
This value dictates if the built-in heartbeat will run or not.

#### Update
```lua
camAPI:update()
```
Runs the heartbeat function, highly recommended to put this somewhere in your own script's heartbeat loop.

Make sure automatic is set to false before using this, as it will cause unnecessary lag and issues otherwise!

## Translate
```lua
camAPI:translate(cframe,inverse)
```
Translates the CFrame to or from the custom camera.

# Examples

#### Simple passthrough
```lua
local camAPI = require(script.Parent:WaitForChild("CameraTool"))()
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local workspace = game:GetService("Workspace")

local player = players.LocalPlayer

local physics = workspace:WaitForChild("Map") -- Make sure to set this to whatever model your using!

camAPI:setup(physics)

camAPI.active = true

runService.Heartbeat:Connect(function()
    local trueCam = workspace.CurrentCamera.CFrame
    
    camAPI.CFrame = trueCam  -- Put whatever you want here, the sky's the limit
end)
```

#### Passthrough, with manual updating
```lua
local camAPI = require(script.Parent:WaitForChild("CameraTool"))()
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local workspace = game:GetService("Workspace")

local player = players.LocalPlayer

local physics = workspace:WaitForChild("Map")

camAPI:setup(physics)

camAPI.automatic = false
camAPI.active = true

runService.Heartbeat:Connect(function()
    local trueCam = workspace.CurrentCamera.CFrame
    
    camAPI.CFrame = trueCam
    camAPI:update()
end)
```
