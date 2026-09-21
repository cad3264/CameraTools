-- Module script by lowpolycat on Discord, huge thanks to them!

--// Helpers

local function findScene(character)
    for _, child in ipairs(character:GetChildren()) do
        local ok, scene = pcall(function() return child.Scene end)
        if ok and scene then return scene end
    end
end

local function getCharacterParts(character)
    local parts = {
        char = character,
        
        humanoid = character:FindFirstChild("Humanoid"),
        hrp = character:FindFirstChild("HumanoidRootPart"),
    }
    
    local torso = findScene(character)
    
    torso = torso and torso:FindFirstChild("Armature.001")
    torso = torso and torso:FindFirstChild("HumanoidRootPart")
    torso = torso and torso:FindFirstChild("Torso")
    
    if not torso then return parts end

    parts.torso = torso
    parts.head = torso:FindFirstChild("Head")
    
    parts.rightArm = torso:FindFirstChild("Right Arm")
    parts.leftArm = torso:FindFirstChild("Left Arm")
    
    parts.rightLeg = torso:FindFirstChild("Right Leg")
    parts.leftLeg = torso:FindFirstChild("Left Leg")

    return parts
end

--// Module
local characterParts = {}

function characterParts.getFromPlayer(player)
    local char = player.Character
    return getCharacterParts(char)
end

function characterParts.getFromCharacter(character)
    return getCharacterParts(character)
end

function characterParts.waitForFull(character)
    local scene repeat scene = findScene(character) until scene
	findScene(character)
    :WaitForChild("Armature.001")
    :WaitForChild("HumanoidRootPart")
    :WaitForChild("Torso")
    :WaitForChild("Head")
end

return characterParts
