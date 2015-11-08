Function Start-MissionPossible{

	[console]::beep(784,150) 
	Start-Sleep -m 300 
	[console]::beep(784,150) 
	Start-Sleep -m 300 
	[console]::beep(932,150) 
	Start-Sleep -m 150 
	[console]::beep(1047,150) 
	Start-Sleep -m 150 
	[console]::beep(784,150) 
	Start-Sleep -m 300 
	 [console]::beep(784,150) 
	Start-Sleep -m 300 
	 [console]::beep(699,150) 
	Start-Sleep -m 150 
	[console]::beep(740,150) 
	Start-Sleep -m 150 
	 [console]::beep(784,150) 
	Start-Sleep -m 300 
	 [console]::beep(784,150) 
	Start-Sleep -m 300 
	 [console]::beep(932,150) 
	Start-Sleep -m 150 
	 [console]::beep(1047,150) 
	Start-Sleep -m 150 
	 [console]::beep(784,150) 
	Start-Sleep -m 300 
	[console]::beep(784,150) 
	Start-Sleep -m 300 
	 [console]::beep(699,150) 
	Start-Sleep -m 150 
	[console]::beep(740,150) 
	Start-Sleep -m 150 
	[console]::beep(932,150) 
	[console]::beep(784,150) 
	 [console]::beep(587,1200) 
	Start-Sleep -m 75 
	 [console]::beep(932,150) 
	[console]::beep(784,150) 
	[console]::beep(554,1200) 
	Start-Sleep -m 75 
	[console]::beep(932,150) 
	[console]::beep(784,150) 
	[console]::beep(523,1200) 
	Start-Sleep -m 150 
	[console]::beep(466,150) 
	[console]::beep(523,150)


}



function Greet-Audience{

	$speaker = New-Object -ComObject SAPI.SpVoice
	$null = $speaker.Speak('Dear Audience. I am very pleased to greet you in the name of your Speakers.')

	$null = $speaker.Speak("The mission, should you accept it, is to learn some things you most likely didn't know about me.")
	
	$accept = Read-Host "Do you accept the mission? Y/N"

	if($accept -eq "Y"){
	
		$null = $speaker.Speak('Very well, then we will begin now!')
		Start-MissionPossible
		
	}
	else{
		
		#Well...Run
		Write-Warning "SelfDestruction enabled. T minus 10 seconds."
		
		Start-Sleep -Seconds 3
		Write-Warning "Please, don't panic. Please scream and run around in circles."
		
		Start-Sleep -Seconds 3
		Write-Warning "Have a nice day."
		
	}

}






