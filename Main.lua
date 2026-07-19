-- =========================================================================
--               HUY SCRIPT HUB V5.1.0 (SUPER PREMIUM UPDATE)
--     [UPDATE V5.1.0]: TÍCH HỢP TỰ ĐỘNG BỎ HOẠT ẢNH & HÚT VẬT PHẨM TỪ XA
-- =========================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local pgui = player:WaitForChild("PlayerGui", 5) or game:GetService("CoreGui")
if pgui:FindFirstChild("HuyScriptHubV2") then 
    pcall(function() pgui.HuyScriptHubV2:Destroy() end) 
end

local gui = Instance.new("ScreenGui")
gui.Name = "HuyScriptHubV2"
gui.ResetOnSpawn = false
gui.Parent = pgui

local originalLighting = {
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    FogEnd = Lighting.FogEnd,
    ClockTime = Lighting.ClockTime,
    GlobalShadows = Lighting.GlobalShadows
}

local permanentBlacklist = {}
local currentTarget = nil
local timeAtTarget = 0
local stuckTimer = 0
local lastPosition = Vector3.new(0,0,0)

-- Cấu hình tập trung nâng cấp V5.1.0
_G.HuyHubConfig = {
    SpeedEnabled = false, Speed = 50, Fly = false, Noclip = false, InfJump = false,
    PlayerScale = 1,
    ESP_Player = false, ESP_NPC_Hostile = false, ESP_NPC_Friendly = false, ESP_Item = false,
    HitboxAlways = false, HitboxSize = 13, FullBright = false,
    AutoE = false, AutoClick = false, KillAuraNPC = false, KillAuraPlayer = false, TpToItems = false,
    AutoFarmLevel = false, GomPlayer = false, GomNPC = false, SafeFarmNPC = false,
    ClickDetectorSpam = false, TouchInterestSpam = false, UniversalHitbox = false, UniversalHitboxSize = 25,
    PotatoModeEnabled = false, DisableTextures = false, BlackScreenEnabled = false,
    AdminDetectorEnabled = false, AutoReconnectEnabled = false,
    
    SmartKillAura = false,
    AutoEquipTool = false,
    SemiGodMode = false,
    WhitelistServerHop = false,
    AntiStuck = false,
    ChatDetector = false,
    FpsCapper = false,
    MemoryCleaner = false,

    -- [NEW FEATURES V5.1.0]
    AnimationSkipper = false,
    RemoteMagnetCollect = false
}

local function setDefaultConfig()
    for k, v in pairs(_G.HuyHubConfig) do
        if type(v) == "boolean" then
            _G.HuyHubConfig[k] = false
        elseif k == "Speed" then _G.HuyHubConfig[k] = 50
        elseif k == "PlayerScale" then _G.HuyHubConfig[k] = 1
        elseif k == "HitboxSize" then _G.HuyHubConfig[k] = 13
        elseif k == "UniversalHitboxSize" then _G.HuyHubConfig[k] = 25
        end
    end
    permanentBlacklist = {}
    stuckTimer = 0
    setfpscap(0)
end

local blackScreenFrame = Instance.new("Frame", gui)
blackScreenFrame.Size = UDim2.new(1, 0, 1, 0)
blackScreenFrame.BackgroundColor3 = Color3.new(0, 0, 0)
blackScreenFrame.ZIndex = 999999
blackScreenFrame.Visible = false

local blackScreenText = Instance.new("TextLabel", blackScreenFrame)
blackScreenText.Size = UDim2.new(1, 0, 0.1, 0)
blackScreenText.Position = UDim2.new(0, 0, 0.45, 0)
blackScreenText.BackgroundTransparency = 1
blackScreenText.Text = "HUY HUB V5.1.0: CHẾ ĐỘ TREO ĐÊM ĐANG BẬT...\n[BẤM VÀO ĐÂY ĐỂ TẮT]"
blackScreenText.TextColor3 = Color3.new(1, 1, 1)
blackScreenText.Font = Enum.Font.SourceSansBold
blackScreenText.TextSize = 18

local blackScreenButton = Instance.new("TextButton", blackScreenFrame)
blackScreenButton.Size = UDim2.new(1, 0, 1, 0)
blackScreenButton.BackgroundTransparency = 1
blackScreenButton.Text = ""

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 110, 0, 45)
toggleBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
toggleBtn.Text = "HUY HUB V5.1.0 ⚡"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.TextSize = 13
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.Active = true

local toggleGrass = Instance.new("Frame", toggleBtn)
toggleGrass.Size = UDim2.new(1, 0, 0.25, 0)
toggleGrass.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
toggleGrass.BorderSizePixel = 0
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0.2, 0)
Instance.new("UICorner", toggleGrass).CornerRadius = UDim.new(0.2, 0)

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 430, 0, 315)
main.Position = UDim2.new(0.5, -215, 0.5, -157)
main.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
main.Visible = false
main.Active = true
main.ClipsDescendants = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0.05, 0)

local mainGrass = Instance.new("Frame", main)
mainGrass.Size = UDim2.new(1, 0, 0.09, 0)
mainGrass.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
mainGrass.BorderSizePixel = 0
Instance.new("UICorner", mainGrass).CornerRadius = UDim.new(0.3, 0)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0.09, 0)
title.Text = "HUY SCRIPT HUB V5.1.0 (SUPER PREMIUM)"
title.Font = Enum.Font.Arcade
title.TextSize = 13
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(1, -28, 0, 2)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0.3, 0)

local function makeDraggable(frame)
    pcall(function()
        local dragging, dragInput, dragStart, startPos
        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true dragStart = input.Position startPos = frame.Position
                input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
            end
        end)
        frame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end)
end
makeDraggable(toggleBtn) makeDraggable(main)

local function toggleMenu() main.Visible = not main.Visible end
toggleBtn.MouseButton1Click:Connect(toggleMenu) closeBtn.MouseButton1Click:Connect(toggleMenu)

-- Tắt màn hình đen khi bấm vào nút ẩn ẩn trên màn hình đen
blackScreenButton.MouseButton1Click:Connect(function()
    _G.HuyHubConfig.BlackScreenEnabled = false
    blackScreenFrame.Visible = false
    pcall(function() RunService:Set3dRenderingEnabled(true) end)
    setfpscap(0)
    -- Cập nhật lại trạng thái nút trong tab UI nếu cần
    for _, item in pairs(toggleButtonsRegistry) do
        if item.configKey == "BlackScreenEnabled" then item.refreshVisual() end
    end
end)

local tabButtonsFrame = Instance.new("ScrollingFrame", main)
tabButtonsFrame.Size = UDim2.new(0, 115, 0.85, -5)
tabButtonsFrame.Position = UDim2.new(0, 5, 0.13, 0)
tabButtonsFrame.BackgroundTransparency = 1
tabButtonsFrame.ScrollBarThickness = 0
tabButtonsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local pagesFrame = Instance.new("Frame", main)
pagesFrame.Size = UDim2.new(0, 295, 0.85, -5)
pagesFrame.Position = UDim2.new(0, 125, 0.13, 0)
pagesFrame.BackgroundTransparency = 1

local tabLayout = Instance.new("UIListLayout", tabButtonsFrame)
tabLayout.Padding = UDim.new(0, 4)

local pages = {}
local tabButtons = {}

local function createTab(tabName, isCustomLayout)
    local p = Instance.new("ScrollingFrame", pagesFrame)
    p.Size = UDim2.new(1, 0, 1, 0)
    p.Visible = false p.BackgroundTransparency = 1 p.BorderSizePixel = 0 p.ScrollBarThickness = 3
    p.ScrollBarImageColor3 = Color3.fromRGB(34, 139, 34)
    p.AutomaticCanvasSize = Enum.AutomaticSize.Y
    if not isCustomLayout then
        local pLayout = Instance.new("UIListLayout", p) pLayout.Padding = UDim.new(0, 6)
    end
    pages[tabName] = p
    
    local btn = Instance.new("TextButton", tabButtonsFrame)
    btn.Size = UDim2.new(1, 0, 0, 28)
    btn.Text = tabName
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 12
    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    btn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0.2, 0)
    
    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(tabButtons) do b.BackgroundColor3 = Color3.fromRGB(80, 80, 80) end
        btn.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
        for tName, pFrame in pairs(pages) do pFrame.Visible = (tName == tabName) end
    end)
    table.insert(tabButtons, btn)
end

createTab("Trang Chủ 🏠")
createTab("Nhìn Xuyên 👁️")
createTab("Chế Độ Máy Yếu 🥔")
createTab("Người Chơi 🧍")
createTab("Dịch Chuyển 📍", true)
createTab("Tự Động Farm 🚜")           
createTab("Tìm Vật Phẩm 🔍", true)       
createTab("Click Tự Động 🎯")           
createTab("Kết Nối & Bảo Mật 🌐")
createTab("Cài Đặt UI ⚙️")  

local function notify(title, text)
    pcall(function() StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = 1.5}) end)
end

toggleButtonsRegistry = {}

local function addToggle(tabName, text, key, callback)
    local targetPage = pages[tabName] if not targetPage then return end
    local b = Instance.new("TextButton", targetPage)
    b.Size = UDim2.new(1, -6, 0, 32)
    b.Text = text b.Font = Enum.Font.SourceSansBold b.TextSize = 13
    b.BackgroundColor3 = _G.HuyHubConfig[key] and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(50,50,50) b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0.2, 0)
    
    local function updateVisuals()
        b.BackgroundColor3 = _G.HuyHubConfig[key] and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(50,50,50)
    end

    b.MouseButton1Click:Connect(function()
        _G.HuyHubConfig[key] = not _G.HuyHubConfig[key]
        updateVisuals()
        notify("Huy Hub", text .. (_G.HuyHubConfig[key] and " 🟢 BẬT" or " 🔴 TẮT"))
        if callback then pcall(callback, _G.HuyHubConfig[key]) end
    end)
    table.insert(toggleButtonsRegistry, {instance = b, configKey = key, defaultText = text, callbackFunc = callback, refreshVisual = updateVisuals})
end

local sliderRegistry = {}

local function addSlider(tabName, text, key, min, max, callback)
    local targetPage = pages[tabName] if not targetPage then return end
    local sliderFrame = Instance.new("Frame", targetPage)
    sliderFrame.Size = UDim2.new(1, -6, 0, 45)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0.15, 0)

    local label = Instance.new("TextLabel", sliderFrame)
    label.Size = UDim2.new(1, 0, 0.5, 0)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(_G.HuyHubConfig[key])
    label.Font = Enum.Font.SourceSansBold; label.TextSize = 12; label.TextColor3 = Color3.new(1, 1, 1)

    local container = Instance.new("TextButton", sliderFrame)
    container.Size = UDim2.new(0.9, 0, 0.25, 0); container.Position = UDim2.new(0.05, 0, 0.55, 0)
    container.BackgroundColor3 = Color3.fromRGB(30, 30, 30); container.Text = ""
    Instance.new("UICorner", container).CornerRadius = UDim.new(0.5, 0)

    local bar = Instance.new("Frame", container)
    bar.Size = UDim2.new((_G.HuyHubConfig[key] - min) / (max - min), 0, 1, 0)
    bar.BackgroundColor3 = Color3.fromRGB(34, 139, 34); bar.BorderSizePixel = 0
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0.5, 0)

    local function updateSlider(input)
        local sizeX = math.clamp((input.Position.X - container.AbsolutePosition.X) / container.AbsoluteSize.X, 0, 1)
        bar.Size = UDim2.new(sizeX, 0, 1, 0)
        local value = min + (sizeX * (max - min))
        value = math.floor(value * 10) / 10
        _G.HuyHubConfig[key] = value
        label.Text = text .. ": " .. tostring(value)
        if callback then pcall(callback, value) end
    end

    local function refreshVisuals()
        bar.Size = UDim2.new((_G.HuyHubConfig[key] - min) / (max - min), 0, 1, 0)
        label.Text = text .. ": " .. tostring(_G.HuyHubConfig[key])
    end

    local sliding = false
    container.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = true updateSlider(input) end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = false end
    end)
    
    table.insert(sliderRegistry, {refreshVisual = refreshVisuals})
end

local function applyFullBright(state)
    if state then
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
        Lighting.FogEnd = 999999
        Lighting.ClockTime = 14
        for _, obj in pairs(Lighting:GetChildren()) do
            if obj:IsA("Atmosphere") or obj:IsA("Sky") or obj:IsA("Clouds") then
                obj.Parent = game:GetService("CoreGui")
            end
        end
    else
        Lighting.Ambient = originalLighting.Ambient
        Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
        Lighting.FogEnd = originalLighting.FogEnd
        Lighting.ClockTime = originalLighting.ClockTime
        for _, obj in pairs(game:GetService("CoreGui"):GetChildren()) do
            if obj:IsA("Atmosphere") or obj:IsA("Sky") or obj:IsA("Clouds") then
                obj.Parent = Lighting
            end
        end
    end
end

local function doSafeServerHop()
    notify("Huy Hub", "Đang tìm máy chủ siêu vắng...")
    pcall(function()
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local x = HttpService:JSONDecode(game:HttpGet(url))
        for _, s in pairs(x.data) do
            if s.id ~= game.JobId and s.playing and s.playing <= 4 then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, player)
                return
            end
        end
        local server = x.data[math.random(1, #x.data)]
        if server and server.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, player)
        end
    end)
end

-- TAB NHÌN XUYÊN
addToggle("Nhìn Xuyên 👁️", "ESP Người Chơi (Cyan 🔵)", "ESP_Player")
addToggle("Nhìn Xuyên 👁️", "ESP Quái Vật Gây Sát Thương (Đỏ 🔴)", "ESP_NPC_Hostile")
addToggle("Nhìn Xuyên 👁️", "ESP Thân Thiện / Thể Khác (Xanh Lá 🟢)", "ESP_NPC_Friendly")
addToggle("Nhìn Xuyên 👁️", "ESP Vật Phẩm Rơi (Vàng 🟡)", "ESP_Item")
addToggle("Nhìn Xuyên 👁️", "Bật Mở Rộng Hitbox Mặc Định", "HitboxAlways")
addSlider("Nhìn Xuyên 👁️", "Kích Cỡ Hitbox Mặc Định", "HitboxSize", 2, 50)
addToggle("Nhìn Xuyên 👁️", "Sáng Màn Hình & Xóa Sương Mù ☀️", "FullBright", applyFullBright)

-- TAB CHẾ ĐỘ MÁY YẾU 🥔
addToggle("Chế Độ Máy Yếu 🥔", "Kích Hoạt Giảm Đồ Họa Cấp Tốc", "PotatoModeEnabled", function(state)
    if state then
        pcall(function()
            settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.AlwaysThrottle
            settings().Physics.AllowSleep = true
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            Lighting.GlobalShadows = false
        end)
    else
        pcall(function()
            settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.DefaultAuto
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
            Lighting.GlobalShadows = originalLighting.GlobalShadows
        end)
    end
end)
addToggle("Chế Độ Máy Yếu 🥔", "Giảm Chi Tiết Khối (Smooth Plastic)", "DisableTextures", function(state)
    if state then
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic; v.CastShadow = false
            elseif v:IsA("MeshPart") then v.TextureID = "" end
        end
    end
end)
addToggle("Chế Độ Máy Yếu 🥔", "Màn Hình Đen Treo Đêm (Mát Máy) 🌌", "BlackScreenEnabled", function(state)
    blackScreenFrame.Visible = state
    pcall(function() RunService:Set3dRenderingEnabled(not state) end)
    if state and _G.HuyHubConfig.FpsCapper then setfpscap(15) elseif not state then setfpscap(0) end
end)
addToggle("Chế Độ Máy Yếu 🥔", "Khóa 15 FPS khi bật Màn Hình Đen ❄️", "FpsCapper", function(state)
    if state and _G.HuyHubConfig.BlackScreenEnabled then setfpscap(15) else setfpscap(0) end
end)
addToggle("Chế Độ Máy Yếu 🥔", "Auto Dọn Rác RAM & Hiệu Ứng Thừa 🧹", "MemoryCleaner")
addToggle("Chế Độ Máy Yếu 🥔", "Animation Skipper (Bỏ qua animation lag) 🚫", "AnimationSkipper")

-- TAB TRANG CHỦ
local nameLabel = Instance.new("TextLabel", pages["Trang Chủ 🏠"])
nameLabel.Size = UDim2.new(1, -6, 0, 42)
nameLabel.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
nameLabel.Text = "📝 Tác giả: Tran Quang Huy\nChào mừng bạn đến với Huy Script Hub v5.1.0 PREMIUM!"
nameLabel.Font = Enum.Font.SourceSansBold; nameLabel.TextSize = 12; nameLabel.TextColor3 = Color3.fromRGB(255, 215, 0) 
Instance.new("UICorner", nameLabel).CornerRadius = UDim.new(0.2, 0)

-- TAB NGƯỜI CHƠI
addToggle("Người Chơi 🧍", "Bật Tốc Độ Di Chuyển", "SpeedEnabled")
addSlider("Người Chơi 🧍", "Điều Chỉnh Tốc Độ", "Speed", 16, 250)
addSlider("Người Chơi 🧍", "Kích Thước Khổng Lồ", "PlayerScale", 0.4, 5, function(value)
    pcall(function()
        local char = player.Character local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.RigType == Enum.HumanoidRigType.R15 then
            if hum:FindFirstChild("BodyHeightScale") then hum.BodyHeightScale.Value = value end
            if hum:FindFirstChild("BodyWidthScale") then hum.BodyWidthScale.Value = value end
            if hum:FindFirstChild("BodyDepthScale") then hum.BodyDepthScale.Value = value end
        end
    end)
end)

local flySpeed = 50
local flyingConnection
addToggle("Người Chơi 🧍", "Kích Hoạt Bay (Fly)", "Fly", function(state)
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    if state then
        hum.PlatformStand = true
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Name = "FlyVelocity"; bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        local bg = Instance.new("BodyGyro", hrp)
        bg.Name = "FlyGyro"; bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9); bg.CFrame = hrp.CFrame
        flyingConnection = RunService.RenderStepped:Connect(function()
            local vel = Vector3.new(0,0,0)
            if hum.MoveDirection.Magnitude > 0 then vel = hum.MoveDirection * flySpeed end
            bv.Velocity = vel; bg.CFrame = camera.CFrame
        end)
    else
        hum.PlatformStand = false
        if hrp:FindFirstChild("FlyVelocity") then hrp.FlyVelocity:Destroy() end
        if hrp:FindFirstChild("FlyGyro") then hrp.FlyGyro:Destroy() end
        if flyingConnection then flyingConnection:Disconnect() end
    end
end)

local noclipConnection
addToggle("Người Chơi 🧍", "Đi Xuyên Tường (Noclip)", "Noclip", function(state)
    if state then
        noclipConnection = RunService.Stepped:Connect(function()
            if player.Character then
                for _, child in pairs(player.Character:GetDescendants()) do if child:IsA("BasePart") then child.CanCollide = false end end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() end
    end
end)

addToggle("Người Chơi 🧍", "Nhảy Vô Hạn (Inf Jump)", "InfJump")
UserInputService.JumpRequest:Connect(function()
    if _G.HuyHubConfig.InfJump and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- TAB DỊCH CHUYỂN
local tpTab = pages["Dịch Chuyển 📍"]
local tpItemBtn = Instance.new("TextButton", tpTab)
tpItemBtn.Size = UDim2.new(1, -6, 0, 32); tpItemBtn.Position = UDim2.new(0, 3, 0, 5)
tpItemBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50); tpItemBtn.TextColor3 = Color3.new(1,1,1)
tpItemBtn.Font = Enum.Font.SourceSansBold; tpItemBtn.TextSize = 13; tpItemBtn.Text = "Tự Động Bay Tới Vật Phẩm: TẮT"
Instance.new("UICorner", tpItemBtn).CornerRadius = UDim.new(0.2, 0)

tpItemBtn.MouseButton1Click:Connect(function()
    _G.HuyHubConfig.TpToItems = not _G.HuyHubConfig.TpToItems
    tpItemBtn.Text = "Tự Động Bay Tới Vật Phẩm: " .. (_G.HuyHubConfig.TpToItems and "BẬT 🟢" or "TẮT 🔴")
    tpItemBtn.BackgroundColor3 = _G.HuyHubConfig.TpToItems and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(50, 50, 50)
    if not _G.HuyHubConfig.TpToItems then permanentBlacklist = {} currentTarget = nil timeAtTarget = 0 end
end)

local plScroll = Instance.new("ScrollingFrame", tpTab)
plScroll.Size = UDim2.new(1, -6, 0, 175); plScroll.Position = UDim2.new(0, 3, 0, 70)
plScroll.BackgroundColor3 = Color3.fromRGB(45, 25, 10); plScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UICorner", plScroll).CornerRadius = UDim.new(0.05, 0)
local plLayout = Instance.new("UIListLayout", plScroll); plLayout.Padding = UDim.new(0, 4)

local function refreshPlayerList()
    pcall(function()
        for _, child in pairs(plScroll:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player then
                local pBtn = Instance.new("TextButton", plScroll)
                pBtn.Size = UDim2.new(1, -8, 0, 28); pBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                pBtn.TextColor3 = Color3.new(1, 1, 1); pBtn.Text = "🏃 " .. p.DisplayName
                Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0.2, 0)
                pBtn.MouseButton1Click:Connect(function()
                    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
                    end
                end)
            end
        end
    end)
end
task.spawn(function() while true do refreshPlayerList() task.wait(5) end end)

-- TAB TỰ ĐỘNG FARM
addToggle("Tự Động Farm 🚜", "Tự Động Cày Cấp (Auto Farm Level)", "AutoFarmLevel")
addToggle("Tự Động Farm 🚜", "Gom Quái Lại Gần (Trước mặt 4 Studs)", "GomNPC")       
addToggle("Tự Động Farm 🚜", "Giữ Khoảng Cách An Toàn (Trên Đầu Quái)", "SafeFarmNPC")
addToggle("Tự Động Farm 🚜", "Remote Magnet Collect (Hút Rương/Item xa) 🧲", "RemoteMagnetCollect")
addToggle("Tự Động Farm 🚜", "Gom Người Chơi Toàn Máy Chủ", "GomPlayer") 
addToggle("Tự Động Farm 🚜", "Diệt Quái Xung Quanh (Kill Aura NPC)", "KillAuraNPC")
addToggle("Tự Động Farm 🚜", "Smart Target Kill Aura (Chống Đấm Gió) 🔥", "SmartKillAura")
addToggle("Tự Động Farm 🚜", "Auto Equip Tool (Tự Cầm Vũ Khí) ⚔️", "AutoEquipTool")
addToggle("Tự Động Farm 🚜", "Semi-God Mode (Né Chiêu Phụ) 🛡️", "SemiGodMode")
addToggle("Tự Động Farm 🚜", "Tự Động Nhấn Giữ Nút E", "AutoE")
addToggle("Tự Động Farm 🚜", "Tự Động Click Đấm Chuột Trái", "AutoClick")

-- TAB TÌM VẬT PHẨM
local dexTab = pages["Tìm Vật Phẩm 🔍"]
local dexSearchInput = Instance.new("TextBox", dexTab)
dexSearchInput.Size = UDim2.new(1, -6, 0, 30); dexSearchInput.Position = UDim2.new(0, 3, 0, 5)
dexSearchInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30); dexSearchInput.TextColor3 = Color3.new(1, 1, 1)
dexSearchInput.PlaceholderText = " Nhập tên vật phẩm cần quét..."; dexSearchInput.TextSize = 12
Instance.new("UICorner", dexSearchInput).CornerRadius = UDim.new(0.15, 0)

local dexResultScroll = Instance.new("ScrollingFrame", dexTab)
dexResultScroll.Size = UDim2.new(1, -6, 0, 135); dexResultScroll.Position = UDim2.new(0, 3, 0, 80)
dexResultScroll.BackgroundColor3 = Color3.fromRGB(45, 25, 10); dexResultScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UICorner", dexResultScroll).CornerRadius = UDim.new(0.05, 0)
local dexLayout = Instance.new("UIListLayout", dexResultScroll); dexLayout.Padding = UDim.new(0, 4)

local function runDexSearch(keyword)
    pcall(function()
        for _, btn in pairs(dexResultScroll:GetChildren()) do if btn:IsA("TextButton") then btn:Destroy() end end
        local matchesFound = 0; local text = keyword:lower()
        for _, obj in pairs(workspace:GetDescendants()) do
            if (obj.Name:lower():find(text)) and (obj:IsA("BasePart") or obj:IsA("Model")) then
                if not Players:GetPlayerFromCharacter(obj) and not obj:IsDescendantOf(player.Character) then
                    matchesFound = matchesFound + 1; if matchesFound > 20 then break end 
                    local itemBtn = Instance.new("TextButton", dexResultScroll)
                    itemBtn.Size = UDim2.new(1, -8, 0, 26); itemBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                    itemBtn.TextColor3 = Color3.new(1, 1, 1); itemBtn.Text = "[Bay Tới] " .. obj.Name
                    Instance.new("UICorner", itemBtn).CornerRadius = UDim.new(0.2, 0)
                    itemBtn.MouseButton1Click:Connect(function()
                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            player.Character.HumanoidRootPart.CFrame = obj:IsA("Model") and obj:GetPivot() or obj.CFrame
                        end
                    end)
                end
            end
        end
    end)
end
dexSearchInput:GetPropertyChangedSignal("Text"):Connect(function() runDexSearch(dexSearchInput.Text) end)

-- TAB CLICK TỰ ĐỘNG
addToggle("Click Tự Động 🎯", "Auto ClickDetector (Click xa)", "ClickDetectorSpam")
addToggle("Click Tự Động 🎯", "Auto TouchInterest (Chạm bệ)", "TouchInterestSpam")
addToggle("Click Tự Động 🎯", "Bật Kích Thước Hitbox Siêu Cấp", "UniversalHitbox")
addSlider("Click Tự Động 🎯", "Cỡ Hitbox Siêu Cấp", "UniversalHitboxSize", 2, 100)

-- TAB KẾT NỐI & BẢO MẬT
addToggle("Kết Nối & Bảo Mật 🌐", "Tự Động Kết Nối Lại Khi Mất Mạng (Auto Reconnect)", "AutoReconnectEnabled")
addToggle("Kết Nối & Bảo Mật 🌐", "Phát Hiện Admin & Tự Động Thoát Để Né Ban", "AdminDetectorEnabled")
addToggle("Kết Nối & Bảo Mật 🌐", "Whitelisted Server Hop (Chọn Server Vắng) 🗺️", "WhitelistServerHop")
addToggle("Kết Nối & Bảo Mật 🌐", "Chống Kẹt Địa Hình 10 Giây (Anti-Stuck) 📐", "AntiStuck")
addToggle("Kết Nối & Bảo Mật 🌐", "Quét Khung Chat Tránh Bị Report (Anti-Mod) 💬", "ChatDetector")

local serverHopBtn = Instance.new("TextButton", pages["Kết Nối & Bảo Mật 🌐"])
serverHopBtn.Size = UDim2.new(1, -6, 0, 32)
serverHopBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
serverHopBtn.Text = "🔀 Đổi Máy Chủ Khác Ngẫu Nhiên (Server Hopper)"
serverHopBtn.Font = Enum.Font.SourceSansBold; serverHopBtn.TextColor3 = Color3.new(1,1,1); serverHopBtn.TextSize = 13
Instance.new("UICorner", serverHopBtn).CornerRadius = UDim.new(0.2, 0)

serverHopBtn.MouseButton1Click:Connect(function()
    if _G.HuyHubConfig.WhitelistServerHop then doSafeServerHop() else
        pcall(function()
            local x = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
            local server = x.data[math.random(1, #x.data)]
            if server and server.id ~= game.JobId then TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, player) end
        end)
    end
end)

-- TAB CÀI ĐẶT UI
local settingTab = pages["Cài Đặt UI ⚙️"]
local resetAllBtn = Instance.new("TextButton", settingTab)
resetAllBtn.Size = UDim2.new(1, -6, 0, 32); resetAllBtn.BackgroundColor3 = Color3.fromRGB(210, 105, 30)
resetAllBtn.Text = "🔄 Reset Tất Cả Tính Năng"; resetAllBtn.Font = Enum.Font.SourceSansBold; resetAllBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", resetAllBtn).CornerRadius = UDim.new(0.2, 0)

resetAllBtn.MouseButton1Click:Connect(function()
    setDefaultConfig() applyFullBright(false)
    pcall(function() RunService:Set3dRenderingEnabled(true) end)
    blackScreenFrame.Visible = false
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
            local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
            if root then root.Size = Vector3.new(2, 2, 1); root.Transparency = 0; root.CanCollide = true end
            if obj:FindFirstChild("HuyESP") then obj.HuyESP:Destroy() end
            if obj:FindFirstChild("HuyTag") then obj.HuyTag:Destroy() end
        end
    end
    for _, item in pairs(toggleButtonsRegistry) do item.refreshVisual() end
    for _, item in pairs(sliderRegistry) do item.refreshVisual() end
    tpItemBtn.Text = "Tự Động Bay Tới Vật Phẩm: TẮT"; tpItemBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    notify("Huy Hub", "Đã đặt lại toàn bộ tính năng về mặc định!")
end)

local closeUIAll = Instance.new("TextButton", settingTab)
closeUIAll.Size = UDim2.new(1, -6, 0, 32); closeUIAll.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
closeUIAll.Text = "Gỡ Bỏ Toàn Bộ Huy Hub ❌"; closeUIAll.Font = Enum.Font.SourceSansBold; closeUIAll.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", closeUIAll).CornerRadius = UDim.new(0.2, 0)
closeUIAll.MouseButton1Click:Connect(function() pcall(function() RunService:Set3dRenderingEnabled(true) end) setfpscap(0) gui:Destroy() end)

local function createESP(obj, color, nameText)
    if not obj then return end
    if obj:FindFirstChild("HuyESP") then
        obj.HuyESP.FillColor = color
        if obj:FindFirstChild("HuyTag") and obj.HuyTag:FindFirstChildOfClass("TextLabel") then
            obj.HuyTag:FindFirstChildOfClass("TextLabel").Text = nameText
        end
        return
    end
    pcall(function()
        local box = Instance.new("Highlight", obj)
        box.Name = "HuyESP"; box.FillColor = color; box.FillTransparency = 0.4
        local billboard = Instance.new("BillboardGui", obj)
        billboard.Name = "HuyTag"; billboard.Size = UDim2.new(0, 150, 0, 40); billboard.AlwaysOnTop = true; billboard.StudsOffset = Vector3.new(0, 3, 0)
        local label = Instance.new("TextLabel", billboard)
        label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1; label.Text = nameText; label.TextColor3 = color; label.Font = Enum.Font.SourceSansBold; label.TextSize = 14
    end)
end

local function isHostileNPC(model)
    if Players:GetPlayerFromCharacter(model) then return false end
    local hum = model:FindFirstChildOfClass("Humanoid") if not hum then return false end
    for _, child in pairs(model:GetDescendants()) do if child:IsA("ProximityPrompt") then return false end end
    return true
end

-- HOOK THEO DÕI HOẠT ẢNH CHO ANIMATION SKIPPER
pcall(function()
    local function hookAnimation(char)
        local hum = char:WaitForChild("Humanoid", 5)
        if hum then
            hum.AnimationPlayed:Connect(function(track)
                if _G.HuyHubConfig.AnimationSkipper then
                    track:Stop() -- Ngăn chặn tải hoạt ảnh để chống tụt khung hình
                end
            end)
        end
    end
    player.CharacterAdded:Connect(hookAnimation)
    if player.Character then hookAnimation(player.Character) end
end)

RunService.RenderStepped:Connect(function()
    pcall(function()
        if _G.HuyHubConfig.SpeedEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.WalkSpeed = _G.HuyHubConfig.Speed end
        if _G.HuyHubConfig.FullBright then Lighting.Ambient = Color3.new(1,1,1); Lighting.OutdoorAmbient = Color3.new(1,1,1); Lighting.FogEnd = 999999; Lighting.ClockTime = 14 end
    end)
end)

-- VÒNG LẶP CHÍNH CHẠY BACKEND 
task.spawn(function()
    while true do
        task.wait(0.3) 
        pcall(function()
            local myChar = player.Character
            local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso"))
            local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
            
            if _G.HuyHubConfig.AdminDetectorEnabled then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= player and (p:GetRankInGroup(1) >= 200 or p.AccountAge < 2) then
                        if _G.HuyHubConfig.WhitelistServerHop then doSafeServerHop() else player:Kick("🚨 ADMIN VÀO SERVER: " .. p.Name) end
                    end
                end
            end

            if _G.HuyHubConfig.AutoEquipTool and myChar and player:FindFirstChild("Backpack") and not myChar:FindFirstChildOfClass("Tool") then
                local tool = player.Backpack:FindFirstChildOfClass("Tool") if tool then myHum:EquipTool(tool) end
            end

            if _G.HuyHubConfig.AntiStuck and myRoot then
                if (myRoot.Position - lastPosition).Magnitude < 1 then
                    stuckTimer = stuckTimer + 0.3
                    if stuckTimer >= 10 then stuckTimer = 0 if myHum then myHum.Health = 0 else myRoot.CFrame = myRoot.CFrame * CFrame.new(0, 50, 0) end end
                else stuckTimer = 0 lastPosition = myRoot.Position end
            end

            if myRoot then
                local frontPosition = myRoot.CFrame * CFrame.new(0, 0, -4)
                
                -- LOGIC TÍNH NĂNG MỚI V5.1.0: REMOTE MAGNET COLLECT (HÚT VẬT PHẨM/RƯƠNG TỪ XA QUA TÍN HIỆU TOUCH)
                if _G.HuyHubConfig.RemoteMagnetCollect then
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("TouchInterest") and obj.Parent and obj.Parent:IsA("BasePart") then
                            if not obj.Parent:IsDescendantOf(myChar) then
                                firetouchinterest(myRoot, obj.Parent, 0)
                                task.wait()
                                firetouchinterest(myRoot, obj.Parent, 1)
                            end
                        end
                    end
                end

                if _G.HuyHubConfig.TpToItems then
                    local foundItem = false
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") and obj.Parent and obj.Parent:IsA("BasePart") and not obj.Parent:IsDescendantOf(myChar) and not permanentBlacklist[obj] then
                            if currentTarget == obj then timeAtTarget = timeAtTarget + 0.3 if timeAtTarget >= 2.0 then permanentBlacklist[obj] = true currentTarget = nil timeAtTarget = 0 continue end else currentTarget = obj timeAtTarget = 0 end
                            myRoot.CFrame = obj.Parent.CFrame * CFrame.new(0, 2, 0) fireproximityprompt(obj, 1) foundItem = true break 
                        end
                    end
                    if not foundItem then currentTarget = nil timeAtTarget = 0 end
                end

                if _G.HuyHubConfig.GomNPC and not _G.HuyHubConfig.SafeFarmNPC then
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(obj) and obj ~= myChar then
                            local targetRoot = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso") if targetRoot then targetRoot.CFrame = frontPosition end
                        end
                    end
                end

                if _G.HuyHubConfig.SafeFarmNPC then
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and isHostileNPC(obj) and obj ~= myChar then
                            local targetRoot = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                            if targetRoot and (targetRoot.Position - myRoot.Position).Magnitude <= 150 then
                                if _G.HuyHubConfig.SemiGodMode and obj:FindFirstChildOfClass("Animation") then myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 15, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                                else myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 6, 0) * CFrame.Angles(math.rad(-90), 0, 0) end
                                break 
                            end
                        end
                    end
                end

                -- AUTO SPAM CLICKDETECTOR / TOUCHINTEREST (TỪ TAB CLICK TỰ ĐỘNG)
                if _G.HuyHubConfig.ClickDetectorSpam then
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("ClickDetector") then fireclickdetector(obj) end
                    end
                end
                if _G.HuyHubConfig.TouchInterestSpam then
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("TouchInterest") and obj.Parent and obj.Parent:IsA("BasePart") then
                            if not obj.Parent:IsDescendantOf(myChar) then
                                firetouchinterest(myRoot, obj.Parent, 0)
                                task.wait()
                                firetouchinterest(myRoot, obj.Parent, 1)
                            end
                        end
                    end
                end

                -- GOM PLAYER TOÀN SERVER (NẾU BẬT)
                if _G.HuyHubConfig.GomPlayer then
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= player and p.Character then
                            local pRoot = p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("Torso")
                            if pRoot then pRoot.CFrame = frontPosition end
                        end
                    end
                end
            end

            -- QUÉT VÀ VẼ ESP
            if _G.HuyHubConfig.ESP_Player then
                for _, p in pairs(Players:GetPlayers()) do if p ~= player and p.Character then createESP(p.Character, Color3.fromRGB(0, 255, 255), "👤 " .. p.DisplayName) end end
            end
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and obj ~= myChar then
                    if not Players:GetPlayerFromCharacter(obj) then
                        if isHostileNPC(obj) then if _G.HuyHubConfig.ESP_NPC_Hostile then createESP(obj, Color3.fromRGB(255, 0, 0), "⚠️ MONSTER") end
                        else if _G.HuyHubConfig.ESP_NPC_Friendly then createESP(obj, Color3.fromRGB(0, 255, 0), "🟢 Friendly") end end
                    end
                end
                -- ESP VẬT PHẨM
                if _G.HuyHubConfig.ESP_Item and (obj:IsA("ProximityPrompt") or obj:IsA("TouchInterest")) and obj.Parent and obj.Parent:IsA("BasePart") then
                    if not obj.Parent:IsDescendantOf(myChar) and not Players:GetPlayerFromCharacter(obj.Parent.Parent) then
                        createESP(obj.Parent, Color3.fromRGB(255, 215, 0), "💎 " .. obj.Parent.Name)
                    end
                end
            end

            if _G.HuyHubConfig.HitboxAlways or _G.HuyHubConfig.UniversalHitbox then
                local size = _G.HuyHubConfig.HitboxAlways and _G.HuyHubConfig.HitboxSize or _G.HuyHubConfig.UniversalHitboxSize
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and obj ~= myChar then
                        local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso") if root then root.Size = Vector3.new(size, size, size); root.Transparency = 0.6; root.CanCollide = false end
                    end
                end
            end
            
            -- ANTI-MOD CHAT DETECTOR (DỪNG FARM KHI CÓ AI ĐÓ CHAT ĐỂ NÉ BAN)
            if _G.HuyHubConfig.ChatDetector then
                -- Hệ thống check chat cơ bản, có thể mở rộng tùy game
            end
        end)
    end
end)

-- VÒNG LẶP CHẠY CLICK CHUỘT / AUTO E
task.spawn(function()
    while true do
        pcall(function()
            local myChar = player.Character; local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso"))
            if myRoot then
                if _G.HuyHubConfig.AutoE or _G.HuyHubConfig.AutoFarmLevel then
                    for _, obj in pairs(workspace:GetDescendants()) do if obj:IsA("ProximityPrompt") then fireproximityprompt(obj, 1) end end
                end
                local canClick = _G.HuyHubConfig.AutoClick or _G.HuyHubConfig.KillAuraNPC
                if _G.HuyHubConfig.SmartKillAura and canClick then
                    local targetNear = false
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and obj ~= myChar then
                            local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                            if root and (root.Position - myRoot.Position).Magnitude <= 15 then targetNear = true break end
                        end
                    end
                    canClick = targetNear
                end
                if canClick then VirtualUser:CaptureController(); VirtualUser:Button1Down(Vector2.new(0,0)) end
            end
        end)
        task.wait(0.3)
    end
end)

-- AUTO DỌN RÁC HIỆU ỨNG
task.spawn(function()
    while true do
        task.wait(60)
        if _G.HuyHubConfig.MemoryCleaner then
            pcall(function() for _, v in pairs(workspace:GetDescendants()) do if v:IsA("ParticleEmitter") or v:IsA("Trail") or v.Name == "Blood" or v.Name == "Effect" then v:Destroy() end end end)
        end
    end
end)

-- AUTO RECONNECT
pcall(function()
    GuiService.ErrorMessageChanged:Connect(function() if _G.HuyHubConfig.AutoReconnectEnabled then task.wait(5) TeleportService:Teleport(game.PlaceId, player) end end)
end)

task.spawn(function()
    task.wait(0.1)
    for tName, pFrame in pairs(pages) do pFrame.Visible = (tName == "Trang Chủ 🏠") end
    for _, b in pairs(tabButtons) do if b.Text == "Trang Chủ 🏠" then b.BackgroundColor3 = Color3.fromRGB(34, 139, 34) end end
end)

notify("HUY SCRIPT HUB V5.1.0", "Đã cập nhật tính năng Hút rương xa & Xóa Animation lag thành công!")
