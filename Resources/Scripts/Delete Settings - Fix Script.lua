pcall(function()
	local Title = game:HttpGet("https://raw.githubusercontent.com/Exunys/Wall-Hack/main/Resources/Information/Title.txt")

	if isfolder(Title) then
		delfolder(Title)
	end
end)
