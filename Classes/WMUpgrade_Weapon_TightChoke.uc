Class WMUpgrade_Weapon_TightChoke extends WMUpgrade_Weapon
	abstract;

var float Spread;

// Only Shotgun are compatible
static function bool IsUpgradeCompatible( class<KFWeapon> KFW )
{	
	if (class<KFWeap_ShotgunBase>(KFW) != none)
		return true;

	return false;
}

static simulated function ModifyTightChokePassive( out float tightChokeFactor, int upgLevel)
{
	tightChokeFactor -= default.Spread * upgLevel;
}


defaultproperties
{
	upgradeName="Tight Choke"
	upgradeDescription(0)="Decrease shot spread of this weapon by %x%%"
	WeaponBonus=(baseValue=0, incValue=20, maxValue=-1)
	Spread=0.200000
}