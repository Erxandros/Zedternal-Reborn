Class WMUpgrade_Skill_HotPepper extends WMUpgrade_Skill;
	
static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_HotPepper_Counter UPG;
	local bool bFound;
	
	if (KFPawn_Human(OwnerPawn)!=none)
	{
		bFound = false;
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_HotPepper_Counter',UPG)
		{
			bFound = true;
		}
		if (!bFound)
		{
			UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_HotPepper_Counter',OwnerPawn);
			UPG.bDeluxe = (upgLevel > 1);
		}
	}
}

defaultproperties
{
	upgradeName="Hot Pepper"
	upgradeDescription(0)="ZEDs near you can catch on fire"
	upgradeDescription(1)="ZEDs near you can catch on <font color=\"#b346ea\">heavy</font> fire"
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_HotPepper'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_HotPepper_Deluxe'
}