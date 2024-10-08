------------------------------------------------------------------------------
--	FILE:	 Frontier.lua
--	AUTHOR:  Bob Thomas
--	PURPOSE: Global map script - Adds extra, unpopulated regions to the map.
------------------------------------------------------------------------------
--	Copyright (c) 2012 Firaxis Games, Inc. All rights reserved.
------------------------------------------------------------------------------

include("MapGenerator");
include("FractalWorld");
include("FeatureGenerator");
include("TerrainGenerator");

------------------------------------------------------------------------------

------------------------------------------------------------------------------
function GetMapScriptInfo()
	local world_age, temperature, rainfall, sea_level, resources = GetCoreMapOptions()
	return {
		Name = "TXT_KEY_MAP_FRONTIER_VP",
		Description = "TXT_KEY_MAP_FRONTIER_HELP",
		IsAdvancedMap = 0,
		IconIndex = 1,
		SortIndex = 1,
		CustomOptions = {world_age, temperature, rainfall, sea_level, resources,
			{
				Name = "TXT_KEY_MAP_OPTION_LANDMASS_TYPE",
				Values = {
					{"TXT_KEY_MAP_OPTION_PANGAEA", "TXT_KEY_MAP_PANGAEA_HELP"},
					{"TXT_KEY_MAP_OPTION_LARGE_CONTINENTS", "TXT_KEY_MAP_CONTINENTS_HELP"},
					"TXT_KEY_MAP_OPTION_RANDOM",
				},
				DefaultValue = 3,
				SortPriority = 1,
			},
		};
	};
end
------------------------------------------------------------------------------
function GetMapInitData(worldSize)
	-- Customized for Frontier. Large and Huge truncated a bit to aid performance.
	local worldsizes = {
		[GameInfo.Worlds.WORLDSIZE_DUEL.ID] = {52, 32},
		[GameInfo.Worlds.WORLDSIZE_TINY.ID] = {64, 40},
		[GameInfo.Worlds.WORLDSIZE_SMALL.ID] = {84, 52},
		[GameInfo.Worlds.WORLDSIZE_STANDARD.ID] = {100, 64},
		[GameInfo.Worlds.WORLDSIZE_LARGE.ID] = {116, 76},
		[GameInfo.Worlds.WORLDSIZE_HUGE.ID] = {132, 88},
	};
	local grid_size = worldsizes[worldSize];

	if GameInfo.Worlds[worldSize] then
		return {
			Width = grid_size[1],
			Height = grid_size[2],
			WrapX = true,
		};
	end
end
------------------------------------------------------------------------------

------------------------------------------------------------------------------
PangaeaFractalWorld = {};
------------------------------------------------------------------------------
function PangaeaFractalWorld.Create(fracXExp, fracYExp)
	local gridWidth, gridHeight = Map.GetGridSize();

	local data = {
		InitFractal = FractalWorld.InitFractal,
		ShiftPlotTypes = FractalWorld.ShiftPlotTypes,
		ShiftPlotTypesBy = FractalWorld.ShiftPlotTypesBy,
		DetermineXShift = FractalWorld.DetermineXShift,
		DetermineYShift = FractalWorld.DetermineYShift,
		GenerateCenterRift = FractalWorld.GenerateCenterRift,
		GeneratePlotTypes = PangaeaFractalWorld.GeneratePlotTypes, -- Custom method

		iFlags = Map.GetFractalFlags(),

		fracXExp = fracXExp,
		fracYExp = fracYExp,

		iNumPlotsX = gridWidth,
		iNumPlotsY = gridHeight,
		plotTypes = table.fill(PlotTypes.PLOT_OCEAN, gridWidth * gridHeight),
	};

	return data;
end
------------------------------------------------------------------------------
function PangaeaFractalWorld:GeneratePlotTypes()
	local sea_level_low = 63;
	local sea_level_normal = 68;
	local sea_level_high = 73;
	local world_age_old = 2;
	local world_age_normal = 3;
	local world_age_new = 5;

	local extra_mountains = 6;
	local adjust_plates = 1.3;
	local tectonic_islands = true;
	local hills_ridge_flags = self.iFlags;
	local peaks_ridge_flags = self.iFlags;

	local sea_level = Map.GetCustomOption(4);
	if sea_level == 4 then
		sea_level = 1 + Map.Rand(3, "Random Sea Level - Lua");
	end
	local world_age = Map.GetCustomOption(1);
	if world_age == 4 then
		world_age = 1 + Map.Rand(3, "Random World Age - Lua");
	end

	-- Set Sea Level according to user selection.
	local water_percent = sea_level_normal;
	if sea_level == 1 then -- Low Sea Level
		water_percent = sea_level_low;
	elseif sea_level == 3 then -- High Sea Level
		water_percent = sea_level_high;
	else -- Normal Sea Level
	end

	-- Set values for hills and mountains according to World Age chosen by user.
	local adjustment = world_age_normal;
	if world_age == 3 then -- 5 Billion Years
		adjustment = world_age_old;
		adjust_plates = adjust_plates * 0.75;
	elseif world_age == 1 then -- 3 Billion Years
		adjustment = world_age_new;
		adjust_plates = adjust_plates * 1.5;
	else -- 4 Billion Years
	end

	-- Apply adjustment to hills and peaks settings.
	local hillsBottom1 = 28 - adjustment;
	local hillsTop1 = 28 + adjustment;
	local hillsBottom2 = 72 - adjustment;
	local hillsTop2 = 72 + adjustment;
	local hillsNearMountains = 91 - (adjustment * 2) - extra_mountains;
	local mountains = 97 - adjustment - extra_mountains;

	-- Hills and Mountains handled differently according to map size - Bob
	local WorldSizeTypes = {};
	for row in GameInfo.Worlds() do
		WorldSizeTypes[row.Type] = row.ID;
	end
	local sizekey = Map.GetWorldSize();

	-- Fractal Grains
	local sizevalues = {
		[WorldSizeTypes.WORLDSIZE_DUEL] = 3,
		[WorldSizeTypes.WORLDSIZE_TINY] = 3,
		[WorldSizeTypes.WORLDSIZE_SMALL] = 4,
		[WorldSizeTypes.WORLDSIZE_STANDARD] = 4,
		[WorldSizeTypes.WORLDSIZE_LARGE] = 5,
		[WorldSizeTypes.WORLDSIZE_HUGE] = 5,
	};
	local grain = sizevalues[sizekey] or 3;

	-- Tectonics Plate Counts
	local platevalues = {
		[WorldSizeTypes.WORLDSIZE_DUEL] = 6,
		[WorldSizeTypes.WORLDSIZE_TINY] = 9,
		[WorldSizeTypes.WORLDSIZE_SMALL] = 12,
		[WorldSizeTypes.WORLDSIZE_STANDARD] = 18,
		[WorldSizeTypes.WORLDSIZE_LARGE] = 24,
		[WorldSizeTypes.WORLDSIZE_HUGE] = 30,
	};
	local numPlates = platevalues[sizekey] or 5;
	-- Add in any plate count modifications passed in from the map script. - Bob
	numPlates = numPlates * adjust_plates;

	-- Generate continental fractal layer and examine the largest landmass. Reject
	-- the result until the largest landmass occupies 84% or more of the total land.
	local done = false;
	local iAttempts = 0;
	local iWaterThreshold;
	local iBiggestID;
	while not done do
		local grain_dice = Map.Rand(7, "Continental Grain roll - LUA Pangaea");
		if grain_dice < 4 then
			grain_dice = 1;
		else
			grain_dice = 2;
		end
		local rift_dice = Map.Rand(3, "Rift Grain roll - LUA Pangaea");
		if rift_dice < 1 then
			rift_dice = -1;
		end

		self.continentsFrac = nil;
		self:InitFractal{continent_grain = grain_dice, rift_grain = rift_dice};
		iWaterThreshold = self.continentsFrac:GetHeight(water_percent);

		local iNumTotalLandTiles = 0;
		for x = 0, self.iNumPlotsX - 1 do
			for y = 0, self.iNumPlotsY - 1 do
				local i = y * self.iNumPlotsX + x;
				local val = self.continentsFrac:GetHeight(x, y);
				if val <= iWaterThreshold then
					self.plotTypes[i] = PlotTypes.PLOT_OCEAN;
				else
					self.plotTypes[i] = PlotTypes.PLOT_LAND;
					iNumTotalLandTiles = iNumTotalLandTiles + 1;
				end
			end
		end

		SetPlotTypes(self.plotTypes);
		Map.RecalculateAreas();
		iBiggestID = Map.FindBiggestLandmassID(false);

		local iNumBiggestLandmassTiles = Map.GetNumTilesOfLandmass(iBiggestID);
		-- Now test the biggest landmass to see if it is large enough.
		if iNumBiggestLandmassTiles >= iNumTotalLandTiles * 0.84 then
			done = true;
		end
		iAttempts = iAttempts + 1;

		--[[ Printout for debug use only
		print("-"); print("--- Pangaea landmass generation, Attempt#", iAttempts, "---");
		print("- This attempt successful: ", done);
		print("- Total Land Plots in world:", iNumTotalLandTiles);
		print("- Land Plots belonging to biggest landmass:", iNumBiggestLandmassTiles);
		print("- Percentage of land belonging to Pangaea: ", 100 * iNumBiggestLandmassTiles / iNumTotalLandTiles);
		print("- Continent Grain for this attempt: ", grain_dice);
		print("- Rift Grain for this attempt: ", rift_dice);
		print("- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -");
		print(".");
		--]]
	end

	-- Generate fractals to govern hills and mountains
	self.hillsFrac = Fractal.Create(self.iNumPlotsX, self.iNumPlotsY, grain, self.iFlags, self.fracXExp, self.fracYExp);
	self.mountainsFrac = Fractal.Create(self.iNumPlotsX, self.iNumPlotsY, grain, self.iFlags, self.fracXExp, self.fracYExp);
	self.hillsFrac:BuildRidges(numPlates, hills_ridge_flags, 1, 2);
	self.mountainsFrac:BuildRidges(numPlates * 2 / 3, peaks_ridge_flags, 6, 1);
	-- Get height values
	local iHillsBottom1 = self.hillsFrac:GetHeight(hillsBottom1);
	local iHillsTop1 = self.hillsFrac:GetHeight(hillsTop1);
	local iHillsBottom2 = self.hillsFrac:GetHeight(hillsBottom2);
	local iHillsTop2 = self.hillsFrac:GetHeight(hillsTop2);
	local iHillsNearMountains = self.mountainsFrac:GetHeight(hillsNearMountains);
	local iMountainThreshold = self.mountainsFrac:GetHeight(mountains);
	local iPassThreshold = self.hillsFrac:GetHeight(hillsNearMountains);
	-- Get height values for tectonic islands
	local iMountain100 = self.mountainsFrac:GetHeight(100);
	local iMountain99 = self.mountainsFrac:GetHeight(99);
	local iMountain97 = self.mountainsFrac:GetHeight(97);
	local iMountain95 = self.mountainsFrac:GetHeight(95);

	-- Because we haven't yet shifted the plot types, we will not be able to take advantage of having water and flatland plots already set.
	-- We still have to generate all data for hills and mountains, too, then shift everything, then set plots one more time.
	for x = 0, self.iNumPlotsX - 1 do
		for y = 0, self.iNumPlotsY - 1 do

			local i = y * self.iNumPlotsX + x;
			local val = self.continentsFrac:GetHeight(x, y);
			local mountainVal = self.mountainsFrac:GetHeight(x, y);
			local hillVal = self.hillsFrac:GetHeight(x, y);

			if val <= iWaterThreshold then
				self.plotTypes[i] = PlotTypes.PLOT_OCEAN;
				if tectonic_islands then -- Build islands in oceans along tectonic ridge lines - Brian
					if mountainVal == iMountain100 then -- Isolated peak in the ocean
						self.plotTypes[i] = PlotTypes.PLOT_MOUNTAIN;
					elseif mountainVal == iMountain99 then
						self.plotTypes[i] = PlotTypes.PLOT_HILLS;
					elseif mountainVal == iMountain97 or mountainVal == iMountain95 then
						self.plotTypes[i] = PlotTypes.PLOT_LAND;
					end
				end
			else
				if mountainVal >= iMountainThreshold then
					if hillVal >= iPassThreshold then -- Mountain Pass though the ridgeline - Brian
						self.plotTypes[i] = PlotTypes.PLOT_HILLS;
					else -- Mountain
						self.plotTypes[i] = PlotTypes.PLOT_MOUNTAIN;
					end
				elseif mountainVal >= iHillsNearMountains then
					self.plotTypes[i] = PlotTypes.PLOT_HILLS; -- Foot hills - Bob
				else
					if (hillVal >= iHillsBottom1 and hillVal <= iHillsTop1) or (hillVal >= iHillsBottom2 and hillVal <= iHillsTop2) then
						self.plotTypes[i] = PlotTypes.PLOT_HILLS;
					else
						self.plotTypes[i] = PlotTypes.PLOT_LAND;
					end
				end
			end
		end
	end

	self:ShiftPlotTypes();

	-- Now shift everything toward one of the poles, to reduce how much jungles tend to dominate this script.
	local shift_dice = Map.Rand(2, "Shift direction - LUA Pangaea");
	local iStartRow;
	local bFoundPangaea, bDoShift = false, false;
	if shift_dice == 1 then
		-- Shift North
		for y = self.iNumPlotsY - 2, 1, -1 do
			for x = 0, self.iNumPlotsX - 1 do
				local i = y * self.iNumPlotsX + x;
				if self.plotTypes[i] == PlotTypes.PLOT_HILLS or self.plotTypes[i] == PlotTypes.PLOT_LAND then
					local plot = Map.GetPlot(x, y);
					local iLandmassID = plot:GetLandmass();
					if iLandmassID == iBiggestID then
						bFoundPangaea = true;
						iStartRow = y + 1;
						if iStartRow < self.iNumPlotsY - 4 then -- Enough rows of water space to do a shift.
							bDoShift = true;
						end
						break;
					end
				end
			end
			-- Check to see if we've found the Pangaea.
			if bFoundPangaea then
				break;
			end
		end
	else
		-- Shift South
		for y = 1, self.iNumPlotsY - 2 do
			for x = 0, self.iNumPlotsX - 1 do
				local i = y * self.iNumPlotsX + x;
				if self.plotTypes[i] == PlotTypes.PLOT_HILLS or self.plotTypes[i] == PlotTypes.PLOT_LAND then
					local plot = Map.GetPlot(x, y);
					local iLandmassID = plot:GetLandmass();
					if iLandmassID == iBiggestID then
						bFoundPangaea = true;
						iStartRow = y - 1;
						if iStartRow > 3 then -- Enough rows of water space to do a shift.
							bDoShift = true;
						end
						break;
					end
				end
			end
			-- Check to see if we've found the Pangaea.
			if bFoundPangaea then
				break;
			end
		end
	end
	if bDoShift then
		if shift_dice == 1 then -- Shift North
			local iRowsDifference = self.iNumPlotsY - iStartRow - 2;
			local iRowsInPlay = math.floor(iRowsDifference * 0.7);
			local iRowsBase = math.ceil(iRowsDifference * 0.3);
			local rows_dice = Map.Rand(iRowsInPlay, "Number of Rows to Shift - LUA Pangaea");
			local iNumRows = math.min(iRowsDifference - 1, iRowsBase + rows_dice);
			local iNumEvenRows = 2 * math.floor(iNumRows / 2); -- MUST be an even number or we risk breaking a 1-tile isthmus and splitting the Pangaea.
			local iNumRowsToShift = math.max(2, iNumEvenRows);
			-- print("-"); print("Shifting lands northward by this many plots: ", iNumRowsToShift); print("-");
			-- Process from top down.
			for y = (self.iNumPlotsY - 1) - iNumRowsToShift, 0, -1 do
				for x = 0, self.iNumPlotsX - 1 do
					local sourcePlotIndex = y * self.iNumPlotsX + x + 1;
					local destPlotIndex = (y + iNumRowsToShift) * self.iNumPlotsX + x + 1;
					self.plotTypes[destPlotIndex] = self.plotTypes[sourcePlotIndex];
				end
			end
			for y = 0, iNumRowsToShift - 1 do
				for x = 0, self.iNumPlotsX - 1 do
					local i = y * self.iNumPlotsX + x + 1;
					self.plotTypes[i] = PlotTypes.PLOT_OCEAN;
				end
			end
		else -- Shift South
			local iRowsDifference = iStartRow - 1;
			local iRowsInPlay = math.floor(iRowsDifference * 0.7);
			local iRowsBase = math.ceil(iRowsDifference * 0.3);
			local rows_dice = Map.Rand(iRowsInPlay, "Number of Rows to Shift - LUA Pangaea");
			local iNumRows = math.min(iRowsDifference - 1, iRowsBase + rows_dice);
			local iNumEvenRows = 2 * math.floor(iNumRows / 2); -- MUST be an even number or we risk breaking a 1-tile isthmus and splitting the Pangaea.
			local iNumRowsToShift = math.max(2, iNumEvenRows);
			-- print("-"); print("Shifting lands southward by this many plots: ", iNumRowsToShift); print("-");
			-- Process from bottom up.
			for y = 0, (self.iNumPlotsY - 1) - iNumRowsToShift do
				for x = 0, self.iNumPlotsX - 1 do
					local sourcePlotIndex = (y + iNumRowsToShift) * self.iNumPlotsX + x + 1;
					local destPlotIndex = y * self.iNumPlotsX + x + 1;
					self.plotTypes[destPlotIndex] = self.plotTypes[sourcePlotIndex];
				end
			end
			for y = self.iNumPlotsY - iNumRowsToShift, self.iNumPlotsY - 1 do
				for x = 0, self.iNumPlotsX - 1 do
					local i = y * self.iNumPlotsX + x + 1;
					self.plotTypes[i] = PlotTypes.PLOT_OCEAN;
				end
			end
		end
	end

	return self.plotTypes;
end
------------------------------------------------------------------------------

------------------------------------------------------------------------------
ContinentsFractalWorld = {};
------------------------------------------------------------------------------
function ContinentsFractalWorld.Create(fracXExp, fracYExp)
	local gridWidth, gridHeight = Map.GetGridSize();

	local data = {
		InitFractal = FractalWorld.InitFractal,
		ShiftPlotTypes = FractalWorld.ShiftPlotTypes,
		ShiftPlotTypesBy = FractalWorld.ShiftPlotTypesBy,
		DetermineXShift = FractalWorld.DetermineXShift,
		DetermineYShift = FractalWorld.DetermineYShift,
		GenerateCenterRift = FractalWorld.GenerateCenterRift,
		GeneratePlotTypes = ContinentsFractalWorld.GeneratePlotTypes, -- Custom method

		iFlags = Map.GetFractalFlags(),

		fracXExp = fracXExp,
		fracYExp = fracYExp,

		iNumPlotsX = gridWidth,
		iNumPlotsY = gridHeight,
		plotTypes = table.fill(PlotTypes.PLOT_OCEAN, gridWidth * gridHeight),
	};

	return data;
end
------------------------------------------------------------------------------
function ContinentsFractalWorld:GeneratePlotTypes()
	local sea_level_low = 67;
	local sea_level_normal = 72;
	local sea_level_high = 76;
	local world_age_old = 2;
	local world_age_normal = 3;
	local world_age_new = 5;

	local extra_mountains = 0;
	local adjust_plates = 1.0;
	local hills_ridge_flags = self.iFlags;
	local peaks_ridge_flags = self.iFlags;

	local sea_level = Map.GetCustomOption(4);
	if sea_level == 4 then
		sea_level = 1 + Map.Rand(3, "Random Sea Level - Lua");
	end
	local world_age = Map.GetCustomOption(1);
	if world_age == 4 then
		world_age = 1 + Map.Rand(3, "Random World Age - Lua");
	end

	-- Set Sea Level according to user selection.
	local water_percent = sea_level_normal;
	if sea_level == 1 then -- Low Sea Level
		water_percent = sea_level_low;
	elseif sea_level == 3 then -- High Sea Level
		water_percent = sea_level_high;
	else -- Normal Sea Level
	end

	-- Set values for hills and mountains according to World Age chosen by user.
	local adjustment = world_age_normal;
	if world_age == 3 then -- 5 Billion Years
		adjustment = world_age_old;
		adjust_plates = adjust_plates * 0.75;
	elseif world_age == 1 then -- 3 Billion Years
		adjustment = world_age_new;
		adjust_plates = adjust_plates * 1.5;
	else -- 4 Billion Years
	end
	-- Apply adjustment to hills and peaks settings.
	local hillsBottom1 = 28 - adjustment;
	local hillsTop1 = 28 + adjustment;
	local hillsBottom2 = 72 - adjustment;
	local hillsTop2 = 72 + adjustment;
	local hillsNearMountains = 91 - (adjustment * 2) - extra_mountains;
	local mountains = 97 - adjustment - extra_mountains;

	-- Hills and Mountains handled differently according to map size
	local WorldSizeTypes = {};
	for row in GameInfo.Worlds() do
		WorldSizeTypes[row.Type] = row.ID;
	end
	local sizekey = Map.GetWorldSize();

	-- Fractal Grains
	local sizevalues = {
		[WorldSizeTypes.WORLDSIZE_DUEL] = 3,
		[WorldSizeTypes.WORLDSIZE_TINY] = 3,
		[WorldSizeTypes.WORLDSIZE_SMALL] = 4,
		[WorldSizeTypes.WORLDSIZE_STANDARD] = 4,
		[WorldSizeTypes.WORLDSIZE_LARGE] = 5,
		[WorldSizeTypes.WORLDSIZE_HUGE] = 5,
	};
	local grain = sizevalues[sizekey] or 3;

	-- Tectonics Plate Counts
	local platevalues = {
		[WorldSizeTypes.WORLDSIZE_DUEL] = 6,
		[WorldSizeTypes.WORLDSIZE_TINY] = 9,
		[WorldSizeTypes.WORLDSIZE_SMALL] = 12,
		[WorldSizeTypes.WORLDSIZE_STANDARD] = 18,
		[WorldSizeTypes.WORLDSIZE_LARGE] = 24,
		[WorldSizeTypes.WORLDSIZE_HUGE] = 30,
	};
	local numPlates = platevalues[sizekey] or 5;
	-- Add in any plate count modifications passed in from the map script.
	numPlates = numPlates * adjust_plates;

	-- Generate continental fractal layer and examine the largest landmass. Reject
	-- the result until the largest landmass occupies 58% or less of the total land.
	local done = false;
	local iAttempts = 0;
	while not done do
		local grain_dice = Map.Rand(7, "Continental Grain roll - LUA Continents");
		if grain_dice < 4 then
			grain_dice = 2;
		else
			grain_dice = 1;
		end
		local rift_dice = Map.Rand(3, "Rift Grain roll - LUA Continents");
		if rift_dice < 1 then
			rift_dice = -1;
		end

		self.continentsFrac = nil;
		self:InitFractal{continent_grain = grain_dice, rift_grain = rift_dice};
		local iWaterThreshold = self.continentsFrac:GetHeight(water_percent);

		local iNumTotalLandTiles = 0;
		for x = 0, self.iNumPlotsX - 1 do
			for y = 0, self.iNumPlotsY - 1 do
				local i = y * self.iNumPlotsX + x;
				local val = self.continentsFrac:GetHeight(x, y);
				if(val <= iWaterThreshold) then
					self.plotTypes[i] = PlotTypes.PLOT_OCEAN;
				else
					self.plotTypes[i] = PlotTypes.PLOT_LAND;
					iNumTotalLandTiles = iNumTotalLandTiles + 1;
				end
			end
		end

		self:ShiftPlotTypes();
		self:GenerateCenterRift();

		SetPlotTypes(self.plotTypes);
		Map.RecalculateAreas();

		local iBiggestID = Map.FindBiggestLandmassID(false);
		local iNumBiggestLandmassTiles = Map.GetNumTilesOfLandmass(iBiggestID);
		-- Now test the biggest landmass to see if it is large enough.
		if iNumBiggestLandmassTiles <= iNumTotalLandTiles * 0.58 then
			done = true;
		end
		iAttempts = iAttempts + 1;

		--[[ Printout for debug use only
		print("-"); print("--- Continents landmass generation, Attempt#", iAttempts, "---");
		print("- This attempt successful: ", done);
		print("- Total Land Plots in world:", iNumTotalLandTiles);
		print("- Land Plots belonging to biggest landmass:", iNumBiggestLandmassTiles);
		print("- Percentage of land belonging to biggest: ", 100 * iNumBiggestLandmassTiles / iNumTotalLandTiles);
		print("- Continent Grain for this attempt: ", grain_dice);
		print("- Rift Grain for this attempt: ", rift_dice);
		print("- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -");
		print(".");
		--]]
	end

	-- Generate fractals to govern hills and mountains
	self.hillsFrac = Fractal.Create(self.iNumPlotsX, self.iNumPlotsY, grain, self.iFlags, self.fracXExp, self.fracYExp);
	self.mountainsFrac = Fractal.Create(self.iNumPlotsX, self.iNumPlotsY, grain, self.iFlags, self.fracXExp, self.fracYExp);
	self.hillsFrac:BuildRidges(numPlates, hills_ridge_flags, 1, 2);
	self.mountainsFrac:BuildRidges((numPlates * 2) / 3, peaks_ridge_flags, 6, 1);
	-- Get height values
	local iHillsBottom1 = self.hillsFrac:GetHeight(hillsBottom1);
	local iHillsTop1 = self.hillsFrac:GetHeight(hillsTop1);
	local iHillsBottom2 = self.hillsFrac:GetHeight(hillsBottom2);
	local iHillsTop2 = self.hillsFrac:GetHeight(hillsTop2);
	local iHillsNearMountains = self.mountainsFrac:GetHeight(hillsNearMountains);
	local iMountainThreshold = self.mountainsFrac:GetHeight(mountains);
	local iPassThreshold = self.hillsFrac:GetHeight(hillsNearMountains);

	-- Set Hills and Mountains
	for x = 0, self.iNumPlotsX - 1 do
		for y = 0, self.iNumPlotsY - 1 do
			local plot = Map.GetPlot(x, y);
			local mountainVal = self.mountainsFrac:GetHeight(x, y);
			local hillVal = self.hillsFrac:GetHeight(x, y);

			if plot:GetPlotType() ~= PlotTypes.PLOT_OCEAN then
				if mountainVal >= iMountainThreshold then
					if hillVal >= iPassThreshold then -- Mountain Pass though the ridgeline
						plot:SetPlotType(PlotTypes.PLOT_HILLS, false, false);
					else -- Mountain
						plot:SetPlotType(PlotTypes.PLOT_MOUNTAIN, false, false);
					end
				elseif mountainVal >= iHillsNearMountains then
					plot:SetPlotType(PlotTypes.PLOT_HILLS, false, false);
				elseif (hillVal >= iHillsBottom1 and hillVal <= iHillsTop1) or (hillVal >= iHillsBottom2 and hillVal <= iHillsTop2) then
					plot:SetPlotType(PlotTypes.PLOT_HILLS, false, false);
				end
			end
		end
	end
end
------------------------------------------------------------------------------

------------------------------------------------------------------------------
function GeneratePlotTypes()
	print("Generating Plot Types (Lua Frontier) ...");

	-- Obtain landmass type selected by user.
	local userInputLandmass = Map.GetCustomOption(6);
	if userInputLandmass == 3 then
		userInputLandmass = 1 + Map.Rand(2, "Random Landmass Type - Lua");
	end

	-- Implement landmass type.
	if userInputLandmass == 2 then -- Continents
		local fractal_world = ContinentsFractalWorld.Create();
		fractal_world:GeneratePlotTypes();
		GenerateCoasts();
	else -- Pangaea
		local fractal_world = PangaeaFractalWorld.Create();
		local plotTypes = fractal_world:GeneratePlotTypes();
		SetPlotTypes(plotTypes);
		GenerateCoasts();
	end
end
------------------------------------------------------------------------------

------------------------------------------------------------------------------
function GenerateTerrain()
	print("Generating Terrain (Lua Frontier) ...");

	-- Get Temperature setting input by user.
	local temp = Map.GetCustomOption(2);
	if temp == 4 then
		temp = 1 + Map.Rand(3, "Random Temperature - Lua");
	end

	local terraingen = TerrainGenerator.Create{temperature = temp};

	local terrainTypes = terraingen:GenerateTerrain();

	SetTerrainTypes(terrainTypes);
end
------------------------------------------------------------------------------
function AddFeatures()
	print("Adding Features (Lua Frontier) ...");

	-- Get Rainfall setting input by user.
	local rain = Map.GetCustomOption(3);
	if rain == 4 then
		rain = 1 + Map.Rand(3, "Random Rainfall - Lua");
	end

	local featuregen = FeatureGenerator.Create{rainfall = rain};

	-- False parameter removes mountains from coastlines.
	featuregen:AddFeatures(false);
end
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Start Plot System - Needs numerous overwrites to make this concept work.
------------------------------------------------------------------------------
function AssignStartingPlots:GetWorldLuxuryTargetNumbers()
	-- This data was separated out to allow easy replacement in map scripts.
	--
	-- The first number is the target for total luxuries in the world, NOT
	-- counting the one-per-civ "second type" added at start locations.
	--
	-- The second number affects minimum number of random luxuries placed.
	-- I say "affects" because it is only one part of the formula.
	local worldsizes = {};

	local luxDensity = self.luxuryDensity;

	if self.luxuryDensity == 4 then
		luxDensity = 1 + Map.Rand(3, "Luxury Resource Density");
	end

	if luxDensity == 1 then -- Sparse
		worldsizes = {
			[GameInfo.Worlds.WORLDSIZE_DUEL.ID] = {17, 3},
			[GameInfo.Worlds.WORLDSIZE_TINY.ID] = {30, 4},
			[GameInfo.Worlds.WORLDSIZE_SMALL.ID] = {42, 4},
			[GameInfo.Worlds.WORLDSIZE_STANDARD.ID] = {55, 5},
			[GameInfo.Worlds.WORLDSIZE_LARGE.ID] = {70, 5},
			[GameInfo.Worlds.WORLDSIZE_HUGE.ID] = {85, 6},
		};
	elseif luxDensity == 3 then -- Abundant
		worldsizes = {
			[GameInfo.Worlds.WORLDSIZE_DUEL.ID] = {30, 3},
			[GameInfo.Worlds.WORLDSIZE_TINY.ID] = {48, 4},
			[GameInfo.Worlds.WORLDSIZE_SMALL.ID] = {68, 4},
			[GameInfo.Worlds.WORLDSIZE_STANDARD.ID] = {90, 5},
			[GameInfo.Worlds.WORLDSIZE_LARGE.ID] = {120, 5},
			[GameInfo.Worlds.WORLDSIZE_HUGE.ID] = {150, 6},
		};
	else -- Standard
		worldsizes = {
			[GameInfo.Worlds.WORLDSIZE_DUEL.ID] = {22, 3},
			[GameInfo.Worlds.WORLDSIZE_TINY.ID] = {38, 4},
			[GameInfo.Worlds.WORLDSIZE_SMALL.ID] = {52, 4},
			[GameInfo.Worlds.WORLDSIZE_STANDARD.ID] = {70, 5},
			[GameInfo.Worlds.WORLDSIZE_LARGE.ID] = {88, 5},
			[GameInfo.Worlds.WORLDSIZE_HUGE.ID] = {110, 6},
		};
	end
	local world_size_data = worldsizes[Map.GetWorldSize()];
	return world_size_data;
end
------------------------------------------------------------------------------
function AssignStartingPlots:GetLowFertilityCompensations(iNumRegions)
	-- Extracted from PlaceLuxuries() for easy override
	local region_low_fert_compensation = table.fill(0, iNumRegions); -- Stores number of luxury compensation each region received
	local luxury_low_fert_compensation = table.fill(0, self.MAX_RESOURCE_INDEX); -- Stores number of times each resource ID had extras handed out at civ starts. WARNING: Don't use ID 0.

	-- Custom for Frontier
	for _, reg_data in ipairs(self.regions_sorted_by_type) do
		local region_number = reg_data[1];
		local this_region_luxury = reg_data[2];
		if self.regionData[region_number][8] < 2.5 then -- Low fertility per region rectangle plot, add a lux.
			-- print("-"); print("Region#", region_number, "has low rectangle fertility, giving it an extra Luxury at start plot.");
			luxury_low_fert_compensation[this_region_luxury] = luxury_low_fert_compensation[this_region_luxury] + 1;
			region_low_fert_compensation[region_number] = region_low_fert_compensation[region_number] + 1;
		end
		if self.regionData[region_number][6] / self.regionTerrainCounts[region_number][2] < 4 then -- Low fertility per land plot.
			-- print("-"); print("Region#", region_number, "has low per-plot fertility, giving it an extra Luxury at start plot.");
			luxury_low_fert_compensation[this_region_luxury] = luxury_low_fert_compensation[this_region_luxury] + 1;
			region_low_fert_compensation[region_number] = region_low_fert_compensation[region_number] + 1;
		end
	end

	return region_low_fert_compensation, luxury_low_fert_compensation;
end
------------------------------------------------------------------------------
function StartPlotSystem()
	-- Get Resources setting input by user.
	local res = Map.GetCustomOption(5);
	if res == 6 then
		res = 1 + Map.Rand(3, "Random Resources Option - Lua");
	end

	print("Creating start plot database.");
	local start_plot_database = AssignStartingPlots.Create();

	print("Dividing the map in to Regions.");
	start_plot_database:GenerateRegions{
		resources = res,
		addEmptyRegions = true,
	};

	print("Choosing start locations for civilizations.");
	start_plot_database:ChooseLocations();

	print("Normalizing start locations and assigning them to Players.");
	start_plot_database:BalanceAndAssign{iNumExtraRegions = start_plot_database.iNumFrontiers};

	print("Placing Natural Wonders.");
	start_plot_database:PlaceNaturalWonders();

	print("Placing Resources and City States.");
	start_plot_database:PlaceResourcesAndCityStates{iNumExtraRegions = start_plot_database.iNumFrontiers};
end
------------------------------------------------------------------------------
