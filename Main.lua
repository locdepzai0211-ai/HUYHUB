-- =========================================================================
--               HUY SCRIPT HUB V5.0.1 (OPTIMIZED NPC DETECTOR)
--       [NÂNG CẤP]: PHÂN LOẠI QUÁI VẬT / NPC QUA PROXIMITYPROMPT CHUẨN 100%
-- =========================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")

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

local function setDefaultConfig()
    _G.SpeedEnabled = false; _G.Speed = 50; _G.Fly = false; _G.Noclip = false; _G.InfJump = false
    _G.PlayerScale = 1 
    _G.ESP_Player = false; _G.ESP_NPC_Hostile = false; _G.ESP_NPC_Friendly = false; _G.ESP_Item = false
    _G.HitboxAlways = false; _G.HitboxSize = 13; _G.FullBright = false
    _G.AutoE = false; _G.AutoClick = false; _G.KillAuraNPC = false; _G.KillAuraPlayer = false; _G.TpToItems = false
    _G.AutoFarmLevel = false; _G.GomPlayer = false; _G.GomNPC = false
    _G.ClickDetectorSpam = false; _G.TouchInterestSpam = false; _G.UniversalHitbox = false; _G.UniversalHitboxSize = 25
    _G.PotatoModeEnabled = false; _G.DisableTextures = false; _G.DisableEffects = false; _G.ClearDecals = false
end
setDefaultConfig()

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 110, 0, 45)
toggleBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
toggleBtn.Text = "HUY HUB V5.0.1 🚨"
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
title.Text = "HUY SCRIPT HUB V5.0.1 (NPC SMART SCAN)"
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
createTab("Cài Đặt UI ⚙️")  

local function notify(title, text)
    pcall(function() StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = 1.5}) end)
end

local toggleButtonsRegistry = {}

local function addToggle(tabName, text, key, callback)
    local targetPage = pages[tabName] if not targetPage then return end
    local b = Instance.new("TextButton", targetPage)
    b.Size = UDim2.new(1, -6, 0, 32)
    b.Text = text b.Font = Enum.Font.SourceSansBold b.TextSize = 13
    b.BackgroundColor3 = _G[key] and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(50,50,50) b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0.2, 0)
    
    local function updateVisuals()
        b.BackgroundColor3 = _G[key] and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(50,50,50)
    end

    b.MouseButton1Click:Connect(function()
        _G[key] = not _G[key]
        updateVisuals()
        notify("Huy Hub", text .. (_G[key] and " 🟢 BẬT" or " 🔴 TẮT"))
        if callback then pcall(callback, _G[key]) end
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
    label.Text = text .. ": " .. tostring(_G[key])
    label.Font = Enum.Font.SourceSansBold; label.TextSize = 12; label.TextColor3 = Color3.new(1, 1, 1)

    local container = Instance.new("TextButton", sliderFrame)
    container.Size = UDim2.new(0.9, 0, 0.25, 0); container.Position = UDim2.new(0.05, 0, 0.55, 0)
    container.BackgroundColor3 = Color3.fromRGB(30, 30, 30); container.Text = ""
    Instance.new("UICorner", container).CornerRadius = UDim.new(0.5, 0)

    local bar = Instance.new("Frame", container)
    bar.Size = UDim2.new((_G[key] - min) / (max - min), 0, 1, 0)
    bar.BackgroundColor3 = Color3.fromRGB(34, 139, 34); bar.BorderSizePixel = 0
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0.5, 0)

    local function updateSlider(input)
        local sizeX = math.clamp((input.Position.X - container.AbsolutePosition.X) / container.AbsoluteSize.X, 0, 1)
        bar.Size = UDim2.new(sizeX, 0, 1, 0)
        local value = min + (sizeX * (max - min))
        value = math.floor(value * 10) / 10
        _G[key] = value
        label.Text = text .. ": " .. tostring(value)
        if callback then pcall(callback, value) end
    end

    local function refreshVisuals()
        bar.Size = UDim2.new((_G[key] - min) / (max - min), 0, 1, 0)
        label.Text = text .. ": " .. tostring(_G[key])
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

-- TAB TRANG CHỦ
local nameLabel = Instance.new("TextLabel", pages["Trang Chủ 🏠"])
nameLabel.Size = UDim2.new(1, -6, 0, 42)
nameLabel.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
nameLabel.Text = "📝 Tác giả: Tran Quang Huy\nChào mừng bạn đến với Huy Script Hub v5.0.1!"
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
    if _G.InfJump and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
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
    _G.TpToItems = not _G.TpToItems
    tpItemBtn.Text = "Tự Động Bay Tới Vật Phẩm: " .. (_G.TpToItems and "BẬT 🟢" or "TẮT 🔴")
    tpItemBtn.BackgroundColor3 = _G.TpToItems and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(50, 50, 50)
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
task.spawn(function() while true do refreshPlayerList() task.wait(3) end end)

-- TAB TỰ ĐỘNG FARM
addToggle("Tự Động Farm 🚜", "Tự Động Cày Cấp (Auto Farm Level)", "AutoFarmLevel")
addToggle("Tự Động Farm 🚜", "Gom Quái Lại Gần (Trước mặt 4 Studs)", "GomNPC")       
addToggle("Tự Động Farm 🚜", "Gom Người Chơi Toàn Máy Chủ", "GomPlayer") 
addToggle("Tự Động Farm 🚜", "Diệt Quái Xung Quanh (Kill Aura NPC)", "KillAuraNPC")
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
                    matchesFound = matchesFound + 1; if matchesFound > 30 then break end
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

-- TAB CÀI ĐẶT UI & NÚT RESET TẤT CẢ
local settingTab = pages["Cài Đặt UI ⚙️"]

local resetAllBtn = Instance.new("TextButton", settingTab)
resetAllBtn.Size = UDim2.new(1, -6, 0, 32)
resetAllBtn.BackgroundColor3 = Color3.fromRGB(210, 105, 30)
resetAllBtn.Text = "🔄 Reset Tất Cả Tính Năng"
resetAllBtn.Font = Enum.Font.SourceSansBold; resetAllBtn.TextColor3 = Color3.new(1,1,1); resetAllBtn.TextSize = 13
Instance.new("UICorner", resetAllBtn).CornerRadius = UDim.new(0.2, 0)

resetAllBtn.MouseButton1Click:Connect(function()
    setDefaultConfig()
    applyFullBright(false)
    
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

local spaceLabel = Instance.new("Frame", settingTab)
spaceLabel.Size = UDim2.new(1,0,0,5); spaceLabel.BackgroundTransparency = 1

local closeUIAll = Instance.new("TextButton", settingTab)
closeUIAll.Size = UDim2.new(1, -6, 0, 32); closeUIAll.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
closeUIAll.Text = "Gỡ Bỏ Toàn Bộ Huy Hub ❌"; closeUIAll.Font = Enum.Font.SourceSansBold; closeUIAll.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", closeUIAll).CornerRadius = UDim.new(0.2, 0)
closeUIAll.MouseButton1Click:Connect(function() gui:Destroy() end)


-- ==================== HỆ THỐNG VẼ ESP & SCANNER ====================
local function createESP(obj, color, nameText)
    if not obj then return end
    if obj:FindFirstChild("HuyESP") then
        obj.HuyESP.FillColor = color
        if obj:FindFirstChild("HuyTag") and obj.HuyTag:FindFirstChildOfClass("TextLabel") then
            obj.HuyTag:FindFirstChildOfClass("TextLabel").Text = nameText
            obj.HuyTag:FindFirstChildOfClass("TextLabel").TextColor3 = color
        end
        return
    end
    pcall(function()
        local box = Instance.new("Highlight")
        box.Name = "HuyESP"; box.FillColor = color; box.OutlineColor = Color3.new(1,1,1)
        box.FillTransparency = 0.4; box.OutlineTransparency = 0; box.Parent = obj
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "HuyTag"; billboard.Size = UDim2.new(0, 150, 0, 40); billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0, 3, 0); billboard.Parent = obj
        
        local label = Instance.new("TextLabel", billboard)
        label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1
        label.Text = nameText; label.TextColor3 = color; label.Font = Enum.Font.SourceSansBold; label.TextSize = 14
    end)
end

-- ==================== THUẬT TOÁN KIỂM TRA QUÁI VẬT SMART NEW ====================
local function isHostileNPC(model)
    if Players:GetPlayerFromCharacter(model) then return false end
    local hum = model:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    
    -- LOGIC THEO ĐÚNG Ý ÔNG: Nếu tìm thấy nút tương tác đối thoại trong model hoặc bộ phận cơ thể của nó
    local hasPrompt = false
    if model:FindFirstChildOfClass("ProximityPrompt") then
        hasPrompt = true
    else
        for _, child in pairs(model:GetDescendants()) do
            if child:IsA("ProximityPrompt") then
                hasPrompt = true
                break
            end
        end
    end
    
    -- Nếu có nút tương tác -> Kết luận: Dân làng / Thân thiện (Trả về false cho Hostile)
    if hasPrompt then
        return false
    end
    
    -- Ngược lại, nếu không thể tương tác -> Chắc chắn là Quái vật / Boss (Trả về true)
    return true
end

-- VÒNG LẶP RENDER GỐC
RunService.RenderStepped:Connect(function()
    pcall(function()
        if _G.SpeedEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then 
            player.Character.Humanoid.WalkSpeed = _G.Speed 
        end
        if _G.FullBright then 
            Lighting.Ambient = Color3.new(1,1,1); Lighting.OutdoorAmbient = Color3.new(1,1,1)
            Lighting.FogEnd = 999999; Lighting.ClockTime = 14
        end
    end)
end)

-- VÒNG LẶP CHÍNH XỬ LÝ GOM PLAYER & QUÁI VẬT
task.spawn(function()
    while true do
        task.wait(0.2)
        pcall(function()
            local myChar = player.Character
            local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso"))
            
            if myRoot then
                local frontPosition = myRoot.CFrame * CFrame.new(0, 0, -4)
                
                if _G.GomNPC then
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(obj) and obj ~= myChar then
                            local targetRoot = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                            if targetRoot then targetRoot.CFrame = frontPosition end
                        end
                    end
                end

                if _G.GomPlayer then
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= player and p.Character then
                            local targetRoot = p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("Torso")
                            if targetRoot then targetRoot.CFrame = frontPosition end
                        end
                    end
                end
            end

            if _G.ESP_Player then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= player and p.Character then createESP(p.Character, Color3.fromRGB(0, 255, 255), "👤 " .. p.DisplayName) end
                end
            end
            
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and obj ~= myChar then
                    if not Players:GetPlayerFromCharacter(obj) then
                        if isHostileNPC(obj) then
                            if _G.ESP_NPC_Hostile then
                                createESP(obj, Color3.fromRGB(255, 0, 0), "⚠️ MONSTER (DANGER)")
                            else
                                if obj:FindFirstChild("HuyESP") then obj.HuyESP:Destroy() end
                                if obj:FindFirstChild("HuyTag") then obj.HuyTag:Destroy() end
                            end
                        else
                            if _G.ESP_NPC_Friendly then
                                createESP(obj, Color3.fromRGB(0, 255, 0), "🟢 Dân Làng / Thân Thiện")
                            else
                                if obj:FindFirstChild("HuyESP") then obj.HuyESP:Destroy() end
                                if obj:FindFirstChild("HuyTag") then obj.HuyTag:Destroy() end
                            end
                        end
                    end
                elseif obj:IsA("ProximityPrompt") and _G.ESP_Item and obj.Parent and obj.Parent:IsA("BasePart") and not obj.Parent:IsDescendantOf(player.Character) then
                    -- Chỉ vẽ ESP Item cho các vật phẩm rơi tự do, không vẽ đè lên các NPC có ProximityPrompt
                    if not obj.Parent:FindFirstAncestorOfClass("Model") or not obj.Parent:FindFirstAncestorOfClass("Model"):FindFirstChildOfClass("Humanoid") then
                        createESP(obj.Parent, Color3.fromRGB(255, 255, 0), "💎 Vật Phẩm")
                    end
                end
            end

            if _G.HitboxAlways or _G.UniversalHitbox then
                local size = _G.HitboxAlways and _G.HitboxSize or _G.UniversalHitboxSize
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and obj ~= myChar then
                        local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                        if root then root.Size = Vector3.new(size, size, size); root.Transparency = 0.6; root.CanCollide = false end
                    end
                end
            end
        end)
    end
end)

-- VÒNG LẶP PHỤ CHO AUTO CLICK / AUTO E
task.spawn(function()
    while true do
        pcall(function()
            local myChar = player.Character; local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso"))
            if myRoot then
                if _G.AutoE then
                    for _, obj in pairs(workspace:GetDescendants()) do if obj:IsA("ProximityPrompt") then fireproximityprompt(obj, 1) end end
                end
                if _G.AutoClick then VirtualUser:CaptureController(); VirtualUser:Button1Down(Vector2.new(0,0)) end
            end
        end)
        task.wait(0.3)
    end
end)

task.spawn(function()
    task.wait(0.1)
    for tName, pFrame in pairs(pages) do pFrame.Visible = (tName == "Trang Chủ 🏠") end
    for _, b in pairs(tabButtons) do if b.Text == "Trang Chủ 🏠" then b.BackgroundColor3 = Color3.fromRGB(34, 139, 34) end end
end)

notify("HUY SCRIPT HUB V5.0.1", "Đã áp dụng quét NPC thông minh bằng ProximityPrompt!")
