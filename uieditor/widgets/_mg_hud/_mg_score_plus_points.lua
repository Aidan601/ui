CoD._mg_score_plus_points = InheritFrom( LUI.UIElement )
CoD._mg_score_plus_points.new = function ( menu, controller )
	local self = LUI.UIElement.new()
	
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	
	self:setUseStencil( false )
	self:setClass( CoD._mg_score_plus_points )
	self.id = "_mg_score_plus_points"
	self.soundSet = "HUD"
	self:setLeftRight( true, false, 0, 85 )
	self:setTopBottom( true, false, 0, 66 )
	
	local Label2 = LUI.UITightText.new()
	Label2:setLeftRight( true, false, 18, 84 )
	Label2:setTopBottom( true, false, 4.38, 41.38 )
	Label2:setRGB( 1, 0.52, 0 )
	Label2:setAlpha( 0.01 )
	Label2:setZoom( -8 )
	Label2:setText( Engine.Localize( "+50" ) )
	Label2:setTTF( "fonts/tf2.ttf" )
	Label2:setMaterial( LUI.UIImage.GetCachedMaterial( "sw4_2d_uie_font_cached_glow" ) )
	Label2:setShaderVector( 0, 0.21, 0, 0, 0 )
	Label2:setShaderVector( 1, 0, 0, 0, 0 )
	Label2:setShaderVector( 2, 1, 0, 0, 0 )
	Label2:setLetterSpacing( 0.9 )
	--self:addElement( Label2 )
	self.Label2 = Label2
	
	local Label1 = LUI.UITightText.new()
	Label1:setLeftRight( true, false, 17, 83 )
	Label1:setTopBottom( true, false, 34.38, 65.38 )
	Label1:setRGB( 0, 1, 0 )
	Label1:setAlpha( 0 )
	Label1:setText( Engine.Localize( "+50" ) )
	Label1:setTTF( "fonts/tf2.ttf" )
	self:addElement( Label1 )
	self.Label1 = Label1
	
	local Glow = LUI.UIImage.new()
	Glow:setLeftRight( true, false, 0, 85 )
	Glow:setTopBottom( true, false, 0, 65.75 )
	Glow:setRGB( 1, 0.26, 0 )
	Glow:setAlpha( 0.01 )
	Glow:setImage( RegisterImage( "uie_t7_core_hud_mapwidget_panelglow" ) )
	Glow:setMaterial( LUI.UIImage.GetCachedMaterial( "ui_add" ) )
	--self:addElement( Glow )
	self.Glow = Glow
	
	self.clipsPerState = 
	{
		DefaultState = 
		{
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )
				local f2_local0 = function ( f3_arg0, f3_arg1 )
					local f3_local0 = function ( f4_arg0, f4_arg1 )
						local f4_local0 = function ( f5_arg0, f5_arg1 )
							local f5_local0 = function ( f6_arg0, f6_arg1 )
								if not f6_arg1.interrupted then
									f6_arg0:beginAnimation( "keyframe", 169, false, false, CoD.TweenType.Bounce )
								end
								f6_arg0:setAlpha( 0 )
								if f6_arg1.interrupted then
									self.clipFinished( f6_arg0, f6_arg1 )
								else
									f6_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
								end
							end
							
							if f5_arg1.interrupted then
								f5_local0( f5_arg0, f5_arg1 )
								return 
							else
								f5_arg0:beginAnimation( "keyframe", 330, false, false, CoD.TweenType.Linear )
								f5_arg0:registerEventHandler( "transition_complete_keyframe", f5_local0 )
							end
						end
						
						if f4_arg1.interrupted then
							f4_local0( f4_arg0, f4_arg1 )
							return 
						else
							f4_arg0:beginAnimation( "keyframe", 140, false, false, CoD.TweenType.Bounce )
							f4_arg0:registerEventHandler( "transition_complete_keyframe", f4_local0 )
						end
					end
					
					if f3_arg1.interrupted then
						f3_local0( f3_arg0, f3_arg1 )
						return 
					else
						f3_arg0:beginAnimation( "keyframe", 129, false, false, CoD.TweenType.Bounce )
						f3_arg0:setAlpha( 0.43 )
						f3_arg0:registerEventHandler( "transition_complete_keyframe", f3_local0 )
					end
				end
				
				Label2:completeAnimation()
				self.Label2:setAlpha( 0 )
				f2_local0( Label2, {} )
				local f2_local1 = function ( f7_arg0, f7_arg1 )
					local f7_local0 = function ( f8_arg0, f8_arg1 )
						local f8_local0 = function ( f9_arg0, f9_arg1 )
							if not f9_arg1.interrupted then
								f9_arg0:beginAnimation( "keyframe", 100, false, false, CoD.TweenType.Bounce )
							end
							f9_arg0:setAlpha( 0 )
							if f9_arg1.interrupted then
								self.clipFinished( f9_arg0, f9_arg1 )
							else
								f9_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
							end
						end
						
						if f8_arg1.interrupted then
							f8_local0( f8_arg0, f8_arg1 )
							return 
						else
							f8_arg0:beginAnimation( "keyframe", 579, false, false, CoD.TweenType.Linear )
							f8_arg0:registerEventHandler( "transition_complete_keyframe", f8_local0 )
						end
					end
					
					if f7_arg1.interrupted then
						f7_local0( f7_arg0, f7_arg1 )
						return 
					else
						f7_arg0:beginAnimation( "keyframe", 70, false, false, CoD.TweenType.Linear )
						f7_arg0:setAlpha( 1 )
						f7_arg0:registerEventHandler( "transition_complete_keyframe", f7_local0 )
					end
				end
				
				Label1:completeAnimation()
				self.Label1:setAlpha( 0 )
				f2_local1( Label1, {} )
				local f2_local2 = function ( f10_arg0, f10_arg1 )
					local f10_local0 = function ( f11_arg0, f11_arg1 )
						local f11_local0 = function ( f12_arg0, f12_arg1 )
							local f12_local0 = function ( f13_arg0, f13_arg1 )
								if not f13_arg1.interrupted then
									f13_arg0:beginAnimation( "keyframe", 189, false, false, CoD.TweenType.Bounce )
								end
								f13_arg0:setAlpha( 0 )
								if f13_arg1.interrupted then
									self.clipFinished( f13_arg0, f13_arg1 )
								else
									f13_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
								end
							end
							
							if f12_arg1.interrupted then
								f12_local0( f12_arg0, f12_arg1 )
								return 
							else
								f12_arg0:beginAnimation( "keyframe", 469, false, false, CoD.TweenType.Linear )
								f12_arg0:setAlpha( 0.34 )
								f12_arg0:registerEventHandler( "transition_complete_keyframe", f12_local0 )
							end
						end
						
						if f11_arg1.interrupted then
							f11_local0( f11_arg0, f11_arg1 )
							return 
						else
							f11_arg0:beginAnimation( "keyframe", 60, false, false, CoD.TweenType.Bounce )
							f11_arg0:setAlpha( 0.42 )
							f11_arg0:registerEventHandler( "transition_complete_keyframe", f11_local0 )
						end
					end
					
					if f10_arg1.interrupted then
						f10_local0( f10_arg0, f10_arg1 )
						return 
					else
						f10_arg0:beginAnimation( "keyframe", 39, false, false, CoD.TweenType.Linear )
						f10_arg0:setAlpha( 1 )
						f10_arg0:registerEventHandler( "transition_complete_keyframe", f10_local0 )
					end
				end
				
				Glow:completeAnimation()
				self.Glow:setAlpha( 0 )
				f2_local2( Glow, {} )
			end,
			NegativeScore = function ()
				self:setupElementClipCounter( 3 )
				local f14_local0 = function ( f15_arg0, f15_arg1 )
					local f15_local0 = function ( f16_arg0, f16_arg1 )
						local f16_local0 = function ( f17_arg0, f17_arg1 )
							local f17_local0 = function ( f18_arg0, f18_arg1 )
								if not f18_arg1.interrupted then
									f18_arg0:beginAnimation( "keyframe", 169, false, false, CoD.TweenType.Bounce )
								end
								f18_arg0:setRGB( 0.59, 0.15, 0.11 )
								f18_arg0:setAlpha( 0 )
								if f18_arg1.interrupted then
									self.clipFinished( f18_arg0, f18_arg1 )
								else
									f18_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
								end
							end
							
							if f17_arg1.interrupted then
								f17_local0( f17_arg0, f17_arg1 )
								return 
							else
								f17_arg0:beginAnimation( "keyframe", 330, false, false, CoD.TweenType.Linear )
								f17_arg0:registerEventHandler( "transition_complete_keyframe", f17_local0 )
							end
						end
						
						if f16_arg1.interrupted then
							f16_local0( f16_arg0, f16_arg1 )
							return 
						else
							f16_arg0:beginAnimation( "keyframe", 140, false, false, CoD.TweenType.Bounce )
							f16_arg0:registerEventHandler( "transition_complete_keyframe", f16_local0 )
						end
					end
					
					if f15_arg1.interrupted then
						f15_local0( f15_arg0, f15_arg1 )
						return 
					else
						f15_arg0:beginAnimation( "keyframe", 129, false, false, CoD.TweenType.Bounce )
						f15_arg0:setAlpha( 0.43 )
						f15_arg0:registerEventHandler( "transition_complete_keyframe", f15_local0 )
					end
				end
				
				Label2:completeAnimation()
				self.Label2:setRGB( 0.59, 0.15, 0.11 )
				self.Label2:setAlpha( 0 )
				f14_local0( Label2, {} )
				local f14_local1 = function ( f19_arg0, f19_arg1 )
					local f19_local0 = function ( f20_arg0, f20_arg1 )
						local f20_local0 = function ( f21_arg0, f21_arg1 )
							if not f21_arg1.interrupted then
								f21_arg0:beginAnimation( "keyframe", 100, false, false, CoD.TweenType.Bounce )
							end
							f21_arg0:setRGB( 0.78, 0.14, 0.08 )
							f21_arg0:setAlpha( 0 )
							if f21_arg1.interrupted then
								self.clipFinished( f21_arg0, f21_arg1 )
							else
								f21_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
							end
						end
						
						if f20_arg1.interrupted then
							f20_local0( f20_arg0, f20_arg1 )
							return 
						else
							f20_arg0:beginAnimation( "keyframe", 579, false, false, CoD.TweenType.Linear )
							f20_arg0:registerEventHandler( "transition_complete_keyframe", f20_local0 )
						end
					end
					
					if f19_arg1.interrupted then
						f19_local0( f19_arg0, f19_arg1 )
						return 
					else
						f19_arg0:beginAnimation( "keyframe", 70, false, false, CoD.TweenType.Linear )
						f19_arg0:setAlpha( 1 )
						f19_arg0:registerEventHandler( "transition_complete_keyframe", f19_local0 )
					end
				end
				
				Label1:completeAnimation()
				self.Label1:setRGB( 0.78, 0.14, 0.08 )
				self.Label1:setAlpha( 0 )
				f14_local1( Label1, {} )
				local f14_local2 = function ( f22_arg0, f22_arg1 )
					local f22_local0 = function ( f23_arg0, f23_arg1 )
						local f23_local0 = function ( f24_arg0, f24_arg1 )
							local f24_local0 = function ( f25_arg0, f25_arg1 )
								if not f25_arg1.interrupted then
									f25_arg0:beginAnimation( "keyframe", 189, false, false, CoD.TweenType.Bounce )
								end
								f25_arg0:setAlpha( 0 )
								if f25_arg1.interrupted then
									self.clipFinished( f25_arg0, f25_arg1 )
								else
									f25_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
								end
							end
							
							if f24_arg1.interrupted then
								f24_local0( f24_arg0, f24_arg1 )
								return 
							else
								f24_arg0:beginAnimation( "keyframe", 469, false, false, CoD.TweenType.Linear )
								f24_arg0:setAlpha( 0.34 )
								f24_arg0:registerEventHandler( "transition_complete_keyframe", f24_local0 )
							end
						end
						
						if f23_arg1.interrupted then
							f23_local0( f23_arg0, f23_arg1 )
							return 
						else
							f23_arg0:beginAnimation( "keyframe", 60, false, false, CoD.TweenType.Bounce )
							f23_arg0:setAlpha( 0.42 )
							f23_arg0:registerEventHandler( "transition_complete_keyframe", f23_local0 )
						end
					end
					
					if f22_arg1.interrupted then
						f22_local0( f22_arg0, f22_arg1 )
						return 
					else
						f22_arg0:beginAnimation( "keyframe", 39, false, false, CoD.TweenType.Linear )
						f22_arg0:setAlpha( 1 )
						f22_arg0:registerEventHandler( "transition_complete_keyframe", f22_local0 )
					end
				end
				
				Glow:completeAnimation()
				self.Glow:setAlpha( 0 )
				f14_local2( Glow, {} )
			end
		}
	}
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end