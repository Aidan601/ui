CoD._mg_ammo_attachment_container = InheritFrom( LUI.UIElement )
CoD._mg_ammo_attachment_container.new = function ( menu, controller )

	local self = LUI.UIElement.new()
	
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	
	self:setUseStencil( false )
	self:setClass( CoD._mg_ammo_attachment_container )
	self.id = "_mg_ammo_attachment_container"
	self.soundSet = "HUD"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self.anyChildUsesUpdateState = true
	
	local attachment_icon = LUI.UIImage.new()
	attachment_icon:setLeftRight( true, false, 960 + 28 + 28 + 28, 960 + 22 + 28 + 28 + 28 )
	attachment_icon:setTopBottom( true, false, 662, 662 + 22 )
	attachment_icon:setImage( RegisterImage( "xenonbutton_dpad_left" ) )
	self:addElement( attachment_icon )
	self.attachment_icon = attachment_icon
	
	local no_attachment_indicator = LUI.UIImage.new()
	no_attachment_indicator:setLeftRight( true, false, 960 + 28 + 28 + 28, 960 + 22 + 28 + 28 + 28 )
	no_attachment_indicator:setTopBottom( true, false, 662, 662 + 22 )
	no_attachment_indicator:setImage( RegisterImage( "_mg_no_gren_indicator" ) )
	no_attachment_indicator:setScale( 0.2 )
	self:addElement( no_attachment_indicator )
	self.no_attachment_indicator = no_attachment_indicator
	
	local attachment_count = LUI.UIText.new()
	attachment_count:setLeftRight( true, false, 960 + 28 + 28 + 28, 960 + 22 + 28 + 28 + 28 )
	attachment_count:setTopBottom( true, false, 658, 668 )
	attachment_count:setTTF( "fonts/Bebas-Regular.ttf" )
	attachment_count:setText( "0" )
	attachment_count:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_RIGHT )
	self:addElement( attachment_count )
	self.attachment_count = attachment_count

	attachment_count:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.dpadLeftAmmo" ), function( ModelRef )
		local modelValue = Engine.GetModelValue( ModelRef )
		if modelValue then
			attachment_count:setText( Engine.Localize( modelValue ) )
		end
	end )
	
	self.clipsPerState = 
	{
		DefaultState = 
		{
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )
				
				attachment_icon:completeAnimation()
				self.attachment_icon:setAlpha( 1 )
				self.clipFinished( attachment_icon, {} )
				
				no_attachment_indicator:completeAnimation()
				no_attachment_indicator:setAlpha( 0 )
				self.clipFinished( no_attachment_indicator, {} )
				
				attachment_count:completeAnimation()
				attachment_count:setAlpha( 1 )
				self.clipFinished( attachment_count, {} )
			end
		},
		Invisible = 
		{
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )
				
				attachment_icon:completeAnimation()
				self.attachment_icon:setAlpha( 0 )
				self.clipFinished( attachment_icon, {} )
				
				no_attachment_indicator:completeAnimation()
				no_attachment_indicator:setAlpha( 1 )
				self.clipFinished( no_attachment_indicator, {} )
				
				attachment_count:completeAnimation()
				attachment_count:setAlpha( 1 )
				self.clipFinished( attachment_count, {} )
			end
		}
	}
	self:mergeStateConditions( 
	{
		{
			stateName = "Invisible",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "hudItems.showDpadLeft", 0 )
			end
		}
	} )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.dpadLeftAmmo" ), function ( modelRef )
		menu:updateElementState( self, 
		{
			name = "model_validation", 
			menu = menu,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "hudItems.dpadLeftAmmo"
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.showDpadLeft" ), function ( modelRef )
		menu:updateElementState( self, 
		{
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "hudItems.showDpadLeft"
		} )
	end )
	
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.attachment_icon:close()
		element.no_attachment_indicator:close()
		element.attachment_count:close()
	end )
	
	return self
end