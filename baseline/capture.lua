if kof97_capture_started then return end
kof97_capture_started = true

local machine = manager.machine
local ports = machine.ioport.ports
local screen = assert(machine.screens[":screen"])
local memory = machine.devices[":maincpu"].spaces["program"]
local output = assert(os.getenv("KOF97_CAPTURE_DIR"))
local schedule = assert(loadfile(assert(os.getenv("KOF97_INPUT_SCRIPT"))))()
local frame = 0

local inputs = {}
for _, event in ipairs(schedule.inputs) do
    local field = assert(ports[event[2]].fields[event[3]], event[3])
    inputs[event[1]] = inputs[event[1]] or {}
    table.insert(inputs[event[1]], {field, event[4]})
end

local checkpoints = {}
for _, checkpoint in ipairs(schedule.checkpoints) do
    checkpoints[checkpoint] = true
end

emu.register_frame_done(function()
    frame = frame + 1
    for _, event in ipairs(inputs[frame] or {}) do
        event[1]:set_value(event[2])
    end
    if checkpoints[frame] then
        local path = string.format("%s/%04d", output, frame)
        local ram = assert(io.open(path .. ".bin", "wb"))
        ram:write(memory:read_range(0x100000, 0x10ffff, 8))
        ram:close()
        assert(not screen:snapshot(path .. ".png"))
        print("Captured frame " .. frame)
    end
end)
