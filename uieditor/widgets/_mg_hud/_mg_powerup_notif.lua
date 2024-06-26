require("ui.uieditor.widgets.CPLevels.RamsesStation.WoundedSoldiers.woundedSoldier_Panel")
require("ui.uieditor.widgets.HUD.ZM_Notif.ZmNotif1_CursorHint")
require("ui.uieditor.widgets.HUD.ZM_NotifFactory.ZmNotif1Factory")
require("ui.uieditor.widgets.HUD.ZM_FX.ZmFx_Spark2")
require("ui.uieditor.widgets.HUD.ZM_AmmoWidgetFactory.ZmAmmo_ParticleFX")
require("ui.uieditor.widgets.ZMInventoryStalingrad.ZmNotif1_Notification_CursorHint")
require("ui.uieditor.widgets.ZMInventoryStalingrad.GameTimeWidget")

EnableGlobals()

function AddZombieNotification(menu, notification_widget, modelref)
	local NotificationData = CoD.GetScriptNotifyData(modelref)
	if NotificationData[2] == nil then
		NotificationData[2] = -1
	end
	notification_widget:appendNotification(
		{
			clip = "TextandImageBasic",
			title = Engine.Localize(Engine.GetIString(NotificationData[1], "CS_LOCALIZED_STRINGS")),
			description = "",
			iconId = NotificationData[2]
		})
end

local PreLoadFunc = function(self, controller)
	Engine.CreateModel(Engine.CreateModel(Engine.GetModelForController(controller), "hudItems.time"),
		"round_complete_time")
end

local PostLoadFunc = function(self, controller)
	self.notificationQueueEmptyModel = Engine.CreateModel(Engine.GetModelForController(controller),
		"NotificationQueueEmpty")
	self.playNotification = function(self, NotificationStruct)
		self.ZmNotif1CursorHint0.CursorHintText:setText(NotificationStruct.description)
		self.ZmNotifFactory.Label1:setText(NotificationStruct.title)
		self.ZmNotifFactory.Label2:setText(NotificationStruct.title)
		if NotificationStruct.iconId == 0 then
			self.PowerupTexture:setImage(RegisterImage("_mg_powerup_nuke"))
		elseif NotificationStruct.iconId == 1 then
			self.PowerupTexture:setImage(RegisterImage("_mg_powerup_carpenter"))
		elseif NotificationStruct.iconId == 2 then
			self.PowerupTexture:setImage(RegisterImage("_mg_powerup_double"))
		elseif NotificationStruct.iconId == 3 then
			self.PowerupTexture:setImage(RegisterImage("_mg_powerup_firesale"))
		elseif NotificationStruct.iconId == 4 then
			self.PowerupTexture:setImage(RegisterImage("tf2_logo"))
			--self.PowerupTexture:setMaterial(LUI.UIImage.GetCachedMaterial("uie_wipe_normal"))
			--self.PowerupTexture:setShaderVector(0,1,0,0,0)
		elseif NotificationStruct.iconId == 5 then
			self.PowerupTexture:setImage(RegisterImage("_mg_powerup_instakill"))
		elseif NotificationStruct.iconId == 6 then
			self.PowerupTexture:setImage(RegisterImage("_mg_powerup_bonuscash"))
		elseif NotificationStruct.iconId == 7 then
			self.PowerupTexture:setImage(RegisterImage("_mg_powerup_zombieblood"))
		elseif NotificationStruct.iconId == 8 then
			self.PowerupTexture:setImage(RegisterImage("_mg_powerup_shield"))
		elseif NotificationStruct.iconId == 9 then
			self.PowerupTexture:setImage(RegisterImage("_mg_powerup_timefreeze"))
		elseif NotificationStruct.iconId == 10 then
			self.PowerupTexture:setImage(RegisterImage("_mg_powerup_fullpower"))
		elseif NotificationStruct.iconId == 11 then
			self.PowerupTexture:setImage(RegisterImage("_mg_powerup_deathmachine"))
		else
			self.PowerupTexture:setImage(RegisterImage("blacktransparent"))
		end
		if NotificationStruct.clip == "TextandImageBGB" or NotificationStruct.clip == "TextandImageBGBToken" or NotificationStruct.clip == "TextandTimeAttack" then
			self.bgbTexture:setImage(NotificationStruct.bgbImage)
			self.bgbTextureLabel:setText(NotificationStruct.bgbImageText or "")
			self.bgbTextureLabelBlur:setText(NotificationStruct.bgbImageText or "")
			if NotificationStruct.clip == "TextandTimeAttack" then
				self.xpaward.Label1:setText(NotificationStruct.xpAward)
				self.xpaward.Label2:setText(NotificationStruct.xpAward)
				self.CursorHint.CursorHintText:setText(NotificationStruct.rewardText)
			end
		end
		self:playClip(NotificationStruct.clip)
	end

	self.appendNotification = function(self, NotificationStruct)
		if self.notificationInProgress == true or Engine.GetModelValue(self.notificationQueueEmptyModel) ~= true then
			local NextNotificationStruct = self.nextNotification
			if NextNotificationStruct == nil then
				self.nextNotification = LUI.ShallowCopy(NotificationStruct)
			else
				while NextNotificationStruct and NextNotificationStruct.next ~= nil do
					NextNotificationStruct = NextNotificationStruct.next
				end
				NextNotificationStruct.next = LUI.ShallowCopy(NotificationStruct)
			end
		else
			self:playNotification(LUI.ShallowCopy(NotificationStruct))
		end
	end

	self.notificationInProgress = false
	self.nextNotification = nil
	LUI.OverrideFunction_CallOriginalSecond(self, "playClip", function(element)
		element.notificationInProgress = true
	end)
	self:registerEventHandler("clip_over", function(element, event)
		self.notificationInProgress = false
		if self.nextNotification ~= nil then
			self:playNotification(self.nextNotification)
			self.nextNotification = self.nextNotification.next
		end
	end)
	self:subscribeToModel(self.notificationQueueEmptyModel, function(modelRef)
		if Engine.GetModelValue(modelRef) == true then
			self:processEvent(
				{
					name = "clip_over"
				})
		end
	end)
	self.Last5RoundTime.GameTimer:subscribeToModel(
		Engine.GetModel(Engine.CreateModel(Engine.GetModelForController(controller), "hudItems.time"),
			"round_complete_time"),
		function(modelRef)
			local modelValue = Engine.GetModelValue(modelRef)
			if modelValue then
				self.Last5RoundTime.GameTimer:setupServerTime(0 - modelValue * 1000)
			end
		end)
end

CoD.ZmNotifBGB_ContainerFactory = InheritFrom(LUI.UIElement)
CoD.ZmNotifBGB_ContainerFactory.new = function(menu, controller)
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc(self, controller)
	end

	self:setUseStencil(false)
	self:setClass(CoD.ZmNotifBGB_ContainerFactory)
	self.id = "ZmNotifBGB_ContainerFactory"
	self.soundSet = "HUD"
	self:setLeftRight(true, false, 0, 312)
	self:setTopBottom(true, false, 0, 32)
	self.anyChildUsesUpdateState = true

	local Panel = CoD.woundedSoldier_Panel.new(menu, controller)
	Panel:setLeftRight(false, false, -156, 156)
	Panel:setTopBottom(true, false, 3.67, 254.33)
	Panel:setRGB(0.84, 0.78, 0.72)
	Panel:setAlpha(0)
	Panel:setRFTMaterial(LUI.UIImage.GetCachedMaterial("uie_scene_blur_pass_2"))
	Panel:setShaderVector(0, 30, 0, 0, 0)
	Panel.Image1:setShaderVector(0, 10, 10, 0, 0)
	self:addElement(Panel)
	self.Panel = Panel

	local PowerupTexture = LUI.UIImage.new()
	PowerupTexture:setLeftRight(false, false, -89.33 + 25 - 70, 90.67 - 25 + 140 - 70)
	PowerupTexture:setTopBottom(true, false, -3.5, 176.5 - 50 + 140)
	PowerupTexture:setAlpha(1)
	PowerupTexture:setScale(1.1)
	PowerupTexture:setImage(RegisterImage("tf2_logo"))
	PowerupTexture:setMaterial(LUI.UIImage.GetCachedMaterial("uie_feather_edges"))
	PowerupTexture:setShaderVector(0, 0, 0, 0, 1)
	--PowerupTexture:setZRot(90)
	self:addElement(PowerupTexture)
	self.PowerupTexture = PowerupTexture

	local PowerupBacker = LUI.UIImage.new()
	PowerupBacker:setLeftRight(false, false, -89.33 + 25 - 20, 90.67 - 25 + 30 - 20)
	PowerupBacker:setTopBottom(true, false, -3.5, 176.5 - 50 + 30)
	PowerupBacker:setImage(RegisterImage("ammo_crate"))
	self:addElement(PowerupBacker)
	self.PowerupBacker = PowerupBacker

	local PowerupBackerLeft = LUI.UIImage.new()
	PowerupBackerLeft:setLeftRight(false, false, -89.33 + 25 - 100, 90.67 - 25 + 200 - 100)
	PowerupBackerLeft:setTopBottom(true, false, -3.5 + 50 + 100, 176.5 - 50 + 50 + 120)

	--self:addElement(PowerupBackerLeft)
	self.PowerupBackerLeft = PowerupBackerLeft

	local PowerupBackerRight = LUI.UIImage.new()
	PowerupBackerRight:setLeftRight(false, false, 156, 156 + 16)
	PowerupBackerRight:setTopBottom(true, false, 140, 190)
	PowerupBackerRight:setImage(RegisterImage("_mg_hintstring_right"))
	--self:addElement( PowerupBackerRight )
	self.PowerupBackerRight = PowerupBackerRight

	local basicImageBacking = LUI.UIImage.new()
	basicImageBacking:setLeftRight(false, false, -124, 124)
	basicImageBacking:setTopBottom(true, false, 5, 253)
	basicImageBacking:setAlpha(0)
	basicImageBacking:setImage(RegisterImage("uie_t7_zm_hud_notif_backdesign_factory"))
	self:addElement(basicImageBacking)
	self.basicImageBacking = basicImageBacking

	local TimeAttack = LUI.UIImage.new()
	TimeAttack:setLeftRight(true, false, 370, 498)
	TimeAttack:setTopBottom(true, false, 92.5, 220.5)
	TimeAttack:setAlpha(0)
	TimeAttack:setImage(RegisterImage("uie_t7_icon_dlc3_time_attack"))
	self:addElement(TimeAttack)
	self.TimeAttack = TimeAttack

	local basicImage = LUI.UIImage.new()
	basicImage:setLeftRight(false, false, -123, 125)
	basicImage:setTopBottom(true, false, 13, 221)
	basicImage:setAlpha(0)
	basicImage:setImage(RegisterImage("uie_t7_zm_hud_notif_factory"))
	self:addElement(basicImage)
	self.basicImage = basicImage

	local bgbGlowOrangeOver = LUI.UIImage.new()
	bgbGlowOrangeOver:setLeftRight(false, false, -103.18, 103.34)
	bgbGlowOrangeOver:setTopBottom(false, false, -183.84, 124.17)
	bgbGlowOrangeOver:setRGB(0, 0.43, 1)
	bgbGlowOrangeOver:setAlpha(0)
	bgbGlowOrangeOver:setZRot(90)
	bgbGlowOrangeOver:setImage(RegisterImage("uie_t7_core_hud_mapwidget_panelglow"))
	bgbGlowOrangeOver:setMaterial(LUI.UIImage.GetCachedMaterial("ui_add"))
	self:addElement(bgbGlowOrangeOver)
	self.bgbGlowOrangeOver = bgbGlowOrangeOver

	local bgbTexture = LUI.UIImage.new()
	bgbTexture:setLeftRight(false, false, -89.33, 90.67)
	bgbTexture:setTopBottom(true, false, -3.5, 176.5)
	bgbTexture:setAlpha(0)
	bgbTexture:setScale(1.1)
	bgbTexture:setImage(RegisterImage("uie_t7_zm_hud_ammo_bbgumtexture"))
	self:addElement(bgbTexture)
	self.bgbTexture = bgbTexture

	local bgbTextureLabelBlur = LUI.UIText.new()
	bgbTextureLabelBlur:setLeftRight(false, false, -46.88, 40.22)
	bgbTextureLabelBlur:setTopBottom(true, false, 63.5, 149.5)
	bgbTextureLabelBlur:setRGB(0.24, 0.11, 0.01)
	bgbTextureLabelBlur:setAlpha(0)
	bgbTextureLabelBlur:setScale(0.7)
	bgbTextureLabelBlur:setText(Engine.Localize("MP_X2"))
	bgbTextureLabelBlur:setTTF("fonts/tf2.ttf")
	bgbTextureLabelBlur:setMaterial(LUI.UIImage.GetCachedMaterial("sw4_2d_uie_font_cached_glow"))
	bgbTextureLabelBlur:setShaderVector(0, 0.11, 0, 0, 0)
	bgbTextureLabelBlur:setShaderVector(1, 0.94, 0, 0, 0)
	bgbTextureLabelBlur:setShaderVector(2, 0, 0, 0, 0)
	bgbTextureLabelBlur:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_RIGHT)
	bgbTextureLabelBlur:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_TOP)
	self:addElement(bgbTextureLabelBlur)
	self.bgbTextureLabelBlur = bgbTextureLabelBlur

	local bgbTextureLabel = LUI.UIText.new()
	bgbTextureLabel:setLeftRight(false, false, -46.88, 40.22)
	bgbTextureLabel:setTopBottom(true, false, 63.5, 149.5)
	bgbTextureLabel:setRGB(1, 0.89, 0.12)
	bgbTextureLabel:setAlpha(0)
	bgbTextureLabel:setScale(0.7)
	bgbTextureLabel:setText(Engine.Localize("MP_X2"))
	bgbTextureLabel:setTTF("fonts/tf2.ttf")
	bgbTextureLabel:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_RIGHT)
	bgbTextureLabel:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_TOP)
	self:addElement(bgbTextureLabel)
	self.bgbTextureLabel = bgbTextureLabel

	local bgbAbilitySwirl = LUI.UIImage.new()
	bgbAbilitySwirl:setLeftRight(false, false, -63.43, 75.43)
	bgbAbilitySwirl:setTopBottom(true, false, 19.64, 156.5)
	bgbAbilitySwirl:setRGB(0, 0.39, 1)
	bgbAbilitySwirl:setAlpha(0)
	bgbAbilitySwirl:setImage(RegisterImage("uie_t7_core_hud_ammowidget_abilityswirl"))
	bgbAbilitySwirl:setMaterial(LUI.UIImage.GetCachedMaterial("ui_add"))
	self:addElement(bgbAbilitySwirl)
	self.bgbAbilitySwirl = bgbAbilitySwirl

	local ZmNotif1CursorHint0 = CoD.ZmNotif1_CursorHint.new(menu, controller)
	ZmNotif1CursorHint0:setLeftRight(false, false, -256, 256)
	ZmNotif1CursorHint0:setTopBottom(true, false, 197.5, 217.5)
	ZmNotif1CursorHint0:setAlpha(0)
	ZmNotif1CursorHint0:setScale(1.4)
	ZmNotif1CursorHint0.FEButtonPanel0:setAlpha(0.27)
	ZmNotif1CursorHint0.CursorHintText:setText(Engine.Localize("MENU_NEW"))
	--self:addElement(ZmNotif1CursorHint0)
	self.ZmNotif1CursorHint0 = ZmNotif1CursorHint0

	local ZmNotifFactory = CoD.ZmNotif1Factory.new(menu, controller)
	ZmNotifFactory:setLeftRight(false, false, -112, 112)
	ZmNotifFactory:setTopBottom(true, false, 138.5, 193.5)
	ZmNotifFactory:setAlpha(0)
	ZmNotifFactory.Label2:setText(Engine.Localize("MENU_NEW"))
	ZmNotifFactory.Label1:setText(Engine.Localize("MENU_NEW"))
	ZmNotifFactory.Label1:setRGB(1, 1, 1)
	ZmNotifFactory.Label2:setRGB(1, 1, 1)
	self:addElement(ZmNotifFactory)
	self.ZmNotifFactory = ZmNotifFactory
	ZmNotifFactory.Label1:setTTF("fonts/tf2build.ttf")
	ZmNotifFactory.Label2:setTTF("fonts/tf2build.ttf")

	local Glow = LUI.UIImage.new()
	Glow:setLeftRight(false, false, -205, 205)
	Glow:setTopBottom(true, false, 18.5, 258.5)
	Glow:setAlpha(0)
	Glow:setImage(RegisterImage("uie_t7_zm_hud_notif_glowfilm"))
	Glow:setMaterial(LUI.UIImage.GetCachedMaterial("ui_add"))
	self:addElement(Glow)
	self.Glow = Glow

	local ZmFxSpark20 = CoD.ZmFx_Spark2.new(menu, controller)
	ZmFxSpark20:setLeftRight(false, false, -102, 101.34)
	ZmFxSpark20:setTopBottom(true, false, 73.5, 225.5)
	ZmFxSpark20:setRGB(0, 0, 0)
	ZmFxSpark20:setRFTMaterial(LUI.UIImage.GetCachedMaterial("ui_add"))
	ZmFxSpark20.Image0:setShaderVector(1, 0, 0.4, 0, 0)
	ZmFxSpark20.Image00:setShaderVector(1, 0, -0.2, 0, 0)
	self:addElement(ZmFxSpark20)
	self.ZmFxSpark20 = ZmFxSpark20

	local Flsh = LUI.UIImage.new()
	Flsh:setLeftRight(false, false, -219.65, 219.34)
	Flsh:setTopBottom(true, false, 146.25, 180.75)
	Flsh:setRGB(0.73, 0.35, 0)
	Flsh:setAlpha(0)
	Flsh:setImage(RegisterImage("uie_t7_zm_hud_notif_txtstreak"))
	Flsh:setMaterial(LUI.UIImage.GetCachedMaterial("ui_add"))
	self:addElement(Flsh)
	self.Flsh = Flsh

	local ZmAmmoParticleFX1left = CoD.ZmAmmo_ParticleFX.new(menu, controller)
	ZmAmmoParticleFX1left:setLeftRight(true, false, -17.74, 125.74)
	ZmAmmoParticleFX1left:setTopBottom(true, false, 132.89, 207.5)
	ZmAmmoParticleFX1left:setAlpha(0)
	ZmAmmoParticleFX1left:setXRot(1)
	ZmAmmoParticleFX1left:setYRot(1)
	ZmAmmoParticleFX1left:setRFTMaterial(LUI.UIImage.GetCachedMaterial("ui_add"))
	ZmAmmoParticleFX1left.p2:setAlpha(0)
	ZmAmmoParticleFX1left.p3:setAlpha(0)
	self:addElement(ZmAmmoParticleFX1left)
	self.ZmAmmoParticleFX1left = ZmAmmoParticleFX1left

	local ZmAmmoParticleFX2left = CoD.ZmAmmo_ParticleFX.new(menu, controller)
	ZmAmmoParticleFX2left:setLeftRight(true, false, -17.74, 125.74)
	ZmAmmoParticleFX2left:setTopBottom(true, false, 130.5, 205.11)
	ZmAmmoParticleFX2left:setAlpha(0)
	ZmAmmoParticleFX2left:setRFTMaterial(LUI.UIImage.GetCachedMaterial("ui_add"))
	ZmAmmoParticleFX2left.p1:setAlpha(0)
	ZmAmmoParticleFX2left.p3:setAlpha(0)
	self:addElement(ZmAmmoParticleFX2left)
	self.ZmAmmoParticleFX2left = ZmAmmoParticleFX2left

	local ZmAmmoParticleFX3left = CoD.ZmAmmo_ParticleFX.new(menu, controller)
	ZmAmmoParticleFX3left:setLeftRight(true, false, -17.74, 125.74)
	ZmAmmoParticleFX3left:setTopBottom(true, false, 131.5, 206.11)
	ZmAmmoParticleFX3left:setAlpha(0)
	ZmAmmoParticleFX3left:setRFTMaterial(LUI.UIImage.GetCachedMaterial("ui_add"))
	ZmAmmoParticleFX3left.p1:setAlpha(0)
	ZmAmmoParticleFX3left.p2:setAlpha(0)
	self:addElement(ZmAmmoParticleFX3left)
	self.ZmAmmoParticleFX3left = ZmAmmoParticleFX3left

	local ZmAmmoParticleFX1right = CoD.ZmAmmo_ParticleFX.new(menu, controller)
	ZmAmmoParticleFX1right:setLeftRight(true, false, 204.52, 348)
	ZmAmmoParticleFX1right:setTopBottom(true, false, 129, 203.6)
	ZmAmmoParticleFX1right:setAlpha(0)
	ZmAmmoParticleFX1right:setXRot(1)
	ZmAmmoParticleFX1right:setYRot(1)
	ZmAmmoParticleFX1right:setZRot(180)
	ZmAmmoParticleFX1right:setRFTMaterial(LUI.UIImage.GetCachedMaterial("ui_add"))
	ZmAmmoParticleFX1right.p2:setAlpha(0)
	ZmAmmoParticleFX1right.p3:setAlpha(0)
	self:addElement(ZmAmmoParticleFX1right)
	self.ZmAmmoParticleFX1right = ZmAmmoParticleFX1right

	local ZmAmmoParticleFX2right = CoD.ZmAmmo_ParticleFX.new(menu, controller)
	ZmAmmoParticleFX2right:setLeftRight(true, false, 204.52, 348)
	ZmAmmoParticleFX2right:setTopBottom(true, false, 126.6, 201.21)
	ZmAmmoParticleFX2right:setAlpha(0)
	ZmAmmoParticleFX2right:setZRot(180)
	ZmAmmoParticleFX2right:setRFTMaterial(LUI.UIImage.GetCachedMaterial("ui_add"))
	ZmAmmoParticleFX2right.p1:setAlpha(0)
	ZmAmmoParticleFX2right.p3:setAlpha(0)
	self:addElement(ZmAmmoParticleFX2right)
	self.ZmAmmoParticleFX2right = ZmAmmoParticleFX2right

	local ZmAmmoParticleFX3right = CoD.ZmAmmo_ParticleFX.new(menu, controller)
	ZmAmmoParticleFX3right:setLeftRight(true, false, 204.52, 348)
	ZmAmmoParticleFX3right:setTopBottom(true, false, 127.6, 202.21)
	ZmAmmoParticleFX3right:setAlpha(0)
	ZmAmmoParticleFX3right:setZRot(180)
	ZmAmmoParticleFX3right:setRFTMaterial(LUI.UIImage.GetCachedMaterial("ui_add"))
	ZmAmmoParticleFX3right.p1:setAlpha(0)
	ZmAmmoParticleFX3right.p2:setAlpha(0)
	self:addElement(ZmAmmoParticleFX3right)
	self.ZmAmmoParticleFX3right = ZmAmmoParticleFX3right

	local Lightning = LUI.UIImage.new()
	Lightning:setLeftRight(true, false, 102, 192)
	Lightning:setTopBottom(true, false, 33.21, 201.21)
	Lightning:setAlpha(0)
	Lightning:setImage(RegisterImage("uie_t7_zm_derriese_hud_notification_anim"))
	Lightning:setMaterial(LUI.UIImage.GetCachedMaterial("uie_flipbook"))
	Lightning:setShaderVector(0, 28, 0, 0, 0)
	Lightning:setShaderVector(1, 30, 0, 0, 0)
	self:addElement(Lightning)
	self.Lightning = Lightning

	local Lightning2 = LUI.UIImage.new()
	Lightning2:setLeftRight(true, false, 102, 192)
	Lightning2:setTopBottom(true, false, 33.21, 201.21)
	Lightning2:setAlpha(0)
	Lightning2:setImage(RegisterImage("uie_t7_zm_derriese_hud_notification_anim"))
	Lightning2:setMaterial(LUI.UIImage.GetCachedMaterial("uie_flipbook"))
	Lightning2:setShaderVector(0, 28, 0, 0, 0)
	Lightning2:setShaderVector(1, 30, 0, 0, 0)
	self:addElement(Lightning2)
	self.Lightning2 = Lightning2

	local Lightning3 = LUI.UIImage.new()
	Lightning3:setLeftRight(true, false, 102, 192)
	Lightning3:setTopBottom(true, false, 33.21, 201.21)
	Lightning3:setAlpha(0)
	Lightning3:setImage(RegisterImage("uie_t7_zm_derriese_hud_notification_anim"))
	Lightning3:setMaterial(LUI.UIImage.GetCachedMaterial("uie_flipbook"))
	Lightning3:setShaderVector(0, 28, 0, 0, 0)
	Lightning3:setShaderVector(1, 30, 0, 0, 0)
	self:addElement(Lightning3)
	self.Lightning3 = Lightning3

	local bgbTextureLabelBlur0 = LUI.UIText.new()
	bgbTextureLabelBlur0:setLeftRight(false, false, -46.88, 40.22)
	bgbTextureLabelBlur0:setTopBottom(true, false, 63.5, 149.5)
	bgbTextureLabelBlur0:setRGB(0.24, 0.11, 0.01)
	bgbTextureLabelBlur0:setAlpha(0)
	bgbTextureLabelBlur0:setScale(0.7)
	bgbTextureLabelBlur0:setText(Engine.Localize("MP_X2"))
	bgbTextureLabelBlur0:setTTF("fonts/FoundryGridnik-Bold.ttf")
	bgbTextureLabelBlur0:setMaterial(LUI.UIImage.GetCachedMaterial("sw4_2d_uie_font_cached_glow"))
	bgbTextureLabelBlur0:setShaderVector(0, 0.11, 0, 0, 0)
	bgbTextureLabelBlur0:setShaderVector(1, 0.94, 0, 0, 0)
	bgbTextureLabelBlur0:setShaderVector(2, 0, 0, 0, 0)
	bgbTextureLabelBlur0:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_RIGHT)
	bgbTextureLabelBlur0:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_TOP)
	self:addElement(bgbTextureLabelBlur0)
	self.bgbTextureLabelBlur0 = bgbTextureLabelBlur0

	local bgbTextureLabel0 = LUI.UIText.new()
	bgbTextureLabel0:setLeftRight(false, false, -46.88, 40.22)
	bgbTextureLabel0:setTopBottom(true, false, 63.5, 149.5)
	bgbTextureLabel0:setRGB(1, 0.89, 0.12)
	bgbTextureLabel0:setAlpha(0)
	bgbTextureLabel0:setScale(0.7)
	bgbTextureLabel0:setText(Engine.Localize("MP_X2"))
	bgbTextureLabel0:setTTF("fonts/FoundryGridnik-Bold.ttf")
	bgbTextureLabel0:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_RIGHT)
	bgbTextureLabel0:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_TOP)
	self:addElement(bgbTextureLabel0)
	self.bgbTextureLabel0 = bgbTextureLabel0

	local xpaward = CoD.ZmNotif1Factory.new(menu, controller)
	xpaward:setLeftRight(false, false, -112, 112)
	xpaward:setTopBottom(true, false, 328.5, 383.5)
	xpaward:setAlpha(0)
	xpaward.Label2:setText(Engine.Localize("GROUPS_SEARCH_SIZE_RANGE_4"))
	xpaward.Label1:setText(Engine.Localize("GROUPS_SEARCH_SIZE_RANGE_4"))
	self:addElement(xpaward)
	self.xpaward = xpaward

	local CursorHint = CoD.ZmNotif1_Notification_CursorHint.new(menu, controller)
	CursorHint:setLeftRight(true, false, -99, 413)
	CursorHint:setTopBottom(true, false, 340, 372)
	CursorHint:setAlpha(0)
	CursorHint.CursorHintText:setText("")
	self:addElement(CursorHint)
	self.CursorHint = CursorHint

	local Last5RoundTime = CoD.GameTimeWidget.new(menu, controller)
	Last5RoundTime:setLeftRight(true, false, 752, 880)
	Last5RoundTime:setTopBottom(true, false, 0, 96)
	Last5RoundTime:setAlpha(0)
	Last5RoundTime.TimeElasped:setText(Engine.Localize("DLC3_TIME_CURRENT"))
	Last5RoundTime:mergeStateConditions(
		{
			{
				stateName = "Visible",
				condition = function(menu, element, event)
					local f10_local0 = IsZombies()
					if f10_local0 then
						f10_local0 = not IsModelValueEqualTo(controller, "hudItems.time.round_complete_time", 0)
					end
					return f10_local0
				end
			}
		})
	Last5RoundTime:subscribeToModel(Engine.GetModel(Engine.GetGlobalModel(), "lobbyRoot.lobbyNav"), function(modelRef)
		menu:updateElementState(Last5RoundTime,
			{
				name = "model_validation",
				menu = menu,
				modelValue = Engine.GetModelValue(modelRef),
				modelName = "lobbyRoot.lobbyNav"
			})
	end)
	Last5RoundTime:subscribeToModel(
		Engine.GetModel(Engine.GetModelForController(controller), "hudItems.time.round_complete_time"),
		function(modelRef)
			menu:updateElementState(Last5RoundTime,
				{
					name = "model_validation",
					menu = menu,
					modelValue = Engine.GetModelValue(modelRef),
					modelName = "hudItems.time.round_complete_time"
				})
		end)
	self:addElement(Last5RoundTime)
	self.Last5RoundTime = Last5RoundTime

	self.clipsPerState =
	{
		DefaultState =
		{
			DefaultClip = function()
				self:setupElementClipCounter(17)

				PowerupBacker:completeAnimation()
				PowerupBacker:setAlpha(0)
				self.clipFinished(PowerupBacker, {})

				PowerupBackerLeft:completeAnimation()
				PowerupBackerLeft:setAlpha(0)
				self.clipFinished(PowerupBackerLeft, {})

				PowerupBackerRight:completeAnimation()
				PowerupBackerRight:setAlpha(0)
				self.clipFinished(PowerupBackerRight, {})

				PowerupTexture:completeAnimation()
				PowerupTexture:setAlpha(0)
				self.clipFinished(PowerupTexture, {})

				Panel:completeAnimation()
				self.Panel:setAlpha(0)
				self.clipFinished(Panel, {})

				basicImageBacking:beginAnimation("keyframe", 4369, false, false, CoD.TweenType.Linear)
				basicImageBacking:setAlpha(0)
				basicImageBacking:registerEventHandler("transition_complete_keyframe", self.clipFinished)

				basicImage:beginAnimation("keyframe", 4369, false, false, CoD.TweenType.Linear)
				basicImage:setAlpha(0)
				basicImage:registerEventHandler("transition_complete_keyframe", self.clipFinished)

				bgbGlowOrangeOver:completeAnimation()
				self.bgbGlowOrangeOver:setAlpha(0)
				self.clipFinished(bgbGlowOrangeOver, {})

				bgbTexture:completeAnimation()
				self.bgbTexture:setAlpha(0)
				self.clipFinished(bgbTexture, {})

				bgbAbilitySwirl:completeAnimation()
				self.bgbAbilitySwirl:setAlpha(0)
				self.clipFinished(bgbAbilitySwirl, {})

				ZmNotif1CursorHint0:completeAnimation()
				self.ZmNotif1CursorHint0:setAlpha(0)
				self.clipFinished(ZmNotif1CursorHint0, {})

				ZmNotifFactory:completeAnimation()
				self.ZmNotifFactory:setAlpha(0)
				self.clipFinished(ZmNotifFactory, {})

				Glow:completeAnimation()
				self.Glow:setAlpha(0)
				self.clipFinished(Glow, {})

				ZmFxSpark20:completeAnimation()
				self.ZmFxSpark20:setRGB(0, 0, 0)
				self.ZmFxSpark20:setAlpha(1)
				self.clipFinished(ZmFxSpark20, {})

				Flsh:completeAnimation()
				self.Flsh:setRGB(0.62, 0.22, 0)
				self.Flsh:setAlpha(0)
				self.clipFinished(Flsh, {})

				CursorHint:beginAnimation("keyframe", 3769, false, false, CoD.TweenType.Linear)
				CursorHint:setAlpha(0)
				CursorHint:registerEventHandler("transition_complete_keyframe", self.clipFinished)

				Last5RoundTime:beginAnimation("keyframe", 6780, false, false, CoD.TweenType.Linear)
				Last5RoundTime:setAlpha(0)
				Last5RoundTime:registerEventHandler("transition_complete_keyframe", self.clipFinished)
			end,
			TextandImageBGB = function()
				self:setupElementClipCounter(26)

				PowerupBacker:completeAnimation()
				PowerupBacker:setAlpha(0)
				self.clipFinished(PowerupBacker, {})

				PowerupBackerLeft:completeAnimation()
				PowerupBackerLeft:setAlpha(0)
				self.clipFinished(PowerupBackerLeft, {})

				PowerupBackerRight:completeAnimation()
				PowerupBackerRight:setAlpha(0)
				self.clipFinished(PowerupBackerRight, {})

				PowerupTexture:completeAnimation()
				PowerupTexture:setAlpha(0)
				self.clipFinished(PowerupTexture, {})

				local f14_local0 = function(f15_arg0, f15_arg1)
					local f15_local0 = function(f16_arg0, f16_arg1)
						local f16_local0 = function(f17_arg0, f17_arg1)
							if not f17_arg1.interrupted then
								f17_arg0:beginAnimation("keyframe", 680, false, false, CoD.TweenType.Linear)
							end
							f17_arg0:setAlpha(0)
							if f17_arg1.interrupted then
								self.clipFinished(f17_arg0, f17_arg1)
							else
								f17_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
							end
						end

						if f16_arg1.interrupted then
							f16_local0(f16_arg0, f16_arg1)
							return
						else
							f16_arg0:beginAnimation("keyframe", 2850, false, false, CoD.TweenType.Linear)
							f16_arg0:registerEventHandler("transition_complete_keyframe", f16_local0)
						end
					end

					if f15_arg1.interrupted then
						f15_local0(f15_arg0, f15_arg1)
						return
					else
						f15_arg0:beginAnimation("keyframe", 560, false, false, CoD.TweenType.Linear)
						f15_arg0:setAlpha(1)
						f15_arg0:registerEventHandler("transition_complete_keyframe", f15_local0)
					end
				end

				Panel:completeAnimation()
				self.Panel:setAlpha(0)
				f14_local0(Panel, {})
				basicImageBacking:completeAnimation()
				self.basicImageBacking:setAlpha(0)
				self.clipFinished(basicImageBacking, {})
				basicImage:completeAnimation()
				self.basicImage:setAlpha(0)
				self.clipFinished(basicImage, {})
				local f14_local1 = function(f18_arg0, f18_arg1)
					local f18_local0 = function(f19_arg0, f19_arg1)
						local f19_local0 = function(f20_arg0, f20_arg1)
							local f20_local0 = function(f21_arg0, f21_arg1)
								local f21_local0 = function(f22_arg0, f22_arg1)
									local f22_local0 = function(f23_arg0, f23_arg1)
										local f23_local0 = function(f24_arg0, f24_arg1)
											local f24_local0 = function(f25_arg0, f25_arg1)
												local f25_local0 = function(f26_arg0, f26_arg1)
													local f26_local0 = function(f27_arg0, f27_arg1)
														local f27_local0 = function(f28_arg0, f28_arg1)
															local f28_local0 = function(f29_arg0, f29_arg1)
																local f29_local0 = function(f30_arg0, f30_arg1)
																	if not f30_arg1.interrupted then
																		f30_arg0:beginAnimation("keyframe", 720, true,
																			false, CoD.TweenType.Bounce)
																	end
																	f30_arg0:setAlpha(0)
																	if f30_arg1.interrupted then
																		self.clipFinished(f30_arg0, f30_arg1)
																	else
																		f30_arg0:registerEventHandler(
																			"transition_complete_keyframe", self
																			.clipFinished)
																	end
																end

																if f29_arg1.interrupted then
																	f29_local0(f29_arg0, f29_arg1)
																	return
																else
																	f29_arg0:beginAnimation("keyframe", 109, false, false,
																		CoD.TweenType.Linear)
																	f29_arg0:setAlpha(0.75)
																	f29_arg0:registerEventHandler(
																		"transition_complete_keyframe", f29_local0)
																end
															end

															if f28_arg1.interrupted then
																f28_local0(f28_arg0, f28_arg1)
																return
															else
																f28_arg0:beginAnimation("keyframe", 120, false, false,
																	CoD.TweenType.Linear)
																f28_arg0:setAlpha(1)
																f28_arg0:registerEventHandler(
																	"transition_complete_keyframe", f28_local0)
															end
														end

														if f27_arg1.interrupted then
															f27_local0(f27_arg0, f27_arg1)
															return
														else
															f27_arg0:beginAnimation("keyframe", 539, false, false,
																CoD.TweenType.Linear)
															f27_arg0:setAlpha(0.8)
															f27_arg0:registerEventHandler("transition_complete_keyframe",
																f27_local0)
														end
													end

													if f26_arg1.interrupted then
														f26_local0(f26_arg0, f26_arg1)
														return
													else
														f26_arg0:beginAnimation("keyframe", 500, false, false,
															CoD.TweenType.Linear)
														f26_arg0:setAlpha(0.36)
														f26_arg0:registerEventHandler("transition_complete_keyframe",
															f26_local0)
													end
												end

												if f25_arg1.interrupted then
													f25_local0(f25_arg0, f25_arg1)
													return
												else
													f25_arg0:beginAnimation("keyframe", 519, false, false,
														CoD.TweenType.Linear)
													f25_arg0:setAlpha(0.8)
													f25_arg0:registerEventHandler("transition_complete_keyframe",
														f25_local0)
												end
											end

											if f24_arg1.interrupted then
												f24_local0(f24_arg0, f24_arg1)
												return
											else
												f24_arg0:beginAnimation("keyframe", 579, false, false,
													CoD.TweenType.Linear)
												f24_arg0:setAlpha(0.36)
												f24_arg0:registerEventHandler("transition_complete_keyframe", f24_local0)
											end
										end

										if f23_arg1.interrupted then
											f23_local0(f23_arg0, f23_arg1)
											return
										else
											f23_arg0:beginAnimation("keyframe", 480, false, false, CoD.TweenType.Linear)
											f23_arg0:setAlpha(0.8)
											f23_arg0:registerEventHandler("transition_complete_keyframe", f23_local0)
										end
									end

									if f22_arg1.interrupted then
										f22_local0(f22_arg0, f22_arg1)
										return
									else
										f22_arg0:beginAnimation("keyframe", 340, false, false, CoD.TweenType.Linear)
										f22_arg0:setAlpha(0.33)
										f22_arg0:registerEventHandler("transition_complete_keyframe", f22_local0)
									end
								end

								if f21_arg1.interrupted then
									f21_local0(f21_arg0, f21_arg1)
									return
								else
									f21_arg0:beginAnimation("keyframe", 60, false, false, CoD.TweenType.Linear)
									f21_arg0:setAlpha(0.75)
									f21_arg0:registerEventHandler("transition_complete_keyframe", f21_local0)
								end
							end

							if f20_arg1.interrupted then
								f20_local0(f20_arg0, f20_arg1)
								return
							else
								f20_arg0:beginAnimation("keyframe", 60, false, false, CoD.TweenType.Linear)
								f20_arg0:setAlpha(1)
								f20_arg0:registerEventHandler("transition_complete_keyframe", f20_local0)
							end
						end

						if f19_arg1.interrupted then
							f19_local0(f19_arg0, f19_arg1)
							return
						else
							f19_arg0:beginAnimation("keyframe", 159, true, false, CoD.TweenType.Bounce)
							f19_arg0:setAlpha(0.75)
							f19_arg0:registerEventHandler("transition_complete_keyframe", f19_local0)
						end
					end

					if f18_arg1.interrupted then
						f18_local0(f18_arg0, f18_arg1)
						return
					else
						f18_arg0:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Linear)
						f18_arg0:registerEventHandler("transition_complete_keyframe", f18_local0)
					end
				end

				bgbGlowOrangeOver:completeAnimation()
				self.bgbGlowOrangeOver:setAlpha(0)
				f14_local1(bgbGlowOrangeOver, {})
				local f14_local2 = function(f31_arg0, f31_arg1)
					local f31_local0 = function(f32_arg0, f32_arg1)
						local f32_local0 = function(f33_arg0, f33_arg1)
							local f33_local0 = function(f34_arg0, f34_arg1)
								local f34_local0 = function(f35_arg0, f35_arg1)
									local f35_local0 = function(f36_arg0, f36_arg1)
										local f36_local0 = function(f37_arg0, f37_arg1)
											local f37_local0 = function(f38_arg0, f38_arg1)
												if not f38_arg1.interrupted then
													f38_arg0:beginAnimation("keyframe", 39, false, false,
														CoD.TweenType.Linear)
												end
												f38_arg0:setAlpha(0)
												f38_arg0:setScale(0.5)
												if f38_arg1.interrupted then
													self.clipFinished(f38_arg0, f38_arg1)
												else
													f38_arg0:registerEventHandler("transition_complete_keyframe",
														self.clipFinished)
												end
											end

											if f37_arg1.interrupted then
												f37_local0(f37_arg0, f37_arg1)
												return
											else
												f37_arg0:beginAnimation("keyframe", 340, false, false,
													CoD.TweenType.Linear)
												f37_arg0:setAlpha(0)
												f37_arg0:setScale(0.57)
												f37_arg0:registerEventHandler("transition_complete_keyframe", f37_local0)
											end
										end

										if f36_arg1.interrupted then
											f36_local0(f36_arg0, f36_arg1)
											return
										else
											f36_arg0:beginAnimation("keyframe", 99, false, false, CoD.TweenType.Linear)
											f36_arg0:setAlpha(0.77)
											f36_arg0:setScale(1.2)
											f36_arg0:registerEventHandler("transition_complete_keyframe", f36_local0)
										end
									end

									if f35_arg1.interrupted then
										f35_local0(f35_arg0, f35_arg1)
										return
									else
										f35_arg0:beginAnimation("keyframe", 29, false, false, CoD.TweenType.Linear)
										f35_arg0:setScale(0.82)
										f35_arg0:registerEventHandler("transition_complete_keyframe", f35_local0)
									end
								end

								if f34_arg1.interrupted then
									f34_local0(f34_arg0, f34_arg1)
									return
								else
									f34_arg0:beginAnimation("keyframe", 3170, false, false, CoD.TweenType.Linear)
									f34_arg0:registerEventHandler("transition_complete_keyframe", f34_local0)
								end
							end

							if f33_arg1.interrupted then
								f33_local0(f33_arg0, f33_arg1)
								return
							else
								f33_arg0:beginAnimation("keyframe", 40, false, false, CoD.TweenType.Linear)
								f33_arg0:setScale(0.7)
								f33_arg0:registerEventHandler("transition_complete_keyframe", f33_local0)
							end
						end

						if f32_arg1.interrupted then
							f32_local0(f32_arg0, f32_arg1)
							return
						else
							f32_arg0:beginAnimation("keyframe", 159, false, false, CoD.TweenType.Linear)
							f32_arg0:setAlpha(1)
							f32_arg0:setScale(1.2)
							f32_arg0:registerEventHandler("transition_complete_keyframe", f32_local0)
						end
					end

					if f31_arg1.interrupted then
						f31_local0(f31_arg0, f31_arg1)
						return
					else
						f31_arg0:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Linear)
						f31_arg0:registerEventHandler("transition_complete_keyframe", f31_local0)
					end
				end

				bgbTexture:completeAnimation()
				self.bgbTexture:setAlpha(0)
				self.bgbTexture:setScale(0.5)
				f14_local2(bgbTexture, {})
				local f14_local3 = function(f39_arg0, f39_arg1)
					local f39_local0 = function(f40_arg0, f40_arg1)
						if not f40_arg1.interrupted then
							f40_arg0:beginAnimation("keyframe", 139, false, false, CoD.TweenType.Linear)
						end
						f40_arg0:setAlpha(0)
						f40_arg0:setZRot(360)
						f40_arg0:setScale(1.7)
						if f40_arg1.interrupted then
							self.clipFinished(f40_arg0, f40_arg1)
						else
							f40_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
						end
					end

					if f39_arg1.interrupted then
						f39_local0(f39_arg0, f39_arg1)
						return
					else
						f39_arg0:beginAnimation("keyframe", 280, false, false, CoD.TweenType.Linear)
						f39_arg0:setAlpha(0.8)
						f39_arg0:setZRot(240)
						f39_arg0:setScale(1.7)
						f39_arg0:registerEventHandler("transition_complete_keyframe", f39_local0)
					end
				end

				bgbAbilitySwirl:completeAnimation()
				self.bgbAbilitySwirl:setAlpha(0)
				self.bgbAbilitySwirl:setZRot(0)
				self.bgbAbilitySwirl:setScale(1)
				f14_local3(bgbAbilitySwirl, {})
				local f14_local4 = function(f41_arg0, f41_arg1)
					local f41_local0 = function(f42_arg0, f42_arg1)
						local f42_local0 = function(f43_arg0, f43_arg1)
							local f43_local0 = function(f44_arg0, f44_arg1)
								if not f44_arg1.interrupted then
									f44_arg0:beginAnimation("keyframe", 1069, false, false, CoD.TweenType.Linear)
								end
								f44_arg0:setAlpha(0)
								if f44_arg1.interrupted then
									self.clipFinished(f44_arg0, f44_arg1)
								else
									f44_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
								end
							end

							if f43_arg1.interrupted then
								f43_local0(f43_arg0, f43_arg1)
								return
							else
								f43_arg0:beginAnimation("keyframe", 2849, false, false, CoD.TweenType.Linear)
								f43_arg0:registerEventHandler("transition_complete_keyframe", f43_local0)
							end
						end

						if f42_arg1.interrupted then
							f42_local0(f42_arg0, f42_arg1)
							return
						else
							f42_arg0:beginAnimation("keyframe", 329, false, false, CoD.TweenType.Bounce)
							f42_arg0:setAlpha(1)
							f42_arg0:registerEventHandler("transition_complete_keyframe", f42_local0)
						end
					end

					if f41_arg1.interrupted then
						f41_local0(f41_arg0, f41_arg1)
						return
					else
						f41_arg0:beginAnimation("keyframe", 119, false, false, CoD.TweenType.Linear)
						f41_arg0:registerEventHandler("transition_complete_keyframe", f41_local0)
					end
				end

				ZmNotif1CursorHint0:completeAnimation()
				self.ZmNotif1CursorHint0:setAlpha(0)
				f14_local4(ZmNotif1CursorHint0, {})
				local f14_local5 = function(f45_arg0, f45_arg1)
					local f45_local0 = function(f46_arg0, f46_arg1)
						local f46_local0 = function(f47_arg0, f47_arg1)
							if not f47_arg1.interrupted then
								f47_arg0:beginAnimation("keyframe", 869, false, false, CoD.TweenType.Bounce)
							end
							f47_arg0:setAlpha(0)
							if f47_arg1.interrupted then
								self.clipFinished(f47_arg0, f47_arg1)
							else
								f47_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
							end
						end

						if f46_arg1.interrupted then
							f46_local0(f46_arg0, f46_arg1)
							return
						else
							f46_arg0:beginAnimation("keyframe", 3240, false, false, CoD.TweenType.Linear)
							f46_arg0:registerEventHandler("transition_complete_keyframe", f46_local0)
						end
					end

					if f45_arg1.interrupted then
						f45_local0(f45_arg0, f45_arg1)
						return
					else
						f45_arg0:beginAnimation("keyframe", 259, false, false, CoD.TweenType.Bounce)
						f45_arg0:setAlpha(1)
						f45_arg0:registerEventHandler("transition_complete_keyframe", f45_local0)
					end
				end

				ZmNotifFactory:completeAnimation()
				self.ZmNotifFactory:setAlpha(0)
				f14_local5(ZmNotifFactory, {})
				local f14_local6 = function(f48_arg0, f48_arg1)
					local f48_local0 = function(f49_arg0, f49_arg1)
						local f49_local0 = function(f50_arg0, f50_arg1)
							if not f50_arg1.interrupted then
								f50_arg0:beginAnimation("keyframe", 800, false, false, CoD.TweenType.Linear)
							end
							f50_arg0:setRGB(0, 0.04, 1)
							f50_arg0:setAlpha(0)
							if f50_arg1.interrupted then
								self.clipFinished(f50_arg0, f50_arg1)
							else
								f50_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
							end
						end

						if f49_arg1.interrupted then
							f49_local0(f49_arg0, f49_arg1)
							return
						else
							f49_arg0:beginAnimation("keyframe", 3359, false, false, CoD.TweenType.Linear)
							f49_arg0:registerEventHandler("transition_complete_keyframe", f49_local0)
						end
					end

					if f48_arg1.interrupted then
						f48_local0(f48_arg0, f48_arg1)
						return
					else
						f48_arg0:beginAnimation("keyframe", 140, false, false, CoD.TweenType.Bounce)
						f48_arg0:setAlpha(1)
						f48_arg0:registerEventHandler("transition_complete_keyframe", f48_local0)
					end
				end

				Glow:completeAnimation()
				self.Glow:setRGB(0, 0.04, 1)
				self.Glow:setAlpha(0)
				f14_local6(Glow, {})
				ZmFxSpark20:completeAnimation()
				self.ZmFxSpark20:setAlpha(0)
				self.clipFinished(ZmFxSpark20, {})
				local f14_local7 = function(f51_arg0, f51_arg1)
					local f51_local0 = function(f52_arg0, f52_arg1)
						if not f52_arg1.interrupted then
							f52_arg0:beginAnimation("keyframe", 609, false, false, CoD.TweenType.Bounce)
						end
						f52_arg0:setLeftRight(false, false, -219.65, 219.34)
						f52_arg0:setTopBottom(true, false, 146.25, 180.75)
						f52_arg0:setRGB(0, 0.34, 1)
						f52_arg0:setAlpha(0)
						if f52_arg1.interrupted then
							self.clipFinished(f52_arg0, f52_arg1)
						else
							f52_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
						end
					end

					if f51_arg1.interrupted then
						f51_local0(f51_arg0, f51_arg1)
						return
					else
						f51_arg0:beginAnimation("keyframe", 39, false, false, CoD.TweenType.Linear)
						f51_arg0:setRGB(0, 0.89, 1)
						f51_arg0:setAlpha(1)
						f51_arg0:registerEventHandler("transition_complete_keyframe", f51_local0)
					end
				end

				Flsh:completeAnimation()
				self.Flsh:setLeftRight(false, false, -219.65, 219.34)
				self.Flsh:setTopBottom(true, false, 146.25, 180.75)
				self.Flsh:setRGB(0, 0.33, 1)
				self.Flsh:setAlpha(0.36)
				f14_local7(Flsh, {})
				local f14_local8 = function(f53_arg0, f53_arg1)
					local f53_local0 = function(f54_arg0, f54_arg1)
						local f54_local0 = function(f55_arg0, f55_arg1)
							if not f55_arg1.interrupted then
								f55_arg0:beginAnimation("keyframe", 440, false, false, CoD.TweenType.Linear)
							end
							f55_arg0:setAlpha(0)
							if f55_arg1.interrupted then
								self.clipFinished(f55_arg0, f55_arg1)
							else
								f55_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
							end
						end

						if f54_arg1.interrupted then
							f54_local0(f54_arg0, f54_arg1)
							return
						else
							f54_arg0:beginAnimation("keyframe", 3720, false, false, CoD.TweenType.Linear)
							f54_arg0:registerEventHandler("transition_complete_keyframe", f54_local0)
						end
					end

					if f53_arg1.interrupted then
						f53_local0(f53_arg0, f53_arg1)
						return
					else
						f53_arg0:beginAnimation("keyframe", 90, false, false, CoD.TweenType.Linear)
						f53_arg0:setAlpha(1)
						f53_arg0:registerEventHandler("transition_complete_keyframe", f53_local0)
					end
				end

				ZmAmmoParticleFX1left:completeAnimation()
				self.ZmAmmoParticleFX1left:setAlpha(0)
				f14_local8(ZmAmmoParticleFX1left, {})
				local f14_local9 = function(f56_arg0, f56_arg1)
					local f56_local0 = function(f57_arg0, f57_arg1)
						local f57_local0 = function(f58_arg0, f58_arg1)
							if not f58_arg1.interrupted then
								f58_arg0:beginAnimation("keyframe", 440, false, false, CoD.TweenType.Linear)
							end
							f58_arg0:setAlpha(0)
							if f58_arg1.interrupted then
								self.clipFinished(f58_arg0, f58_arg1)
							else
								f58_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
							end
						end

						if f57_arg1.interrupted then
							f57_local0(f57_arg0, f57_arg1)
							return
						else
							f57_arg0:beginAnimation("keyframe", 3720, false, false, CoD.TweenType.Linear)
							f57_arg0:registerEventHandler("transition_complete_keyframe", f57_local0)
						end
					end

					if f56_arg1.interrupted then
						f56_local0(f56_arg0, f56_arg1)
						return
					else
						f56_arg0:beginAnimation("keyframe", 90, false, false, CoD.TweenType.Linear)
						f56_arg0:setAlpha(1)
						f56_arg0:registerEventHandler("transition_complete_keyframe", f56_local0)
					end
				end

				ZmAmmoParticleFX2left:completeAnimation()
				self.ZmAmmoParticleFX2left:setAlpha(0)
				f14_local9(ZmAmmoParticleFX2left, {})
				local f14_local10 = function(f59_arg0, f59_arg1)
					local f59_local0 = function(f60_arg0, f60_arg1)
						local f60_local0 = function(f61_arg0, f61_arg1)
							if not f61_arg1.interrupted then
								f61_arg0:beginAnimation("keyframe", 440, false, false, CoD.TweenType.Linear)
							end
							f61_arg0:setAlpha(0)
							if f61_arg1.interrupted then
								self.clipFinished(f61_arg0, f61_arg1)
							else
								f61_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
							end
						end

						if f60_arg1.interrupted then
							f60_local0(f60_arg0, f60_arg1)
							return
						else
							f60_arg0:beginAnimation("keyframe", 3720, false, false, CoD.TweenType.Linear)
							f60_arg0:registerEventHandler("transition_complete_keyframe", f60_local0)
						end
					end

					if f59_arg1.interrupted then
						f59_local0(f59_arg0, f59_arg1)
						return
					else
						f59_arg0:beginAnimation("keyframe", 90, false, false, CoD.TweenType.Linear)
						f59_arg0:setAlpha(1)
						f59_arg0:registerEventHandler("transition_complete_keyframe", f59_local0)
					end
				end

				ZmAmmoParticleFX3left:completeAnimation()
				self.ZmAmmoParticleFX3left:setAlpha(0)
				f14_local10(ZmAmmoParticleFX3left, {})
				local f14_local11 = function(f62_arg0, f62_arg1)
					local f62_local0 = function(f63_arg0, f63_arg1)
						local f63_local0 = function(f64_arg0, f64_arg1)
							if not f64_arg1.interrupted then
								f64_arg0:beginAnimation("keyframe", 440, false, false, CoD.TweenType.Linear)
							end
							f64_arg0:setLeftRight(true, false, 204.52, 348)
							f64_arg0:setTopBottom(true, false, 129, 203.6)
							f64_arg0:setAlpha(0)
							f64_arg0:setZRot(180)
							if f64_arg1.interrupted then
								self.clipFinished(f64_arg0, f64_arg1)
							else
								f64_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
							end
						end

						if f63_arg1.interrupted then
							f63_local0(f63_arg0, f63_arg1)
							return
						else
							f63_arg0:beginAnimation("keyframe", 3720, false, false, CoD.TweenType.Linear)
							f63_arg0:registerEventHandler("transition_complete_keyframe", f63_local0)
						end
					end

					if f62_arg1.interrupted then
						f62_local0(f62_arg0, f62_arg1)
						return
					else
						f62_arg0:beginAnimation("keyframe", 90, false, false, CoD.TweenType.Linear)
						f62_arg0:setAlpha(1)
						f62_arg0:registerEventHandler("transition_complete_keyframe", f62_local0)
					end
				end

				ZmAmmoParticleFX1right:completeAnimation()
				self.ZmAmmoParticleFX1right:setLeftRight(true, false, 204.52, 348)
				self.ZmAmmoParticleFX1right:setTopBottom(true, false, 129, 203.6)
				self.ZmAmmoParticleFX1right:setAlpha(0)
				self.ZmAmmoParticleFX1right:setZRot(180)
				f14_local11(ZmAmmoParticleFX1right, {})
				local f14_local12 = function(f65_arg0, f65_arg1)
					local f65_local0 = function(f66_arg0, f66_arg1)
						local f66_local0 = function(f67_arg0, f67_arg1)
							if not f67_arg1.interrupted then
								f67_arg0:beginAnimation("keyframe", 440, false, false, CoD.TweenType.Linear)
							end
							f67_arg0:setLeftRight(true, false, 204.52, 348)
							f67_arg0:setTopBottom(true, false, 126.6, 201.21)
							f67_arg0:setAlpha(0)
							f67_arg0:setZRot(180)
							if f67_arg1.interrupted then
								self.clipFinished(f67_arg0, f67_arg1)
							else
								f67_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
							end
						end

						if f66_arg1.interrupted then
							f66_local0(f66_arg0, f66_arg1)
							return
						else
							f66_arg0:beginAnimation("keyframe", 3720, false, false, CoD.TweenType.Linear)
							f66_arg0:registerEventHandler("transition_complete_keyframe", f66_local0)
						end
					end

					if f65_arg1.interrupted then
						f65_local0(f65_arg0, f65_arg1)
						return
					else
						f65_arg0:beginAnimation("keyframe", 90, false, false, CoD.TweenType.Linear)
						f65_arg0:setAlpha(1)
						f65_arg0:registerEventHandler("transition_complete_keyframe", f65_local0)
					end
				end

				ZmAmmoParticleFX2right:completeAnimation()
				self.ZmAmmoParticleFX2right:setLeftRight(true, false, 204.52, 348)
				self.ZmAmmoParticleFX2right:setTopBottom(true, false, 126.6, 201.21)
				self.ZmAmmoParticleFX2right:setAlpha(0)
				self.ZmAmmoParticleFX2right:setZRot(180)
				f14_local12(ZmAmmoParticleFX2right, {})
				local f14_local13 = function(f68_arg0, f68_arg1)
					local f68_local0 = function(f69_arg0, f69_arg1)
						local f69_local0 = function(f70_arg0, f70_arg1)
							if not f70_arg1.interrupted then
								f70_arg0:beginAnimation("keyframe", 440, false, false, CoD.TweenType.Linear)
							end
							f70_arg0:setLeftRight(true, false, 204.52, 348)
							f70_arg0:setTopBottom(true, false, 127.6, 202.21)
							f70_arg0:setAlpha(0)
							f70_arg0:setZRot(180)
							if f70_arg1.interrupted then
								self.clipFinished(f70_arg0, f70_arg1)
							else
								f70_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
							end
						end

						if f69_arg1.interrupted then
							f69_local0(f69_arg0, f69_arg1)
							return
						else
							f69_arg0:beginAnimation("keyframe", 3720, false, false, CoD.TweenType.Linear)
							f69_arg0:setAlpha(0)
							f69_arg0:registerEventHandler("transition_complete_keyframe", f69_local0)
						end
					end

					if f68_arg1.interrupted then
						f68_local0(f68_arg0, f68_arg1)
						return
					else
						f68_arg0:beginAnimation("keyframe", 90, false, false, CoD.TweenType.Linear)
						f68_arg0:registerEventHandler("transition_complete_keyframe", f68_local0)
					end
				end

				ZmAmmoParticleFX3right:completeAnimation()
				self.ZmAmmoParticleFX3right:setLeftRight(true, false, 204.52, 348)
				self.ZmAmmoParticleFX3right:setTopBottom(true, false, 127.6, 202.21)
				self.ZmAmmoParticleFX3right:setAlpha(1)
				self.ZmAmmoParticleFX3right:setZRot(180)
				f14_local13(ZmAmmoParticleFX3right, {})
				local f14_local14 = function(f71_arg0, f71_arg1)
					local f71_local0 = function(f72_arg0, f72_arg1)
						local f72_local0 = function(f73_arg0, f73_arg1)
							local f73_local0 = function(f74_arg0, f74_arg1)
								if not f74_arg1.interrupted then
									f74_arg0:beginAnimation("keyframe", 679, false, false, CoD.TweenType.Linear)
								end
								f74_arg0:setLeftRight(true, false, 38.67, 280)
								f74_arg0:setTopBottom(true, false, -22.5, 193.5)
								f74_arg0:setAlpha(0)
								if f74_arg1.interrupted then
									self.clipFinished(f74_arg0, f74_arg1)
								else
									f74_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
								end
							end

							if f73_arg1.interrupted then
								f73_local0(f73_arg0, f73_arg1)
								return
							else
								f73_arg0:beginAnimation("keyframe", 150, false, false, CoD.TweenType.Linear)
								f73_arg0:registerEventHandler("transition_complete_keyframe", f73_local0)
							end
						end

						if f72_arg1.interrupted then
							f72_local0(f72_arg0, f72_arg1)
							return
						else
							f72_arg0:beginAnimation("keyframe", 109, false, false, CoD.TweenType.Linear)
							f72_arg0:setAlpha(1)
							f72_arg0:registerEventHandler("transition_complete_keyframe", f72_local0)
						end
					end

					if f71_arg1.interrupted then
						f71_local0(f71_arg0, f71_arg1)
						return
					else
						f71_arg0:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Linear)
						f71_arg0:registerEventHandler("transition_complete_keyframe", f71_local0)
					end
				end

				Lightning:completeAnimation()
				self.Lightning:setLeftRight(true, false, 38.67, 280)
				self.Lightning:setTopBottom(true, false, -22.5, 193.5)
				self.Lightning:setAlpha(0)
				f14_local14(Lightning, {})
				Lightning2:completeAnimation()
				self.Lightning2:setAlpha(0)
				self.clipFinished(Lightning2, {})
				Lightning3:completeAnimation()
				self.Lightning3:setAlpha(0)
				self.clipFinished(Lightning3, {})
				CursorHint:beginAnimation("keyframe", 3769, false, false, CoD.TweenType.Linear)
				CursorHint:setAlpha(0)
				CursorHint:registerEventHandler("transition_complete_keyframe", self.clipFinished)
				Last5RoundTime:completeAnimation()
				self.Last5RoundTime:setAlpha(0)
				self.clipFinished(Last5RoundTime, {})
			end,
			TextandImageBGBToken = function()
				self:setupElementClipCounter(28)

				PowerupBacker:completeAnimation()
				PowerupBacker:setAlpha(0)
				self.clipFinished(PowerupBacker, {})

				PowerupBackerLeft:completeAnimation()
				PowerupBackerLeft:setAlpha(0)
				self.clipFinished(PowerupBackerLeft, {})

				PowerupBackerRight:completeAnimation()
				PowerupBackerRight:setAlpha(0)
				self.clipFinished(PowerupBackerRight, {})

				PowerupTexture:completeAnimation()
				PowerupTexture:setAlpha(0)
				self.clipFinished(PowerupTexture, {})

				local f75_local0 = function(f76_arg0, f76_arg1)
					local f76_local0 = function(f77_arg0, f77_arg1)
						local f77_local0 = function(f78_arg0, f78_arg1)
							if not f78_arg1.interrupted then
								f78_arg0:beginAnimation("keyframe", 680, false, false, CoD.TweenType.Linear)
							end
							f78_arg0:setAlpha(0)
							if f78_arg1.interrupted then
								self.clipFinished(f78_arg0, f78_arg1)
							else
								f78_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
							end
						end

						if f77_arg1.interrupted then
							f77_local0(f77_arg0, f77_arg1)
							return
						else
							f77_arg0:beginAnimation("keyframe", 2850, false, false, CoD.TweenType.Linear)
							f77_arg0:registerEventHandler("transition_complete_keyframe", f77_local0)
						end
					end

					if f76_arg1.interrupted then
						f76_local0(f76_arg0, f76_arg1)
						return
					else
						f76_arg0:beginAnimation("keyframe", 560, false, false, CoD.TweenType.Linear)
						f76_arg0:setAlpha(1)
						f76_arg0:registerEventHandler("transition_complete_keyframe", f76_local0)
					end
				end

				Panel:completeAnimation()
				self.Panel:setAlpha(0)
				f75_local0(Panel, {})
				basicImageBacking:completeAnimation()
				self.basicImageBacking:setAlpha(0)
				self.clipFinished(basicImageBacking, {})
				basicImage:completeAnimation()
				self.basicImage:setAlpha(0)
				self.clipFinished(basicImage, {})
				local f75_local1 = function(f79_arg0, f79_arg1)
					local f79_local0 = function(f80_arg0, f80_arg1)
						local f80_local0 = function(f81_arg0, f81_arg1)
							local f81_local0 = function(f82_arg0, f82_arg1)
								local f82_local0 = function(f83_arg0, f83_arg1)
									local f83_local0 = function(f84_arg0, f84_arg1)
										local f84_local0 = function(f85_arg0, f85_arg1)
											local f85_local0 = function(f86_arg0, f86_arg1)
												local f86_local0 = function(f87_arg0, f87_arg1)
													local f87_local0 = function(f88_arg0, f88_arg1)
														local f88_local0 = function(f89_arg0, f89_arg1)
															local f89_local0 = function(f90_arg0, f90_arg1)
																local f90_local0 = function(f91_arg0, f91_arg1)
																	if not f91_arg1.interrupted then
																		f91_arg0:beginAnimation("keyframe", 720, true,
																			false, CoD.TweenType.Bounce)
																	end
																	f91_arg0:setAlpha(0)
																	if f91_arg1.interrupted then
																		self.clipFinished(f91_arg0, f91_arg1)
																	else
																		f91_arg0:registerEventHandler(
																			"transition_complete_keyframe", self
																			.clipFinished)
																	end
																end

																if f90_arg1.interrupted then
																	f90_local0(f90_arg0, f90_arg1)
																	return
																else
																	f90_arg0:beginAnimation("keyframe", 109, false, false,
																		CoD.TweenType.Linear)
																	f90_arg0:setAlpha(0.75)
																	f90_arg0:registerEventHandler(
																		"transition_complete_keyframe", f90_local0)
																end
															end

															if f89_arg1.interrupted then
																f89_local0(f89_arg0, f89_arg1)
																return
															else
																f89_arg0:beginAnimation("keyframe", 120, false, false,
																	CoD.TweenType.Linear)
																f89_arg0:setAlpha(1)
																f89_arg0:registerEventHandler(
																	"transition_complete_keyframe", f89_local0)
															end
														end

														if f88_arg1.interrupted then
															f88_local0(f88_arg0, f88_arg1)
															return
														else
															f88_arg0:beginAnimation("keyframe", 539, false, false,
																CoD.TweenType.Linear)
															f88_arg0:setAlpha(0.8)
															f88_arg0:registerEventHandler("transition_complete_keyframe",
																f88_local0)
														end
													end

													if f87_arg1.interrupted then
														f87_local0(f87_arg0, f87_arg1)
														return
													else
														f87_arg0:beginAnimation("keyframe", 500, false, false,
															CoD.TweenType.Linear)
														f87_arg0:setAlpha(0.36)
														f87_arg0:registerEventHandler("transition_complete_keyframe",
															f87_local0)
													end
												end

												if f86_arg1.interrupted then
													f86_local0(f86_arg0, f86_arg1)
													return
												else
													f86_arg0:beginAnimation("keyframe", 519, false, false,
														CoD.TweenType.Linear)
													f86_arg0:setAlpha(0.8)
													f86_arg0:registerEventHandler("transition_complete_keyframe",
														f86_local0)
												end
											end

											if f85_arg1.interrupted then
												f85_local0(f85_arg0, f85_arg1)
												return
											else
												f85_arg0:beginAnimation("keyframe", 579, false, false,
													CoD.TweenType.Linear)
												f85_arg0:setAlpha(0.36)
												f85_arg0:registerEventHandler("transition_complete_keyframe", f85_local0)
											end
										end

										if f84_arg1.interrupted then
											f84_local0(f84_arg0, f84_arg1)
											return
										else
											f84_arg0:beginAnimation("keyframe", 480, false, false, CoD.TweenType.Linear)
											f84_arg0:setAlpha(0.8)
											f84_arg0:registerEventHandler("transition_complete_keyframe", f84_local0)
										end
									end

									if f83_arg1.interrupted then
										f83_local0(f83_arg0, f83_arg1)
										return
									else
										f83_arg0:beginAnimation("keyframe", 340, false, false, CoD.TweenType.Linear)
										f83_arg0:setAlpha(0.33)
										f83_arg0:registerEventHandler("transition_complete_keyframe", f83_local0)
									end
								end

								if f82_arg1.interrupted then
									f82_local0(f82_arg0, f82_arg1)
									return
								else
									f82_arg0:beginAnimation("keyframe", 60, false, false, CoD.TweenType.Linear)
									f82_arg0:setAlpha(0.75)
									f82_arg0:registerEventHandler("transition_complete_keyframe", f82_local0)
								end
							end

							if f81_arg1.interrupted then
								f81_local0(f81_arg0, f81_arg1)
								return
							else
								f81_arg0:beginAnimation("keyframe", 60, false, false, CoD.TweenType.Linear)
								f81_arg0:setAlpha(1)
								f81_arg0:registerEventHandler("transition_complete_keyframe", f81_local0)
							end
						end

						if f80_arg1.interrupted then
							f80_local0(f80_arg0, f80_arg1)
							return
						else
							f80_arg0:beginAnimation("keyframe", 159, true, false, CoD.TweenType.Bounce)
							f80_arg0:setAlpha(0.75)
							f80_arg0:registerEventHandler("transition_complete_keyframe", f80_local0)
						end
					end

					if f79_arg1.interrupted then
						f79_local0(f79_arg0, f79_arg1)
						return
					else
						f79_arg0:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Linear)
						f79_arg0:registerEventHandler("transition_complete_keyframe", f79_local0)
					end
				end

				bgbGlowOrangeOver:completeAnimation()
				self.bgbGlowOrangeOver:setAlpha(0)
				f75_local1(bgbGlowOrangeOver, {})
				local f75_local2 = function(f92_arg0, f92_arg1)
					local f92_local0 = function(f93_arg0, f93_arg1)
						local f93_local0 = function(f94_arg0, f94_arg1)
							local f94_local0 = function(f95_arg0, f95_arg1)
								local f95_local0 = function(f96_arg0, f96_arg1)
									local f96_local0 = function(f97_arg0, f97_arg1)
										local f97_local0 = function(f98_arg0, f98_arg1)
											local f98_local0 = function(f99_arg0, f99_arg1)
												if not f99_arg1.interrupted then
													f99_arg0:beginAnimation("keyframe", 39, false, false,
														CoD.TweenType.Linear)
												end
												f99_arg0:setAlpha(0)
												f99_arg0:setScale(0.5)
												if f99_arg1.interrupted then
													self.clipFinished(f99_arg0, f99_arg1)
												else
													f99_arg0:registerEventHandler("transition_complete_keyframe",
														self.clipFinished)
												end
											end

											if f98_arg1.interrupted then
												f98_local0(f98_arg0, f98_arg1)
												return
											else
												f98_arg0:beginAnimation("keyframe", 340, false, false,
													CoD.TweenType.Linear)
												f98_arg0:setAlpha(0)
												f98_arg0:setScale(0.57)
												f98_arg0:registerEventHandler("transition_complete_keyframe", f98_local0)
											end
										end

										if f97_arg1.interrupted then
											f97_local0(f97_arg0, f97_arg1)
											return
										else
											f97_arg0:beginAnimation("keyframe", 99, false, false, CoD.TweenType.Linear)
											f97_arg0:setAlpha(0.77)
											f97_arg0:setScale(1.2)
											f97_arg0:registerEventHandler("transition_complete_keyframe", f97_local0)
										end
									end

									if f96_arg1.interrupted then
										f96_local0(f96_arg0, f96_arg1)
										return
									else
										f96_arg0:beginAnimation("keyframe", 29, false, false, CoD.TweenType.Linear)
										f96_arg0:setScale(0.82)
										f96_arg0:registerEventHandler("transition_complete_keyframe", f96_local0)
									end
								end

								if f95_arg1.interrupted then
									f95_local0(f95_arg0, f95_arg1)
									return
								else
									f95_arg0:beginAnimation("keyframe", 3170, false, false, CoD.TweenType.Linear)
									f95_arg0:registerEventHandler("transition_complete_keyframe", f95_local0)
								end
							end

							if f94_arg1.interrupted then
								f94_local0(f94_arg0, f94_arg1)
								return
							else
								f94_arg0:beginAnimation("keyframe", 40, false, false, CoD.TweenType.Linear)
								f94_arg0:setScale(0.7)
								f94_arg0:registerEventHandler("transition_complete_keyframe", f94_local0)
							end
						end

						if f93_arg1.interrupted then
							f93_local0(f93_arg0, f93_arg1)
							return
						else
							f93_arg0:beginAnimation("keyframe", 159, false, false, CoD.TweenType.Linear)
							f93_arg0:setAlpha(1)
							f93_arg0:setScale(1.2)
							f93_arg0:registerEventHandler("transition_complete_keyframe", f93_local0)
						end
					end

					if f92_arg1.interrupted then
						f92_local0(f92_arg0, f92_arg1)
						return
					else
						f92_arg0:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Linear)
						f92_arg0:registerEventHandler("transition_complete_keyframe", f92_local0)
					end
				end

				bgbTexture:completeAnimation()
				self.bgbTexture:setAlpha(0)
				self.bgbTexture:setScale(0.5)
				f75_local2(bgbTexture, {})
				local f75_local3 = function(f100_arg0, f100_arg1)
					local f100_local0 = function(f101_arg0, f101_arg1)
						local f101_local0 = function(f102_arg0, f102_arg1)
							local f102_local0 = function(f103_arg0, f103_arg1)
								local f103_local0 = function(f104_arg0, f104_arg1)
									local f104_local0 = function(f105_arg0, f105_arg1)
										local f105_local0 = function(f106_arg0, f106_arg1)
											local f106_local0 = function(f107_arg0, f107_arg1)
												if not f107_arg1.interrupted then
													f107_arg0:beginAnimation("keyframe", 39, false, false,
														CoD.TweenType.Linear)
												end
												f107_arg0:setAlpha(0)
												f107_arg0:setScale(0.5)
												if f107_arg1.interrupted then
													self.clipFinished(f107_arg0, f107_arg1)
												else
													f107_arg0:registerEventHandler("transition_complete_keyframe",
														self.clipFinished)
												end
											end

											if f106_arg1.interrupted then
												f106_local0(f106_arg0, f106_arg1)
												return
											else
												f106_arg0:beginAnimation("keyframe", 340, false, false,
													CoD.TweenType.Linear)
												f106_arg0:setAlpha(0)
												f106_arg0:setScale(0.57)
												f106_arg0:registerEventHandler("transition_complete_keyframe",
													f106_local0)
											end
										end

										if f105_arg1.interrupted then
											f105_local0(f105_arg0, f105_arg1)
											return
										else
											f105_arg0:beginAnimation("keyframe", 99, false, false, CoD.TweenType.Linear)
											f105_arg0:setAlpha(0.77)
											f105_arg0:setScale(1.2)
											f105_arg0:registerEventHandler("transition_complete_keyframe", f105_local0)
										end
									end

									if f104_arg1.interrupted then
										f104_local0(f104_arg0, f104_arg1)
										return
									else
										f104_arg0:beginAnimation("keyframe", 29, false, false, CoD.TweenType.Linear)
										f104_arg0:setScale(0.82)
										f104_arg0:registerEventHandler("transition_complete_keyframe", f104_local0)
									end
								end

								if f103_arg1.interrupted then
									f103_local0(f103_arg0, f103_arg1)
									return
								else
									f103_arg0:beginAnimation("keyframe", 3170, false, false, CoD.TweenType.Linear)
									f103_arg0:registerEventHandler("transition_complete_keyframe", f103_local0)
								end
							end

							if f102_arg1.interrupted then
								f102_local0(f102_arg0, f102_arg1)
								return
							else
								f102_arg0:beginAnimation("keyframe", 40, false, false, CoD.TweenType.Linear)
								f102_arg0:setScale(0.7)
								f102_arg0:registerEventHandler("transition_complete_keyframe", f102_local0)
							end
						end

						if f101_arg1.interrupted then
							f101_local0(f101_arg0, f101_arg1)
							return
						else
							f101_arg0:beginAnimation("keyframe", 159, false, false, CoD.TweenType.Linear)
							f101_arg0:setAlpha(1)
							f101_arg0:setScale(1.2)
							f101_arg0:registerEventHandler("transition_complete_keyframe", f101_local0)
						end
					end

					if f100_arg1.interrupted then
						f100_local0(f100_arg0, f100_arg1)
						return
					else
						f100_arg0:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Linear)
						f100_arg0:registerEventHandler("transition_complete_keyframe", f100_local0)
					end
				end

				bgbTextureLabelBlur:completeAnimation()
				self.bgbTextureLabelBlur:setAlpha(0)
				self.bgbTextureLabelBlur:setScale(0.5)
				f75_local3(bgbTextureLabelBlur, {})
				local f75_local4 = function(f108_arg0, f108_arg1)
					local f108_local0 = function(f109_arg0, f109_arg1)
						local f109_local0 = function(f110_arg0, f110_arg1)
							local f110_local0 = function(f111_arg0, f111_arg1)
								local f111_local0 = function(f112_arg0, f112_arg1)
									local f112_local0 = function(f113_arg0, f113_arg1)
										local f113_local0 = function(f114_arg0, f114_arg1)
											local f114_local0 = function(f115_arg0, f115_arg1)
												if not f115_arg1.interrupted then
													f115_arg0:beginAnimation("keyframe", 39, false, false,
														CoD.TweenType.Linear)
												end
												f115_arg0:setAlpha(0)
												f115_arg0:setScale(0.5)
												if f115_arg1.interrupted then
													self.clipFinished(f115_arg0, f115_arg1)
												else
													f115_arg0:registerEventHandler("transition_complete_keyframe",
														self.clipFinished)
												end
											end

											if f114_arg1.interrupted then
												f114_local0(f114_arg0, f114_arg1)
												return
											else
												f114_arg0:beginAnimation("keyframe", 340, false, false,
													CoD.TweenType.Linear)
												f114_arg0:setAlpha(0)
												f114_arg0:setScale(0.57)
												f114_arg0:registerEventHandler("transition_complete_keyframe",
													f114_local0)
											end
										end

										if f113_arg1.interrupted then
											f113_local0(f113_arg0, f113_arg1)
											return
										else
											f113_arg0:beginAnimation("keyframe", 99, false, false, CoD.TweenType.Linear)
											f113_arg0:setAlpha(0.77)
											f113_arg0:setScale(1.2)
											f113_arg0:registerEventHandler("transition_complete_keyframe", f113_local0)
										end
									end

									if f112_arg1.interrupted then
										f112_local0(f112_arg0, f112_arg1)
										return
									else
										f112_arg0:beginAnimation("keyframe", 29, false, false, CoD.TweenType.Linear)
										f112_arg0:setScale(0.82)
										f112_arg0:registerEventHandler("transition_complete_keyframe", f112_local0)
									end
								end

								if f111_arg1.interrupted then
									f111_local0(f111_arg0, f111_arg1)
									return
								else
									f111_arg0:beginAnimation("keyframe", 3170, false, false, CoD.TweenType.Linear)
									f111_arg0:registerEventHandler("transition_complete_keyframe", f111_local0)
								end
							end

							if f110_arg1.interrupted then
								f110_local0(f110_arg0, f110_arg1)
								return
							else
								f110_arg0:beginAnimation("keyframe", 40, false, false, CoD.TweenType.Linear)
								f110_arg0:setScale(0.7)
								f110_arg0:registerEventHandler("transition_complete_keyframe", f110_local0)
							end
						end

						if f109_arg1.interrupted then
							f109_local0(f109_arg0, f109_arg1)
							return
						else
							f109_arg0:beginAnimation("keyframe", 159, false, false, CoD.TweenType.Linear)
							f109_arg0:setAlpha(1)
							f109_arg0:setScale(1.2)
							f109_arg0:registerEventHandler("transition_complete_keyframe", f109_local0)
						end
					end

					if f108_arg1.interrupted then
						f108_local0(f108_arg0, f108_arg1)
						return
					else
						f108_arg0:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Linear)
						f108_arg0:registerEventHandler("transition_complete_keyframe", f108_local0)
					end
				end

				bgbTextureLabel:completeAnimation()
				self.bgbTextureLabel:setAlpha(0)
				self.bgbTextureLabel:setScale(0.5)
				f75_local4(bgbTextureLabel, {})
				local f75_local5 = function(f116_arg0, f116_arg1)
					local f116_local0 = function(f117_arg0, f117_arg1)
						if not f117_arg1.interrupted then
							f117_arg0:beginAnimation("keyframe", 139, false, false, CoD.TweenType.Linear)
						end
						f117_arg0:setAlpha(0)
						f117_arg0:setZRot(360)
						f117_arg0:setScale(1.7)
						if f117_arg1.interrupted then
							self.clipFinished(f117_arg0, f117_arg1)
						else
							f117_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
						end
					end

					if f116_arg1.interrupted then
						f116_local0(f116_arg0, f116_arg1)
						return
					else
						f116_arg0:beginAnimation("keyframe", 280, false, false, CoD.TweenType.Linear)
						f116_arg0:setAlpha(0.8)
						f116_arg0:setZRot(240)
						f116_arg0:setScale(1.7)
						f116_arg0:registerEventHandler("transition_complete_keyframe", f116_local0)
					end
				end

				bgbAbilitySwirl:completeAnimation()
				self.bgbAbilitySwirl:setAlpha(0)
				self.bgbAbilitySwirl:setZRot(0)
				self.bgbAbilitySwirl:setScale(1)
				f75_local5(bgbAbilitySwirl, {})
				local f75_local6 = function(f118_arg0, f118_arg1)
					local f118_local0 = function(f119_arg0, f119_arg1)
						local f119_local0 = function(f120_arg0, f120_arg1)
							local f120_local0 = function(f121_arg0, f121_arg1)
								if not f121_arg1.interrupted then
									f121_arg0:beginAnimation("keyframe", 1069, false, false, CoD.TweenType.Linear)
								end
								f121_arg0:setAlpha(0)
								if f121_arg1.interrupted then
									self.clipFinished(f121_arg0, f121_arg1)
								else
									f121_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
								end
							end

							if f120_arg1.interrupted then
								f120_local0(f120_arg0, f120_arg1)
								return
							else
								f120_arg0:beginAnimation("keyframe", 2849, false, false, CoD.TweenType.Linear)
								f120_arg0:registerEventHandler("transition_complete_keyframe", f120_local0)
							end
						end

						if f119_arg1.interrupted then
							f119_local0(f119_arg0, f119_arg1)
							return
						else
							f119_arg0:beginAnimation("keyframe", 329, false, false, CoD.TweenType.Bounce)
							f119_arg0:setAlpha(1)
							f119_arg0:registerEventHandler("transition_complete_keyframe", f119_local0)
						end
					end

					if f118_arg1.interrupted then
						f118_local0(f118_arg0, f118_arg1)
						return
					else
						f118_arg0:beginAnimation("keyframe", 119, false, false, CoD.TweenType.Linear)
						f118_arg0:registerEventHandler("transition_complete_keyframe", f118_local0)
					end
				end

				ZmNotif1CursorHint0:completeAnimation()
				self.ZmNotif1CursorHint0:setAlpha(0)
				f75_local6(ZmNotif1CursorHint0, {})
				local f75_local7 = function(f122_arg0, f122_arg1)
					local f122_local0 = function(f123_arg0, f123_arg1)
						local f123_local0 = function(f124_arg0, f124_arg1)
							if not f124_arg1.interrupted then
								f124_arg0:beginAnimation("keyframe", 869, false, false, CoD.TweenType.Bounce)
							end
							f124_arg0:setAlpha(0)
							if f124_arg1.interrupted then
								self.clipFinished(f124_arg0, f124_arg1)
							else
								f124_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
							end
						end

						if f123_arg1.interrupted then
							f123_local0(f123_arg0, f123_arg1)
							return
						else
							f123_arg0:beginAnimation("keyframe", 3240, false, false, CoD.TweenType.Linear)
							f123_arg0:registerEventHandler("transition_complete_keyframe", f123_local0)
						end
					end

					if f122_arg1.interrupted then
						f122_local0(f122_arg0, f122_arg1)
						return
					else
						f122_arg0:beginAnimation("keyframe", 259, false, false, CoD.TweenType.Bounce)
						f122_arg0:setAlpha(1)
						f122_arg0:registerEventHandler("transition_complete_keyframe", f122_local0)
					end
				end

				ZmNotifFactory:completeAnimation()
				self.ZmNotifFactory:setAlpha(0)
				f75_local7(ZmNotifFactory, {})
				local f75_local8 = function(f125_arg0, f125_arg1)
					local f125_local0 = function(f126_arg0, f126_arg1)
						local f126_local0 = function(f127_arg0, f127_arg1)
							if not f127_arg1.interrupted then
								f127_arg0:beginAnimation("keyframe", 800, false, false, CoD.TweenType.Linear)
							end
							f127_arg0:setRGB(0, 0.04, 1)
							f127_arg0:setAlpha(0)
							if f127_arg1.interrupted then
								self.clipFinished(f127_arg0, f127_arg1)
							else
								f127_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
							end
						end

						if f126_arg1.interrupted then
							f126_local0(f126_arg0, f126_arg1)
							return
						else
							f126_arg0:beginAnimation("keyframe", 3359, false, false, CoD.TweenType.Linear)
							f126_arg0:registerEventHandler("transition_complete_keyframe", f126_local0)
						end
					end

					if f125_arg1.interrupted then
						f125_local0(f125_arg0, f125_arg1)
						return
					else
						f125_arg0:beginAnimation("keyframe", 140, false, false, CoD.TweenType.Bounce)
						f125_arg0:setAlpha(1)
						f125_arg0:registerEventHandler("transition_complete_keyframe", f125_local0)
					end
				end

				Glow:completeAnimation()
				self.Glow:setRGB(0, 0.04, 1)
				self.Glow:setAlpha(0)
				f75_local8(Glow, {})
				ZmFxSpark20:completeAnimation()
				self.ZmFxSpark20:setAlpha(0)
				self.clipFinished(ZmFxSpark20, {})
				local f75_local9 = function(f128_arg0, f128_arg1)
					local f128_local0 = function(f129_arg0, f129_arg1)
						if not f129_arg1.interrupted then
							f129_arg0:beginAnimation("keyframe", 609, false, false, CoD.TweenType.Bounce)
						end
						f129_arg0:setLeftRight(false, false, -219.65, 219.34)
						f129_arg0:setTopBottom(true, false, 146.25, 180.75)
						f129_arg0:setRGB(0, 0.33, 1)
						f129_arg0:setAlpha(0)
						if f129_arg1.interrupted then
							self.clipFinished(f129_arg0, f129_arg1)
						else
							f129_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
						end
					end

					if f128_arg1.interrupted then
						f128_local0(f128_arg0, f128_arg1)
						return
					else
						f128_arg0:beginAnimation("keyframe", 39, false, false, CoD.TweenType.Linear)
						f128_arg0:setRGB(0, 0.92, 1)
						f128_arg0:setAlpha(1)
						f128_arg0:registerEventHandler("transition_complete_keyframe", f128_local0)
					end
				end

				Flsh:completeAnimation()
				self.Flsh:setLeftRight(false, false, -219.65, 219.34)
				self.Flsh:setTopBottom(true, false, 146.25, 180.75)
				self.Flsh:setRGB(0, 0.37, 1)
				self.Flsh:setAlpha(0.36)
				f75_local9(Flsh, {})
				local f75_local10 = function(f130_arg0, f130_arg1)
					local f130_local0 = function(f131_arg0, f131_arg1)
						local f131_local0 = function(f132_arg0, f132_arg1)
							if not f132_arg1.interrupted then
								f132_arg0:beginAnimation("keyframe", 440, false, false, CoD.TweenType.Linear)
							end
							f132_arg0:setAlpha(0)
							if f132_arg1.interrupted then
								self.clipFinished(f132_arg0, f132_arg1)
							else
								f132_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
							end
						end

						if f131_arg1.interrupted then
							f131_local0(f131_arg0, f131_arg1)
							return
						else
							f131_arg0:beginAnimation("keyframe", 3720, false, false, CoD.TweenType.Linear)
							f131_arg0:registerEventHandler("transition_complete_keyframe", f131_local0)
						end
					end

					if f130_arg1.interrupted then
						f130_local0(f130_arg0, f130_arg1)
						return
					else
						f130_arg0:beginAnimation("keyframe", 90, false, false, CoD.TweenType.Linear)
						f130_arg0:setAlpha(1)
						f130_arg0:registerEventHandler("transition_complete_keyframe", f130_local0)
					end
				end

				ZmAmmoParticleFX1left:completeAnimation()
				self.ZmAmmoParticleFX1left:setAlpha(0)
				f75_local10(ZmAmmoParticleFX1left, {})
				local f75_local11 = function(f133_arg0, f133_arg1)
					local f133_local0 = function(f134_arg0, f134_arg1)
						local f134_local0 = function(f135_arg0, f135_arg1)
							if not f135_arg1.interrupted then
								f135_arg0:beginAnimation("keyframe", 440, false, false, CoD.TweenType.Linear)
							end
							f135_arg0:setAlpha(0)
							if f135_arg1.interrupted then
								self.clipFinished(f135_arg0, f135_arg1)
							else
								f135_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
							end
						end

						if f134_arg1.interrupted then
							f134_local0(f134_arg0, f134_arg1)
							return
						else
							f134_arg0:beginAnimation("keyframe", 3720, false, false, CoD.TweenType.Linear)
							f134_arg0:registerEventHandler("transition_complete_keyframe", f134_local0)
						end
					end

					if f133_arg1.interrupted then
						f133_local0(f133_arg0, f133_arg1)
						return
					else
						f133_arg0:beginAnimation("keyframe", 90, false, false, CoD.TweenType.Linear)
						f133_arg0:setAlpha(1)
						f133_arg0:registerEventHandler("transition_complete_keyframe", f133_local0)
					end
				end

				ZmAmmoParticleFX2left:completeAnimation()
				self.ZmAmmoParticleFX2left:setAlpha(0)
				f75_local11(ZmAmmoParticleFX2left, {})
				local f75_local12 = function(f136_arg0, f136_arg1)
					local f136_local0 = function(f137_arg0, f137_arg1)
						local f137_local0 = function(f138_arg0, f138_arg1)
							if not f138_arg1.interrupted then
								f138_arg0:beginAnimation("keyframe", 440, false, false, CoD.TweenType.Linear)
							end
							f138_arg0:setAlpha(0)
							if f138_arg1.interrupted then
								self.clipFinished(f138_arg0, f138_arg1)
							else
								f138_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
							end
						end

						if f137_arg1.interrupted then
							f137_local0(f137_arg0, f137_arg1)
							return
						else
							f137_arg0:beginAnimation("keyframe", 3720, false, false, CoD.TweenType.Linear)
							f137_arg0:registerEventHandler("transition_complete_keyframe", f137_local0)
						end
					end

					if f136_arg1.interrupted then
						f136_local0(f136_arg0, f136_arg1)
						return
					else
						f136_arg0:beginAnimation("keyframe", 90, false, false, CoD.TweenType.Linear)
						f136_arg0:setAlpha(1)
						f136_arg0:registerEventHandler("transition_complete_keyframe", f136_local0)
					end
				end

				ZmAmmoParticleFX3left:completeAnimation()
				self.ZmAmmoParticleFX3left:setAlpha(0)
				f75_local12(ZmAmmoParticleFX3left, {})
				local f75_local13 = function(f139_arg0, f139_arg1)
					local f139_local0 = function(f140_arg0, f140_arg1)
						local f140_local0 = function(f141_arg0, f141_arg1)
							if not f141_arg1.interrupted then
								f141_arg0:beginAnimation("keyframe", 440, false, false, CoD.TweenType.Linear)
							end
							f141_arg0:setLeftRight(true, false, 204.52, 348)
							f141_arg0:setTopBottom(true, false, 129, 203.6)
							f141_arg0:setAlpha(0)
							f141_arg0:setZRot(180)
							if f141_arg1.interrupted then
								self.clipFinished(f141_arg0, f141_arg1)
							else
								f141_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
							end
						end

						if f140_arg1.interrupted then
							f140_local0(f140_arg0, f140_arg1)
							return
						else
							f140_arg0:beginAnimation("keyframe", 3720, false, false, CoD.TweenType.Linear)
							f140_arg0:registerEventHandler("transition_complete_keyframe", f140_local0)
						end
					end

					if f139_arg1.interrupted then
						f139_local0(f139_arg0, f139_arg1)
						return
					else
						f139_arg0:beginAnimation("keyframe", 90, false, false, CoD.TweenType.Linear)
						f139_arg0:setAlpha(1)
						f139_arg0:registerEventHandler("transition_complete_keyframe", f139_local0)
					end
				end

				ZmAmmoParticleFX1right:completeAnimation()
				self.ZmAmmoParticleFX1right:setLeftRight(true, false, 204.52, 348)
				self.ZmAmmoParticleFX1right:setTopBottom(true, false, 129, 203.6)
				self.ZmAmmoParticleFX1right:setAlpha(0)
				self.ZmAmmoParticleFX1right:setZRot(180)
				f75_local13(ZmAmmoParticleFX1right, {})
				local f75_local14 = function(f142_arg0, f142_arg1)
					local f142_local0 = function(f143_arg0, f143_arg1)
						local f143_local0 = function(f144_arg0, f144_arg1)
							if not f144_arg1.interrupted then
								f144_arg0:beginAnimation("keyframe", 440, false, false, CoD.TweenType.Linear)
							end
							f144_arg0:setLeftRight(true, false, 204.52, 348)
							f144_arg0:setTopBottom(true, false, 126.6, 201.21)
							f144_arg0:setAlpha(0)
							f144_arg0:setZRot(180)
							if f144_arg1.interrupted then
								self.clipFinished(f144_arg0, f144_arg1)
							else
								f144_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
							end
						end

						if f143_arg1.interrupted then
							f143_local0(f143_arg0, f143_arg1)
							return
						else
							f143_arg0:beginAnimation("keyframe", 3720, false, false, CoD.TweenType.Linear)
							f143_arg0:registerEventHandler("transition_complete_keyframe", f143_local0)
						end
					end

					if f142_arg1.interrupted then
						f142_local0(f142_arg0, f142_arg1)
						return
					else
						f142_arg0:beginAnimation("keyframe", 90, false, false, CoD.TweenType.Linear)
						f142_arg0:setAlpha(1)
						f142_arg0:registerEventHandler("transition_complete_keyframe", f142_local0)
					end
				end

				ZmAmmoParticleFX2right:completeAnimation()
				self.ZmAmmoParticleFX2right:setLeftRight(true, false, 204.52, 348)
				self.ZmAmmoParticleFX2right:setTopBottom(true, false, 126.6, 201.21)
				self.ZmAmmoParticleFX2right:setAlpha(0)
				self.ZmAmmoParticleFX2right:setZRot(180)
				f75_local14(ZmAmmoParticleFX2right, {})
				local f75_local15 = function(f145_arg0, f145_arg1)
					local f145_local0 = function(f146_arg0, f146_arg1)
						local f146_local0 = function(f147_arg0, f147_arg1)
							if not f147_arg1.interrupted then
								f147_arg0:beginAnimation("keyframe", 440, false, false, CoD.TweenType.Linear)
							end
							f147_arg0:setLeftRight(true, false, 204.52, 348)
							f147_arg0:setTopBottom(true, false, 127.6, 202.21)
							f147_arg0:setAlpha(0)
							f147_arg0:setZRot(180)
							if f147_arg1.interrupted then
								self.clipFinished(f147_arg0, f147_arg1)
							else
								f147_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
							end
						end

						if f146_arg1.interrupted then
							f146_local0(f146_arg0, f146_arg1)
							return
						else
							f146_arg0:beginAnimation("keyframe", 3720, false, false, CoD.TweenType.Linear)
							f146_arg0:setAlpha(0)
							f146_arg0:registerEventHandler("transition_complete_keyframe", f146_local0)
						end
					end

					if f145_arg1.interrupted then
						f145_local0(f145_arg0, f145_arg1)
						return
					else
						f145_arg0:beginAnimation("keyframe", 90, false, false, CoD.TweenType.Linear)
						f145_arg0:setAlpha(1)
						f145_arg0:registerEventHandler("transition_complete_keyframe", f145_local0)
					end
				end

				ZmAmmoParticleFX3right:completeAnimation()
				self.ZmAmmoParticleFX3right:setLeftRight(true, false, 204.52, 348)
				self.ZmAmmoParticleFX3right:setTopBottom(true, false, 127.6, 202.21)
				self.ZmAmmoParticleFX3right:setAlpha(0)
				self.ZmAmmoParticleFX3right:setZRot(180)
				f75_local15(ZmAmmoParticleFX3right, {})
				local f75_local16 = function(f148_arg0, f148_arg1)
					local f148_local0 = function(f149_arg0, f149_arg1)
						local f149_local0 = function(f150_arg0, f150_arg1)
							if not f150_arg1.interrupted then
								f150_arg0:beginAnimation("keyframe", 679, false, false, CoD.TweenType.Linear)
							end
							f150_arg0:setLeftRight(true, false, 38.67, 280)
							f150_arg0:setTopBottom(true, false, -22.5, 193.5)
							f150_arg0:setAlpha(0)
							if f150_arg1.interrupted then
								self.clipFinished(f150_arg0, f150_arg1)
							else
								f150_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
							end
						end

						if f149_arg1.interrupted then
							f149_local0(f149_arg0, f149_arg1)
							return
						else
							f149_arg0:beginAnimation("keyframe", 260, false, false, CoD.TweenType.Linear)
							f149_arg0:setAlpha(1)
							f149_arg0:registerEventHandler("transition_complete_keyframe", f149_local0)
						end
					end

					if f148_arg1.interrupted then
						f148_local0(f148_arg0, f148_arg1)
						return
					else
						f148_arg0:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Linear)
						f148_arg0:registerEventHandler("transition_complete_keyframe", f148_local0)
					end
				end

				Lightning:completeAnimation()
				self.Lightning:setLeftRight(true, false, 38.67, 280)
				self.Lightning:setTopBottom(true, false, -22.5, 193.5)
				self.Lightning:setAlpha(0)
				f75_local16(Lightning, {})
				Lightning2:completeAnimation()
				self.Lightning2:setAlpha(0)
				self.clipFinished(Lightning2, {})
				Lightning3:completeAnimation()
				self.Lightning3:setAlpha(0)
				self.clipFinished(Lightning3, {})
				CursorHint:beginAnimation("keyframe", 3769, false, false, CoD.TweenType.Linear)
				CursorHint:setAlpha(0)
				CursorHint:registerEventHandler("transition_complete_keyframe", self.clipFinished)
				Last5RoundTime:completeAnimation()
				self.Last5RoundTime:setAlpha(0)
				self.clipFinished(Last5RoundTime, {})
			end,
			TextandImageBasic = function()
				self:setupElementClipCounter(17)

				local FadeInThenOut = function(element, event)
					local f152_local0 = function(element, event)
						local f153_local0 = function(element, event)
							local f154_local0 = function(element, event)
								if not event.interrupted then
									element:beginAnimation("keyframe", 679, false, false, CoD.TweenType.Linear)
								end
								element:setAlpha(0)
								if event.interrupted then
									self.clipFinished(element, event)
								else
									element:registerEventHandler("transition_complete_keyframe", self.clipFinished)
								end
							end

							if event.interrupted then
								f154_local0(element, event)
								return
							else
								element:beginAnimation("keyframe", 1850 + 1000, false, false, CoD.TweenType.Linear)
								element:registerEventHandler("transition_complete_keyframe", f154_local0)
							end
						end

						if event.interrupted then
							f153_local0(element, event)
							return
						else
							element:beginAnimation("keyframe", 110, false, false, CoD.TweenType.Linear)
							element:setAlpha(1)
							element:registerEventHandler("transition_complete_keyframe", f153_local0)
						end
					end

					if event.interrupted then
						f152_local0(element, event)
						return
					else
						element:beginAnimation("keyframe", 449, false, false, CoD.TweenType.Linear)
						element:setAlpha(0.8)
						element:registerEventHandler("transition_complete_keyframe", f152_local0)
					end
				end

				local CircleAnimationStage1 = function(element, event)
					local f152_local0 = function(element, event)
						local f153_local0 = function(element, event)
							local f154_local0 = function(element, event)
								if not event.interrupted then
									element:beginAnimation("keyframe", 679, false, false, CoD.TweenType.Linear)
								end
								element:setAlpha(0)
								if event.interrupted then
									self.clipFinished(element, event)
								else
									element:setZRot(-24)
									element:registerEventHandler("transition_complete_keyframe", self.clipFinished)
								end
							end

							if event.interrupted then
								f154_local0(element, event)
								return
							else
								element:beginAnimation("keyframe", 1850 + 1000, false, false, CoD.TweenType.Linear)
								element:setZRot(-16.73 - 0.65 - 2.64)
								element:registerEventHandler("transition_complete_keyframe", f154_local0)
							end
						end

						if event.interrupted then
							f153_local0(element, event)
							return
						else
							element:beginAnimation("keyframe", 110, false, false, CoD.TweenType.Linear)
							element:setAlpha(1)
							element:setZRot(-0.65 - 2.64)
							--element:setShaderVector(0, .5, 0, 0, 0)
							element:registerEventHandler("transition_complete_keyframe", f153_local0)
						end
					end

					if event.interrupted then
						f152_local0(element, event)
						return
					else
						element:beginAnimation("keyframe", 449, false, false, CoD.TweenType.Linear)
						element:setAlpha(0.8)
						element:setZRot(-2.64)
						element:registerEventHandler("transition_complete_keyframe", f152_local0)
					end
				end

				PowerupBacker:completeAnimation()
				self.PowerupBacker:setAlpha(0)
				FadeInThenOut(PowerupBacker, {})

				PowerupBackerLeft:completeAnimation()
				self.PowerupBackerLeft:setAlpha(0)
				FadeInThenOut(PowerupBackerLeft, {})

				PowerupBackerRight:completeAnimation()
				self.PowerupBackerRight:setAlpha(0)
				FadeInThenOut(PowerupBackerRight, {})

				PowerupTexture:completeAnimation()
				self.PowerupTexture:setAlpha(0)
				self.PowerupTexture:setZRot(0)
				CircleAnimationStage1(PowerupTexture, {})

				Panel:completeAnimation()
				self.Panel:setAlpha(0)
				self.clipFinished(Panel, {})

				basicImageBacking:completeAnimation()
				basicImageBacking:setAlpha(0)
				self.clipFinished(basicImageBacking, {})

				basicImage:completeAnimation()
				basicImage:setAlpha(0)
				self.clipFinished(basicImage, {})

				bgbGlowOrangeOver:completeAnimation()
				self.bgbGlowOrangeOver:setAlpha(0)
				self.clipFinished(bgbGlowOrangeOver, {})

				bgbTexture:completeAnimation()
				self.bgbTexture:setAlpha(0)
				self.clipFinished(bgbTexture, {})

				bgbAbilitySwirl:completeAnimation()
				self.bgbAbilitySwirl:setAlpha(0)
				self.clipFinished(bgbAbilitySwirl, {})

				ZmNotif1CursorHint0:completeAnimation()
				self.ZmNotif1CursorHint0:setAlpha(0)
				FadeInThenOut(ZmNotif1CursorHint0, {})

				ZmNotifFactory:completeAnimation()
				self.ZmNotifFactory:setRGB(1, 1, 1)
				self.ZmNotifFactory:setAlpha(0)
				FadeInThenOut(ZmNotifFactory, {})

				Glow:completeAnimation()
				self.Glow:setAlpha(0)
				self.clipFinished(Glow, {})

				ZmFxSpark20:completeAnimation()
				self.ZmFxSpark20:setRGB(0, 0, 0)
				self.ZmFxSpark20:setAlpha(1)
				self.clipFinished(ZmFxSpark20, {})

				Flsh:completeAnimation()
				self.Flsh:setRGB(0.62, 0.22, 0)
				self.Flsh:setAlpha(0)
				self.clipFinished(Flsh, {})

				CursorHint:beginAnimation("keyframe", 3769, false, false, CoD.TweenType.Linear)
				CursorHint:setAlpha(0)
				CursorHint:registerEventHandler("transition_complete_keyframe", self.clipFinished)

				Last5RoundTime:completeAnimation()
				self.Last5RoundTime:setAlpha(0)
				self.clipFinished(Last5RoundTime, {})
			end,
			TextandTimeAttack = function()
				self:setupElementClipCounter(28)

				PowerupBacker:completeAnimation()
				PowerupBacker:setAlpha(0)
				self.clipFinished(PowerupBacker, {})

				PowerupBackerLeft:completeAnimation()
				PowerupBackerLeft:setAlpha(0)
				self.clipFinished(PowerupBackerLeft, {})

				PowerupBackerRight:completeAnimation()
				PowerupBackerRight:setAlpha(0)
				self.clipFinished(PowerupBackerRight, {})

				PowerupTexture:completeAnimation()
				PowerupTexture:setAlpha(0)
				self.clipFinished(PowerupTexture, {})

				local f198_local0 = function(f199_arg0, f199_arg1)
					local f199_local0 = function(f200_arg0, f200_arg1)
						local f200_local0 = function(f201_arg0, f201_arg1)
							local f201_local0 = function(f202_arg0, f202_arg1)
								if not f202_arg1.interrupted then
									f202_arg0:beginAnimation("keyframe", 679, false, false, CoD.TweenType.Linear)
								end
								f202_arg0:setRGB(0.25, 0.49, 0.83)
								f202_arg0:setAlpha(0)
								if f202_arg1.interrupted then
									self.clipFinished(f202_arg0, f202_arg1)
								else
									f202_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
								end
							end

							if f201_arg1.interrupted then
								f201_local0(f201_arg0, f201_arg1)
								return
							else
								f201_arg0:beginAnimation("keyframe", 1850, false, false, CoD.TweenType.Linear)
								f201_arg0:registerEventHandler("transition_complete_keyframe", f201_local0)
							end
						end

						if f200_arg1.interrupted then
							f200_local0(f200_arg0, f200_arg1)
							return
						else
							f200_arg0:beginAnimation("keyframe", 110, false, false, CoD.TweenType.Linear)
							f200_arg0:setAlpha(1)
							f200_arg0:registerEventHandler("transition_complete_keyframe", f200_local0)
						end
					end

					if f199_arg1.interrupted then
						f199_local0(f199_arg0, f199_arg1)
						return
					else
						f199_arg0:beginAnimation("keyframe", 449, false, false, CoD.TweenType.Linear)
						f199_arg0:setAlpha(0.8)
						f199_arg0:registerEventHandler("transition_complete_keyframe", f199_local0)
					end
				end

				Panel:completeAnimation()
				self.Panel:setRGB(0.25, 0.49, 0.83)
				self.Panel:setAlpha(0)
				f198_local0(Panel, {})
				local f198_local1 = function(f203_arg0, f203_arg1)
					local f203_local0 = function(f204_arg0, f204_arg1)
						local f204_local0 = function(f205_arg0, f205_arg1)
							local f205_local0 = function(f206_arg0, f206_arg1)
								if not f206_arg1.interrupted then
									f206_arg0:beginAnimation("keyframe", 600, false, false, CoD.TweenType.Linear)
								end
								f206_arg0:setAlpha(0)
								f206_arg0:setZRot(10)
								if f206_arg1.interrupted then
									self.clipFinished(f206_arg0, f206_arg1)
								else
									f206_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
								end
							end

							if f205_arg1.interrupted then
								f205_local0(f205_arg0, f205_arg1)
								return
							else
								f205_arg0:beginAnimation("keyframe", 1879, false, false, CoD.TweenType.Linear)
								f205_arg0:setZRot(5.7)
								f205_arg0:registerEventHandler("transition_complete_keyframe", f205_local0)
							end
						end

						if f204_arg1.interrupted then
							f204_local0(f204_arg0, f204_arg1)
							return
						else
							f204_arg0:beginAnimation("keyframe", 310, false, false, CoD.TweenType.Linear)
							f204_arg0:setAlpha(1)
							f204_arg0:setZRot(-7.78)
							f204_arg0:registerEventHandler("transition_complete_keyframe", f204_local0)
						end
					end

					if f203_arg1.interrupted then
						f203_local0(f203_arg0, f203_arg1)
						return
					else
						f203_arg0:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Linear)
						f203_arg0:registerEventHandler("transition_complete_keyframe", f203_local0)
					end
				end

				basicImageBacking:completeAnimation()
				self.basicImageBacking:setAlpha(0)
				self.basicImageBacking:setZRot(-10)
				f198_local1(basicImageBacking, {})
				local f198_local2 = function(f207_arg0, f207_arg1)
					local f207_local0 = function(f208_arg0, f208_arg1)
						local f208_local0 = function(f209_arg0, f209_arg1)
							local f209_local0 = function(f210_arg0, f210_arg1)
								if not f210_arg1.interrupted then
									f210_arg0:beginAnimation("keyframe", 559, false, false, CoD.TweenType.Linear)
								end
								f210_arg0:setLeftRight(true, false, 75.67, 237.67)
								f210_arg0:setTopBottom(true, false, 44, 206)
								f210_arg0:setAlpha(0)
								f210_arg0:setScale(0.8)
								if f210_arg1.interrupted then
									self.clipFinished(f210_arg0, f210_arg1)
								else
									f210_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
								end
							end

							if f209_arg1.interrupted then
								f209_local0(f209_arg0, f209_arg1)
								return
							else
								f209_arg0:beginAnimation("keyframe", 110, false, false, CoD.TweenType.Linear)
								f209_arg0:setAlpha(1)
								f209_arg0:registerEventHandler("transition_complete_keyframe", f209_local0)
							end
						end

						if f208_arg1.interrupted then
							f208_local0(f208_arg0, f208_arg1)
							return
						else
							f208_arg0:beginAnimation("keyframe", 1839, false, false, CoD.TweenType.Linear)
							f208_arg0:registerEventHandler("transition_complete_keyframe", f208_local0)
						end
					end

					if f207_arg1.interrupted then
						f207_local0(f207_arg0, f207_arg1)
						return
					else
						f207_arg0:beginAnimation("keyframe", 449, false, false, CoD.TweenType.Linear)
						f207_arg0:setAlpha(0.95)
						f207_arg0:registerEventHandler("transition_complete_keyframe", f207_local0)
					end
				end

				TimeAttack:completeAnimation()
				self.TimeAttack:setLeftRight(true, false, 75.67, 237.67)
				self.TimeAttack:setTopBottom(true, false, 44, 206)
				self.TimeAttack:setAlpha(0)
				self.TimeAttack:setScale(0.8)
				f198_local2(TimeAttack, {})
				local f198_local3 = function(f211_arg0, f211_arg1)
					local f211_local0 = function(f212_arg0, f212_arg1)
						local f212_local0 = function(f213_arg0, f213_arg1)
							local f213_local0 = function(f214_arg0, f214_arg1)
								local f214_local0 = function(f215_arg0, f215_arg1)
									if not f215_arg1.interrupted then
										f215_arg0:beginAnimation("keyframe", 679, false, true, CoD.TweenType.Linear)
									end
									f215_arg0:setAlpha(0)
									if f215_arg1.interrupted then
										self.clipFinished(f215_arg0, f215_arg1)
									else
										f215_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
									end
								end

								if f214_arg1.interrupted then
									f214_local0(f214_arg0, f214_arg1)
									return
								else
									f214_arg0:beginAnimation("keyframe", 1630, false, false, CoD.TweenType.Linear)
									f214_arg0:registerEventHandler("transition_complete_keyframe", f214_local0)
								end
							end

							if f213_arg1.interrupted then
								f213_local0(f213_arg0, f213_arg1)
								return
							else
								f213_arg0:beginAnimation("keyframe", 339, false, false, CoD.TweenType.Linear)
								f213_arg0:registerEventHandler("transition_complete_keyframe", f213_local0)
							end
						end

						if f212_arg1.interrupted then
							f212_local0(f212_arg0, f212_arg1)
							return
						else
							f212_arg0:beginAnimation("keyframe", 290, false, false, CoD.TweenType.Linear)
							f212_arg0:registerEventHandler("transition_complete_keyframe", f212_local0)
						end
					end

					if f211_arg1.interrupted then
						f211_local0(f211_arg0, f211_arg1)
						return
					else
						f211_arg0:beginAnimation("keyframe", 140, false, false, CoD.TweenType.Linear)
						f211_arg0:registerEventHandler("transition_complete_keyframe", f211_local0)
					end
				end

				basicImage:completeAnimation()
				self.basicImage:setAlpha(0)
				f198_local3(basicImage, {})
				bgbGlowOrangeOver:completeAnimation()
				self.bgbGlowOrangeOver:setAlpha(0)
				self.clipFinished(bgbGlowOrangeOver, {})
				bgbTexture:completeAnimation()
				self.bgbTexture:setAlpha(0)
				self.clipFinished(bgbTexture, {})
				bgbAbilitySwirl:completeAnimation()
				self.bgbAbilitySwirl:setAlpha(0)
				self.bgbAbilitySwirl:setZRot(0)
				self.bgbAbilitySwirl:setScale(1)
				self.clipFinished(bgbAbilitySwirl, {})
				local f198_local4 = function(f216_arg0, f216_arg1)
					local f216_local0 = function(f217_arg0, f217_arg1)
						local f217_local0 = function(f218_arg0, f218_arg1)
							local f218_local0 = function(f219_arg0, f219_arg1)
								if not f219_arg1.interrupted then
									f219_arg0:beginAnimation("keyframe", 1069, false, false, CoD.TweenType.Linear)
								end
								f219_arg0:setAlpha(0)
								if f219_arg1.interrupted then
									self.clipFinished(f219_arg0, f219_arg1)
								else
									f219_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
								end
							end

							if f218_arg1.interrupted then
								f218_local0(f218_arg0, f218_arg1)
								return
							else
								f218_arg0:beginAnimation("keyframe", 1849, false, false, CoD.TweenType.Linear)
								f218_arg0:registerEventHandler("transition_complete_keyframe", f218_local0)
							end
						end

						if f217_arg1.interrupted then
							f217_local0(f217_arg0, f217_arg1)
							return
						else
							f217_arg0:beginAnimation("keyframe", 329, false, false, CoD.TweenType.Bounce)
							f217_arg0:setAlpha(1)
							f217_arg0:registerEventHandler("transition_complete_keyframe", f217_local0)
						end
					end

					if f216_arg1.interrupted then
						f216_local0(f216_arg0, f216_arg1)
						return
					else
						f216_arg0:beginAnimation("keyframe", 119, false, false, CoD.TweenType.Linear)
						f216_arg0:registerEventHandler("transition_complete_keyframe", f216_local0)
					end
				end

				ZmNotif1CursorHint0:completeAnimation()
				self.ZmNotif1CursorHint0:setAlpha(0)
				f198_local4(ZmNotif1CursorHint0, {})
				local f198_local5 = function(f220_arg0, f220_arg1)
					local f220_local0 = function(f221_arg0, f221_arg1)
						local f221_local0 = function(f222_arg0, f222_arg1)
							if not f222_arg1.interrupted then
								f222_arg0:beginAnimation("keyframe", 869, false, false, CoD.TweenType.Bounce)
							end
							f222_arg0:setRGB(1, 1, 1)
							f222_arg0:setAlpha(0)
							if f222_arg1.interrupted then
								self.clipFinished(f222_arg0, f222_arg1)
							else
								f222_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
							end
						end

						if f221_arg1.interrupted then
							f221_local0(f221_arg0, f221_arg1)
							return
						else
							f221_arg0:beginAnimation("keyframe", 2240, false, false, CoD.TweenType.Linear)
							f221_arg0:registerEventHandler("transition_complete_keyframe", f221_local0)
						end
					end

					if f220_arg1.interrupted then
						f220_local0(f220_arg0, f220_arg1)
						return
					else
						f220_arg0:beginAnimation("keyframe", 259, false, false, CoD.TweenType.Bounce)
						f220_arg0:setAlpha(1)
						f220_arg0:registerEventHandler("transition_complete_keyframe", f220_local0)
					end
				end

				ZmNotifFactory:completeAnimation()
				self.ZmNotifFactory:setRGB(1, 1, 1)
				self.ZmNotifFactory:setAlpha(0)
				f198_local5(ZmNotifFactory, {})
				local f198_local6 = function(f223_arg0, f223_arg1)
					local f223_local0 = function(f224_arg0, f224_arg1)
						local f224_local0 = function(f225_arg0, f225_arg1)
							local f225_local0 = function(f226_arg0, f226_arg1)
								if not f226_arg1.interrupted then
									f226_arg0:beginAnimation("keyframe", 799, false, false, CoD.TweenType.Linear)
								end
								f226_arg0:setRGB(0, 0.42, 1)
								f226_arg0:setAlpha(0)
								if f226_arg1.interrupted then
									self.clipFinished(f226_arg0, f226_arg1)
								else
									f226_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
								end
							end

							if f225_arg1.interrupted then
								f225_local0(f225_arg0, f225_arg1)
								return
							else
								f225_arg0:beginAnimation("keyframe", 2049, false, false, CoD.TweenType.Linear)
								f225_arg0:registerEventHandler("transition_complete_keyframe", f225_local0)
							end
						end

						if f224_arg1.interrupted then
							f224_local0(f224_arg0, f224_arg1)
							return
						else
							f224_arg0:beginAnimation("keyframe", 310, false, false, CoD.TweenType.Linear)
							f224_arg0:registerEventHandler("transition_complete_keyframe", f224_local0)
						end
					end

					if f223_arg1.interrupted then
						f223_local0(f223_arg0, f223_arg1)
						return
					else
						f223_arg0:beginAnimation("keyframe", 140, false, false, CoD.TweenType.Bounce)
						f223_arg0:setAlpha(1)
						f223_arg0:registerEventHandler("transition_complete_keyframe", f223_local0)
					end
				end

				Glow:completeAnimation()
				self.Glow:setRGB(0, 0.42, 1)
				self.Glow:setAlpha(0)
				f198_local6(Glow, {})
				ZmFxSpark20:completeAnimation()
				self.ZmFxSpark20:setAlpha(0)
				self.clipFinished(ZmFxSpark20, {})
				local f198_local7 = function(f227_arg0, f227_arg1)
					local f227_local0 = function(f228_arg0, f228_arg1)
						if not f228_arg1.interrupted then
							f228_arg0:beginAnimation("keyframe", 609, false, false, CoD.TweenType.Bounce)
						end
						f228_arg0:setLeftRight(false, false, -219.65, 219.34)
						f228_arg0:setTopBottom(true, false, 146.25, 180.75)
						f228_arg0:setRGB(0, 0.56, 1)
						f228_arg0:setAlpha(0)
						if f228_arg1.interrupted then
							self.clipFinished(f228_arg0, f228_arg1)
						else
							f228_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
						end
					end

					if f227_arg1.interrupted then
						f227_local0(f227_arg0, f227_arg1)
						return
					else
						f227_arg0:beginAnimation("keyframe", 39, false, false, CoD.TweenType.Linear)
						f227_arg0:setRGB(0, 0.86, 1)
						f227_arg0:setAlpha(1)
						f227_arg0:registerEventHandler("transition_complete_keyframe", f227_local0)
					end
				end

				Flsh:completeAnimation()
				self.Flsh:setLeftRight(false, false, -219.65, 219.34)
				self.Flsh:setTopBottom(true, false, 146.25, 180.75)
				self.Flsh:setRGB(0, 0.53, 1)
				self.Flsh:setAlpha(0.36)
				f198_local7(Flsh, {})
				local f198_local8 = function(f229_arg0, f229_arg1)
					local f229_local0 = function(f230_arg0, f230_arg1)
						if not f230_arg1.interrupted then
							f230_arg0:beginAnimation("keyframe", 439, false, false, CoD.TweenType.Linear)
						end
						f230_arg0:setAlpha(0)
						if f230_arg1.interrupted then
							self.clipFinished(f230_arg0, f230_arg1)
						else
							f230_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
						end
					end

					if f229_arg1.interrupted then
						f229_local0(f229_arg0, f229_arg1)
						return
					else
						f229_arg0:beginAnimation("keyframe", 2930, false, false, CoD.TweenType.Linear)
						f229_arg0:registerEventHandler("transition_complete_keyframe", f229_local0)
					end
				end

				ZmAmmoParticleFX1left:completeAnimation()
				self.ZmAmmoParticleFX1left:setAlpha(1)
				f198_local8(ZmAmmoParticleFX1left, {})
				local f198_local9 = function(f231_arg0, f231_arg1)
					local f231_local0 = function(f232_arg0, f232_arg1)
						if not f232_arg1.interrupted then
							f232_arg0:beginAnimation("keyframe", 439, false, false, CoD.TweenType.Linear)
						end
						f232_arg0:setAlpha(0)
						if f232_arg1.interrupted then
							self.clipFinished(f232_arg0, f232_arg1)
						else
							f232_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
						end
					end

					if f231_arg1.interrupted then
						f231_local0(f231_arg0, f231_arg1)
						return
					else
						f231_arg0:beginAnimation("keyframe", 2930, false, false, CoD.TweenType.Linear)
						f231_arg0:registerEventHandler("transition_complete_keyframe", f231_local0)
					end
				end

				ZmAmmoParticleFX2left:completeAnimation()
				self.ZmAmmoParticleFX2left:setAlpha(1)
				f198_local9(ZmAmmoParticleFX2left, {})
				local f198_local10 = function(f233_arg0, f233_arg1)
					local f233_local0 = function(f234_arg0, f234_arg1)
						if not f234_arg1.interrupted then
							f234_arg0:beginAnimation("keyframe", 439, false, false, CoD.TweenType.Linear)
						end
						f234_arg0:setAlpha(0)
						if f234_arg1.interrupted then
							self.clipFinished(f234_arg0, f234_arg1)
						else
							f234_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
						end
					end

					if f233_arg1.interrupted then
						f233_local0(f233_arg0, f233_arg1)
						return
					else
						f233_arg0:beginAnimation("keyframe", 2930, false, false, CoD.TweenType.Linear)
						f233_arg0:registerEventHandler("transition_complete_keyframe", f233_local0)
					end
				end

				ZmAmmoParticleFX3left:completeAnimation()
				self.ZmAmmoParticleFX3left:setAlpha(1)
				f198_local10(ZmAmmoParticleFX3left, {})
				local f198_local11 = function(f235_arg0, f235_arg1)
					local f235_local0 = function(f236_arg0, f236_arg1)
						if not f236_arg1.interrupted then
							f236_arg0:beginAnimation("keyframe", 439, false, false, CoD.TweenType.Linear)
						end
						f236_arg0:setLeftRight(true, false, 204.52, 348)
						f236_arg0:setTopBottom(true, false, 129, 203.6)
						f236_arg0:setAlpha(0)
						f236_arg0:setZRot(180)
						if f236_arg1.interrupted then
							self.clipFinished(f236_arg0, f236_arg1)
						else
							f236_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
						end
					end

					if f235_arg1.interrupted then
						f235_local0(f235_arg0, f235_arg1)
						return
					else
						f235_arg0:beginAnimation("keyframe", 2930, false, false, CoD.TweenType.Linear)
						f235_arg0:registerEventHandler("transition_complete_keyframe", f235_local0)
					end
				end

				ZmAmmoParticleFX1right:completeAnimation()
				self.ZmAmmoParticleFX1right:setLeftRight(true, false, 204.52, 348)
				self.ZmAmmoParticleFX1right:setTopBottom(true, false, 129, 203.6)
				self.ZmAmmoParticleFX1right:setAlpha(1)
				self.ZmAmmoParticleFX1right:setZRot(180)
				f198_local11(ZmAmmoParticleFX1right, {})
				local f198_local12 = function(f237_arg0, f237_arg1)
					local f237_local0 = function(f238_arg0, f238_arg1)
						if not f238_arg1.interrupted then
							f238_arg0:beginAnimation("keyframe", 439, false, false, CoD.TweenType.Linear)
						end
						f238_arg0:setLeftRight(true, false, 204.52, 348)
						f238_arg0:setTopBottom(true, false, 126.6, 201.21)
						f238_arg0:setAlpha(0)
						f238_arg0:setZRot(180)
						if f238_arg1.interrupted then
							self.clipFinished(f238_arg0, f238_arg1)
						else
							f238_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
						end
					end

					if f237_arg1.interrupted then
						f237_local0(f237_arg0, f237_arg1)
						return
					else
						f237_arg0:beginAnimation("keyframe", 2930, false, false, CoD.TweenType.Linear)
						f237_arg0:registerEventHandler("transition_complete_keyframe", f237_local0)
					end
				end

				ZmAmmoParticleFX2right:completeAnimation()
				self.ZmAmmoParticleFX2right:setLeftRight(true, false, 204.52, 348)
				self.ZmAmmoParticleFX2right:setTopBottom(true, false, 126.6, 201.21)
				self.ZmAmmoParticleFX2right:setAlpha(1)
				self.ZmAmmoParticleFX2right:setZRot(180)
				f198_local12(ZmAmmoParticleFX2right, {})
				local f198_local13 = function(f239_arg0, f239_arg1)
					local f239_local0 = function(f240_arg0, f240_arg1)
						if not f240_arg1.interrupted then
							f240_arg0:beginAnimation("keyframe", 439, false, false, CoD.TweenType.Linear)
						end
						f240_arg0:setLeftRight(true, false, 204.52, 348)
						f240_arg0:setTopBottom(true, false, 127.6, 202.21)
						f240_arg0:setAlpha(0)
						f240_arg0:setZRot(180)
						if f240_arg1.interrupted then
							self.clipFinished(f240_arg0, f240_arg1)
						else
							f240_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
						end
					end

					if f239_arg1.interrupted then
						f239_local0(f239_arg0, f239_arg1)
						return
					else
						f239_arg0:beginAnimation("keyframe", 2930, false, false, CoD.TweenType.Linear)
						f239_arg0:registerEventHandler("transition_complete_keyframe", f239_local0)
					end
				end

				ZmAmmoParticleFX3right:completeAnimation()
				self.ZmAmmoParticleFX3right:setLeftRight(true, false, 204.52, 348)
				self.ZmAmmoParticleFX3right:setTopBottom(true, false, 127.6, 202.21)
				self.ZmAmmoParticleFX3right:setAlpha(0)
				self.ZmAmmoParticleFX3right:setZRot(180)
				f198_local13(ZmAmmoParticleFX3right, {})
				local f198_local14 = function(f241_arg0, f241_arg1)
					local f241_local0 = function(f242_arg0, f242_arg1)
						local f242_local0 = function(f243_arg0, f243_arg1)
							if not f243_arg1.interrupted then
								f243_arg0:beginAnimation("keyframe", 439, false, false, CoD.TweenType.Linear)
							end
							f243_arg0:setLeftRight(true, false, 110.67, 200.67)
							f243_arg0:setTopBottom(true, false, 8.5, 176.5)
							f243_arg0:setAlpha(0)
							if f243_arg1.interrupted then
								self.clipFinished(f243_arg0, f243_arg1)
							else
								f243_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
							end
						end

						if f242_arg1.interrupted then
							f242_local0(f242_arg0, f242_arg1)
							return
						else
							f242_arg0:beginAnimation("keyframe", 2360, false, false, CoD.TweenType.Linear)
							f242_arg0:registerEventHandler("transition_complete_keyframe", f242_local0)
						end
					end

					if f241_arg1.interrupted then
						f241_local0(f241_arg0, f241_arg1)
						return
					else
						f241_arg0:beginAnimation("keyframe", 300, false, false, CoD.TweenType.Linear)
						f241_arg0:registerEventHandler("transition_complete_keyframe", f241_local0)
					end
				end

				Lightning:completeAnimation()
				self.Lightning:setLeftRight(true, false, 110.67, 200.67)
				self.Lightning:setTopBottom(true, false, 8.5, 176.5)
				self.Lightning:setAlpha(0)
				f198_local14(Lightning, {})
				local f198_local15 = function(f244_arg0, f244_arg1)
					local f244_local0 = function(f245_arg0, f245_arg1)
						local f245_local0 = function(f246_arg0, f246_arg1)
							if not f246_arg1.interrupted then
								f246_arg0:beginAnimation("keyframe", 439, false, false, CoD.TweenType.Linear)
							end
							f246_arg0:setLeftRight(true, false, 35.74, 125.74)
							f246_arg0:setTopBottom(true, false, 62.25, 230.25)
							f246_arg0:setAlpha(0)
							f246_arg0:setZRot(40)
							f246_arg0:setScale(0.7)
							if f246_arg1.interrupted then
								self.clipFinished(f246_arg0, f246_arg1)
							else
								f246_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
							end
						end

						if f245_arg1.interrupted then
							f245_local0(f245_arg0, f245_arg1)
							return
						else
							f245_arg0:beginAnimation("keyframe", 2360, false, false, CoD.TweenType.Linear)
							f245_arg0:registerEventHandler("transition_complete_keyframe", f245_local0)
						end
					end

					if f244_arg1.interrupted then
						f244_local0(f244_arg0, f244_arg1)
						return
					else
						f244_arg0:beginAnimation("keyframe", 300, false, false, CoD.TweenType.Linear)
						f244_arg0:setAlpha(1)
						f244_arg0:registerEventHandler("transition_complete_keyframe", f244_local0)
					end
				end

				Lightning2:completeAnimation()
				self.Lightning2:setLeftRight(true, false, 35.74, 125.74)
				self.Lightning2:setTopBottom(true, false, 62.25, 230.25)
				self.Lightning2:setAlpha(0)
				self.Lightning2:setZRot(40)
				self.Lightning2:setScale(0.7)
				f198_local15(Lightning2, {})
				local f198_local16 = function(f247_arg0, f247_arg1)
					local f247_local0 = function(f248_arg0, f248_arg1)
						local f248_local0 = function(f249_arg0, f249_arg1)
							if not f249_arg1.interrupted then
								f249_arg0:beginAnimation("keyframe", 439, false, false, CoD.TweenType.Linear)
							end
							f249_arg0:setLeftRight(true, false, 186, 276)
							f249_arg0:setTopBottom(true, false, 60.5, 228.5)
							f249_arg0:setAlpha(0)
							f249_arg0:setZRot(-40)
							f249_arg0:setScale(0.7)
							if f249_arg1.interrupted then
								self.clipFinished(f249_arg0, f249_arg1)
							else
								f249_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
							end
						end

						if f248_arg1.interrupted then
							f248_local0(f248_arg0, f248_arg1)
							return
						else
							f248_arg0:beginAnimation("keyframe", 2360, false, false, CoD.TweenType.Linear)
							f248_arg0:registerEventHandler("transition_complete_keyframe", f248_local0)
						end
					end

					if f247_arg1.interrupted then
						f247_local0(f247_arg0, f247_arg1)
						return
					else
						f247_arg0:beginAnimation("keyframe", 300, false, false, CoD.TweenType.Linear)
						f247_arg0:setAlpha(1)
						f247_arg0:registerEventHandler("transition_complete_keyframe", f247_local0)
					end
				end

				Lightning3:completeAnimation()
				self.Lightning3:setLeftRight(true, false, 186, 276)
				self.Lightning3:setTopBottom(true, false, 60.5, 228.5)
				self.Lightning3:setAlpha(0)
				self.Lightning3:setZRot(-40)
				self.Lightning3:setScale(0.7)
				f198_local16(Lightning3, {})
				local f198_local17 = function(f250_arg0, f250_arg1)
					local f250_local0 = function(f251_arg0, f251_arg1)
						local f251_local0 = function(f252_arg0, f252_arg1)
							local f252_local0 = function(f253_arg0, f253_arg1)
								if not f253_arg1.interrupted then
									f253_arg0:beginAnimation("keyframe", 439, false, false, CoD.TweenType.Linear)
								end
								f253_arg0:setLeftRight(false, false, -112, 112)
								f253_arg0:setTopBottom(true, false, 328.5, 383.5)
								f253_arg0:setAlpha(0)
								if f253_arg1.interrupted then
									self.clipFinished(f253_arg0, f253_arg1)
								else
									f253_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
								end
							end

							if f252_arg1.interrupted then
								f252_local0(f252_arg0, f252_arg1)
								return
							else
								f252_arg0:beginAnimation("keyframe", 1590, false, false, CoD.TweenType.Linear)
								f252_arg0:registerEventHandler("transition_complete_keyframe", f252_local0)
							end
						end

						if f251_arg1.interrupted then
							f251_local0(f251_arg0, f251_arg1)
							return
						else
							f251_arg0:beginAnimation("keyframe", 770, false, false, CoD.TweenType.Linear)
							f251_arg0:registerEventHandler("transition_complete_keyframe", f251_local0)
						end
					end

					if f250_arg1.interrupted then
						f250_local0(f250_arg0, f250_arg1)
						return
					else
						f250_arg0:beginAnimation("keyframe", 300, false, false, CoD.TweenType.Linear)
						f250_arg0:setAlpha(1)
						f250_arg0:registerEventHandler("transition_complete_keyframe", f250_local0)
					end
				end

				xpaward:completeAnimation()
				self.xpaward:setLeftRight(false, false, -112, 112)
				self.xpaward:setTopBottom(true, false, 328.5, 383.5)
				self.xpaward:setAlpha(0)
				f198_local17(xpaward, {})
				local f198_local18 = function(f254_arg0, f254_arg1)
					local f254_local0 = function(f255_arg0, f255_arg1)
						local f255_local0 = function(f256_arg0, f256_arg1)
							local f256_local0 = function(f257_arg0, f257_arg1)
								if not f257_arg1.interrupted then
									f257_arg0:beginAnimation("keyframe", 340, false, false, CoD.TweenType.Linear)
								end
								f257_arg0:setAlpha(0)
								if f257_arg1.interrupted then
									self.clipFinished(f257_arg0, f257_arg1)
								else
									f257_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
								end
							end

							if f256_arg1.interrupted then
								f256_local0(f256_arg0, f256_arg1)
								return
							else
								f256_arg0:beginAnimation("keyframe", 3349, false, false, CoD.TweenType.Linear)
								f256_arg0:registerEventHandler("transition_complete_keyframe", f256_local0)
							end
						end

						if f255_arg1.interrupted then
							f255_local0(f255_arg0, f255_arg1)
							return
						else
							f255_arg0:beginAnimation("keyframe", 439, false, false, CoD.TweenType.Linear)
							f255_arg0:setAlpha(1)
							f255_arg0:registerEventHandler("transition_complete_keyframe", f255_local0)
						end
					end

					if f254_arg1.interrupted then
						f254_local0(f254_arg0, f254_arg1)
						return
					else
						f254_arg0:beginAnimation("keyframe", 2660, false, false, CoD.TweenType.Linear)
						f254_arg0:registerEventHandler("transition_complete_keyframe", f254_local0)
					end
				end

				CursorHint:completeAnimation()
				self.CursorHint:setAlpha(0)
				f198_local18(CursorHint, {})
				local f198_local19 = function(f258_arg0, f258_arg1)
					local f258_local0 = function(f259_arg0, f259_arg1)
						local f259_local0 = function(f260_arg0, f260_arg1)
							if not f260_arg1.interrupted then
								f260_arg0:beginAnimation("keyframe", 330, false, false, CoD.TweenType.Linear)
							end
							f260_arg0:setAlpha(0)
							if f260_arg1.interrupted then
								self.clipFinished(f260_arg0, f260_arg1)
							else
								f260_arg0:registerEventHandler("transition_complete_keyframe", self.clipFinished)
							end
						end

						if f259_arg1.interrupted then
							f259_local0(f259_arg0, f259_arg1)
							return
						else
							f259_arg0:beginAnimation("keyframe", 6149, false, false, CoD.TweenType.Linear)
							f259_arg0:registerEventHandler("transition_complete_keyframe", f259_local0)
						end
					end

					if f258_arg1.interrupted then
						f258_local0(f258_arg0, f258_arg1)
						return
					else
						f258_arg0:beginAnimation("keyframe", 300, false, false, CoD.TweenType.Linear)
						f258_arg0:setAlpha(1)
						f258_arg0:registerEventHandler("transition_complete_keyframe", f258_local0)
					end
				end

				Last5RoundTime:completeAnimation()
				self.Last5RoundTime:setAlpha(0)
				f198_local19(Last5RoundTime, {})
			end
		}
	}

	LUI.OverrideFunction_CallOriginalSecond(self, "close", function(element)
		element.PowerupBacker:close()
		element.PowerupBackerLeft:close()
		element.PowerupBackerRight:close()
		element.PowerupTexture:close()
		element.Panel:close()
		element.ZmNotif1CursorHint0:close()
		element.ZmNotifFactory:close()
		element.ZmFxSpark20:close()
		element.ZmAmmoParticleFX1left:close()
		element.ZmAmmoParticleFX2left:close()
		element.ZmAmmoParticleFX3left:close()
		element.ZmAmmoParticleFX1right:close()
		element.ZmAmmoParticleFX2right:close()
		element.ZmAmmoParticleFX3right:close()
		element.xpaward:close()
		element.CursorHint:close()
		element.Last5RoundTime:close()
	end)

	if PostLoadFunc then
		PostLoadFunc(self, controller, menu)
	end

	return self
end
