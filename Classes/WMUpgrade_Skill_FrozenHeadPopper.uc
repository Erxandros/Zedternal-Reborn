class WMUpgrade_Skill_FrozenHeadPopper extends WMUpgrade_Skill;

var float MaxDamage, Probability;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	local rotator Rot;
	local vector Loc;

	if (MyKFPM != None && DamageInstigator != None && HitZoneIdx == HZI_HEAD && FRand() < Fmin(default.Probability, (float(DefaultDamage) / default.MaxDamage)))
	{
		Rot = rotator(MyKFPM.Velocity);
		Loc = MyKFPM.Location;
		Loc.Z -= MyKFPM.GetCollisionHeight();
		Rot.Pitch = 0;
		if (upgLevel == 1)
			DamageInstigator.Spawn(class'ZedternalReborn.WMProj_FreezeExplosion', DamageInstigator, , Loc, Rot, , True);
		else
			DamageInstigator.Spawn(class'ZedternalReborn.WMProj_FreezeExplosion_Deluxe', DamageInstigator, , Loc, Rot, , True);
	}
}

defaultproperties
{
	Probability=0.2f
	MaxDamage=800.0f

	UpgradeName="Frozen Head Popper"
	UpgradeDescription(0)="Headshots with <font color=\"#eaeff7\">all weapons</font> may cause an ice explosion with higher damage headshots equaling a greater chance to explode"
	UpgradeDescription(1)="Headshots with <font color=\"#eaeff7\">all weapons</font> may cause a <font color=\"#b346ea\">massive</font> ice explosion with higher damage headshots equaling a greater chance to explode"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_FrozenHeadPopper'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_FrozenHeadPopper_Deluxe'

	Name="Default__WMUpgrade_Skill_FrozenHeadPopper"
}
