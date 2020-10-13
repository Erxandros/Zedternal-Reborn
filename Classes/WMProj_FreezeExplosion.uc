class WMProj_FreezeExplosion extends KFProj_FreezeGrenade
	hidedropdown;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	ExplodeTimer();
}

defaultproperties
{
	AssociatedPerkClass=Class'ZedternalReborn.WMPerk'
	FuseTime=0.05f

	Begin Object Name=ExploTemplate0
		Damage=10.0f
		DamageRadius=500.0f
		MyDamageType=Class'ZedternalReborn.WMDT_FreezeExplosion'
		ActorClassToIgnoreForDamage=class'KFGame.KFPawn_Human'
	End Object

	Name="Default__WMProj_FreezeExplosion"
}
