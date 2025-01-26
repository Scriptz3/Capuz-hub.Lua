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

-- Abas
local Tabs = {
    Main = Window:AddTab({ Title = "Main" }),
    Speed = Window:AddTab({ Title = "Velocidade" }),
    Teleport = Window:AddTab({ Title = "Teleporte" }),
    Kill = Window:AddTab({ Title = "Kill" }) -- Adicionando a aba "Kill"
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

-- Listando todos os jogadores na aba "Kill"
for _, targetPlayer in ipairs(game.Players:GetPlayers()) do
    if targetPlayer ~= game.Players.LocalPlayer then  -- Não adicionar o próprio jogador à lista
        Tabs.Kill:AddButton({
            Title = "Kill " .. targetPlayer.Name,  -- Alterado de "Teleportar para" para "Kill"
            Callback = function()
                -- Teleporta o jogador
                TeleportToPlayer(targetPlayer)

                -- Mensagem de animação
                Fluent:Notify({
                    Title = "Atenção",
                    Content = "Fique com a animação em deitar-se com o carrinho.",
                    Duration = 5
                })

                -- Ficar preso ao jogador alvo
                StickToPlayer(targetPlayer)

                -- Aguardar até o jogador alvo sentar no carrinho
                local isInCart, vehicle = IsPlayerInCart(targetPlayer)
                while not isInCart do
                    wait(1)
                    isInCart, vehicle = IsPlayerInCart(targetPlayer)
                end

                -- Depois que o jogador senta no carrinho, teletransporta o jogador e o carrinho para o void
                SendToVoid(game.Players.LocalPlayer, vehicle)
                print("Jogador " .. targetPlayer.Name .. " e seu carrinho foram teleportados para o void.")
            end
        })
    end
end

-- Adicionando a lista de jogadores na aba "Teleport"
for _, targetPlayer in ipairs(game.Players:GetPlayers()) do
    if targetPlayer ~= game.Players.LocalPlayer then  -- Não adicionar o próprio jogador à lista
        Tabs.Teleport:AddButton({
            Title = "Teleportar para " .. targetPlayer.Name,
            Callback = function()
                TeleportToPlayer(targetPlayer)
                Fluent:Notify({
                    Title = "Teleporte",
                    Content = "Teleportado para " .. targetPlayer.Name,
                    Duration = 5
                })
            end
        })
    end
end

-- Configuração dos gerenciadores
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Construção da interface
InterfaceManager:SetFolder("CapuzHub")
SaveManager:SetFolder("CapuzHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Main)
InterfaceManager:BuildInterfaceSection(Tabs.Speed)
InterfaceManager:BuildInterfaceSection(Tabs.Teleport) -- Adiciona a sessão Teleporte
InterfaceManager:BuildInterfaceSection(Tabs.Kill) -- Adiciona a sessão Kill
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
