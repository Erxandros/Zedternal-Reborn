class WMUpgrade_Skill_BringTheHeat_Flame_Base extends KFProj_MolotovGrenade
	hidedropdown;

/** Blow up on impact */
simulated function ProcessTouch( Actor Other, Vector HitLocation, Vector HitNormal )
{
	if( Other.bBlockActors )
	{
		// don't explode on client-side-only destructibles
		if( KFDestructibleActor(Other) != none && KFDestructibleActor(Other).ReplicationMode == RT_ClientSide )
		{
			return;
		}

		Explode( Location, HitNormal );
	}
}


defaultproperties
{
   FuseTime=0.500000
   NumResidualFlames=2
   WeaponSelectTexture=Texture2D'wep_ui_molotov_tex.UI_WeaponSelect_MolotovCocktail'
   bWarnAIWhenFired=False
   TossZ=0.000000
   TerminalVelocity=2000.000000
   ExplosionActorClass=Class'KFGame.KFExplosionActor'
   ProjDisintegrateTemplate=ParticleSystem'ZED_Siren_EMIT.FX_Siren_grenade_disable_01'
   ProjFlightTemplate=ParticleSystem'WEP_3P_Molotov_EMIT.FX_Molotov_Grenade_Mesh'
   AssociatedPerkClass=Class'KFGame.KFPerk_Firebug'
   Speed=1200.000000
   Name="Default__WMUpgrade_Skill_BringTheHeat_Flame_Base"
}
