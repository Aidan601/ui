require( "ui.uieditor.widgets._mg_hud._mg_score_plus_points_container" )
require( "ui.uieditor.widgets._mg_hud._mg_score_clients" )
require( "ui.uieditor.widgets._mg_hud._mg_score_self" )
--[[
DataSources.ZMPlayerList = 
{
	getModel = function ( controller )
		return Engine.CreateModel( Engine.GetModelForController( controller ), "PlayerList" )
	end
}
]]
local PlayPlusPoints = function ( parent, n_amount, controller, menu, b_scale, s_info )
	if n_amount == 0 or n_amount < -10000 or n_amount > 10000 then
		return 
	end
	local uie_plus_points_container = CoD._mg_score_plus_points_container.new( menu, controller )
	uie_plus_points_container.scoreEmitterInfo = s_info
	if 0 < n_amount then
		uie_plus_points_container.ZMScrPlusPoints.Label1:setText( "+" .. n_amount )
		uie_plus_points_container.ZMScrPlusPoints.Label2:setText( "+" .. n_amount )
		uie_plus_points_container.ZMScrPlusPoints:playClip( "DefaultClip" )
	else
		uie_plus_points_container.ZMScrPlusPoints.Label1:setText( n_amount )
		uie_plus_points_container.ZMScrPlusPoints.Label2:setText( n_amount )
		uie_plus_points_container.ZMScrPlusPoints:playClip( "NegativeScore" )
	end
	uie_plus_points_container:setLeftRight( parent:getLocalLeftRight() )
	uie_plus_points_container:setTopBottom( parent:getLocalTopBottom() )
	if b_scale then
		uie_plus_points_container:setScale( 0.75 )
	end
	parent.lastAnim = parent.lastAnim + 1
	uie_plus_points_container:setState( "DefaultState" )
	if not uie_plus_points_container:hasClip( "Anim" .. parent.lastAnim ) then
		parent.lastAnim = 1
	end
	uie_plus_points_container:registerEventHandler( "clip_over", function ( element, event )
		local info = element.scoreEmitterInfo
		element:close()
		CoD.perController[ info.controller ].scoreEmitterCount[ info.index ][ info.type ] = CoD.perController[ info.controller ].scoreEmitterCount[ info.index ][ info.type ] - 1
	end )
	local parents_parent = parent:getParent()
	parents_parent:addElement( uie_plus_points_container )
	uie_plus_points_container:playClip( "Anim" .. parent.lastAnim )
end

local PreLoadFunc = function ( self, controller )
end

local PostLoadFunc = function ( self, controller, menu )
	local n_max_delay = 128
	local n_max_instant = 64
	local n_max_players = 4
	local a_damage_points = 
	{
		damage = 10,
		death_normal = 50,
		death_torso = 60,
		death_neck = 70,
		death_head = 100,
		death_melee = 130
	}
	local uim_controller_model = Engine.GetModelForController( controller )
	CoD.perController[ controller ].scoreEmitterCount = {}
	for i = 0, n_max_players - 1, 1 do
		local n_index = i
		local uie_plus_points = self[ "ZMScrPlusPoints" .. n_index ]
		uie_plus_points:setAlpha( 0 )
		uie_plus_points.lastAnim = 0
		CoD.perController[ controller ].scoreEmitterCount[ n_index ] = {}
		CoD.perController[ controller ].scoreEmitterCount[ n_index ].delayed = 0
		CoD.perController[ controller ].scoreEmitterCount[ n_index ].instant = 0
		local uim_client_num = Engine.GetModel( uim_controller_model, "PlayerList." .. n_index .. ".clientNum" )
		if uim_client_num then
			uim_client_num = Engine.GetModelValue( uim_client_num )
		end
		if uim_client_num ~= nil then
			local uim_player = Engine.GetModel( uim_controller_model, "PlayerList.client" .. uim_client_num )
			if uim_player ~= nil then
				for key, value in pairs( a_damage_points ) do
					uie_plus_points:registerEventHandler( "delayed_score", function ( element, event )
						PlayPlusPoints( element, event.score, controller, menu, n_index > 0, 
						{
							controller = controller,
							index = n_index,
							type = "delayed"
						} )
					end )
					uie_plus_points:subscribeToModel( Engine.CreateModel( uim_player, "score_cf_" .. key ), function ( modelRef )
						if Engine.GetModelValue( modelRef ) ~= nil then
							local n_value = value
							local uim_double_points = Engine.GetModel( uim_controller_model, "hudItems.doublePointsActive" )
							if uim_double_points ~= nil and Engine.GetModelValue( uim_double_points ) == 1 then
								n_value = value * 2
							end
							if uie_plus_points.accountedForScore ~= nil then
								uie_plus_points.accountedForScore = uie_plus_points.accountedForScore + n_value
							end
							if CoD.perController[ controller ].scoreEmitterCount[ n_index ].delayed < n_max_delay then
								CoD.perController[ controller ].scoreEmitterCount[ n_index ].delayed = CoD.perController[ controller ].scoreEmitterCount[ n_index ].delayed + 1
								self:addElement( LUI.UITimer.new( 16 * Engine.GetModelValue( modelRef ) % 3, 
								{
									name = "delayed_score",
									score = n_value
								}, true, uie_plus_points ) )
							end
						end
					end )
				end
			end
		end
		local uim_player = Engine.GetModel( uim_controller_model, "PlayerList." .. n_index .. ".playerScore" )
		uie_plus_points.accountedForScore = Engine.GetModelValue( uim_player )
		uie_plus_points:subscribeToModel( uim_player, function ( modelRef )
			local modelValue = Engine.GetModelValue( modelRef )
			if uie_plus_points.accountedForScore == nil then
				uie_plus_points.accountedForScore = modelValue
			end
			if modelValue ~= uie_plus_points.accountedForScore then
				if CoD.perController[ controller ].scoreEmitterCount[ n_index ].instant < n_max_instant then
					CoD.perController[ controller ].scoreEmitterCount[ n_index ].instant = CoD.perController[ controller ].scoreEmitterCount[ n_index ].instant + 1
					PlayPlusPoints( uie_plus_points, modelValue - uie_plus_points.accountedForScore, controller, menu, n_index > 0, 
					{
						controller = controller,
						index = n_index,
						type = "instant"
					} )
				end
				uie_plus_points.accountedForScore = modelValue
			end
		end )
	end
	Engine.CreateModel( uim_controller_model, "hudItems.doublePointsActive" )
end

CoD._mg_score_container = InheritFrom( LUI.UIElement )
CoD._mg_score_container.new = function ( menu, controller )

	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD._mg_score_container )
	self.id = "_mg_score_container"
	self.soundSet = "HUD"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self:makeFocusable()
	self.onlyChildrenFocusable = true
	self.anyChildUsesUpdateState = true

	self.ListingUser = LUI.UIList.new( menu, controller, 2, 0, nil, false, false, 0, 0, false, false )
	self.ListingUser:makeFocusable()
    self.ListingUser:setLeftRight( true, false, 13, 184 )
    self.ListingUser:setTopBottom( false, true, -62, -32 )
	self.ListingUser:setWidgetType( CoD._mg_score_self )
	self.ListingUser:setDataSource( "PlayerListZM" )
	self.ListingUser:mergeStateConditions( 
	{
		{
			stateName = "Visible",
			condition = function ( menu, element, event )
				local f10_local0
				if not IsSelfModelValueEqualTo( element, controller, "playerScoreShown", 0 ) then
					f10_local0 = AlwaysTrue()
				else
					f10_local0 = false
				end
				return f10_local0
			end
		}
	} )
	self.ListingUser:linkToElementModel( self.ListingUser, "playerScoreShown", true, function ( modelRef )
		menu:updateElementState( self.ListingUser, 
		{
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "playerScoreShown"
		} )
	end )
	self:addElement( self.ListingUser )
	-- self.ListingUser = ListingUser
	-- self:addElement( self.ListingUser )
	
	self.Listing2 = CoD._mg_score_clients.new( menu, controller )
    self.Listing2:setLeftRight( true, false, 18, 167.5 )
    self.Listing2:setTopBottom( false, true, 18, 8 )
	self.Listing2:subscribeToGlobalModel( controller, "ZMPlayerList", "1", function( ModelRef )
		self.Listing2:setModel( ModelRef, controller )
	end)

	self:addElement( self.Listing2 )
	
	self.Listing3 = CoD._mg_score_clients.new( menu, controller )
    self.Listing3:setLeftRight( true, false, 18, 167.5 )
    self.Listing3:setTopBottom( false, true, -47, -37 )
	self.Listing3:subscribeToGlobalModel( controller, "ZMPlayerList", "2", function( ModelRef )
		self.Listing3:setModel( ModelRef, controller )
	end)

	self:addElement( self.Listing3 )
	
	self.Listing4 = CoD._mg_score_clients.new( menu, controller )
    self.Listing4:setLeftRight( true, false, 18, 167.5 )
    self.Listing4:setTopBottom( false, true, -90, -80 )
	self.Listing4:subscribeToGlobalModel( controller, "ZMPlayerList", "3", function( ModelRef )
		self.Listing4:setModel( ModelRef, controller )
	end)

	self:addElement( self.Listing4 )

	local ZMScrPlusPoints0 = CoD._mg_score_plus_points_container.new( menu, controller )
	ZMScrPlusPoints0:setLeftRight( true, false, 13 + 80, 184 + 80 )
	ZMScrPlusPoints0:setTopBottom( false, true, -62 - 20, -32 - 20 )
	self:addElement( ZMScrPlusPoints0 )
	self.ZMScrPlusPoints0 = ZMScrPlusPoints0
	
	local ZMScrPlusPoints1 = CoD._mg_score_plus_points_container.new( menu, controller )
	ZMScrPlusPoints1:setLeftRight( true, false, 18 + 80, 167.5 + 80 )
	ZMScrPlusPoints1:setTopBottom( false, true, 18, 8 )
	ZMScrPlusPoints1:setScale( 0.75 )
	self:addElement( ZMScrPlusPoints1 )
	self.ZMScrPlusPoints1 = ZMScrPlusPoints1
	
	local ZMScrPlusPoints2 = CoD._mg_score_plus_points_container.new( menu, controller )
	ZMScrPlusPoints2:setLeftRight( true, false, 18 + 80, 167.5 + 80 )
	ZMScrPlusPoints2:setTopBottom( false, true, -47, -37 )
	ZMScrPlusPoints2:setScale( 0.75 )
	self:addElement( ZMScrPlusPoints2 )
	self.ZMScrPlusPoints2 = ZMScrPlusPoints2
	
	local ZMScrPlusPoints3 = CoD._mg_score_plus_points_container.new( menu, controller )
	ZMScrPlusPoints3:setLeftRight( true, false, 18 + 80, 167.5 + 80 )
	ZMScrPlusPoints3:setTopBottom( false, true, -90, -80 )
	ZMScrPlusPoints3:setScale( 0.75 )
	self:addElement( ZMScrPlusPoints3 )
	self.ZMScrPlusPoints3 = ZMScrPlusPoints3

    self.ListingUser.Anchor = -20
    self.Listing2.Anchor = 12
    self.Listing3.Anchor = 12
    self.Listing4.Anchor = 12
	
	self.clipsPerState = 
	{
		DefaultState = 
		{
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )

                self.ListingUser:completeAnimation()
				self.ListingUser:beginAnimation( "keyframe", 250, false, false, CoD.TweenType.Linear )
                self.ListingUser:setAlpha( 0 )
				self.clipFinished( self.ListingUser, {} )

                self.Listing2:completeAnimation()
				self.Listing2:beginAnimation( "keyframe", 250, false, false, CoD.TweenType.Linear )
                self.Listing2:setAlpha( 0 )
				self.clipFinished( self.Listing2, {} )
           
                self.Listing3:completeAnimation()
				self.Listing3:beginAnimation( "keyframe", 250, false, false, CoD.TweenType.Linear )
                self.Listing3:setAlpha( 0 )
				self.clipFinished( self.Listing3, {} )
              
            
                self.Listing4:completeAnimation()
				self.Listing4:beginAnimation( "keyframe", 250, false, false, CoD.TweenType.Linear )
                self.Listing4:setAlpha( 0 )
				self.clipFinished( self.Listing4, {} )
			end
		},
		HudStart = 
		{
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )

                self.ListingUser:completeAnimation()
				self.ListingUser:beginAnimation( "keyframe", 250, false, false, CoD.TweenType.Linear )
                self.ListingUser:setAlpha( 1 )
				self.clipFinished( self.ListingUser, {} )

                self.Listing2:completeAnimation()
				self.Listing2:beginAnimation( "keyframe", 250, false, false, CoD.TweenType.Linear )
                self.Listing2:setAlpha( 1 )
				self.clipFinished( self.Listing2, {} )
           
                self.Listing3:completeAnimation()
				self.Listing3:beginAnimation( "keyframe", 250, false, false, CoD.TweenType.Linear )
                self.Listing3:setAlpha( 1 )
				self.clipFinished( self.Listing3, {} )
              
            
                self.Listing4:completeAnimation()
				self.Listing4:beginAnimation( "keyframe", 250, false, false, CoD.TweenType.Linear )
                self.Listing4:setAlpha( 1 )
				self.clipFinished( self.Listing4, {} )
			end
		}
	}

    self:mergeStateConditions(
	{
        {
            stateName = "HudStart",
            condition = function ( menu, element, event )
                if IsModelValueTrue( controller, "hudItems.playerSpawned" ) then
                    if Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_HUD_VISIBLE ) and
                    Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE ) and 
					not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_HUD_HARDCORE ) and 
					not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_GAME_ENDED ) and 
					not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM ) and 
					not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN ) and 
					not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_KILLCAM ) and 
					not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED ) and 
					not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_UI_ACTIVE ) and 
					not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_SCOPED ) and 
					not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_VEHICLE ) and 
					not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE ) and 
					not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN ) and 
					not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC ) and 
					not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_EMP_ACTIVE ) then
                        return true
                    else
                        return false
                    end
                end
            end
        }
    })
    
    self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.playerSpawned" ), function( ModelRef )
        menu:updateElementState( self, 
		{
            name = "model_validation",
            menu = menu,
            modelValue = Engine.GetModelValue( ModelRef ),
            modelName = "hudItems.playerSpawned"
        })
    end)
    self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_VISIBLE ), function( ModelRef )
        menu:updateElementState( self, 
		{
            name = "model_validation",
            menu = menu,
            modelValue = Engine.GetModelValue( ModelRef ),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_VISIBLE
        })
    end)
    self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE ), function( ModelRef )
        menu:updateElementState( self, 
		{
            name = "model_validation",
            menu = menu,
            modelValue = Engine.GetModelValue( ModelRef ),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE
        })
    end)
    self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_HARDCORE ), function( ModelRef )
        menu:updateElementState( self, 
		{
            name = "model_validation",
            menu = menu,
            modelValue = Engine.GetModelValue( ModelRef ),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_HARDCORE
        })
    end) 
    self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_GAME_ENDED ), function( ModelRef )
        menu:updateElementState( self, 
		{
            name = "model_validation",
            menu = menu,
            modelValue = Engine.GetModelValue( ModelRef ),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_GAME_ENDED
        })
    end)
    self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM ), function( ModelRef )
        menu:updateElementState( self, 
		{
            name = "model_validation",
            menu = menu,
            modelValue = Engine.GetModelValue( ModelRef ),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM
        })
    end)
    self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN ), function( ModelRef )
        menu:updateElementState( self, 
		{
            name = "model_validation",
            menu = menu,
            modelValue = Engine.GetModelValue( ModelRef ),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN
        })
    end)
    self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_KILLCAM ), function( ModelRe )
        menu:updateElementState( self, 
		{
            name = "model_validation",
            menu = menu,
            modelValue = Engine.GetModelValue( ModelRef ),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_KILLCAM
        })
    end)
    self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED ), function( ModelRef )
        menu:updateElementState( self, 
		{
            name = "model_validation",
            menu = menu,
            modelValue = Engine.GetModelValue( ModelRef ),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED
        })
    end)
    self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_UI_ACTIVE ), function( ModelRef )
        menu:updateElementState( self, 
		{
            name = "model_validation",
            menu = menu,
            modelValue = Engine.GetModelValue( ModelRef ),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_UI_ACTIVE
        })
    end)
    self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_SCOPED ), function( ModelRef )
        menu:updateElementState( self, 
		{
            name = "model_validation",
            menu = menu,
            modelValue = Engine.GetModelValue( ModelRef ),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_SCOPED
        })
    end)
    self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_VEHICLE ), function( ModelRef )
        menu:updateElementState( self, 
		{
            name = "model_validation",
            menu = menu,
            modelValue = Engine.GetModelValue( ModelRef ),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_VEHICLE
        })
    end)
    self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE ), function( ModelRef )
        menu:updateElementState( self, 
		{
            name = "model_validation",
            menu = menu,
            modelValue = Engine.GetModelValue( ModelRef ),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE
        })
    end)
    self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN ), function( ModelRef )
        menu:updateElementState( self, 
		{
            name = "model_validation",
            menu = menu,
            modelValue = Engine.GetModelValue( ModelRef ),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN
        })
    end)
    self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC ), function( ModelRef )
        menu:updateElementState( self, 
		{
            name = "model_validation",
            menu = menu,
            modelValue = Engine.GetModelValue( ModelRef ),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC
        })
    end)
    self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_EMP_ACTIVE ), function( ModelRef )
        menu:updateElementState( self, 
		{
            name = "model_validation",
            menu = menu,
            modelValue = Engine.GetModelValue( ModelRef ),
            modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_EMP_ACTIVE
        })
    end)

	self.ListingUser.id = "ListingUser"

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.ListingUser:close()
		element.Listing2:close()
		element.Listing3:close()
		element.Listing4:close()
		element.ZMScrPlusPoints0:close()
		element.ZMScrPlusPoints1:close()
		element.ZMScrPlusPoints2:close()
		element.ZMScrPlusPoints3:close()
	end)

	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end

	return self
end