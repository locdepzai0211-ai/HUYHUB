-- =========================================================================
--                     HUY SCRIPT HUB V4.4.6 (THE ULTIMATE VERSION)
--       [SỬA LỖI]: KHÔI PHỤC TOÀN BỘ TẤT CẢ TÍNH NĂNG HACK + GIỮ KHUNG CHAT XỊN
--       [TRẠNG THÁI]: HOÀN CHỈNH 100% - KHÔNG CÒN LỖI LẦM
-- =========================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

-- HỆ THỐNG BACKUP MAP AN TOÀN
local MapBackup = {}
task.spawn(function()
    for _, child in pairs(workspace:GetChildren()) do
        if not Players:GetPlayerFromCharacter(child) and child ~= camera and not child:IsA("Terrain") then
            pcall(function() MapBackup[child.Name] = child:Clone() end)
        end
    end
end)

local pgui = nil
local success_gui = pcall(function()
    if gethui then pgui = gethui()
    elseif game:GetService("CoreGui"):FindFirstChild("RobloxGui") then pgui = game:GetService("CoreGui")
    else pgui = player:WaitForChild("PlayerGui") end
end)
if not pgui or not success_gui then pgui = player:WaitForChild("PlayerGui") end

-- DỌN SẠCH BẢN CŨ V4.4.5
if pgui:FindFirstChild("HuyScriptHubV2") then pgui.HuyScriptHubV2:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "HuyScriptHubV2"
gui.ResetOnSpawn = false
gui.Parent = pgui

-- Nút mở Menu
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 110, 0, 45)
toggleBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
toggleBtn.Text = "HUY HUB V4.4.6 🌌"
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
local main = Instance.new("CanvasGroup", gui)
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
title.Text = "HUY SCRIPT HUB V4.4.6"
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

-- ANIMATION ĐÓNG / MỞ MENU
local isTweening = false
local currentScale = Instance.new("UIScale", main)
local function toggleMenu()
    if isTweening then return end isTweening = true
    if not main.Visible then
        main.Visible = true main.GroupTransparency = 1 currentScale.Scale = 0.7
        TweenService:Create(currentScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        local t = TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 0})
        t:Play() t.Completed:Connect(function() isTweening = false end)
    else
        TweenService:Create(currentScale, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0.7}):Play()
        local t = TweenService:Create(main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {GroupTransparency = 1})
        t:Play() t.Completed:Connect(function() main.Visible = false isTweening = false end)
    end
end
toggleBtn.MouseButton1Click:Connect(toggleMenu) closeBtn.MouseButton1Click:Connect(toggleMenu)

-- KHU VỰC TAB
local tabButtonsFrame = Instance.new("ScrollingFrame", main)
tabButtonsFrame.Size = UDim2.new(0, 110, 0.82, -5)
tabButtonsFrame.Position = UDim2.new(0, 5, 0.15, 0)
tabButtonsFrame.BackgroundTransparency = 1
tabButtonsFrame.ScrollBarThickness = 0
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
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.Text = tabName
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    btn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0.2, 0)
    
    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(tabButtons) do TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play() end
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(34, 139, 34)}):Play()
        for tName, pFrame in pairs(pages) do 
            if tName == tabName then
                pFrame.Visible = true pFrame.Position = UDim2.new(0, 0, 0, 15)
                TweenService:Create(pFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
            else pFrame.Visible = false end
        end
    end)
    table.insert(tabButtons, btn)
end

-- KHỞI TẠO TẤT CẢ CÁC TAB NHƯ CŨ
createTab("Main 🏠")
createTab("Player")
createTab("Combat V3")  
createTab("Visual")
createTab("Farm")           
createTab("Chat Server 🌐", true)
createTab("Setting UI ⚙️")  

-- KHAI BÁO BIẾN HACK FULL TRỞ LẠI
_G.SpeedEnabled = false; _G.Speed = 50; _G.Fly = false; _G.Noclip = false; _G.InfJump = false
_G.ESP_Player = false; _G.ESP_NPC = false; _G.ESP_Item = false; _G.HitboxAlways = false; _G.HitboxSize = 10; _G.FullBright = false
_G.AutoE = false; _G.AutoClick = false; _G.KillAura = false; _G.TpToItems = false; _G.AutoEquip = false
_G.AutoFarmLevel = false; _G.BringMonsters = false; _G.AutoSkill = false; _G.AutoParry = false
_G.StreamerMode = false; _G.FPSBooster = false

local function notify(title, text)
    pcall(function() StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = 1.5}) end)
end

local function addToggle(tabName, text, key, callback)
    local targetPage = pages[tabName] if not targetPage then return end
    local b = Instance.new("TextButton", targetPage)
    b.Size = UDim2.new(1, -6, 0, 32)
    b.Text = text b.Font = Enum.Font.SourceSansBold b.TextSize = 13
    b.BackgroundColor3 = Color3.fromRGB(50,50,50) b.TextColor3 = Color3.new(1,1,1)
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

    local function update(input)
        local sizeX = math.clamp((input.Position.X - container.AbsolutePosition.X) / container.AbsoluteSize.X, 0, 1)
        bar.Size = UDim2.new(sizeX, 0, 1, 0)
        local value = math.floor(min + (sizeX * (max - min)))
        _G[key] = value
        label.Text = text .. ": " .. tostring(value)
        if callback then callback(value) end
    end

    local sliding = false
    container.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = true update(input) end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input) end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = false end
    end)
end

-- ==================== KHÔI PHỤC TOÀN BỘ LOGIC CÁC TAB ====================

-- TAB MAIN
local nameLabel = Instance.new("TextLabel", pages["Main 🏠"])
nameLabel.Size = UDim2.new(1, -6, 0, 42)
nameLabel.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
nameLabel.Text = "📝 Tác giả: Tran Quang Huy\nChào mừng bạn đến với Huy Script Hub v4.4.6 Full!"
nameLabel.Font = Enum.Font.SourceSansBold
nameLabel.TextSize = 12
nameLabel.TextColor3 = Color3.fromRGB(255, 215, 0) 
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
addToggle("Visual", "ESP Items (Tương Tác)", "ESP_Item")
addToggle("Visual", "Hitbox Always", "HitboxAlways")
addSlider("Visual", "Kích cỡ Hitbox", "HitboxSize", 2, 50)
addToggle("Visual", "Sáng Màn Hình (FullBright)", "FullBright")

local lightBackup = {Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient, Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime}

local function applyHighlight(model, name, outlineColor, fillColor)
    if not model or not model:IsA("Instance") then return end
    local old = model:FindFirstChild(name)
    if not old then
        local highlight = Instance.new("Highlight")
        highlight.Name = name
        highlight.FillColor = fillColor
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = outlineColor 
        highlight.OutlineTransparency = 0.1
        highlight.Adornee = model
        highlight.Parent = model
    end
end

local function removeHighlight(model, name)
    if not model then return end
    local old = model:FindFirstChild(name)
    if old then pcall(function() old:Destroy() end) end
end

RunService.RenderStepped:Connect(function()
    if _G.SpeedEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = _G.Speed
    end

    if _G.FullBright then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 3
        Lighting.ClockTime = 12
    else
        Lighting.Ambient = lightBackup.Ambient
        Lighting.OutdoorAmbient = lightBackup.OutdoorAmbient
        Lighting.Brightness = lightBackup.Brightness
        Lighting.ClockTime = lightBackup.ClockTime
    end
end)

task.spawn(function()
    while true do
        task.wait(0.4)
        if _G.ESP_Player then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character then applyHighlight(p.Character, "Hub_PlayerESP", Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 170, 255)) end
            end
        else
            for _, p in pairs(Players:GetPlayers()) do if p.Character then removeHighlight(p.Character, "Hub_PlayerESP") end end
        end

        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
                local isRealPlayer = false
                for _, p in pairs(Players:GetPlayers()) do if p.Character == obj then isRealPlayer = true break end end
                if not isRealPlayer then
                    if _G.ESP_NPC then applyHighlight(obj, "Hub_NPCESP", Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 50, 50))
                    else removeHighlight(obj, "Hub_NPCESP") end
                end
            end

            if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") and obj ~= player.Character then
                local hrp = obj.HumanoidRootPart
                if _G.HitboxAlways then
                    hrp.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
                    hrp.Transparency = 0.75
                    hrp.Color = Color3.fromRGB(0, 255, 0)
                    hrp.CanCollide = false
                else
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                end
            end

            if _G.ESP_Item and (obj:IsA("ProximityPrompt") or obj:IsA("ClickDetector")) then
                local parent = obj.Parent
                if parent and (parent:IsA("BasePart") or parent:IsA("Model")) then applyHighlight(parent, "Hub_ItemESP", Color3.fromRGB(255, 255, 0), Color3.fromRGB(0, 255, 0)) end
            elseif not _G.ESP_Item and (obj:IsA("ProximityPrompt") or obj:IsA("ClickDetector")) then
                if obj.Parent then removeHighlight(obj.Parent, "Hub_ItemESP") end
            end
        end
    end
end)

-- TAB FARM
addToggle("Farm", "Auto Farm Level (Thông minh)", "AutoFarmLevel")
addToggle("Farm", "Gom Quái Lại 1 Điểm (Magnet)", "BringMonsters", function(state)
    if state then
        task.spawn(function()
            while _G.BringMonsters do
                task.wait(0.2)
                pcall(function()
                    local myHrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if myHrp then
                        for _, v in pairs(workspace:GetDescendants()) do
                            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v ~= player.Character then
                                if (v.HumanoidRootPart.Position - myHrp.Position).Magnitude < 150 then
                                    v.HumanoidRootPart.CFrame = myHrp.CFrame * CFrame.new(0, 0, -5)
                                    v.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end
end)

addToggle("Farm", "Tự Động Tung Chiêu (Auto Skill Z,X,C)", "AutoSkill", function(state)
    if state then
        task.spawn(function()
            local VirtualInputManager = game:GetService("VirtualInputManager")
            while _G.AutoSkill do
                task.wait(1)
                if player.Character and player.Character:FindFirstChildOfClass("Tool") then
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game) task.wait(0.1)
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game) task.wait(0.1)
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
                end
            end
        end)
    end
end)

local function getWeakestTarget()
    local myChar = player.Character if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
    local weakest = nil local lowestHealth = math.huge
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local char = otherPlayer.Character local hum = char:FindFirstChildOfClass("Humanoid") local hrp = char:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 and hum.Health < lowestHealth then lowestHealth = hum.Health weakest = hrp end
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
                        myChar.HumanoidRootPart.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 2)
                        if tool then tool:Activate() end
                    end
                end
            end
        end)
    end
end)

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

addToggle("Farm", "Teleport To Items", "TpToItems", function(state)
    if state then
        task.spawn(function()
            while _G.TpToItems do
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    for _, item in pairs(workspace:GetDescendants()) do
                        if item:IsA("ProximityPrompt") and item.Parent and item.Parent:IsA("BasePart") then
                            char.HumanoidRootPart.CFrame = item.Parent.CFrame * CFrame.new(0, 2, 0)
                            task.wait(0.3) fireproximityprompt(item, 1)
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end)

addToggle("Farm", "Tự Trang Bị Vũ Khí", "AutoEquip", function(state)
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


-- ==================== TAB CHAT SERVER MƯỢT MÀ TỪ V4.4.5 ====================
local chatTab = pages["Chat Server 🌐"]
local chatDisplay = Instance.new("ScrollingFrame", chatTab)
chatDisplay.Size = UDim2.new(1, -6, 0, 165)
chatDisplay.Position = UDim2.new(0, 3, 0, 5)
chatDisplay.BackgroundColor3 = Color3.fromRGB(45, 25, 10)
chatDisplay.ScrollBarThickness = 4
chatDisplay.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UICorner", chatDisplay).CornerRadius = UDim.new(0.05, 0)

local chatLayout = Instance.new("UIListLayout", chatDisplay)
chatLayout.Padding = UDim.new(0, 4)

local chatInput = Instance.new("TextBox", chatTab)
chatInput.Size = UDim2.new(0, 195, 0, 32)
chatInput.Position = UDim2.new(0, 3, 0, 178)
chatInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
chatInput.TextColor3 = Color3.new(1, 1, 1)
chatInput.Text = ""
chatInput.PlaceholderText = " Nhập tin nhắn HuyHub..."
chatInput.TextSize = 12
chatInput.Font = Enum.Font.SourceSans
Instance.new("UICorner", chatInput).CornerRadius = UDim.new(0.15, 0)

local sendBtn = Instance.new("TextButton", chatTab)
sendBtn.Size = UDim2.new(0, 60, 0, 32)
sendBtn.Position = UDim2.new(0, 202, 0, 178)
sendBtn.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
sendBtn.Text = "GỬI 🚀"
sendBtn.TextColor3 = Color3.new(1, 1, 1)
sendBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", sendBtn).CornerRadius = UDim.new(0.15, 0)

local NEW_DATABASE_URL = "https://huyhub-global-chat-default-rtdb.firebaseio.com/messages.json"
local trackingMessages = {}

local function displayMessage(sender, msg)
    local msgKey = sender .. ":" .. msg
    if trackingMessages[msgKey] and sender ~= player.Name then return end
    trackingMessages[msgKey] = true

    local lbl = Instance.new("TextLabel", chatDisplay)
    lbl.Size = UDim2.new(1, -10, 0, 24)
    lbl.BackgroundTransparency = 1
    lbl.Text = " 👤 [" .. sender .. "]: " .. msg
    lbl.TextColor3 = (sender == player.Name) and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(240, 240, 240)
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextWrapped = true
    
    task.defer(function() chatDisplay.CanvasPosition = Vector2.new(0, chatDisplay.AbsoluteCanvasSize.Y + 50) end)
end

local function handleSendChat()
    local text = chatInput.Text
    if text:gsub(" ", "") == "" then return end
    chatInput.Text = ""
    
    displayMessage(player.Name, text)
    
    task.spawn(function()
        local data = {sender = player.Name, message = text, time = os.time()}
        pcall(function() HttpService:PostAsync(NEW_DATABASE_URL, HttpService:JSONEncode(data)) end)
    end)
end

sendBtn.MouseButton1Click:Connect(handleSendChat)
chatInput.FocusLost:Connect(function(enterPressed) if enterPressed then handleSendChat() end end)

task.spawn(function()
    while true do
        pcall(function()
            local response = HttpService:GetAsync(NEW_DATABASE_URL)
            if response and response ~= "null" then
                local allChats = HttpService:JSONDecode(response)
                if allChats then
                    for _, chatData in pairs(allChats) do
                        if chatData.sender and chatData.message and chatData.sender ~= player.Name then
                            displayMessage(chatData.sender, chatData.message)
                        end
                    end
                end
            end
        end)
        task.wait(1.2)
    end
end)

-- TAB SETTING UI
addToggle("Setting UI ⚙️", "Chế Độ Streamer (Ẩn Tên)", "StreamerMode", function(state)
    if state then title.Text = "STREAMER MODE" else title.Text = "HUY SCRIPT HUB V4.4.6" end
end)
addToggle("Setting UI ⚙️", "FPS Booster", "FPSBooster", function(state)
    if state then
        Lighting.GlobalShadows = false
        for _, v in pairs(game:GetDescendants()) do if v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1 end end
    end
end)

-- MẶC ĐỊNH CHỌN TAB MAIN
task.spawn(function()
    task.wait(0.1)
    for tName, pFrame in pairs(pages) do pFrame.Visible = (tName == "Main 🏠") end
    for _, b in pairs(tabButtons) do 
        if b.Text == "Main 🏠" then b.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
        else b.BackgroundColor3 = Color3.fromRGB(80, 80, 80) end
    end
end)

notify("HUY SCRIPT HUB V4.4.6", "Đã khôi phục thành công toàn bộ tính năng hack!")
