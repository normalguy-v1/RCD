game:GetService("ReplicatedStorage")["01_server"]:FireServer("cmd", "-gh 116940095199813, 117311153426168,")
wait(1.5)
task.spawn(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Jskfhggjxu/My-Script/refs/heads/main/Cool-Reanimate.lua"))()
end)
wait(5.6)
local LOAD_T0 = os.clock()

local genv = (getgenv and getgenv()) or _G
if not genv.Global then genv.Global = {} end
local Global = genv.Global

local RunService   = game:GetService("RunService")
local Players      = game:GetService("Players")
local Debris       = game:GetService("Debris")
local TweenService = game:GetService("TweenService")
local Workspace    = workspace

local CFnew, CFangles = CFrame.new, CFrame.Angles
local V3 = Vector3.new
local rad, cos, sin, random, clamp, floor, sqrt = math.rad, math.cos, math.sin, math.random, math.clamp, math.floor, math.sqrt
local ZERO = V3()

local aligns = Global.__LCAligns
if not aligns then
    aligns = setmetatable({}, { __mode = "k" })
    Global.__LCAligns = aligns
end

Global.AlignPart = function(part0, part1, posOffset, rotOffset)
    if not part0 or not part1 then return end
    if part0:IsA("JointInstance") then part0 = part0.Parent end
    if part1:IsA("JointInstance") then part1 = part1.Parent end
    if not part0:IsA("BasePart") or not part1:IsA("BasePart") then return end

    if aligns[part0] then
        aligns[part0]:Disconnect()
        aligns[part0] = nil
    end

    part0:BreakJoints()
    part0.CanCollide = false
    part0.Massless = true

    posOffset = posOffset or V3()
    rotOffset = rotOffset or V3()
    local cfOffset = CFnew(posOffset) * CFangles(rad(rotOffset.X), rad(rotOffset.Y), rad(rotOffset.Z))
    local lastpos = part0.Position
    local rot = rad(0.05)
    local base = V3(0.1, 25.1, 0.1)
    local mask = V3(8, 0, 8)

    local connection
    connection = RunService.Heartbeat:Connect(function(delta)
        if not part0.Parent or not part1.Parent then
            connection:Disconnect()
            if aligns[part0] == connection then aligns[part0] = nil end
            return
        end

        part0.RotVelocity = part1.RotVelocity

        local newcf = part1.CFrame * cfOffset
        local vel = (newcf.Position - lastpos) / delta
        if vel.Magnitude < 0.1 then
            part0.Velocity = base
        else
            part0.Velocity = vel * mask + base
        end

        rot = -rot
        newcf = newcf * CFangles(0, 0, rot)
        lastpos = newcf.Position
        part0.CFrame = newcf
    end)
    aligns[part0] = connection
end

local function main()
LOAD_T0 = os.clock()
local testService = game:FindFirstChildOfClass("TestService")
if testService and testService:FindFirstChild("ScriptCheck") then
    error("Script Running")
end

if type(Global.LC_Cleanup) == "function" then
    pcall(Global.LC_Cleanup)
end

local janitor = {}
local function keep(x)
    janitor[#janitor + 1] = x
    return x
end
Global.LC_Cleanup = function()
    for i = #janitor, 1, -1 do
        local x = janitor[i]
        local t = typeof(x)
        if t == "RBXScriptConnection" then
            pcall(function() x:Disconnect() end)
        elseif t == "Instance" then
            pcall(function() x:Destroy() end)
        elseif t == "function" then
            pcall(x)
        end
    end
    table.clear(janitor)
end

local lplr = Players.LocalPlayer
if not lplr then
    return
end

local currentChar
keep(lplr.CharacterAdded:Connect(function(char)
    if char == currentChar then return end
    task.wait(1)
    main()
end))

local function randomstring()
    local length = random(10, 20)
    local array = table.create(length)
    for i = 1, length do
        array[i] = string.char(random(32, 126))
    end
    return table.concat(array)
end

local shade = Color3.new(1, 1, 1)
local red   = Color3.new(1, 0, 0)
local blue  = Color3.new(0, 0, 1)
local curColor = shade
local hue = 0
local quality = 1

local STEP = 1 / 60
local tickN = 0
local wco, wt, wn = {}, {}, 0

local function swait(n)
    n = n or 1
    if n < 1 then n = 1 end
    wn = wn + 1
    wco[wn] = coroutine.running()
    wt[wn] = tickN + n
    coroutine.yield()
end
local Swait = swait

local function stepWaiters()
    local i = 1
    while i <= wn do
        if wt[i] <= tickN then
            local co = wco[i]
            wco[i] = wco[wn]
            wt[i] = wt[wn]
            wco[wn] = nil
            wt[wn] = nil
            wn = wn - 1
            task.spawn(co)
        else
            i = i + 1
        end
    end
end

local function CreateSound(id, parent, volume, pitch, loop)
    local s = Instance.new("Sound")
    s.Volume = volume
    s.PlaybackSpeed = pitch
    s.SoundId = "rbxassetid://" .. id
    s.Looped = loop == true
    s.Parent = parent
    s:Play()
    if not loop then
        s.Ended:Connect(function() s:Destroy() end)
        Debris:AddItem(s, 60)
    end
    return s
end

local setupDone = false
local function destroyMainModule()
    for _ = 1, 5 do
        local m = Workspace:FindFirstChild("MainModule")
        if not m then return end
        local okc, inside = pcall(function() return script ~= nil and script:IsDescendantOf(m) end)
        if okc and inside then
            warn("[LC] MainModule not deleted: this script is running from inside it")
            return
        end
        m:Destroy()
    end
end

task.spawn(function()
    local ok, objects = pcall(function()
        return game:GetObjects("rbxassetid://5654587719")
    end)
    if ok and objects then
        for _, object in ipairs(objects) do
            object.Parent = Workspace
        end
        if setupDone then destroyMainModule() end
    else
        warn("[LC] Failed to load asset:", objects)
    end
end)

local AUDIO_FILES = {
    default = "lcv1_v2.mp3",
    solid   = "solidlc_theme.mp3",
    speed   = "lc_speedoflight.mp3",
    whiner  = "lc_whiner.mp3",
    krump   = "lc_krump.mp3",
}
local AUDIO_URLS
do
    local RCD = "https://github.com/normalguy-v1/RCD/raw/refs/heads/main/LCV1/"
    local RCD_RAW = "https://raw.githubusercontent.com/normalguy-v1/RCD/main/LCV1/"
    local LCA = "https://github.com/normalguy-v1/Lightning_Cannons/raw/refs/heads/main/lightning-cannons/assets/"
    local LCA_RAW = "https://raw.githubusercontent.com/normalguy-v1/Lightning_Cannons/main/lightning-cannons/assets/"
    AUDIO_URLS = {
        default = { LCA_RAW .. "lcv1.mp3", LCA .. "lcv1.mp3" },
        solid   = { LCA .. "Solid%20Lightning%20Cannon%20Theme.mp3", LCA_RAW .. "Solid%20Lightning%20Cannon%20Theme.mp3" },
        speed   = { RCD .. "atthespeedoflight.mp3", RCD_RAW .. "atthespeedoflight.mp3" },
        whiner  = { RCD .. "whiner.mp3", RCD_RAW .. "whiner.mp3" },
        krump   = { RCD .. "Krump.mp3", RCD_RAW .. "Krump.mp3" },
    }
end
local audioRequested = {}
local audioAssets = {}
local onAudioReady

local function looksLikeMp3(d)
    if type(d) ~= "string" or #d < 10000 then return false end
    if d:sub(1, 3) == "ID3" then return true end
    local b1, b2 = d:byte(1, 2)
    return b1 == 0xFF and b2 ~= nil and b2 >= 0xE0
end

local function fetchMp3(url)
    local ok, body = pcall(function() return game:HttpGet(url) end)
    if ok and looksLikeMp3(body) then return body end
    local req = request or http_request or (syn and syn.request)
    if req then
        local ok2, res = pcall(req, { Url = url, Method = "GET" })
        if ok2 and type(res) == "table" and looksLikeMp3(res.Body) then return res.Body end
    end
    return nil
end

local function prepareAudio(name)
    if audioRequested[name] then return end
    audioRequested[name] = true
    task.spawn(function()
        local getAsset = getcustomasset or getsynasset
        if not (isfile and writefile and getAsset) then
            warn("[LC] Music: your executor has no isfile/writefile/getcustomasset")
            return
        end
        local file = AUDIO_FILES[name]
        if name == "default" and isfile("lcv1.mp3") and delfile then
            pcall(delfile, "lcv1.mp3")
        end
        local good = false
        if isfile(file) then
            local okRead, data = pcall(readfile, file)
            good = okRead and looksLikeMp3(data)
            if not good and delfile then pcall(delfile, file) end
        end
        if not good then
            for _, url in ipairs(AUDIO_URLS[name]) do
                local body = fetchMp3(url)
                if body then
                    writefile(file, body)
                    good = true
                    break
                end
            end
        end
        if not good then
            warn("[LC] Music '" .. name .. "': could not download a valid mp3 (the file may no longer exist in the GitHub repo)")
            return
        end
        local ok, asset = pcall(getAsset, file)
        if ok and asset then
            audioAssets[name] = asset
            if onAudioReady then onAudioReady(name) end
        else
            warn("[LC] Music '" .. name .. "': getcustomasset failed: " .. tostring(asset))
        end
    end)
end
prepareAudio("default")

task.delay(4, function()
    for _, n in ipairs({ "solid", "speed", "whiner", "krump" }) do
        prepareAudio(n)
        task.wait(1)
    end
end)

local host = script or Instance.new("Folder")

local function getLocalValue(name, className, defaultValue)
    local value = host:FindFirstChild(name)
    if value and value:IsA(className) then
        return value
    end
    value = Instance.new(className)
    value.Name = name
    value.Value = defaultValue
    value.Parent = host
    return value
end

local SongSync = getLocalValue("SongSync", "NumberValue", 0)
local songid   = getLocalValue("SongID", "StringValue", "")
local taunt    = getLocalValue("Taunt", "StringValue", "None")

local function findDonor()
    local c = host:FindFirstChild("Character")
    if c then return c end
    local mm = Workspace:FindFirstChild("MainModule")
    local lol = mm and mm:FindFirstChild("lol")
    local sc = lol and lol:FindFirstChild("Script")
    local holder = sc and sc:FindFirstChild("Holder")
    local ls = holder and holder:FindFirstChild("LocalScript")
    return ls and ls:FindFirstChild("Character")
end

local sourceCharacter = findDonor()
if not sourceCharacter then
    local t0 = os.clock()
    repeat
        task.wait(0.05)
        sourceCharacter = findDonor()
    until sourceCharacter or os.clock() - t0 > 10
end

local Character = lplr.Character or lplr.CharacterAdded:Wait()
currentChar = Character
local function wait4(parent, name)
    return parent:FindFirstChild(name) or parent:WaitForChild(name, 5)
end
local Humanoid = Character:FindFirstChildOfClass("Humanoid") or Character:WaitForChild("Humanoid", 5)
local RootPart = wait4(Character, "HumanoidRootPart")
local Torso    = wait4(Character, "Torso")
local Head     = wait4(Character, "Head")
local LeftArm  = wait4(Character, "Left Arm")
local RightArm = wait4(Character, "Right Arm")
local LeftLeg  = wait4(Character, "Left Leg")
local RightLeg = wait4(Character, "Right Leg")

if not (Humanoid and RootPart and Torso and Head and LeftArm and RightArm and LeftLeg and RightLeg) then
    warn("LC: real player must be R6")
    return
end

local function stripDefaultAnimation()
    local anim = Character:FindFirstChild("Animate")
    if anim then
        pcall(function() anim.Disabled = true end)
        anim:Destroy()
    end
    local an = Humanoid:FindFirstChildOfClass("Animator")
    if an then
        pcall(function()
            for _, t in ipairs(an:GetPlayingAnimationTracks()) do t:Stop(0) end
        end)
        an:Destroy()
    end
end
stripDefaultAnimation()
keep(Humanoid.ChildAdded:Connect(function(c)
    if c:IsA("Animator") then task.defer(stripDefaultAnimation) end
end))
keep(Character.ChildAdded:Connect(function(c)
    if c.Name == "Animate" then task.defer(stripDefaultAnimation) end
end))
Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
local RealRoot = RootPart

local function findMotor(parent, names)
    for _, name in ipairs(names) do
        local obj = parent:FindFirstChild(name)
        if obj and obj:IsA("Motor6D") then return obj end
    end
end

local RootJoint = RootPart:FindFirstChild("RootJoint") or Torso:FindFirstChild("RootJoint")
local Neck = Torso:FindFirstChild("Neck")
local RightShoulder = findMotor(Torso, { "Right Shoulder", "RightShoulder" })
local LeftShoulder  = findMotor(Torso, { "Left Shoulder", "LeftShoulder" })
local RightHip = findMotor(Torso, { "Right Hip", "RightHip" })
local LeftHip  = findMotor(Torso, { "Left Hip", "LeftHip" })

if not (RootJoint and Neck and RightShoulder and LeftShoulder and RightHip and LeftHip) then
    warn("LC: required R6 Motor6D joints are missing")
    return
end

local function attach(name)
    local old = Character:FindFirstChild(name)
    if old then old:Destroy() end
    local src = sourceCharacter and sourceCharacter:FindFirstChild(name)
    if not src then return nil end
    local x = src:Clone()
    x.Name = name
    for _, v in ipairs(x:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Anchored = false
            v.CanCollide = false
            v.Massless = true
        end
    end
    x.Parent = Character
    return x
end

local Effects = attach("Effects") or Instance.new("Folder")
Effects.Name = "Effects"
Effects.Parent = Character
local Visualizer  = attach("Visualizer")
local Visualizer2 = attach("Visualizer2")

local GUN
if lplr.UserId == 1308783007 then
    GUN = attach("DarkMegaGunnModel")
else
    GUN = attach("MegaGunnModel")
end

if not GUN or not GUN:IsA("Model") or not GUN.PrimaryPart then
    warn("LC: gun donor/model not found")
    return
end

local function findBase(model, name)
    local obj = model and model:FindFirstChild(name, true)
    return obj and obj:IsA("BasePart") and obj or nil
end

local GunNeon      = findBase(GUN, "NeonParts")
local GunBase      = findBase(GUN, "Base")
local GunAdditions = findBase(GUN, "GunAdditions")
if not GunNeon or not GunBase or not GunAdditions then
    warn("LC: gun is missing Base/GunAdditions/NeonParts")
    return
end

do
    local dark = Character:FindFirstChild("DarkMegaGunnModel")
    local normal = Character:FindFirstChild("MegaGunnModel")
    if dark and dark ~= GUN then dark:Destroy() end
    if normal and normal ~= GUN then normal:Destroy() end
end

local oldWeld = GUN.PrimaryPart:FindFirstChild("Weld")
if oldWeld then oldWeld:Destroy() end

local function A(x, y, z) return CFangles(rad(x), rad(y), rad(z)) end
local GJ_REST = CFnew(0.05, -1, -0.15) * A(-90, 0, 0)

local GunJoint = Instance.new("Weld")
GunJoint.Name = "Weld"
GunJoint.Part0 = RightArm
GunJoint.Part1 = GUN.PrimaryPart
GunJoint.C0 = GJ_REST
GunJoint.C1 = CFnew()
GunJoint.Parent = GUN.PrimaryPart

local Hole    = GUN:FindFirstChild("Hole", true)
local Holetwo = GUN:FindFirstChild("Hole2", true)
if not Hole or not Holetwo then warn("LC: gun holes missing") return end

local outerm  = Visualizer and Visualizer:FindFirstChild("Mesh")
local outerm2 = Visualizer2 and Visualizer2:FindFirstChild("Mesh")

local visParts = {}
local VIS_ROT = A(0, 0, 90)
for _, v in ipairs({ Visualizer or false, Visualizer2 or false }) do
    if v and v:IsA("BasePart") then
        v:BreakJoints()
        v.Anchored = true
        v.CanCollide = false
        v.CanTouch = false
        v.CanQuery = false
        visParts[#visParts + 1] = v
    end
end

local neonParts = {}
do
    GunNeon.Material = Enum.Material.Neon
    neonParts[1] = GunNeon
    for _, v in ipairs(GunNeon:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.Neon
            neonParts[#neonParts + 1] = v
        end
    end
    local baseP = GUN:FindFirstChild("Base") or GunBase
    baseP.Color = shade
    baseP.Material = Enum.Material.Neon
    curColor = GunNeon.Color
end

local eee = Instance.new("Sound")
eee.Volume = 1
eee.PlaybackSpeed = 1
eee.SoundId = songid.Value
eee.Name = randomstring()
eee.Looped = true
eee.TimePosition = SongSync.Value
eee.Parent = Torso
eee:Play()
keep(eee)

keep(songid:GetPropertyChangedSignal("Value"):Connect(function()
    if eee.Parent then
        eee.SoundId = songid.Value
        eee.TimePosition = 0
    end
end))

do
    local RPG = Character:FindFirstChild("Accessory (VoidRPG)")
    if RPG and RPG:FindFirstChild("Handle") then
        Global.AlignPart(RPG.Handle, GunAdditions, V3(0, 0, 0), V3(0, 90, 0))
    end
    local Alligator = Character:FindFirstChild("Accessory (VoidAlligatorJaw)")
    if Alligator and Alligator:FindFirstChild("Handle") then
        Global.AlignPart(Alligator.Handle, Hole, V3(-1.35, -0.1, 0), V3(0, 180, 0))
    end
end

local hiddenRoots = { GunNeon, GunAdditions, GUN:FindFirstChild("Base") or GunBase }
local function hideGun()
    for i = 1, #hiddenRoots do
        local obj = hiddenRoots[i]
        if obj:IsA("BasePart") then obj.Transparency = 1 end
        for _, d in ipairs(obj:GetDescendants()) do
            if d:IsA("BasePart") or d:IsA("Decal") or d:IsA("Texture") then
                d.Transparency = 1
            end
        end
    end
end
hideGun()

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
rayParams.FilterDescendantsInstances = { Character }

local overlap = OverlapParams.new()
overlap.FilterType = Enum.RaycastFilterType.Exclude
overlap.FilterDescendantsInstances = { Character }

local lMouse = lplr:GetMouse()

local attack = false
local Anim = "Idle"
local walkspeed = 10
local sine = 0
local change = 1
local doe = 0
Humanoid.WalkSpeed = walkspeed

local alreadyfixing = false
local function characterfixer()
    if alreadyfixing then return end
    alreadyfixing = true
    Character = lplr.Character or Character
    Humanoid = Character:FindFirstChildOfClass("Humanoid") or Humanoid
    RootPart = Character:FindFirstChild("HumanoidRootPart") or RootPart
    Torso = Character:FindFirstChild("Torso") or Torso
    RealRoot = RootPart
    rayParams.FilterDescendantsInstances = { Character }
    overlap.FilterDescendantsInstances = { Character }

    if GUN and GUN.Parent ~= Character then GUN.Parent = Character end
    if GUN and GUN.PrimaryPart then
        local w = GUN.PrimaryPart:FindFirstChild("Weld")
        if not w then
            w = Instance.new("Weld")
            w.Name = "Weld"
            w.Parent = GUN.PrimaryPart
        end
        w.Part0 = RightArm
        w.Part1 = GUN.PrimaryPart
        w.C0 = GJ_REST
        w.C1 = CFnew()
        GunJoint = w
    end
    if Effects and Effects.Parent ~= Character then Effects.Parent = Character end
    if eee and eee.Parent ~= Torso then eee.Parent = Torso end
    Workspace.CurrentCamera.CameraSubject = Humanoid
    Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    alreadyfixing = false
end

keep(Workspace.DescendantRemoving:Connect(function(v)
    if alreadyfixing then return end
    if v ~= Character and v:IsDescendantOf(Character) then
        if not v:IsDescendantOf(Effects) and not v:IsA("Sound") and not v:IsA("BodyMover") and not v:IsA("Animator") and not v:IsA("LuaSourceContainer") then
            characterfixer()
        elseif v == eee then
            characterfixer()
        end
    end
end))

Workspace.CurrentCamera.CameraSubject = Humanoid
keep(Workspace.CurrentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(function()
    if not alreadyfixing and Humanoid.Parent and Workspace.CurrentCamera.CameraSubject ~= Humanoid then
        Workspace.CurrentCamera.CameraSubject = Humanoid
    end
end))

local gui, fixBtn, exitBtn
local fixingGui = false

local function makeButton(parent, text, anchorX)
    local b = Instance.new("TextButton")
    b.TextScaled = true
    b.Font = Enum.Font.Code
    b.Name = randomstring()
    b.BorderSizePixel = 0
    b.BackgroundTransparency = 0.5
    b.TextStrokeColor3 = shade
    b.TextStrokeTransparency = 0
    b.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
    b.Text = text
    b.Size = UDim2.new(0.25, 0, 0, 36)
    b.AnchorPoint = Vector2.new(anchorX, 1)
    b.Position = UDim2.new(0.5, 0, 0, 0)
    b.Parent = parent
    return b
end

local buildGui
buildGui = function()
    fixingGui = true
    if gui then pcall(function() gui:Destroy() end) end
    local g = Instance.new("ScreenGui")
    g.Name = randomstring()
    g.ResetOnSpawn = false
    gui = g
    fixBtn = makeButton(g, "Fix Character", 1)
    exitBtn = makeButton(g, "Leave Game", 0)
    fixBtn.MouseButton1Click:Connect(function()
        if not alreadyfixing then characterfixer() end
    end)
    exitBtn.MouseButton1Click:Connect(function()
        lplr:Kick("Left game")
    end)
    g.Parent = lplr:FindFirstChildOfClass("PlayerGui") or lplr:WaitForChild("PlayerGui")
    g.AncestryChanged:Connect(function()
        if not fixingGui and gui == g and not g.Parent then
            task.defer(buildGui)
        end
    end)
    fixingGui = false
end
buildGui()
keep(function()
    fixingGui = true
    if gui then pcall(function() gui:Destroy() end) end
end)

local talkSound = Instance.new("Sound")
talkSound.SoundId = "rbxassetid://4740147336"
talkSound.Volume = 5
talkSound.Parent = RootPart
keep(talkSound)

local chatToken = 0
local function chatfunc(text)
    chatToken = chatToken + 1
    local token = chatToken
    task.spawn(function()
        local old = Effects:FindFirstChild("TalkingBillBoard")
        if old then old:Destroy() end

        local bb = Instance.new("BillboardGui")
        bb.Size = UDim2.new(0, 9999, 2, 0)
        bb.StudsOffset = V3(0, 4.5, 0)
        bb.Adornee = RealRoot
        bb.Name = "TalkingBillBoard"
        bb.Parent = Effects

        local function label()
            local l = Instance.new("TextLabel")
            l.BackgroundTransparency = 1
            l.BorderSizePixel = 0
            l.Text = ""
            l.Font = Enum.Font.Code
            l.TextScaled = true
            l.TextStrokeTransparency = 0
            l.TextStrokeColor3 = shade
            l.Size = UDim2.new(1, 0, 1, 0)
            l.Parent = bb
            return l
        end
        local t2 = label()
        local t3 = label()

        local function alive() return token == chatToken and bb.Parent ~= nil end

        task.spawn(function()
            while alive() do
                swait()
                t2.TextColor3 = Color3.fromHSV(hue, 1, 0.5)
                t3.TextColor3 = curColor
                t2.Position = UDim2.new(0, random(-3, 3), 0, random(-3, 3))
                t3.Position = UDim2.new(0, random(-3, 3), 0, random(-3, 3))
            end
        end)

        for i = 1, #text do
            if not alive() then return end
            talkSound.TimePosition = 0
            talkSound:Play()
            swait(2)
            local sub = string.sub(text, 1, i)
            t2.Text = sub
            t3.Text = sub
        end
        swait(120)
        for i = 1, 50 do
            if not alive() then return end
            swait()
            t2.Rotation = t2.Rotation + random(-2, 2)
            t3.Rotation = t3.Rotation + random(-2, 2)
            local f = i / 50
            t2.TextStrokeTransparency = f
            t2.TextTransparency = f
            t3.TextStrokeTransparency = f
            t3.TextTransparency = f
        end
        bb:Destroy()
    end)
end
keep(lplr.Chatted:Connect(chatfunc))

local MESH_IDS = {
    Wave = "20329976", Ring = "559831844", Slash = "662586858",
    ["Round Slash"] = "662585058", Swirl = "168892432",
    Skull = "4770583", Crystal = "9756362",
}
local Neon = Enum.Material.Neon
local poolP, poolM = {}, {}
local fxActive, fxN = {}, 0
local FX_MAX = 260

local function newFxPart(kind)
    local p = Instance.new("Part")
    p.Name = randomstring()
    p.Anchored = true
    p.CanCollide = false
    p.CanTouch = false
    p.CanQuery = false
    p.Massless = true
    p.Locked = true
    p.CastShadow = false
    p.Material = Neon
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth
    p.Size = V3(1, 1, 1)
    p.Transparency = 1
    local m = Instance.new("SpecialMesh")
    if kind == "Sphere" then
        m.MeshType = Enum.MeshType.Sphere
    elseif kind == "Block" or kind == "Box" then
        m.MeshType = Enum.MeshType.Brick
    else
        m.MeshType = Enum.MeshType.FileMesh
        m.MeshId = "rbxassetid://" .. MESH_IDS[kind]
    end
    m.Parent = p
    p.Parent = Effects
    return p, m
end

local function acquire(kind)
    local pp = poolP[kind]
    if pp then
        local n = #pp
        if n > 0 then
            local part, mesh = pp[n], poolM[kind][n]
            pp[n] = nil
            poolM[kind][n] = nil
            return part, mesh
        end
    end
    return newFxPart(kind)
end

local function release(kind, part, mesh)
    part.Transparency = 1
    local pp = poolP[kind]
    if not pp then
        pp = {}
        poolP[kind] = pp
        poolM[kind] = {}
    end
    local n = #pp + 1
    if n <= 50 then
        pp[n] = part
        poolM[kind][n] = mesh
    else
        part:Destroy()
    end
end

local function spawnFx(kind, size, size2, trans, trans2, cf, time, color, rx, ry, rz, moveTo, sId, sPitch, sVol, boom, boomer, sizeBoomer)
    if fxN >= FX_MAX * quality and not sId then return end
    if time < 1 then time = 1 end
    local part, mesh = acquire(kind)

    local b1 = 1 + boomer / 50
    local b2 = 1 + sizeBoomer / 50
    local g = size - size2
    if boom then g = g * (b2 + 1) end

    if kind == "Ring" then
        mesh.Scale = V3(size.X, size.X, 0.1)
    elseif kind == "Slash" or kind == "Round Slash" then
        mesh.Scale = V3(size.X / 10, 0, size.X / 10)
    else
        mesh.Scale = size
    end
    mesh.Offset = (kind == "Wave") and V3(0, 0, -size.X / 8) or ZERO

    local _, sat = Color3.toHSV(color)
    part.Color = color
    part.Transparency = trans
    if kind == "Block" then
        part.CFrame = cf * CFangles(rad(random(0, 360)), rad(random(0, 360)), rad(random(0, 360)))
    else
        part.CFrame = cf
    end

    local ms
    if moveTo then
        ms = (cf.Position - moveTo).Magnitude / time
        if boom then ms = ms * b1 end
    end

    local r = {
        p = part, m = mesh, k = kind, i = 0, time = time, n = time + 1,
        g = g, td = trans - trans2, boom = boom, b1 = b1, b2 = b2,
        cf = cf, mv = moveTo, ms = ms, rb = sat > 0.1, ph = 0, w = 0,
    }
    if rx ~= 0 or ry ~= 0 or rz ~= 0 then
        r.rot = CFangles(rad(rx), rad(ry), rad(rz))
    end
    if sId and sPitch and sVol then
        r.snd = CreateSound(sId, part, sVol, sPitch, false)
    end
    fxN = fxN + 1
    fxActive[fxN] = r
end

local function Effect(t)
    spawnFx(
        t.EffectType or "Sphere", t.Size or V3(1, 1, 1), t.Size2 or ZERO,
        t.Transparency or 0, t.Transparency2 or 1, t.CFrame or Torso.CFrame,
        t.Time or 45, t.Color or shade,
        t.RotationX or 0, t.RotationY or 0, t.RotationZ or 0, t.MoveToPos,
        t.SoundID, t.SoundPitch, t.SoundVolume,
        t.UseBoomerangMath or false, t.Boomerang or 0, t.SizeBoomerang or 0
    )
end

local function stepEffects()
    local i = 1
    while i <= fxN do
        local r = fxActive[i]
        local done = false
        local p = r.p
        if r.ph == 0 then
            local L = r.i + 1
            r.i = L
            local m = r.m
            local time = r.time
            local sc
            if r.boom then
                sc = m.Scale - r.g * ((1 - (L / time) * r.b2) * r.b2 / time)
            else
                sc = m.Scale - r.g / time
            end
            m.Scale = sc
            if r.k == "Wave" then m.Offset = V3(0, 0, -sc.Z / 8) end
            p.Transparency = p.Transparency - r.td / time
            if r.k == "Block" then
                p.CFrame = r.cf * CFangles(rad(random(0, 360)), rad(random(0, 360)), rad(random(0, 360)))
            elseif r.rot then
                p.CFrame = p.CFrame * r.rot
            end
            if r.mv then
                local ori = p.Orientation
                local f = 1
                if r.boom then f = 1 - (L / time) * r.b1 end
                p.CFrame = CFnew(p.Position, r.mv) * CFnew(0, 0, -r.ms * f)
                p.Orientation = ori
            end
            if r.rb then p.Color = curColor end
            if L >= r.n then
                p.Transparency = 1
                if r.snd then
                    r.ph = 1
                else
                    done = true
                end
            end
        else
            r.w = r.w + 1
            local s = r.snd

            if not s.Parent or r.w > 480 or (r.w > 90 and not s.Playing) then
                if s.Parent then s:Destroy() end
                done = true
            end
        end
        if done then
            release(r.k, p, r.m)
            fxActive[i] = fxActive[fxN]
            fxActive[fxN] = nil
            fxN = fxN - 1
        else
            i = i + 1
        end
    end
end

local function CreatePart(parent, transparency, color, size, anchored)
    local p = Instance.new("Part")
    p.Massless = true
    p.CanCollide = false
    p.Locked = true
    p.Anchored = anchored ~= false
    p.Material = Neon
    p.Color = color
    p.Transparency = transparency
    p.Name = randomstring()
    p.Size = size
    p:BreakJoints()
    p.Parent = parent
    return p
end

local function MakeForm(part, kind)
    if kind == "Cyl" then
        Instance.new("CylinderMesh", part)
    elseif kind == "Ball" then
        local m = Instance.new("SpecialMesh", part)
        m.MeshType = Enum.MeshType.Sphere
    end
end

local function weldBetween(a, b)
    local w = Instance.new("Weld")
    w.Part0 = a
    w.Part1 = b
    w.C0 = CFnew()
    w.C1 = b.CFrame:Inverse() * a.CFrame
    w.Parent = b
    return w
end

local function castTo(origin, dir, range)
    local d = dir.Unit * range
    local res = Workspace:Raycast(origin, d, rayParams)
    if res then return res.Position end
    return origin + d
end

local function mdmg(center, range)
    local parts = Workspace:GetPartBoundsInRadius(center, range + 4, overlap)
    local seen
    for i = 1, #parts do
        local p = parts[i]
        local nm = p.Name
        if nm == "HumanoidRootPart" or nm == "Torso" then
            local model = p.Parent
            if model and model ~= Character and not (seen and seen[model]) then
                local hum = model:FindFirstChildOfClass("Humanoid")
                if hum and hum.RootPart == p and (p.Position - center).Magnitude <= range + p.Size.Magnitude then
                    seen = seen or {}
                    seen[model] = true

                    local deathp = Instance.new("Part")
                    deathp.Anchored = true
                    deathp.Transparency = 1
                    deathp.CanCollide = false
                    deathp.CanQuery = false
                    deathp.CFrame = p.CFrame
                    local s = Instance.new("Sound")
                    s.SoundId = "rbxassetid://206082273"
                    s.Volume = 5
                    s.PlaybackSpeed = 0.75
                    s.PlayOnRemove = true
                    s.Parent = deathp
                    deathp.Parent = Workspace
                    deathp:Destroy()

                    pcall(function() hum.Health = 0 end)
                end
            end
        end
    end
end

local function Lightning(p0, p1, _, offset, color, timer, sSize, eSize, trans, boomer, sBoomer, trans2)
    local magz = (p0 - p1).Magnitude
    local times = clamp(floor(clamp(magz / 10, 5, 20) * quality + 0.5), 3, 20)
    local seg = magz / times
    local curpos = p0
    local n1, n2 = -offset, offset
    for i = 1, times do
        local off = V3(random(2) == 1 and n1 or n2, random(2) == 1 and n1 or n2, random(2) == 1 and n1 or n2)
        local cf, zlen
        if i == times then
            local m2 = (curpos - p1).Magnitude
            if m2 < 0.01 then break end
            zlen = m2
            cf = CFnew(curpos, p1) * CFnew(0, 0, -m2 / 2)
        else
            local trolpos = (CFnew(curpos, p1) * CFnew(0, 0, seg)).Position + off
            if (trolpos - curpos).Magnitude < 0.001 then break end
            zlen = seg
            cf = CFnew(curpos, trolpos) * CFnew(0, 0, seg / 2)
        end
        curpos = (cf * CFnew(0, 0, seg / 2)).Position
        spawnFx("Box", V3(sSize, sSize, zlen), V3(eSize, eSize, zlen), trans, trans2 or 1, cf, timer, color,
            0, 0, 0, nil, nil, nil, nil, boomer, 0, sBoomer)
    end
end

local function FireArc(part, toLocation, steps, height)
    local dir = CFnew(part.Position, toLocation)
    local distance = (part.Position - toLocation).Magnitude
    for i = 1, steps do
        swait()
        part.CFrame = dir * CFnew(0, (steps / 200) + ((steps / height) - ((i * 2) / height)), -distance / steps)
        dir = part.CFrame
    end
end

local function AttackGyro()
    local g = Instance.new("BodyGyro")
    g.D = 25
    g.P = 20000
    g.MaxTorque = V3(0, 4000000, 0)
    g.CFrame = CFnew(RootPart.Position, lMouse.Hit.Position)
    g.Parent = RootPart
    task.spawn(function()
        repeat
            swait()
            g.CFrame = CFnew(RootPart.Position, lMouse.Hit.Position)
        until attack == false
        g:Destroy()
    end)
end

local function Pair(kind, size, size2, cf, time, sb, sId, sPitch, sVol)
    spawnFx(kind, size, size2, 0, 1, cf, time, red, random(-1, 1), random(-1, 1), random(-1, 1),
        nil, sId, sPitch, sVol, true, 0, sb)
    spawnFx(kind, size, size2, 0, 1, cf, time, shade, random(-1, 1), random(-1, 1), random(-1, 1),
        nil, nil, nil, nil, true, 0, sb)
end

local function SlashPair(basecf, size, size2)
    for _ = 0, 2 do
        spawnFx("Round Slash", size, size2, 0, 1,
            basecf * CFangles(rad(random(0, 360)), rad(random(0, 360)), rad(random(0, 360))),
            random(25, 50), red, random(-1, 1), random(-1, 1), random(-1, 1), nil, nil, nil, nil, true, 0, 15)
        spawnFx("Round Slash", size, size2, 0, 1,
            basecf * CFangles(rad(random(0, 360)), rad(random(0, 360)), rad(random(0, 360))),
            random(25, 50), shade, random(-1, 1), random(-1, 1), random(-1, 1), nil, nil, nil, nil, true, 0, 15)
    end
end

local PO = {}
local rc0  = A(-90, 0, 180)
local nc0  = CFnew(0, 1, 0) * A(-90, 0, 180)
local rscp = CFnew(-0.5, 0, 0) * A(0, 90, 0)
local lscp = CFnew(0.5, 0, 0) * A(0, -90, 0)

local function RS(ax, ay, az, px, py, pz) return CFnew(px or 1.5, py or 0.5, pz or 0) * A(ax, ay, az) * rscp end
local function LS(ax, ay, az, px, py, pz) return CFnew(px or -1.5, py or 0.5, pz or 0) * A(ax, ay, az) * lscp end
local function hip(px, py, pz, ax, ay, az, bx, by, bz)
    return CFnew(px, py, pz) * A(ax, ay, az) * A(bx or 0, by or 0, bz or 0)
end

local function pose(rj, nk, rs, ls, rh, lh, gj)
    RootJoint.C0 = RootJoint.C0:Lerp(rj, 1 / 3)
    Neck.C0 = Neck.C0:Lerp(nk, 1 / 3)
    RightShoulder.C0 = RightShoulder.C0:Lerp(rs, 1 / 3)
    LeftShoulder.C0 = LeftShoulder.C0:Lerp(ls, 1 / 3)
    RightHip.C0 = RightHip.C0:Lerp(rh, 1 / 3)
    LeftHip.C0 = LeftHip.C0:Lerp(lh, 1 / 3)
    GunJoint.C0 = GunJoint.C0:Lerp(gj, 1 / 2)
end
local function poseT(P)
    pose(P[1], P[2], P[3], P[4], P[5], P[6], P[7])
end

PO.RH_75 = hip(1, -1, 0, -5, 75, 0, -4, 0, 0)
PO.LH_65 = hip(-1, -1, 0, 0, -65, 0, -5, 0, 0)
PO.RH_80 = hip(1, -1, 0, -5, 80, 0, -4, 0, 0)
PO.LH_70 = hip(-1, -1, 0, 0, -70, 0, -5, 0, 0)

PO.P_A1a = { rc0 * A(0, 0, 30), nc0 * A(15, 0, -30), RS(90, 0, 30), LS(30, 0, 0), PO.RH_80, PO.LH_70, GJ_REST }
PO.P_A1b = { rc0 * A(-5, 0, 60), nc0 * A(10, 0, -60), RS(160, -20, 60), LS(40, 5, 5), PO.RH_75, PO.LH_65, GJ_REST }

PO.P_HEDa = { rc0 * A(0, 0, -60), nc0 * A(0, 0, 60), RS(90, 0, -60, 1.25, 0.5, -0.25), LS(95, 0, 10, -1.25, 0.5, -0.25), PO.RH_75, PO.LH_65, CFnew(0, -0.5, 0) * A(-90, 0, 0) }
PO.P_HEDb = { rc0 * A(0, 0, 90), nc0 * A(0, 0, -90), RS(90, 0, 90), LS(40, 5, 5), PO.RH_75, PO.LH_65, GJ_REST }

PO.P_RAINb = { rc0 * A(0, 0, -5), nc0 * A(15, 0, -5), RS(175, -10, 10), LS(-10, -10, -5), PO.RH_80, PO.LH_70, GJ_REST }
PO.P_RAINc = { rc0 * A(0, 0, -5), nc0 * A(15, 0, -5), RS(225, -20, 20), LS(-5, -5, 0), PO.RH_80, PO.LH_70, GJ_REST }
PO.P_RAINd = { rc0 * A(0, 0, -5), nc0 * A(15, 0, -5), RS(175, -10, 10), LS(-5, -5, 0), PO.RH_80, PO.LH_70, GJ_REST }
PO.RAIN_RJ, PO.RAIN_NK, PO.RAIN_RS, PO.RAIN_LS = rc0 * A(0, 0, -10), nc0 * A(25, 0, -20), RS(35, -35, 20), LS(-20, -5, -10)

local ATK = {}
function ATK.attackone()
    attack = true
    walkspeed = 5
    AttackGyro()
    for _ = 0, 0.5, 0.05 do swait(); poseT(PO.P_A1a) end

    Pair("Box", ZERO, V3(3, 3, 3), Holetwo.CFrame, 25, 50, 642890855, 0.45, 6)
    local hitCF = lMouse.Hit
    local hitP = hitCF.Position
    local dist = (Holetwo.Position - hitP).Magnitude
    local killbeam = CreatePart(Effects, 0, shade, V3(1, dist, 1))
    killbeam.CFrame = CFnew(Holetwo.Position, hitP) * CFnew(0, 0, -dist / 2) * A(90, 0, 0)
    MakeForm(killbeam, "Cyl")
    local lastT = 0
    killbeam.Touched:Connect(function(victim)
        local now = os.clock()
        if now - lastT > 0.15 then
            lastT = now
            mdmg(victim.Position, 5)
        end
    end)
    task.spawn(function()
        for i = 1, 25 do
            swait()
            killbeam.Transparency = i / 25
        end
        killbeam:Destroy()
    end)
    for _ = 1, 5 do
        Lightning(Holetwo.Position, hitP, 15, 3.5, blue, 25, 0, 1, 0, true, 55)
    end
    SlashPair(Holetwo.CFrame, ZERO, V3(0.1, 0, 0.1))
    Pair("Box", ZERO, V3(3, 3, 3), hitCF, 25, 50, 192410089, 0.55, 8)
    SlashPair(hitCF, ZERO, V3(0.1, 0, 0.1))
    mdmg(hitP, 10)

    for _ = 0, 0.5, 0.075 do swait(); poseT(PO.P_A1b) end
    walkspeed = 10
    attack = false
end

function ATK.attacktwo()
    attack = true
    walkspeed = 0
    AttackGyro()
    local gBullet = CreatePart(Effects, 0, blue, ZERO)
    MakeForm(gBullet, "Ball")
    gBullet.CFrame = LeftArm.CFrame * CFnew(0, -1.5, 0)
    CreateSound(2785493, gBullet, 2, 0.8)
    for _ = 0, 1.25, 0.025 do
        swait()
        local lcf = LeftArm.CFrame * CFnew(0, -1.5, 0)
        spawnFx("Sphere", V3(0.5, 0.5, 0.5), V3(1, 1, 1), 0, 1, lcf, random(35, 55), red, 0, 0, 0,
            (lcf * CFnew(random(-10, 10), random(-10, 10), random(-10, 10))).Position,
            nil, nil, nil, true, 50, 50)
        gBullet.Size = gBullet.Size * 1.085
        gBullet.CFrame = lcf
        local c = cos(sine / 12)
        pose(
            rc0 * CFnew(0, 0, 0.05 * c) * A(5, 0, -30),
            nc0 * A(-5 - 3 * c, 0, 30),
            RS(-62.5, -5 * c, 30),
            LS(85 - 1.5 * c, -6 * c, -30 - 6 * c, -1.5, 0.5 + 0.1 * c, 0),
            hip(1, -1 - 0.075 * c, 0, 5, 80, 0, -4, 0, 0),
            hip(-1, -1 - 0.075 * c, 0, 0, -70, 0, -5, 0, 0),
            GJ_REST
        )
    end

    local bullets = {}
    for _ = 1, random(27, 41) do
        swait()
        local b = CreatePart(Effects, 0, blue, V3(0.6, 0.6, 0.6))
        MakeForm(b, "Ball")
        b.CFrame = gBullet.CFrame
        spawnFx("Sphere", V3(3, 3, 3) * random(-3, 2), V3(6, 6, 6) * random(-3, 2), 0.4, 1, b.CFrame,
            random(5, 20), red, 0, 0, 0, nil, nil, nil, nil, true, 0, 25)
        bullets[#bullets + 1] = b
    end

    for bi = 1, #bullets do
        swait()
        local b = bullets[bi]
        local origin = (LeftArm.CFrame * CFnew(0, -1.5, 0)).Position
        local target = lMouse.Hit.Position + V3(random(-15, 15), random(-7, 7), random(-15, 15))
        local pos = castTo(origin, target - origin, 500)
        task.spawn(function()
            FireArc(b, pos, random(17, 31), random(9, 15))
            spawnFx("Sphere", V3(0.6, 0.6, 0.6), V3(1.6, 1.6, 1.6), 0, 1, b.CFrame, random(25, 35), red,
                0, 0, 0, nil, nil, nil, nil, true, 0, 25)
            swait(random(55, 65))
            for _ = 1, 3 do
                spawnFx("Sphere", V3(0.6, 6, 0.6) * random(-1.05, 1.25), V3(1.6, 10, 1.6) * random(-1.05, 1.25),
                    0, 1, b.CFrame * CFangles(rad(random(0, 360)), rad(random(0, 360)), rad(random(0, 360))),
                    random(45, 65), red, 0, 0, 0, nil, nil, nil, nil, true, 20, 35)
            end
            for _ = 0, 10 do
                swait()
                b.Transparency = b.Transparency + 0.1
            end
            mdmg(b.Position, 10)
            local s = CreateSound(168513088, b, 3.5, 1.1, false)
            b.Transparency = 1
            s.Ended:Connect(function() b:Destroy() end)
            Debris:AddItem(b, 8)
        end)
    end

    for _ = 0, 10 do
        swait()
        gBullet.Transparency = gBullet.Transparency + 0.1
    end
    gBullet:Destroy()
    walkspeed = 10
    attack = false
end

function ATK.hedshoot()
    attack = true
    walkspeed = 5
    CreateSound(235097614, RootPart, 6, 1.5, false)
    for _ = 0, 0.5, 0.05 do swait(); poseT(PO.P_HEDa) end

    local rcf = RootPart.CFrame
    Pair("Box", V3(2, 2, 2), V3(5, 5, 5), rcf, 25, 50, 642890855, 0.45, 6)
    spawnFx("Sphere", V3(2, 100, 2), V3(6, 100, 6), 0, 1,
        rcf * CFnew(random(-1, 1), random(-1, 1), -50) * A(random(89, 91), random(-1, 1), random(-1, 1)),
        random(25, 45), red, 0, 0, 0, nil, nil, nil, nil, true, 0, 45)
    spawnFx("Sphere", V3(3, 100, 3), V3(9, 100, 9), 0, 1,
        rcf * CFnew(random(-1, 1), random(-1, 1), -50) * A(random(89, 91), random(-1, 1), random(-1, 1)),
        random(25, 45), shade, 0, 0, 0, nil, nil, nil, nil, true, 0, 45)
    mdmg(RootPart.Position, 14)
    for _ = 1, 4 do
        RootPart.CFrame = RootPart.CFrame * CFnew(0, 0, -25)
        mdmg(RootPart.Position, 14)
        local rc = RootPart.CFrame
        Lightning((rc * CFnew(random(-2.5, 2.5), random(-5, 5), random(-15, 15))).Position,
            (rc * CFnew(random(-2.5, 2.5), random(-5, 5), random(-15, 15))).Position,
            6, 25, shade, random(30, 45), 0.5, 1.5, 0, true, 60)
        Lightning((rc * CFnew(random(-2.5, 2.5), random(-5, 5), random(-15, 15))).Position,
            (rc * CFnew(random(-2.5, 2.5), random(-5, 5), random(-15, 15))).Position,
            6, 25, blue, random(30, 45), 0.5, 1.5, 0, true, 60)
    end
    Pair("Box", V3(2, 2, 2), V3(5, 5, 5), RootPart.CFrame, 25, 50)
    for _ = 0, 0.5, 0.1 do swait(); poseT(PO.P_HEDb) end
    attack = false
    walkspeed = 10
end

function ATK.painlessrain()
    attack = true
    walkspeed = 5
    task.spawn(function()
        for _ = 0, 2 do
            swait(12)
            CreateSound(199145095, GUN, 6, 1)
        end
    end)
    for _ = 0, 2, 0.1 do
        swait()
        pose(PO.RAIN_RJ, PO.RAIN_NK, PO.RAIN_RS, PO.RAIN_LS, PO.RH_80, PO.LH_70, CFnew(0.05, -1, -0.15) * A(doe * 22, 0, 0))
    end
    for _ = 0, 1.5, 0.1 do swait(); poseT(PO.P_RAINb) end

    local hcf = Hole.CFrame
    local hole2 = (hcf * CFnew(-600, 0, 0)).Position
    Pair("Box", V3(2, 2, 2), V3(5, 5, 5), hcf, 25, 50, 642890855, 0.45, 6)
    Lightning(Hole.Position, hole2, 15.137, 3.5, shade, 25, 1, 3, 0, true, 55)
    Lightning(Hole.Position, hole2, 15.137, 3.5, blue, 25, 1, 3, 0, true, 55)
    SlashPair(hcf, V3(0.1, 0.1, 0.1), V3(0.4, 0, 0.4))
    for _ = 0, 0.5, 0.1 do swait(); poseT(PO.P_RAINc) end
    for _ = 0, 0.5, 0.1 do swait(); poseT(PO.P_RAINd) end
    attack = false
    walkspeed = 10
    swait(36)

    for _ = 1, 75 do
        local sky = (RootPart.CFrame * CFnew(0, 600, 0)).Position
        local MoPos = (lMouse.Hit * CFnew(random(-18, 18), 0, random(-18, 18))).Position
        local d = (sky - MoPos).Magnitude
        Lightning(sky, MoPos, 35.137, 7, blue, 25, 2, 4, 0, true, 55)
        spawnFx("Box", V3(1, 1, d), V3(2, 2, d), 0, 1, CFnew(sky, MoPos) * CFnew(0, 0, -d / 2), 25, shade,
            0, 0, 0, nil, nil, nil, nil, true, 0, 50)
        spawnFx("Box", V3(2, 2, 2), V3(5, 5, 5), 0, 1, CFnew(MoPos), 25, blue,
            random(-1, 1), random(-1, 1), random(-1, 1), nil, 192410089, 0.55, 8, true, 0, 50)
        spawnFx("Box", V3(2, 2, 2), V3(5, 5, 5), 0, 1, CFnew(MoPos), 25, shade,
            random(-1, 1), random(-1, 1), random(-1, 1), nil, nil, nil, nil, true, 0, 50)
        spawnFx("Round Slash", V3(0.1, 0.1, 0.1), V3(0.3, 0, 0.3), 0, 1,
            CFnew(MoPos) * CFangles(rad(random(0, 360)), rad(random(0, 360)), rad(random(0, 360))),
            random(25, 50), random(2) == 1 and blue or shade,
            random(-1, 1), random(-1, 1), random(-1, 1), nil, nil, nil, nil, true, 0, 15)
        mdmg(MoPos, 12)
        swait(5)
    end
end

function ATK.SingularityBeam()
    attack = true
    walkspeed = 0
    AttackGyro()
    for _ = 0, 0.5, 0.05 do swait(); poseT(PO.P_HEDa) end

    local holeDist = (Hole.Position - Holetwo.Position).Magnitude
    local chargebeam = CreatePart(Effects, 0, shade, V3(0.25, holeDist, 0.25), false)
    MakeForm(chargebeam, "Cyl")
    chargebeam.CFrame = CFnew(Hole.Position, Holetwo.Position) * CFnew(0, 0, -holeDist / 2) * A(90, 0, 0)
    weldBetween(GUN.PrimaryPart, chargebeam)
    local chargeball = CreatePart(Effects, 0, shade, V3(0.5, 0.5, 0.5), false)
    chargeball.Shape = Enum.PartType.Ball
    chargeball.CFrame = Holetwo.CFrame
    weldBetween(Holetwo, chargeball)
    CreateSound(342793847, Hole, 10, 1, false)
    local bigball = TweenService:Create(chargeball, TweenInfo.new(3.86, Enum.EasingStyle.Linear), { Size = V3(2.5, 2.5, 2.5) })
    bigball:Play()
    bigball.Completed:Wait()
    chargebeam:Destroy()

    local killDist = (Holetwo.Position - lMouse.Hit.Position).Magnitude
    local killbeam = CreatePart(Effects, 0, shade, V3(2.5, killDist, 2.5))
    MakeForm(killbeam, "Cyl")
    local lastT = 0
    killbeam.Touched:Connect(function(victim)
        local now = os.clock()
        if now - lastT > 0.15 then
            lastT = now
            mdmg(victim.Position, 5)
        end
    end)

    task.spawn(function()
        local n = 0
        local toggle = false
        while killbeam.Parent ~= nil do
            n = n + 1
            toggle = not toggle
            local hitCF = lMouse.Hit
            local hitP = hitCF.Position
            killDist = (Holetwo.Position - hitP).Magnitude
            if n % 6 == 1 then mdmg(hitP, 5) end
            RootPart.CFrame = RootPart.CFrame * CFnew(0, 0, 0.1)
            killbeam.Size = V3(2.5, killDist, 2.5)
            killbeam.CFrame = CFnew(Holetwo.Position, hitP) * CFnew(0, 0, -killDist / 2) * A(90, 0, 0)
            if toggle then
                Lightning(Holetwo.Position, hitP, 15, 3, blue, 10, 0, 1, 0, true, 55)
                local hc = Holetwo.CFrame
                for _, base in ipairs({ hc, hitCF }) do
                    spawnFx("Round Slash", ZERO, V3(0.1, 0, 0.1), 0, 1,
                        base * CFangles(rad(random(0, 360)), rad(random(0, 360)), rad(random(0, 360))),
                        10, red, random(-1, 1), random(-1, 1), random(-1, 1), nil, nil, nil, nil, true, 0, 15)
                    spawnFx("Round Slash", ZERO, V3(0.1, 0, 0.1), 0, 1,
                        base * CFangles(rad(random(0, 360)), rad(random(0, 360)), rad(random(0, 360))),
                        10, shade, random(-1, 1), random(-1, 1), random(-1, 1), nil, nil, nil, nil, true, 0, 15)
                end
                spawnFx("Box", ZERO, V3(3, 3, 3), 0, 1, hitCF, 10, red,
                    random(-1, 1), random(-1, 1), random(-1, 1), nil, nil, nil, nil, true, 0, 50)
                spawnFx("Box", ZERO, V3(3, 3, 3), 0, 1, hitCF, 10, shade,
                    random(-1, 1), random(-1, 1), random(-1, 1), nil, nil, nil, nil, true, 0, 50)
            end
            swait()
        end
    end)

    CreateSound(138677306, Holetwo, 10, 1, false)
    CreateSound(415700134, Holetwo, 10, 1, false)
    swait(150)
    CreateSound(3264923, Holetwo, 10, 1, false)
    swait(30)
    chargeball:Destroy()
    killbeam:Destroy()
    walkspeed = 10
    attack = false
end

local function guarded(fn)
    return function()
        local ok, err = pcall(fn)
        if not ok then
            warn("[LC] attack error: " .. tostring(err))
            attack = false
            walkspeed = 10
        end
    end
end
local DO = {
    one  = guarded(ATK.attackone),
    two  = guarded(ATK.attacktwo),
    hed  = guarded(ATK.hedshoot),
    rain = guarded(ATK.painlessrain),
    beam = guarded(ATK.SingularityBeam),
}

local StarterGui = game:GetService("StarterGui")
local function notify(text)
    pcall(function()
        StarterGui:SetCore("SendNotification", { Title = "LC", Text = text, Duration = 2 })
    end)
end

local musicTracks = {}
local activeMusic
local mode = "LC"

local MODES = {
    ["Solid LC"]              = { key = "m", track = "solid",  hip = 3, speed = 50,  wings = true },
    ["At The Speed Of Light"] = { key = "e", track = "speed",  hip = 0, speed = 300 },
    ["Whiner"]                = { key = "q", track = "whiner", hip = 3, speed = 50, wings = true },
}

local function wantedTrack()
    if taunt.Value == "Krump" then return "krump" end
    local cfg = MODES[mode]
    return cfg and cfg.track or "default"
end

local function playTrack(name, restart)
    for n, snd in pairs(musicTracks) do
        if n ~= name and snd.Parent and snd.IsPlaying then snd:Pause() end
    end
    local asset = audioAssets[name]
    if not asset then
        prepareAudio(name)
        activeMusic = nil
        return
    end
    local snd = musicTracks[name]
    if not snd or not snd.Parent then
        snd = Instance.new("Sound")
        snd.Name = randomstring()
        snd.SoundId = asset
        snd.Volume = 1.8
        snd.Looped = true
        snd.Parent = Head
        keep(snd)
        musicTracks[name] = snd
    elseif restart then
        snd.TimePosition = 0
    end
    if not snd.IsPlaying then snd:Play() end
    activeMusic = snd
end

local function ensureMusic()
    local name = wantedTrack()
    local snd = musicTracks[name]
    if audioAssets[name] and (not snd or not snd.Parent) then playTrack(name) end
end

onAudioReady = function(name)
    if name == wantedTrack() then playTrack(name) end
end

local StarterGui = game:GetService("StarterGui")
local function notify(text)
    pcall(function()
        StarterGui:SetCore("SendNotification", { Title = "LC", Text = text, Duration = 2 })
    end)
end

local savedHip = Humanoid.HipHeight
local modeWalking, neckSnap = false, false
local RightWing, LeftWing

local function setMode(name)
    local target = (name == mode) and "LC" or name
    if target == mode then return end
    if mode == "LC" then savedHip = Humanoid.HipHeight end
    mode = target
    local cfg = MODES[target]
    Humanoid.HipHeight = (cfg and cfg.hip) or savedHip
    Humanoid.WalkSpeed = (cfg and cfg.speed) or 10
    RightWing, LeftWing = nil, nil
    if cfg and cfg.wings then
        RightWing = Character:FindFirstChild("RightWing", true)
        LeftWing = Character:FindFirstChild("LeftWing", true)
        if RightWing and not RightWing:IsA("JointInstance") then RightWing = nil end
        if LeftWing and not LeftWing:IsA("JointInstance") then LeftWing = nil end
    end
    playTrack(wantedTrack(), true)
    notify("Mode: " .. target)
end

PO.SOLID_RS = CFnew(1.55, 0.5, 0.5) * A(250, 20, -80) * rscp

local function wingsAnim(S)
    if RightWing then RightWing.C0 = RightWing.C0:Lerp(CFnew(0.15, 0.5, 0.5) * A(0, 105 - 25 * cos(S / 25), 0), 0.25) end
    if LeftWing then LeftWing.C0 = LeftWing.C0:Lerp(CFnew(-0.15, 0.5, 0.5) * A(0, 75 + 25 * cos(S / 25), 0), 0.25) end
end

local function solidAnim(S)
    local nbase = nc0 * CFangles(rad(20), rad(10 * sin(S / 100)), 0)
    if neckSnap then
        Neck.C0 = Neck.C0:Lerp(nbase, 1)
        neckSnap = false
    else
        Neck.C0 = Neck.C0:Lerp(nbase, 0.25)
    end
    if random(1, 60) == 1 then
        Neck.C0 = Neck.C0:Lerp(
            nc0 * CFangles(rad(20 + random(-20, 20)), rad((10 * sin(S / 100)) + random(-20, 20)), rad(random(-20, 20))), 1)
        neckSnap = true
    end

    if modeWalking then
        GunJoint.C0 = GunJoint.C0:Lerp(GJ_REST, 1 / 2)
        RootJoint.C0 = RootJoint.C0:Lerp(rc0 * CFnew(0.5 * cos(S / 50), 0, -0.5 * sin(S / 50)) * A(40, 0, 0), 0.25)
        Neck.C0 = Neck.C0:Lerp(nc0 * CFnew(0, -0.25, 0) * A(-40, 0, 0), 0.25)
        RightShoulder.C0 = RightShoulder.C0:Lerp(PO.SOLID_RS, 1 / 3)
        LeftShoulder.C0 = LeftShoulder.C0:Lerp(CFnew(-1.5, 0.5, 0) * A(-45, 0, -5 - 2 * cos(S / 19)) * lscp, 0.25)
        RightHip.C0 = RightHip.C0:Lerp(CFnew(1, -0.5, -0.5) * A(-20 + 9 * cos(S / 74), 80, 0) * A(5 * cos(S / 37), 0, 0), 0.25)
        LeftHip.C0 = LeftHip.C0:Lerp(CFnew(-1, -1, 0) * A(-20 - 9 * cos(S / 54), -80, 0) * A(-5 * cos(S / 41), 0, 0), 0.25)
    else
        GunJoint.C0 = GunJoint.C0:Lerp(CFnew(0.05, -1, -0.15) * A(-120, 0, 0), 1 / 2)
        RootJoint.C0 = RootJoint.C0:Lerp(rc0 * CFnew(0.5 * cos(S / 50), 0, -0.5 * sin(S / 50)) * A(-25 + 5 * sin(S / 50), 0, 0), 0.7 / 3)
        Neck.C0 = Neck.C0:Lerp(nc0 * A(30 + 5 * sin(S / 50), 0, 0), 0.7 / 3)
        RightShoulder.C0 = RightShoulder.C0:Lerp(PO.SOLID_RS, 1 / 3)
        LeftShoulder.C0 = LeftShoulder.C0:Lerp(CFnew(-1.5, 0.5, 0) * A(-20 + 8.5 * cos(S / 50), 0, -25 - 5 * cos(S / 25)) * lscp, 0.7 / 3)
        RightHip.C0 = RightHip.C0:Lerp(CFnew(1, -0.5, -0.5) * A(-5 + 9 * cos(S / 74), 80, 0) * A(5 * cos(S / 37), 0, 0), 0.7 / 3)
        LeftHip.C0 = LeftHip.C0:Lerp(CFnew(-1, -1, 0) * A(13 - 9 * cos(S / 54), -80, 0) * A(-5 * cos(S / 41), 0, 0), 0.7 / 3)
    end
    GunJoint.C0 = GunJoint.C0:Lerp(GJ_REST, 0.25)
    wingsAnim(S)
end

local function speedAnim(S)
    if modeWalking then
        local c7, s7 = cos(S / 7), sin(S / 7)
        local c35, s35 = cos(S / 3.5), sin(S / 3.5)
        local c12 = cos(S / 12)
        RootJoint.C0 = RootJoint.C0:Lerp(
            rc0 * CFnew(0, 0, -0.175 + 0.025 * c35 + -s35 / 7) * A(9 - 2.5 * c35, 0, 10 * c7), 0.15)
        Neck.C0 = Neck.C0:Lerp(nc0 * A(random(-15, 15), random(-15, 15), random(-15, 15)), 0.35 / 3)
        RightHip.C0 = RightHip.C0:Lerp(
            CFnew(1, -0.925 - 0.5 * c7 / 2, 0.5 * c7 / 2)
            * CFangles(rad(-15 - 35 * c7) + -s7 / 2.5, rad(90 - 2 * c7), 0)
            * A(2.5 * c7, 0, 0), 0.3)
        LeftHip.C0 = LeftHip.C0:Lerp(
            CFnew(-1, -0.925 + 0.5 * c7 / 2, -0.5 * c7 / 2)
            * CFangles(rad(-15 + 35 * c7) + s7 / 2.5, rad(-90 - 2 * c7), 0)
            * A(-2.5 * c7, 0, 0), 0.3)
        RightShoulder.C0 = RightShoulder.C0:Lerp(
            CFnew(1.5, 0.5, 0) * A(-60 - 5 * c12, -2.5 * c12, 5 + 2.5 * c12) * rscp, 1 / 3)
        LeftShoulder.C0 = LeftShoulder.C0:Lerp(
            CFnew(-1, 0.5 + 0.05 * sin(S / 30), 0.025 * cos(S / 20)) * CFangles(rad(-70) * c7, rad(-90), rad(-5)), 0.1)
        GunJoint.C0 = GunJoint.C0:Lerp(GJ_REST, 1 / 2)
    else
        local s5 = sin(S / 5)
        RootJoint.C0 = RootJoint.C0:Lerp(rc0 * CFnew(0, 0, -0.2) * A(-S * 6, 0, 0), 0.25)
        Neck.C0 = Neck.C0:Lerp(nc0, 0.25)
        RightShoulder.C0 = RightShoulder.C0:Lerp(CFnew(1.5, 0.5, 0) * A(-75 * s5, 0, 0) * rscp, 0.25)
        LeftShoulder.C0 = LeftShoulder.C0:Lerp(CFnew(-1.5, 0.5, 0) * A(75 * s5, 0, 0) * lscp, 0.25)
        RightHip.C0 = RightHip.C0:Lerp(CFnew(1, -1, -0.01) * A(75 * s5, 90, 0), 0.25)
        LeftHip.C0 = LeftHip.C0:Lerp(CFnew(-1, -1, -0.01) * A(-75 * s5, -90, 0), 0.25)
        GunJoint.C0 = GunJoint.C0:Lerp(GJ_REST, 0.25)
    end
end

local function whinerAnim(S)
    local s15 = sin(S / 15)
    local c15 = cos(S / 15)
    if modeWalking then
        RootJoint.C0 = RootJoint.C0:Lerp(rc0 * CFnew(0, 0, 0.5 * c15) * A(20 - 2.5 * s15, 0, 0), 0.25)
        Neck.C0 = Neck.C0:Lerp(nc0 * A(-10 - 10 * s15, 0, 0), 0.25)
        RightShoulder.C0 = RightShoulder.C0:Lerp(CFnew(1.5, 0.5 + 0.25 * s15, 0) * A(-50 + 5 * s15, 0, 0) * rscp, 0.25)
        LeftShoulder.C0 = LeftShoulder.C0:Lerp(CFnew(-1.5, 0.5 + 0.25 * s15, 0) * A(110, 0, 0) * lscp, 0.25)
    else
        RootJoint.C0 = RootJoint.C0:Lerp(rc0 * CFnew(0, 0, 0.5 * c15) * A(-2.5 * s15, 0, 0), 0.25)
        Neck.C0 = Neck.C0:Lerp(nc0 * A(10 - 10 * s15, 0, 0), 0.25)
        RightShoulder.C0 = RightShoulder.C0:Lerp(CFnew(1.5, 0.5 + 0.25 * s15, 0) * A(135 + 5 * s15, 0, 25) * rscp, 0.25)
        LeftShoulder.C0 = LeftShoulder.C0:Lerp(CFnew(-1.5, 0.5 + 0.25 * s15, 0) * A(0, 0, -10 + 10 * c15) * lscp, 0.25)
    end
    RightHip.C0 = RightHip.C0:Lerp(CFnew(1, -1, -0.01) * A(-10, 80, 5 + 5 * s15), 0.25)
    LeftHip.C0 = LeftHip.C0:Lerp(CFnew(-1, -1, -0.01) * A(0, -80, -5 - 5 * s15), 0.25)
    GunJoint.C0 = GunJoint.C0:Lerp(GJ_REST, 0.25)
    wingsAnim(S)
end

local function modeAnim(tv)
    if tv > 2 then modeWalking = true elseif tv < 1 then modeWalking = false end
    if mode == "Solid LC" then
        solidAnim(sine)
    elseif mode == "At The Speed Of Light" then
        speedAnim(sine)
    elseif mode == "Whiner" then
        whinerAnim(sine)
    end
end

local function applyTauntVisual()
    hideGun()
    playTrack(wantedTrack(), taunt.Value == "Krump")
end
keep(taunt:GetPropertyChangedSignal("Value"):Connect(applyTauntVisual))
applyTauntVisual()

keep(lMouse.Button1Down:Connect(function()
    if attack == false and taunt.Value == "None" then
        DO.one()
    end
end))

keep(lMouse.KeyDown:Connect(function(k)
    k = k:lower()
    if k == "z" and attack == false and taunt.Value == "None" then
        DO.hed()
    elseif k == "x" and attack == false and taunt.Value == "None" then
        DO.beam()
    elseif k == "c" and attack == false and taunt.Value == "None" then
        DO.rain()
    elseif k == "v" and attack == false and taunt.Value == "None" then
        DO.two()
    elseif k == "f" then
        taunt.Value = (taunt.Value ~= "Fave") and "Fave" or "None"
    elseif k == "k" then
        taunt.Value = (taunt.Value ~= "Krump") and "Krump" or "None"
    elseif k == "m" then
        setMode("Solid LC")
    elseif k == "e" then
        setMode("At The Speed Of Light")
    elseif k == "q" then
        setMode("Whiner")
    end
end))

local antivoid = Instance.new("Part")
antivoid.Size = V3(400, 10, 400)
antivoid.Anchored = true
antivoid.Transparency = 1
antivoid.CanQuery = false
antivoid.Parent = Workspace
keep(antivoid)

local DOWN4 = V3(0, -4, 0)
local lastRescue = -1000
local attackTicks = 0
local lastLoud = -1

local function rescue()
    local spawnLoc
    for _, b in ipairs(Workspace:GetDescendants()) do
        if b:IsA("SpawnLocation") and not b:IsDescendantOf(Character) then
            spawnLoc = b
        end
    end
    local rp = RootPart.Position
    if spawnLoc then
        RootPart.CFrame = CFnew(spawnLoc.Position.X, spawnLoc.Position.Y + (spawnLoc.Size.Y / 2) + 3, spawnLoc.Position.Z)
    else
        local base = Workspace:FindFirstChild("Base") or Workspace:FindFirstChild("Baseplate")
        if base then
            RootPart.CFrame = CFnew(
                clamp(rp.X, -base.Size.X / 2, base.Size.X / 2),
                base.Position.Y + (base.Size.Y / 2) + 3,
                clamp(rp.Z, -base.Size.X / 2, base.Size.X / 2))
        else
            RootPart.CFrame = CFnew(clamp(rp.X, -100, 100), 20, clamp(rp.Z, -100, 100))
        end
    end
    local flot = Instance.new("BodyPosition")
    local spen = Instance.new("BodyGyro")
    local hu = math.huge
    flot.MaxForce = V3(hu, hu, hu)
    spen.MaxTorque = V3(hu, hu, hu)
    flot.Position = RootPart.Position
    flot.Parent = RootPart
    spen.CFrame = RootPart.CFrame
    spen.Parent = RootPart
    Debris:AddItem(flot, 1)
    Debris:AddItem(spen, 1)
end

local function animTick()
    local v = RootPart.AssemblyLinearVelocity
    local tv = sqrt(v.X * v.X + v.Z * v.Z)
    sine = sine + change
    local c12, s12 = cos(sine / 12), sin(sine / 12)
    local c6, s6 = cos(sine / 6), sin(sine / 6)
    local hit = Workspace:Raycast(RootPart.Position, DOWN4, rayParams)

    if mode ~= "LC" and taunt.Value == "None" then

        RootJoint.C1 = RootJoint.C1:Lerp(rc0, 0.2 / 3)
        Neck.C1 = Neck.C1:Lerp(CFnew(0, -0.5, 0) * A(-90, 0, 180), 0.2 / 3)
        RightHip.C1 = RightHip.C1:Lerp(CFnew(0.5, 1, 0) * A(0, 90, 0), 0.7 / 3)
        LeftHip.C1 = LeftHip.C1:Lerp(CFnew(-0.5, 1, 0) * A(0, -90, 0), 0.7 / 3)
        if attack == false then modeAnim(tv) end
        return
    end

    if taunt.Value == "None" then
        if Anim == "Walk" and tv > 1 then
            RootJoint.C1 = RootJoint.C1:Lerp(rc0 * CFnew(0, 0, 0.1 + 0.05 * c6), 2 / 3)
            Neck.C1 = Neck.C1:Lerp(CFnew(0, -0.5, 0) * A(-90, 0, 180) * CFangles(0, 0, -Head.RotVelocity.Y / 30), 0.2 / 3)
            RightHip.C1 = RightHip.C1:Lerp(CFnew(0.5, 0.95 - 0.2 * s12, -0.15 * s12) * A(-5, 90, 0) * A(0, 0, -10 + 35 * c12), 0.6 / 3)
            LeftHip.C1 = LeftHip.C1:Lerp(CFnew(-0.5, 0.95 + 0.2 * s12, 0.15 * s12) * A(-5, -90, 0) * A(0, 0, 10 + 35 * c12), 0.6 / 3)
        else
            RootJoint.C1 = RootJoint.C1:Lerp(rc0, 0.2 / 3)
            Neck.C1 = Neck.C1:Lerp(CFnew(0, -0.5, 0) * A(-90, 0, 180), 0.2 / 3)
            RightHip.C1 = RightHip.C1:Lerp(CFnew(0.5, 1, 0) * A(0, 90, 0), 0.7 / 3)
            LeftHip.C1 = LeftHip.C1:Lerp(CFnew(-0.5, 1, 0) * A(0, -90, 0), 0.7 / 3)
        end

        if v.Y > 1 and hit == nil then
            Anim = "Jump"
            if attack == false then
                pose(
                    rc0 * A(-5, 0, 0),
                    nc0 * A(-25, 0, 10),
                    RS(-50, 0, 10 * c12),
                    LS(50, 0, -25 - 10 * c12),
                    CFnew(1, -0.4, -0.6) * A(1, 90, 0) * A(-1 * s6, 0, 0),
                    CFnew(-1, -1, 0) * A(0, -85, 0) * A(-1 * s6, 0, 0),
                    GJ_REST
                )
            end
        elseif v.Y < -1 and hit == nil then
            Anim = "Fall"
            if attack == false then
                pose(
                    rc0 * A(15, 0, 0),
                    nc0 * A(-15, 2.5, 5 + 5 * c12),
                    RS(-90 - 4 * c6, 0, 10 * c12),
                    LS(35 - 4 * c6, 0, -45 - 10 * c12),
                    CFnew(1, -0.3, -0.7) * A(-25 + 5 * s12, 90, 0) * A(-1 * s6, 0, 0),
                    CFnew(-1, -0.8, -0.3) * A(-10, -80, 0) * A(-1 * s6, 0, 0),
                    GJ_REST
                )
            end
        elseif tv < 1 and hit ~= nil then
            Anim = "Idle"
            if attack == false then
                change = 1
                pose(
                    rc0 * CFnew(0, 0, 0.05 * c12) * A(15, 0, 0),
                    nc0 * A(-15 - 3 * c12, 5, 0),
                    RS(-53.75 + 1.75 * c12, 0, 5, 1.5, 0.5 + 0.1 * c12, 0),
                    LS(15 - 1.5 * c12, -6 * c12, -6 * c12, -1.5, 0.5 + 0.1 * c12, 0),
                    hip(1, -1.1 - 0.05 * c12, 0, 15, 80, 0, -4, 0, 0),
                    hip(-1, -1.1 - 0.05 * c12, 0, 10, -70, 0, -5, 0, 0),
                    CFnew(0.05, -1, -0.15) * A(-106.3 - 0.9 * c12, 0, 0)
                )
            end
        elseif tv > 2 and hit ~= nil then
            Anim = "Walk"
            if attack == false then
                pose(
                    rc0 * CFnew(0, 0, 0.05 * c12) * A(20, 2.5 * c12, -2.5 * c12),
                    nc0 * A(-20 - 3 * c12, -2.5 * c12, -2.5 * c12),
                    RS(-60 - 5 * c12, -2.5 * c12, 5 + 2.5 * c12),
                    LS(20 - 45 * c12, -10 * c12, 2.5 * c12, -1.5, 0.5, -0.2 * c12),
                    hip(1, -1, 0, 0, 85, 0),
                    hip(-1, -1, 0, 0, -85, 0),
                    CFnew(0.05, -1, -0.15) * A(-93.75 + 7.25 * c12, 0, 0)
                )
            end
        end
    elseif taunt.Value == "Fave" then
        RootJoint.C0 = rc0
        Neck.C0 = nc0
        RightShoulder.C0 = RS(0, 0, 0)
        LeftShoulder.C0 = LS(0, 0, -135, -1.3, 0.7, 0)
        RightHip.C0 = CFnew(0.5, -2, 0)
        LeftHip.C0 = CFnew(-0.9, -1.9, 0) * A(0, 0, -25)
        RightHip.C1 = CFnew()
        LeftHip.C1 = CFnew()
        GunJoint.C0 = CFnew(0, -1, 0) * A(-90, 0, 0)
    elseif taunt.Value == "Krump" then
        RootJoint.C0 = rc0 * CFnew(sin(sine / 3), cos(sine / 3), -0.75) * A(0, -10, 0)
        Neck.C0 = nc0
        RightShoulder.C0 = RS(0, 0, 90, 1.5, 1, 0)
        LeftShoulder.C0 = LS(0, 0, -90, -1.5, 1, 0)
        RightHip.C0 = CFnew(1.5, -1, 0) * A(0, 0, 70)
        LeftHip.C0 = CFnew(-0.5, -1.25, -0.25) * A(0, 0, 10)
        RightHip.C1 = CFnew()
        LeftHip.C1 = CFnew()
        GunJoint.C0 = CFnew(0, -1, 0) * A(-90, 0, 0)
    end
end

local mainTick = function()
    if alreadyfixing then return end
    if attack then
        attackTicks = attackTicks + 1
        if attackTicks > 900 then
            attack = false
            attackTicks = 0
        end
    else
        attackTicks = 0
    end
    if not RootPart or not RootPart.Parent then return end

    hue = (hue + STEP * 12) % 1
    curColor = Color3.fromHSV(hue, 1, 1)
    if tickN % 30 == 0 then
        hideGun()
        ensureMusic()
        stripDefaultAnimation()
        local cfg = MODES[mode]
        if cfg then
            if cfg.speed and Humanoid.WalkSpeed ~= cfg.speed then Humanoid.WalkSpeed = cfg.speed end
            if cfg.hip and Humanoid.HipHeight ~= cfg.hip then Humanoid.HipHeight = cfg.hip end
        end
    end
    if fixBtn then
        fixBtn.TextColor3 = curColor
        exitBtn.TextColor3 = curColor
    end

    if outerm then
        local loud = eee.PlaybackLoudness
        local ms = activeMusic
        if ms and ms.Parent then
            local ml = ms.PlaybackLoudness
            if ml > loud then loud = ml end
        end
        if loud ~= lastLoud then
            lastLoud = loud
            local l = loud / 50
            local sc = V3(1, l, l)
            outerm.Scale = sc
            if outerm2 then
                if sc.Y > 0.1 then
                    outerm2.Scale = sc + V3(-0.1, 0.5, 0.5)
                else
                    outerm2.Scale = sc
                end
            end
        end
        local vp = outerm.Parent
        if vp and vp:IsA("BasePart") then vp.Color = curColor end
    end

    if #visParts > 0 then
        local rp = RootPart.Position
        local gy = rp.Y - (3 + Humanoid.HipHeight)
        visParts[1].CFrame = CFnew(rp.X, gy + 0.1, rp.Z) * VIS_ROT
        if visParts[2] then visParts[2].CFrame = CFnew(rp.X, gy + 0.05, rp.Z) * VIS_ROT end
    end

    if doe <= 360 then doe = doe + 2 else doe = 0 end

    if tickN % 4 == 0 then
        local rp = RootPart.Position
        antivoid.Position = V3(rp.X, Workspace.FallenPartsDestroyHeight + 5, rp.Z)
    end
    if RootPart.Position.Y < Workspace.FallenPartsDestroyHeight + 50 and tickN - lastRescue > 30 then
        lastRescue = tickN
        rescue()
    end

    if tickN % 10 == 0 then
        if SongSync.Value > eee.TimeLength and eee.TimeLength >= 0.1 then
            SongSync.Value = 0
        end
        if eee.TimePosition < (SongSync.Value - 1) or eee.TimePosition > (SongSync.Value + 1) then
            eee.TimePosition = SongSync.Value
        end
    end

    animTick()
end

do
    local acc, fpsAcc, fpsN = 0, 0, 0
    keep(RunService.Heartbeat:Connect(function(dt)
        fpsAcc = fpsAcc + dt
        fpsN = fpsN + 1
        if fpsAcc >= 1 then
            local fps = fpsN / fpsAcc
            fpsAcc, fpsN = 0, 0
            local target = 1
            if fps < 25 then target = 0.35
            elseif fps < 40 then target = 0.6
            elseif fps < 52 then target = 0.85 end
            quality = quality + (target - quality) * 0.5
        end

        acc = acc + dt
        if acc < STEP then return end
        local steps = floor(acc / STEP)
        if steps > 3 then
            steps = 3
            acc = 0
        else
            acc = acc - steps * STEP
        end
        for _ = 1, steps do
            tickN = tickN + 1
            stepWaiters()
            stepEffects()
            mainTick()
        end
    end))
end

setupDone = true
destroyMainModule()
warn(string.format("[LC] loaded in %.2fs", os.clock() - LOAD_T0))
end

main()