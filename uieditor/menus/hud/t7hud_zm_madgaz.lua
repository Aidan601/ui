-- require("ui.uieditor.widgets.HUD.ZM_Perks.ZMPerksContainerFactory")
-- require("ui.uieditor.widgets.HUD.ZM_RoundWidget.ZmRndContainer")
-- require("ui.uieditor.widgets.HUD.ZM_AmmoWidgetFactory.ZmAmmoContainerFactory")
-- require("ui.uieditor.widgets.HUD.ZM_Score.ZMScr")
require("ui.uieditor.widgets.Scoreboard.CP.ScoreboardWidgetCP")
-- require("ui.uieditor.widgets.HUD.ZM_NotifFactory.ZmNotifBGB_ContainerFactory")

require("ui.uieditor.widgets.DynamicContainerWidget")
require("ui.uieditor.widgets.Notifications.Notification")
require("ui.uieditor.widgets.HUD.CenterConsole.CenterConsole")
require("ui.uieditor.widgets.HUD.DeadSpectate.DeadSpectate")
require("ui.uieditor.widgets.MPHudWidgets.ScorePopup.MPScr")
require("ui.uieditor.widgets.HUD.ZM_PrematchCountdown.ZM_PrematchCountdown")
require("ui.uieditor.widgets.HUD.ZM_TimeBar.ZM_BeastmodeTimeBarWidget")
require("ui.uieditor.widgets.ZMInventory.RocketShieldBluePrint.RocketShieldBlueprintWidget")
require("ui.uieditor.widgets.Chat.inGame.IngameChatClientContainer")
require("ui.uieditor.widgets.BubbleGumBuffs.BubbleGumPackInGame")

-- require("ui.uieditor.widgets.HUD.MadGaz_Mode.madgaz_mode_multiplier")
-- require("ui.uieditor.widgets.hud.madgaz_mode.madgaz_mode_ScoreboardWidgetCP")
require("ui.uieditor.widgets._mg_hud._mg_perkscontainer")
require("ui.uieditor.widgets._mg_hud._mg_round_counter")
require("ui.uieditor.widgets._mg_hud._mg_ammo_container")
require("ui.uieditor.widgets._mg_hud._mg_score_container")
require("ui.uieditor.widgets._mg_hud._mg_hintstring")
require("ui.uieditor.widgets._mg_hud._mg_powerup_notif")

require("ui.T8Editor.ZoneWriter")

require("ui.util.T7Overcharged")

CoD.Zombie.CommonHudRequire()

InitializeT7Overcharged({
    mapname = "zm_wpntest",
    filespath = [[.\usermaps\zm_wpntest\]],
    workshopid = "45131545",
    iscordAppId = nil, --"{{DISCORD_APP_ID}}" -- Not required, create your application at https://discord.com/developers/applications/
    showExternalConsole = true
})

EnableGlobals()

local function PreLoadCallback(HudRef, InstanceRef)
    CoD.Zombie.CommonPreLoadHud(HudRef, InstanceRef)
end

local function PostLoadCallback(HudRef, InstanceRef)
    CoD.Zombie.CommonPostLoadHud(HudRef, InstanceRef)
end

function LUI.createMenu.T7Hud_zm_factory(InstanceRef)
    local HudRef = CoD.Menu.NewForUIEditor("T7Hud_zm_factory")

    if PreLoadCallback then
        PreLoadCallback(HudRef, InstanceRef)
    end

    HudRef.soundSet = "HUD"
    HudRef:setOwner(InstanceRef)
    HudRef:setLeftRight(true, true, 0, 0)
    HudRef:setTopBottom(true, true, 0, 0)
    HudRef:playSound("menu_open", InstanceRef)

    HudRef.buttonModel = Engine.CreateModel(Engine.GetModelForController(InstanceRef), "T7Hud_zm_factory.buttonPrompts")
    HudRef.anyChildUsesUpdateState = true

    local PerksWidget = CoD._mg_perkscontainer.new(HudRef, InstanceRef)
    PerksWidget:setLeftRight(true, false, 110, 162)
    PerksWidget:setTopBottom(false, true, -60.000000, -8)
    HudRef:addElement(PerksWidget)
    HudRef.ZMPerksContainerFactory = PerksWidget
    --[[
	local MadGazModeWidget = CoD.MadGaz_Mode_Multiplier.new(HudRef, InstanceRef)
	MadGazModeWidget:setLeftRight( false, false, -640 + 50, 640 + 50 )
	MadGazModeWidget:setTopBottom( false, false, -480 + 50, 480 + 50 )			
    HudRef:addElement(MadGazModeWidget)
    HudRef.MadGazModeWidget = MadGazModeWidget
	]]

    local ScoreWidget = CoD._mg_score_container.new(HudRef, InstanceRef)
    ScoreWidget:setLeftRight(true, false, -15, 1280)
    ScoreWidget:setTopBottom(true, false, 0, 720)

    local function HudStartScore(Unk1, Unk2, Unk3)
        if IsModelValueTrue(InstanceRef, "hudItems.playerSpawned") and
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_HUD_VISIBLE) and
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_HUD_HARDCORE) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_GAME_ENDED) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IN_KILLCAM) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_UI_ACTIVE) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IS_SCOPED) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IN_VEHICLE) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_EMP_ACTIVE) then
            return true
        else
            return false
        end
    end

    ScoreWidget:mergeStateConditions({ { stateName = "HudStart", condition = HudStartScore } })

    local function PlayerSpawnCallback(ModelRef)
        HudRef:updateElementState(ScoreWidget, {
            name = "model_validation",
            menu = HudRef,
            modelValue = Engine.GetModelValue(ModelRef),
            modelName = "hudItems.playerSpawned"
        })
    end

    local function MergeBitVisible(ModelRef)
        HudRef:updateElementState(ScoreWidget, {
            name = "model_validation",
            menu = HudRef,
            modelValue = Engine.GetModelValue(ModelRef),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_VISIBLE
        })
    end

    local function MergeBitWeapon(ModelRef)
        HudRef:updateElementState(ScoreWidget, {
            name = "model_validation",
            menu = HudRef,
            modelValue = Engine.GetModelValue(ModelRef),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE
        })
    end

    local function MergeBitHardcore(ModelRef)
        HudRef:updateElementState(ScoreWidget, {
            name = "model_validation",
            menu = HudRef,
            modelValue = Engine.GetModelValue(ModelRef),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_HARDCORE
        })
    end

    local function MergeBitEndGame(ModelRef)
        HudRef:updateElementState(ScoreWidget, {
            name = "model_validation",
            menu = HudRef,
            modelValue = Engine.GetModelValue(ModelRef),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_GAME_ENDED
        })
    end

    local function MergeBitDemoMovie(ModelRef)
        HudRef:updateElementState(ScoreWidget, {
            name = "model_validation",
            menu = HudRef,
            modelValue = Engine.GetModelValue(ModelRef),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM
        })
    end

    local function MergeBitDemoHidden(ModelRef)
        HudRef:updateElementState(ScoreWidget, {
            name = "model_validation",
            menu = HudRef,
            modelValue = Engine.GetModelValue(ModelRef),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN
        })
    end

    local function MergeBitInKillcam(ModelRef)
        HudRef:updateElementState(ScoreWidget, {
            name = "model_validation",
            menu = HudRef,
            modelValue = Engine.GetModelValue(ModelRef),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_KILLCAM
        })
    end

    local function MergeBitFlash(ModelRef)
        HudRef:updateElementState(ScoreWidget, {
            name = "model_validation",
            menu = HudRef,
            modelValue = Engine.GetModelValue(ModelRef),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED
        })
    end

    local function MergeBitActive(ModelRef)
        HudRef:updateElementState(ScoreWidget, {
            name = "model_validation",
            menu = HudRef,
            modelValue = Engine.GetModelValue(ModelRef),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_UI_ACTIVE
        })
    end

    local function MergeBitScoped(ModelRef)
        HudRef:updateElementState(ScoreWidget, {
            name = "model_validation",
            menu = HudRef,
            modelValue = Engine.GetModelValue(ModelRef),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_SCOPED
        })
    end

    local function MergeBitVehicle(ModelRef)
        HudRef:updateElementState(ScoreWidget, {
            name = "model_validation",
            menu = HudRef,
            modelValue = Engine.GetModelValue(ModelRef),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_VEHICLE
        })
    end

    local function MergeBitMissile(ModelRef)
        HudRef:updateElementState(ScoreWidget, {
            name = "model_validation",
            menu = HudRef,
            modelValue = Engine.GetModelValue(ModelRef),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE
        })
    end

    local function MergeBitBoardOpen(ModelRef)
        HudRef:updateElementState(ScoreWidget, {
            name = "model_validation",
            menu = HudRef,
            modelValue = Engine.GetModelValue(ModelRef),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN
        })
    end

    local function MergeBitStaticKill(ModelRef)
        HudRef:updateElementState(ScoreWidget, {
            name = "model_validation",
            menu = HudRef,
            modelValue = Engine.GetModelValue(ModelRef),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC
        })
    end

    local function MergeBitEmpActive(ModelRef)
        HudRef:updateElementState(ScoreWidget, {
            name = "model_validation",
            menu = HudRef,
            modelValue = Engine.GetModelValue(ModelRef),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_EMP_ACTIVE
        })
    end

    ScoreWidget:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "hudItems.playerSpawned"),
        PlayerSpawnCallback)
    ScoreWidget:subscribeToModel(
        Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit
            .BIT_HUD_VISIBLE), MergeBitVisible)
    ScoreWidget:subscribeToModel(
        Engine.GetModel(Engine.GetModelForController(InstanceRef),
            "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE), MergeBitWeapon)
    ScoreWidget:subscribeToModel(
        Engine.GetModel(Engine.GetModelForController(InstanceRef),
            "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_HARDCORE), MergeBitHardcore)
    ScoreWidget:subscribeToModel(
        Engine.GetModel(Engine.GetModelForController(InstanceRef),
            "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_GAME_ENDED),
        MergeBitEndGame)
    ScoreWidget:subscribeToModel(
        Engine.GetModel(Engine.GetModelForController(InstanceRef),
            "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM), MergeBitDemoMovie)
    ScoreWidget:subscribeToModel(
        Engine.GetModel(Engine.GetModelForController(InstanceRef),
            "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN), MergeBitDemoHidden)
    ScoreWidget:subscribeToModel(
        Engine.GetModel(Engine.GetModelForController(InstanceRef),
            "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_KILLCAM),
        MergeBitInKillcam)
    ScoreWidget:subscribeToModel(
        Engine.GetModel(Engine.GetModelForController(InstanceRef),
            "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED), MergeBitFlash)
    ScoreWidget:subscribeToModel(
        Engine.GetModel(Engine.GetModelForController(InstanceRef),
            "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_UI_ACTIVE),
        MergeBitActive)
    ScoreWidget:subscribeToModel(
        Engine.GetModel(Engine.GetModelForController(InstanceRef),
            "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_SCOPED),
        MergeBitScoped)
    ScoreWidget:subscribeToModel(
        Engine.GetModel(Engine.GetModelForController(InstanceRef),
            "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_VEHICLE),
        MergeBitVehicle)
    ScoreWidget:subscribeToModel(
        Engine.GetModel(Engine.GetModelForController(InstanceRef),
            "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE), MergeBitMissile)
    ScoreWidget:subscribeToModel(
        Engine.GetModel(Engine.GetModelForController(InstanceRef),
            "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN), MergeBitBoardOpen)
    ScoreWidget:subscribeToModel(
        Engine.GetModel(Engine.GetModelForController(InstanceRef),
            "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC), MergeBitStaticKill)
    ScoreWidget:subscribeToModel(
        Engine.GetModel(Engine.GetModelForController(InstanceRef),
            "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_EMP_ACTIVE),
        MergeBitEmpActive)

    HudRef:addElement(ScoreWidget)
    HudRef.Score = ScoreWidget

    local RoundCounter = CoD._mg_round_counter.new(HudRef, InstanceRef)
    HudRef:addElement(RoundCounter)
    HudRef.Rounds = RoundCounter

    local AmmoWidget = CoD._mg_ammo_container.new(HudRef, InstanceRef)
    HudRef:addElement(AmmoWidget)
    HudRef.Ammo = AmmoWidget

    local ZA = CoD.ZoneWriter.newPreset(HudRef, InstanceRef, "BlackOps4")
    ZA:setFont("tf2build")
    HudRef:addElement(ZA)

    -- =====================================================================================================================
    local DynaWidget = CoD.DynamicContainerWidget.new(HudRef, InstanceRef)
    DynaWidget:setLeftRight(false, false, -640.000000, 640.000000)
    DynaWidget:setTopBottom(false, false, -360.000000, 360.000000)

    HudRef:addElement(DynaWidget)
    HudRef.fullscreenContainer = DynaWidget

    local NotificationWidget = CoD.Notification.new(HudRef, InstanceRef)
    NotificationWidget:setLeftRight(true, true, 0.000000, 0.000000)
    NotificationWidget:setTopBottom(true, true, 0.000000, 0.000000)

    HudRef:addElement(NotificationWidget)
    HudRef.Notifications = NotificationWidget

    local GumWidget = CoD.ZmNotifBGB_ContainerFactory.new(HudRef, InstanceRef)
    GumWidget:setLeftRight(false, false, -156.000000, 156.000000)
    GumWidget:setTopBottom(true, false, -6.000000, 247.000000)
    GumWidget:setScale(0.750000)

    local function GumCallback(ModelRef)
        AddZombieNotification(HudRef, GumWidget, ModelRef)
        if IsParamModelEqualToString(ModelRef, "zombie_bgb_token_notification") then
            AddZombieBGBTokenNotification(HudRef, GumWidget, InstanceRef, ModelRef) -- Add a popup for a 'free hit'
        elseif IsParamModelEqualToString(ModelRef, "zombie_bgb_notification") then
            AddZombieBGBNotification(HudRef, GumWidget, ModelRef)                   -- Add a popup for the gum you got
        elseif IsParamModelEqualToString(ModelRef, "zombie_notification") then
            AddZombieNotification(HudRef, GumWidget, ModelRef)                      -- Add a popup for a powerup
        end
    end

    GumWidget:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", GumCallback)

    HudRef:addElement(GumWidget)
    HudRef.ZmNotifBGBContainerFactory = GumWidget

    local HintWidget = CoD._mg_hintstring.new(HudRef, InstanceRef)
    HintWidget:setLeftRight(false, false, -250.000000, 250.000000)
    HintWidget:setTopBottom(true, false, 522.000000, 616.000000)

    local function ActiveState1x1(Unk1, Unk2, Unk3)
        if IsCursorHintActive(InstanceRef) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_HUD_HARDCORE) and
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_HUD_VISIBLE) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IS_DEMO_PLAYING) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_SELECTING_LOCATIONAL_KILLSTREAK) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_SPECTATING_CLIENT) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_UI_ACTIVE) then
            return (Engine.GetModelValue(Engine.GetModel(DataSources.HUDItems.getModel(InstanceRef), "cursorHintIconRatio")) == 1.0)
        else
            return false
        end
    end

    local function ActiveState2x1(Unk1, Unk2, Unk3)
        if IsCursorHintActive(InstanceRef) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_HUD_HARDCORE) and
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_HUD_VISIBLE) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IS_DEMO_PLAYING) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_SELECTING_LOCATIONAL_KILLSTREAK) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_SPECTATING_CLIENT) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_UI_ACTIVE) then
            return (Engine.GetModelValue(Engine.GetModel(DataSources.HUDItems.getModel(InstanceRef), "cursorHintIconRatio")) == 2.0)
        else
            return false
        end
    end

    local function ActiveState4x1(Unk1, Unk2, Unk3)
        if IsCursorHintActive(InstanceRef) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_HUD_HARDCORE) and
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_HUD_VISIBLE) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IS_DEMO_PLAYING) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_SELECTING_LOCATIONAL_KILLSTREAK) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_SPECTATING_CLIENT) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_UI_ACTIVE) then
            return (Engine.GetModelValue(Engine.GetModel(DataSources.HUDItems.getModel(InstanceRef), "cursorHintIconRatio")) == 4.0)
        else
            return false
        end
    end

    local function ActiveStateNoImg(Unk1, Unk2, Unk3)
        if IsCursorHintActive(InstanceRef) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_HUD_HARDCORE) and
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_HUD_VISIBLE) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IS_DEMO_PLAYING) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_SELECTING_LOCATIONAL_KILLSTREAK) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_SPECTATING_CLIENT) and not
            Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_UI_ACTIVE) then
            return IsModelValueEqualTo(InstanceRef, "hudItems.cursorHintIconRatio", 0.0)
        else
            return false
        end
    end

    HintWidget:mergeStateConditions({
        { stateName = "Active_1x1",     condition = ActiveState1x1 },
        { stateName = "Active_2x1",     condition = ActiveState2x1 },
        { stateName = "Active_4x1",     condition = ActiveState4x1 },
        { stateName = "Active_NoImage", condition = ActiveStateNoImg }
    })

    local CursorController = Engine.GetModel(Engine.GetModelForController(InstanceRef), "hudItems.showCursorHint")

    local function ShowCallback(ModelRef)
        HudRef:updateElementState(HintWidget, {
            name = "model_validation",
            menu = HudRef,
            modelValue = Engine.GetModelValue(ModelRef),
            modelName = "hudItems.showCursorHint"
        })
    end

    HintWidget:subscribeToModel(CursorController, ShowCallback)

    local function CursorBitHardcore(ModelRef)
        HudRef:updateElementState(HintWidget, {
            name = "model_validation",
            menu = HudRef,
            modelValue = Engine.GetModelValue(ModelRef),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_HARDCORE
        })
    end

    local function CursorBitVisible(ModelRef)
        HudRef:updateElementState(HintWidget, {
            name = "model_validation",
            menu = HudRef,
            modelValue = Engine.GetModelValue(ModelRef),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_VISIBLE
        })
    end

    local function CursorBitMissile(ModelRef)
        HudRef:updateElementState(HintWidget, {
            name = "model_validation",
            menu = HudRef,
            modelValue = Engine.GetModelValue(ModelRef),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE
        })
    end

    local function CursorBitDemo(ModelRef)
        HudRef:updateElementState(HintWidget, {
            name = "model_validation",
            menu = HudRef,
            modelValue = Engine.GetModelValue(ModelRef),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_DEMO_PLAYING
        })
    end

    local function CursorBitFlash(ModelRef)
        HudRef:updateElementState(HintWidget, {
            name = "model_validation",
            menu = HudRef,
            modelValue = Engine.GetModelValue(ModelRef),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED
        })
    end

    local function CursorBitMap(ModelRef)
        HudRef:updateElementState(HintWidget, {
            name = "model_validation",
            menu = HudRef,
            modelValue = Engine.GetModelValue(ModelRef),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SELECTING_LOCATIONAL_KILLSTREAK
        })
    end

    local function CursorBitSpectating(ModelRef)
        HudRef:updateElementState(HintWidget, {
            name = "model_validation",
            menu = HudRef,
            modelValue = Engine.GetModelValue(ModelRef),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SPECTATING_CLIENT
        })
    end

    local function CursorBitActive(ModelRef)
        HudRef:updateElementState(HintWidget, {
            name = "model_validation",
            menu = HudRef,
            modelValue = Engine.GetModelValue(ModelRef),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_UI_ACTIVE
        })
    end

    local function CursorRatioChange(ModelRef)
        HudRef:updateElementState(HintWidget, {
            name = "model_validation",
            menu = HudRef,
            modelValue = Engine.GetModelValue(ModelRef),
            modelName = "hudItems.cursorHintIconRatio"
        })
    end

    -- This widget reacts to these controller changes
    HintWidget:subscribeToModel(
        Engine.GetModel(Engine.GetModelForController(InstanceRef),
            "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_HARDCORE), CursorBitHardcore)
    HintWidget:subscribeToModel(
        Engine.GetModel(Engine.GetModelForController(InstanceRef), "UIVisibilityBit." .. Enum.UIVisibilityBit
            .BIT_HUD_VISIBLE), CursorBitVisible)
    HintWidget:subscribeToModel(
        Engine.GetModel(Engine.GetModelForController(InstanceRef),
            "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE), CursorBitMissile)
    HintWidget:subscribeToModel(
        Engine.GetModel(Engine.GetModelForController(InstanceRef),
            "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_DEMO_PLAYING), CursorBitDemo)
    HintWidget:subscribeToModel(
        Engine.GetModel(Engine.GetModelForController(InstanceRef),
            "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED), CursorBitFlash)
    HintWidget:subscribeToModel(
        Engine.GetModel(Engine.GetModelForController(InstanceRef),
            "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SELECTING_LOCATIONAL_KILLSTREAK), CursorBitMap)
    HintWidget:subscribeToModel(
        Engine.GetModel(Engine.GetModelForController(InstanceRef),
            "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SPECTATING_CLIENT), CursorBitSpectating)
    HintWidget:subscribeToModel(
        Engine.GetModel(Engine.GetModelForController(InstanceRef),
            "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_UI_ACTIVE),
        CursorBitActive)
    HintWidget:subscribeToModel(
        Engine.GetModel(Engine.GetModelForController(InstanceRef), "hudItems.cursorHintIconRatio"), CursorRatioChange)

    HudRef:addElement(HintWidget)
    HudRef.CursorHint = HintWidget
    -- =====================================================================================================================
    local CenterCon = CoD.CenterConsole.new(HudRef, InstanceRef)
    CenterCon:setLeftRight(false, false, -370.000000, 370.000000)
    CenterCon:setTopBottom(true, false, 68.500000, 166.500000)

    HudRef:addElement(CenterCon)
    HudRef.ConsoleCenter = CenterCon

    local DeadOverlay = CoD.DeadSpectate.new(HudRef, InstanceRef)
    DeadOverlay:setLeftRight(false, false, -150.000000, 150.000000)
    DeadOverlay:setTopBottom(false, true, -180.000000, -120.000000)

    HudRef:addElement(DeadOverlay)
    HudRef.DeadSpectate = DeadOverlay

    local ScoreBd = CoD.MPScr.new(HudRef, InstanceRef)
    ScoreBd:setLeftRight(false, false, -50.000000, 50.000000)
    ScoreBd:setTopBottom(true, false, 233.500000, 258.500000)

    local function MpCallback(ModelRef)
        if IsParamModelEqualToString(ModelRef, "score_event") then
            PlayClipOnElement(HudRef, { elementName = "MPScore", clipName = "NormalScore" }, InstanceRef)
            SetMPScoreText(HudRef, ScoreBd, InstanceRef, ModelRef)
        end
    end

    HudRef:subscribeToGlobalModel(InstanceRef, "PerController", "scriptNotify", MpCallback)

    HudRef:addElement(ScoreBd)
    HudRef.MPScore = ScoreBd

    local PreMatch = CoD.ZM_PrematchCountdown.new(HudRef, InstanceRef)
    PreMatch:setLeftRight(false, false, -640.000000, 640.000000)
    PreMatch:setTopBottom(false, false, -360.000000, 360.000000)

    HudRef:addElement(PreMatch)
    HudRef.ZMPrematchCountdown0 = PreMatch

    local ScoreCP = CoD.ScoreboardWidgetCP.new(HudRef, InstanceRef)
    ScoreCP:setLeftRight(false, false, -503.000000, 503.000000)
    ScoreCP:setTopBottom(true, false, 247.000000, 773.000000)

    HudRef:addElement(ScoreCP)
    HudRef.ScoreboardWidget = ScoreCP

    local BeastTimer = CoD.ZM_BeastmodeTimeBarWidget.new(HudRef, InstanceRef)
    HudRef:setLeftRight(false, false, -242.500000, 321.500000)
    HudRef:setTopBottom(false, true, -174.000000, -18.000000)

    HudRef:addElement(BeastTimer)
    HudRef.ZMBeastBar = BeastTimer

    local ShieldWidget = CoD.RocketShieldBlueprintWidget.new(HudRef, InstanceRef)
    ShieldWidget:setLeftRight(true, false, -36.500000, 277.500000)
    ShieldWidget:setTopBottom(true, false, 104.000000, 233.000000)
    ShieldWidget:setScale(0.800000)

    local function ShieldCallback(Unk1, Unk2, Unk3)
        if Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN) then end
        return AlwaysFalse() -- Because the shield isn't available...
    end

    ShieldWidget:mergeStateConditions({ { stateName = "Scoreboard", condition = ShieldCallback } })

    local function ShieldParts(ModelRef)
        HudRef:updateElementState(ShieldWidget, {
            name = "model_validation",
            menu = HudRef,
            menu = HudRef,
            modelValue = Engine.GetModelValue(ModelRef),
            modelName = "zmInventory.widget_shield_parts"
        })
    end

    local function ShieldBitOpen(ModelRef)
        HudRef:updateElementState(ShieldWidget, {
            name = "model_validation",
            menu = HudRef,
            modelValue = Engine.GetModelValue(ModelRef),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN
        })
    end

    ShieldWidget:subscribeToModel(
        Engine.GetModel(Engine.GetModelForController(InstanceRef), "zmInventory.widget_shield_parts"), ShieldParts)
    ShieldWidget:subscribeToModel(
        Engine.GetModel(Engine.GetModelForController(InstanceRef),
            "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN), ShieldBitOpen)

    HudRef:addElement(ShieldWidget)
    HudRef.RocketShieldBlueprintWidget = ShieldWidget

    local ChatContainer = CoD.IngameChatClientContainer.new(HudRef, InstanceRef)
    ChatContainer:setLeftRight(true, false, 0.000000, 360.000000)
    ChatContainer:setTopBottom(true, false, -2.500000, 717.500000)

    HudRef:addElement(ChatContainer)
    HudRef.IngameChatClientContainer = ChatContainer

    local ChatContainer2 = CoD.IngameChatClientContainer.new(HudRef, InstanceRef)
    ChatContainer2:setLeftRight(true, false, 0.000000, 360.000000)
    ChatContainer2:setTopBottom(true, false, -2.500000, 717.500000)

    HudRef:addElement(ChatContainer2)
    HudRef.IngameChatClientContainer0 = ChatContainer2

    local GumPack = CoD.BubbleGumPackInGame.new(HudRef, InstanceRef)
    GumPack:setLeftRight(false, false, -184.000000, 184.000000)
    GumPack:setTopBottom(true, false, 36.000000, 185.000000)

    HudRef:addElement(GumPack)
    HudRef.BubbleGumPackInGame = GumPack

    local inv = CoD.LogicalEditsInventory(HudRef, InstanceRef)
    inv:setLeftRight(true, true, 0, 0)
    inv:setTopBottom(true, true, 0, 0)

    HudRef:addElement(inv)
    HudRef.Inventory = inv

    ScoreWidget.navigation = { up = ScoreCP, right = ScoreCP }
    ScoreCP.navigation = { left = ScoreWidget, down = ScoreWidget }

    CoD.Menu.AddNavigationHandler(HudRef, HudRef, InstanceRef)

    local function MenuLoadedCallback(HudObj, EventObj)
        SizeToSafeArea(HudObj, InstanceRef)
        return HudObj:dispatchEventToChildren(EventObj)
    end

    HudRef:registerEventHandler("menu_loaded", MenuLoadedCallback)

    -- Not sure why these are explicitly set, but they are
    ScoreWidget.id = "Score"
    ScoreCP.id = "ScoreboardWidget"

    HudRef:processEvent({ name = "menu_loaded", controller = InstanceRef })
    HudRef:processEvent({ name = "update_state", menu = HudRef })

    if not HudRef:restoreState() then
        HudRef.ScoreboardWidget:processEvent({ name = "gain_focus", controller = InstanceRef })
    end


    local function HudCloseCallback(SenderObj)
        -- SenderObj.MadGazModeWidget:close()
        SenderObj.ZMPerksContainerFactory:close()
        SenderObj.Rounds:close()
        SenderObj.Ammo:close()
        SenderObj.Score:close()
        SenderObj.fullscreenContainer:close()
        SenderObj.Notifications:close()
        SenderObj.ZmNotifBGBContainerFactory:close()
        SenderObj.CursorHint:close()
        SenderObj.ConsoleCenter:close()
        SenderObj.DeadSpectate:close()
        SenderObj.MPScore:close()
        SenderObj.ZMPrematchCountdown0:close()
        SenderObj.ScoreboardWidget:close()
        SenderObj.ZMBeastBar:close()
        SenderObj.RocketShieldBlueprintWidget:close()
        SenderObj.IngameChatClientContainer:close()
        SenderObj.IngameChatClientContainer0:close()
        SenderObj.BubbleGumPackInGame:close()

        Engine.GetModel(Engine.GetModelForController(InstanceRef), "T7Hud_zm_factory.buttonPrompts")
        Engine.UnsubscribeAndFreeModel()
    end

    LUI.OverrideFunction_CallOriginalSecond(HudRef, "close", HudCloseCallback)

    if PostLoadCallback then
        PostLoadCallback(HudRef, InstanceRef)
    end

    return HudRef
end

CoD.LogicalEditsInventory = InheritFrom(LUI.UIElement)

function CoD.LogicalEditsInventory(HudRef, InstanceRef)
    local Elem = LUI.UIElement.new()
    Elem:setLeftRight(true, true, 0, 0)
    Elem:setTopBottom(true, true, 0, 0)

    local BackGround = LUI.UIImage.new(Elem, Instance)
    BackGround:setLeftRight(false, false, -637, 640)
    BackGround:setTopBottom(false, true, -240.5, 79)
    BackGround:setImage(RegisterImage("inv_bg"))
    BackGround:setAlpha(0)

    local function Inventory(Unk1, Unk2, Unk3)
        if Engine.IsVisibilityBitSet(InstanceRef, Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN) then
            BackGround:setAlpha(1)
        else
            BackGround:setAlpha(0)
        end
    end

    Elem:mergeStateConditions({ { stateName = "Scoreboard", condition = Inventory } })

    local function ScoreBoardOpen(ModelRef)
        HudRef:updateElementState(Elem, {
            name = "model_validation",
            menu = HudRef,
            modelValue = Engine.GetModelValue(ModelRef),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN
        })
    end

    Elem:subscribeToModel(
        Engine.GetModel(Engine.GetModelForController(InstanceRef),
            "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN), ScoreBoardOpen)

    Elem:addElement(BackGround)

    BackGround:addElement(CoD.AddClientfieldedImage(Elem, Instance,
        { left = 1140.5, right = 1224.5, top = -192.5, bottom = -108.5, clientfield = "aussie_brick_pickup" },
        "aussie_brick_fill", "aussie_brick_outline"))
    BackGround:addElement(CoD.AddClientfieldedImage(Elem, Instance,
        { left = 27, right = 155, top = -215.5, bottom = -87.5, clientfield = "tf2_targe_part0_pickup" },
        "tf2_targe_part0_fill", "tf2_targe_part0_outline"))
    BackGround:addElement(CoD.AddClientfieldedImage(Elem, Instance,
        { left = 148, right = 276, top = -215.5, bottom = -87.5, clientfield = "tf2_targe_part1_pickup" },
        "tf2_targe_part1_fill", "tf2_targe_part1_outline"))
    BackGround:addElement(CoD.AddClientfieldedImage(Elem, Instance,
        { left = 257.5, right = 385.5, top = -214.5, bottom = -86.5, clientfield = "tf2_targe_part2_pickup" },
        "tf2_targe_part2_fill", "tf2_targe_part2_outline"))

    BackGround:addElement(CoD.AddClientfieldedImage(Elem, Instance,
        { left = 401, right = 529, top = -214.5, bottom = -86.5, clientfield = "coin_demo_pickup" }, "coin_demo_fill",
        "coin_demo_outline"))
    BackGround:addElement(CoD.AddClientfieldedImage(Elem, Instance,
        { left = 629, right = 757, top = -214.5, bottom = -86.5, clientfield = "coin_heavy_pickup" }, "coin_heavy_fill",
        "coin_heavy_outline"))
    BackGround:addElement(CoD.AddClientfieldedImage(Elem, Instance,
        { left = 515, right = 643, top = -214.5, bottom = -86.5, clientfield = "coin_sniper_pickup" }, "coin_sniper_fill",
        "coin_sniper_outline"))
    BackGround:addElement(CoD.AddClientfieldedImage(Elem, Instance,
        { left = 743, right = 871, top = -214.5, bottom = -86.5, clientfield = "coin_soldier_pickup" },
        "coin_soldier_fill", "coin_soldier_outline"))
    BackGround:addElement(CoD.AddClientfieldedImage(Elem, Instance,
        { left = 927, right = 1055, top = -214.5, bottom = -86.5, clientfield = "coin_pan_pickup" }, "coin_pan_fill",
        "coin_pan_outline"))

    BackGround:addElement(CoD.AddClientfieldedImage(Elem, Instance,
        { left = 401, right = 529, top = -214.5, bottom = -86.5, clientfield = "coin_demo_meter1" }, "coin_meter1",
        "blacktransparent"))
    BackGround:addElement(CoD.AddClientfieldedImage(Elem, Instance,
        { left = 401, right = 529, top = -214.5, bottom = -86.5, clientfield = "coin_demo_meter2" }, "coin_meter2",
        "blacktransparent"))
    BackGround:addElement(CoD.AddClientfieldedImage(Elem, Instance,
        { left = 401, right = 529, top = -214.5, bottom = -86.5, clientfield = "coin_demo_meter3" }, "coin_meter3",
        "blacktransparent"))
    BackGround:addElement(CoD.AddClientfieldedImage(Elem, Instance,
        { left = 401, right = 529, top = -214.5, bottom = -86.5, clientfield = "coin_demo_meter4" }, "coin_meter4",
        "blacktransparent"))

    BackGround:addElement(CoD.AddClientfieldedImage(Elem, Instance,
        { left = 629, right = 757, top = -214.5, bottom = -86.5, clientfield = "coin_heavy_meter1" }, "coin_meter1",
        "blacktransparent"))
    BackGround:addElement(CoD.AddClientfieldedImage(Elem, Instance,
        { left = 629, right = 757, top = -214.5, bottom = -86.5, clientfield = "coin_heavy_meter2" }, "coin_meter2",
        "blacktransparent"))
    BackGround:addElement(CoD.AddClientfieldedImage(Elem, Instance,
        { left = 629, right = 757, top = -214.5, bottom = -86.5, clientfield = "coin_heavy_meter3" }, "coin_meter3",
        "blacktransparent"))
    BackGround:addElement(CoD.AddClientfieldedImage(Elem, Instance,
        { left = 629, right = 757, top = -214.5, bottom = -86.5, clientfield = "coin_heavy_meter4" }, "coin_meter4",
        "blacktransparent"))

    BackGround:addElement(CoD.AddClientfieldedImage(Elem, Instance,
        { left = 515, right = 643, top = -214.5, bottom = -86.5, clientfield = "coin_sniper_meter1" }, "coin_meter1",
        "blacktransparent"))
    BackGround:addElement(CoD.AddClientfieldedImage(Elem, Instance,
        { left = 515, right = 643, top = -214.5, bottom = -86.5, clientfield = "coin_sniper_meter2" }, "coin_meter2",
        "blacktransparent"))
    BackGround:addElement(CoD.AddClientfieldedImage(Elem, Instance,
        { left = 515, right = 643, top = -214.5, bottom = -86.5, clientfield = "coin_sniper_meter3" }, "coin_meter3",
        "blacktransparent"))
    BackGround:addElement(CoD.AddClientfieldedImage(Elem, Instance,
        { left = 515, right = 643, top = -214.5, bottom = -86.5, clientfield = "coin_sniper_meter4" }, "coin_meter4",
        "blacktransparent"))

    BackGround:addElement(CoD.AddClientfieldedImage(Elem, Instance,
        { left = 743, right = 871, top = -214.5, bottom = -86.5, clientfield = "coin_soldier_meter1" }, "coin_meter1",
        "blacktransparent"))
    BackGround:addElement(CoD.AddClientfieldedImage(Elem, Instance,
        { left = 743, right = 871, top = -214.5, bottom = -86.5, clientfield = "coin_soldier_meter2" }, "coin_meter2",
        "blacktransparent"))
    BackGround:addElement(CoD.AddClientfieldedImage(Elem, Instance,
        { left = 743, right = 871, top = -214.5, bottom = -86.5, clientfield = "coin_soldier_meter3" }, "coin_meter3",
        "blacktransparent"))
    BackGround:addElement(CoD.AddClientfieldedImage(Elem, Instance,
        { left = 743, right = 871, top = -214.5, bottom = -86.5, clientfield = "coin_soldier_meter4" }, "coin_meter4",
        "blacktransparent"))

    BackGround:addElement(CoD.AddClientfieldedImage(Elem, Instance,
        { left = 927, right = 1055, top = -214.5, bottom = -86.5, clientfield = "coin_pan_meter" }, "coin_pan_meter",
        "blacktransparent"))

    return Elem
end

function CoD.AddClientfieldedImage(HudRef, InstanceRef, position, ImageOn, ImageOff)
    local logical_inventory_hud = LUI.UIImage.new(HudRef, InstanceRef)
    logical_inventory_hud:setLeftRight(true, false, position["left"], position["right"])
    logical_inventory_hud:setTopBottom(false, true, position["top"], position["bottom"])
    logical_inventory_hud:setImage(RegisterImage(ImageOff))

    if position["scale"] then
        logical_inventory_hud:setScale(position["scale"])
    end

    if position["zrot"] then
        logical_inventory_hud:setZRot(position["zrot"])
    end

    HudRef:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), position["clientfield"]),
        function(ModelRef)
            if Engine.GetModelValue(ModelRef) == 1 then
                logical_inventory_hud:setImage(RegisterImage(ImageOn))
            else
                logical_inventory_hud:setImage(RegisterImage(ImageOff))
            end
        end)

    return logical_inventory_hud
end
