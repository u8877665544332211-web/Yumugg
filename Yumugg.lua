local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Toggles = getgenv().Toggles or Library.Toggles
local Options = getgenv().Options or Library.Options

-- ==========================================
-- Services & Local Player 설정
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local lp = LocalPlayer
local Camera = Workspace.CurrentCamera or Workspace:WaitForChild("Camera")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Global Config & State Table (통합 관리)
getgenv().Config = getgenv().Config or {}
getgenv().State = getgenv().State or {}

local Window = Library:CreateWindow({
    Title = 'Yumu Enchantment - discord.gg/qTV5c5Fn6',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    Combat = Window:AddTab('Combat'),
    Visuals = Window:AddTab('Visuals'),
    Character = Window:AddTab('Character'),
    Misc = Window:AddTab('Misc'),
    Setting = Window:AddTab('Setting')
}

local _0l1lOIIII0 = true

local function is_teammate(player)
    if not _0l1lOIIII0 then return false end
    local _357_939 = LocalPlayer:GetAttribute("TeamID")
    local L880_33 = player:GetAttribute("TeamID")
    if _357_939 == nil or L880_33 == nil then return false end
    return L880_33 == _357_939
end

local function get_character(playerOrChar)
    local char = playerOrChar
    if typeof(playerOrChar) == "Instance" and playerOrChar:IsA("Player") then
        char = playerOrChar.Character
    end
    if not char then return true end
    if char:FindFirstChildOfClass("ForceField") then return true end
    local __BfgstqWnead = char:FindFirstChild("HumanoidRootPart")
    if __BfgstqWnead and __BfgstqWnead:FindFirstChild("Attachment") then return true end
    local _IlO1IIIIOl1I = char:GetAttribute("Immune") or char:GetAttribute("Invincible") or char:GetAttribute("IsImmune")
    if _IlO1IIIIOl1I == true then return true end
    local a87b18c82 = char:FindFirstChildOfClass("Humanoid")
    if a87b18c82 then
        local _7665x159 = a87b18c82:GetAttribute("Immune") or a87b18c82:GetAttribute("Invincible")
        if _7665x159 == true then return true end
    end
    return false
end

local function get_player_from_part(player)
    local char = player and player.Character
    if not char then return false end
    local _8898x144 = {"Reflecting", "IsReflecting", "BulletReflect", "Reflect", "Deflecting", "Parrying"}
    for _, a in ipairs(_8898x144) do
        local _01O001l00 = char:GetAttribute(a)
        if _01O001l00 == true or _01O001l00 == 1 or _01O001l00 == "true" then return true end
    end
    return false
end

-- ==========================================
-- Desync & Ragebot Main Logic 변수 정의
-- ==========================================
local _2631x704 = true
local flyEnabled = false
local _8080x566 = 50000000
local _lII0ll = false
local _4012x732 = 0.25
local a85b57c99 = 0.1
local L555_61 = false
local __lhiRNgvZ = 3 
local a73b35c96 = nil

local L389_46 = nil
local L273_20 = nil
local _10O0lO = nil

task.spawn(function()
    while true do
        if _lII0ll and L555_61 then
            _2631x704 = true
            local _3661x412 = a85b57c99
            if typeof(_3661x412) ~= "number" or _3661x412 < 0.01 then _3661x412 = 0.01 end
            task.wait(_3661x412)
            if _lII0ll and L555_61 then
                _2631x704 = false
                local _0xdee6 = _4012x732
                if typeof(_0xdee6) ~= "number" or _0xdee6 < 0.01 then _0xdee6 = 0.01 end
                task.wait(_0xdee6)
            else
                _2631x704 = true
            end
        else
            _2631x704 = true
            task.wait(0.05)
        end
    end
end)

local function get_character_root(char)
    if not char then return nil end
    return char:FindFirstChild("HitboxHead")
        or char:FindFirstChild("HitboxHeadSmall")
        or char:FindFirstChild("Head")
end

local v71190 = function(on) end

task.spawn(function()
    pcall(function()
        local _3213x326 = LocalPlayer.PlayerScripts
        local a66b43c59, _9817x625 = pcall(require, _3213x326.Controllers.FighterController)
        local _0xd857, v27885     = pcall(require, ReplicatedStorage.Modules.EnumLibrary)
        local __MAwXiJM    = ReplicatedStorage.Remotes.Replication.Fighter.UseItem
        local _IIOl1OI11O00; pcall(function() _IIOl1OI11O00 = v27885:ToEnum("StartShooting") end)

        local function _5460x742()
            if not (a66b43c59 and _9817x625) then return nil end
            local _0x3584 = _9817x625.LocalFighter; if not _0x3584 then return nil end
            local _549_282 = _0x3584.EquippedItem; if not _549_282 then return nil end
            local L704_40, L987_53 = pcall(function() return _549_282:Get("ObjectID") end)
            if L704_40 and L987_53 then return L987_53 end
            L704_40, L987_53 = pcall(function() return _549_282.Data and _549_282.Data.ObjectID end)
            return L704_40 and L987_53 or nil
        end

        local function teleport_character(originPos, _IOI1l0I100)
            local L501_16 = _IOI1l0I100.Position
            local _0xb60d = CFrame.lookAt(originPos, L501_16)
            local _0Il0I11O, _1897x442, _0xefad = _0xb60d:ToOrientation()
            local a49b75c71 = {
                [utf8.char(0)] = originPos.X, [utf8.char(1)] = originPos.Y, [utf8.char(2)] = originPos.Z,
                [utf8.char(3)] = _0Il0I11O, [utf8.char(4)] = _1897x442, [utf8.char(5)] = _0xefad,
            }
            local a12b15c22 = _IOI1l0I100.CFrame:ToObjectSpace(CFrame.new(L501_16))
            local _lOl1lI0llll0, _1l00IOl101Il, __CtOClXPOnz = a12b15c22:ToOrientation()
            return {
                [utf8.char(1)] = {
                    [utf8.char(0)] = a49b75c71,
                    [utf8.char(1)] = a49b75c71,
                    [utf8.char(2)] = _IOI1l0I100,
                    [utf8.char(3)] = {
                        [utf8.char(0)] = a12b15c22.X, [utf8.char(1)] = a12b15c22.Y, [utf8.char(2)] = a12b15c22.Z,
                        [utf8.char(3)] = _lOl1lI0llll0, [utf8.char(4)] = _1l00IOl101Il, [utf8.char(5)] = __CtOClXPOnz,
                    },
                },
            }
        end

        v71190 = function(on)
            if _10O0lO then _10O0lO:Disconnect(); _10O0lO = nil end
            if not on then return end

            local _l0OIIO = nil
            _10O0lO = RunService.Heartbeat:Connect(function()
                if not L555_61 or not _2631x704 then return end
                if not a73b35c96 or not a73b35c96.Parent then return end

                local a20b32c46 = a73b35c96:FindFirstAncestorOfClass("Model") or a73b35c96.Parent
                local a14b42c70 = Players:GetPlayerFromCharacter(a20b32c46)
                if not a14b42c70 or a14b42c70 == LocalPlayer then return end
                if is_teammate(a14b42c70) or get_character(a14b42c70) or get_player_from_part(a14b42c70) then return end

                local _lO00OO0 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not _lO00OO0 then return end

                local _0xf72a = _5460x742()
                if _0xf72a then _l0OIIO = _0xf72a else _0xf72a = _l0OIIO end
                if not _0xf72a then return end

                local L405_52 = a73b35c96
                local _0Ol00I01OO0l = L405_52.Position + Vector3.new(0, 0.1, 0)
                local v84604 = teleport_character(_0Ol00I01OO0l, L405_52)
                pcall(function()
                    if _0xf72a and _IIOl1OI11O00 then
                        __MAwXiJM:FireServer(_0xf72a, _IIOl1OI11O00, v84604, nil)
                    end
                end)
            end)
        end
    end)
end)

local function find_closest_target()
    local v83548 = true
    pcall(function()
        local _3213x326 = LocalPlayer.PlayerScripts
        local _0x9ec3, _0lO010OIIO = pcall(require, _3213x326.Controllers.FighterController)
        if not _0x9ec3 or not _0lO010OIIO or not _0lO010OIIO.LocalFighter then return end
        local _549_282 = _0lO010OIIO.LocalFighter.EquippedItem
        if not _549_282 then v83548 = false; return end
    end)
    return v83548
end

local function restore_desync_position()
    local __BfgstqWnead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not __BfgstqWnead or not L389_46 then return end
    __BfgstqWnead.CFrame = L389_46
    if L273_20 then __BfgstqWnead.AssemblyLinearVelocity = L273_20 end
    L389_46 = nil
    L273_20 = nil
end

pcall(function() RunService:UnbindFromRenderStep("RestoreDesyncPerfect") end)
pcall(function() RunService:BindToRenderStep("RestoreDesyncPerfect", 0, restore_desync_position) end)
RunService.RenderStepped:Connect(restore_desync_position)

RunService.Heartbeat:Connect(function()
    pcall(function()
        local __BfgstqWnead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not __BfgstqWnead then return end

        if L389_46 then restore_desync_position() end

        if L555_61 and _2631x704 and a73b35c96 and find_closest_target() then
            local _3921x508 = a73b35c96:FindFirstAncestorOfClass("Model") or a73b35c96.Parent
            local _456_638 = Players:GetPlayerFromCharacter(_3921x508)
            if _456_638 and get_player_from_part(_456_638) then return end
            
            L389_46 = __BfgstqWnead.CFrame
            L273_20 = __BfgstqWnead.AssemblyLinearVelocity
            
            local L501_16 = a73b35c96.Position
            local _7279x484 = L501_16 + Vector3.new(0, __lhiRNgvZ, 0)
            __BfgstqWnead.CFrame = CFrame.new(_7279x484, L501_16)
            return
        end

        if flyEnabled then
            L389_46 = __BfgstqWnead.CFrame
            L273_20 = __BfgstqWnead.AssemblyLinearVelocity
            local _687_388 = Vector3.new(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100)).Unit
            local _7279x484 = __BfgstqWnead.Position + _687_388 * _8080x566
            local _OIOO0O1 = L389_46 - L389_46.Position
            __BfgstqWnead.CFrame = CFrame.new(_7279x484) * _OIOO0O1
        end
    end)
end)

task.spawn(function()
    while true do
        task.wait(0.01)
        if L555_61 and _2631x704 then
            local __xxEEAQiVz = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position or Vector3.zero
            local _338_977 = nil
            local __UHvhQn = math.huge

            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and not is_teammate(player) then
                    if get_character(player) or get_player_from_part(player) then continue end
                    local __BfgstqWnead = player.Character:FindFirstChild("HumanoidRootPart")
                    local a87b18c82 = player.Character:FindFirstChild("Humanoid")
                    if __BfgstqWnead and a87b18c82 and a87b18c82.Health > 0 then
                        local _100l10O0II = (Vector3.new(__xxEEAQiVz.X, 0, __xxEEAQiVz.Z) - Vector3.new(__BfgstqWnead.Position.X, 0, __BfgstqWnead.Position.Z)).Magnitude
                        if _100l10O0II < __UHvhQn then
                            __UHvhQn = _100l10O0II
                            _338_977 = player
                        end
                    end
                end
            end

            if _338_977 and _338_977.Character then
                a73b35c96 = get_character_root(_338_977.Character)
            else
                a73b35c96 = nil
            end
        else
            a73b35c96 = nil
        end
    end
end)

-- ==========================================
-- Combat 탭 UI 구성
-- ==========================================
local AimbotGroup = Tabs.Combat:AddLeftGroupbox('Aimbot')
AimbotGroup:AddToggle('AimbotEnable', {
    Text = 'Enable Aimbot',
    Default = false,
    Callback = function(Value)
        getgenv().elisium = getgenv().elisium or {}
        getgenv().elisium.aimbot = getgenv().elisium.aimbot or {}
        getgenv().elisium.aimbot.enable = Value
    end
})

AimbotGroup:AddToggle('AimbotShowFOV', {
    Text = 'Show FOV',
    Default = false,
    Callback = function(Value)
        if getgenv().elisium and getgenv().elisium.aimbot then
            getgenv().elisium.aimbot.show_fov = Value
        end
    end
}):AddColorPicker('AimbotFOVColor', {
    Default = Color3.fromRGB(120, 81, 166),
    Title = 'FOV Color',
    Callback = function(Value)
        if getgenv().elisium and getgenv().elisium.aimbot then
            getgenv().elisium.aimbot.fov_color = Value
        end
    end
})

AimbotGroup:AddSlider('AimbotFOVRadius', {
    Text = 'FOV Radius',
    Default = 180,
    Min = 10,
    Max = 800,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        if getgenv().elisium and getgenv().elisium.aimbot then
            getgenv().elisium.aimbot.fov_radius = Value
        end
    end
})

AimbotGroup:AddSlider('AimbotSmoothing', {
    Text = 'Smoothing',
    Default = 1,
    Min = 1,
    Max = 20,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        if getgenv().elisium and getgenv().elisium.aimbot then
            getgenv().elisium.aimbot.smoothing = Value
        end
    end
})

AimbotGroup:AddToggle('AimbotClosestPart', {
    Text = 'Target Closest Part',
    Default = false,
    Callback = function(Value)
        if getgenv().elisium and getgenv().elisium.aimbot then
            getgenv().elisium.aimbot.closest_part = Value
        end
    end
})

local SilentAimGroup = Tabs.Combat:AddRightGroupbox('Silent Aim')
SilentAimGroup:AddToggle('SilentAimEnable', {
    Text = 'Enable Silent Aim',
    Default = false,
    Callback = function(Value)
        getgenv().elisium = getgenv().elisium or {}
        getgenv().elisium.silent_aim = getgenv().elisium.silent_aim or {}
        getgenv().elisium.silent_aim.enable = Value
    end
})

SilentAimGroup:AddToggle('SilentAimShowFOV', {
    Text = 'Show FOV',
    Default = false,
    Callback = function(Value)
        if getgenv().elisium and getgenv().elisium.silent_aim then
            getgenv().elisium.silent_aim.show_fov = Value
        end
    end
}):AddColorPicker('SilentAimFOVColor', {
    Default = Color3.fromRGB(120, 81, 166),
    Title = 'FOV Color',
    Callback = function(Value)
        if getgenv().elisium and getgenv().elisium.silent_aim then
            getgenv().elisium.silent_aim.fov_color = Value
        end
    end
})

SilentAimGroup:AddSlider('SilentAimFOVRadius', {
    Text = 'FOV Radius',
    Default = 180,
    Min = 10,
    Max = 800,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        if getgenv().elisium and getgenv().elisium.silent_aim then
            getgenv().elisium.silent_aim.fov_radius = Value
        end
    end
})

SilentAimGroup:AddSlider('SilentAimHitChance', {
    Text = 'Hit Chance',
    Default = 100,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        if getgenv().elisium and getgenv().elisium.silent_aim then
            getgenv().elisium.silent_aim.hit_chance = Value
        end
    end
})

SilentAimGroup:AddToggle('SilentAimClosestPart', {
    Text = 'Target Closest Part',
    Default = false,
    Callback = function(Value)
        if getgenv().elisium and getgenv().elisium.silent_aim then
            getgenv().elisium.silent_aim.closest_part = Value
        end
    end
})

local RagebotGroup = Tabs.Combat:AddLeftGroupbox('Ragebot')
RagebotGroup:AddToggle('RagebotEnabled', {
    Text = 'Enabled',
    Default = false,
    Callback = function(Value)
        L555_61 = Value
        pcall(function() v71190(Value) end)
    end
})

RagebotGroup:AddToggle('RagebotOrbit', {
    Text = 'Orbit',
    Default = false,
    Callback = function(Value)
        flyEnabled = Value
        if Value then
            _8080x566 = 5003
        end
    end
})

RagebotGroup:AddToggle('RagebotVoidspam', {
    Text = 'Void Spam',
    Default = false,
    Callback = function(Value)
        _lII0ll = Value
        if not Value then
            _2631x704 = true
        end
    end
})

RagebotGroup:AddSlider('RagebotHide', {
    Text = 'Hide Delay',
    Default = 0.25,
    Min = 0.01,
    Max = 1,
    Rounding = 2,
    Compact = false,
    Callback = function(Value)
        _4012x732 = Value
    end
})

RagebotGroup:AddSlider('RagebotAttack', {
    Text = 'Attack Delay',
    Default = 0.1,
    Min = 0.01,
    Max = 1,
    Rounding = 2,
    Compact = false,
    Callback = function(Value)
        a85b57c99 = Value
    end
})

-- ============================================================================
-- VISUALS MODULE & UI INTEGRATION
-- ============================================================================
Config.Visuals = false
Config.VisualsPreset = "Neutral"
Config.VisualsPerformanceMode = false
Config.VisualsFullbright = false
Config.VisualsNoFog = false
Config.VisualsHolograms = false
Config.VisualsRainbowMap = false
Config.VisualsRainbowMapSpeed = 0.15
Config.VisualsStretch = 1.0
Config.VisualsCameraSway = false
Config.VisualsCameraSwayAmount = 0.5
Config.VisualsGrade = "Crisp"
Config.VisualsGradeStrength = 0.6
Config.VisualsBloom = false
Config.VisualsBloomIntensity = 1.0
Config.VisualsVignette = false
Config.VisualsVignetteStrength = 0.6
Config.VisualsLetterbox = false
Config.VisualsLetterboxSize = 0.10
Config.VisualsDOF = false
Config.VisualsDOFDistance = 28
Config.VisualsDOFBlur = 0.5

local Visuals = {}
;(function()
    local _origLighting, _origClones = nil, {}
    local _hologramFolder = nil
    local _stretchBound, _rainbowConn = false, nil
    local _rainbowParts, _rainbowHue, _rainbowBatchIdx = {}, 0, 1
    local _perfBackup, _origParticleRates = nil, {}
    local _reassertConn, _reassertLastT = nil, 0
    local LIGHTING_PROPS = {
        "Brightness","ExposureCompensation","GlobalShadows","ShadowSoftness",
        "EnvironmentDiffuseScale","EnvironmentSpecularScale","ClockTime",
        "OutdoorAmbient","Ambient","FogEnd","FogStart","FogColor",
        "ColorShift_Top","ColorShift_Bottom",
    }
    local function snapshotLighting()
        if _origLighting then return end
        _origLighting = {}
        for _, p in ipairs(LIGHTING_PROPS) do
            local ok, v = pcall(function() return Lighting[p] end)
            if ok then _origLighting[p] = v end
        end
        for _, c in ipairs(Lighting:GetChildren()) do
            if not c:GetAttribute("VS_Custom") then
                local ok, clone = pcall(function() return c:Clone() end)
                if ok and clone then table.insert(_origClones, clone) end
            end
        end
    end
    local function clearTagged()
        for _, c in ipairs(Lighting:GetChildren()) do
            if c:GetAttribute("VS_Custom") then c:Destroy() end
        end
    end
    local function restore()
        if not _origLighting then return end
        clearTagged()
        for k, v in pairs(_origLighting) do pcall(function() Lighting[k] = v end) end
        local exist = {}
        for _, c in ipairs(Lighting:GetChildren()) do exist[c.Name] = true end
        for _, clone in ipairs(_origClones) do
            if not exist[clone.Name] then clone:Clone().Parent = Lighting end
        end
    end
    local function fx(cls, props)
        local f = Instance.new(cls)
        f:SetAttribute("VS_Custom", true)
        for k, v in pairs(props) do f[k] = v end
        f.Parent = Lighting
        return f
    end
    local Presets = {}
    Presets.Neutral = function()
        clearTagged()
        Lighting.Brightness = 2; Lighting.ExposureCompensation = 0
        Lighting.GlobalShadows = false; Lighting.ShadowSoftness = 0.2
        Lighting.EnvironmentDiffuseScale = 0.5; Lighting.EnvironmentSpecularScale = 0.5
        Lighting.ClockTime = 14; Lighting.OutdoorAmbient = Color3.fromRGB(70,70,70)
        Lighting.Ambient = Color3.fromRGB(0,0,0); Lighting.FogEnd = 100000
        fx("Atmosphere", { Density=0.3, Offset=0.25, Color=Color3.fromRGB(199,199,199),
            Decay=Color3.fromRGB(106,112,125), Glare=0, Haze=0 })
    end
    Presets.Cyberpunk = function()
        clearTagged()
        Lighting.Brightness = 2.6; Lighting.ExposureCompensation = 0.5
        Lighting.GlobalShadows = false; Lighting.ShadowSoftness = 0.7
        Lighting.EnvironmentDiffuseScale = 0.7; Lighting.EnvironmentSpecularScale = 1
        Lighting.ClockTime = 0; Lighting.OutdoorAmbient = Color3.fromRGB(120,80,165)
        Lighting.Ambient = Color3.fromRGB(80,55,120)
        fx("Atmosphere", { Density=0.3, Offset=0.3, Color=Color3.fromRGB(160,70,215),
            Decay=Color3.fromRGB(75,200,240), Glare=2.2, Haze=1 })
        fx("BloomEffect", { Intensity=1.15, Size=24, Threshold=0.72 })
        fx("ColorCorrectionEffect", { Brightness=0.04, Contrast=0.2, Saturation=0.45,
            TintColor=Color3.fromRGB(220,195,255) })
    end
    Presets.Anime = function()
        clearTagged()
        Lighting.Brightness = 2.3; Lighting.ExposureCompensation = 0.2
        Lighting.GlobalShadows = false; Lighting.ShadowSoftness = 0.7
        Lighting.EnvironmentDiffuseScale = 0.7; Lighting.EnvironmentSpecularScale = 0.7
        Lighting.ClockTime = 15; Lighting.OutdoorAmbient = Color3.fromRGB(150,140,170)
        Lighting.Ambient = Color3.fromRGB(95,85,120)
        fx("Atmosphere", { Density=0.28, Offset=0.35, Color=Color3.fromRGB(255,200,230),
            Decay=Color3.fromRGB(150,195,255), Glare=1, Haze=0.8 })
        fx("BloomEffect", { Intensity=1.0, Size=26, Threshold=0.8 })
        fx("ColorCorrectionEffect", { Brightness=0.03, Contrast=0.14, Saturation=0.32,
            TintColor=Color3.fromRGB(255,228,242) })
    end
    Presets.Sunset = function()
        clearTagged()
        Lighting.Brightness = 2.3; Lighting.ExposureCompensation = 0.4
        Lighting.GlobalShadows = false; Lighting.ShadowSoftness = 0.5
        Lighting.EnvironmentDiffuseScale = 0.75; Lighting.EnvironmentSpecularScale = 0.9
        Lighting.ClockTime = 17.75; Lighting.OutdoorAmbient = Color3.fromRGB(185,115,80)
        Lighting.Ambient = Color3.fromRGB(105,60,45)
        fx("Atmosphere", { Density=0.38, Offset=0.55, Color=Color3.fromRGB(255,150,80),
            Decay=Color3.fromRGB(255,105,60), Glare=1.8, Haze=1.6 })
        fx("BloomEffect", { Intensity=0.9, Size=24, Threshold=0.78 })
        fx("ColorCorrectionEffect", { Brightness=0.03, Contrast=0.16, Saturation=0.32,
            TintColor=Color3.fromRGB(255,195,150) })
    end
    Presets.Vaporwave = function()
        clearTagged()
        Lighting.Brightness = 2.3; Lighting.ExposureCompensation = 0.4
        Lighting.GlobalShadows = false; Lighting.ShadowSoftness = 0.7
        Lighting.EnvironmentDiffuseScale = 0.6; Lighting.EnvironmentSpecularScale = 0.9
        Lighting.ClockTime = 18.4; Lighting.OutdoorAmbient = Color3.fromRGB(150,90,165)
        Lighting.Ambient = Color3.fromRGB(95,60,120)
        fx("Atmosphere", { Density=0.34, Offset=0.4, Color=Color3.fromRGB(255,130,205),
            Decay=Color3.fromRGB(110,200,255), Glare=1.8, Haze=1.3 })
        fx("BloomEffect", { Intensity=1.05, Size=26, Threshold=0.74 })
        fx("ColorCorrectionEffect", { Brightness=0.04, Contrast=0.18, Saturation=0.38,
            TintColor=Color3.fromRGB(255,205,240) })
    end
    Presets.Void = function()
        clearTagged()
        Lighting.Brightness = 2.0; Lighting.ExposureCompensation = 0.25
        Lighting.GlobalShadows = false; Lighting.ShadowSoftness = 0.9
        Lighting.EnvironmentDiffuseScale = 0.5; Lighting.EnvironmentSpecularScale = 0.7
        Lighting.ClockTime = 0; Lighting.OutdoorAmbient = Color3.fromRGB(85,95,135)
        Lighting.Ambient = Color3.fromRGB(55,62,95)
        fx("Atmosphere", { Density=0.35, Offset=0.2, Color=Color3.fromRGB(55,65,110),
            Decay=Color3.fromRGB(95,110,180), Glare=0.3, Haze=0.8 })
        fx("BloomEffect", { Intensity=0.8, Size=22, Threshold=0.76 })
        fx("ColorCorrectionEffect", { Brightness=0.03, Contrast=0.16, Saturation=-0.2,
            TintColor=Color3.fromRGB(190,200,255) })
    end
    Presets.Clarity = function()
        clearTagged()
        Lighting.Brightness = 2.6; Lighting.ExposureCompensation = 0
        Lighting.GlobalShadows = false; Lighting.ShadowSoftness = 1
        Lighting.EnvironmentDiffuseScale = 0.2; Lighting.EnvironmentSpecularScale = 0.1
        Lighting.ClockTime = 14; Lighting.OutdoorAmbient = Color3.fromRGB(150,150,155)
        Lighting.Ambient = Color3.fromRGB(120,120,125); Lighting.FogEnd = 1000000
        fx("ColorCorrectionEffect", { Brightness=0.05, Contrast=0.25, Saturation=-0.2,
            TintColor=Color3.fromRGB(255,255,255) })
    end
    Presets.Toxic = function()
        clearTagged()
        Lighting.Brightness = 2.2; Lighting.ExposureCompensation = 0.35
        Lighting.GlobalShadows = false; Lighting.ShadowSoftness = 0.7
        Lighting.EnvironmentDiffuseScale = 0.6; Lighting.EnvironmentSpecularScale = 0.8
        Lighting.ClockTime = 1; Lighting.OutdoorAmbient = Color3.fromRGB(80,135,70)
        Lighting.Ambient = Color3.fromRGB(45,85,50)
        fx("Atmosphere", { Density=0.34, Offset=0.35, Color=Color3.fromRGB(95,220,110),
            Decay=Color3.fromRGB(55,180,80), Glare=1.8, Haze=1.4 })
        fx("BloomEffect", { Intensity=1.1, Size=24, Threshold=0.74 })
        fx("ColorCorrectionEffect", { Brightness=0.04, Contrast=0.2, Saturation=0.45,
            TintColor=Color3.fromRGB(210,255,205) })
    end
    Presets.Sakura = function()
        clearTagged()
        Lighting.Brightness = 2.2; Lighting.ExposureCompensation = 0.35
        Lighting.GlobalShadows = false; Lighting.ShadowSoftness = 0.8
        Lighting.EnvironmentDiffuseScale = 0.7; Lighting.EnvironmentSpecularScale = 0.7
        Lighting.ClockTime = 15.5; Lighting.OutdoorAmbient = Color3.fromRGB(200,155,180)
        Lighting.Ambient = Color3.fromRGB(120,85,110)
        fx("Atmosphere", { Density=0.3, Offset=0.4, Color=Color3.fromRGB(255,205,225),
            Decay=Color3.fromRGB(255,175,215), Glare=1.2, Haze=1 })
        fx("BloomEffect", { Intensity=1.1, Size=26, Threshold=0.78 })
        fx("ColorCorrectionEffect", { Brightness=0.04, Contrast=0.15, Saturation=0.28,
            TintColor=Color3.fromRGB(255,225,240) })
    end
    Presets.Nebula = function()
        clearTagged()
        Lighting.Brightness = 2.2; Lighting.ExposureCompensation = 0.4
        Lighting.GlobalShadows = false; Lighting.ShadowSoftness = 0.9
        Lighting.EnvironmentDiffuseScale = 0.55; Lighting.EnvironmentSpecularScale = 0.85
        Lighting.ClockTime = 0; Lighting.OutdoorAmbient = Color3.fromRGB(128,94,168)
        Lighting.Ambient = Color3.fromRGB(82,60,120)
        fx("Atmosphere", { Density=0.34, Offset=0.25, Color=Color3.fromRGB(120,70,180),
            Decay=Color3.fromRGB(220,90,190), Glare=1.4, Haze=1.1 })
        fx("BloomEffect", { Intensity=1.15, Size=24, Threshold=0.72 })
        fx("ColorCorrectionEffect", { Brightness=0.03, Contrast=0.2, Saturation=0.4,
            TintColor=Color3.fromRGB(235,205,255) })
    end
    local PresetScalars = {
        Neutral   = { Brightness=2,   ExposureCompensation=0,    ClockTime=14,   OutdoorAmbient=Color3.fromRGB(70,70,70),
                      Ambient=Color3.fromRGB(0,0,0),      FogEnd=100000,
                      EnvironmentDiffuseScale=0.5,  EnvironmentSpecularScale=0.5 },
        Clarity   = { Brightness=2.6, ExposureCompensation=0,    ClockTime=14,   OutdoorAmbient=Color3.fromRGB(150,150,155),
                      Ambient=Color3.fromRGB(120,120,125), FogEnd=1000000,
                      EnvironmentDiffuseScale=0.2,  EnvironmentSpecularScale=0.1 },
        Cyberpunk = { Brightness=2.6, ExposureCompensation=0.5,  ClockTime=0,    OutdoorAmbient=Color3.fromRGB(120,80,165),
                      Ambient=Color3.fromRGB(80,55,120),
                      EnvironmentDiffuseScale=0.7,  EnvironmentSpecularScale=1 },
        Anime     = { Brightness=2.3, ExposureCompensation=0.2,  ClockTime=15,   OutdoorAmbient=Color3.fromRGB(150,140,170),
                      Ambient=Color3.fromRGB(95,85,120),
                      EnvironmentDiffuseScale=0.7,  EnvironmentSpecularScale=0.7 },
        Sunset    = { Brightness=2.3, ExposureCompensation=0.4,  ClockTime=17.75, OutdoorAmbient=Color3.fromRGB(185,115,80),
                      Ambient=Color3.fromRGB(105,60,45),
                      EnvironmentDiffuseScale=0.75, EnvironmentSpecularScale=0.9 },
        Vaporwave = { Brightness=2.3, ExposureCompensation=0.4,  ClockTime=18.4, OutdoorAmbient=Color3.fromRGB(150,90,165),
                      Ambient=Color3.fromRGB(95,60,120),
                      EnvironmentDiffuseScale=0.6,  EnvironmentSpecularScale=0.9 },
        Toxic     = { Brightness=2.2, ExposureCompensation=0.35, ClockTime=1,    OutdoorAmbient=Color3.fromRGB(80,135,70),
                      Ambient=Color3.fromRGB(45,85,50),
                      EnvironmentDiffuseScale=0.6,  EnvironmentSpecularScale=0.8 },
        Void      = { Brightness=2.0, ExposureCompensation=0.25, ClockTime=0,    OutdoorAmbient=Color3.fromRGB(85,95,135),
                      Ambient=Color3.fromRGB(55,62,95),
                      EnvironmentDiffuseScale=0.5,  EnvironmentSpecularScale=0.7 },
        Sakura    = { Brightness=2.2, ExposureCompensation=0.35, ClockTime=15.5, OutdoorAmbient=Color3.fromRGB(200,155,180),
                      Ambient=Color3.fromRGB(120,85,110),
                      EnvironmentDiffuseScale=0.7,  EnvironmentSpecularScale=0.7 },
        Nebula    = { Brightness=2.2, ExposureCompensation=0.4,  ClockTime=0,    OutdoorAmbient=Color3.fromRGB(128,94,168),
                      Ambient=Color3.fromRGB(82,60,120),
                      EnvironmentDiffuseScale=0.55, EnvironmentSpecularScale=0.85 },
    }
    local _WHITE = Color3.new(1, 1, 1)
    local function applyFullbrightOverride()
        if not Config.VisualsFullbright then return end
        pcall(function() if Lighting.Ambient ~= _WHITE then Lighting.Ambient = _WHITE end end)
        pcall(function() if Lighting.OutdoorAmbient ~= _WHITE then Lighting.OutdoorAmbient = _WHITE end end)
        pcall(function() if Lighting.GlobalShadows ~= false then Lighting.GlobalShadows = false end end)
        pcall(function() if Lighting.Brightness < 2 then Lighting.Brightness = 2 end end)
    end
    local function applyFogOverride()
        if not Config.VisualsNoFog then return end
        pcall(function() if Lighting.FogEnd ~= 1e6 then Lighting.FogEnd = 1e6 end end)
        pcall(function() if Lighting.FogStart ~= 1e6 then Lighting.FogStart = 1e6 end end)
        for _, c in ipairs(Lighting:GetChildren()) do
            if c:IsA("Atmosphere") then
                pcall(function() if c.Density ~= 0 then c.Density = 0 end end)
            end
        end
    end
    local function cfg(key, default)
        local v = Config[key]
        if v == nil then return default end
        return v
    end
    local _GRADES = {
        Crisp = { B = 0.03,  C = 0.20, S = 0.18,  tint = _WHITE },
        Cold  = { B = -0.03, C = 0.28, S = -0.22, tint = Color3.fromRGB(196, 220, 255) },
        Warm  = { B = 0.04,  C = 0.22, S = 0.15,  tint = Color3.fromRGB(255, 222, 180) },
        Comp  = { B = -0.01, C = 0.40, S = 0.28,  tint = Color3.fromRGB(255, 248, 236) },
    }
    local _gradeFx = nil
    local function getGradeFx()
        if _gradeFx and _gradeFx.Parent then return _gradeFx end
        local cc = Instance.new("ColorCorrectionEffect")
        cc.Name = "_vs_grade"
        cc:SetAttribute("VS_Grade", true)
        cc.Parent = Lighting
        _gradeFx = cc
        return cc
    end
    local function reassertGrade()
        local g = _GRADES[cfg("VisualsGrade", "None")]
        if not g then
            if _gradeFx and _gradeFx.Parent then
                pcall(function() if _gradeFx.Enabled then _gradeFx.Enabled = false end end)
            end
            return
        end
        local s  = math.clamp(cfg("VisualsGradeStrength", 1), 0, 1)
        local tB, tC, tS = g.B * s, g.C * s, g.S * s
        local tT = g.tint:Lerp(_WHITE, 1 - s)
        local cc = getGradeFx()
        pcall(function()
            if not cc.Enabled then cc.Enabled = true end
            if math.abs(cc.Brightness - tB) > 0.001 then cc.Brightness = tB end
            if math.abs(cc.Contrast   - tC) > 0.001 then cc.Contrast   = tC end
            if math.abs(cc.Saturation - tS) > 0.001 then cc.Saturation = tS end
            if cc.TintColor ~= tT then cc.TintColor = tT end
        end)
    end
    local function clearGrade()
        if _gradeFx then pcall(function() _gradeFx:Destroy() end); _gradeFx = nil end
    end
    local _bloomFx = nil
    local function getBloomFx()
        if _bloomFx and _bloomFx.Parent then return _bloomFx end
        local b = Instance.new("BloomEffect")
        b.Name = "_vs_bloom"; b:SetAttribute("VS_Bloom", true)
        b.Size = 24; b.Threshold = 0.8; b.Intensity = 0
        b.Parent = Lighting
        _bloomFx = b
        return b
    end
    local function reassertBloom()
        if not cfg("VisualsBloom", false) then
            if _bloomFx and _bloomFx.Parent then
                pcall(function() if _bloomFx.Enabled then _bloomFx.Enabled = false end end)
            end
            return
        end
        local tI = math.clamp(cfg("VisualsBloomIntensity", 1), 0, 3)
        local b = getBloomFx()
        pcall(function()
            if not b.Enabled then b.Enabled = true end
            if math.abs(b.Intensity - tI) > 0.01 then b.Intensity = tI end
        end)
    end
    local function clearBloom()
        if _bloomFx then pcall(function() _bloomFx:Destroy() end); _bloomFx = nil end
    end
    local function reassertScalars()
        local sc = PresetScalars[State.VisualsCurrentPreset or Config.VisualsPreset]
        if sc then
            for k, v in pairs(sc) do pcall(function() if Lighting[k] ~= v then Lighting[k] = v end end) end
            pcall(function() if Lighting.GlobalShadows ~= false then Lighting.GlobalShadows = false end end)
        end
        applyFullbrightOverride()
        applyFogOverride()
        reassertGrade()
        reassertBloom()
    end
    local function startReassert()
        if _reassertConn then return end
        _reassertConn = RunService.Heartbeat:Connect(function()
            if not Config.Visuals or Config.VisualsPerformanceMode then return end
            local now = tick()
            if (now - _reassertLastT) < 1.0 then return end
            _reassertLastT = now
            reassertScalars()
        end)
    end
    local function stopReassert()
        if _reassertConn then _reassertConn:Disconnect(); _reassertConn = nil end
    end
    Visuals.PresetOrder = { "Neutral", "Clarity", "Cyberpunk", "Anime", "Sunset", "Vaporwave", "Toxic", "Void", "Sakura", "Nebula" }
    local function applyPreset(name)
        if not Config.Visuals or Config.VisualsPerformanceMode then return end
        local fn = Presets[name]; if not fn then return end
        pcall(fn); State.VisualsCurrentPreset = name; Config.VisualsPreset = name
        reassertGrade()
        reassertBloom()
    end
    local function bindStretch()
        if _stretchBound then return end
        _stretchBound = true
        RunService:BindToRenderStep("VS_Stretch", Enum.RenderPriority.Last.Value, function()
            if not Config.Visuals then return end
            local s = Config.VisualsStretch
            local doStretch = math.abs(s - 1.0) >= 0.001
            local doSway = Config.VisualsCameraSway
            if not (doStretch or doSway) then return end
            local c = Camera.CFrame
            if doSway then
                local amt = math.clamp(Config.VisualsCameraSwayAmount or 0.5, 0, 1)
                local t = tick()
                local roll  = (math.sin(t * 0.9) + math.sin(t * 0.37) * 0.6) * amt
                local pitch =  math.sin(t * 1.3) * 0.7 * amt
                local yaw   =  math.sin(t * 0.7) * 0.8 * amt
                c = c * CFrame.Angles(math.rad(pitch), math.rad(yaw), math.rad(roll))
            end
            if doStretch then
                c = CFrame.fromMatrix(c.Position, c.RightVector * s, c.UpVector)
            end
            Camera.CFrame = c
        end)
    end
    local function startRainbow()
        if _rainbowConn then return end
        _rainbowBatchIdx = 1; table.clear(_rainbowParts)
        local charSet = {}
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl.Character then charSet[pl.Character] = true end
        end
        for _, d in ipairs(Workspace:GetDescendants()) do
            if d:IsA("BasePart") and not d:GetAttribute("VS_Holo")
                and not charSet[d.Parent]
                and d.Name ~= "Terrain" then
                table.insert(_rainbowParts, { part = d, originalColor = d.Color })
            end
        end
        _rainbowConn = RunService.Heartbeat:Connect(function(dt)
            if not Config.Visuals or not Config.VisualsRainbowMap then return end
            _rainbowHue = (_rainbowHue + dt * Config.VisualsRainbowMapSpeed) % 1
            local total = #_rainbowParts; if total == 0 then return end
            local batch = math.min(250, total)
            for i = 1, batch do
                local idx = ((_rainbowBatchIdx - 1 + i - 1) % total) + 1
                local e   = _rainbowParts[idx]
                if e and e.part and e.part.Parent then
                    e.part.Color = Color3.fromHSV((_rainbowHue + (idx / total) * 0.3) % 1, 0.85, 1)
                end
            end
            _rainbowBatchIdx = ((_rainbowBatchIdx + batch - 1) % total) + 1
        end)
    end
    local function stopRainbow()
        if _rainbowConn then _rainbowConn:Disconnect(); _rainbowConn = nil end
        for _, e in ipairs(_rainbowParts) do
            if e.part and e.part.Parent then pcall(function() e.part.Color = e.originalColor end) end
        end
        table.clear(_rainbowParts)
    end
    function Visuals.toggleRainbowMap(on)
        Config.VisualsRainbowMap = on
        if on and Config.Visuals then startRainbow() else stopRainbow() end
    end
    local function applyPerf()
        if not _perfBackup then
            _perfBackup = {
                GlobalShadows = Lighting.GlobalShadows,
                EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
                EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
                Brightness = Lighting.Brightness,
                ShadowSoftness = Lighting.ShadowSoftness,
            }
        end
        clearTagged(); clearGrade(); clearBloom()
        Lighting.GlobalShadows = false; Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0; Lighting.Brightness = 2
        Lighting.ShadowSoftness = 0
        for _, d in ipairs(Workspace:GetDescendants()) do
            if d:IsA("ParticleEmitter") and not d:GetAttribute("VS_Holo") then
                if not _origParticleRates[d] then _origParticleRates[d] = d.Rate end
                d.Rate = 0
            end
        end
    end
    local function disablePerf()
        if _perfBackup then
            for k, v in pairs(_perfBackup) do pcall(function() Lighting[k] = v end) end
            _perfBackup = nil
        end
        for em, rate in pairs(_origParticleRates) do
            if em and em.Parent then pcall(function() em.Rate = rate end) end
        end
        table.clear(_origParticleRates)
        if State.VisualsCurrentPreset then applyPreset(State.VisualsCurrentPreset) end
    end
    function Visuals.togglePerf(on)
        Config.VisualsPerformanceMode = on
        if on then applyPerf() else disablePerf() end
    end
    function Visuals.setPreset(name)
        if Presets[name] then
            Config.VisualsPreset = name
            applyPreset(name)
        end
    end
    Visuals.GradeOrder = { "None", "Crisp", "Cold", "Warm", "Comp" }
    function Visuals.setGrade(name)
        Config.VisualsGrade = name
        if not Config.Visuals or Config.VisualsPerformanceMode then return end
        reassertGrade()
    end
    function Visuals.setGradeStrength(v)
        Config.VisualsGradeStrength = math.clamp(v, 0, 1)
        if not Config.Visuals or Config.VisualsPerformanceMode then return end
        reassertGrade()
    end
    function Visuals.setBloom(on)
        Config.VisualsBloom = on
        if not Config.Visuals or Config.VisualsPerformanceMode then return end
        reassertBloom()
    end
    function Visuals.setBloomIntensity(v)
        Config.VisualsBloomIntensity = math.clamp(v, 0, 3)
        if not Config.Visuals or Config.VisualsPerformanceMode then return end
        reassertBloom()
    end
    function Visuals.toggleFullbright(on)
        Config.VisualsFullbright = on
        if not Config.Visuals or Config.VisualsPerformanceMode then return end
        if on then applyFullbrightOverride()
        else applyPreset(State.VisualsCurrentPreset or Config.VisualsPreset or "Neutral") end
    end
    function Visuals.toggleNoFog(on)
        Config.VisualsNoFog = on
        if not Config.Visuals or Config.VisualsPerformanceMode then return end
        if on then applyFogOverride()
        else applyPreset(State.VisualsCurrentPreset or Config.VisualsPreset or "Neutral") end
    end

    function Visuals.init()
        snapshotLighting()
        if Config.Visuals then bindStretch() end
    end
    function Visuals.enable()
        Config.Visuals = true; applyPreset(Config.VisualsPreset or "Neutral")
        if not Config.VisualsPerformanceMode then
            applyFullbrightOverride(); applyFogOverride()
        end
        bindStretch()
        if Config.VisualsRainbowMap then startRainbow() end
        if Config.VisualsPerformanceMode then applyPerf() end
        startReassert()
    end
    function Visuals.disable()
        Config.Visuals = false; stopRainbow(); stopReassert()
        clearGrade(); clearBloom()
        if Config.VisualsPerformanceMode then disablePerf() end
        if _stretchBound then
            pcall(function() RunService:UnbindFromRenderStep("VS_Stretch") end)
            _stretchBound = false
        end
        restore()
    end
end)()

Visuals.init()

-- ==========================================
-- VISUALS TAB UI 구성
-- ==========================================
local ESPGroup = Tabs.Visuals:AddLeftGroupbox('ESP Elements')
ESPGroup:AddToggle('ESPBox', { Text = 'Box ESP', Default = false })
ESPGroup:AddToggle('ESPName', { Text = 'Name ESP', Default = false })
ESPGroup:AddToggle('ESPHealth', { Text = 'Health ESP', Default = false })
ESPGroup:AddToggle('ESPDistance', { Text = 'Distance ESP', Default = false })
ESPGroup:AddToggle('ESPTracer', { Text = 'Tracer ESP', Default = false })
ESPGroup:AddToggle('ESPSkeleton', { Text = 'Skeleton ESP', Default = false })
ESPGroup:AddToggle('ESPChams', { Text = 'Chams ESP', Default = false })

local _3323x151 = false
local a41b78c88 = false

local IndicatorGroup = Tabs.Visuals:AddLeftGroupbox('Indicators')
IndicatorGroup:AddToggle('IndicatorRagebot', {
    Text = 'Ragebot Indicator',
    Default = false,
    Callback = function(Value) _3323x151 = Value end
})
IndicatorGroup:AddToggle('IndicatorAmmo', {
    Text = 'Ammo Indicator',
    Default = false,
    Callback = function(Value) a41b78c88 = Value end
})

local MasterGroup = Tabs.Visuals:AddRightGroupbox('Environment & Lighting')
MasterGroup:AddToggle('VisualsMasterToggle', {
    Text = 'Enable Custom Lighting',
    Default = false,
    Callback = function(Value)
        if Value then Visuals.enable() else Visuals.disable() end
    end
})
MasterGroup:AddDropdown('VisualsPresetDropdown', {
    Values = Visuals.PresetOrder,
    Default = 1,
    Text = 'Lighting Preset',
    Callback = function(Value) Visuals.setPreset(Value) end
})
MasterGroup:AddToggle('VisualsFullbrightToggle', {
    Text = 'Fullbright',
    Default = false,
    Callback = function(Value) Visuals.toggleFullbright(Value) end
})
MasterGroup:AddToggle('VisualsNoFogToggle', {
    Text = 'No Fog',
    Default = false,
    Callback = function(Value) Visuals.toggleNoFog(Value) end
})
MasterGroup:AddToggle('VisualsRainbowMapToggle', {
    Text = 'Rainbow Map',
    Default = false,
    Callback = function(Value) Visuals.toggleRainbowMap(Value) end
})
MasterGroup:AddToggle('VisualsPerformanceToggle', {
    Text = 'Performance Mode',
    Default = false,
    Callback = function(Value) Visuals.togglePerf(Value) end
})

local PostGroup = Tabs.Visuals:AddRightGroupbox('Post-Processing FX')
PostGroup:AddDropdown('VisualsGradeDropdown', {
    Values = Visuals.GradeOrder,
    Default = 2,
    Text = 'Color Grade Filter',
    Callback = function(Value) Visuals.setGrade(Value) end
})
PostGroup:AddSlider('VisualsGradeStrengthSlider', {
    Text = 'Grade Strength',
    Default = 0.6,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Callback = function(Value) Visuals.setGradeStrength(Value) end
})
PostGroup:AddToggle('VisualsBloomToggle', {
    Text = 'Custom Bloom Effect',
    Default = false,
    Callback = function(Value) Visuals.setBloom(Value) end
})
PostGroup:AddSlider('VisualsBloomIntensitySlider', {
    Text = 'Bloom Intensity',
    Default = 1.0,
    Min = 0,
    Max = 3,
    Rounding = 2,
    Callback = function(Value) Visuals.setBloomIntensity(Value) end
})

local CameraGroup = Tabs.Visuals:AddLeftGroupbox('Camera Effects')
CameraGroup:AddSlider('VisualsStretchSlider', {
    Text = 'Resolution Stretch',
    Default = 1.0,
    Min = 0.5,
    Max = 1.2,
    Rounding = 2,
    Callback = function(Value)
        Config.VisualsStretch = Value
    end
})
CameraGroup:AddToggle('VisualsSwayToggle', {
    Text = 'Motion Sway FX',
    Default = false,
    Callback = function(Value) Config.VisualsCameraSway = Value end
})

local SkyboxGroup = Tabs.Visuals:AddRightGroupbox('Legacy Skybox Presets')
local function GetSky()
    local sky = Lighting:FindFirstChildOfClass("Sky")
    if not sky then
        sky = Instance.new("Sky")
        sky.Parent = Lighting
    end
    return sky
end
local SkyPresets = {
    ["Purple Nebula"] = "rbxassetid://159454299",
    ["Night Sky"] = "rbxassetid://12064107",
    ["Pink Sunset"] = "rbxassetid://271042310",
    ["Vaporwave"] = "rbxassetid://1417494402"
}
local function ApplySky(id)
    local sky = GetSky()
    sky.SkyboxBk, sky.SkyboxDn, sky.SkyboxFt, sky.SkyboxLf, sky.SkyboxRt, sky.SkyboxUp = id, id, id, id, id, id
end
local function RemoveSky()
    local sky = Lighting:FindFirstChildOfClass("Sky")
    if sky then sky:Destroy() end
end
SkyboxGroup:AddDropdown('SkyboxPresetDropdown', {
    Values = { 'Disable', 'Purple Nebula', 'Night Sky', 'Pink Sunset', 'Vaporwave' },
    Default = 1,
    Text = 'Presets',
    Callback = function(Value)
        if Value == 'Disable' then RemoveSky() elseif SkyPresets[Value] then ApplySky(SkyPresets[Value]) end
    end
})

-- ==========================================
-- Weather 기능 구현 및 Visuals 탭에 Weather 그룹박스 추가
-- ==========================================
local Weather = {}
;(function()
    local function cfg(key, default)
        local v = Config[key]
        if v == nil then return default end
        return v
    end
    local function iAmt()
        return math.clamp(cfg("WeatherIntensity", 1), 0.15, 2)
    end
    local function iRate(I, kLo, kHi)
        if I < 1 then return math.exp(kLo * (I - 1)) end
        return math.exp(kHi * (I - 1))
    end
    local function evRate(key)
        return math.clamp(cfg(key, 1), 0.25, 3)
    end
    local IR = {
        Snow      = { lo = 1.75, hi = 0.85, acc = 0.45, sz = 0.08, alp = 0.35, gst = 0.30 },
        Petals    = { lo = 1.75, hi = 0.85, acc = 0.40, sz = 0.08, alp = 0.30, gst = 0.30 },
        Autumn    = { lo = 1.75, hi = 0.85, acc = 0.40, sz = 0.08, alp = 0.30, gst = 0.30 },
        Mist      = { lo = 1.35, hi = 1.10, acc = 0.30, sz = 0.25, alp = 0.75, gst = 0.20 },
        Ash       = { lo = 1.45, hi = 1.05, acc = 0.35, sz = 0.15, alp = 0.55, gst = 0.20 },
        Sandstorm = { lo = 1.35, hi = 1.60, acc = 0.45, sz = 0.30, alp = 0.75, gst = 0.20 },
        Embers    = { lo = 1.45, hi = 1.05, acc = 0.30, sz = 0.10, alp = 0.25, gst = 0.20 },
        Fireflies = { lo = 1.45, hi = 1.00, acc = 0.10, sz = 0.08, alp = 0.20, gst = 0.15 },
    }
    local IR_DEF = { lo = 1.6, hi = 0.9, acc = 0.3, sz = 0.10, alp = 0.25, gst = 0.25 }
    local SET_LO, SET_HI = 0.75, 0.45
    local Vec   = Vector3.new
    local WHITE = Color3.new(1, 1, 1)
    local TX_SOFT  = "rbxasset://textures/particles/smoke_main.dds"
    local TX_SPARK = "rbxasset://textures/particles/sparkles_main.dds"
    local TX_FLAKE    = "rbxassetid://101749163393113"
    local TX_SNOWSOFT = "rbxassetid://78582616787441"
    local TX_PUFF     = "rbxassetid://77935321198144"
    local TX_PETAL    = "rbxassetid://243344623"
    local TX_LEAFA    = "rbxassetid://8590047664"
    local TX_LEAFB    = "rbxassetid://5970677338"
    local TX_LEAFC    = "rbxassetid://9239040931"
    local TX_DUST     = "rbxassetid://341828512"
    local _curType = nil
    local Wind = { x = 0, z = 0 }
    ;(function()
        local baseAng = math.random() * 6.283
        local gustT0, gustDur, gustAmp = 0, 1, 0
        local nextGustT = math.huge
        local cbs = {}
        function Wind.onGust(fn) cbs[#cbs + 1] = fn end
        function Wind.reset(now)
            nextGustT = now + 8 + math.random() * 17
            gustT0, gustAmp = 0, 0
            Wind.x, Wind.z = 0, 0
        end
        function Wind.update(now)
            if now >= nextGustT then
                gustT0 = now
                gustDur = 2 + math.random() * 2
                gustAmp = 1 + math.random()
                nextGustT = now + 8 + math.random() * 17
                for i = 1, #cbs do pcall(cbs[i], gustDur, 1 + gustAmp) end
            end
            local ang = baseAng + 0.6 * math.sin(now * 0.013) + 0.9 * math.sin(now * 0.031 + 2.6)
            local str = 1 + 0.35 * math.sin(now * 0.17) + 0.22 * math.sin(now * 0.41 + 1.3) + 0.15 * math.sin(now * 0.07 + 4.1)
            local ga = (now - gustT0) / gustDur
            if gustAmp > 0 and ga < 1 then str = str * (1 + gustAmp * math.sin(ga * math.pi)) end
            Wind.x = math.cos(ang) * str
            Wind.z = math.sin(ang) * str
        end
    end)()
    local _folder = nil
    local function getFolder()
        if _folder and _folder.Parent then return _folder end
        local f = Instance.new("Folder"); f.Name = "_wx"; f:SetAttribute("WX_Custom", true)
        f.Parent = Workspace; _folder = f; return f
    end
    local _rain = { drops = {}, conn = nil, folder = nil, dir = nil, applied = nil }
    local RAIN_DIR = Vec(-0.16, -1, 0.05).Unit
    local RAIN_LEAN_K, RAIN_LEAN_MAX = 0.12, 0.2126
    local RAIN_RADIUS, RAIN_TOP, RAIN_BOT, RAIN_MAX = 70, 70, -28, 420
    local function rainFolder()
        if _rain.folder and _rain.folder.Parent then return _rain.folder end
        local f = Instance.new("Folder"); f.Name = "_wxRain"; f:SetAttribute("WX_Custom", true)
        f.Parent = getFolder(); _rain.folder = f; return f
    end
    local function makeDrop(parent, streakLen, width, color, glow, transp)
        local part = Instance.new("Part")
        part.Anchored = true; part.CanCollide = false; part.CanQuery = false; part.CanTouch = false
        part.CastShadow = false; part.Massless = true; part.Transparency = 1; part.Size = Vec(0.05,0.05,0.05)
        part:SetAttribute("WX_Custom", true)
        local a0 = Instance.new("Attachment"); a0.Parent = part
        local a1 = Instance.new("Attachment"); a1.Position = _rain.dir * streakLen; a1.Parent = part
        local beam = Instance.new("Beam")
        beam.Attachment0 = a0; beam.Attachment1 = a1
        beam.Segments = 1; beam.FaceCamera = true
        beam.Width0 = width; beam.Width1 = width * 0.55
        beam.LightEmission = glow and 1 or 0.35
        beam.LightInfluence = 0
        beam.Color = ColorSequence.new(color)
        beam.Transparency = NumberSequence.new(transp)
        beam.Parent = part
        part.Parent = parent
        return part, a1, beam
    end
    local function seedDrop(d, camPos)
        local ang = math.random() * math.pi * 2
        local rad = math.sqrt(math.random()) * RAIN_RADIUS
        local y   = camPos.Y + RAIN_TOP - math.random() * (RAIN_TOP - RAIN_BOT)
        d.pos = Vec(camPos.X + math.cos(ang) * rad, y, camPos.Z + math.sin(ang) * rad)
    end
    local function newDrop(folder, i, camPos)
        local base, width, color, transp, spd0
        if (i % 3) ~= 0 then
            base, width, transp = 5 + math.random() * 3, 0.10, 0.22
            spd0 = 150 + math.random() * 30; color = Color3.fromRGB(180, 202, 232)
        else
            base, width, transp = 3 + math.random() * 2, 0.06, 0.55
            spd0 = 120 + math.random() * 30; color = Color3.fromRGB(158, 182, 214)
        end
        local part, a1, beam = makeDrop(folder, base, width, color, false, transp)
        local d = { part = part, a1 = a1, beam = beam, base = base, len = base, w0 = width, t0 = transp, spd0 = spd0, spd = spd0 }
        seedDrop(d, camPos)
        part.CFrame = CFrame.new(d.pos)
        return d
    end
    local function tuneRain()
        local folder = rainFolder()
        local I = iAmt()
        local n = math.clamp(math.floor(150 * iRate(I, 1.75, 0.85)), 16, RAIN_MAX)
        local drops = _rain.drops
        local camPos = Camera and Camera.CFrame.Position or Vec(0,0,0)
        for i = #drops, n + 1, -1 do drops[i].part:Destroy(); drops[i] = nil end
        for i = #drops + 1, n do drops[i] = newDrop(folder, i, camPos) end
    end
    local function startRain()
        if _rain.conn then return end
        _rain.conn = RunService.Heartbeat:Connect(function(dt)
            if not Config.Weather or _curType ~= "Rain" then return end
            local cam = Camera; if not cam then return end
            local camPos = cam.CFrame.Position
            local lx, lz = Wind.x * RAIN_LEAN_K, Wind.z * RAIN_LEAN_K
            local lm = math.sqrt(lx * lx + lz * lz)
            if lm > RAIN_LEAN_MAX then local s = RAIN_LEAN_MAX / lm; lx, lz = lx * s, lz * s end
            local step = _rain.dir:Lerp(Vec(lx, -1, lz).Unit, math.min(dt * 2, 1)).Unit
            _rain.dir = step
            if (step - _rain.applied).Magnitude > 0.015 then
                _rain.applied = step
                for i = 1, #_rain.drops do _rain.drops[i].a1.Position = step * _rain.drops[i].len end
            end
            local r2 = RAIN_RADIUS * RAIN_RADIUS
            for i = 1, #_rain.drops do
                local d = _rain.drops[i]
                local p = d.pos + step * (d.spd * dt)
                local relX, relY, relZ = p.X - camPos.X, p.Y - camPos.Y, p.Z - camPos.Z
                if relY < RAIN_BOT or (relX * relX + relZ * relZ) > r2 then seedDrop(d, camPos); p = d.pos end
                d.pos = p
                if d.part then d.part.CFrame = CFrame.new(p) end
            end
        end)
    end
    local function stopRain()
        if _rain.conn then _rain.conn:Disconnect(); _rain.conn = nil end
        if _rain.folder then pcall(function() _rain.folder:Destroy() end); _rain.folder = nil end
        table.clear(_rain.drops); _rain.dir = nil; _rain.applied = nil
    end

    local ND = Enum.NormalId
    local function flutterSeq(lo, hi, n, env, flip)
        local kps = table.create(n + 1)
        for i = 0, n do
            local v = lo; if (i + flip) % 2 == 1 then v = hi end
            kps[i + 1] = NumberSequenceKeypoint.new(i / n, v, env)
        end
        return NumberSequence.new(kps)
    end

    local PRESETS = {
        Snow = {
            { size=Vec(22,4,22), oy=5, tex=TX_FLAKE, color=WHITE, skeys={{0,1.7,0.35},{1,1.35,0.3}}, squash=-0.12, transp0=0.18,transp1=0.55, rate=0.7, speed={0.8,1.6}, life={5,7}, spread=28, rot={-60,60}, rotSpd=26, accel=Vec(0,-2.4,0), drag=2.2, glow=0.2, dir=ND.Bottom, gust={ax=1.8,az=1.2,wx=0.4,wz=0.31,ph=0.5} },
            { size=Vec(140,4,140), oy=20, tex=TX_FLAKE, color=Color3.fromRGB(242,248,255), skeys={{0,0.5,0.2},{1,0.38,0.14}}, squash=-0.08, transp0=0.08,transp1=0.5, rate=190, speed={2,4}, life={7,10}, spread=50, rot={-180,180}, rotSpd=42, accel=Vec(0,-5,0), drag=1.7, glow=0.35, dir=ND.Bottom, gust={ax=2.2,az=1.4,wx=0.33,wz=0.26,ph=1.9} },
        },
        Mist = {
            { size=Vec(150,8,150), oy=0, tex=TX_SOFT, color=Color3.fromRGB(210,216,226), size0=26,size1=44, transp0=0.68,transp1=0.94, rate=16, speed={0.8,2.2}, life={9,13}, spread=20, rot={-5,5}, rotSpd=3, accel=Vec(2.2,0.25,1.2), drag=0.8, dir=ND.Top },
        },
        Embers = {
            { size=Vec(90,28,90), oy=2, tex=TX_SOFT, color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,170,60)),ColorSequenceKeypoint.new(1,Color3.fromRGB(165,35,12))}), size0=0.85,size1=0.3, transp0=0.05,transp1=0.85, rate=80, speed={3,7}, life={3,5}, spread=40, rot={-60,60}, rotSpd=90, accel=Vec(1.5,9,1), drag=1.6, glow=0.35, dir=ND.Top },
        },
        Fireflies = {
            { size=Vec(70,8,70), oy=-2, tex=TX_SNOWSOFT, color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(220,255,130)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,200,80))}), skeys={{0,0.1},{0.08,0.62,0.15},{1,0.08}}, tkeys={{0,1},{0.08,0.08},{1,1}}, rate=18, speed={0.5,1.6}, life={2.5,4}, spread=180, rot={0,0}, rotSpd=0, accel=Vec(0,0.3,0), drag=2.5, glow=0.95, dir=ND.Top },
        },
        Petals = {
            { size=Vec(64,12,64), oy=5, tex=TX_PETAL, color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,222,234)),ColorSequenceKeypoint.new(1,Color3.fromRGB(226,132,176))}), skeys={{0,2.05,0.5},{1,1.7,0.35}}, qseq=flutterSeq(-0.88, 0.08, 14, 0.12, 0), transp0=0.1,transp1=0.38, rate=13, speed={0.6,1.4}, life={6,8}, spread=35, rot={-180,180}, rotSpd=95, accel=Vec(0,-3.5,0), drag=1.6, glow=0.08, dir=ND.Bottom, gust={ax=2.6,az=1.8,wx=0.4,wz=0.31,ph=0.5} },
        },
        Autumn = {
            { size=Vec(20,6,20), oy=13, uw=8, tex=TX_LEAFA, color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(226,190,128)),ColorSequenceKeypoint.new(1,Color3.fromRGB(190,132,62))}), skeys={{0,0.62,0.14},{1,0.54,0.10}}, qseq=flutterSeq(-0.60, 0.14, 13, 0.10, 0), transp0=0.08,transp1=0.42, rate=14, speed={0.6,1.6}, life={7,9}, spread=34, rot={-180,180}, rotSpd=130, accel=Vec(0,-5,0), drag=1.5, glow=0.62, dir=ND.Bottom, gust={ax=3.4,az=2.2,wx=0.41,wz=0.3,ph=0.5} },
        },
        Ash = {
            { size=Vec(110,4,110), oy=16, tex=TX_SOFT, color=Color3.fromRGB(96,90,86), size0=0.4,size1=0.3, transp0=0.05,transp1=0.5, rate=140, speed={2,4}, life={6,9}, spread=45, rot={-60,60}, rotSpd=45, accel=Vec(-3.5,-5,2), drag=1.6, glow=0, dir=ND.Bottom },
        },
        Sandstorm = {
            { size=Vec(160,20,160), oy=6, tex=TX_SOFT, color=Color3.fromRGB(194,168,120), size0=24,size1=38, transp0=0.58,transp1=0.93, rate=24, speed={8,15}, life={5,8}, spread=28, rot={-8,8}, rotSpd=6, accel=Vec(20,0.5,7), drag=0.6, dir=ND.Right },
        },
    }
    Weather.TypeOrder = { "Rain", "Snow", "Mist", "Embers", "Fireflies", "Petals", "Autumn", "Ash", "Sandstorm" }

    local MOOD = {
        Rain      = { B=-0.03, C=0.08,  S=-0.12, tint=Color3.fromRGB(205,220,255) },
        Snow      = { B= 0.03, C=0.05,  S=-0.08, tint=Color3.fromRGB(226,240,255) },
        Mist      = { B=-0.01, C=-0.05, S=-0.20, tint=Color3.fromRGB(220,224,230) },
        Embers    = { B= 0.02, C=0.08,  S= 0.10, tint=Color3.fromRGB(255,238,220) },
        Fireflies = { B=-0.04, C=0.06,  S= 0.02, tint=Color3.fromRGB(238,228,205) },
        Petals    = { B= 0.00, C=0.09,  S= 0.05, tint=Color3.fromRGB(255,234,234) },
        Autumn    = { B= 0.005, C=0.08, S= 0.04, tint=Color3.fromRGB(253,244,232) },
        Ash       = { B=-0.04, C=0.06,  S=-0.25, tint=Color3.fromRGB(225,220,215) },
        Sandstorm = { B=-0.02, C=0.10,  S= 0.05, tint=Color3.fromRGB(224,196,150) },
    }
    local SOUND = { Rain="rbxassetid://9114223173", Snow="rbxassetid://9114223173" }
    local _partLayers = {}
    local _ambient = nil
    local _moodCC = nil
    local _moodTween = nil
    local FADE_TI = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    local MOOD_TI = TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    local _followConn = nil

    local function clearPartLayers()
        for _, L in ipairs(_partLayers) do
            if L.rateTween then L.rateTween:Cancel() end
            if L.host then pcall(function() L.host:Destroy() end) end
        end
        table.clear(_partLayers)
    end
    local _fadeLayers = {}
    local _fadeToken = 0
    local function killFade()
        _fadeToken = _fadeToken + 1
        for _, F in ipairs(_fadeLayers) do pcall(function() F.host:Destroy() end) end
        table.clear(_fadeLayers)
    end
    local function beginLayerFade()
        killFade()
        local maxLife = 0
        for _, L in ipairs(_partLayers) do
            if L.rateTween then L.rateTween:Cancel() end
            if L.emitter then TweenService:Create(L.emitter, FADE_TI, { Rate = 0 }):Play() end
            if L.life2 > maxLife then maxLife = L.life2 end
            table.insert(_fadeLayers, { host = L.host, oy = L.oy })
        end
        table.clear(_partLayers)
    end
    local function layerRate(L, I)
        return L.spec.rate * iRate(I, L.ir.lo, L.ir.hi)
    end
    local function tuneLayer(L, I)
        local spec, R, e = L.spec, L.ir, L.emitter
        local am = 1 - R.acc + R.acc * I
        L.accel = spec.accel * am
        e.Acceleration = L.accel
        e.Speed = NumberRange.new(spec.speed[1] * am, spec.speed[2] * am)
    end
    local function mkPartLayer(spec, ir, rampIn)
        local host = Instance.new("Part")
        host.Name = "_wxHost"; host.Anchored = true; host.CanCollide = false; host.CanQuery = false
        host.CanTouch = false; host.CastShadow = false; host.Transparency = 1; host.Massless = true
        host.Size = spec.size; host:SetAttribute("WX_Custom", true)
        host.Parent = getFolder()
        local e = Instance.new("ParticleEmitter")
        e:SetAttribute("WX_Custom", true)
        e.Texture = spec.tex
        e.Color = ColorSequence.new(spec.color)
        e.LightEmission = spec.glow or 0
        e.LightInfluence = 1 - math.min(spec.glow or 0, 1)
        e.Lifetime = NumberRange.new(spec.life[1], spec.life[2])
        e.SpreadAngle = Vector2.new(spec.spread, spec.spread)
        e.Rotation = NumberRange.new(spec.rot and spec.rot[1] or 0, spec.rot and spec.rot[2] or 360)
        e.RotSpeed = NumberRange.new(-(spec.rotSpd or 45), spec.rotSpd or 45)
        e.Squash = NumberSequence.new(spec.squash or 0)
        e.Drag = spec.drag or 0
        e.EmissionDirection = spec.dir
        e.Parent = host
        local L = { host = host, oy = spec.oy, emitter = e, spec = spec, ir = ir, accel = spec.accel, life2 = spec.life[2], rateTween = nil }
        local I = iAmt()
        tuneLayer(L, I)
        local targetRate = layerRate(L, I)
        if rampIn then
            e.Rate = 0
            L.rateTween = TweenService:Create(e, FADE_TI, { Rate = targetRate })
            L.rateTween:Play()
        else
            e.Rate = targetRate
        end
        table.insert(_partLayers, L)
    end
    local function clearMood()
        if _moodTween then _moodTween:Cancel(); _moodTween = nil end
        if _moodCC then pcall(function() _moodCC:Destroy() end); _moodCC = nil end
    end
    local function applyMood(name)
        if not cfg("WeatherMood", true) then clearMood(); return end
        local m = MOOD[name]; if not m then clearMood(); return end
        if _moodTween then _moodTween:Cancel(); _moodTween = nil end
        local g = 0.6 + 0.4 * iAmt()
        local cc = _moodCC
        if cc and cc.Parent then
            _moodTween = TweenService:Create(cc, MOOD_TI, { Brightness = m.B * g, Contrast = m.C * g, Saturation = m.S * g, TintColor = m.tint })
            _moodTween:Play()
            return
        end
        cc = Instance.new("ColorCorrectionEffect")
        cc.Name = "_wxMood"; cc:SetAttribute("WX_Custom", true)
        cc.Brightness = m.B * g; cc.Contrast = m.C * g; cc.Saturation = m.S * g; cc.TintColor = m.tint
        cc.Parent = Lighting; _moodCC = cc
    end
    local function startAmbient(id)
        if _ambient then pcall(function() _ambient:Destroy() end); _ambient = nil end
        if not id or id == "" then return end
        local s = Instance.new("Sound")
        s.Name = "_wxAmb"; s:SetAttribute("WX_Custom", true)
        s.SoundId = id; s.Looped = true; s.Volume = cfg("WeatherSoundVolume", 0.35)
        s.Parent = SoundService
        pcall(function() s:Play() end)
        _ambient = s
    end
    local function startFollow()
        if _followConn then return end
        local now0 = tick(); Wind.reset(now0)
        _followConn = RunService.Heartbeat:Connect(function()
            if not Config.Weather then return end
            local now = tick(); Wind.update(now)
            if _ambient then
                local vol = cfg("WeatherSoundVolume", 0.35)
                if _ambient.Volume ~= vol then _ambient.Volume = vol end
            end
            local cam = Camera; if not cam then return end
            local pos = cam.CFrame.Position
            for _, L in ipairs(_partLayers) do
                if L.host and L.host.Parent then L.host.CFrame = CFrame.new(pos.X, pos.Y + L.oy, pos.Z) end
            end
            for _, F in ipairs(_fadeLayers) do
                if F.host and F.host.Parent then F.host.CFrame = CFrame.new(pos.X, pos.Y + F.oy, pos.Z) end
            end
        end)
    end
    local function stopFollow()
        if _followConn then _followConn:Disconnect(); _followConn = nil end
    end
    local function normType(name)
        if PRESETS[name] or name == "Rain" then return name end
        return "Rain"
    end
    local function applyType(name)
        name = normType(name)
        local prev = _curType
        stopRain()
        if #_partLayers > 0 then beginLayerFade() end
        _curType = name
        if name == "Rain" then buildRain(); startRain()
        else
            local ramp = PRESETS[prev] ~= nil
            local ir = IR[name] or IR_DEF
            if PRESETS[name] then
                for _, spec in ipairs(PRESETS[name]) do mkPartLayer(spec, ir, ramp) end
            end
        end
        applyMood(name)
        startAmbient(SOUND[name])
    end
    function Weather.setType(name)
        name = normType(name)
        Config.WeatherType = name
        if Config.Weather then applyType(name) end
    end
    function Weather.setIntensity(v)
        Config.WeatherIntensity = math.clamp(v, 0.15, 2)
        if not Config.Weather then return end
        local I = Config.WeatherIntensity
        for _, L in ipairs(_partLayers) do
            if L.emitter then
                pcall(tuneLayer, L, I)
                if L.rateTween then L.rateTween:Cancel(); L.rateTween = nil end
                pcall(function() L.emitter.Rate = layerRate(L, I) end)
            end
        end
        if _curType == "Rain" then pcall(tuneRain) end
        if _curType then pcall(applyMood, _curType) end
    end
    function Weather.setVolume(v)
        Config.WeatherSoundVolume = v
        if _ambient then pcall(function() _ambient.Volume = v end) end
    end
    function Weather.toggleMood(on)
        Config.WeatherMood = on
        if Config.Weather and _curType then
            if on then applyMood(_curType) else clearMood() end
        end
    end
    function Weather.toggleStorm(on) Config.WeatherStorm = on end
    function Weather.toggleSkyFlash(on) Config.WeatherStormFlash = on end
    function Weather.toggleMeteors(on) Config.WeatherMeteors = on end
    function Weather.setMeteorsRate(v) Config.WeatherMeteorRate = v end
    function Weather.toggleShootingStars(on) Config.WeatherShootingStars = on end
    function Weather.setStarsRate(v) Config.WeatherStarRate = v end
    function Weather.toggleCelestial(on) Config.SkyboxHideCelestial = on end
    function Weather.toggleGodRays(on) Config.WeatherGodRays = on end
    function Weather.toggleRainbow(on) Config.WeatherRainbow = on end
    function Weather.togglePuddles(on) Config.WeatherPuddles = on end
    function Weather.toggleClock(on) Config.WeatherClockDial = on end

    function Weather.enableWeather()
        Config.Weather = true
        getFolder(); startFollow()
        applyType(cfg("WeatherType", "Rain"))
    end
    function Weather.disableWeather()
        Config.Weather = false
        stopFollow(); stopRain(); clearPartLayers(); killFade(); clearMood()
        if _ambient then pcall(function() _ambient:Destroy() end); _ambient = nil end
        _curType = nil
    end

    function Weather.setSkybox(preset)
        Config.SkyboxPreset = preset
        local sky = Lighting:FindFirstChildOfClass("Sky")
        if preset == "Off" then
            if sky then sky:Destroy() end
        else
            if not sky then sky = Instance.new("Sky"); sky.Parent = Lighting end
            if SkyPresets[preset] then ApplySky(SkyPresets[preset]) end
        end
    end

    function Weather.init()
        if Config.Weather then pcall(Weather.enableWeather) end
        if Config.SkyboxPreset and Config.SkyboxPreset ~= "Off" then pcall(Weather.setSkybox, Config.SkyboxPreset) end
    end
    function Weather.unload()
        pcall(Weather.disableWeather)
        if _folder then pcall(function() _folder:Destroy() end); _folder = nil end
    end
end)()

Weather.init()

-- ==========================================
-- Visuals 탭에 Weather 그룹박스 추가
-- ==========================================
local WX = Tabs.Visuals:AddLeftGroupbox('Weather System')

WX:AddToggle('Weather', { Text='Enable Weather', Default=(Config.Weather or false),
    Callback=function(v) if v then Weather.enableWeather() else Weather.disableWeather() end end })

local wxDep = WX:AddDependencyBox()
wxDep:AddDropdown('WeatherType', { Values={'Rain','Snow','Petals','Autumn','Mist','Ash','Sandstorm','Embers','Fireflies'},
    Default=(Config.WeatherType or 'Rain'), Text='Precipitation',
    Callback=function(v) Weather.setType(v) end })
wxDep:AddSlider('WeatherIntensity', { Text='Intensity', Default=(Config.WeatherIntensity or 1.0),
    Min=0.15, Max=2, Rounding=2, Suffix='x',
    Callback=function(v) Weather.setIntensity(v) end })
wxDep:AddSlider('WeatherSoundVolume', { Text='Volume', Default=(Config.WeatherSoundVolume or 0.35),
    Min=0, Max=1, Rounding=2,
    Callback=function(v) Weather.setVolume(v) end })
wxDep:AddToggle('WeatherMood', { Text='Mood tint', Default=(Config.WeatherMood or true),
    Callback=function(v) Weather.toggleMood(v) end })
wxDep:AddDivider('Atmosphere')
wxDep:AddToggle('WeatherStorm', { Text='Storm & lightning', Default=(Config.WeatherStorm or false),
    Callback=function(v) Weather.toggleStorm(v) end })

local stormDep = wxDep:AddDependencyBox()
stormDep:AddToggle('WeatherStormFlash', { Text='Sky flash', Default=(Config.WeatherStormFlash or true),
    Callback=function(v) Weather.toggleSkyFlash(v) end })
stormDep:SetupDependencies({ { Toggles.WeatherStorm, true } })

wxDep:AddToggle('WeatherMeteors', { Text='Meteors', Default=(Config.WeatherMeteors or false),
    Callback=function(v) Weather.toggleMeteors(v) end })
local metDep = wxDep:AddDependencyBox()
metDep:AddSlider('WeatherMeteorRate', { Text='Rate', Default=(Config.WeatherMeteorRate or 1.0),
    Min=0.25, Max=3, Rounding=2, Suffix='x', Compact=true,
    Callback=function(v) Weather.setMeteorsRate(v) end })
metDep:SetupDependencies({ { Toggles.WeatherMeteors, true } })

wxDep:AddToggle('WeatherShootingStars', { Text='Shooting stars', Default=(Config.WeatherShootingStars or false),
    Callback=function(v) Weather.toggleShootingStars(v) end })
local starDep = wxDep:AddDependencyBox()
starDep:AddSlider('WeatherStarRate', { Text='Rate', Default=(Config.WeatherStarRate or 1.0),
    Min=0.25, Max=3, Rounding=2, Suffix='x', Compact=true,
    Callback=function(v) Weather.setStarsRate(v) end })
starDep:SetupDependencies({ { Toggles.WeatherShootingStars, true } })

wxDep:AddDropdown('SkyboxPreset', { Values={'Off', 'Purple Nebula', 'Night Sky', 'Pink Sunset', 'Vaporwave'},
    Default=(Config.SkyboxPreset or 'Off'), Text='Skybox',
    Callback=function(v) Weather.setSkybox(v) end })
wxDep:AddToggle('SkyboxHideCelestial', { Text='Hide celestial', Default=(Config.SkyboxHideCelestial or false),
    Callback=function(v) Weather.toggleCelestial(v) end })
wxDep:AddToggle('WeatherGodRays', { Text='God rays', Default=(Config.WeatherGodRays or false),
    Callback=function(v) Weather.toggleGodRays(v) end })
wxDep:AddToggle('WeatherRainbow', { Text='Rainbow', Default=(Config.WeatherRainbow or false),
    Callback=function(v) Weather.toggleRainbow(v) end })
wxDep:AddToggle('WeatherPuddles', { Text='Puddles', Default=(Config.WeatherPuddles or false),
    Callback=function(v) Weather.togglePuddles(v) end })
wxDep:AddToggle('WeatherClockDial', { Text='Clock dial', Default=(Config.WeatherClockDial or false),
    Callback=function(v) Weather.toggleClock(v) end })
wxDep:SetupDependencies({ { Toggles.Weather, true } })

-- ==========================================
-- Character 탭 (Emote)
-- ==========================================
local EmoteGroup = Tabs.Character:AddLeftGroupbox('Emote')
local EmoteEnabled = false
local emoteTrack = nil
local EMOTESPEED = 1
local EMOTES = {
    "rbxassetid://507771019",
    "rbxassetid://507776043",
    "rbxassetid://507777623",
    "rbxassetid://3698339488",
    "rbxassetid://92281817840531",
}
local function stopEmote()
    EmoteEnabled = false
    if emoteTrack then pcall(function() emoteTrack:Stop() end); emoteTrack = nil end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then pcall(function() for _, t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end) end
end
local function playEmote(char)
    if not EmoteEnabled then return end
    char = char or LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 3)
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)
    for _, id in ipairs(EMOTES) do
        local ok, track = pcall(function()
            local a = Instance.new("Animation"); a.AnimationId = id
            local t = animator:LoadAnimation(a)
            t.Priority = Enum.AnimationPriority.Action4; t.Looped = true
            t:Play(0.1, 1, EMOTESPEED)
            return t
        end)
        if ok and track then
            emoteTrack = track
            track.Stopped:Connect(function() if EmoteEnabled then task.defer(function() playEmote(char) end) end end)
            return
        end
    end
end
LocalPlayer.CharacterAdded:Connect(function(char)
    if EmoteEnabled then task.delay(0.5, function() if EmoteEnabled then playEmote(char) end end) end
end)
EmoteGroup:AddToggle('EnableEmoteSpeed', {
    Text = 'Enable Fast Emote', Default = false,
    Callback = function(Value)
        if Value then EmoteEnabled = true; playEmote(LocalPlayer.Character) else stopEmote() end
    end
})
EmoteGroup:AddSlider('EmoteSpeedSlider', {
    Text = 'Emote', Default = 1, Min = 1, Max = 1000, Rounding = 0,
    Callback = function(Value)
        EMOTESPEED = Value
        if emoteTrack and EmoteEnabled then pcall(function() emoteTrack:AdjustSpeed(EMOTESPEED) end) end
    end
})

-- ==========================================
-- Misc 탭 (Device Spoof & Hit Sound)
-- ==========================================
local Group = Tabs.Misc:AddLeftGroupbox('Device Spoofing')
local SetControlsRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Replication"):WaitForChild("Fighter"):WaitForChild("SetControls")
Group:AddDropdown('DeviceDropdown', {
    Values = { 'PC (Mouse & Keyboard)', 'Mobile (Touch)', 'Controller (Gamepad)', 'VR' },
    Default = 1, Text = 'Device Spoof',
    Callback = function(Value)
        local TargetDevice = "MouseKeyboard"
        if Value:find("PC") then TargetDevice = "MouseKeyboard"
        elseif Value:find("Mobile") then TargetDevice = "Touch"
        elseif Value:find("Controller") then TargetDevice = "Gamepad"
        elseif Value:find("VR") then TargetDevice = "VR" end
        SetControlsRemote:FireServer("MouseKeyboard")
        task.wait(0.1)
        SetControlsRemote:FireServer(TargetDevice)
    end
})

-- Hit Sound
local HitSoundConfig = { Enable = false, RemoveDefaultSound = false, Volume = 3, Pitch = 1, Selected = "rust", NotifyEnable = false }
local SoundLibrary = { ["rust"] = "rbxassetid://1255040462", ["windows xp"] = "rbxassetid://108009100115241" }
local SoundKeys = { "rust", "windows xp" }

local HitSoundGroup = Tabs.Misc:AddRightGroupbox('Hit Sound')
HitSoundGroup:AddToggle('HitSoundEnable', { Text = 'Enable Hit Sound', Default = false, Callback = function(v) HitSoundConfig.Enable = v end })
HitSoundGroup:AddDropdown('HitSoundDropdown', { Values = SoundKeys, Default = 1, Text = 'Sound Effect', Callback = function(v) HitSoundConfig.Selected = v end })
HitSoundGroup:AddSlider('HitSoundVolume', { Text = 'Volume', Default = 3, Min = 0, Max = 5, Rounding = 1, Callback = function(v) HitSoundConfig.Volume = v end })

-- ==========================================
-- ESP Render Loop
-- ==========================================
local espData = {}
local function addESP(p)
    if p == LocalPlayer then return end
    task.spawn(function()
        local box, nameText
        pcall(function()
            if Drawing then
                box = Drawing.new("Square"); box.Visible = false; box.Color = Color3.new(1, 1, 1); box.Thickness = 1
                nameText = Drawing.new("Text"); nameText.Visible = false; nameText.Center = true; nameText.Outline = true; nameText.Color = Color3.new(1, 1, 1); nameText.Size = 13
            end
        end)
        if box then espData[p] = { Box = box, NameText = nameText } end
    end)
end
for _, p in ipairs(Players:GetPlayers()) do addESP(p) end
Players.PlayerAdded:Connect(addESP)
Players.PlayerRemoving:Connect(function(p)
    if espData[p] then
        pcall(function() espData[p].Box:Remove(); espData[p].NameText:Remove() end)
        espData[p] = nil
    end
end)

RunService.RenderStepped:Connect(function()
    local CurrentCam = Workspace.CurrentCamera
    if not CurrentCam then return end
    for p, d in pairs(espData) do
        local c = p.Character
        if c and c:FindFirstChild("Humanoid") and c.Humanoid.Health > 0 then
            local root = c:FindFirstChild("HumanoidRootPart")
            if root then
                local rPos, onScreen = CurrentCam:WorldToViewportPoint(root.Position)
                if onScreen and Toggles.ESPBox and Toggles.ESPBox.Value then
                    d.Box.Size = Vector2.new(30, 50)
                    d.Box.Position = Vector2.new(rPos.X - 15, rPos.Y - 25)
                    d.Box.Visible = true
                else
                    d.Box.Visible = false
                end
            else
                d.Box.Visible = false
            end
        else
            d.Box.Visible = false
        end
    end
end)

-- ==========================================
-- Setting 탭 (Config & Theme)
-- ==========================================
local SettingsMenu = Tabs.Setting:AddLeftGroupbox('Menu Settings')
SettingsMenu:AddButton('Unload UI', function()
    pcall(function() Visuals.unload(); Weather.unload() end)
    Library:Unload()
end)
SettingsMenu:AddLabel('Menu Keybind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu Keybind' })

Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('YumuEnchantment')
SaveManager:SetFolder('YumuEnchantment/configs')
SaveManager:BuildConfigSection(Tabs.Setting)
ThemeManager:ApplyToTab(Tabs.Setting)
SaveManager:LoadAutoloadConfig()
