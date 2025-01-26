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
    Speed = Window:AddTab({ Title = "⚡ Velocidade" }),
    Teleport = Window:AddTab({ Title = "⭐ Teleporte" }),
    Kill = Window:AddTab({ Title = "💀 Kill" }),
    Others = Window:AddTab({ Title = "📂 Others" })
}

-- Notificação inicial
Fluent:Notify({
    Title = "Bem-vindo",
    Content = "O Capuz Hub foi carregado.",
    Duration = 5
})

-- Adicionando scripts na aba "Others"
Tabs.Others:AddButton({
    Title = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet(('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'), true))()
        Fluent:Notify({
            Title = "Carregado",
            Content = "Infinite Yield foi executado com sucesso.",
            Duration = 5
        })
    end
})

Tabs.Others:AddButton({
    Title = "Capuz Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/CapuzHub/main/source.lua"))()
        Fluent:Notify({
            Title = "Carregado",
            Content = "Capuz Hub foi executado com sucesso.",
            Duration = 5
        })
    end
})

-- Funções e configurações já existentes
-- (Não removidas, pois foram solicitadas como parte do contexto original)
-- Funções e lógica específicas para abas Speed, Teleport, e Kill
-- Configurações de salvamento e interface (SaveManager e InterfaceManager)

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:SetFolder("CapuzHub/specific-game")
InterfaceManager:SetFolder("CapuzHub")

InterfaceManager:BuildInterfaceSection(Tabs.Main)
InterfaceManager:BuildInterfaceSection(Tabs.Speed)
InterfaceManager:BuildInterfaceSection(Tabs.Teleport)
InterfaceManager:BuildInterfaceSection(Tabs.Kill)
SaveManager:BuildConfigSection(Tabs.Main)

-- Configuração para a aba Others
SaveManager:BuildConfigSection(Tabs.Others)

-- Configuração do botão flutuante para alternar visibilidade
local FloatingButton = Instance.new("TextButton")
FloatingButton.Size = UDim2.fromOffset(100, 50)
FloatingButton.Position = UDim2.new(0.5, -50, 0.1, 0)
FloatingButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FloatingButton.Text = "Cpz Hb"
FloatingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingButton.Font = Enum.Font.SourceSans
FloatingButton.TextSize = 24
FloatingButton.Parent = game.CoreGui

local isHubVisible = true
local function ToggleHubVisibility()
    if isHubVisible then
        Window:Hide()
    else
        Window:Show()
    end
    isHubVisible = not isHubVisible
end

FloatingButton.MouseButton1Click:Connect(ToggleHubVisibility)

Window:SelectTab(1)
Fluent:Notify({
    Title = "Capuz Hub",
    Content = "A interface foi carregada.",
    Duration = 8
})

SaveManager:LoadAutoloadConfig()
