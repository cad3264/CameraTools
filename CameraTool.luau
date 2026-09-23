--[[
Copyright © 2026 cad4

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

-- this needs CharacterParts by @lowpolycat on discord
-- this also needs to be ran on a localscript.

-- call it like so: 
-- local camAPI = require(script.Parent:WaitForChild("CameraTool"))()

-- enable/disable it with camAPI.active = true/false

-- set the camera's CFrame with camAPI.CFrame = insertCFrameHere

-- kill the camAPI with camAPI:kill()
-- if you don't want it to update the visuals parts, you can do camAPI:kill(false)


























































-- actual code below
-- be wary!

return function()
    local cameraAPI = {}

    local workspace = game:GetService("Workspace")
    local players = game:GetService("Players")
    local characterParts = require(script.Parent:WaitForChild("CharacterParts"))
    local runService = game:GetService("RunService")

    local player = players.LocalPlayer

    characterParts.waitForFull(player.Character)

    local limbs = characterParts.getFromPlayer(player)

    local falsePlayer = Instance.new("Model")
    falsePlayer.Parent = workspace
    falsePlayer.Name = "FalsePlayer"

    local truePlayer = limbs.torso.Parent
    limbs.torso.Parent = falsePlayer

    local function translate(CFrame,old,new)
        return ((old.Rotation * (new.Rotation:Inverse() * (CFrame - new.Position))) + old.Position)
    end

    cameraAPI.CFrame = CFrame.new(0,0,0)
    cameraAPI.active = false
    
    cameraAPI.automatic = true
    
    function cameraAPI:setup(physics,visuals)
        local visuals = visuals
        if not visuals then visuals = Instance.new("Model") visuals.Parent = workspace visuals.Name = "Visuals" end
        
        for i, part in ipairs(physics:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            	local counterpart = part:Clone()
            	if not part.UniqueId and i == 1 then warn("UniqueId is not avaliable, please ensure all of your parts are uniquely named.") end
 
            	counterpart.Name = part.UniqueId or part.Name -- incase UniqueId doesn't work on vortex
            	counterpart.CanCollide = false
            	counterpart.Anchored = true
            	counterpart.Parent = visuals
            end
        end
        
        cameraAPI.visuals = visuals
        cameraAPI.physics = physics

        return physics, visuals
    end
    
    function cameraAPI:translate(cframe,inverse)
        local camera = workspace.CurrentCamera
        local camCFrame = camera.CFrame
        if cameraAPI.active then 
            camCFrame = cameraAPI.CFrame
        end
        if not inverse then
            return translate(cframe,camera.CFrame,camCFrame)
        else
            return translate(cframe,camCFrame,camera.CFrame)
        end
    end

    
    local function heartbeatFunc()
        if cameraAPI.physics and cameraAPI.visuals then 
        local camera = workspace.CurrentCamera
        local camCFrame = camera.CFrame
        if cameraAPI.active then 
            --if typeof(cameraAPI.CFrame) ~= "CFrame" then warn("Camera CFrame is not a CFrame, but instead a " .. typeof(cameraAPI.CFrame) .. "!!") else -- typeof(CFrame) doesn't work'
            camCFrame = cameraAPI.CFrame --end
        end
        
        falsePlayer.CFrame =  translate((CFrame.new(limbs.hrp.CFrame * Vector3.new(0,2.85,0)) * limbs.hrp.CFrame.Rotation),camera.CFrame,camCFrame)
        for i, falsePart in ipairs(cameraAPI.visuals:GetChildren()) do
            local trueCounterpart
            if falsePart.UniqueId then trueCounterpart = cameraAPI.physics:FindFirstChild(falsePart.UniqueId)
or cameraAPI.physics:FindFirstChild(falsePart.Name) else
            trueCounterpart = cameraAPI.physics:FindFirstChild(falsePart.Name)
end
            if trueCounterpart then
            falsePart.CFrame = translate(trueCounterpart.CFrame,camera.CFrame,camCFrame)
end
        end
        else if not cameraAPI.physics then warn("Missing physics instance!") end if not cameraAPI.visuals then warn("Missing visuals instance!") end end

   end

	function cameraAPI:update() heartbeatFunc() end

    local heartbeat = runService.Heartbeat:Connect(function() if cameraAPI.automatic then heartbeatFunc() end end)
    
    function cameraAPI:kill(correctParts)
        heartbeat:Disconnect()
        if correctParts or correctParts == nil then
        	for i, falsePart in ipairs(cameraAPI.physics:GetChildren()) do
        	    local trueCounterpart = trueMap:FindFirstChild(falsePart.UniqueId or "")
or trueMap:FindFirstChild(falsePart.Name)
        	    falsePart.CFrame = trueCounterpart.CFrame
        	end
        end
        limbs.torso.Parent = truePlayer
        falsePlayer:Destroy()
        self = nil

   end
    
    return cameraAPI
end
