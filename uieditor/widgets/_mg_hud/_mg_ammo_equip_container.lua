require( "ui.uieditor.widgets._mg_hud._mg_ammo_lethal_container" )
require( "ui.uieditor.widgets._mg_hud._mg_ammo_tactical_container" )
require( "ui.uieditor.widgets._mg_hud._mg_ammo_mine_container" )
require( "ui.uieditor.widgets._mg_hud._mg_ammo_attachment_container" )

CoD._mg_ammo_equip_container = InheritFrom( LUI.UIElement )
CoD._mg_ammo_equip_container.new = function ( menu, controller )

	local self = LUI.UIElement.new()
	
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	
	self:setUseStencil( false )
	self:setClass( CoD._mg_ammo_equip_container )
	self.id = "_mg_ammo_equip_container"
	self.soundSet = "HUD"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self.anyChildUsesUpdateState = true
	
	local frag_container = CoD._mg_ammo_lethal_container.new( menu, controller )
	self:addElement( frag_container )
	self.frag_container = frag_container
	
	local tactical_container = CoD._mg_ammo_tactical_container.new( menu, controller )
	--self:addElement( tactical_container )
	self.tactical_container = tactical_container
	
	local mine_container = CoD._mg_ammo_mine_container.new( menu, controller )
	--self:addElement( mine_container )
	self.mine_container = mine_container
	
	local attachment_container = CoD._mg_ammo_attachment_container.new( menu, controller )
	--self:addElement( attachment_container )
	self.attachment_container = attachment_container
	
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.frag_container:close()
		element.tactical_container:close() 
		element.mine_container:close() 
		element.attachment_container:close() 
	end )
	
	return self
end