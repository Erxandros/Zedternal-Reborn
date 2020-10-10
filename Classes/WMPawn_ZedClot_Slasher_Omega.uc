class WMPawn_ZedClot_Slasher_Omega extends KFPawn_ZedClot_Slasher;

var transient Zed_Arch_SlasherOmega ZedArch;
var transient ParticleSystemComponent SpecialFXPSCs[2];
var float ExtraResistance;

static function string GetLocalizedName()
{
	return "Slasher Omega";
}

simulated function PostBeginPlay()
{
	IntendedBodyScale = 1.125f;
	ZedArch = class'Zed_Arch_SlasherOmega'.static.GetArch(WorldInfo);
	if (ZedArch != None)
		updateArch();

	if (WorldInfo.NetMode != NM_DedicatedServer)
		ApplySpecialFX();

	bVersusZed = True;

	super.PostBeginPlay();
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	if (WorldInfo.NetMode != NM_DedicatedServer)
		EndSpecialFX();

	super.PlayDying(DamageType, HitLoc);
}

simulated function ApplySpecialFX()
{
	local Name SocketBoneName;

	SocketBoneName = Mesh.GetSocketBoneName('FX_EYE_L');
	if (SocketBoneName != '' && SocketBoneName != 'None')
		SpecialFXPSCs[0] = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(ParticleSystem'ZedternalReborn_Zeds.FX_Omega', Mesh, 'FX_EYE_L', True, vect(0,0,0));

	SocketBoneName = Mesh.GetSocketBoneName('FX_EYE_R');
	if (SocketBoneName != '' && SocketBoneName != 'None')
		SpecialFXPSCs[1] = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(ParticleSystem'ZedternalReborn_Zeds.FX_Omega', Mesh, 'FX_EYE_R', True, vect(0,0,0));
}

simulated function EndSpecialFX()
{
	if (SpecialFXPSCs[0] != None && SpecialFXPSCs[0].bIsActive)
	{
		SpecialFXPSCs[0].DeactivateSystem();
	}
	if (SpecialFXPSCs[1] != None && SpecialFXPSCs[1].bIsActive)
	{
		SpecialFXPSCs[1].DeactivateSystem();
	}
}

simulated function updateArch()
{
	ZedArch = class'Zed_Arch_SlasherOmega'.Static.GetArch(WorldInfo);
	if (ZedArch != None)
	{
		Mesh.AnimSets = ZedArch.zedClientArch.AnimSets;
		Mesh.SetAnimTreeTemplate(ZedArch.zedClientArch.AnimTreeTemplate);
		PawnAnimInfo = ZedArch.zedClientArch.AnimArchetype;

		// update texture effects
		UpdateGameplayMICParams();
	}
}

simulated function UpdateGameplayMICParams()
{
	local byte i;

	super.UpdateGameplayMICParams();

	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		for (i = 0; i < CharacterMICs.length; ++i)
		{
			CharacterMICs[i].SetVectorParameterValue('Vector_GlowColor', class'WMPawn_OmegaConstants'.default.OmegaColor);
			CharacterMICs[i].SetVectorParameterValue('Vector_FresnelGlowColor', class'WMPawn_OmegaConstants'.default.OmegaFresnelColor);
		}
	}
}

function float GetDamageTypeModifier(class<DamageType> DT)
{
	local float currentMod;

	// Omega ZEDs have extra resistance against all damage type
	currentMod = super.GetDamageTypeModifier(DT);
	return FMax(0.01f, currentMod - ExtraResistance);
}

simulated event bool UsePlayerControlledZedSkin()
{
	return True;
}

defaultproperties
{
	DoshValue=15
	XPValues(0)=16
	XPValues(1)=22
	XPValues(2)=22
	XPValues(3)=22
	Health=250
	ExtraResistance=0.15f
	GroundSpeed=340.0f
	SprintSpeed=580.0f
	LocalizationKey="WMPawn_ZedSlasher_Omega"

	Begin Object Class=KFMeleeHelperAI Name=WMMeleeHelper_0 Archetype=KFMeleeHelperAI'KFGame.Default__KFPawn_Monster:MeleeHelper_0'
		BaseDamage=10.0f
		MyDamageType=Class'kfgamecontent.KFDT_Slashing_ZedWeak'
		MomentumTransfer=25000.0f
		MaxHitRange=180.0f
		Name="MeleeHelper_0"
	End Object
	MeleeAttackHelper=KFMeleeHelperAI'ZedternalReborn.Default__WMPawn_ZedClot_Slasher_Omega:WMMeleeHelper_0'

	bVersusZed=False
	ParryResistance=1
	GrabAttackFrequency=0.6f

	HitZones(0)=(GoreHealth=150)

	Name="Default__WMPawn_ZedClot_Slasher_Omega"
}
