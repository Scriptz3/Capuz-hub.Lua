local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Capuz Hub",
    SubTitle = "by Scriptz3",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Abas com emojis
local Tabs = {
    Main = Window:AddTab({ Title = "Main" }),
    Speed = Window:AddTab({ Title = "⚡ Velocidade" }),  -- Emoji de raio ao lado de "Velocidade"
    Teleport = Window:AddTab({ Title = "⭐ Teleporte" }),  -- Emoji de estrela ao lado de "Teleporte"
    Troll = Window:AddTab({ Title = "💀 Troll" })  -- Renomeado de "Kill" para "Troll" e emoji de caveira
}

-- Notificação inicial
Fluent:Notify({
    Title = "Bem-vindo",
    Content = "O Capuz Hub foi carregado.",
    Duration = 5
})

-- Função para alterar a velocidade de tpwalk
local function SetTpwalkSpeed(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    print("Velocidade ajustada para Tpwalk " .. value)
end

-- Adicionando as opções de velocidade (Tpwalk 2, Tpwalk 3, etc.) na aba "Velocidade"
local SpeedOptions = {2, 3, 4, 5, 10, 50, 100, 200, 500}

for _, speed in ipairs(SpeedOptions) do
    Tabs.Speed:AddButton({
        Title = "Tpwalk " .. speed,
        Callback = function()
            SetTpwalkSpeed(speed)
        end
    })
end

-- Função para teleportar para um jogador
local function TeleportToPlayer(player)
    local character = game.Players.LocalPlayer.Character
    if character and player.Character then
        character:MoveTo(player.Character.HumanoidRootPart.Position)
        print("Teleported to " .. player.Name)
    else
        print("Erro ao teleportar para " .. player.Name)
    end
end

-- Função para verificar se o jogador está sentado no carrinho
local function IsPlayerInCart(player)
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        for _, vehicle in pairs(workspace:GetChildren()) do
            if vehicle:IsA("Model") and vehicle:FindFirstChild("Seat") then
                local seat = vehicle.Seat
                if seat.Occupant == humanoid then
                    return true, vehicle
                end
            end
        end
    end
    return false
end

-- Função para enviar o jogador e o carrinho para o "void"
local function SendToVoid(player, vehicle)
    -- Teleportando o jogador
    local char = player.Character
    if char then
        local humanoidRootPart = char:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            humanoidRootPart.CFrame = CFrame.new(0, -5000, 0)  -- Teleporta para o "void"
        end
    end

    -- Teleportando o carrinho
    if vehicle and vehicle:FindFirstChild("HumanoidRootPart") then
        vehicle.HumanoidRootPart.CFrame = CFrame.new(0, -5000, 0)  -- Teleporta o carrinho para o "void"
    end
end

-- Função para manter o jogador "preso" ao alvo
local function StickToPlayer(targetPlayer)
    local character = game.Players.LocalPlayer.Character
    local targetCharacter = targetPlayer.Character

    if character and targetCharacter then
        -- Fica "preso" ao alvo
        local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart")
        local playerHRP = character:FindFirstChild("HumanoidRootPart")

        if targetHRP and playerHRP then
            -- Atualiza a posição do jogador com o alvo
            while targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") do
                playerHRP.CFrame = targetHRP.CFrame
                wait(0.1)  -- Ajuste do tempo, para não causar delay
            end
        end
    end
end

-- Função para seguir um jogador
local function FollowPlayer(targetPlayer)
    local character = game.Players.LocalPlayer.Character
    local targetCharacter = targetPlayer.Character

    if character and targetCharacter then
        -- Atualiza a posição para seguir o jogador alvo
        while targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") do
            local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                character:MoveTo(targetHRP.Position)
            end
            wait(0.5)  -- Ajuste do tempo para não sobrecarregar a movimentação
        end
    end
end

-- Função para ver um jogador
local function ViewPlayer(targetPlayer)
    local character = game.Players.LocalPlayer.Character
    local targetCharacter = targetPlayer.Character

    if character and targetCharacter then
        -- Alinha o personagem para ver o jogador alvo
        local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart")
        if targetHRP then
            character:SetPrimaryPartCFrame(targetHRP.CFrame)
        end
    end
end

-- Função para atualizar a lista de jogadores
local function UpdatePlayerList()
    for _, targetPlayer in ipairs(game.Players:GetPlayers()) do
        if targetPlayer ~= game.Players.LocalPlayer then
            Tabs.Troll:AddButton({
                Title = targetPlayer.Name,
                Callback = function()
                    -- Exibe as opções para o jogador selecionado
                    local subMenu = Tabs.Troll:AddSection({
                        Title = "Kill Player",
                        List = true
                    })

                    subMenu:AddButton({
                        Title = "Follow",
                        Callback = function()
                            FollowPlayer(targetPlayer)
                        end
                    })

                    subMenu:AddButton({
                        Title = "Goto",
                        Callback = function()
                            TeleportToPlayer(targetPlayer)
                        end
                    })

                    subMenu:AddButton({
                        Title = "View",
                        Callback = function()
                            ViewPlayer(targetPlayer)
                        end
                    })

                    subMenu:AddButton({
                        Title = "Reset List",
                        Callback = function()
                            UpdatePlayerList()
                        end
                    })
                end
            })
        end
    end
end

-- Inicializando a lista de jogadores
UpdatePlayerList()

-- Função para abrir e minimizar a lista de jogadores
local isPlayerListVisible = false
local function TogglePlayerList()
    isPlayerListVisible = not isPlayerListVisible
    if isPlayerListVisible then
        UpdatePlayerList()
    else
        Tabs.Troll:Clear()
    end
end

-- Adicionando o botão "Player list" na sessão Troll
Tabs.Troll:AddButton({
    Title = "Player list",
    Callback = TogglePlayerList
})

-- Configuração dos gerenciadores
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Construção da interface
InterfaceManager:SetFolder("CapuzHub")
SaveManager:SetFolder("CapuzHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Main)
InterfaceManager:BuildInterfaceSection(Tabs.Speed)
InterfaceManager:BuildInterfaceSection(Tabs.Teleport) -- Adiciona a sessão Teleporte
InterfaceManager:BuildInterfaceSection(Tabs.Troll) -- Adiciona a sessão Troll
SaveManager:BuildConfigSection(Tabs.Main)

-- Seleciona a aba principal
Window:SelectTab(1)

Fluent:Notify({
    Title = "Capuz Hub",
    Content = "A interface foi carregada.",
    Duration = 8
})

-- Salvando configurações
SaveManager:LoadAutoloadConfig()

-- Criando o botão flutuante
local FloatingButton = Instance.new("TextButton")
FloatingButton.Size = UDim2.fromOffset(100, 50)
FloatingButton.Position = UDim2.new(0.5, -50, 0.1, 0)  -- Centralizado na parte superior
FloatingButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Cor de fundo do botão
FloatingButton.Text = "Cpz Hb"  -- Texto do botão
FloatingButton.TextColor3 = Color3.fromRGB(255, 255, 255)  -- Cor do texto
FloatingButton.Font = Enum.Font.SourceSans
FloatingButton.TextSize = 24
FloatingButton.Parent = game.CoreGui

-- Função para alternar a visibilidade do Hub
local isHubVisible = true  -- Flag para controlar a visibilidade do Hub

local function ToggleHubVisibility()
    if isHubVisible then
        Window:Hide()  -- Esconde o Hub
    else
        Window:Show()  -- Mostra o Hub
    end
    isHubVisible = not isHubVisible  -- Alterna o estado da visibilidade
end

-- Conectando o clique no botão flutuante
FloatingButton.MouseButton1Click:Connect(ToggleHubVisibility)
