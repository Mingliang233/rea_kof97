local coin = ":AUDIO_COIN"
local start = ":edge:joy:START"
local inputs = {}
local function press(frame, port, name)
    table.insert(inputs, {frame, port, name, 1})
    table.insert(inputs, {frame + 5, port, name, 0})
end
local function player(frame, number, button)
    press(frame, ":edge:joy:JOY" .. number, "P" .. number .. " " .. button)
end

press(650, coin, "Coin 1")
press(665, coin, "Coin 1")
press(700, start, "1 Player Start")
press(5100, start, "2 Players Start")
player(5400, 1, "A")
player(5400, 2, "A")
player(5500, 1, "A")
for index = 0, 3 do player(5500 + index * 20, 2, "Left") end
player(5580, 2, "Down")
player(5600, 2, "Down")
player(5620, 2, "Left")
player(5640, 2, "Down")
player(5650, 1, "A")
player(5700, 1, "A")
player(5700, 2, "A")
player(5750, 2, "A")
player(5800, 2, "A")

-- Iori closes distance while Kyo holds back, then tests a standing light punch.
table.insert(inputs, {7910, ":edge:joy:JOY2", "P2 Left", 1})
table.insert(inputs, {7958, ":edge:joy:JOY2", "P2 Left", 0})
table.insert(inputs, {7945, ":edge:joy:JOY1", "P1 Down", 1})
table.insert(inputs, {7950, ":edge:joy:JOY1", "P1 Left", 1})
player(7960, 2, "A")
table.insert(inputs, {7990, ":edge:joy:JOY1", "P1 Left", 0})
table.insert(inputs, {7990, ":edge:joy:JOY1", "P1 Down", 0})

local checkpoints = {7900}
for frame = 7958, 7980 do table.insert(checkpoints, frame) end

return {
    inputs = inputs,
    checkpoints = checkpoints,
}
