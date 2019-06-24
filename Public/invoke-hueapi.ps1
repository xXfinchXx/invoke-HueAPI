Function Invoke-HueAPI{
    <# 
 .Synopsis
  Control Hue Functions through API commands.

 .Description
  Make the Hue bulbs loop, Alert, Clear or just start a party. Each command is done by a switch to simplify use.

 .Parameter Loop
  Loops through the colors in a slow progression.

 .Parameter Alert
  RED ALERT!!!! 
  Flashes Red several times and will be modified to play the red alert sound as well.

 .Parameter Clear
  Clears all commands.

 .Parameter DiscoParty
  DiscoParty is there for one reason and that reason is Party Time!

 .Example
   Invoke-HueAPI -[SWITCH]
#>
    param(
        [Switch]$Clear,
        [Switch]$DiscoParty,
        [Switch]$Loop,
        [Switch]$Alert,
        [Switch]$Xmas,
        [Switch]$ResetSaturation,
        [Parameter]$HueAPIKey,
        [Parameter]$BridgeIP,
        [Parameter]$GroupNum,
        [Parameter]$LightNum1,
        [Parameter]$LightNum2


    )
    Begin{
        #Find-Module BurntToast | Install-Module -Force -Confirm -AllowClobber
        #Import-Module BurtnToast
        Add-Type -assemblyname System.Speech
        $speak =New-Object System.Speech.Synthesis.SpeechSynthesizer
        #$Discos = $Module.path -replace 'HueAPI.psm1','Private\Media\disco.jpg'
        #$Alerts = $Module.path -replace 'HueAPI.psm1','Private\Media\Alert.png'
        #$loops = $Module.path -replace 'HueAPI.psm1','Private\Media\Loop.jpg'
    }
    Process{
        If ($Clear -eq $True){
            $Val=@{"effect"= "none"} 
            Invoke-RestMethod -Uri "http://$($BridgeIP)/api/$($hueAPIKey)/groups/$($groupNum)/action" -Method Put -ContentType application/json -Body (ConvertTo-Json -InputObject $Val)
        }
        elseif ($DiscoParty -eq $True) {
            $Val=@{"effect"= "none"} 
            Invoke-RestMethod -Uri "http://$($BridgeIP)/api/$($hueAPIKey)/groups/$($groupNum)/action" -Method Put -ContentType application/json -Body (ConvertTo-Json -InputObject $Val)
            #New-BurntToastNotification -Text "DISCO DISCO!",'Time To Party!' -AppLogo $Discos
            Start-Sleep -Milliseconds 100
            $A = 0

            While($a -ne 6528000){
                0,9000,12750,25500,46920,56100| %{Invoke-RestMethod -Uri "http://$($BridgeIP)/api/$($hueAPIKey)/lights/$($lightNum1)/state" -Method Put -ContentType application/json -Body (ConvertTo-Json -InputObject @{"on"=$true 
                    "sat"=254 
                    "bri"=254 
                    "hue"=$_})
                Start-Sleep -Milliseconds 100
                }
            $A++}    
        }
        elseif ($Loop -eq $True) {
            $Val=@{"effect"= "colorloop"}
            Invoke-RestMethod -Uri "http://$($BridgeIP)/api/$($hueAPIKey)/groups/$($groupNum)/action" -Method Put -ContentType application/json -Body (ConvertTo-Json -InputObject $Val)
            #New-BurntToastNotification -Text "Hoola Loops!",'I am Feeling Loopy!' -Sound Reminder -AppLogo $Loops     
        }
        elseif ($Alert -eq $True) {
            $Val=@{"effect"= "none"} 
            Invoke-RestMethod -Uri "http://$($BridgeIP)/api/$($hueAPIKey)/groups/$($groupNum)/action" -Method Put -ContentType application/json -Body (ConvertTo-Json -InputObject $Val)
            #New-BurntToastNotification -Text "Red Alert! Red Alert!",'All Hands On Deck!' -Sound Alarm10 -AppLogo $Alerts
            Start-Sleep -Milliseconds 100
            $A = 0
            $red = @{"on"=$true 
                "sat"=254 
                "bri"=254 
                "hue"=0}
            $Val=@{"alert"= "lselect"}
            while($a -ne 2){
            #Invoke-RestMethod -Uri "http://$($BridgeIP)/api/$($hueAPIKey)/groups/$($groupNum)/action" -Method Put -ContentType application/json -Body (ConvertTo-Json -InputObject $clear)
            #Start-Sleep -Milliseconds 100  
                Invoke-RestMethod -Uri "http://$($BridgeIP)/api/$($hueAPIKey)/lights/$($lightNum1)/state" -Method Put -ContentType application/json -Body (ConvertTo-Json -InputObject $red)
                Start-Sleep -Milliseconds 100
                Invoke-RestMethod -Uri "http://$($BridgeIP)/api/$($hueAPIKey)/groups/$($groupNum)/action" -Method Put -ContentType application/json -Body (ConvertTo-Json -InputObject $Val)
                #(new-object Media.SoundPlayer "C:\Projects\Rich-HelpFileTest\HueAPI\Private\tos-redalert.wav").playlooping()
                $speak.Speak("Red Alert. Red Alert. Red Alert. Red Alert. It's Jason's Fault.") 
                Start-Sleep 15
            $A++}
            
        }
        elseif ($Xmas -eq $True){
            $red = @{"on"=$true 
            "sat"=254 
            "bri"=254 
            "hue"=0}
            $green = @{"on"=$true 
            "sat"=254 
            "bri"=254 
            "hue"=25500}

            $A = 0
            Write-Host "The Little Lights Aren't Twinkling Clark" -ForegroundColor Red -BackgroundColor Green
            While($a -ne 6528000){
                Invoke-RestMethod -Uri "http://$($BridgeIP)/api/$($hueAPIKey)/lights/$($lightNum1)/state/" -Method Put -ContentType application/json -Body (ConvertTo-Json -InputObject $green)
                Start-Sleep -Milliseconds 100
                Invoke-RestMethod -Uri "http://$($BridgeIP)/api/$($hueAPIKey)/lights/$($lightNum2)/state/" -Method Put -ContentType application/json -Body (ConvertTo-Json -InputObject $red)
                Start-Sleep -seconds 1
                Invoke-RestMethod -Uri "http://$($BridgeIP)/api/$($hueAPIKey)/lights/$($lightNum1)/state/" -Method Put -ContentType application/json -Body (ConvertTo-Json -InputObject $red)
                Start-Sleep -Milliseconds 100
                Invoke-RestMethod -Uri "http://$($BridgeIP)/api/$($hueAPIKey)/lights/$($lightNum2)/state/" -Method Put -ContentType application/json -Body (ConvertTo-Json -InputObject $green)
                Start-Sleep -seconds 1
                $A++
            }
        }
        Elseif($ResetSaturation -eq $True){
            Write-Host "These Dull Ass Lights Need Brightened Up"
            $red = @{"on"=$true 
            "sat"=254 
            "bri"=254 
            "hue"=0}
            Invoke-RestMethod -Uri "http://$($BridgeIP)/api/$($hueAPIKey)/lights/$($lightNum1)/state/" -Method Put -ContentType application/json -Body (ConvertTo-Json -InputObject $red)
            Invoke-RestMethod -Uri "http://$($BridgeIP)/api/$($hueAPIKey)/lights/$($lightNum1)/state/" -Method Put -ContentType application/json -Body (ConvertTo-Json -InputObject $red)
        }
    }
}