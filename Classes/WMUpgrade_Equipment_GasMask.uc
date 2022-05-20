class WMUpgrade_Equipment_GasMask extends WMUpgrade_Equipment;

static simulated function GetPerkLensEffect(out class<EmitterCameraLensEffectBase> CamEffect, class<KFDamageType> DmgType, int upgLevel)
{
	if (ClassIsChildOf(DmgType, class'KFDT_Toxic'))
		CamEffect = None;
}

defaultproperties
{
	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Equipment_GasMask"
	LocalizeDescriptionLineCount=1
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Equipment.UI_Equipment_GasMask'

	Name="Default__WMUpgrade_Equipment_GasMask"
}
