local PlayerData				= {}
local CurrentAction				= nil
local CurrentActionMsg			= ''
local CurrentActionData			= {}
local work = false
local szpital = 0
local tekst = 0
local showTimer = false
ESX                           = nil
CreateThread(function()
	while ESX == nil do
		TriggerEvent("hypex:getTwojStarySharedTwojaStaraObject", function(library)
			ESX = library
		end)
	  
		Citizen.Wait(250)
	end
	while true do
		PlayerData = ESX.GetPlayerData()
		Citizen.Wait(800)
	end
end)

CreateThread(function()
	while PlayerData.job == nil do
		Citizen.Wait(100)
	end
	while true do
		if PlayerData.job.name == 'ambulance' then
			local playerPed = PlayerPedId()
			pCoords = GetEntityCoords(playerPed)
		else
			local playerPed = PlayerPedId()
			tCoords = GetEntityCoords(playerPed)
		end
		Citizen.Wait(500)
	end
end)
function DrawText3D(x, y, z, text, scale)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 255)
	SetTextOutline()

	AddTextComponentString(text)
	DrawText(_x, _y)

	local factor = (string.len(text)) / 270
	DrawRect(_x, _y + 0.015, 0.005 + factor, 0.03, 31, 31, 31, 155)
end
function startjob()
	work = true
	if szpital == 0 then
		local xd = math.random(1, 3)
		if (xd == 1) then
			ESX.ShowNotification("Udaj sie karetka na znacznik i odbierz organ. Pamietaj Aby jechac karetka!")
			SetNewWaypoint(298.07989501953, -584.30718994141, 42.26029586792)
			print("1")
			szpital = 1
		elseif (xd == 2) then
			print("2")
			ESX.ShowNotification("Udaj sie karetka na znacznik i odbierz organ. Pamietaj Aby jechac karetka!")
			SetNewWaypoint(-822.17791748047, -1223.6275634766, 6.3653984069824)
			szpital = 2
		else
			ESX.ShowNotification("Udaj sie karetka na znacznik i odbierz organ. Pamietaj Aby jechac karetka!")
			SetNewWaypoint(-677.01861572266, 313.87774658203, 82.084114074707)
			szpital = 3
		end
	else
		ESX.ShowNotification('Masz juz kurs')
	end
end
-- Nie Alkoholu xD
RegisterNetEvent('jhn:procenty')
AddEventHandler('jhn:procenty', function()
	showTimer = true

	while (showTimer) do
		Wait(0)
		DisableControlAction(0, 73, true) -- X
		DrawText3D(pCoords.x, pCoords.y, pCoords.z + 0.1, tekst .. '~g~%', 0.4)
    end
end)
function stopuj()
	print("work")
	inProgress = false
	ESX.ShowNotification('Masz Juz Organ i zapierdalaj dalej')
	SetNewWaypoint(1151.3088378906, -1529.7966308594, 34.37032699585)
	FreezeEntityPosition(PlayerPedId(), false)
	ClearPedTasks(PlayerPedId())
	TriggerServerEvent("jhn_organy:xD")
end
function Timer(time)
	TriggerEvent('jhn:procenty')
	CreateThread(function()
		tekst = 0
		repeat
			tekst = tekst + 1
			Citizen.Wait(time)
		until tekst == 100
		showTimer = false
		stopuj()
	end)
end

function hospital1()
	if szpital == 1 then
		ESX.ShowNotification("Czekasz Na Dostarczenei Organu")
		local playerPed = PlayerPedId()

		ESX.TriggerServerCallback('gcphone:getItemAmount', function(count)
			if count < 1 then
				ClearPedTasks(playerPed)
				FreezeEntityPosition(playerPed, true)
				inProgress = true
				Timer(1800)
			else
				inProgress = false
				ESX.ShowNotification('~y~Masz Juz Organ')
			end
		end, 'organ')
	elseif szpital == 0 then
		ESX.ShowNotification("Nie masz kursu")
	else
		ESX.ShowNotification("Nie ten szpital!")
	end
end
function hospital2()
	if szpital == 2 then
		ESX.ShowNotification("Czekasz Na Dostarczenei Organu")
		local playerPed = PlayerPedId()

		ESX.TriggerServerCallback('gcphone:getItemAmount', function(count)
			if count < 1 then
				ClearPedTasks(playerPed)
				FreezeEntityPosition(playerPed, true)
				inProgress = true
				Timer(1800)
			else
				inProgress = false
				ESX.ShowNotification('~y~Masz Juz Organ')
			end
		end, 'organ')
	elseif szpital == 0 then
		ESX.ShowNotification("Nie masz kursu")
	else
		ESX.ShowNotification("Nie ten szpital!")
	end
end
function hospital3()
	if szpital == 3 then
		ESX.ShowNotification("Czekasz Na Dostarczenei Organu")
		local playerPed = PlayerPedId()

		ESX.TriggerServerCallback('gcphone:getItemAmount', function(count)
			if count < 1 then
				ClearPedTasks(playerPed)
				FreezeEntityPosition(playerPed, true)
				inProgress = true
				Timer(1800)
			else
				inProgress = false
				ESX.ShowNotification('~y~Masz Juz Organ')
			end
		end, 'organ')
	elseif szpital == 0 then
		ESX.ShowNotification("Nie masz kursu")
	else
		ESX.ShowNotification("Nie ten szpital!")
	end
end
function hospitalmain()
		local playerPed = PlayerPedId()

		ESX.TriggerServerCallback('gcphone:getItemAmount', function(count)
			if count < 1 then
				ESX.ShowNotification("Nie Masz Organu")
			else
				ESX.ShowNotification('Oddajesz Organ')
				TriggerServerEvent('jhn_organy:xDe')
				szpital = 0
			end
		end, 'organ')
end

CreateThread(function()
	while true do

		Citizen.Wait(10)
		if PlayerData.job and PlayerData.job.name == 'ambulance' then

			if CurrentAction ~= nil and not cooldown then

				ESX.ShowHelpNotification(CurrentActionMsg)

				if IsControlJustReleased(0, 38) then
					if CurrentAction == 'getwork' then
						startjob()
					elseif CurrentAction == 'hospital1' then
						hospital1()
					elseif CurrentAction == 'hospitalmain' then
						hospitalmain()
					elseif CurrentAction == 'hospital2' then
						hospital2()
					elseif CurrentAction == 'hospital3' then
						hospital3()
					else
						inAction = false
					end
					CurrentAction = nil
				end
			end
			if IsControlJustReleased(0, 167) and IsInputDisabled(0) and PlayerData.job.grade >= 7 then
				OpenMobileCafeActionsMenu()
			end
		else
			Citizen.Wait(2000)
		end
	end
end)
AddEventHandler('jhn_organy:hasEnteredMarker', function(station, partNum)
	if station == 'getwork' then
		CurrentAction		= 'getwork'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby Rozpoczac Kurs Po Organ"
		CurrentActionData	= {}
	elseif station == 'hospital2' then
		CurrentAction		= 'hospital1'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, Zebrac Organ"
		CurrentActionData	= {}
	elseif station == 'hospital3' then
		CurrentAction		= 'hospital2'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, Zebrac Organ"
		CurrentActionData	= {}
	elseif station == 'hospital4' then
		CurrentAction		= 'hospital3'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, Zebrac Organ"
		CurrentActionData	= {}
	elseif station == 'hospitalmain' then
		CurrentAction		= 'hospitalmain'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, Oddac organ"
		CurrentActionData	= {}
		
	end
end)

AddEventHandler('jhn_organy:hasExitedMarker', function(station, partNum)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)
print("Dziala")
CreateThread(function()
	while true do
		Citizen.Wait(3)
		if PlayerData.job ~= nil and (PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'offambulance') then
			local found = false
			local coords = GetEntityCoords(PlayerPedId())
			for k,v in pairs(Config.Markers) do
				for i=1, #v, 1 do
					if k == 'getwork' then
						if #(coords - v[i].coords) < 10 then
							found = true
							ESX.DrawBigMarker(v[i].coords)
						end
					elseif k == 'hospital2' then
						if #(coords - v[i].coords) < 10 then
							found = true
							ESX.DrawBigMarker(v[i].coords)
						end
					elseif k == 'hospital3' then
						if #(coords - v[i].coords) < 10 then
							found = true
							ESX.DrawBigMarker(v[i].coords)
						end
					elseif k == 'hospital4' then
						if #(coords - v[i].coords) < 10 then
							found = true
							ESX.DrawBigMarker(v[i].coords)
						end
					elseif k == 'hospitalmain' then
						if #(coords - v[i].coords) < 10 then
							found = true
							ESX.DrawBigMarker(v[i].coords)
						end
					end
				end
			end
			
			if not found then
				Citizen.Wait(2000)
			end
		else
			Citizen.Wait(100)
		end
	end
end)
CreateThread(function()
	while true do
		Citizen.Wait(60)

		local coords, sleep		= GetEntityCoords(PlayerPedId()), true
		local isInMarker	= false
		local currentZone	= nil
		local zoneNumber 	= nil
		
		for k,v in pairs(Config.Markers) do
			if PlayerData.job ~= nil and (PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'offambulance') then
				for i=1, #v, 1 do
					if k == 'getwork' then
					
						if #(coords - v[i].coords) < 4.0 then
							sleep = false
							isInMarker	= true
							currentZone = k
							zoneNumber = i
						
						end
					elseif k == 'hospital2' then
					
						if #(coords - v[i].coords) < 4.0 then
							sleep = false
							isInMarker	= true
							currentZone = k
							zoneNumber = i
						
						end
					elseif k == 'hospital3' then
					
						if #(coords - v[i].coords) < 4.0 then
							sleep = false
							isInMarker	= true
							currentZone = k
							zoneNumber = i
						
						end
					elseif k == 'hospital4' then
					
						if #(coords - v[i].coords) < 4.0 then
							sleep = false
							isInMarker	= true
							currentZone = k
							zoneNumber = i
						
						end
					elseif k == 'hospitalmain' then
					
						if #(coords - v[i].coords) < 4.0 then
							sleep = false
							isInMarker	= true
							currentZone = k
							zoneNumber = i
						
						end

					end
				end
			end
		end
		
		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			lastZone				= currentZone
			TriggerEvent('jhn_organy:hasEnteredMarker', currentZone, zoneNumber)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('jhn_organy:hasExitedMarker', lastZone)
		end
		
		if sleep then
			Citizen.Wait(250)
		end
	end
end)