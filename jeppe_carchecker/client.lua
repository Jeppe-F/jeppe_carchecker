-- enkelt jävla script för att se fordonets motorhälsa, motor temperatur samt att kunna checka hur mycket soppa man har : )

-- jeppe

ESX = nil

Citizen.CreateThread(
	function()
		while ESX == nil do
			TriggerEvent(
				"esx:getSharedObject",
				function(obj)
					ESX = obj
				end
			)
			Citizen.Wait(0)
		end
	end
)

RegisterCommand(
	"checkcar", -- skriv /checkcar för att se motortemp samt hälsa.
	function()
		local Avrunda = math.floor -- ta bort avrundningen om du vill ha ett mer exakt nummer.
		local PlayerPed = GetPlayerPed()
		local Vehicle = GetVehiclePedIsIn(PlayerPed, false)
		local IsInVehicle = IsPedInVehicle(PlayerPed, Vehicle, false)
		local Pos = GetEntityCoords(PlayerPedId())
		local ClosestVehicle = ESX.Game.GetClosestVehicle(Pos)
		local EngineHealth = Avrunda(GetVehicleEngineHealth(ClosestVehicle))
		local MotorTemp = Avrunda(GetVehicleEngineTemperature(ClosestVehicle))
		local dstCheck = GetDistanceBetweenCoords(Pos, GetEntityCoords(ClosestVehicle), true)

		if IsInVehicle then
			TriggerEvent(
				"pNotify:SendNotification",
				{
					text = "Du kan ej sitta i fordonet när du ska checka på bilen!",
					type = "warning",
					timeout = 5000,
					layout = "bottomcenter"
				}
			)
		elseif dstCheck >= 5 and ClosestVehicle then
			TriggerEvent(
				"pNotify:SendNotification",
				{
					text = "Du är för långt ifrån närmsta fordon",
					type = "warning",
					timeout = 5000,
					layout = "bottomcenter"
				}
			)
		elseif dstCheck <= 5 and ClosestVehicle then
			TriggerEvent(
				"pNotify:SendNotification",
				{
					text = "Checkar på fordonets temperatur samt motorhälsa...",
					type = "normal",
					timeout = 5000,
					layout = "bottomcenter"
				}
			)
			print(EngineHealth)
			Citizen.Wait(10000)
			TriggerEvent(
				"pNotify:SendNotification",
				{
					text = "Fordonets Temperatur ligger på " .. MotorTemp .. " Grader Celsius",
					type = "normal",
					timeout = 5000,
					layout = "bottomcenter"
				}
			)
			Citizen.Wait(2000)

			if EngineHealth >= 800 then
				TriggerEvent(
					"pNotify:SendNotification",
					{
						text = "Fordonets motorhälsa är tipp topp!",
						type = "succses",
						timeout = 5000,
						layout = "bottomcenter"
					}
				)
			elseif EngineHealth < 800 and EngineHealth >= 500 then
				TriggerEvent(
					"pNotify:SendNotification",
					{
						text = "Fordonets motorhälsa är Si sådär",
						type = "normal",
						timeout = 5000,
						layout = "bottomcenter"
					}
				)
			elseif EngineHealth < 500 and EngineHealth >= 200 then
				TriggerEvent(
					"pNotify:SendNotification",
					{
						text = "Nu börjar fordonet må riktigt dåligt",
						type = "warning",
						timeout = 5000,
						layout = "bottomcenter"
					}
				)
			elseif EngineHealth < 200 and EngineHealth >= 0 then
				TriggerEvent(
					"pNotify:SendNotification",
					{
						text = "Nu är den dö",
						type = "warning",
						timeout = 5000,
						layout = "bottomcenter"
					}
				)
			end
		end
	end
)

RegisterCommand(
	"getfuel", -- skriv /getfuel för att se hur mycket soppa du har : )
	function()
		local playerPed = GetPlayerPed()
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		local fuelLevel = math.floor(GetVehicleFuelLevel(vehicle))
		local IsInVeh = IsPedInVehicle(playerPed, vehicle, false)

		if IsInVeh then
			TriggerEvent(
				"pNotify:SendNotification",
				{
					text = "Ditt fordons bränslenivå ligger på " .. fuelLevel .. " %",
					type = "normal",
					timeout = 7500,
					layout = "bottomcenter"
				}
			)
		else
			TriggerEvent(
				"pNotify:SendNotification",
				{text = "Du sitter inte i ett fordon", type = "warning", timeout = 5000, layout = "bottomcenter"}
			)
		end
	end
)
