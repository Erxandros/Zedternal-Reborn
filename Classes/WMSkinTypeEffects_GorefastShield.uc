class WMSkinTypeEffects_GorefastShield extends KFSkinTypeEffects;

/** Overriden to orient the effect toward in the direction of the hit and not attach it to a specific bone */
simulated function ParticleSystemComponent AttachEffectToHitLocation( KFPawn P, ParticleSystem ParticleTemplate, int HitZoneIndex, vector HitLocation, vector HitDirection )
{
	local name HitBoneName;
	local int HitBoneIdx;
	local ParticleSystemComponent PSC;
	
	// HitZone==255 is unsupported for this type
	if ( HitZoneIndex != 255 )
	{
		HitBoneName = P.HitZones[HitZoneIndex].BoneName;
		HitBoneIdx = P.Mesh.MatchRefBone(HitBoneName);
		
		if( HitBoneIdx != INDEX_NONE )
		{
			PSC = P.WorldInfo.ImpactFXEmitterPool.SpawnEmitter(ParticleTemplate, HitLocation, rotator(-HitDirection), P);
			PSC.SetLightingChannels(P.PawnLightingChannel);

			P.LastImpactParticleEffectTime = P.WorldInfo.TimeSeconds;

			// Make the particle system ignore bone rotation
			PSC.SetAbsolute(false, true, true);
		}
	}

	return PSC;
}

defaultproperties
{
   ImpactFXArray(0)=(DefaultParticle=ParticleSystem'ZED_Hans_EMIT.FX_Hans_invulnerable_Hit',bAttachToHitLocation=True,DefaultSound=AkEvent'WW_Skin_Impacts.Play_IMP_Ballistic_Machine_Local')
   ImpactFXArray(1)=(Type=FXG_Bludgeon,DefaultParticle=ParticleSystem'ZED_Hans_EMIT.FX_Hans_invulnerable_Hit',bAttachToHitLocation=True,DefaultSound=AkEvent'WW_Skin_Impacts.Play_IMP_Ballistic_Machine_Local')
   ImpactFXArray(2)=(Type=FXG_Piercing,DefaultParticle=ParticleSystem'ZED_Hans_EMIT.FX_Hans_invulnerable_Hit',bAttachToHitLocation=True,DefaultSound=AkEvent'WW_Skin_Impacts.Play_IMP_Ballistic_Machine_Local')
   ImpactFXArray(3)=(Type=FXG_Slashing,DefaultParticle=ParticleSystem'ZED_Hans_EMIT.FX_Hans_invulnerable_Hit',bAttachToHitLocation=True,DefaultSound=AkEvent'WW_Skin_Impacts.Play_IMP_Ballistic_Machine_Local')
   ImpactFXArray(4)=(Type=FXG_Fire,DefaultParticle=ParticleSystem'ZED_Hans_EMIT.FX_Hans_invulnerable_Hit',bAttachToHitLocation=True,DefaultSound=AkEvent'WW_Skin_Impacts.Play_IMP_Ballistic_Machine_Local')
   ImpactFXArray(5)=(Type=FXG_Toxic,DefaultParticle=ParticleSystem'ZED_Hans_EMIT.FX_Hans_invulnerable_Hit',bAttachToHitLocation=True,DefaultSound=AkEvent'WW_Skin_Impacts.Play_IMP_Ballistic_Machine_Local')
   ImpactFXArray(6)=(Type=FXG_Healing,DefaultParticle=ParticleSystem'ZED_Hans_EMIT.FX_Hans_invulnerable_Hit',bAttachToHitLocation=True,DefaultSound=AkEvent'WW_Skin_Impacts.Play_IMP_Ballistic_Machine_Local')
   ImpactFXArray(7)=(Type=FXG_Sawblade,DefaultParticle=ParticleSystem'ZED_Hans_EMIT.FX_Hans_invulnerable_Hit',bAttachToHitLocation=True,DefaultSound=AkEvent'WW_Skin_Impacts.Play_IMP_Ballistic_Machine_Local')
   ImpactFXArray(8)=(Type=FXG_DrainLife,DefaultParticle=ParticleSystem'ZED_Hans_EMIT.FX_Hans_invulnerable_Hit',bAttachToHitLocation=True,DefaultSound=AkEvent'WW_Skin_Impacts.Play_IMP_Ballistic_Machine_Local')
   ImpactFXArray(9)=(Type=FXG_IncendiaryRound,DefaultParticle=ParticleSystem'ZED_Hans_EMIT.FX_Hans_invulnerable_Hit',bAttachToHitLocation=True,DefaultSound=AkEvent'WW_Skin_Impacts.Play_IMP_Ballistic_Machine_Local')
   ImpactFXArray(10)=(Type=FXG_UnexplodedGrenade,DefaultParticle=ParticleSystem'ZED_Hans_EMIT.FX_Hans_invulnerable_Hit',bAttachToHitLocation=True,DefaultSound=AkEvent'WW_Skin_Impacts.Play_IMP_Ballistic_Machine_Local')
   ImpactFXArray(11)=(Type=FXG_MicrowaveBlast,DefaultParticle=ParticleSystem'ZED_Hans_EMIT.FX_Hans_invulnerable_Hit',bAttachToHitLocation=True,DefaultSound=AkEvent'WW_Skin_Impacts.Play_IMP_Ballistic_Machine_Local')
   ImpactFXArray(12)=(Type=FXG_ShieldBash,DefaultParticle=ParticleSystem'ZED_Hans_EMIT.FX_Hans_invulnerable_Hit',bAttachToHitLocation=True,DefaultSound=AkEvent'WW_Skin_Impacts.Play_IMP_Ballistic_Machine_Local')
   ImpactFXArray(13)=(Type=FXG_MetalMace,DefaultParticle=ParticleSystem'ZED_Hans_EMIT.FX_Hans_invulnerable_Hit',bAttachToHitLocation=True,DefaultSound=AkEvent'WW_Skin_Impacts.Play_IMP_Ballistic_Machine_Local')
   Name="Default__WMSkinTypeEffects_GorefastShield"
}
