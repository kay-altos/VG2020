$managedCred = Get-StoredCredential -Target a.samoshkin_cloud
Connect-msolService -Credential $managedCred
Connect-MicrosoftTeams -Credential $managedCred

#  	fc0093ec-20a8-4123-b4ff-e0b4a1658998	0600 Программирование на языке С++ Акимов 3	Private	False	msteams_fe459f	 	

	 	

#  daabcd76-a9ee-4826-be5e-facbc28b7132	0600 Программирование на языке С++ Акимов 3	HiddenMembership	False	06003	0600 Программирование на языке С++ Акимов 3	


	

#Remove-Team -GroupId ""

$GroupId = "daabcd76-a9ee-4826-be5e-facbc28b7132"



$list = "f.tatarnikov23406@dvorec.onmicrosoft.com m.shadiev2628@dvorec.onmicrosoft.com i.borodenok75233@dvorec.onmicrosoft.com m.morozov18441@dvorec.onmicrosoft.com a.kuznecov59317@dvorec.onmicrosoft.com m.shompolov74437@dvorec.onmicrosoft.com i.akatev17542@dvorec.onmicrosoft.com v.deulin30151@dvorec.onmicrosoft.com a.nikitin57813@dvorec.onmicrosoft.com o.feofanov60908@dvorec.onmicrosoft.com b.babayan82859@dvorec.onmicrosoft.com m.solomatin67018@dvorec.onmicrosoft.com d.bolotnyj65499@dvorec.onmicrosoft.com k.blatov78675@dvorec.onmicrosoft.com a.serov78232@dvorec.onmicrosoft.com a.chervyakov68935@dvorec.onmicrosoft.com a.nalivajko75676@dvorec.onmicrosoft.com v.artemenkova80835@dvorec.onmicrosoft.com"


$users = $list.Split(" ")
$users | ForEach-Object {


Add-TeamUser -GroupId $GroupId -User $_ -Role Member


}


