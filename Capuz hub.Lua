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
    Speed = Window:AddTab({ Title = "Velocidade" })
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

-- Configuração dos gerenciadores
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Construção da interface
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
