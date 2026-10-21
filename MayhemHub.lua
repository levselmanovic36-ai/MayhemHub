-- MayhemHub Items Update
-- Adds the 29 item attributes observed in Workspace.Debris.Items.
-- Keep `attribute` as the original in-game attribute name; `displayName`
-- is the text that MayhemHub should show in its interface.

local MayhemHubItems = {}

MayhemHubItems.List = {
    { attribute = "AlarmClock",       displayName = "AlarmClock" },
    { attribute = "AloeVera",         displayName = "AloeVera" },
    { attribute = "BackdoorKey",      displayName = "BackdoorKey" },
    { attribute = "Bread",            displayName = "Bread" },
    { attribute = "BreakerSwitch",    displayName = "BreakerSwitch" },
    { attribute = "Candies",          displayName = "Candies" },
    { attribute = "Candle",           displayName = "Candle" },
    { attribute = "CandyBag",         displayName = "CandyBag" },
    { attribute = "Compass",          displayName = "Compass" },
    { attribute = "Crucifix",         displayName = "Crucifix" },
    { attribute = "Donut",            displayName = "Donut" },
    { attribute = "Flashlight",       displayName = "Flashlight" },
    { attribute = "GuillotineLever",  displayName = "GuillotineLever" },
    { attribute = "HotelKey",         displayName = "HotelKey" },
    { attribute = "IronKey",          displayName = "IronKey" },
    { attribute = "Lantern",          displayName = "Lantern" },
    { attribute = "LibraryHintPaper", displayName = "LibraryHintPaper" },
    { attribute = "Lighter",          displayName = "Lighter" },
    { attribute = "Lockpicks",        displayName = "Lockpicks" },
    { attribute = "Lotus",            displayName = "Lotus" },
    { attribute = "RiftCandle",       displayName = "Moonlight Candle" },
    { attribute = "RiftSmoothie",     displayName = "Moonlight Smoothie" },
    { attribute = "Shears",           displayName = "Shears" },
    { attribute = "SkeletonKey",      displayName = "SkeletonKey" },
    { attribute = "Skins",            displayName = "Skins" },
    { attribute = "Smoothie",         displayName = "Smoothie" },
    { attribute = "StarBottle",       displayName = "StarBottle" },
    { attribute = "StarVial",         displayName = "StarVial" },
    { attribute = "Vitamins",         displayName = "Vitamins" },
}

-- Fast lookup by the original game attribute name.
MayhemHubItems.ByAttribute = {}
for _, item in ipairs(MayhemHubItems.List) do
    MayhemHubItems.ByAttribute[item.attribute] = item
end

-- Read one item's count from an Instance that stores these Attributes.
-- Returns 0 when the instance, attribute, or numeric value is missing.
function MayhemHubItems.GetCount(itemsInstance, attributeName)
    if not itemsInstance then
        return 0
    end

    local ok, value = pcall(function()
        return itemsInstance:GetAttribute(attributeName)
    end)

    if not ok or type(value) ~= "number" then
        return 0
    end

    return value
end

-- Build display rows for the MayhemHub interface.
-- Each row contains: attribute, displayName, count.
function MayhemHubItems.GetRows(itemsInstance)
    local rows = {}

    for _, item in ipairs(MayhemHubItems.List) do
        rows[#rows + 1] = {
            attribute = item.attribute,
            displayName = item.displayName,
            count = MayhemHubItems.GetCount(itemsInstance, item.attribute),
        }
    end

    return rows
end

return MayhemHubItems
