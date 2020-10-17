class WMUpgrade_Skill_BringTheHeat_Flame_Base extends KFProj_MolotovGrenade
	hidedropdown;

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	if (Other.bBlockActors)
	{
		if (KFDestructibleActor(Other) != None && KFDestructibleActor(Other).ReplicationMode == RT_ClientSide)
		{
			return;
		}

		Explode(Location, HitNormal);
	}
}

defaultproperties
{
	bWarnAIWhenFired=False
	FuseTime=0.5f
	Speed=1200.0f
	TerminalVelocity=2000.0f
	TossZ=0.0f

	AssociatedPerkClass=class'ZedternalReborn.WMPerk'

	Name="Default__WMUpgrade_Skill_BringTheHeat_Flame_Base"
}
