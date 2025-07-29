-- Cleanup
pcall(function() game.CoreGui:FindFirstChild("PetRandomizerGUI"):Destroy() end)

-- Egg to pet mappings
local eggPets = {
    ["Bug Egg"] = {"Dragonfly", "Praying Mantis", "Giant Ant"},
    ["Paradise Egg"] = {"Mimic Octopus", "Capybara", "Peacock"},
    ["Dinosaur Egg"] = {"T-Rex", "Brontosaurus", "Pterodactyl"},
    ["Zen Egg"] = {"Kitsune", "Kappa", "Tanchozuru", "Tanuki", "Nihonzaru"},
    ["Primal Egg"] = {"Spinosaurus", "Ankylosaurus", "Dilophosaurus", "Pachycephalosaurus", "Iguanodon", "Parasaurolophus"},
    ["Common Egg"] = {"Dog", "Golden Lab", "Bunny"},
}

local ESP_ENABLED = true
local AUTO_RANDOM = false

-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "PetRandomizerGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 210)
frame.Position = UDim2.new(0.05, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(255, 182, 193) -- Light Pink
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "Pet Randomizer\nMade by - Shyy"
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255, 240, 250)
title.Font = Enum.Font.GothamBold
title.TextWrapped = true
title.BackgroundTransparency = 1

local randomBtn = Instance.new("TextButton", frame)
randomBtn.Size = UDim2.new(1, -20, 0, 45)
randomBtn.Position = UDim2.new(0, 10, 0, 60)
randomBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180) -- Hot Pink
randomBtn.Text = "Randomize Pets"
randomBtn.Font = Enum.Font.GothamBold
randomBtn.TextColor3 = Color3.new(1, 1, 1)
randomBtn.TextScaled = true
randomBtn.BorderSizePixel = 0

local espBtn = Instance.new("TextButton", frame)
espBtn.Size = UDim2.new(1, -20, 0, 40)
espBtn.Position = UDim2.new(0, 10, 0, 110)
espBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180) -- Hot Pink
espBtn.Text = "ESP: ON"
espBtn.Font = Enum.Font.GothamBold
espBtn.TextColor3 = Color3.new(1, 1, 1)
espBtn.TextScaled = true
espBtn.BorderSizePixel = 0

local autoBtn = Instance.new("TextButton", frame)
autoBtn.Size = UDim2.new(1, -20, 0, 40)
autoBtn.Position = UDim2.new(0, 10, 0, 160)
autoBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180) -- Hot Pink
autoBtn.Text = "Auto: OFF"
autoBtn.Font = Enum.Font.GothamBold
autoBtn.TextColor3 = Color3.new(1, 1, 1)
autoBtn.TextScaled = true
autoBtn.BorderSizePixel = 0

-- Rainbow text
local function rainbowEffect(label)
    coroutine.wrap(function()
        local t = 0
        while label and label.Parent do
            t += 0.05
            local r = math.sin(t) * 0.5 + 0.5
            local g = math.sin(t + 2) * 0.5 + 0.5
            local b = math.sin(t + 4) * 0.5 + 0.5
            label.TextColor3 = Color3.new(r, g, b)
            wait(0.1)
        end
    end)()
end

-- ESP functions
local function addESP(egg)
    if egg:FindFirstChild("PetNameBillboard") then return end
    local petList = eggPets[egg.Name]
    if not petList then return end

    local name = Instance.new("BillboardGui", egg)
    name.Name = "PetNameBillboard"
    name.Size = UDim2.new(0, 200, 0, 50)
    name.StudsOffset = Vector3.new(0, 3, 0)
    name.AlwaysOnTop = true

    local label = Instance.new("TextLabel", name)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Text = petList[math.random(1, #petList)]
    label.TextColor3 = Color3.fromRGB(255, 20, 147) -- Deep Pink

    rainbowEffect(label)
end

local function removeESP()
    for _, egg in pairs(workspace:GetDescendants()) do
        if egg:FindFirstChild("PetNameBillboard") then
            egg.PetNameBillboard:Destroy()
        end
    end
end

local function refreshESP()
    if not ESP_ENABLED then removeESP() return end
    for _, egg in pairs(workspace:GetDescendants()) do
        if egg:IsA("Model") and eggPets[egg.Name] then
            addESP(egg)
        end
    end
end

-- Random animation
local function animatePetName(label, petList)
    for i = 1, 10 do
        label.Text = petList[math.random(1, #petList)]
        wait(0.05)
    end
end

local function randomizePet()
    for _, egg in pairs(workspace:GetDescendants()) do
        if egg:IsA("Model") and eggPets[egg.Name] then
            local gui = egg:FindFirstChild("PetNameBillboard")
            if gui then
                local label = gui:FindFirstChildOfClass("TextLabel")
                if label then
                    animatePetName(label, eggPets[egg.Name])
                end
            end
        end
    end
end

-- Loop for auto
task.spawn(function()
    while true do
        if AUTO_RANDOM then randomizePet() end
        wait(3)
    end
end)

-- Button logic
espBtn.MouseButton1Click:Connect(function()
    ESP_ENABLED = not ESP_ENABLED
    espBtn.Text = "ESP: " .. (ESP_ENABLED and "ON" or "OFF")
    refreshESP()
end)

autoBtn.MouseButton1Click:Connect(function()
    AUTO_RANDOM = not AUTO_RANDOM
    autoBtn.Text = "Auto: " .. (AUTO_RANDOM and "ON" or "OFF")
end)

randomBtn.MouseButton1Click:Connect(function()
    randomizePet()
end)

refreshESP()
