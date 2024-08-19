loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Keyboard-16345"))()
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local flying = false
local speed = 50
local camera = game.Workspace.CurrentCamera

local bodyGyro, bodyVelocity

-- Afficher un message dans le chat quand le script est chargé
local function sendMessageToChat(message)
    local chatService = game:GetService("Chat")
    chatService:Chat(character.Head, message, Enum.ChatColor.Blue)
end

sendMessageToChat("KeamsOS is successfully loaded")

-- Créer un écran GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyMenuGui"
screenGui.Parent = playerGui

-- Créer un cadre (le menu) centré à l'écran
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 200, 0, 300)
menuFrame.Position = UDim2.new(0.5, -100, 0.5, -150)
menuFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
menuFrame.BorderSizePixel = 0
menuFrame.AnchorPoint = Vector2.new(0.5, 0.5)
menuFrame.Parent = screenGui
menuFrame.Visible = true

-- Ajouter des coins arrondis au menu
local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 10)
uicorner.Parent = menuFrame

-- Ajouter un bouton pour activer le vol
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 180, 0, 40)
flyButton.Position = UDim2.new(0.5, 0, 0, 20)
flyButton.AnchorPoint = Vector2.new(0.5, 0)
flyButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
flyButton.TextColor3 = Color3.new(1, 1, 1)
flyButton.Text = "Fly"
flyButton.Font = Enum.Font.GothamBold
flyButton.TextSize = 18
flyButton.Parent = menuFrame

local flyButtonCorner = Instance.new("UICorner")
flyButtonCorner.CornerRadius = UDim.new(0, 10)
flyButtonCorner.Parent = flyButton

-- Ajouter un bouton pour désactiver le vol
local unflyButton = Instance.new("TextButton")
unflyButton.Size = UDim2.new(0, 180, 0, 40)
unflyButton.Position = UDim2.new(0.5, 0, 0, 80)
unflyButton.AnchorPoint = Vector2.new(0.5, 0)
unflyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
unflyButton.TextColor3 = Color3.new(1, 1, 1)
unflyButton.Text = "Unfly"
unflyButton.Font = Enum.Font.GothamBold
unflyButton.TextSize = 18
unflyButton.Parent = menuFrame

local unflyButtonCorner = Instance.new("UICorner")
unflyButtonCorner.CornerRadius = UDim.new(0, 10)
unflyButtonCorner.Parent = unflyButton

-- Ajouter un bouton de fermeture du menu
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 180, 0, 40)
closeButton.Position = UDim2.new(0.5, 0, 1, -30)
closeButton.AnchorPoint = Vector2.new(0.5, 1)
closeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Text = "Fermer"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 18
closeButton.Parent = menuFrame

local closeButtonCorner = Instance.new("UICorner")
closeButtonCorner.CornerRadius = UDim.new(0, 10)
closeButtonCorner.Parent = closeButton

-- Fonction pour activer le vol
local function startFlying()
    if not flying then
        flying = true
        humanoid.PlatformStand = true
        
        -- Créer BodyVelocity pour gérer le mouvement du joueur dans les airs
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
        bodyVelocity.Parent = character.HumanoidRootPart

        -- Créer BodyGyro pour stabiliser le joueur en vol
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
        bodyGyro.CFrame = character.HumanoidRootPart.CFrame
        bodyGyro.Parent = character.HumanoidRootPart

        sendMessageToChat("Flying mode enabled")
    end
end

-- Fonction pour désactiver le vol
local function stopFlying()
    if flying then
        flying = false
        humanoid.PlatformStand = false

        bodyVelocity:Destroy()
        bodyGyro:Destroy()

        sendMessageToChat("Flying mode disabled")
    end
end

-- Gérer le clic sur le bouton Fly
flyButton.MouseButton1Click:Connect(function()
    startFlying()
end)

-- Gérer le clic sur le bouton Unfly
unflyButton.MouseButton1Click:Connect(function()
    stopFlying()
end)

-- Gérer le clic sur le bouton Fermer
closeButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = false
end)

-- Gérer le vol pendant que le joueur est en mode "Fly"
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")

rs.RenderStepped:Connect(function()
    if flying then
        local direction = Vector3.new(0, 0, 0)

        -- Utiliser la direction de la caméra pour orienter le vol
        local cameraCF = camera.CFrame
        local lookVector = cameraCF.LookVector

        -- Contrôles clavier
        if uis:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + lookVector
        end
        if uis:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - lookVector
        end
        if uis:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - cameraCF.RightVector
        end
        if uis:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + cameraCF.RightVector
        end
        if uis:IsKeyDown(Enum.KeyCode.Space) then
            direction = direction + Vector3.new(0, 1, 0)
        end
        if uis:IsKeyDown(Enum.KeyCode.LeftControl) then
            direction = direction - Vector3.new(0, 1, 0)
        end

        -- Appliquer la direction et la vitesse
        bodyVelocity.Velocity = direction * speed
        bodyGyro.CFrame = cameraCF
    end
end)

-- Gérer les mouvements sur mobile
local touchInput = Vector2.new(0, 0)

uis.TouchMoved:Connect(function(input)
    touchInput = input.Position
end)

rs.RenderStepped:Connect(function()
    if flying then
        -- Contrôler le vol avec les mouvements tactiles
        local screenCenter = camera.ViewportSize / 2
        local direction = (touchInput - screenCenter).Unit

        -- Convertir direction de l'écran à l'espace du monde
        direction = camera.CFrame:VectorToWorldSpace(Vector3.new(direction.X, 0, direction.Y))
        bodyVelocity.Velocity = direction * speed
    end
end)

-- Ajouter de la fonctionnalité pour déplacer le menu sur mobile (et PC)
local dragging = false
local dragStart = nil
local startPos = nil

local function update(input)
    local delta = input.Position - dragStart
    menuFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

menuFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = menuFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

menuFrame.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        update(input)
    end
end)
