class WMUpgrade_Weapon_TightChoke extends WMUpgrade_Weapon
	abstract;

var float Spread;

// Only Shotgun are compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	if (class<KFWeap_ShotgunBase>(KFW) != None)
		return True;
	else if (class<KFWeap_HRG_Revolver_Buckshot>(KFW) != None)
		return True;
	else if (class<KFWeap_Pistol_Blunderbuss>(KFW) != None)
		return True;

	return False;
}

static simulated function ModifyTightChoke(out float InTight, float DefaultTight, int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	InTight -= default.Spread * upgLevel;
}

defaultproperties
{
	Spread=0.2f

	upgradeName="Tight Choke"
	upgradeDescription(0)="Decrease shot spread of this weapon by %x%%"
	WeaponBonus=(baseValue=0, incValue=20, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_TightChoke"
}
