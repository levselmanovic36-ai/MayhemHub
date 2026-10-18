-- DOORS: MAYHEM HUB
-- V17: monster ESP ability status, BrambleLantern ESP, and Exploits placeholder message.

task.wait(2)

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
if not player then
    return
end

local CONFIG = {
    ["glitchcube"] = { Color = Color3.fromRGB(255, 0, 255), Name = "Glitch Fragment" },
    ["livehintbook"] = { Color = Color3.fromRGB(255, 235, 40), Name = "Hint Book" },
    ["timerlever"] = { Color = Color3.fromRGB(0, 180, 255), Name = "Timer Lever" },
    ["lever"] = { Color = Color3.fromRGB(0, 255, 100), Name = "Main Lever" },
    ["guillotinelever"] = { Color = Color3.fromRGB(255, 140, 0), Name = "Guillotine Lever" },
    ["breakerswitch"] = { Color = Color3.fromRGB(0, 255, 255), Name = "Breaker Switch", StrictModel = true },
    ["gatebutton"] = { Color = Color3.fromRGB(0, 255, 255), Name = "Gate Button" },
    ["ironkey"] = { Color = Color3.fromRGB(255, 165, 0), Name = "Iron Key" },
    ["lotuspetal"] = { Color = Color3.fromRGB(255, 120, 220), Name = "Lotus Petal" },
    ["hotelkey"] = { Color = Color3.fromRGB(255, 210, 50), Name = "Hotel Key" },
    ["backdoorkey"] = { Color = Color3.fromRGB(255, 210, 50), Name = "Backdoor Key" },
    ["breakerbox"] = { Color = Color3.fromRGB(255, 50, 50), Name = "Breaker Box" },
    ["breaker"] = { Color = Color3.fromRGB(255, 50, 50), Name = "Breaker Box" },
    ["elevatorbreaker"] = { Color = Color3.fromRGB(255, 80, 80), Name = "Elevator Breaker", MonsterVisible = true },
    ["escapedoor"] = { Color = Color3.fromRGB(80, 255, 120), Name = "Escape Door", MonsterVisible = true, IsExit = true },
    ["exitdoor"] = { Color = Color3.fromRGB(80, 255, 120), Name = "Exit Door", MonsterVisible = true, IsExit = true },
    ["gardengatetemplate"] = { Color = Color3.fromRGB(80, 255, 120), Name = "Garden Gate", MonsterVisible = true, IsExit = true },
    ["elevatorcar"] = { Color = Color3.fromRGB(80, 255, 120), Name = "Elevator", MonsterVisible = true, IsExit = true },
    ["vinegate"] = { Color = Color3.fromRGB(80, 255, 120), Name = "Hedge Maze Exit", MonsterVisible = true, IsExit = true },

    -- Common MAYHEM items
    ["shears"] = { Color = Color3.fromRGB(190, 190, 190), Name = "Shears" },
    ["lockpick"] = { Color = Color3.fromRGB(255, 210, 80), Name = "Lockpick" },
    ["vitamins"] = { Color = Color3.fromRGB(100, 255, 160), Name = "Vitamins" },
    ["starvial"] = { Color = Color3.fromRGB(150, 100, 255), Name = "StarVial" },
    ["compass"] = { Color = Color3.fromRGB(255, 180, 80), Name = "Compass" },
    ["nvcs"] = { Color = Color3.fromRGB(80, 220, 255), Name = "NVCS" },
    ["nvcs3000"] = { Color = Color3.fromRGB(80, 220, 255), Name = "NVCS-3000" }
}

-- Additional item aliases. Matching is normalized, so spaces/_/- do not matter.
local EXTRA_CONFIG = {
    ["shears"]       = { Color = Color3.fromRGB(255, 255, 255), Name = "Shears" },
    ["lockpick"]     = { Color = Color3.fromRGB(180, 180, 190), Name = "Lockpick" },
    ["vitamins"]     = { Color = Color3.fromRGB(255, 100, 100), Name = "Vitamins" },
    ["starvial"]     = { Color = Color3.fromRGB(255, 220, 80), Name = "StarVial" },
    ["compass"]      = { Color = Color3.fromRGB(120, 200, 255), Name = "Compass" },
    ["nvcs"]         = { Color = Color3.fromRGB(100, 220, 255), Name = "NVCS" },
    ["nvcs3000"]     = { Color = Color3.fromRGB(100, 220, 255), Name = "NVCS-3000" },
    ["candle"]       = { Color = Color3.fromRGB(255, 210, 120), Name = "Candle" },
    ["skeletonkey"]  = { Color = Color3.fromRGB(255, 220, 100), Name = "Skeleton Key" },
    ["crucifix"]     = { Color = Color3.fromRGB(230, 230, 255), Name = "Crucifix" },
    ["bandage"]      = { Color = Color3.fromRGB(240, 240, 240), Name = "Bandage" },
    ["bandagepack"]  = { Color = Color3.fromRGB(240, 240, 240), Name = "Bandage Pack" },
    ["medkit"]       = { Color = Color3.fromRGB(100, 255, 130), Name = "Medkit" },
    ["key"]          = { Color = Color3.fromRGB(255, 210, 50), Name = "Key" },
    ["roomkey"]      = { Color = Color3.fromRGB(255, 210, 50), Name = "Room Key" },
    ["gold"]         = { Color = Color3.fromRGB(255, 210, 50), Name = "Gold" },
    ["coin"]         = { Color = Color3.fromRGB(255, 210, 50), Name = "Coin" },
}

for k, v in pairs(EXTRA_CONFIG) do
    CONFIG[k] = v
end


local Settings = {
    SpeedEnabled = false,
    SpeedBonus = 0,
    FOVEnabled = false,
    FOV = 90,
    AutoInteract = false,
    InstantInteract = false,
    ItemESP = false,
    PlayerESP = false,
    MonsterESP = false,
    ExitESP = false,
    AbilityDetector = false,
    EntityHazards = false,
    FullBright = false,
    NoFog = false,
}

local Lighting = game:GetService("Lighting")
local savedLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    GlobalShadows = Lighting.GlobalShadows,
    FogStart = Lighting.FogStart,
    FogEnd = Lighting.FogEnd,
}

local function normalizeName(name)
    return string.lower(name):gsub("[%s_%-]", "")
end

local function getConfig(name)
    return CONFIG[normalizeName(name)]
end


-- Remove an older copy if it exists
pcall(function()
    local old = CoreGui:FindFirstChild("DoorsMayhemHub")
    if old then
        old:Destroy()
    end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "DoorsMayhemHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

-- Use the executor's UI container when available.
local parent
pcall(function()
    if typeof(gethui) == "function" then
        parent = gethui()
    end
end)

if not parent then
    parent = CoreGui
end

gui.Parent = parent
gui.DisplayOrder = 999


local espObjects = {}
local playerESPObjects = {}
local mapContainers = {}
local mapConnections = {}

-- Interaction prompt registry.
-- IMPORTANT: prompts are registered by events instead of repeatedly scanning Workspace.
local interactionPrompts = {}
local interactionConnections = {}
local lastAutoInteract = {}
local PROMPT_FIRE_COOLDOWN = 0.18

local MAP_FOLDER_NAMES = {
    Hotel = true,
    Library = true,
    Cellar = true,
    Backdoor = true,
    ElectricalRoom = true,
    Outdoors = true,
    HedgeMaze = true,
}

local function removeESP(obj)
    local data = espObjects[obj]
    if not data then return end
    if data.highlight then pcall(function() data.highlight:Destroy() end) end
    if data.label then pcall(function() data.label:Destroy() end) end
    espObjects[obj] = nil
end

local function clearItemESP()
    for obj in pairs(espObjects) do
        removeESP(obj)
    end
end

local function removePlayerESP(model)
    local data = playerESPObjects[model]
    if not data then return end
    if data.highlight then pcall(function() data.highlight:Destroy() end) end
    if data.label then pcall(function() data.label:Destroy() end) end
    playerESPObjects[model] = nil
end

local function clearPlayerESP()
    for model in pairs(playerESPObjects) do
        removePlayerESP(model)
    end
end

local function getAdornee(obj)
    if obj:IsA("Model") then
        return obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true)
    end
    if obj:IsA("BasePart") or obj:IsA("Tool") then
        return obj
    end
    return nil
end

local function makeESP(obj, cfg)
    if espObjects[obj] or not obj.Parent then return end
    local adornee = getAdornee(obj)
    if not adornee then return end

    local h = Instance.new("Highlight")
    h.Name = "MayhemESP"
    h.Adornee = obj:IsA("Model") and obj or adornee
    h.FillColor = cfg.Color
    h.OutlineColor = cfg.Color
    h.FillTransparency = 0.72
    h.OutlineTransparency = 0
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = workspace

    local bill = Instance.new("BillboardGui")
    bill.Name = "MayhemESPLabel"
    bill.Adornee = adornee
    bill.Size = UDim2.fromOffset(180, 26)
    bill.StudsOffset = Vector3.new(0, 2.5, 0)
    bill.AlwaysOnTop = true
    bill.Parent = gui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.Text = cfg.Name
    label.TextColor3 = cfg.Color
    label.TextStrokeTransparency = 0.25
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Parent = bill

    espObjects[obj] = {highlight = h, label = bill}

    obj.AncestryChanged:Connect(function(_, parent)
        if not parent then removeESP(obj) end
    end)
end

local function makePlayerESP(model, playerName)
    if not Settings.PlayerESP or not model or model == player.Character then return end
    if playerESPObjects[model] then return end

    local adornee = model:FindFirstChild("HumanoidRootPart")
        or model:FindFirstChild("UpperTorso")
        or model:FindFirstChild("Torso")
        or model.PrimaryPart
    if not adornee then return end

    local color = Color3.fromRGB(70, 255, 120)
    local h = Instance.new("Highlight")
    h.Name = "MayhemPlayerESP"
    h.Adornee = model
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.78
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = gui

    local bill = Instance.new("BillboardGui")
    bill.Name = "MayhemPlayerLabel"
    bill.Adornee = adornee
    bill.Size = UDim2.fromOffset(200, 28)
    bill.StudsOffset = Vector3.new(0, 3, 0)
    bill.AlwaysOnTop = true
    bill.Parent = gui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.Text = playerName
    label.TextColor3 = color
    label.TextStrokeTransparency = 0.25
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Parent = bill

    playerESPObjects[model] = {highlight = h, label = bill, isMonster = false}
    model.AncestryChanged:Connect(function(_, parent)
        if not parent then removePlayerESP(model) end
    end)
end

-- Forward declaration: the detector is defined below, but ESP labels use it too.
local isBrambleModel

local function getMonsterTypeLabel(model)
    if not model then return "Unknown entity" end
    if isBrambleModel and isBrambleModel(model) then return "Bramble" end

    for _, attributeName in ipairs({"MonsterName", "MonsterType", "EntityName", "EntityType", "Type"}) do
        local value = model:GetAttribute(attributeName)
        if typeof(value) == "string" and value ~= "" then
            return value
        end
    end

    local lowerName = string.lower(model.Name)
    for _, knownName in ipairs({"figure", "seek", "rush", "halt", "eyes", "bramble", "honcho", "noise"}) do
        if string.find(lowerName, knownName, 1, true) then
            return knownName:sub(1, 1):upper() .. knownName:sub(2)
        end
    end

    return "Unknown entity"
end

local function getMonsterAbilityLine(model, activeStatus)
    local lowerStatus = string.lower(tostring(activeStatus or ""))
    if string.find(lowerStatus, "ability 1 active", 1, true) then
        return "Ability 1 Active"
    end
    if string.find(lowerStatus, "ability 2 active", 1, true) then
        return "Ability 2 Active"
    end
    -- Do not display inactive/empty placeholder lines under monster names.
    return nil
end

local function makeMonsterESPText(model, monsterName, activeStatus)
    local lines = {
        tostring(monsterName or model.Name),
        getMonsterTypeLabel(model),
    }
    local abilityLine = getMonsterAbilityLine(model, activeStatus)
    if abilityLine then
        table.insert(lines, abilityLine)
    end
    return table.concat(lines, "\n")
end

local function makeMonsterESP(model, monsterName)
    if not Settings.MonsterESP or not model or model == player.Character then return end
    if playerESPObjects[model] then return end

    local adornee = model:FindFirstChild("HumanoidRootPart")
        or model:FindFirstChild("UpperTorso")
        or model:FindFirstChild("Torso")
        or model.PrimaryPart
    if not adornee then return end

    local color = Color3.fromRGB(255, 70, 70)
    local h = Instance.new("Highlight")
    h.Name = "MayhemMonsterESP"
    h.Adornee = model
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.78
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = gui

    local bill = Instance.new("BillboardGui")
    bill.Name = "MayhemMonsterLabel"
    bill.Adornee = adornee
    bill.Size = UDim2.fromOffset(280, 68)
    bill.StudsOffset = Vector3.new(0, 3.5, 0)
    bill.AlwaysOnTop = true
    bill.Parent = gui

    local label = Instance.new("TextLabel")
    label.Name = "MonsterStatusText"
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.Text = makeMonsterESPText(model, monsterName, nil)
    label.TextColor3 = color
    label.TextStrokeTransparency = 0.25
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.TextWrapped = true
    label.Parent = bill

    playerESPObjects[model] = {highlight = h, label = bill, textLabel = label, monsterName = monsterName, abilityStatus = "inactive", lastText = label.Text, isMonster = true}
    model.AncestryChanged:Connect(function(_, parent)
        if not parent then removePlayerESP(model) end
    end)
end

local function getPlayersFolder()
    return workspace:FindFirstChild("players")
end

-- Shared helper used by the Ability Detector and ESP refresh loop.
-- In V12 the Ability Detector called this function without defining it,
-- which stopped its sampling loop with an error.
local function getEntityFolder()
    local playersFolder = getPlayersFolder()
    return playersFolder and playersFolder:FindFirstChild("entities") or nil
end

-- Ability Detector V14 (check Bramble signals directly on entity models)
-- Bramble hierarchy used by MAYHEM:
-- Search the entire Workspace.players.entities child model for LanternNeon, Attachments, Beam, and CenterAttach.
-- V14 diagnostics showed Attachments was not a child of LanternNeon, so V15 no longer assumes that path.
-- Ability 1 is considered active when ANY of these three signals is Enabled.
local abilityESPObjects = {}
local FIGURE_ABILITY_ANIMATION_ID = "129749382034868"
local ABILITY_SAMPLE_INTERVAL = 0.12

local function removeAbilityStatus(model)
    local data = abilityESPObjects[model]
    if data and data.label then
        pcall(function() data.label:Destroy() end)
    end
    abilityESPObjects[model] = nil
end

local function getAbilityAdornee(model)
    return model:FindFirstChild("HumanoidRootPart")
        or model:FindFirstChild("UpperTorso")
        or model:FindFirstChild("Torso")
        or model:FindFirstChild("Head")
        or model.PrimaryPart
end

local function setAbilityStatus(model, text)
    if not Settings.AbilityDetector or not model or not model.Parent then
        removeAbilityStatus(model)
        return
    end

    local adornee = getAbilityAdornee(model)
    if not adornee then return end

    local data = abilityESPObjects[model]
    if data and data.label and data.label.Parent then
        local label = data.label:FindFirstChild("TextLabel")
        if label then label.Text = text end
        return
    end

    local bill = Instance.new("BillboardGui")
    bill.Name = "MayhemAbilityStatus"
    bill.Adornee = adornee
    bill.Size = UDim2.fromOffset(260, 26)
    bill.StudsOffset = Vector3.new(0, 4.1, 0)
    bill.AlwaysOnTop = true
    bill.Parent = gui

    local label = Instance.new("TextLabel")
    label.Name = "TextLabel"
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 230, 80)
    label.TextStrokeTransparency = 0.2
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.Parent = bill

    abilityESPObjects[model] = {label = bill, text = text}
end

isBrambleModel = function(model)
    if not model then return false end
    local lowerName = string.lower(model.Name)
    return model:FindFirstChild("ab1", true) ~= nil
        or model:FindFirstChild("LanternNeon", true) ~= nil
        or string.find(lowerName, "bramble", 1, true) ~= nil
end

local function getBrambleSignals(model)
    if not model then
        return nil, {}, {lanternFound = false, attachmentsFound = false, centerFound = false, beamFound = false}
    end

    -- The diagnostic from V14 showed LanternNeon exists but Attachments is NOT
    -- underneath it. Search the whole entity model instead of assuming a parent path.
    local lanternNeon = model:FindFirstChild("LanternNeon", true)
    local attachmentsCandidates = {}
    local centerAttach = nil
    local beam = nil

    for _, obj in ipairs(model:GetDescendants()) do
        if obj.Name == "Attachments" then
            table.insert(attachmentsCandidates, obj)
        elseif obj.Name == "CenterAttach" and not centerAttach then
            centerAttach = obj
        elseif obj.Name == "Beam" and obj:IsA("Beam") and not beam then
            beam = obj
        end
    end

    -- Prefer the Attachments folder nearest to LanternNeon, but accept it anywhere
    -- in the entity model if MAYHEM parents these objects as siblings instead.
    local attachments = nil
    if lanternNeon then
        for _, candidate in ipairs(attachmentsCandidates) do
            if candidate:IsDescendantOf(lanternNeon) then
                attachments = candidate
                break
            end
        end
    end
    if not attachments and #attachmentsCandidates > 0 then
        attachments = attachmentsCandidates[1]
    end

    -- If Beam is under Attachments, prefer that Beam; otherwise use the first Beam
    -- found anywhere in this entity model.
    if attachments then
        local preferredBeam = attachments:FindFirstChild("Beam", true)
        if preferredBeam and preferredBeam:IsA("Beam") then
            beam = preferredBeam
        end
        local preferredCenter = attachments:FindFirstChild("CenterAttach", true)
        if preferredCenter then
            centerAttach = preferredCenter
        end
    end

    -- Final fallback: find PointLights under CenterAttach anywhere in the entity.
    local pointLights = {}
    if centerAttach then
        if centerAttach:IsA("PointLight") then
            table.insert(pointLights, centerAttach)
        end
        for _, child in ipairs(centerAttach:GetDescendants()) do
            if child:IsA("PointLight") then
                table.insert(pointLights, child)
            end
        end
    end

    return beam, pointLights, {
        lanternFound = lanternNeon ~= nil,
        attachmentsFound = #attachmentsCandidates > 0,
        centerFound = centerAttach ~= nil,
        beamFound = beam ~= nil,
        lightCount = #pointLights,
        attachmentsLocation = attachments and attachments:GetFullName() or "not found",
        centerLocation = centerAttach and centerAttach:GetFullName() or "not found",
        beamLocation = beam and beam:GetFullName() or "not found",
    }
end

local function objectEnabledState(obj, expectedClass)
    if not obj then return "missing" end
    if expectedClass and not obj:IsA(expectedClass) then
        return "wrong-class:" .. obj.ClassName
    end
    local ok, enabled = pcall(function() return obj.Enabled end)
    if not ok then return "no-Enabled" end
    return enabled and "ON" or "off"
end

local function isBrambleAbilityActive(model)
    local beam, pointLights = getBrambleSignals(model)
    if beam and beam:IsA("Beam") then
        local ok, enabled = pcall(function() return beam.Enabled end)
        if ok and enabled then return true end
    end

    -- The ability is active if ANY of Beam or either PointLight is enabled.
    for _, light in ipairs(pointLights or {}) do
        if light:IsA("PointLight") then
            local ok, enabled = pcall(function() return light.Enabled end)
            if ok and enabled then return true end
        end
    end
    return false
end

-- A new DeadBrambleLantern in Workspace.Debris marks the end of the current
-- Bramble Ability 1 display (for example, once Bramble finishes teleporting).
-- This only hides our ESP label; it does not modify the game's lights, beams,
-- or the ability itself. Suppression lasts until the three ability signals go
-- inactive, so the next genuine activation can be detected normally.
local Workspace = game:GetService("Workspace")
local brambleSuppressedAfterTeleport = {}
local deadBrambleLanternEndPending = false
local watchedDebrisFolder = nil
local debrisDescendantAddedConnection = nil
local debrisDescendantRemovingConnection = nil
local workspaceChildAddedConnection = nil

local function handleDebrisDescendantAdded(instance)
    if not instance or normalizeName(instance.Name) ~= "deadbramblelantern" then
        return
    end
    deadBrambleLanternEndPending = true
end

local function watchWorkspaceDebris(folder)
    if folder == watchedDebrisFolder then return end
    if debrisDescendantAddedConnection then
        pcall(function() debrisDescendantAddedConnection:Disconnect() end)
        debrisDescendantAddedConnection = nil
    end
    if debrisDescendantRemovingConnection then
        pcall(function() debrisDescendantRemovingConnection:Disconnect() end)
        debrisDescendantRemovingConnection = nil
    end
    watchedDebrisFolder = folder
    if folder then
        debrisDescendantAddedConnection = folder.DescendantAdded:Connect(handleDebrisDescendantAdded)
        debrisDescendantRemovingConnection = folder.DescendantRemoving:Connect(function(instance)
            if instance and normalizeName(instance.Name) == "bramblelantern" then
                deadBrambleLanternEndPending = true
            end
        end)
    end
end

watchWorkspaceDebris(Workspace:FindFirstChild("Debris"))
workspaceChildAddedConnection = Workspace.ChildAdded:Connect(function(child)
    if child.Name == "Debris" then
        watchWorkspaceDebris(child)
    end
end)

-- Entity Hazards ESP: BrambleLantern, BrambleLotus, SeekPuddle, and FigureSnare.
-- All four hazard types share one toggle and are only highlighted locally.
local ENTITY_HAZARD_CONFIG = {
    bramblelantern = {Label = "Bramble Lantern", Color = Color3.fromRGB(80, 220, 255)},
    bramblelotus = {Label = "Bramble Lotus", Color = Color3.fromRGB(100, 255, 130)},
    seekpuddle = {Label = "Seek Puddle", Color = Color3.fromRGB(70, 120, 255)},
    figuresnare = {Label = "Figure Snare", Color = Color3.fromRGB(255, 180, 70)},
}

local entityHazardESPObjects = {}
local entityHazardsDescendantAddedConnection = nil

local function removeEntityHazardESP(obj)
    local data = entityHazardESPObjects[obj]
    if not data then return end
    if data.highlight then pcall(function() data.highlight:Destroy() end) end
    if data.label then pcall(function() data.label:Destroy() end) end
    entityHazardESPObjects[obj] = nil
end

local function getHazardAdornment(obj)
    if not obj then return nil, nil end

    if obj:IsA("Model") then
        local part = obj.PrimaryPart
        if not part then
            for _, descendant in ipairs(obj:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    part = descendant
                    break
                end
            end
        end
        if part then return obj, part end
        return nil, nil
    elseif obj:IsA("BasePart") then
        return obj, obj
    end

    -- Some map hazards may be folders/attachments rather than Models.
    -- Prefer their nearest containing Model; otherwise use a BasePart descendant.
    local ancestor = obj.Parent
    while ancestor and ancestor ~= Workspace do
        if ancestor:IsA("Model") then
            local part = ancestor.PrimaryPart
            if not part then
                for _, descendant in ipairs(ancestor:GetDescendants()) do
                    if descendant:IsA("BasePart") then
                        part = descendant
                        break
                    end
                end
            end
            if part then return ancestor, part end
        end
        ancestor = ancestor.Parent
    end

    for _, descendant in ipairs(obj:GetDescendants()) do
        if descendant:IsA("BasePart") then
            return descendant, descendant
        end
    end
    return nil, nil
end

local function addEntityHazardESP(obj)
    if not Settings.EntityHazards or not obj then return end
    local config = ENTITY_HAZARD_CONFIG[normalizeName(obj.Name)]
    if not config or entityHazardESPObjects[obj] then return end
    if not obj:IsDescendantOf(Workspace) then return end

    local highlightTarget, labelPart = getHazardAdornment(obj)
    if not highlightTarget or not labelPart then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "MayhemEntityHazardESP"
    highlight.Adornee = highlightTarget
    highlight.FillColor = config.Color
    highlight.OutlineColor = config.Color
    highlight.FillTransparency = 0.72
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = gui

    local bill = Instance.new("BillboardGui")
    bill.Name = "MayhemEntityHazardLabel"
    bill.Adornee = labelPart
    bill.Size = UDim2.fromOffset(180, 24)
    bill.StudsOffset = Vector3.new(0, 2.2, 0)
    bill.AlwaysOnTop = true
    bill.Parent = gui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.Text = config.Label
    label.TextColor3 = config.Color
    label.TextStrokeTransparency = 0.2
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.Parent = bill

    entityHazardESPObjects[obj] = {highlight = highlight, label = bill}
    obj.AncestryChanged:Connect(function()
        if not obj:IsDescendantOf(Workspace) then
            removeEntityHazardESP(obj)
        end
    end)
end

local function setEntityHazardsEnabled(state)
    Settings.EntityHazards = state
    if not state then
        if entityHazardsDescendantAddedConnection then
            pcall(function() entityHazardsDescendantAddedConnection:Disconnect() end)
            entityHazardsDescendantAddedConnection = nil
        end
        for obj in pairs(entityHazardESPObjects) do
            removeEntityHazardESP(obj)
        end
        return
    end

    -- Initial scan of existing hazards.
    for _, descendant in ipairs(Workspace:GetDescendants()) do
        addEntityHazardESP(descendant)
    end

    -- Catch newly spawned hazards, including models whose parts arrive a moment later.
    if entityHazardsDescendantAddedConnection then
        pcall(function() entityHazardsDescendantAddedConnection:Disconnect() end)
    end
    entityHazardsDescendantAddedConnection = Workspace.DescendantAdded:Connect(function(instance)
        task.defer(function()
            local current = instance
            while current and current ~= Workspace do
                addEntityHazardESP(current)
                current = current.Parent
            end
        end)
    end)
end

local function isFigureAnimationPlaying(model)
    local hasFigureMarker = model:FindFirstChild("ab2", true) ~= nil
        or string.find(string.lower(model.Name), "figure", 1, true) ~= nil
    if not hasFigureMarker then return false end

    for _, obj in ipairs(model:GetDescendants()) do
        if obj:IsA("Animator") then
            local ok, tracks = pcall(function()
                return obj:GetPlayingAnimationTracks()
            end)
            if ok and tracks then
                for _, track in ipairs(tracks) do
                    local animationId = ""
                    pcall(function()
                        if track.Animation then
                            animationId = tostring(track.Animation.AnimationId)
                        end
                    end)
                    local digits = animationId:match("(%d+)$") or animationId
                    if track.IsPlaying and digits == FIGURE_ABILITY_ANIMATION_ID then
                        return true
                    end
                end
            end
        end
    end
    return false
end

local function updateMonsterAbilityLine(model, activeStatus)
    local data = playerESPObjects[model]
    if not data or not data.isMonster or not data.textLabel or not data.textLabel.Parent then return end
    local status = getMonsterAbilityLine(model, activeStatus)
    local text = makeMonsterESPText(model, data.monsterName, activeStatus)
    if data.lastText == text then return end
    data.abilityStatus = status or ""
    data.lastText = text
    data.textLabel.Text = text
end

local function clearAbilityDetector()
    for model in pairs(abilityESPObjects) do
        removeAbilityStatus(model)
    end
end

local function setAbilityDetectorEnabled(state)
    Settings.AbilityDetector = state
    if not state then clearAbilityDetector() end
end

-- Small, bounded loop: only registered BrambleLanterns and current entity models.
task.spawn(function()
    while gui and gui.Parent do
        task.wait(ABILITY_SAMPLE_INTERVAL)
        if Settings.AbilityDetector or Settings.MonsterESP then
            local activeThisCycle = {}
            local monsterAbilityStatus = {}
            local entities = getEntityFolder()
            -- A new DeadBrambleLantern ends the displayed Bramble ability state.
            if deadBrambleLanternEndPending and entities then
                for _, model in ipairs(entities:GetChildren()) do
                    if isBrambleModel(model) then
                        brambleSuppressedAfterTeleport[model] = true
                        removeAbilityStatus(model)
                    end
                end
                deadBrambleLanternEndPending = false
            end

            if entities then
                for _, model in ipairs(entities:GetChildren()) do
                    if isFigureAnimationPlaying(model) then
                        activeThisCycle[model] = model.Name .. " - Figure: Ability 2 Active"
                        monsterAbilityStatus[model] = "Figure: Ability 2 Active"
                    end
                end

                for _, model in ipairs(entities:GetChildren()) do
                    if isBrambleModel(model) then
                        local rawActive = isBrambleAbilityActive(model)
                        if not rawActive then
                            brambleSuppressedAfterTeleport[model] = nil
                        elseif not brambleSuppressedAfterTeleport[model] then
                            activeThisCycle[model] = model.Name .. " - Bramble: Ability 1 Active"
                            monsterAbilityStatus[model] = "Bramble: Ability 1 Active"
                        end
                    end
                    if Settings.MonsterESP then
                        updateMonsterAbilityLine(model, monsterAbilityStatus[model])
                    end
                end
            end

            if Settings.AbilityDetector then
                for model, statusText in pairs(activeThisCycle) do
                    if Settings.MonsterESP then
                        -- The monster ESP already contains the ability line; avoid a duplicate label.
                        removeAbilityStatus(model)
                    else
                        setAbilityStatus(model, statusText)
                    end
                end
                for model in pairs(abilityESPObjects) do
                    if Settings.MonsterESP or not activeThisCycle[model] or not model.Parent then
                        removeAbilityStatus(model)
                    end
                end
            end

            for model in pairs(brambleSuppressedAfterTeleport) do
                if not model.Parent then
                    brambleSuppressedAfterTeleport[model] = nil
                end
            end
        end
    end
end)

local function refreshPlayerESP()
    for model, data in pairs(playerESPObjects) do
        if (data.isMonster and not Settings.MonsterESP) or ((not data.isMonster) and not Settings.PlayerESP) then
            removePlayerESP(model)
        end
    end

    local playersFolder = getPlayersFolder()
    if not playersFolder then return end
    local humans = playersFolder:FindFirstChild("humans")
    local entities = playersFolder:FindFirstChild("entities")

    if humans and Settings.PlayerESP then
        for _, model in ipairs(humans:GetChildren()) do
            local plr = Players:FindFirstChild(model.Name)
            makePlayerESP(model, plr and plr.Name or model.Name)
        end
    end
    if entities and Settings.MonsterESP then
        for _, model in ipairs(entities:GetChildren()) do
            local plr = Players:FindFirstChild(model.Name)
            makeMonsterESP(model, plr and plr.Name or model.Name)
        end
    end
end

local function hookPlayerFolders()
    local playersFolder = getPlayersFolder()
    if not playersFolder then return end
    local hooked = {}

    local function hookTeamFolder(folder, isMonster)
        if not folder or hooked[folder] then return end
        hooked[folder] = true
        for _, model in ipairs(folder:GetChildren()) do
            if isMonster then
                if Settings.MonsterESP then
                    local plr = Players:FindFirstChild(model.Name)
                    makeMonsterESP(model, plr and plr.Name or model.Name)
                end
            elseif Settings.PlayerESP then
                local plr = Players:FindFirstChild(model.Name)
                makePlayerESP(model, plr and plr.Name or model.Name)
            end
        end
        folder.ChildAdded:Connect(function(model)
            task.defer(function()
                if isMonster then
                    if Settings.MonsterESP then
                        local plr = Players:FindFirstChild(model.Name)
                        makeMonsterESP(model, plr and plr.Name or model.Name)
                    end
                elseif Settings.PlayerESP then
                    local plr = Players:FindFirstChild(model.Name)
                    makePlayerESP(model, plr and plr.Name or model.Name)
                end
            end)
        end)
        folder.ChildRemoved:Connect(function(model)
            removePlayerESP(model)
        end)
    end

    hookTeamFolder(playersFolder:FindFirstChild("humans"), false)
    hookTeamFolder(playersFolder:FindFirstChild("entities"), true)
    playersFolder.ChildAdded:Connect(function(child)
        if child.Name == "humans" then hookTeamFolder(child, false)
        elseif child.Name == "entities" then hookTeamFolder(child, true) end
    end)
end

local function locateMap(name)
    -- Prefer cheap/direct locations first.
    local direct = workspace:FindFirstChild(name)
    if direct then return direct end

    for _, rootName in ipairs({"Map", "map", "CurrentMap", "currentMap", "Maps"}) do
        local root = workspace:FindFirstChild(rootName)
        if root then
            local found = root:FindFirstChild(name, true)
            if found then return found end
        end
    end

    -- Last resort, once per requested map, not continuously.
    return workspace:FindFirstChild(name, true)
end

local function registerPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return end
    if interactionPrompts[prompt] then return end

    interactionPrompts[prompt] = true

    if Settings.InstantInteract then
        pcall(function()
            prompt.HoldDuration = 0
        end)
    end

    interactionConnections[prompt] = prompt.AncestryChanged:Connect(function(_, parent)
        if not parent then
            interactionPrompts[prompt] = nil
            lastAutoInteract[prompt] = nil
            local c = interactionConnections[prompt]
            if c then
                pcall(function() c:Disconnect() end)
            end
            interactionConnections[prompt] = nil
        end
    end)
end

local function processMapObject(obj)
    -- A new item/exit is handled ONLY when that object is added.
    -- We do not rescan the whole map here.
    if obj:IsA("ProximityPrompt") then
        registerPrompt(obj)
    end

    local cfg = getConfig(obj.Name)
    if not cfg then return end

    if cfg.IsExit then
        if Settings.ExitESP then
            makeESP(obj, cfg)
        end
    else
        if Settings.ItemESP then
            makeESP(obj, cfg)
        end
    end
end

local function scanMapContainer(container)
    if not container or not container.Parent then return end

    -- This is the ONLY full scan: one pass when a map is first hooked
    -- or when the user deliberately re-enables ESP.
    for _, obj in ipairs(container:GetDescendants()) do
        processMapObject(obj)
    end
end

local function disconnectMapContainer(container)
    local c = mapConnections[container]
    if c then
        pcall(function() c:Disconnect() end)
        mapConnections[container] = nil
    end
    mapContainers[container] = nil
end

local function hookMapContainer(container)
    if not container or not container.Parent then return end

    if mapContainers[container] then
        return
    end

    mapContainers[container] = true
    scanMapContainer(container)

    -- IMPORTANT: this listener exists only while Item/Exit ESP is enabled.
    mapConnections[container] = container.DescendantAdded:Connect(function(obj)
        if not (Settings.ItemESP or Settings.ExitESP) then return end
        processMapObject(obj)
    end)

    container.AncestryChanged:Connect(function(_, parent)
        if not parent then
            disconnectMapContainer(container)
        end
    end)
end

local function hookAllMaps()
    for name in pairs(MAP_FOLDER_NAMES) do
        task.spawn(function()
            for _ = 1, 20 do
                if not (Settings.ItemESP or Settings.ExitESP) then return end
                local container = locateMap(name)
                if container then
                    hookMapContainer(container)
                    return
                end
                task.wait(0.25)
            end
        end)
    end
end

local function refreshExistingMaps()
    for container in pairs(mapContainers) do
        if container and container.Parent and (Settings.ItemESP or Settings.ExitESP) then
            scanMapContainer(container)
        end
    end
end

local function disconnectAllMapESP()
    for container in pairs(mapContainers) do
        disconnectMapContainer(container)
    end
end

local function setItemESPEnabled(state)
    Settings.ItemESP = state

    if not state then
        for obj in pairs(espObjects) do
            local cfg = getConfig(obj.Name)
            if cfg and not cfg.IsExit then
                removeESP(obj)
            end
        end
    else
        hookAllMaps()
        refreshExistingMaps()
    end

    if not Settings.ItemESP and not Settings.ExitESP then
        disconnectAllMapESP()
    end
end

local function setExitESPEnabled(state)
    Settings.ExitESP = state

    if not state then
        for obj in pairs(espObjects) do
            local cfg = getConfig(obj.Name)
            if cfg and cfg.IsExit then
                removeESP(obj)
            end
        end
    else
        hookAllMaps()
        refreshExistingMaps()
    end

    if not Settings.ItemESP and not Settings.ExitESP then
        disconnectAllMapESP()
    end
end

-- Player role folders are small and event-driven; there is no Workspace-wide scan.
task.spawn(function()
    local pf = workspace:WaitForChild("players", 10)
    if pf then hookPlayerFolders() end
end)

local function updateLighting()
    if Settings.FullBright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = savedLighting.Brightness
        Lighting.ClockTime = savedLighting.ClockTime
        Lighting.GlobalShadows = savedLighting.GlobalShadows
    end

    if Settings.NoFog then
        Lighting.FogStart = 0
        Lighting.FogEnd = 1000000
    else
        Lighting.FogStart = savedLighting.FogStart
        Lighting.FogEnd = savedLighting.FogEnd
    end
end

local savedFOV = 90
local appliedSpeedBonus = 0
local speedWriteLock = false
local speedConnection = nil
local fovConnection = nil

local function getHumanoid()
    local character = player.Character
    return character and character:FindFirstChildOfClass("Humanoid")
end

local function applySpeedFromCurrent()
    local humanoid = getHumanoid()
    if not humanoid or not Settings.SpeedEnabled then return end

    speedWriteLock = true
    humanoid.WalkSpeed = humanoid.WalkSpeed + Settings.SpeedBonus - appliedSpeedBonus
    appliedSpeedBonus = Settings.SpeedBonus

    task.defer(function()
        speedWriteLock = false
    end)
end

local function removeSpeedBonus()
    local humanoid = getHumanoid()
    if humanoid and appliedSpeedBonus ~= 0 then
        speedWriteLock = true
        humanoid.WalkSpeed = math.max(0, humanoid.WalkSpeed - appliedSpeedBonus)
        task.defer(function()
            speedWriteLock = false
        end)
    end
    appliedSpeedBonus = 0
end

local function disconnectSpeed()
    if speedConnection then
        pcall(function() speedConnection:Disconnect() end)
        speedConnection = nil
    end
end

local function setSpeedEnabled(state)
    Settings.SpeedEnabled = state
    disconnectSpeed()

    if not state then
        removeSpeedBonus()
        return
    end

    applySpeedFromCurrent()

    local humanoid = getHumanoid()
    if humanoid then
        speedConnection = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if speedWriteLock or not Settings.SpeedEnabled then return end

            -- MAYHEM can change WalkSpeed while moving/backtracking.
            -- Re-apply only our bonus to the new game-set speed.
            task.defer(function()
                if Settings.SpeedEnabled and not speedWriteLock then
                    applySpeedFromCurrent()
                end
            end)
        end)
    end
end

player.CharacterAdded:Connect(function(character)
    disconnectSpeed()
    appliedSpeedBonus = 0
    speedWriteLock = false

    task.defer(function()
        local humanoid = character:WaitForChild("Humanoid", 3)
        if humanoid and Settings.SpeedEnabled then
            setSpeedEnabled(true)
        end
    end)
end)

local function setFOVEnabled(state)
    Settings.FOVEnabled = state

    if fovConnection then
        pcall(function() fovConnection:Disconnect() end)
        fovConnection = nil
    end

    local camera = workspace.CurrentCamera
    if not camera then return end

    if not state then
        camera.FieldOfView = savedFOV
        return
    end

    savedFOV = camera.FieldOfView
    camera.FieldOfView = Settings.FOV

    -- Only react when the game actually changes FOV.
    -- No permanent Heartbeat/RenderStepped loop.
    fovConnection = camera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
        if Settings.FOVEnabled and camera.FieldOfView ~= Settings.FOV then
            camera.FieldOfView = Settings.FOV
        end
    end)
end

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    if Settings.FOVEnabled then
        task.defer(function()
            setFOVEnabled(true)
        end)
    end
end)

-- Lighting is applied only when its toggles change.

-- Interaction loop works only with the small prompt registry.
-- It NEVER calls Workspace:GetDescendants().
task.spawn(function()
    while gui.Parent do
        task.wait(0.12)

        if Settings.AutoInteract and typeof(fireproximityprompt) == "function" then
            local character = player.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")

            if root then
                local now = os.clock()
                for prompt in pairs(interactionPrompts) do
                    if prompt.Parent and prompt.Enabled then
                        local part = prompt.Parent
                        if part and part:IsA("BasePart") then
                            local distance = (root.Position - part.Position).Magnitude
                            if distance <= prompt.MaxActivationDistance then
                                local last = lastAutoInteract[prompt] or 0
                                if now - last >= PROMPT_FIRE_COOLDOWN then
                                    lastAutoInteract[prompt] = now
                                    pcall(function()
                                        fireproximityprompt(prompt)
                                    end)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- If Instant Interact is enabled later, newly spawned prompts are changed immediately
-- by registerPrompt(). Existing prompts are registered by the map's initial scan.


local function setPlayerESPEnabled(state)
    Settings.PlayerESP = state
    refreshPlayerESP()
end

local function setMonsterESPEnabled(state)
    Settings.MonsterESP = state
    refreshPlayerESP()
end

-- Toggle state.
local menuVisible = true

-- Main window
local window = Instance.new("Frame")
window.Name = "Window"
window.Size = UDim2.fromOffset(560, 380)
window.Position = UDim2.fromScale(0.5, 0.5)
window.AnchorPoint = Vector2.new(0.5, 0.5)
window.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
window.BorderSizePixel = 0
window.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = window

-- Title
local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(18, 12)
title.Size = UDim2.new(1, -70, 0, 36)
title.Font = Enum.Font.GothamBold
title.Text = "DOORS: MAYHEM HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = window

-- Close button
local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(36, 32)
close.Position = UDim2.new(1, -46, 0, 12)
close.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
close.BorderSizePixel = 0
close.Font = Enum.Font.GothamBold
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.TextSize = 16
close.Parent = window

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 7)
closeCorner.Parent = close

-- Mobile reopen button.
-- On touch devices this stays available even when the main window is hidden.
local mobileButton = Instance.new("TextButton")
mobileButton.Name = "MobileHubButton"
mobileButton.Size = UDim2.fromOffset(58, 42)
mobileButton.Position = UDim2.new(1, -72, 0.5, -21)
mobileButton.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
mobileButton.BorderSizePixel = 0
mobileButton.Font = Enum.Font.GothamBold
mobileButton.Text = "HUB"
mobileButton.TextColor3 = Color3.fromRGB(255, 255, 255)
mobileButton.TextSize = 15
mobileButton.Visible = UserInputService.TouchEnabled
mobileButton.ZIndex = 100
mobileButton.Parent = gui

local mobileCorner = Instance.new("UICorner")
mobileCorner.CornerRadius = UDim.new(0, 10)
mobileCorner.Parent = mobileButton

local function setMenuVisible(state)
    menuVisible = state
    window.Visible = state

    -- The mobile button must remain available when the window is closed.
    mobileButton.Visible = UserInputService.TouchEnabled
end

-- Use Activated so the same handler works for mouse and touch.
mobileButton.Activated:Connect(function()
    setMenuVisible(not menuVisible)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end

    if input.KeyCode == Enum.KeyCode.RightShift then
        setMenuVisible(not menuVisible)
    end
end)

close.MouseButton1Click:Connect(function()
    setMenuVisible(false)
end)

-- Tab bar
local tabs = Instance.new("Frame")
tabs.BackgroundTransparency = 1
tabs.Position = UDim2.fromOffset(15, 58)
tabs.Size = UDim2.new(1, -30, 0, 40)
tabs.Parent = window

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 7)
tabLayout.Parent = tabs

-- Content
local content = Instance.new("Frame")
content.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
content.BorderSizePixel = 0
content.Position = UDim2.fromOffset(15, 108)
content.Size = UDim2.new(1, -30, 1, -123)
content.Parent = window

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 8)
contentCorner.Parent = content

local pages = {}

local function createPage(name, description)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Size = UDim2.fromScale(1, 1)
    page.Visible = false
    page.ScrollBarThickness = 5
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ScrollingDirection = Enum.ScrollingDirection.Y
    page.Parent = content

    pages[name] = page
end

createPage("General", "General functions will be added here.")
createPage("Exploits", "Exploit functions will be added here.")
createPage("Visual", "ESP and visual functions will be added here.")

local exploitsMessage = Instance.new("TextLabel")
exploitsMessage.Name = "ExploitsPlaceholderMessage"
exploitsMessage.Position = UDim2.fromOffset(14, 14)
exploitsMessage.Size = UDim2.new(1, -28, 0, 60)
exploitsMessage.BackgroundTransparency = 1
exploitsMessage.Font = Enum.Font.GothamMedium
exploitsMessage.Text = "Theres no exploits for now. Wait for my brain activity:))"
exploitsMessage.TextColor3 = Color3.fromRGB(225, 225, 235)
exploitsMessage.TextSize = 16
exploitsMessage.TextWrapped = true
exploitsMessage.TextXAlignment = Enum.TextXAlignment.Center
exploitsMessage.TextYAlignment = Enum.TextYAlignment.Center
exploitsMessage.Parent = pages["Exploits"]

local buttons = {}

local function showPage(name)
    for pageName, page in pairs(pages) do
        page.Visible = (pageName == name)
    end

    for buttonName, button in pairs(buttons) do
        if buttonName == name then
            button.BackgroundColor3 = Color3.fromRGB(75, 75, 90)
        else
            button.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
        end
    end
end

for _, name in ipairs({"General", "Exploits", "Visual"}) do
    local button = Instance.new("TextButton")
    button.Name = name .. "Tab"
    button.Size = UDim2.fromOffset(125, 36)
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    button.BorderSizePixel = 0
    button.Font = Enum.Font.GothamMedium
    button.Text = name
    button.TextColor3 = Color3.fromRGB(240, 240, 240)
    button.TextSize = 15
    button.Parent = tabs

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 7)
    buttonCorner.Parent = button

    buttons[name] = button

    button.Activated:Connect(function()
        showPage(name)
    end)
end


local function addToggle(page, y, text, key)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -24, 0, 38)
    b.Position = UDim2.fromOffset(12, y)
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    b.BorderSizePixel = 0
    b.Font = Enum.Font.GothamMedium
    b.TextColor3 = Color3.fromRGB(240, 240, 240)
    b.TextSize = 14
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.Parent = page
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)

    local function refresh()
        b.Text = "  " .. text .. "    [" .. (Settings[key] and "ON" or "OFF") .. "]"
        b.BackgroundColor3 = Settings[key] and Color3.fromRGB(65, 85, 70) or Color3.fromRGB(45, 45, 52)
    end

    b.Activated:Connect(function()
        Settings[key] = not Settings[key]
        refresh()

        if key == "SpeedEnabled" then
            setSpeedEnabled(Settings.SpeedEnabled)
        elseif key == "ItemESP" then
            setItemESPEnabled(Settings.ItemESP)
        elseif key == "PlayerESP" then
            setPlayerESPEnabled(Settings.PlayerESP)
        elseif key == "MonsterESP" then
            setMonsterESPEnabled(Settings.MonsterESP)
        elseif key == "ExitESP" then
            setExitESPEnabled(Settings.ExitESP)
        elseif key == "AbilityDetector" then
            setAbilityDetectorEnabled(Settings.AbilityDetector)
        elseif key == "EntityHazards" then
            setEntityHazardsEnabled(Settings.EntityHazards)
        end

        if key == "FOVEnabled" then
            setFOVEnabled(Settings.FOVEnabled)
        elseif key == "FullBright" or key == "NoFog" then
            updateLighting()
        end
    end)
    refresh()
    return b
end

local function addNumber(page, y, text, key, step)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -24, 0, 38)
    box.Position = UDim2.fromOffset(12, y)
    box.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    box.BorderSizePixel = 0
    box.Font = Enum.Font.GothamMedium
    box.TextColor3 = Color3.fromRGB(240, 240, 240)
    box.TextSize = 14
    box.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    box.Text = tostring(Settings[key])
    box.Parent = page
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 7)
    box.FocusLost:Connect(function()
        local n = tonumber(box.Text)
        if n then
            Settings[key] = n
            if key == "SpeedBonus" and Settings.SpeedEnabled then
                applySpeedFromCurrent()
            elseif key == "FOV" and Settings.FOVEnabled then
                setFOVEnabled(true)
            end
        else
            box.Text = tostring(Settings[key])
        end
    end)
    return box
end

-- General
addToggle(pages["General"], 12, "Speed", "SpeedEnabled")
addNumber(pages["General"], 58, "Speed bonus (16 + bonus)", "SpeedBonus", 1)
addToggle(pages["General"], 104, "FOV", "FOVEnabled")
addNumber(pages["General"], 150, "FOV value", "FOV", 1)
addToggle(pages["General"], 196, "Auto Interact", "AutoInteract")
addToggle(pages["General"], 242, "Instant Interact", "InstantInteract")

-- Visual
addToggle(pages["Visual"], 12, "Item ESP", "ItemESP")
addToggle(pages["Visual"], 58, "Player ESP", "PlayerESP")
addToggle(pages["Visual"], 104, "Monster ESP", "MonsterESP")
addToggle(pages["Visual"], 150, "Entity Hazards", "EntityHazards")
addToggle(pages["Visual"], 196, "Exit ESP", "ExitESP")
addToggle(pages["Visual"], 242, "Ability Detector", "AbilityDetector")
addToggle(pages["Visual"], 288, "Full Bright", "FullBright")
addToggle(pages["Visual"], 334, "No Fog", "NoFog")


if Settings.ItemESP or Settings.ExitESP then
    hookAllMaps()
end
if Settings.PlayerESP or Settings.MonsterESP then
    task.defer(refreshPlayerESP)
end

showPage("General")
