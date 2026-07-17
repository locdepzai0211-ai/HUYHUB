-- =========================================================================
--                     HUY SCRIPT HUB V4.3.2 (TOUCH & OBSTACLE FIX)
--       SỬA LỖI XÓA VẬT CẢN KHÔNG ĂN TRÊN MOBILE VÀ TƯỜNG BỊ KHÓA
-- =========================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

-- HỆ THỐNG BACKUP MAP AN TOÀN (CHẠY NGẦM KHÔNG GÂY TREO SCRIPT)
local MapBackup = {}
task.spawn(function()
    for _, child in pairs(workspace:GetChildren()) do
        if not Players:GetPlayerFromCharacter(child) and child ~= camera and not child:IsA("Terrain") then
            pcall(function()
                MapBackup[child.Name] = child:Clone()
            end)
        end
    end
end)

-- [HỆ THỐNG GIAO DIỆN AN TOÀN]
local pgui = nil
local success_gui = pcall(function()
    if gethui then
        pgui = gethui()
    elseif game:GetService("CoreGui"):FindFirstChild("RobloxGui") then
        pgui = game:GetService("CoreGui")
    else
        pgui = player:WaitForChild("PlayerGui")
    end
end)

if not pgui or not success_gui then
    pgui = player:WaitForChild("PlayerGui")
end

-- DỌN SẠCH BẢN CŨ NẾU CÓ
if pgui:FindFirstChild("HuyScriptHubV2") then 
    pgui.HuyScriptHubV2:Destroy() 
end

-- KHỞI TẠO GUI CHÍNH
local gui = Instance.new("ScreenGui")
gui.Name = "HuyScriptHubV2"
gui.ResetOnSpawn = false
gui.Parent = pgui

-- Nút mở Menu
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 110, 0, 45)
toggleBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
toggleBtn.Text = "HUY HUB V4.3 🌌"
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

-- Khung menu chính
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 390, 0, 280) 
main.Position = UDim2.new(0.5, -195, 0.5, -140)
main.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
main.Visible = false
main.Active = true
main.ClipsDescendants = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0.05, 0)

local mainGrass = Instance.new("Frame", main)
mainGrass.Size = UDim2.new(1, 0, 0.1, 0)
mainGrass.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
mainGrass.BorderSizePixel = 0
Instance.new("UICorner", mainGrass).CornerRadius = UDim.new(0.3, 0)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0.1, 0)
title.Text = "HUY SCRIPT HUB V4.3.2"
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
    local dragging = false
    local dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
makeDraggable(toggleBtn)
makeDraggable(main)

toggleBtn.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)
closeBtn.MouseButton1Click:Connect(function() main.Visible = false end)

-- PHÂN CHIA KHU VỰC TAB
local tabButtonsFrame = Instance.new("ScrollingFrame", main)
tabButtonsFrame.Size = UDim2.new(0, 110, 0.82, -5)
tabButtonsFrame.Position = UDim2.new(0, 5, 0.15, 0)
tabButtonsFrame.BackgroundTransparency = 1
tabButtonsFrame.BorderSizePixel = 0
tabButtonsFrame.ScrollBarThickness = 0
tabButtonsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
tabButtonsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local pagesFrame = Instance.new("Frame", main)
pagesFrame.Size = UDim2.new(0, 265, 0.85, -5)
pagesFrame.Position = UDim2.new(0, 120, 0.15, 0)
pagesFrame.BackgroundTransparency = 1

local tabLayout = Instance.new("UIListLayout", tabButtonsFrame)
tabLayout.Padding = UDim.new(0, 5)

local pages = {}
local tabButtons = {}
local togglesList = {} 

local function createTab(tabName)
    local p = Instance.new("ScrollingFrame", pagesFrame)
    p.Size = UDim2.new(1, 0, 1, 0)
    p.Visible = false
    p.BackgroundTransparency = 1
    p.BorderSizePixel = 0
    p.ScrollBarThickness = 3
    p.ScrollBarImageColor3 = Color3.fromRGB(34, 139, 34)
    p.CanvasSize = UDim2.new(0, 0, 0, 0)
    p.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local pLayout = Instance.new("UIListLayout", p)
    pLayout.Padding = UDim.new(0, 6)
    
    pages[tabName] = p
    
    local btn = Instance.new("TextButton", tabButtonsFrame)
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.Text = tabName
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    btn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0.2, 0)
    
    btn.MouseButton1Click:Connect(function()
        for tName, pFrame in pairs(pages) do pFrame.Visible = (tName == tabName) end
        for _, b in pairs(tabButtons) do b.BackgroundColor3 = Color3.fromRGB(80, 80, 80) end
        btn.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
    end)
    table.insert(tabButtons, btn)
end

-- TẠO CÁC TAB THEO ĐÚNG THỨ TỰ
createTab("Main 🏠")
createTab("Player")
createTab("Combat V3")  
createTab("Visual")
createTab("Farm")
createTab("Other") 

-- BIẾN TRẠNG THÁI HACK CỐT LÕI
_G.SpeedEnabled = false
_G.Speed = 50
_G.Fly = false
_G.Noclip = false
_G.InfJump = false
_G.ESP_Player = false
_G.ESP_NPC = false
_G.HitboxAlways = false
_G.HitboxSize = 10
_G.FullBright = false
_G.AutoE = false
_G.AutoClick = false
_G.KillAura = false
_G.TpToItems = false
_G.AutoEquip = false
_G.FPSBooster = false
_G.RemoveObstacles = false
_G.AutoParry = false

local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 1.5
        })
    end)
end

local function addToggle(tabName, text, key, callback)
    local targetPage = pages[tabName]
    if not targetPage then return end
    
    local b = Instance.new("TextButton", targetPage)
    b.Size = UDim2.new(1, -6, 0, 32)
    b.Text = text
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 13
    b.BackgroundColor3 = Color3.fromRGB(50,50,50)
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0.2, 0)
    
    b.MouseButton1Click:Connect(function()
        _G[key] = not _G[key]
        b.BackgroundColor3 = _G[key] and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(50,50,50)
        notify("Huy Hub", text .. (_G[key] and " 🟢 BẬT" or " 🔴 TẮT"))
        if callback then callback(_G[key]) end
    end)
    togglesList[key] = {button = b, defaultText = text, callback = callback}
end

-- ==================== TAB MAIN MỚI ====================
local nameLabel = Instance.new("TextLabel", pages["Main 🏠"])
nameLabel.Size = UDim2.new(1, -6, 0, 42)
nameLabel.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
nameLabel.Text = "📝 Tác giả: Tran Quang Huy"
nameLabel.Font = Enum.Font.SourceSansBold
nameLabel.TextSize = 14
nameLabel.TextColor3 = Color3.fromRGB(255, 215, 0) 
Instance.new("UICorner", nameLabel).CornerRadius = UDim.new(0.2, 0)

local subLabel = Instance.new("TextLabel", pages["Main 🏠"])
subLabel.Size = UDim2.new(1, -6, 0, 25)
subLabel.BackgroundTransparency = 1
subLabel.Text = "chào mung bạn đến Huy script hub"
subLabel.Font = Enum.Font.SourceSansItalic
subLabel.TextSize = 13
subLabel.TextColor3 = Color3.new(1, 1, 1)

local resetBtn = Instance.new("TextButton", pages["Main 🏠"])
resetBtn.Size = UDim2.new(1, -6, 0, 48)
resetBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
resetBtn.Text = "🔄 RESET ALL"
resetBtn.Font = Enum.Font.SourceSansBold
resetBtn.TextSize = 15
resetBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0.2, 0)

local resetStroke = Instance.new("UIStroke", resetBtn)
resetStroke.Thickness = 1.5
resetStroke.Color = Color3.fromRGB(255, 255, 255)

resetBtn.MouseButton1Click:Connect(function()
    notify("Huy Hub Resetting...", "Đang khôi phục bản đồ & chỉ số...")
    for key, data in pairs(togglesList) do
        _G[key] = false
        if data.button then data.button.BackgroundColor3 = Color3.fromRGB(50, 50, 50) end
        if data.callback then pcall(function() data.callback(false) end) end
    end
    pcall(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 16
            player.Character.Humanoid.JumpPower = 50
        end
    end)
    for name, originalModel in pairs(MapBackup) do
        pcall(function()
            local existing = workspace:FindFirstChild(name)
            if not existing then
                local restored = originalModel:Clone()
                restored.Parent = workspace
            end
        end)
    end
    notify("Thành Công!", "Bản đồ đã được khôi phục nguyên vẹn!")
end)

-- TAB PLAYER
addToggle("Player", "Bật Tốc Độ (Speed)", "SpeedEnabled")

local speedFrame = Instance.new("Frame", pages["Player"])
speedFrame.Size = UDim2.new(1, -6, 0, 45)
speedFrame.BackgroundColor3 = Color3.fromRGB(60, 40, 20)
Instance.new("UICorner", speedFrame).CornerRadius = UDim.new(0.15, 0)

local minusBtn = Instance.new("TextButton", speedFrame)
minusBtn.Size = UDim2.new(0, 30, 0, 30)
minusBtn.Position = UDim2.new(0.05, 0, 0.5, -15)
minusBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 40)
minusBtn.Text = "[-]"
minusBtn.TextColor3 = Color3.new(1,1,1)
minusBtn.Font = Enum.Font.SourceSansBold
minusBtn.TextSize = 14
Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0.3, 0)

local plusBtn = Instance.new("TextButton", speedFrame)
plusBtn.Size = UDim2.new(0, 30, 0, 30)
plusBtn.Position = UDim2.new(0.85, -10, 0.5, -15)
plusBtn.BackgroundColor3 = Color3.fromRGB(40, 80, 40)
plusBtn.Text = "[+]"
plusBtn.TextColor3 = Color3.new(1,1,1)
plusBtn.Font = Enum.Font.SourceSansBold
plusBtn.TextSize = 14
Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0.3, 0)

local speedLabel = Instance.new("TextLabel", speedFrame)
speedLabel.Size = UDim2.new(0.4, 0, 0, 14)
speedLabel.Position = UDim2.new(0.3, 0, 0.1, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Tốc độ: 50"
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.TextSize = 11
speedLabel.Font = Enum.Font.SourceSansBold

local speedBar = Instance.new("Frame", speedFrame)
speedBar.Size = UDim2.new(0.45, 0, 0, 5)
speedBar.Position = UDim2.new(0.275, 0, 0.65, 0)
speedBar.BackgroundColor3 = Color3.fromRGB(40,40,40)

local speedBall = Instance.new("TextButton", speedBar)
speedBall.Size = UDim2.new(0, 12, 0, 12)
speedBall.Position = UDim2.new(0.1, -6, 0.5, -6)
speedBall.BackgroundColor3 = Color3.new(1,1,1)
speedBall.Text = ""
Instance.new("UICorner", speedBall).CornerRadius = UDim.new(1, 0)

local function updateSpeedUI()
    _G.Speed = math.clamp(_G.Speed, 16, 500)
    speedLabel.Text = "Tốc độ: " .. tostring(_G.Speed)
    local pct = (_G.Speed - 16) / (500 - 16)
    speedBall.Position = UDim2.new(pct, -6, 0.5, -6)
end

minusBtn.MouseButton1Click:Connect(function() _G.Speed = _G.Speed - 5 updateSpeedUI() end)
plusBtn.MouseButton1Click:Connect(function() _G.Speed = _G.Speed + 5 updateSpeedUI() end)

speedBall.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                connection:Disconnect()
            else
                local mousePos = UserInputService:GetMouseLocation().X
                local barPos = speedBar.AbsolutePosition.X
                local barSize = speedBar.AbsoluteSize.X
                local percent = math.clamp((mousePos - barPos) / barSize, 0, 1)
                _G.Speed = math.round(16 + (percent * (500 - 16)))
                updateSpeedUI()
            end
        end)
    end
end)

local flySpeed = 50
local flyingConnection
addToggle("Player", "Bay (Fly)", "Fly", function(state)
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    if state then
        hum.PlatformStand = true
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Name = "FlyVelocity"
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = Vector3.new(0,0,0)
        
        local bg = Instance.new("BodyGyro", hrp)
        bg.Name = "FlyGyro"
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.CFrame = hrp.CFrame

        flyingConnection = RunService.RenderStepped:Connect(function()
            local moveDir = hum.MoveDirection
            local vel = Vector3.new(0,0,0)
            if moveDir.Magnitude > 0 then vel = moveDir * flySpeed end
            bv.Velocity = vel
            bg.CFrame = camera.CFrame
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
                    if child:IsA("BasePart") and child.CanCollide then child.CanCollide = false end
                end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() end
    end
end)

addToggle("Player", "Nhảy Vô Hạn (Inf Jump)", "InfJump")
UserInputService.JumpRequest:Connect(function()
    if _G.InfJump and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- TAB COMBAT V3
addToggle("Combat V3", "Tự Động Đỡ Đòn (Auto Parry)", "AutoParry", function(state)
    if state then
        task.spawn(function()
            while _G.AutoParry do
                task.wait(0.08) 
                for _, monster in pairs(workspace:GetDescendants()) do
                    if monster:IsA("Model") and monster:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(monster) then
                        local mHrp = monster:FindFirstChild("HumanoidRootPart")
                        if mHrp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = (player.Character.HumanoidRootPart.Position - mHrp.Position).Magnitude
                            if dist < 12 then
                                local blockTool = player.Backpack:FindFirstChild("Block") or player.Character:FindFirstChild("Block") or player.Backpack:FindFirstChildOfClass("Tool")
                                if blockTool then
                                    player.Character.Humanoid:EquipTool(blockTool)
                                    blockTool:Activate()
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- TAB VISUAL
addToggle("Visual", "ESP Người Chơi", "ESP_Player")
addToggle("Visual", "ESP NPC", "ESP_NPC")
addToggle("Visual", "Hitbox Always (Khối hộp xanh)", "HitboxAlways")

local hitboxFrame = Instance.new("Frame", pages["Visual"])
hitboxFrame.Size = UDim2.new(1, -6, 0, 40)
hitboxFrame.BackgroundColor3 = Color3.fromRGB(60, 40, 20)
Instance.new("UICorner", hitboxFrame).CornerRadius = UDim.new(0.15, 0)

local hitboxLabel = Instance.new("TextLabel", hitboxFrame)
hitboxLabel.Size = UDim2.new(1, 0, 0, 14)
hitboxLabel.BackgroundTransparency = 1
hitboxLabel.Text = "Kích cỡ Hitbox: 10"
hitboxLabel.TextColor3 = Color3.new(1,1,1)
hitboxLabel.TextSize = 11
hitboxLabel.Font = Enum.Font.SourceSansBold

local hitboxBar = Instance.new("Frame", hitboxFrame)
hitboxBar.Size = UDim2.new(0.8, 0, 0, 5)
hitboxBar.Position = UDim2.new(0.1, 0, 0.6, 0)
hitboxBar.BackgroundColor3 = Color3.fromRGB(40,40,40)

local hitboxBall = Instance.new("TextButton", hitboxBar)
hitboxBall.Size = UDim2.new(0, 12, 0, 12)
hitboxBall.Position = UDim2.new(0.3, -6, 0.5, -6)
hitboxBall.BackgroundColor3 = Color3.new(1,1,1)
hitboxBall.Text = ""
Instance.new("UICorner", hitboxBall).CornerRadius = UDim.new(1, 0)

hitboxBall.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                connection:Disconnect()
            else
                local mousePos = UserInputService:GetMouseLocation().X
                local barPos = hitboxBar.AbsolutePosition.X
                local barSize = hitboxBar.AbsoluteSize.X
                local percent = math.clamp((mousePos - barPos) / barSize, 0, 1)
                hitboxBall.Position = UDim2.new(percent, -6, 0.5, -6)
                _G.HitboxSize = math.round(1 + (percent * 29))
                hitboxLabel.Text = "Kích cỡ Hitbox: " .. tostring(_G.HitboxSize)
            end
        end)
    end
end)

local lightBackup = {Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient, Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime}
addToggle("Visual", "Sáng Màn Hình (FullBright)", "FullBright", function(state)
    if state then
        task.spawn(function()
            while _G.FullBright do
                Lighting.Ambient = Color3.fromRGB(255, 255, 255)
                Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
                Lighting.Brightness = 3
                Lighting.ClockTime = 12
                task.wait(0.5)
            end
        end)
    else
        Lighting.Ambient = lightBackup.Ambient
        Lighting.OutdoorAmbient = lightBackup.OutdoorAmbient
        Lighting.Brightness = lightBackup.Brightness
        Lighting.ClockTime = lightBackup.ClockTime
    end
end)

local activeHighlights = {}
local function applyHighlight(model, outlineColor, fillColor)
    if not model or activeHighlights[model] then return end
    local highlight = Instance.new("Highlight", model)
    highlight.Name = "ESP_Highlight_Standard"
    highlight.FillColor = fillColor
    highlight.FillTransparency = 0.75
    highlight.OutlineColor = outlineColor 
    highlight.OutlineTransparency = 0.1
    highlight.Adornee = model
    activeHighlights[model] = highlight
end

local function removeHighlight(model)
    if activeHighlights[model] then
        pcall(function() activeHighlights[model]:Destroy() end)
        activeHighlights[model] = nil
    end
    local old = model:FindFirstChild("ESP_Highlight_Standard")
    if old then pcall(function() old:Destroy() end) end
end

task.spawn(function()
    while true do
        task.wait(0.5) 
        if _G.ESP_Player then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character then applyHighlight(p.Character, Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 170, 255)) end
            end
        else
            for _, p in pairs(Players:GetPlayers()) do if p.Character then removeHighlight(p.Character) end end
        end

        if _G.ESP_NPC then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
                    local isRealPlayer = false
                    for _, p in pairs(Players:GetPlayers()) do
                        if p.Character == obj then isRealPlayer = true break end
                    end
                    if not isRealPlayer then applyHighlight(obj, Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 50, 50)) end
                end
            end
        else
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
                    local isRealPlayer = false
                    for _, p in pairs(Players:GetPlayers()) do
                        if p.Character == obj then isRealPlayer = true break end
                    end
                    if not isRealPlayer then removeHighlight(obj) end
                end
            end
        end

        if _G.HitboxAlways then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") and obj ~= player.Character then
                    local hrp = obj.HumanoidRootPart
                    hrp.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
                    hrp.Transparency = 0.85
                    hrp.Color = Color3.fromRGB(0, 255, 0)
                    hrp.CanCollide = false
                end
            end
        else
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") then
                    obj.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                    obj.HumanoidRootPart.Transparency = 1
                end
            end
        end
    end
end)

-- TAB FARM
addToggle("Farm", "Auto Tương Tác (Auto E)", "AutoE", function(state)
    if state then
        task.spawn(function()
            while _G.AutoE do
                task.wait(0.2)
                for _, prompt in pairs(workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then fireproximityprompt(prompt, 1) end
                end
            end
        end)
    end
end)

addToggle("Farm", "Tự Động Click (Auto Click)", "AutoClick", function(state)
    if state then
        task.spawn(function()
            while _G.AutoClick do
                task.wait(0.02) 
                pcall(function()
                    local char = player.Character
                    if char and char:FindFirstChildOfClass("Tool") then char:FindFirstChildOfClass("Tool"):Activate() end
                end)
            end
        end)
    end
end)

local function getWeakestTarget()
    local myChar = player.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
    local weakest = nil
    local lowestHealth = math.huge
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local char = otherPlayer.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 and hum.Health < lowestHealth then
                lowestHealth = hum.Health weakest = hrp
            end
        end
    end
    if not weakest then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj ~= myChar and not Players:GetPlayerFromCharacter(obj) then
                local hum = obj:FindFirstChildOfClass("Humanoid")
                local hrp = obj:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health > 0 and hum.Health < lowestHealth then
                    lowestHealth = hum.Health weakest = hrp
                end
            end
        end
    end
    return weakest
end

addToggle("Farm", "Kill Aura (TP Kill 1s)", "KillAura", function(state)
    if state then
        task.spawn(function()
            while _G.KillAura do
                task.wait(0.1)
                local myChar = player.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                    local targetHrp = getWeakestTarget()
                    if targetHrp and targetHrp.Parent then
                        local tool = myChar:FindFirstChildOfClass("Tool") or player.Backpack:FindFirstChildOfClass("Tool")
                        if tool and tool.Parent == player.Backpack then myChar.Humanoid:EquipTool(tool) end
                        
                        local startTime = os.clock()
                        while _G.KillAura and targetHrp and targetHrp.Parent and (os.clock() - startTime) < 1.0 do
                            local hum = targetHrp.Parent:FindFirstChildOfClass("Humanoid")
                            if not hum or hum.Health <= 0 then break end
                            myChar.HumanoidRootPart.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 2)
                            if tool then tool:Activate() end
                            task.wait(0.05) 
                        end
                    end
                end
            end
        end)
    end
end)

addToggle("Farm", "Teleport To Items", "TpToItems", function(state)
    if state then
        task.spawn(function()
            while _G.TpToItems do
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local targetFound = false
                    for _, item in pairs(workspace:GetDescendants()) do
                        if item:IsA("ProximityPrompt") and item.Parent and item.Parent:IsA("BasePart") then
                            char.HumanoidRootPart.CFrame = item.Parent.CFrame * CFrame.new(0, 2, 0)
                            task.wait(0.3) 
                            fireproximityprompt(item, 1)
                            targetFound = true
                        end
                    end
                    if not targetFound then task.wait(0.5) end
                end
                task.wait(0.1)
            end
        end)
    end
end)

addToggle("Farm", "Tự Trang Bị Kiếm (Auto Equip)", "AutoEquip", function(state)
    if state then
        task.spawn(function()
            while _G.AutoEquip do
                task.wait(0.5)
                local char = player.Character
                if char and char:FindFirstChild("Humanoid") and not char:FindFirstChildOfClass("Tool") then
                    local targetTool = player.Backpack:FindFirstChildOfClass("Tool")
                    if targetTool then char.Humanoid:EquipTool(targetTool) end
                end
            end
        end)
    end
end)

-- TAB OTHER
addToggle("Other", "FPS Booster", "FPSBooster", function(state)
    if state then
        settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Default
        Lighting.GlobalShadows = false
        Lighting.OutdoorLightPerspectiveLimit = 0
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1
            elseif v:IsA("PostEffect") then v.Enabled = false end
        end
    end
end)

-- ==================== NÂNG CẤP XÓA VẬT CẢN HỖ TRỢ TOÀN DIỆN MOBILE VÀ TƯỜNG KHÓA ====================
local obstacleConnection = nil
addToggle("Other", "Xoá Vật Cản", "RemoveObstacles", function(state)
    if state then
        local tool = Instance.new("Tool", player.Backpack)
        tool.Name = "Xoá Vật Cản ⚒️"
        tool.RequiresHandle = false
        
        -- Hàm xử lý logic xóa thông minh (Bỏ qua Locked, dùng chung cho cả Click và Touch)
        local function processDelete(targetPart)
            if targetPart and targetPart:IsA("BasePart") then
                local character = player.Character
                local hitCharacter = targetPart:FindFirstAncestorOfClass("Model")
                
                -- Không cho phép tự xóa bản thân hoặc xóa người chơi khác
                if not hitCharacter or (hitCharacter ~= character and not Players:GetPlayerFromCharacter(hitCharacter)) then
                    pcall(function()
                        targetPart.Locked = false -- Bẻ khóa bảo vệ của Tường/Part
                        
                        -- Tạo hiệu ứng chuyển đỏ cảnh báo trước khi hủy
                        local selectBox = Instance.new("SelectionBox", targetPart)
                        selectBox.Color3 = Color3.fromRGB(255, 0, 0)
                        selectBox.Adornee = targetPart
                    end)
                    task.wait(0.02)
                    pcall(function() targetPart:Destroy() end)
                end
            end
        end

        -- Kích hoạt bằng Tool trên PC/Mobile
        tool.Activated:Connect(function()
            -- Giải pháp 1: Dành cho PC (Dùng tâm chuột)
            if UserInputService.TouchEnabled == false then
                processDelete(mouse.Target)
            end
        end)
        
        -- Giải pháp 2: Quét tọa độ chạm đa điểm (Chuyên trị cho Điện thoại / Mobile)
        obstacleConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and player.Character and player.Character:FindFirstChild("Xoá Vật Cản ⚒️") then
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local pos = input.Position
                    local ray = camera:ViewportPointToRay(pos.X, pos.Y)
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                    raycastParams.FilterDescendantsInstances = {player.Character}
                    
                    local result = workspace:Raycast(ray.Origin, ray.Direction * 1000, raycastParams)
                    if result and result.Instance then
                        processDelete(result.Instance)
                    end
                end
            end
        end)
    else
        -- Dọn dẹp Tool khi tắt
        if obstacleConnection then obstacleConnection:Disconnect() obstacleConnection = nil end
        local t1 = player.Backpack:FindFirstChild("Xoá Vật Cản ⚒️")
        local t2 = player.Character and player.Character:FindFirstChild("Xoá Vật Cản ⚒️")
        if t1 then t1:Destroy() end
        if t2 then t2:Destroy() end
    end
end)

-- VÒNG LẶP WALK SPEED
RunService.Stepped:Connect(function()
    if _G.SpeedEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = _G.Speed
    end
end)

-- KHỞI ĐỘNG HIỂN THỊ MẶC ĐỊNH TAB MAIN
task.spawn(function()
    task.wait(0.1)
    for tName, pFrame in pairs(pages) do pFrame.Visible = (tName == "Main 🏠") end
    for _, b in pairs(tabButtons) do 
        if b.Text == "Main 🏠" then b.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
        else b.BackgroundColor3 = Color3.fromRGB(80, 80, 80) end
    end
end)

notify("Huy Hub V4.3.2", "Đã fix lỗi Xóa Vật Cản trên Điện thoại! Cầm item chạm thẳng vào tường để xóa nhé bro!")
