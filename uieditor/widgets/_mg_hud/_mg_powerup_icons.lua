CoD.PowerUps = {}
CoD.PowerUps.IconSize = 48
CoD.PowerUps.UpgradeIconSize = 36
CoD.PowerUps.Spacing = 8
CoD.PowerUps.STATE_OFF = 0
CoD.PowerUps.STATE_ON = 1
CoD.PowerUps.STATE_FLASHING_OFF = 2
CoD.PowerUps.STATE_FLASHING_ON = 3
CoD.PowerUps.FLASHING_STAGE_DURATION = 500
CoD.PowerUps.MOVING_DURATION = 500

CoD.PowerUps.UpGradeIconColorRed = 
{
	r = 1,
	g = 0,
	b = 0
}

CoD.PowerUps.ClientFieldNames = 
{
    {
        clientFieldName = "powerup_instant_kill",
        material = RegisterMaterial( "tf2_powerup_instakill" )
    },
    {
        clientFieldName = "powerup_double_points",
        material = RegisterMaterial( "tf2_powerup_double" ),
    },
    {
        clientFieldName = "powerup_fire_sale",
        material = RegisterMaterial( "tf2_powerup_firesale" )
    },
    {
        clientFieldName = "powerup_bon_fire",
        material = RegisterMaterial( "tf2_powerup_bonfire" )
    },
    {
        clientFieldName = "powerup_mini_gun",
        material = RegisterMaterial( "tf2_powerup_deathmachine" )
    },
    {
        clientFieldName = "powerup_zombie_blood",
        material = RegisterMaterial( "tf2_powerup_blood" )
    },
    {
        clientFieldName = "powerup_double_points_player",
        material = RegisterMaterial( "tf2_powerup_double" )
    },
    {
        clientFieldName = "powerup_instant_kill_player",
        material = RegisterMaterial( "tf2_powerup_instakill" )
    },
    {
        clientFieldName = "uber",
        material = RegisterMaterial( "tf2_powerup_blood" )
	},
    {
        clientFieldName = "powerup_time_freeze",
        material = RegisterMaterial( "tf2_powerup_timefreeze" )
    }
}

CoD.PowerUps.UpgradeClientFieldNames = 
{
    {
        clientFieldName = "powerup_instant_kill_ug",
        material = RegisterMaterial( "specialty_instakill_zombies" ),
        color = CoD.PowerUps.UpGradeIconColorRed
    }
}

LUI.createMenu.PowerUpsArea = function ( controller )
    for index=1, #CoD.PowerUps.ClientFieldNames do
        local powerupCFName = CoD.PowerUps.ClientFieldNames[ index ].clientFieldName
        local powerupTimeModel = Engine.CreateModel( Engine.GetModelForController( controller ), powerupCFName .. ".time" )
    end

	local menu = CoD.Menu.NewSafeAreaFromState( "PowerUpsArea", controller )
	menu:setOwner( controller )
	menu.scaleContainer = CoD.SplitscreenScaler.new( nil, CoD.Zombie.SplitscreenMultiplier )
	menu.scaleContainer:setLeftRight( false, false, 0, 0 )
	menu.scaleContainer:setTopBottom( false, true, 0, 0 )
	menu:addElement( menu.scaleContainer )
	menu.powerUps = {}
	for index = 1, #CoD.PowerUps.ClientFieldNames, 1 do
	
		local self = LUI.UIElement.new()
		
		self:setLeftRight( false, false, -CoD.PowerUps.IconSize * 0.5, CoD.PowerUps.IconSize * 0.5 )
		self:setTopBottom( false, true, -CoD.PowerUps.IconSize + CoD.PowerUps.UpgradeIconSize + 10 - 25, -25 )
		self:registerEventHandler( "transition_complete_off_fade_out", CoD.PowerUps.PowerUpIcon_UpdatePosition )
		
		self.powerUpIcon = LUI.UIImage.new()
		self.powerUpIcon:setLeftRight( true, true, 0, 0 )
		self.powerUpIcon:setTopBottom( false, true, -CoD.PowerUps.IconSize, 0 )
		self.powerUpIcon:setAlpha( 0 )
		self:addElement( self.powerUpIcon )
		
		self.upgradePowerUpIcon = LUI.UIImage.new()
		self.upgradePowerUpIcon:setLeftRight( false, false, -CoD.PowerUps.UpgradeIconSize / 2, CoD.PowerUps.UpgradeIconSize / 2 )
		self.upgradePowerUpIcon:setTopBottom( true, false, 0, CoD.PowerUps.UpgradeIconSize )
		self.upgradePowerUpIcon:setAlpha( 0 )
		self:addElement( self.upgradePowerUpIcon )
		
		self.powerupId = nil
		menu.scaleContainer:addElement( self )
		menu.powerUps[ index ] = self
		menu:registerEventHandler( CoD.PowerUps.ClientFieldNames[ index ].clientFieldName, CoD.PowerUps.Update )
		menu:registerEventHandler( CoD.PowerUps.ClientFieldNames[ index ].clientFieldName .. "_ug", CoD.PowerUps.UpgradeUpdate )
        menu:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), CoD.PowerUps.ClientFieldNames[ index ].clientFieldName .. ".time" ), function( ModelRef )
            menu:processEvent(
			{
                name = "update_" .. CoD.PowerUps.ClientFieldNames[ index ].clientFieldName .. "_time", 
                time = Engine.GetModelValue( ModelRef )
            } )
        end )
	end

	menu.activePowerUpCount = 0

	menu:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_VISIBLE ), function ( ModelRef ) CoD.PowerUps.UpdateVisibility( menu, controller ) end )
	menu:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_PLAYER_IN_AFTERLIFE ), function ( ModelRef ) CoD.PowerUps.UpdateVisibility( menu, controller ) end )
	menu:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_EMP_ACTIVE ), function ( ModelRef ) CoD.PowerUps.UpdateVisibility( menu, controller ) end )
	menu:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_UI_ACTIVE ), function ( ModelRef ) CoD.PowerUps.UpdateVisibility( menu, controller ) end )
	menu:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SPECTATING_CLIENT ), function ( ModelRef ) CoD.PowerUps.UpdateVisibility( menu, controller ) end )
	menu:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN ), function ( ModelRef ) CoD.PowerUps.UpdateVisibility( menu, controller ) end )
	menu:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_VEHICLE ), function ( ModelRef ) CoD.PowerUps.UpdateVisibility( menu, controller ) end )
	menu:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE ), function ( ModelRef ) CoD.PowerUps.UpdateVisibility( menu, controller ) end )
	menu:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC ), function ( ModelRef ) CoD.PowerUps.UpdateVisibility( menu, controller ) end )
	menu:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_SCOPED ), function ( ModelRef ) CoD.PowerUps.UpdateVisibility( menu, controller ) end )
	menu:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED ), function ( ModelRef ) CoD.PowerUps.UpdateVisibility( menu, controller ) end )
	menu:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM ), function ( ModelRef ) CoD.PowerUps.UpdateVisibility( menu, controller ) end )
	menu:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN ), function ( ModelRef ) CoD.PowerUps.UpdateVisibility( menu, controller ) end )
	menu:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_GAME_ENDED ), function ( ModelRef ) CoD.PowerUps.UpdateVisibility( menu, controller ) end )

	menu:registerEventHandler( "powerups_update_position", CoD.PowerUps.UpdatePosition )
    
	menu.visible = true

	return menu
end

CoD.PowerUps.UpdateVisibility = function ( menu, controller )
	if Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_HUD_VISIBLE ) and 
	not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_PLAYER_IN_AFTERLIFE ) and 
	not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_EMP_ACTIVE ) and 
	not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM ) and 
	not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN ) and 
	not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_UI_ACTIVE ) and 
	not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_KILLCAM ) and 
	not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN ) and
    ( not CoD.IsShoutcaster( controller ) or CoD.ShoutcasterProfileVarBool( controller, "shoutcaster_teamscore" ) ) and 
	not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE ) and 
	not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC ) and 
	not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_SCOPED ) and 
	not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_VEHICLE ) and 
	not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED ) and 
	not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_GAME_ENDED ) then
		if not menu.visible then
			menu:setAlpha( 1 )
			menu.visible = true
		end
	elseif menu.visible then
		menu:setAlpha( 0 )
		menu.visible = nil
	end
end

CoD.PowerUps.Update = function ( element, event )
	CoD.PowerUps.UpdateState( element, event )
	CoD.PowerUps.UpdatePosition( element, event )
end

CoD.PowerUps.UpdateState = function ( element, event )
	local powerUp = nil
	local index = CoD.PowerUps.GetExistingPowerUpIndex( element, event.name )
	if index ~= nil then
		powerUp = element.powerUps[ index ]
		if event.newValue == CoD.PowerUps.STATE_ON then
			powerUp.powerUpId = event.name
			powerUp.powerUpIcon:setImage( CoD.PowerUps.GetMaterial( element, event.controller, event.name ) )
			powerUp.powerUpIcon:setAlpha( 1 )
		elseif event.newValue == CoD.PowerUps.STATE_OFF then
			powerUp.powerUpIcon:beginAnimation( "off_fade_out", CoD.PowerUps.FLASHING_STAGE_DURATION )
			powerUp.powerUpIcon:setAlpha( 0 )
			powerUp.upgradePowerUpIcon:beginAnimation( "off_fade_out", CoD.PowerUps.FLASHING_STAGE_DURATION )
			powerUp.upgradePowerUpIcon:setAlpha( 0 )
			powerUp.powerUpId = nil
			element.activePowerUpCount = element.activePowerUpCount - 1
		elseif event.newValue == CoD.PowerUps.STATE_FLASHING_OFF then
			powerUp.powerUpIcon:beginAnimation( "fade_out", CoD.PowerUps.FLASHING_STAGE_DURATION )
			powerUp.powerUpIcon:setAlpha( 0 )
		elseif event.newValue == CoD.PowerUps.STATE_FLASHING_ON then
			powerUp.powerUpIcon:beginAnimation( "fade_in", CoD.PowerUps.FLASHING_STAGE_DURATION )
			powerUp.powerUpIcon:setAlpha( 1 )
		end
	elseif event.newValue == CoD.PowerUps.STATE_ON or event.newValue == CoD.PowerUps.STATE_FLASHING_ON then
		local index = CoD.PowerUps.GetFirstAvailablePowerUpIndex( element )
		if index ~= nil then
			powerUp = element.powerUps[ index ]
			powerUp.powerUpId = event.name
			powerUp.powerUpIcon:setImage( CoD.PowerUps.GetMaterial( element, event.controller, event.name ) )
			powerUp.powerUpIcon:setAlpha( 1 )
			element.activePowerUpCount = element.activePowerUpCount + 1
		end
	end
end

CoD.PowerUps.UpgradeUpdate = function ( element, event )
	CoD.PowerUps.UpgradeUpdateState( element, event )
end

CoD.PowerUps.UpgradeUpdateState = function ( element, event )
	local powerUp = nil
	local index = CoD.PowerUps.GetExistingPowerUpIndex( element, string.sub( event.name, 0, -4 ) )
	if index ~= nil then
		powerUp = element.powerUps[ index ].upgradePowerUpIcon
		if event.newValue == CoD.PowerUps.STATE_ON then
			powerUp:setImage( CoD.PowerUps.GetUpgradeMaterial( element, event.name ) )
			powerUp:setAlpha( 1 )
			CoD.PowerUps.SetUpgradeColor( powerUp, event.name )
		elseif event.newValue == CoD.PowerUps.STATE_OFF then
			powerUp:beginAnimation( "off_fade_out", CoD.PowerUps.FLASHING_STAGE_DURATION )
			powerUp:setAlpha( 0 )
		elseif event.newValue == CoD.PowerUps.STATE_FLASHING_OFF then
			powerUp:beginAnimation( "fade_out", CoD.PowerUps.FLASHING_STAGE_DURATION )
			powerUp:setAlpha( 0 )
		elseif event.newValue == CoD.PowerUps.STATE_FLASHING_ON then
			powerUp:beginAnimation( "fade_in", CoD.PowerUps.FLASHING_STAGE_DURATION )
			powerUp:setAlpha( 1 )
		end
	end
end

CoD.PowerUps.GetMaterial = function ( element, controller, clientFieldName )
	local material = nil
	for index = 1, #CoD.PowerUps.ClientFieldNames, 1 do
		if CoD.PowerUps.ClientFieldNames[ index ].clientFieldName == clientFieldName then
			material = CoD.PowerUps.ClientFieldNames[ index ].material
			break
		end
	end
	return material
end

CoD.PowerUps.GetUpgradeMaterial = function ( element, clientFieldName )
	local material = nil
	for index = 1, #CoD.PowerUps.UpgradeClientFieldNames, 1 do
		if CoD.PowerUps.UpgradeClientFieldNames[ index ].clientFieldName == clientFieldName then
			material = CoD.PowerUps.UpgradeClientFieldNames[ index ].material
			break
		end
	end
	return material
end

CoD.PowerUps.SetUpgradeColor = function ( element, clientFieldName )
	local color = nil
	for index = 1, #CoD.PowerUps.UpgradeClientFieldNames, 1 do
		if CoD.PowerUps.UpgradeClientFieldNames[ index ].clientFieldName == clientFieldName then
			if CoD.PowerUps.UpgradeClientFieldNames[ index ].color then
				element:setRGB( CoD.PowerUps.UpgradeClientFieldNames[ index ].color.r, CoD.PowerUps.UpgradeClientFieldNames[ index ].color.g, CoD.PowerUps.UpgradeClientFieldNames[ index ].color.b )
				break
			end
		end
	end
end

CoD.PowerUps.GetExistingPowerUpIndex = function ( element, powerUpId )
	for index = 1, #CoD.PowerUps.ClientFieldNames, 1 do
		if element.powerUps[ index ].powerUpId == powerUpId then
			return index
		end
	end
	return nil
end

CoD.PowerUps.GetFirstAvailablePowerUpIndex = function ( element )
	for index = 1, #CoD.PowerUps.ClientFieldNames, 1 do
		if not element.powerUps[ index ].powerUpId then
			return index
		end
	end
	return nil
end

CoD.PowerUps.PowerUpIcon_UpdatePosition = function ( element, event )
	if event.interrupted ~= true then
		element:dispatchEventToParent( 
		{
			name = "powerups_update_position"
		} )
	end
end

CoD.PowerUps.UpdatePosition = function ( element, event )
	local powerUp = nil
	local LeftAnchor = 0
	local RightAnchor = 0
	local AnimationOffset = nil
	for index = 1, #CoD.PowerUps.ClientFieldNames, 1 do
		powerUp = element.powerUps[ index ]
		if powerUp.powerUpId ~= nil then
			if not AnimationOffset then
				LeftAnchor = -( CoD.PowerUps.IconSize * 0.5 * element.activePowerUpCount + CoD.PowerUps.Spacing * 0.5 * ( element.activePowerUpCount - 1 ) )
			else
				LeftAnchor = AnimationOffset + CoD.PowerUps.IconSize + CoD.PowerUps.Spacing
			end
			RightAnchor = LeftAnchor + CoD.PowerUps.IconSize
			powerUp:beginAnimation( "move", CoD.PowerUps.MOVING_DURATION )
			powerUp:setLeftRight( false, false, LeftAnchor, RightAnchor )
			AnimationOffset = LeftAnchor
		end
	end
end