class WMProj_FreezeExplosion extends KFProj_FreezeGrenade
	hidedropdown;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	ExplodeTimer();
}

simulated event GrenadeIsAtRest()
{
	super.GrenadeIsAtRest();
}
	
defaultproperties
{
   FuseTime=0.050000
   Begin Object Name=ExploTemplate0
      Damage=10.000000
      DamageRadius=500.000000
      MyDamageType=Class'ZedternalReborn.WMDT_FreezeExplosion'
	  ActorClassToIgnoreForDamage=class'KFGame.KFPawn_Human'
      Name="ExploTemplate0"
   End Object
   ExplosionTemplate=ExploTemplate0
   AssociatedPerkClass=Class'ZedternalReborn.WMPerk'
   Name="Default__WMProj_FreezeExplosion"
}
