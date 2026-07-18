-- =========================================================================
--                     HUY SCRIPT HUB V4.6.0 (PREMIUM EXPANDED)
--       [FIX CHAT TEXT WRAPPED]: SỬA LỖI TIN NHẮN DÀI BỊ MẤT CHỮ - TỰ ĐỘNG XUỐNG DÒNG
--       [CHAT SERVER NOTIFY]: TỰ ĐỘNG CHÈN THÔNG BÁO KẾT NỐI TỪ BOT KHI KHỞI CHẠY
--       [FIX INF JUMP]: TÍNH NĂNG NHẢY VÔ HẠN HOẠT ĐỘNG ỔN ĐỊNH KHI RESET
-- =========================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

local pgui = nil
local success_gui = pcall(function()
    if gethui then pgui = gethui()
    elseif game:GetService("CoreGui"):FindFirstChild("RobloxGui") then pgui = game:GetService("CoreGui")
    else pgui = player:WaitForChild("PlayerGui") end
end)
if not pgui or not success_gui then pgui = player:WaitForChild("PlayerGui") end

-- LÀM SẠCH BẢN CŨ TRÁNH XUNG ĐỘT GIAO DIỆN
if pgui:FindFirstChild("HuyScriptHubV2") then pgui.HuyScriptHubV2:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "HuyScriptHubV2"
gui.ResetOnSpawn = false
gui.Parent = pgui

-- KHỞI TẠO BIẾN TOÀN CỤC CHẠY TÍNH NĂNG
_G.SpeedEnabled = false; _G.Speed = 50; _G.Fly = false; _G.Noclip = false; _G.InfJump = false
_G.ESP_Player = false; _G.ESP_NPC = false; _G.ESP_Item = false; _G.HitboxAlways = false; _G.HitboxSize = 13; _G.FullBright = false
_G.AutoE = false; _G.AutoClick = false; _G.KillAura = false; _G.TpToItems = false
_G.AutoFarmLevel = false; _G.AutoParry = false
_G.GomPlayer = false; _G.GomNPC = false
_G.ClickDetectorSpam = false; _G.TouchInterestSpam = false; _G.UniversalHitbox = false; _G.UniversalHitboxSize = 25
_G.PotatoModeEnabled = false; _G.AdminChatCmds = false

-- Nút mở Menu chính
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 110, 0, 45)
toggleBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
toggleBtn.Text = "HUY HUB V4.6.0 🌌"
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

-- Khung nền chính của Menu
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 430, 0, 300) 
main.Position = UDim2.new(0.5, -215, 0.5, -150)
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
title.Text = "HUY SCRIPT HUB V4.6.0"
title.Font = Enum.Font.Arcade
title.TextSize = 14
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

-- Kéo thả Menu
local function makeDraggable(frame)
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
end
makeDraggable(toggleBtn) makeDraggable(main)

local function toggleMenu() main.Visible = not main.Visible end
toggleBtn.MouseButton1Click:Connect(toggleMenu) closeBtn.MouseButton1Click:Connect(toggleMenu)

-- PHÂN CHIA HỆ THỐNG CÁC TAB CHỨC NĂNG
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
local togglesList = {} 

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

-- TẠO CÁC TAB
createTab("Main 🏠")
createTab("Player")
createTab("Teleport to.. 📍", true)
createTab("Combat V3")  
createTab("Visual")
createTab("Farm")           
createTab("Game Dex 🔍", true)       
createTab("Universal Clicker 🎯")   
createTab("Potato Mode 🥔")         
createTab("Admin Cmds ⚡")          
createTab("Chat Server 🌐", true)   
createTab("Setting UI ⚙️")  

local function notify(title, text)
    pcall(function() StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = 1.5}) end)
end

local function addToggle(tabName, text, key, callback)
    local targetPage = pages[tabName] if not targetPage then return end
    local b = Instance.new("TextButton", targetPage)
    b.Size = UDim2.new(1, -6, 0, 32)
    b.Text = text b.Font = Enum.Font.SourceSansBold b.TextSize = 13
    b.BackgroundColor3 = _G[key] and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(50,50,50) b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0.2, 0)
    
    b.MouseButton1Click:Connect(function()
        _G[key] = not _G[key]
        b.BackgroundColor3 = _G[key] and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(50,50,50)
        notify("Huy Hub", text .. (_G[key] and " 🟢 BẬT" or " 🔴 TẮT"))
        if callback then callback(_G[key]) end
    end)
    togglesList[key] = {button = b, defaultText = text, callback = callback}
end

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
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 12
    label.TextColor3 = Color3.new(1, 1, 1)

    local container = Instance.new("TextButton", sliderFrame)
    container.Size = UDim2.new(0.9, 0, 0.25, 0)
    container.Position = UDim2.new(0.05, 0, 0.55, 0)
    container.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    container.Text = ""
    Instance.new("UICorner", container).CornerRadius = UDim.new(0.5, 0)

    local bar = Instance.new("Frame", container)
    bar.Size = UDim2.new((_G[key] - min) / (max - min), 0, 1, 0)
    bar.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
    bar.BorderSizePixel = 0
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0.5, 0)

    local function updateSlider(input)
        local sizeX = math.clamp((input.Position.X - container.AbsolutePosition.X) / container.AbsoluteSize.X, 0, 1)
        bar.Size = UDim2.new(sizeX, 0, 1, 0)
        local value = math.floor(min + (sizeX * (max - min)))
        _G[key] = value
        label.Text = text .. ": " .. tostring(value)
        if callback then callback(value) end
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
end

-- TAB MAIN
local nameLabel = Instance.new("TextLabel", pages["Main 🏠"])
nameLabel.Size = UDim2.new(1, -6, 0, 42)
nameLabel.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
nameLabel.Text = "📝 Tác giả: Tran Quang Huy\nChào mừng bạn đến với Huy Script Hub v4.6.0!"
nameLabel.Font = Enum.Font.SourceSansBold; nameLabel.TextSize = 12; nameLabel.TextColor3 = Color3.fromRGB(255, 215, 0) 
Instance.new("UICorner", nameLabel).CornerRadius = UDim.new(0.2, 0)

-- TAB PLAYER
addToggle("Player", "Bật Tốc Độ (Speed)", "SpeedEnabled")
addSlider("Player", "Điều chỉnh Tốc Độ", "Speed", 16, 250)

local flySpeed = 50
local flyingConnection
addToggle("Player", "Bay (Fly)", "Fly", function(state)
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    if state then
        hum.PlatformStand = true
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Name = "FlyVelocity"; bv.MaxForce = Vector3.new(9e9, 9e9, 9e9); bv.Velocity = Vector3.new(0,0,0)
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
addToggle("Player", "Xuyên Tường (Noclip)", "Noclip", function(state)
    if state then
        noclipConnection = RunService.Stepped:Connect(function()
            if player.Character then
                for _, child in pairs(player.Character:GetDescendants()) do
                    if child:IsA("BasePart") then child.CanCollide = false end
                end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() end
    end
end)

-- NHẢY VÔ HẠN (INF JUMP)
addToggle("Player", "Nhảy Vô Hạn (Inf Jump)", "InfJump")
UserInputService.JumpRequest:Connect(function()
    if _G.InfJump and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- TAB TELEPORT TO.. 📍
local tpTab = pages["Teleport to.. 📍"]
addToggle("Teleport to.. 📍", "Teleport To Items (Auto)", "TpToItems")

local plTitle = Instance.new("TextLabel", tpTab)
plTitle.Size = UDim2.new(1, -6, 0, 24); plTitle.Position = UDim2.new(0, 3, 0, 40)
plTitle.BackgroundColor3 = Color3.fromRGB(34, 139, 34); plTitle.Text = "👤 TELEPORT TO PLAYER:"
plTitle.Font = Enum.Font.SourceSansBold; plTitle.TextSize = 11; plTitle.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", plTitle).CornerRadius = UDim.new(0.2, 0)

local plScroll = Instance.new("ScrollingFrame", tpTab)
plScroll.Size = UDim2.new(1, -6, 0, 175); plScroll.Position = UDim2.new(0, 3, 0, 70)
plScroll.BackgroundColor3 = Color3.fromRGB(45, 25, 10); plScroll.ScrollBarThickness = 4
plScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UICorner", plScroll).CornerRadius = UDim.new(0.05, 0)
local plLayout = Instance.new("UIListLayout", plScroll); plLayout.Padding = UDim.new(0, 4)

local function refreshPlayerList()
    for _, child in pairs(plScroll:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            local pBtn = Instance.new("TextButton", plScroll)
            pBtn.Size = UDim2.new(1, -8, 0, 28); pBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            pBtn.TextColor3 = Color3.new(1, 1, 1); pBtn.Font = Enum.Font.SourceSansBold; pBtn.TextSize = 12
            pBtn.Text = "🏃 " .. p.DisplayName .. " (@" .. p.Name .. ")"
            Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0.2, 0)
            pBtn.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
                end
            end)
        end
    end
end
Players.PlayerAdded:Connect(refreshPlayerList) Players.PlayerRemoving:Connect(refreshPlayerList)
task.spawn(function() while true do refreshPlayerList() task.wait(5) end end)

-- TAB COMBAT V3
addToggle("Combat V3", "Tự Động Đỡ Đòn (Auto Parry)", "AutoParry")

-- TAB VISUAL
addToggle("Visual", "ESP Người Chơi", "ESP_Player")
addToggle("Visual", "ESP NPC / Quái Vật", "ESP_NPC")
addToggle("Visual", "ESP Items (Tương Tác)", "ESP_Item")
addToggle("Visual", "Bật Mở Rộng Hitbox Gốc", "HitboxAlways")
addSlider("Visual", "Kích cỡ Hitbox Mở Rộng", "HitboxSize", 2, 50)
addToggle("Visual", "Sáng Màn Hình (FullBright)", "FullBright")

-- TAB FARM 
addToggle("Farm", "Auto Farm Level (Thông minh)", "AutoFarmLevel")
addToggle("Farm", "Gom NPC / Quái Vật (Chỉ NPC)", "GomNPC")       
addToggle("Farm", "Gom Toàn Server (Gom Player)", "GomPlayer") 
addToggle("Farm", "Kill Aura (TP Kill 1s)", "KillAura")
addToggle("Farm", "Auto Tương Tác (Auto E)", "AutoE")
addToggle("Farm", "Tự Động Click (Auto Click)", "AutoClick")

-- TAB GAME DEX 🔍
local dexTab = pages["Game Dex 🔍"]
local dexSearchInput = Instance.new("TextBox", dexTab)
dexSearchInput.Size = UDim2.new(1, -6, 0, 30); dexSearchInput.Position = UDim2.new(0, 3, 0, 5)
dexSearchInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30); dexSearchInput.TextColor3 = Color3.new(1, 1, 1)
dexSearchInput.PlaceholderText = " Nhập từ khóa..."; dexSearchInput.TextSize = 12
Instance.new("UICorner", dexSearchInput).CornerRadius = UDim.new(0.15, 0)

local suggestFrame = Instance.new("Frame", dexTab)
suggestFrame.Size = UDim2.new(1, -6, 0, 32); suggestFrame.Position = UDim2.new(0, 3, 0, 40); suggestFrame.BackgroundTransparency = 1
local suggestLayout = Instance.new("UIListLayout", suggestFrame); suggestLayout.FillDirection = Enum.FillDirection.Horizontal; suggestLayout.Padding = UDim.new(0, 4)

local dexResultScroll = Instance.new("ScrollingFrame", dexTab)
dexResultScroll.Size = UDim2.new(1, -6, 0, 135); dexResultScroll.Position = UDim2.new(0, 3, 0, 106)
dexResultScroll.BackgroundColor3 = Color3.fromRGB(45, 25, 10); dexResultScroll.ScrollBarThickness = 4
dexResultScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UICorner", dexResultScroll).CornerRadius = UDim.new(0.05, 0)
local dexLayout = Instance.new("UIListLayout", dexResultScroll); dexLayout.Padding = UDim.new(0, 4)

local function runDexSearch(keyword)
    dexSearchInput.Text = keyword
    for _, btn in pairs(dexResultScroll:GetChildren()) do if btn:IsA("TextButton") then btn:Destroy() end end
    local matchesFound = 0; local text = keyword:lower()
    for _, obj in pairs(workspace:GetDescendants()) do
        if (obj.Name:lower():find(text)) and (obj:IsA("BasePart") or obj:IsA("Model")) then
            if not Players:GetPlayerFromCharacter(obj) and not obj:IsDescendantOf(player.Character) then
                matchesFound = matchesFound + 1; if matchesFound > 40 then break end
                local itemBtn = Instance.new("TextButton", dexResultScroll)
                itemBtn.Size = UDim2.new(1, -8, 0, 26); itemBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                itemBtn.TextColor3 = Color3.new(1, 1, 1); itemBtn.Text = "[TP] " .. obj.Name
                Instance.new("UICorner", itemBtn).CornerRadius = UDim.new(0.2, 0)
                itemBtn.MouseButton1Click:Connect(function()
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        player.Character.HumanoidRootPart.CFrame = obj:IsA("Model") and obj:GetPivot() or obj.CFrame
                    end
                end)
            end
        end
    end
end

local suggestions = {"Card", "Money", "Coin", "Scrap", "Key"}
for _, word in pairs(suggestions) do
    local sBtn = Instance.new("TextButton", suggestFrame)
    sBtn.Size = UDim2.new(0, 52, 1, 0); sBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 15)
    sBtn.Text = word; sBtn.TextColor3 = Color3.new(1,1,1); sBtn.Font = Enum.Font.SourceSansBold; sBtn.TextSize = 11
    Instance.new("UICorner", sBtn).CornerRadius = UDim.new(0.2, 0)
    sBtn.MouseButton1Click:Connect(function() runDexSearch(word) end)
end

local dexSearchBtn = Instance.new("TextButton", dexTab)
dexSearchBtn.Size = UDim2.new(1, -6, 0, 26); dexSearchBtn.Position = UDim2.new(0, 3, 0, 76)
dexSearchBtn.BackgroundColor3 = Color3.fromRGB(34, 139, 34); dexSearchBtn.Text = "QUÉT THEO TÊN Ô TRÊN 🔍"
dexSearchBtn.TextColor3 = Color3.new(1, 1, 1); font = Enum.Font.SourceSansBold; dexSearchBtn.TextSize = 12
Instance.new("UICorner", dexSearchBtn).CornerRadius = UDim.new(0.15, 0)
dexSearchBtn.MouseButton1Click:Connect(function() runDexSearch(dexSearchInput.Text) end)

-- TAB UNIVERSAL CLICKER 🎯
addToggle("Universal Clicker 🎯", "Auto ClickDetector (Click từ xa)", "ClickDetectorSpam")
addToggle("Universal Clicker 🎯", "Auto TouchInterest (Chạm bệ hệ thống)", "TouchInterestSpam")
addToggle("Universal Clicker 🎯", "Bật Mở Rộng Hitbox Quái/Người", "UniversalHitbox")
addSlider("Universal Clicker 🎯", "Kích Cỡ Khổng Lồ Hitbox", "UniversalHitboxSize", 2, 100)

-- TAB POTATO MODE 🥔
addToggle("Potato Mode 🥔", "Kích Hoạt Potato Siêu Mượt Máy", "PotatoModeEnabled", function(state)
    if state then
        settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.AlwaysThrottle
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
                v.CastShadow = false
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            elseif v:IsA("Explosion") or v:IsA("Sparkles") or v:IsA("Fire") then
                v.Enabled = false
            end
        end
    end
end)

-- TAB ADMIN CMDS ⚡
addToggle("Admin Cmds ⚡", "Bật Hệ Thống Lệnh Ẩn (/e Lệnh)", "AdminChatCmds")

-- ==================== TAB CHAT SERVER 🌐 (CẬP NHẬT TỰ ĐỘNG XUỐNG DÒNG THÔNG MINH) ====================
local chatTab = pages["Chat Server 🌐"]
local chatLogsScroll = Instance.new("ScrollingFrame", chatTab)
chatLogsScroll.Size = UDim2.new(1, -6, 0, 175); chatLogsScroll.Position = UDim2.new(0, 3, 0, 5)
chatLogsScroll.BackgroundColor3 = Color3.fromRGB(30, 15, 5); chatLogsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
chatLogsScroll.ScrollBarThickness = 4
Instance.new("UICorner", chatLogsScroll).CornerRadius = UDim.new(0.05, 0)

local chatLayout = Instance.new("UIListLayout", chatLogsScroll)
chatLayout.Padding = UDim.new(0, 4)

local chatTextBox = Instance.new("TextBox", chatTab)
chatTextBox.Size = UDim2.new(0, 220, 0, 30); chatTextBox.Position = UDim2.new(0, 3, 0, 185)
chatTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50); chatTextBox.TextColor3 = Color3.new(1, 1, 1)
chatTextBox.PlaceholderText = " Nhập tin nhắn..."; chatTextBox.Text = ""
Instance.new("UICorner", chatTextBox).CornerRadius = UDim.new(0.15, 0)

local sendChatBtn = Instance.new("TextButton", chatTab)
sendChatBtn.Size = UDim2.new(0, 65, 0, 30); sendChatBtn.Position = UDim2.new(0, 227, 0, 185)
sendChatBtn.BackgroundColor3 = Color3.fromRGB(34, 139, 34); sendChatBtn.Text = "GỬI 🚀"; sendChatBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", sendChatBtn).CornerRadius = UDim.new(0.15, 0)

-- [FIXED ALGORITHM]: Hàm tối ưu hóa tự động xuống dòng và tự động co giãn kích thước nhãn tin nhắn
local function insertChatLog(text, color)
    local msgLabel = Instance.new("TextLabel", chatLogsScroll)
    msgLabel.Size = UDim2.new(1, -10, 0, 0) -- Rộng tối đa khung chat, cao mặc định bằng 0 để hệ thống tự tính toán
    msgLabel.AutomaticSize = Enum.AutomaticSize.Y -- [BỔ SUNG] Tự động giãn chiều cao dựa trên độ dài dòng chữ
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = text
    msgLabel.TextColor3 = color
    msgLabel.TextSize = 12
    msgLabel.Font = Enum.Font.SourceSansBold
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.TextYAlignment = Enum.TextYAlignment.Top
    msgLabel.TextWrapped = true -- [QUAN TRỌNG]: Bật tự động xuống dòng khi chạm giới hạn biên của khung chat!

    -- Đợi cập nhật khung hình rồi cuộn mượt xuống cuối log chat
    task.defer(function()
        chatLogsScroll.CanvasPosition = Vector2.new(0, math.max(0, chatLogsScroll.AbsoluteCanvasSize.Y - chatLogsScroll.AbsoluteWindowSize.Y))
    end)
end

sendChatBtn.MouseButton1Click:Connect(function()
    if chatTextBox.Text ~= "" then
        insertChatLog(" 🔴 [" .. player.DisplayName .. "]: " .. chatTextBox.Text, Color3.fromRGB(255, 215, 0))
        chatTextBox.Text = ""
    end
end)

-- TỰ ĐỘNG HIỆN THÔNG BÁO BOT KHI VỪA KHỞI CHẠY HỆ THỐNG
task.spawn(function()
    task.wait(0.5) 
    insertChatLog(" 📢 [HuyHub Bot]: Hệ thống Chat Server đã kết nối thành công! Chúc bạn tương tác vui vẻ.", Color3.fromRGB(0, 255, 200))
end)

-- TAB SETTING UI ⚙️
local settingTab = pages["Setting UI ⚙️"]
local function createSettingBtn(text, color, callback)
    local sBtn = Instance.new("TextButton", settingTab)
    sBtn.Size = UDim2.new(1, -6, 0, 32); sBtn.BackgroundColor3 = color; sBtn.Text = text
    sBtn.Font = Enum.Font.SourceSansBold; sBtn.TextSize = 13; sBtn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", sBtn).CornerRadius = UDim.new(0.2, 0)
    sBtn.MouseButton1Click:Connect(callback)
end
createSettingBtn("Đổi Chủ Đề Giao Diện 🌱", Color3.fromRGB(34, 139, 34), function() main.BackgroundColor3 = Color3.fromRGB(20, 50, 20) end)
createSettingBtn("Xóa Toàn Bộ Script Hub ❌", Color3.fromRGB(180, 40, 40), function() gui:Destroy() end)


-- ==================== CORE LOGIC HOẠT ĐỘNG NGẦM ====================

local function createESP(obj, color, espKey, nameText)
    if obj:FindFirstChild("HuyESP") then return end
    local box = Instance.new("Highlight")
    box.Name = "HuyESP"; box.FillColor = color; box.OutlineColor = Color3.new(1,1,1)
    box.FillTransparency = 0.5; box.OutlineTransparency = 0; box.Parent = obj
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "HuyTag"; billboard.Size = UDim2.new(0, 200, 0, 50); billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 3, 0); billboard.Parent = obj
    
    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1
    label.Text = nameText; label.TextColor3 = color; label.Font = Enum.Font.SourceSansBold; label.TextSize = 14

    task.spawn(function()
        while obj and obj.Parent and _G[espKey] do task.wait(0.5) end
        box:Destroy(); billboard:Destroy()
    end)
end

RunService.RenderStepped:Connect(function()
    if _G.SpeedEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = _G.Speed
    end
    if _G.FullBright then Lighting.Ambient = Color3.new(1,1,1); Lighting.OutdoorAmbient = Color3.new(1,1,1) end
end)

-- VÒNG LẶP CHÍNH TẦN SUẤT 50MS
task.spawn(function()
    while true do
        task.wait(0.05)
        
        local myChar = player.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        
        if myRoot then
            local targetCFrame = myRoot.CFrame * CFrame.new(0, 0, -5)

            -- 1. TÍNH NĂNG GOM PLAYER
            if _G.GomPlayer then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local pRoot = p.Character.HumanoidRootPart
                        pRoot.Velocity = Vector3.new(0,0,0)
                        pRoot.CFrame = targetCFrame
                    end
                end
            end

            -- 2. TÍNH NĂNG GOM NPC
            if _G.GomNPC then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(obj) and obj ~= myChar then
                        local nRoot = obj:FindFirstChild("HumanoidRootPart")
                        if nRoot then
                            nRoot.Velocity = Vector3.new(0,0,0)
                            nRoot.CFrame = targetCFrame
                        end
                    end
                end
            end

            -- 3. AUTO FARM LEVEL VÀ KILL AURA
            if _G.AutoFarmLevel or _G.KillAura then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(obj) and obj ~= myChar then
                        local monsterRoot = obj:FindFirstChild("HumanoidRootPart")
                        local monsterHum = obj:FindFirstChildOfClass("Humanoid")
                        
                        if monsterRoot and monsterHum and monsterHum.Health > 0 then
                            myRoot.CFrame = monsterRoot.CFrame * CFrame.new(0, 0, 3)
                            VirtualUser:CaptureController()
                            VirtualUser:Button1Down(Vector2.new(0,0))
                            task.wait(0.08)
                            if not _G.AutoFarmLevel and not _G.KillAura then break end
                        end
                    end
                end
            end
        end

        if _G.AutoClick then
            VirtualUser:CaptureController()
            VirtualUser:Button1Down(Vector2.new(0,0))
        end

        if _G.AutoE then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    fireproximityprompt(obj, 1)
                end
            end
        end
    end
end)

-- VÒNG LẶP HỆ THỐNG VISUAL
task.spawn(function()
    while true do
        task.wait(1)
        if _G.ESP_Player then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    createESP(p.Character, Color3.fromRGB(0, 255, 255), "ESP_Player", p.DisplayName)
                end
            end
        end
        if _G.ESP_NPC then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(obj) and obj ~= player.Character then
                    createESP(obj, Color3.fromRGB(255, 0, 0), "ESP_NPC", "⚠️ Monster / NPC")
                end
            end
        end
        if _G.ESP_Item then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") and obj.Parent and obj.Parent:IsA("BasePart") then
                    createESP(obj.Parent, Color3.fromRGB(0, 255, 0), "ESP_Item", "💎 Item Tương Tác")
                end
            end
        end
        if _G.HitboxAlways or _G.UniversalHitbox then
            local size = _G.HitboxAlways and _G.HitboxSize or _G.UniversalHitboxSize
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and obj ~= player.Character then
                    local root = obj:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.Size = Vector3.new(size, size, size)
                        root.Transparency = 0.6; root.CanCollide = false
                    end
                end
            end
        end
    end
end)

-- Auto nhặt đồ xa
task.spawn(function()
    while true do
        if _G.TpToItems and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            for _, item in pairs(workspace:GetDescendants()) do
                if item:IsA("ProximityPrompt") and item.Parent and item.Parent:IsA("BasePart") then
                    player.Character.HumanoidRootPart.CFrame = item.Parent.CFrame * CFrame.new(0, 2, 0)
                    task.wait(0.2); fireproximityprompt(item, 1)
                end
            end
        end
        task.wait(0.5)
    end
end)

-- Mặc định mở tab Main khi bắt đầu chạy
task.spawn(function()
    task.wait(0.1)
    for tName, pFrame in pairs(pages) do pFrame.Visible = (tName == "Main 🏠") end
    for _, b in pairs(tabButtons) do if b.Text == "Main 🏠" then b.BackgroundColor3 = Color3.fromRGB(34, 139, 34) end end
end)

notify("HUY SCRIPT HUB V4.6.0", "Đã cập nhật tính năng tự động xuống dòng & căn chỉnh giao diện khung chat!")
