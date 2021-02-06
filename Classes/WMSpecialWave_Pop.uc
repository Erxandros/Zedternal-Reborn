class WMSpecialWave_Pop extends WMSpecialWave;

var float DamageBody, DamageHead, DamageOther, ZedHeadScale, ZedHeadScaleCombinedBobbleZed;

function PostBeginPlay()
{
	super.PostBeginPlay();
	ZedHeadScaleCombinedBobbleZed = (class'ZedternalReborn.WMSpecialWave_BobbleZed'.default.ZedSpawnHeadScale + Default.ZedHeadScale) / 2;
	SetTimer(1.2f, True, NameOf(UpdateZed));
}

function UpdateZed()
{
	local KFPawn_Monster KFM;

	foreach DynamicActors(class'KFPawn_Monster', KFM)
	{
		if (KFM.IntendedHeadScale != default.ZedHeadScale && KFM.IntendedHeadScale != ZedHeadScaleCombinedBobbleZed)
		{
			if (KFM.IntendedHeadScale == class'ZedternalReborn.WMSpecialWave_BobbleZed'.default.ZedSpawnHeadScale)
				KFM.IntendedHeadScale = ZedHeadScaleCombinedBobbleZed;
			else
				KFM.IntendedHeadScale = default.ZedHeadScale;

			KFM.SetHeadScale(KFM.IntendedHeadScale, KFM.CurrentHeadScale);
		}
	}
}

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (HitZoneIdx != HZI_HEAD && (ClassIsChildOf(DamageType, class'KFDT_Fire') || ClassIsChildOf(DamageType, class'KFDT_Explosive')))
		InDamage -= Round(float(InDamage) * default.DamageOther);
	else
	{
		if (HitZoneIdx == HZI_HEAD)
			InDamage += Round(float(InDamage) * default.DamageHead);
		else
			InDamage -= Round(float(InDamage) * default.DamageBody);
	}
}

defaultproperties
{
	DamageBody=0.45f
	DamageHead=1.3f
	DamageOther=0.2f
	ZedHeadScale=0.8f

	Title="Hard Skin"
	Description="Headshots are the key!"

	Name="Default__WMSpecialWave_Pop"
}
