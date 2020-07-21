class WMSpecialWave_Pop extends WMSpecialWave;

var float damageBody;
var float damageHead;
var float damageOther;
var float ZedHeadScale;
var float ZedHeadScaleCombinedBobbleZed;

function PostBeginPlay()
{
	ZedHeadScaleCombinedBobbleZed = (class'WMSpecialWave_BobbleZed'.default.ZedSpawnHeadScale + Default.ZedHeadScale) / 2;
	SetTimer(1.20f, true, nameof(UpdateZed));
	super.PostBeginPlay();
}

function UpdateZed()
{
	local KFPawn_Monster KFM;

	foreach DynamicActors(class'KFPawn_Monster', KFM)
	{
		if (KFM.IntendedHeadScale != default.ZedHeadScale && KFM.IntendedHeadScale != ZedHeadScaleCombinedBobbleZed)
		{
			if (KFM.IntendedHeadScale == class'WMSpecialWave_BobbleZed'.default.ZedSpawnHeadScale)
				KFM.IntendedHeadScale = ZedHeadScaleCombinedBobbleZed;
			else
				KFM.IntendedHeadScale = default.ZedHeadScale;

			KFM.SetHeadScale(KFM.IntendedHeadScale, KFM.CurrentHeadScale);
		}
	}
}

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (HitZoneIdx != HZI_HEAD && (ClassIsChildOf(DamageType, class'KFDT_Fire') || ClassIsChildOf(DamageType, class'KFDT_Explosive')))
		InDamage -= Round(float(InDamage) * default.damageOther);
	else
	{
		if (HitZoneIdx == HZI_HEAD)
			InDamage += Round(float(InDamage) * default.damageHead);
		else
			InDamage -= Round(float(InDamage) * default.damageBody);
	}
}

defaultproperties
{
	Title="Hard Skin"
	Description="Headshots are the key!"

	damageHead=1.300000
	damageBody=0.450000
	damageOther=0.200000
	ZedHeadScale=0.800000

	Name="Default__WMSpecialWave_Pop"
}
