Class WMUpgrade_Skill_AirborneAgent extends WMUpgrade_Skill;

static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_AirborneAgent_Counter UPG;
	local bool bFound;
	
	if (KFPawn_Human(OwnerPawn)!=none)
	{
		bFound = false;
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_AirborneAgent_Counter',UPG)
			bFound = true;
		
		if (!bFound)
		{
			UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_AirborneAgent_Counter',OwnerPawn);
			UPG.Player = KFPawn_Human(OwnerPawn);
			UPG.bDeluxe = (upgLevel > 1);
		}
	}
}

defaultproperties
{
	upgradeName="Airborne Agent"
	upgradeDescription(0)="Release heal gas when you or nearby friends are in danger"
	upgradeDescription(1)="Release <font color=\"#b346ea\">strong</font> heal gas when you or nearby friends are in danger"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_AirborneAgent'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_AirborneAgent_Deluxe'
}