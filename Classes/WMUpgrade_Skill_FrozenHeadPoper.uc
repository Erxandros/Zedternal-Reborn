Class WMUpgrade_Skill_FrozenHeadPoper extends WMUpgrade_Skill;
	
var float maxDamage;
var float prob;
	
static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	local rotator Rot;
	local vector Loc;
	
	if (MyKFPM != none && DamageInstigator != none && HitZoneIdx == HZI_HEAD && FRand() < fmin(default.prob, (float(DefaultDamage) / default.maxDamage)))
	{
		Rot = rotator( MyKFPM.Velocity );
		Loc = MyKFPM.Location;
		Loc.Z -= MyKFPM.GetCollisionHeight();
		Rot.Pitch = 0;
		if (upgLevel == 1)
			DamageInstigator.Spawn(class'ZedternalReborn.WMUpgrade_FreezeExplosion', DamageInstigator,, Loc, Rot,, true);
		else
			DamageInstigator.Spawn(class'ZedternalReborn.WMUpgrade_FreezeExplosion_Deluxe', DamageInstigator,, Loc, Rot,, true);
	}
}

defaultproperties
{
	upgradeName="Frozen Head Poper"
	upgradeDescription(0)="Any head shots with <font color=\"#eaeff7\">all weapons</font> have a chance to create an ice explosion"
	upgradeDescription(1)="Any head shots with <font color=\"#eaeff7\">all weapons</font> have a chance to create a <font color=\"#b346ea\">massive</font> ice explosion"
	prob=0.200000
	maxDamage=800.000000
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_FrozenHeadPoper'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_FrozenHeadPoper_Deluxe'
}