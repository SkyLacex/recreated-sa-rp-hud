local sx, sy = guiGetScreenSize();
local bx, by = 1920, 1080;
local multiplier = sx/bx, sy/by;

local bars = {
    {
        func = getElementHealth, -- A függvény amiből kikérje az értéket
        args = {localPlayer}, -- Argok, amikkel meghívja a függvényt
        width = 300, -- Hosszúság
        height = 24, -- Magasság
        image = {
            src = 'client/assets/hp.png', -- Kép elérési útja
            size = 32, -- Kép mérete
        },
        colors = {
            primary = tocolor(191, 27, 27), -- Sáv színe
            background = tocolor(0, 0, 0), -- Háttér színe
        },
        gap = 4, -- A csíkok közötti távolság 
        inner = 1, -- Hány pixellel legyen bentebb a csík külsejétől 
        segments = 2, -- Hány részre legyen szétosztva
    },
    {
        func = getPedArmor,
        args = {localPlayer},
        width = 300,
        height = 24,
        image = {
            src = 'client/assets/armor.png',
            size = 32,
        },
        colors = {
            primary = tocolor(32, 93, 150),
            background = tocolor(0, 0, 0),
        },
        gap = 4,
        inner = 1,
        segments = 3,
    },
    {
        func = getElementData,
        args = {localPlayer, 'hunger'},
        width = 300,
        height = 24,
        image = {
            src = 'client/assets/food.png',
            size = 32,
        },
        colors = {
            primary = tocolor(102, 48, 18),
            background = tocolor(0, 0, 0),
        },
        gap = 4,
        inner = 1,
        segments = 4,
    },
    {
        func = getElementData,
        args = {localPlayer, 'thirst'},
        width = 300,
        height = 24,
        image = {
            src = 'client/assets/drink.png',
            size = 32,
        },
        colors = {
            primary = tocolor(22, 145, 158),
            background = tocolor(0, 0, 0),
        },
        gap = 4,
        inner = 1,
        segments = 5,
    },
};

addEventHandler('onClientRender', root, function()
    for i,v in ipairs(bars) do 
        i = i - 1;
        dxDrawSegmentBar(sx-10-(v.width*multiplier), (v.height*multiplier)+(i*(v.height+4)), v.width*multiplier, v.height*multiplier, v.colors.background, v.colors.primary, (v.func(unpack(v.args)) or 100), v.gap, v.inner, v.segments, true, false);
        dxDrawImage(sx-((v.image.size * multiplier)+8)-(v.width*multiplier), (v.height*multiplier)+(i*(v.height+4))+v.height/2-(v.image.size)/2, (v.image.size * multiplier), (v.image.size * multiplier), v.image.src);
    end
end);

function dxDrawSegmentBar(startX, startY, width, height, backgroundColor, progressColor, currentValue, gapWidth, inner, numOfSegments, postGUI, subPixelPositioning)



    inner = inner or 0
    backgroundColor = backgroundColor or tocolor(0, 0, 0, 200)
    progressColor = progressColor or tocolor(0, 150, 255)

    currentValue = currentValue and math.min(100, currentValue) or 0
    gapWidth = gapWidth or 5
    numOfSegments = numOfSegments or 3

    local widthWithGap = width - gapWidth * (numOfSegments - 1)
    local oneSegmentWidth = widthWithGap / numOfSegments - inner / 2

    local progressPerSegment = 100 / numOfSegments
    local remainingProgress = currentValue % progressPerSegment

    local segmentsFull = math.floor(currentValue / progressPerSegment)
    local segmentsInUse = math.ceil(currentValue / progressPerSegment)

    for i = 1, numOfSegments do
        local segmentX = startX + (oneSegmentWidth + gapWidth) * (i - 1)

        dxDrawRectangle(segmentX, startY, oneSegmentWidth, height, backgroundColor, postGUI, subPixelPositioning)

        if i <= segmentsFull then
            dxDrawRectangle(segmentX + inner, startY + inner, oneSegmentWidth - inner * 2, height - inner * 2, progressColor, postGUI, subPixelPositioning)
        elseif i == segmentsInUse then
            if remainingProgress > 0 then
                dxDrawRectangle(segmentX + inner, startY + inner, oneSegmentWidth / progressPerSegment * remainingProgress - inner * 2, height - inner * 2, progressColor, postGUI, subPixelPositioning)
            end
        end
    end
end

local components = {'ammo', 'armour', 'breath', 'clock', 'health', 'money', 'weapon', 'wanted'};
addEventHandler('onClientResourceStart', root, function()
    for i,v in ipairs(components) do 
        setPlayerHudComponentVisible(v, false);
    end
end);
