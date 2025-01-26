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
    Main = Window:AddTab({ Title = "Menu" }),
    Speed = Window:AddTab({ Title = "Velocidade" }),
    Troll = Window:AddTab({ Title = "Troll" })
}

-- Função para teleportar para outro jogador
local function TeleportToPlayer(playerName)
    local targetPlayer = game.Players:FindFirstChild(playerName)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
        local localPlayer = game.Players.LocalPlayer
        if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
            print("Teleportado para " .. playerName)
        end
    else
        Fluent:Notify({
            Title = "Erro",
            Content = "Jogador não encontrado ou sem posição válida.",
            Duration = 3
        })
        print("Erro ao teleportar: jogador não encontrado ou inválido.")
    end
end

-- Lista de jogadores na aba "Troll"
local PlayerListSection = Tabs.Troll:AddSection({ Title = "Lista de Jogadores" })

local function RefreshPlayerList()
    PlayerListSection:Clear() -- Limpa a lista existente
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            -- Cria botão para cada jogador com a opção "TP"
            PlayerListSection:AddButton({
                Title = player.Name,
                Callback = function()
                    -- Ao clicar no nome do jogador, oferece a opção de teleportar
                    Fluent:Notify({
                        Title = "Teleportar para " .. player.Name,
                        Content = "Deseja se teleportar para " .. player.Name .. "?",
                        Duration = 3
                    })
                    
                    -- Adiciona o botão de Teleportar (TP) dentro da lista
                    PlayerListSection:AddButton({
                        Title = "TP para " .. player.Name,
                        Callback = function()
                            TeleportToPlayer(player.Name)
                        end
                    })
                end
            })
        end
    end
end

-- Botão para atualizar a lista de jogadores
Tabs.Troll:AddButton({
    Title = "Atualizar Lista",
    Callback = function()
        RefreshPlayerList()
        print("Lista de jogadores atualizada.")
    end
})

-- Atualiza a lista automaticamente ao abrir
RefreshPlayerList()

-- Configuração dos gerenciadores
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

InterfaceManager:SetFolder("CapuzHub")
SaveManager:SetFolder("CapuzHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Main)
InterfaceManager:BuildInterfaceSection(Tabs.Speed)
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
