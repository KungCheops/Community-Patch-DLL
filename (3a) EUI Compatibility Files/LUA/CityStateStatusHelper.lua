print("This is the modded CityStateStatusHelper from EUI - CBP- CSD")
------------------------------------------------------
-- CityStateStatusHelper.lua
-- Author: Anton Strenger
--
-- Consolidation of code associated with displaying
-- the friendship status of a player with a city-state
------------------------------------------------------
-- modified by bc1 from 1.0.3.144 brave new world & civ BE code
-- code is common using gk_mode, bnw_mode, and civ5_mode switches
------------------------------------------------------

local pairs = pairs
local print = print
local math_abs = math.abs
local math_min = math.min
local table_insert = table.insert
local table_concat = table.concat

local Game_GetReligionName = Game.GetReligionName
local Game_GetGameTurn = Game.GetGameTurn
local GameDefines = GameDefines
local MinorCivTraitTypes = MinorCivTraitTypes
local MinorCivQuestTypes = MinorCivQuestTypes
local L = Locale.ConvertTextKey
local Players = Players
local Teams = Teams

include( "EUI_utilities" )
local IconHookup = EUI.IconHookup
local GameInfo = EUI.GameInfoCache
GetGreatPersonQuestIconText = EUI.GreatPeopleIcon
local GetGreatPersonQuestIconText = GetGreatPersonQuestIconText

local gk_mode = type( Game_GetReligionName ) == "function"
local bnw_mode = type( Game.GetActiveLeague ) == "function"
local civ5_mode = type( MouseOverStrategicViewResource ) == "function"

local newLine = civ5_mode and "[NEWLINE]" or "/n"

local iEmbassy = GameInfoTypes.IMPROVEMENT_EMBASSY

--[[
local GetCityStateStatusRow = GetCityStateStatusRow
local GetCityStateStatusType = GetCityStateStatusType
local UpdateCityStateStatusBar = UpdateCityStateStatusBar
local UpdateCityStateStatusIconBG = UpdateCityStateStatusIconBG
local UpdateCityStateStatusUI = UpdateCityStateStatusUI
local GetCityStateStatusText = GetCityStateStatusText
local GetCityStateResourceExports = GetCityStateResourceExports
local GetCityStateBonuses = GetCityStateBonuses
local GetCityStateStatusToolTip = GetCityStateStatusToolTip
local GetAllyText = GetAllyText
local GetAllyToolTip = GetAllyToolTip
local GetActiveQuestText = GetActiveQuestText
local GetGreatPersonQuestIconText = GetGreatPersonQuestIconText
local GetActiveQuestToolTip = GetActiveQuestToolTip
local GetCityStateTraitText = GetCityStateTraitText
local GetCityStateTraitToolTip = GetCityStateTraitToolTip
local GetCityStateStatusAlly = GetCityStateStatusAlly
--]]

------------------------------------------------------
-- Global Constants
------------------------------------------------------
local kPosInfRange = math_abs( GameDefines.FRIENDSHIP_THRESHOLD_ALLIES - GameDefines.FRIENDSHIP_THRESHOLD_NEUTRAL )
local kNegInfRange = math_abs( GameDefines.MINOR_FRIENDSHIP_AT_WAR - GameDefines.FRIENDSHIP_THRESHOLD_NEUTRAL )
local kPosBarRange = 81
local kNegBarRange = 81
local kBarIconAtlas = "CITY_STATE_INFLUENCE_METER_ICON_ATLAS"
local kBarIconNeutralIndex = 4

local kMinorWar, kMinorAllies, kMinorFriends, kMinorAfraid, kMinorAngry, kMinorNeutral, ktQuestsDisplayOrder
local ktQuestsIcon = {
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_ROUTE or false ] = function() return "[ICON_CONNECTED]" end,
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_KILL_CAMP or false ] = function() return "[ICON_WAR]" end,
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_CONNECT_RESOURCE or false ] = function(i) local row = GameInfo.Resources[i] return row and row.IconString or "" end,
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_CONSTRUCT_WONDER ]	= function() return "[ICON_WONDER]" end,
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_GREAT_PERSON or false ] = function(i) return GetGreatPersonQuestIconText(i) end,
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_KILL_CITY_STATE or false ] = function() return "[ICON_IDEOLOGY_AUTOCRACY]" end,
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_FIND_PLAYER or false ] = function(i) return Players[i]:IsMinorCiv() and "[ICON_CITY_STATE]" or "[ICON_CAPITAL]" end,
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_FIND_NATURAL_WONDER or false ] = function() return "[ICON_HAPPINESS_1]" end,
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_GIVE_GOLD or false ] = function() return "[ICON_GOLD]" end,
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_PLEDGE_TO_PROTECT or false ] = function() return "[ICON_STRENGTH]" end,
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_CONTEST_CULTURE or false ] = function() return "[ICON_CULTURE]" end,
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_CONTEST_FAITH or false ] = function() return "[ICON_PEACE]" end,
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_CONTEST_TECHS or false ] = function() return "[ICON_RESEARCH]" end,
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_INVEST or false ] = function() return "[ICON_INVEST]" end,
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_BULLY_CITY_STATE or false ] = function() return "[ICON_PIRATE]" end,
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_DENOUNCE_MAJOR or false ] = function() return "[ICON_DENOUNCE]" end,
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_SPREAD_RELIGION or false ] = function(i) local row = GameInfo.Religions[i] return row and row.IconString or "" end,
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_TRADE_ROUTE or false ] = function() return "[ICON_INTERNATIONAL_TRADE]" end,
-- VP
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_FIND_CITY or false ] = function() return "[ICON_CAPITAL]" end,
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_WAR or false ] = function() return "[ICON_SILVER_FIST]" end,
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_CONSTRUCT_NATIONAL_WONDER or false ] = function() return "[ICON_TRADE_WHITE]" end,
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_GIFT_SPECIFIC_UNIT or false ] = function() return "[ICON_STRENGTH]" end,
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_FIND_CITY_STATE or false ] = function() return "[ICON_CITY_STATE]" end,
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_INFLUENCE or false ] = function() return "[ICON_INFLUENCE]" end,
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_CONTEST_TOURISM or false ] = function() return "[ICON_TOURISM]" end,
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_ARCHAEOLOGY or false ] = function() return "[ICON_RES_ARTIFACTS]" end,
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_CIRCUMNAVIGATION or false ] = function() return "[ICON_TURNS_REMAINING]" end,
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_LIBERATION or false ] = function() return "[ICON_OCCUPIED]" end,
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_HORDE or false ] = function() return "[ICON_HAPPINESS_3]" end,
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_REBELLION or false ] = function() return "[ICON_HAPPINESS_4]" end,
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_EXPLORE_AREA or false ] = function() return "[ICON_RANGE_STRENGTH]" end,
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_BUILD_X_BUILDINGS or false ] = function() return "[ICON_PRODUCTION]" end,
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_SPY_ON_MAJOR or false ] = function() return "[ICON_VIEW_CITY]" end,
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_COUP or false ] = function() return "[ICON_INQUISITOR]" end,
	[ MinorCivQuestTypes.MINOR_CIV_QUEST_ACQUIRE_CITY or false ] = function() return "[ICON_VICTORY_DOMINATION]" end,
-- END
} ktQuestsIcon[-1] = nil

if gk_mode then
	-- The order of precedence in which the quest icons and tooltip points are displayed
	ktQuestsDisplayOrder = {
		-- Global quests are first
		MinorCivQuestTypes.MINOR_CIV_QUEST_CONTEST_CULTURE or false,	-- g&k+
		MinorCivQuestTypes.MINOR_CIV_QUEST_CONTEST_FAITH or false,	-- g&k+
		MinorCivQuestTypes.MINOR_CIV_QUEST_CONTEST_TECHS or false,	-- g&k+
		MinorCivQuestTypes.MINOR_CIV_QUEST_INVEST or false,		-- g&k+
		MinorCivQuestTypes.MINOR_CIV_QUEST_CONTEST_TOURISM or false, -- VP
		MinorCivQuestTypes.MINOR_CIV_QUEST_INFLUENCE or false, -- VP
		MinorCivQuestTypes.MINOR_CIV_QUEST_KILL_CAMP or false,		-- vanilla+
		MinorCivQuestTypes.MINOR_CIV_QUEST_HORDE or false, -- VP
		MinorCivQuestTypes.MINOR_CIV_QUEST_REBELLION or false, -- VP
		-- Then personal support quests
		MinorCivQuestTypes.MINOR_CIV_QUEST_GIVE_GOLD or false,		-- g&k+
		MinorCivQuestTypes.MINOR_CIV_QUEST_PLEDGE_TO_PROTECT or false,	-- g&k+
		MinorCivQuestTypes.MINOR_CIV_QUEST_DENOUNCE_MAJOR or false,	-- g&k+
		MinorCivQuestTypes.MINOR_CIV_QUEST_WAR or false, -- VP
		MinorCivQuestTypes.MINOR_CIV_QUEST_LIBERATION or false, -- VP
		-- Then other personal quests
		MinorCivQuestTypes.MINOR_CIV_QUEST_EXPLORE_AREA or false,		-- VP
		MinorCivQuestTypes.MINOR_CIV_QUEST_BUILD_X_BUILDINGS or false,		-- VP
		MinorCivQuestTypes.MINOR_CIV_QUEST_SPY_ON_MAJOR or false,		-- VP
		MinorCivQuestTypes.MINOR_CIV_QUEST_COUP or false,		-- VP
		MinorCivQuestTypes.MINOR_CIV_QUEST_ACQUIRE_CITY or false,		-- VP
		MinorCivQuestTypes.MINOR_CIV_QUEST_TRADE_ROUTE or false,		-- bnw+
		MinorCivQuestTypes.MINOR_CIV_QUEST_SPREAD_RELIGION or false,	-- g&k+
		MinorCivQuestTypes.MINOR_CIV_QUEST_BULLY_CITY_STATE or false,	-- g&k+
		MinorCivQuestTypes.MINOR_CIV_QUEST_FIND_NATURAL_WONDER or false,	-- vanilla+ but NOT civBE
		MinorCivQuestTypes.MINOR_CIV_QUEST_FIND_PLAYER or false,		-- vanilla+
		MinorCivQuestTypes.MINOR_CIV_QUEST_FIND_CITY or false,			-- VP
		MinorCivQuestTypes.MINOR_CIV_QUEST_KILL_CITY_STATE or false,	-- vanilla+
		MinorCivQuestTypes.MINOR_CIV_QUEST_FIND_CITY_STATE or false, -- VP
		MinorCivQuestTypes.MINOR_CIV_QUEST_GREAT_PERSON or false,	-- vanilla+
		MinorCivQuestTypes.MINOR_CIV_QUEST_CONSTRUCT_WONDER or false,	-- vanilla+
		MinorCivQuestTypes.MINOR_CIV_QUEST_CONNECT_RESOURCE or false,	-- vanilla+
		MinorCivQuestTypes.MINOR_CIV_QUEST_ROUTE or false,		-- vanilla+
		MinorCivQuestTypes.MINOR_CIV_QUEST_CONSTRUCT_NATIONAL_WONDER, -- VP
		MinorCivQuestTypes.MINOR_CIV_QUEST_GIFT_SPECIFIC_UNIT, -- VP
		MinorCivQuestTypes.MINOR_CIV_QUEST_ARCHAEOLOGY or false, -- VP
		MinorCivQuestTypes.MINOR_CIV_QUEST_CIRCUMNAVIGATION or false, -- VP
	}
	kMinorWar = GameInfo.MinorCivTraits_Status.MINOR_FRIENDSHIP_STATUS_WAR
	kMinorAllies = GameInfo.MinorCivTraits_Status.MINOR_FRIENDSHIP_STATUS_ALLIES
	kMinorFriends = GameInfo.MinorCivTraits_Status.MINOR_FRIENDSHIP_STATUS_FRIENDS
	kMinorAfraid = GameInfo.MinorCivTraits_Status.MINOR_FRIENDSHIP_STATUS_AFRAID
	kMinorAngry = GameInfo.MinorCivTraits_Status.MINOR_FRIENDSHIP_STATUS_ANGRY
	kMinorNeutral = GameInfo.MinorCivTraits_Status.MINOR_FRIENDSHIP_STATUS_NEUTRAL
else
	kMinorWar = GameInfo.MinorCivTraits_Status.MINOR_FRIENDSHIP_AT_WAR
	kMinorAllies = GameInfo.MinorCivTraits_Status.FRIENDSHIP_THRESHOLD_ALLIES
	kMinorFriends = GameInfo.MinorCivTraits_Status.FRIENDSHIP_THRESHOLD_FRIENDS
	kMinorAfraid = GameInfo.MinorCivTraits_Status.FRIENDSHIP_THRESHOLD_NEUTRAL
	kMinorAngry = GameInfo.MinorCivTraits_Status.MINOR_FRIENDSHIP_AT_WAR
	kMinorNeutral = GameInfo.MinorCivTraits_Status.FRIENDSHIP_THRESHOLD_NEUTRAL
end

------------------------------------------------------

function GetCityStateStatusRow( majorPlayerID, minorPlayerID )
	local majorPlayer = Players[majorPlayerID]
	local minorPlayer = Players[minorPlayerID]

	if majorPlayer and minorPlayer then

		-- War
		if Teams[majorPlayer:GetTeam()]:IsAtWar(minorPlayer:GetTeam()) then
			return kMinorWar

		-- Allies
		elseif minorPlayer:IsAllies(majorPlayerID) then
			return kMinorAllies

		-- Friends
		elseif minorPlayer:IsFriends(majorPlayerID) then
			return kMinorFriends

		-- Able to bully?
		elseif gk_mode and minorPlayer:CanMajorBullyGold(majorPlayerID) then
			return kMinorAfraid

		-- Angry
		elseif minorPlayer:GetMinorCivFriendshipWithMajor(majorPlayerID) < GameDefines.FRIENDSHIP_THRESHOLD_NEUTRAL then
			return kMinorAngry

		-- Neutral
		else
			return kMinorNeutral
		end

	else
		print("Lua error - invalid player index")
	end
end

function GetCityStateStatusType(majorPlayerID, minorPlayerID)
	local row = GetCityStateStatusRow(majorPlayerID, minorPlayerID)
	return row and row.Type
end

function UpdateCityStateStatusBar(majorPlayerID, minorPlayerID, posBarCtrl, negBarCtrl, barMarkerCtrl)
	local majorPlayer = Players[majorPlayerID]
	local minorPlayer = Players[minorPlayerID]

	if majorPlayer and minorPlayer then

		local info = GetCityStateStatusRow(majorPlayerID, minorPlayerID)
		local iInf = minorPlayer:GetMinorCivFriendshipWithMajor(majorPlayerID)

		if iInf >= 0 then
			local percentFull = math_abs(iInf) / kPosInfRange
			local xOffset = math_min(percentFull * kPosBarRange, kPosBarRange)
			barMarkerCtrl:SetOffsetX(xOffset)
			if gk_mode and info and info.PositiveStatusMeter then
				posBarCtrl:SetTexture(info.PositiveStatusMeter)
			end
			posBarCtrl:SetPercent(percentFull)
			posBarCtrl:SetHide(false)
			negBarCtrl:SetHide(true)
		else
			local percentFull = math_abs(iInf) / kNegInfRange
			local xOffset = - math_min(percentFull * kNegBarRange, kNegBarRange)
			barMarkerCtrl:SetOffsetX(xOffset)
			if gk_mode and info and info.NegativeStatusMeter then
				negBarCtrl:SetTexture(info.NegativeStatusMeter)
			end
			negBarCtrl:SetPercent(percentFull)
			negBarCtrl:SetHide(false)
			posBarCtrl:SetHide(true)
		end

		if gk_mode then
			-- Bubble icon for meter
			local size = barMarkerCtrl:GetSize().x
			-- Special case when INF = 0
			if iInf == 0 then
				IconHookup(kBarIconNeutralIndex, size, kBarIconAtlas, barMarkerCtrl)
			elseif info and info.StatusMeterIconAtlasIndex then
				IconHookup(info.StatusMeterIconAtlasIndex, size, kBarIconAtlas, barMarkerCtrl)
			end
		end
	else
		print("Lua error - invalid player index")
	end
end

function UpdateCityStateStatusIconBG(majorPlayerID, minorPlayerID, iconBGCtrl)
	local row = GetCityStateStatusRow(majorPlayerID, minorPlayerID)

	if row and row.StatusIcon then
		iconBGCtrl:SetTexture( row.StatusIcon )
	end
end

function UpdateCityStateStatusUI(majorPlayerID, minorPlayerID, posBarCtrl, negBarCtrl, barMarkerCtrl, iconBGCtrl)
	UpdateCityStateStatusBar(majorPlayerID, minorPlayerID, posBarCtrl, negBarCtrl, barMarkerCtrl)
	UpdateCityStateStatusIconBG(majorPlayerID, minorPlayerID, iconBGCtrl)
end

function GetCityStateStatusText( majorPlayerID, minorPlayerID )
	local majorPlayer = Players[majorPlayerID]
	local minorPlayer = Players[minorPlayerID]
	local strStatusText = ""

	if majorPlayer and minorPlayer then

		local majorTeamID = majorPlayer:GetTeam()
		local minorTeamID = minorPlayer:GetTeam()
		local majorTeam = Teams[majorTeamID]

		local isAtWar = majorTeam:IsAtWar(minorTeamID)
		local majorInfluenceWithMinor = minorPlayer:GetMinorCivFriendshipWithMajor(majorPlayerID)

		-- Status

		if minorPlayer:IsAllies(majorPlayerID) then			-- Allies
			strStatusText = "[COLOR_CYAN]" .. L("TXT_KEY_ALLIES")

		elseif minorPlayer:IsFriends(majorPlayerID) then		-- Friends
			strStatusText = "[COLOR_POSITIVE_TEXT]" .. L("TXT_KEY_FRIENDS")

		elseif minorPlayer:IsMinorPermanentWar(majorTeamID) then	-- Permanent War
			strStatusText = "[COLOR_NEGATIVE_TEXT]" .. L("TXT_KEY_PERMANENT_WAR")

		elseif minorPlayer:IsAllyAtWar(majorTeamID) then		-- Peace blocked by being at war with ally
			strStatusText = "[COLOR_NEGATIVE_TEXT]" .. L("TXT_KEY_PEACE_BLOCKED")

		elseif minorPlayer:GetPeaceBlockedTurns(majorTeamID) > 0 then	-- Peace blocked due to attacking too recently
			strStatusText = "[COLOR_NEGATIVE_TEXT]" .. L("TXT_KEY_PEACE_BLOCKED_TURNS", minorPlayer:GetPeaceBlockedTurns(majorTeamID))

		elseif minorPlayer:IsPeaceBlocked(majorTeamID) then		-- Can't make peace for some other reason
			strStatusText = "[COLOR_NEGATIVE_TEXT]" .. L("TXT_KEY_PEACE_BLOCKED")

		elseif isAtWar then		-- War
			strStatusText = "[COLOR_NEGATIVE_TEXT]" .. L("TXT_KEY_WAR")

		elseif majorInfluenceWithMinor < GameDefines.FRIENDSHIP_THRESHOLD_NEUTRAL then
			-- Afraid
			if gk_mode and minorPlayer:CanMajorBullyGold(majorPlayerID) then
				strStatusText = "[COLOR_PLAYER_LIGHT_ORANGE_TEXT]"..L("TXT_KEY_AFRAID").."[ENDCOLOR]"
			-- Angry
			else
				strStatusText = "[COLOR_MAGENTA]"..L("TXT_KEY_ANGRY")
			end

		else		-- Neutral
			strStatusText = "[COLOR_WHITE]" .. L("TXT_KEY_NEUTRAL_CSTATE")
		end
		strStatusText = strStatusText .. "[ENDCOLOR]"
		if not isAtWar then
			strStatusText = strStatusText .. " " .. majorInfluenceWithMinor .. "[ICON_INFLUENCE]"
			if not gk_mode and majorInfluenceWithMinor ~= 0 then
				strStatusText = strStatusText .. (" (%+g[ICON_INFLUENCE] / "):format(minorPlayer:GetFriendshipChangePerTurnTimes100(majorPlayerID) / 100).. L"TXT_KEY_DO_TURN" .. ")" --"TXT_KEY_CITY_STATE_TITLE_TOOL_TIP_CURRENT"
			end
		end
	else
		print("Lua error - invalid player index")
	end

	return strStatusText
end

function GetCityStateResourceExports( minorPlayer )
	-- Resources
	local resourceExports = {}

	if minorPlayer and minorPlayer.GetResourceExport then
		for resource in GameInfo.Resources() do
			if resource.ResourceClassType ~= "RESOURCECLASS_BONUS" then
				local resourceExport = minorPlayer:GetResourceExport(resource.ID)
				if resourceExport > 0 then
					table_insert( resourceExports, "[COLOR_POSITIVE_TEXT]" .. resourceExport .. resource.IconString .. "[ENDCOLOR] " .. L(resource.Description) )
				end
			end
		end
	end
	return table_concat( resourceExports, ", ")
end

function GetCityStateBonuses( majorPlayerID, minorPlayerID )
	local tips = {}
	local minorPlayer = Players[minorPlayerID]

	if minorPlayer then

		local capitalFoodBonus = minorPlayer:GetCurrentCapitalFoodBonus(majorPlayerID) / 100
		local otherCityFoodBonus = minorPlayer:GetCurrentOtherCityFoodBonus(majorPlayerID) / 100
		if capitalFoodBonus ~= 0 or otherCityFoodBonus ~= 0 then
			table_insert( tips, L("TXT_KEY_CSTATE_FOOD_BONUS", capitalFoodBonus, otherCityFoodBonus) )
		end

		local unitSpawnEstimate = minorPlayer:GetCurrentSpawnEstimate(majorPlayerID)
		local unitSpawnExact = minorPlayer:GetUnitSpawnCounter(majorPlayerID)
		if (unitSpawnEstimate ~= 0 and not minorPlayer:IsMinorCivUnitSpawningDisabled(majorPlayerID)) then
			table_insert( tips, L("TXT_KEY_CSTATE_MILITARY_BONUS", unitSpawnEstimate, unitSpawnExact) )
		end

		local scienceBonusTimes100 = minorPlayer:GetCurrentScienceFriendshipBonusTimes100(majorPlayerID)
		if scienceBonusTimes100 ~= 0 then
			table_insert( tips, L("TXT_KEY_CSTATE_SCIENCE_BONUS", scienceBonusTimes100 / 100) )
		end

		if gk_mode then
			local cultureBonus = minorPlayer:GetMinorCivCurrentCultureBonus(majorPlayerID)
			if cultureBonus ~= 0 then
				table_insert( tips, L("TXT_KEY_CSTATE_CULTURE_BONUS", cultureBonus) )
			end

			local happinessBonus = civ5_mode and minorPlayer:GetMinorCivCurrentHappinessBonus(majorPlayerID) or minorPlayer:GetMinorCivCurrentHealthBonus(majorPlayerID)
			if happinessBonus ~= 0 then
				table_insert( tips, L(civ5_mode and "TXT_KEY_CSTATE_HAPPINESS_BONUS" or "TXT_KEY_CSTATE_HEALTH_BONUS", happinessBonus) )
			end

			local faithBonus = minorPlayer:GetMinorCivCurrentFaithBonus(majorPlayerID)
			if faithBonus ~= 0 then
				table_insert( tips,  L("TXT_KEY_CSTATE_FAITH_BONUS", faithBonus) )
			end

			--CBP
			local goldBonus = minorPlayer:GetMinorCivCurrentGoldBonus(majorPlayerID)
			if goldBonus ~= 0 then
				table_insert( tips,  L("TXT_KEY_CSTATE_GOLD_BONUS", goldBonus) )
			end
			local scienceBonus = minorPlayer:GetMinorCivCurrentScienceBonus(majorPlayerID)
			if scienceBonus ~= 0 then
				table_insert( tips,  L("TXT_KEY_CSTATE_SCIENCE_BONUS", scienceBonus) )
			end
		else
			local cultureBonus = minorPlayer:GetCurrentCultureBonus(majorPlayerID);
			if cultureBonus ~= 0 then
				table_insert( tips, L("TXT_KEY_CSTATE_CULTURE_BONUS", cultureBonus) )
			end
		end

		-- Resources
		local resourceExports = GetCityStateResourceExports( minorPlayer )

		if minorPlayer:IsAllies(majorPlayerID) and #resourceExports > 0 then

			table_insert( tips, L( "TXT_KEY_CSTATE_RESOURCES_RECEIVED", resourceExports ) )
		end
	end
	return tips
end

function GetCityStateStatusToolTip( majorPlayerID, minorPlayerID, isFullInfo )
	local majorPlayer = Players[majorPlayerID]
	local minorPlayer = Players[minorPlayerID]
	local tips = {}

	if majorPlayer and minorPlayer then

		local majorTeamID = majorPlayer:GetTeam()
		local minorTeamID = minorPlayer:GetTeam()
		local majorTeam = Teams[majorTeamID]
		local minorTeam = Teams[minorTeamID]

		local strShortDesc = minorPlayer:GetCivilizationShortDescription()
		local influenceAccumulated = minorPlayer:GetMinorCivFriendshipWithMajor(majorPlayerID)

		-- Name
		local tip = strShortDesc
		-- Resources
		for resource in GameInfo.Resources() do
			if resource.ResourceClassType ~= "RESOURCECLASS_BONUS" then
				local resourceForExport = minorPlayer:GetResourceExport(resource.ID)
							+ minorPlayer:GetNumResourceAvailable(resource.ID, false)
				if resourceForExport > 0 then
					tip = tip .. " " .. resourceForExport .. resource.IconString
				end
			end
		end
		-- Status
		tip = tip .. " " .. GetCityStateStatusText( majorPlayerID, minorPlayerID )
		table_insert( tips, tip )
		if minorPlayer:GetImprovementCount(iEmbassy) > 0 then
			table_insert( tips, L"TXT_KEY_CSTATE_CANNOT_EMBASSY")
		else
			table_insert( tips, L"TXT_KEY_CSTATE_CAN_EMBASSY")
		end
		-- Influence change
		if gk_mode then
			local influenceAnchor = minorPlayer:GetMinorCivFriendshipAnchorWithMajor(majorPlayerID)
			if influenceAccumulated ~= influenceAnchor then
				table_insert( tips, L( "TXT_KEY_CSTATE_INFLUENCE_RATE", minorPlayer:GetFriendshipChangePerTurnTimes100(majorPlayerID) / 100, influenceAnchor ) )
			end
			--Protect
			if minorPlayer:CanMajorStartProtection(majorPlayerID) then
				table_insert( tips, L"TXT_KEY_CSTATE_CAN_PROTECT" )
			end
			-- Bullying
			if minorPlayer:CanMajorBullyGold(majorPlayerID) then
				table_insert( tips, L("TXT_KEY_CSTATE_CAN_BULLY", minorPlayer:GetMajorBullyValue(majorPlayerID)) )
			else
				table_insert( tips, L("TXT_KEY_CSTATE_CANNOT_BULLY", minorPlayer:GetMajorBullyValue(majorPlayerID)) )
			end
		end

		local iJerkTurnsRemaining = minorPlayer:GetJerkTurnsRemaining(majorPlayerID);
		if (iJerkTurnsRemaining > 0) then
			table_insert( tips, L("TXT_KEY_CSTATE_JERK_STATUS", iJerkTurnsRemaining))
		end

		if isFullInfo then
			-- Bonuses
			local bonuses = GetCityStateBonuses( majorPlayerID, minorPlayerID )
			if #bonuses > 0 then
				table_insert( tips, table_concat( bonuses, newLine ) )
			end

			-- Protected by anyone?
			local protectors={}
			for playerID = 0, GameDefines.MAX_MAJOR_CIVS-1 do
				local player = Players[playerID]
				if player
					and player:IsAlive()
					and majorTeam:IsHasMet(player:GetTeam())
					and player:IsProtectingMinor(minorPlayerID)
				then
					table_insert( protectors, player:GetCivilizationShortDescription() )
				end
			end
			if #protectors > 0 then
				table_insert( tips, L"TXT_KEY_POP_CSTATE_PLEDGE_TO_PROTECT" .. ": " .. table_concat(protectors, ", ") )
			end

			-- At war with anyone ?
			local wars={}
			for playerID = 0, GameDefines.MAX_CIV_PLAYERS - 1 do
				local player = Players[playerID]
				if player
					and playerID ~= minorPlayerID
					and player:IsAlive()
					and majorTeam:IsHasMet(player:GetTeam())
					and minorTeam:IsAtWar(player:GetTeam())
				then
					table_insert( wars, player:GetCivilizationShortDescription() )
				end
			end
			if #wars > 0 then
				table_insert( tips, L("TXT_KEY_AT_WAR_WITH", table_concat(wars, ", ") ) )
			end

		end
	else
		print("Lua error - invalid player index")
	end

	return table_concat( tips, newLine )
end
function GetAllyText( majorPlayerID, minorPlayerID )

	local majorPlayer = Players[ majorPlayerID ]
	local minorPlayer = Players[ minorPlayerID ]

	if majorPlayer and minorPlayer then
		local allyID = minorPlayer:GetAlly()
		local ally = Players[ allyID ]
		-- Has an ally
		if ally then
			-- Not us
			if allyID ~= majorPlayerID then
				-- Someone we know
				if Teams[majorPlayer:GetTeam()]:IsHasMet( ally:GetTeam() ) then
					return L( ally:GetCivilizationShortDescriptionKey() )
				-- Someone we haven't met
				else
					return L"TXT_KEY_UNMET_PLAYER"
				end
			-- Us
			else
				return "[COLOR_POSITIVE_TEXT]" .. L"TXT_KEY_YOU" .. "[ENDCOLOR]"
			end
		-- No ally
		else
			return L"TXT_KEY_CITY_STATE_NOBODY"
		end
	end

	return ""
end

function GetAllyToolTip( majorPlayerID, minorPlayerID )
	local toolTip = ""

	local majorPlayer = Players[majorPlayerID]
	local minorPlayer = Players[minorPlayerID]
	if majorPlayer and minorPlayer then
		local minorCivFriendshipWithMajor = minorPlayer:GetMinorCivFriendshipWithMajor(majorPlayerID)
		local allyID = minorPlayer:GetAlly()
		local ally = Players[allyID]
		-- Has an ally
		if ally then
			local minorCivFriendshipWithAlly = minorPlayer:GetMinorCivFriendshipWithMajor(allyID)
			-- Not us
			if allyID ~= majorPlayerID then
				-- Someone we know
				local influenceUntilAllied = minorCivFriendshipWithAlly - minorCivFriendshipWithMajor + 1	-- needs to pass up the current ally, not just match
				--CBP
				if(minorPlayer:GetPermanentAlly() == allyID) then
					toolTip = L("TXT_KEY_CITY_STATE_PERMANENT_ALLY_TT", Players[allyID]:GetCivilizationShortDescriptionKey())
				elseif Teams[majorPlayer:GetTeam()]:IsHasMet(ally:GetTeam()) then
					toolTip = L("TXT_KEY_CITY_STATE_ALLY_TT", Players[allyID]:GetCivilizationShortDescription(), influenceUntilAllied)
				-- Someone we haven't met
				else
					toolTip = L("TXT_KEY_CITY_STATE_ALLY_UNKNOWN_TT", influenceUntilAllied)
				end
				-- Remove Firaxis' tedious drone blurb
				return toolTip:sub(1,(toolTip:find("[NEWLINE]",1,true) or 999)-1)

			-- Us
			else
				toolTip = L("TXT_KEY_CITY_STATE_RELATIONSHIP_ALLIES")
				-- Bonuses
				local bonuses = GetCityStateBonuses( majorPlayerID, minorPlayerID )
				if #bonuses > 0 then
					toolTip = toolTip .. " " .. table_concat( bonuses, " " )
				end
			end
		-- No ally
		-- CBP
		elseif(minorPlayer:IsNoAlly()) then
			toolTip = L("TXT_KEY_CITY_STATE_ALLY_NOBODY_PERMA")
		else
			local influenceUntilAllied = GameDefines.FRIENDSHIP_THRESHOLD_ALLIES - minorCivFriendshipWithMajor
			if gk_mode then
				toolTip = L( "TXT_KEY_CITY_STATE_ALLY_NOBODY_TT", influenceUntilAllied )
			else
				toolTip = L("TXT_KEY_CITY_STATE_TITLE_TOOL_TIP_ALLIES", influenceUntilAllied, minorPlayer:GetCivilizationShortDescription() )
			end
		end
	end

	return toolTip
end


-- Vox Populi contender info
function GetContenderInfo(majorPlayerID, minorPlayerID)
	local pMinor = Players[ minorPlayerID ]
	if not pMinor then return "error" end
	
	local iContInfluence = 0
	local iContender = -1
	local eAllyID = pMinor:GetAlly()
	
	for ePlayer = 0, GameDefines.MAX_MAJOR_CIVS - 1 do
		if ePlayer ~= eAllyID then
			local iInfluence = pMinor:GetMinorCivFriendshipWithMajor(ePlayer)
			if iInfluence > iContInfluence then iContInfluence = iInfluence; iContender = ePlayer end
		end
	end
	--How convenient the AI knows you are gathering influence but you don't? Let's add this.
	if iContender > -1 and iContender ~= majorPlayerID then
		if Teams[Players[majorPlayerID]:GetTeam()]:IsHasMet(Players[iContender]:GetTeam()) then 
			return tostring(iContInfluence).."[ICON_INFLUENCE] "..Players[iContender]:GetCivilizationShortDescription();
		else
			return tostring(iContInfluence).."[ICON_INFLUENCE] " .. L("TXT_KEY_POP_VOTE_RESULTS_UNMET_PLAYER");
		end
	end
	return tostring(iContInfluence).."[ICON_INFLUENCE]"
end

function GetContenderInfoTT(majorPlayerID, minorPlayerID)
	local pMinor = Players[ minorPlayerID ]
	if not pMinor then return "error" end
	
	local sAnchorInfluence = ""
	local iHighestInfluence = 0
	local influencetips = {}
	
	for ePlayer = 0, GameDefines.MAX_MAJOR_CIVS - 1 do
		if Players[ePlayer]:IsEverAlive() then
			local iInfluence = pMinor:GetMinorCivFriendshipAnchorWithMajor(ePlayer)
			if iInfluence ~= 0 then
				influencetips["PlayerID" .. ePlayer] = iInfluence
			end
		else
			influencetips["PlayerID" .. ePlayer] = 0
		end
	end
	
	local sortedinfluencetips = {}
	for k, v in pairs(influencetips) do table.insert(sortedinfluencetips,{k,v}) end
	table.sort(sortedinfluencetips, function(a,b) return a[2] < b[2] end)
	
	for _, v in ipairs(sortedinfluencetips) do
		if Teams[Players[majorPlayerID]:GetTeam()]:IsHasMet(Players[tonumber(v[1].sub(v[1], 9))]:GetTeam()) then
			if Players[tonumber(v[1].sub(v[1], 9))]:IsAlive() then
				sAnchorInfluence = "[NEWLINE][ICON_BULLET]" .. Players[tonumber(v[1].sub(v[1], 9))]:GetCivilizationShortDescription() .. ": " .. v[2] .. " " .. L("TXT_KEY_VP_RESTING_INFLUENCE") .. sAnchorInfluence
			else
				sAnchorInfluence = "[NEWLINE][ICON_BULLET][COLOR_GREY]" .. Players[tonumber(v[1].sub(v[1], 9))]:GetCivilizationShortDescription() .. ": " .. v[2] .. " " .. L("TXT_KEY_VP_RESTING_INFLUENCE") .. sAnchorInfluence
			end
		end
	end
	
	if sAnchorInfluence == "" then return L("TXT_KEY_POP_CSTATE_LABEL_CONTENDER_TT_HEADER2", pMinor:GetName()) end
	return L("TXT_KEY_POP_CSTATE_LABEL_CONTENDER_TT_HEADER", pMinor:GetName()) .. sAnchorInfluence
end


local isMinorCivQuestForPlayer
if gk_mode then
	if bnw_mode then
		isMinorCivQuestForPlayer = Players[1].IsMinorCivDisplayedQuestForPlayer
	else
		isMinorCivQuestForPlayer = Players[1].IsMinorCivActiveQuestForPlayer
	end
	
	function HasActivePersonalQuestText(majorPlayerID, minorPlayerID)
		local minorPlayer = Players[minorPlayerID]
		
		if minorPlayer then
			for _, questID in pairs(ktQuestsDisplayOrder) do
				if isMinorCivQuestForPlayer( minorPlayer, majorPlayerID, questID ) then
					if minorPlayer:IsPersonalQuest(questID) then
						return true
					end
				end
			end
		end
		
		return false
	end
	
	function GetActiveQuestText(majorPlayerID, minorPlayerID)
		local minorPlayer = Players[minorPlayerID]
		local sIconText = ""
		
		local sIconTextQuestGlobal = ""
		local sIconTextQuestPersonal = ""
		local sIconTextOther = ""

		if minorPlayer then
			for _, questID in pairs(ktQuestsDisplayOrder) do
				if isMinorCivQuestForPlayer( minorPlayer, majorPlayerID, questID ) then
					if minorPlayer:IsGlobalQuest(questID) then
						sIconTextQuestGlobal = sIconTextQuestGlobal .. ktQuestsIcon[questID]( minorPlayer:GetQuestData1(majorPlayerID, questID) )
					end
					
					if minorPlayer:IsPersonalQuest(questID) then
						sIconTextQuestPersonal = sIconTextQuestPersonal .. ktQuestsIcon[questID]( minorPlayer:GetQuestData1(majorPlayerID, questID) )
					end
				end
			end

			-- Threatening Barbarians event
			if minorPlayer:IsThreateningBarbariansEventActiveForPlayer(majorPlayerID) then
				sIconTextOther = sIconTextOther .. "[ICON_RAZING]"
			end

			-- Proxy War event
			if bnw_mode and minorPlayer:IsProxyWarActiveForMajor(majorPlayerID) then
				sIconTextOther = sIconTextOther .. "[ICON_RESISTANCE]"
			end
		
			-- CBP
			-- Denied Quest Influence
			if minorPlayer:IsQuestInfluenceDisabled(majorPlayerID) then
				sIconTextOther = sIconTextOther .. "[ICON_NOINFLUENCE]"
			end
			
			-- Married
			if bnw_mode and minorPlayer:IsMarried(majorPlayerID) then
				sIconTextOther = sIconTextOther .. "[ICON_RES_MARRIAGE]"
			end
			-- END
		else
			print("Lua error - invalid player index")
		end
		
		-- text
		local bHasGlobalQuests = sIconTextQuestGlobal ~= ""
		local bHasPersonalQuests = sIconTextQuestPersonal ~= ""
		local bHasOther = sIconTextOther ~= ""
		
		if bHasGlobalQuests then
			sIconText = sIconText .. sIconTextQuestGlobal
		end
		
		if bHasPersonalQuests then
			if sIconText ~= "" then
				sIconText = sIconText .. "  "
			end
			
			sIconText = sIconText .. sIconTextQuestPersonal
		end
		
		if bHasOther then
			if sIconText ~= "" then
				sIconText = sIconText .. "  "
			end
			
			sIconText = sIconText .. sIconTextOther
		end
		
		-- additional functions (allies, spies)
		local bMinorHasAlly = minorPlayer:GetAlly() ~= -1	
		local bMinorHasSpy = false
		local majorPlayer = Players[majorPlayerID]
		
		for _, s in ipairs( majorPlayer:GetEspionageSpies() ) do
			local plot = Map.GetPlot( s.CityX, s.CityY )
			local city = plot and plot:GetPlotCity()
			if city and city:GetOwner() == minorPlayerID then
				bMinorHasSpy = true
				break
			end
		end
		
		if (bMinorHasSpy or bMinorHasAlly) and not bHasOther then
			sIconText = sIconText .. " "
		end
		
		return sIconText
	end
else
	function GetActiveQuestText(majorPlayerID, minorPlayerID)

		local minorPlayer = Players[minorPlayerID]

		if minorPlayer then
			local questID = minorPlayer:GetActiveQuestForPlayer(majorPlayerID)
			local questIcon = questID and ktQuestsIcon[questID]
			if questIcon then
				return questIcon( minorPlayer:GetQuestData1(majorPlayerID) )
			end
		else
			print("Lua error - invalid player index")
		end
		return ""
	end
end

local function QuestString(majorPlayerID, minorPlayer, questID, questData1, questData2)
	if questID == MinorCivQuestTypes.MINOR_CIV_QUEST_ROUTE then
		return L( "TXT_KEY_CITY_STATE_QUEST_ROUTE_FORMAL" )
	elseif questID == MinorCivQuestTypes.MINOR_CIV_QUEST_KILL_CAMP then
		return L( "TXT_KEY_CITY_STATE_QUEST_KILL_CAMP_FORMAL" )
	elseif questID == MinorCivQuestTypes.MINOR_CIV_QUEST_CONNECT_RESOURCE then
		return L( "TXT_KEY_CITY_STATE_QUEST_CONNECT_RESOURCE_FORMAL", GameInfo.Resources[questData1].Description )
	elseif questID == MinorCivQuestTypes.MINOR_CIV_QUEST_CONSTRUCT_WONDER then
		return L( "TXT_KEY_CITY_STATE_QUEST_CONSTRUCT_WONDER_FORMAL", GameInfo.Buildings[questData1].Description )
	elseif questID == MinorCivQuestTypes.MINOR_CIV_QUEST_GREAT_PERSON then
		return L( "TXT_KEY_CITY_STATE_QUEST_GREAT_PERSON_FORMAL", GameInfo.Units[questData1].Description )
	elseif questID == MinorCivQuestTypes.MINOR_CIV_QUEST_KILL_CITY_STATE then
		return L( "TXT_KEY_CITY_STATE_QUEST_KILL_CITY_STATE_FORMAL", Players[questData1]:GetNameKey() )
	elseif questID == MinorCivQuestTypes.MINOR_CIV_QUEST_FIND_PLAYER then
		return L( "TXT_KEY_CITY_STATE_QUEST_FIND_PLAYER_FORMAL", Players[questData1]:GetCivilizationShortDescriptionKey() )
	elseif questID == MinorCivQuestTypes.MINOR_CIV_QUEST_FIND_CITY then
		return L( "TXT_KEY_CITY_STATE_QUEST_FIND_CITY_FORMAL", minorPlayer:GetTargetCityString(majorPlayerID , questID ))
	elseif civ5_mode and questID == MinorCivQuestTypes.MINOR_CIV_QUEST_FIND_NATURAL_WONDER then
		return L( "TXT_KEY_CITY_STATE_QUEST_FIND_NATURAL_WONDER_FORMAL" )
	elseif gk_mode then
		if questID == MinorCivQuestTypes.MINOR_CIV_QUEST_GIVE_GOLD then
			return L( "TXT_KEY_CITY_STATE_QUEST_GIVE_GOLD_FORMAL", Players[questData1]:GetCivilizationShortDescriptionKey() )
		elseif questID == MinorCivQuestTypes.MINOR_CIV_QUEST_PLEDGE_TO_PROTECT then
			return L( "TXT_KEY_CITY_STATE_QUEST_PLEDGE_TO_PROTECT_FORMAL", Players[questData1]:GetCivilizationShortDescriptionKey() )
		elseif questID == MinorCivQuestTypes.MINOR_CIV_QUEST_CONTEST_CULTURE then
			local iLeaderScore = minorPlayer:GetMinorCivContestValueForLeader(questID)
			local iMajorScore = minorPlayer:GetMinorCivContestValueForPlayer(majorPlayerID, questID)
			if minorPlayer:IsMinorCivContestLeader(majorPlayerID, questID) then
				return L( "TXT_KEY_CITY_STATE_QUEST_CONTEST_CULTURE_WINNING_FORMAL", iMajorScore )
			else
				return L( "TXT_KEY_CITY_STATE_QUEST_CONTEST_CULTURE_LOSING_FORMAL", iLeaderScore, iMajorScore )
			end
		elseif questID == MinorCivQuestTypes.MINOR_CIV_QUEST_CONTEST_FAITH then
			local iLeaderScore = minorPlayer:GetMinorCivContestValueForLeader(questID)
			local iMajorScore = minorPlayer:GetMinorCivContestValueForPlayer(majorPlayerID, questID)
			if minorPlayer:IsMinorCivContestLeader(majorPlayerID, questID) then
				return L( "TXT_KEY_CITY_STATE_QUEST_CONTEST_FAITH_WINNING_FORMAL", iMajorScore )
			else
				return L( "TXT_KEY_CITY_STATE_QUEST_CONTEST_FAITH_LOSING_FORMAL", iLeaderScore, iMajorScore )
			end
		elseif questID == MinorCivQuestTypes.MINOR_CIV_QUEST_CONTEST_TECHS then
			local iLeaderScore = minorPlayer:GetMinorCivContestValueForLeader(questID)
			local iMajorScore = minorPlayer:GetMinorCivContestValueForPlayer(majorPlayerID, questID)
			if minorPlayer:IsMinorCivContestLeader(majorPlayerID, questID) then
				return L( "TXT_KEY_CITY_STATE_QUEST_CONTEST_TECHS_WINNING_FORMAL", iMajorScore )
			else
				return L( "TXT_KEY_CITY_STATE_QUEST_CONTEST_TECHS_LOSING_FORMAL", iLeaderScore, iMajorScore )
			end
-- CBP
		elseif (questID == MinorCivQuestTypes.MINOR_CIV_QUEST_CONTEST_TOURISM) then
				local iLeaderScore = minorPlayer:GetMinorCivContestValueForLeader(questID);
				local iMajorScore = minorPlayer:GetMinorCivContestValueForPlayer(majorPlayerID, questID);
				if (minorPlayer:IsMinorCivContestLeader(majorPlayerID, questID)) then
					return L( "TXT_KEY_CITY_STATE_QUEST_CONTEST_TOURISM_WINNING_FORMAL", iMajorScore );
				else
					return L( "TXT_KEY_CITY_STATE_QUEST_CONTEST_TOURISM_LOSING_FORMAL", iLeaderScore, iMajorScore );
				end
-- END
		elseif questID == MinorCivQuestTypes.MINOR_CIV_QUEST_INVEST then
			return L( "TXT_KEY_CITY_STATE_QUEST_INVEST_FORMAL" )
		elseif questID == MinorCivQuestTypes.MINOR_CIV_QUEST_BULLY_CITY_STATE then
			return L( "TXT_KEY_CITY_STATE_QUEST_BULLY_CITY_STATE_FORMAL", Players[questData1]:GetCivilizationShortDescriptionKey() )
		elseif questID == MinorCivQuestTypes.MINOR_CIV_QUEST_DENOUNCE_MAJOR then
			return L( "TXT_KEY_CITY_STATE_QUEST_DENOUNCE_MAJOR_FORMAL", Players[questData1]:GetCivilizationShortDescriptionKey() )
		elseif questID == MinorCivQuestTypes.MINOR_CIV_QUEST_SPREAD_RELIGION then
			return L( "TXT_KEY_CITY_STATE_QUEST_SPREAD_RELIGION_FORMAL", Game_GetReligionName(questData1) )
-- CBP
		elseif questID == MinorCivQuestTypes.MINOR_CIV_QUEST_WAR then
			return L( "TXT_KEY_CITY_STATE_QUEST_WAR_FORMAL", Players[questData1]:GetCivilizationShortDescriptionKey() )
		elseif questID == MinorCivQuestTypes.MINOR_CIV_QUEST_CONSTRUCT_NATIONAL_WONDER then
			return L( "TXT_KEY_CITY_STATE_QUEST_CONSTRUCT_NATIONAL_WONDER_FORMAL", GameInfo.Buildings[questData1].Description )
		elseif questID == MinorCivQuestTypes.MINOR_CIV_QUEST_GIFT_SPECIFIC_UNIT then
			return L( "TXT_KEY_CITY_STATE_QUEST_GIFT_SPECIFIC_UNIT_FORMAL", GameInfo.Units[questData1].Description, questData2 )
		elseif questID == MinorCivQuestTypes.MINOR_CIV_QUEST_FIND_CITY_STATE then
			return L( "TXT_KEY_CITY_STATE_QUEST_FIND_CITY_STATE_FORMAL", Players[questData1]:GetNameKey() )
		elseif questID == MinorCivQuestTypes.MINOR_CIV_QUEST_INFLUENCE then
			return L( "TXT_KEY_CITY_STATE_QUEST_INFLUENCE_FORMAL" )
		elseif questID == MinorCivQuestTypes.MINOR_CIV_QUEST_ARCHAEOLOGY then
			return L( "TXT_KEY_CITY_STATE_QUEST_ARCHAEOLOGY_FORMAL" )
		elseif questID == MinorCivQuestTypes.MINOR_CIV_QUEST_CIRCUMNAVIGATION then
			return L( "TXT_KEY_CITY_STATE_QUEST_CIRCUMNAVIGATION_FORMAL" )
		elseif questID == MinorCivQuestTypes.MINOR_CIV_QUEST_LIBERATION then
			return L( "TXT_KEY_CITY_STATE_QUEST_LIBERATION_FORMAL" , minorPlayer:GetTargetCityString(majorPlayerID , questID ))
		elseif questID == MinorCivQuestTypes.MINOR_CIV_QUEST_HORDE then
			return L( "TXT_KEY_CITY_STATE_QUEST_HORDE_FORMAL" )
		elseif questID == MinorCivQuestTypes.MINOR_CIV_QUEST_REBELLION then
			return L( "TXT_KEY_CITY_STATE_QUEST_REBELLION_FORMAL" )
		elseif questID == MinorCivQuestTypes.MINOR_CIV_QUEST_EXPLORE_AREA then
			return L( "TXT_KEY_CITY_STATE_QUEST_EXPLORE_AREA_FORMAL", minorPlayer:GetExplorePercent(majorPlayerID , questID) )
		elseif questID == MinorCivQuestTypes.MINOR_CIV_QUEST_BUILD_X_BUILDINGS then
			return L( "TXT_KEY_CITY_STATE_QUEST_BUILD_X_BUILDINGS_FORMAL", GameInfo.Buildings[questData1].Description, minorPlayer:GetXQuestBuildingRemaining(majorPlayerID, questID, questData1 ) )
		elseif questID == MinorCivQuestTypes.MINOR_CIV_QUEST_SPY_ON_MAJOR then
			return L( "TXT_KEY_CITY_STATE_QUEST_SPY_ON_MAJOR_FORMAL", Players[questData1]:GetNameKey(), minorPlayer:QuestSpyActionsRemaining(majorPlayerID, questID) )
		elseif questID == MinorCivQuestTypes.MINOR_CIV_QUEST_COUP then
			return L( "TXT_KEY_CITY_STATE_QUEST_COUP_FORMAL", Players[questData1]:GetNameKey() )
		elseif questID == MinorCivQuestTypes.MINOR_CIV_QUEST_ACQUIRE_CITY then
			return L( "TXT_KEY_CITY_STATE_QUEST_ACQUIRE_CITY_FORMAL" , minorPlayer:GetTargetCityString(majorPlayerID , questID ))
-- END
		elseif bnw_mode then
			if questID == MinorCivQuestTypes.MINOR_CIV_QUEST_TRADE_ROUTE then
				return L("TXT_KEY_CITY_STATE_QUEST_TRADE_ROUTE_FORMAL")
			end
		end
	end
	return "CityStateStatusHelper script error - unknown quest"
end

if gk_mode then
	function GetActiveQuestToolTip(majorPlayerID, minorPlayerID)
		local minorPlayer = Players[minorPlayerID]
		local tips = {}
		
		local tTooltipQuestGlobal = {}
		local tTooltipQuestPersonal = {}
		local tTooltipOther = {}
		
		if minorPlayer then
			for _, questID in pairs(ktQuestsDisplayOrder) do
				if isMinorCivQuestForPlayer( minorPlayer, majorPlayerID, questID ) then
					local questData1 = minorPlayer:GetQuestData1(majorPlayerID, questID)
					local questData2 = minorPlayer:GetQuestData2(majorPlayerID, questID)
					local questString = QuestString(majorPlayerID, minorPlayer, questID, questData1, questData2)
					local turnsRemaining = minorPlayer:GetQuestTurnsRemaining(majorPlayerID, questID, Game_GetGameTurn() - 1)	-- add 1 since began on CS's turn (1 before), and avoids "0 turns remaining"
					
					if turnsRemaining >= 0 then
						questString = questString .. " " .. L( "TXT_KEY_CITY_STATE_QUEST_TURNS_REMAINING_FORMAL", turnsRemaining )
					end
					
					--CBP
					local questreward = minorPlayer:GetRewardString(majorPlayerID, questID);
					
					if(questreward ~= "")then
						questString = questString .. "[NEWLINE]" .. questreward
					end
					--END
					
					if minorPlayer:IsGlobalQuest(questID) then
						table_insert( tTooltipQuestGlobal, ktQuestsIcon[questID]( questData1 ) .. " " .. questString )
					end
					
					if minorPlayer:IsPersonalQuest(questID) then
						table_insert( tTooltipQuestPersonal, ktQuestsIcon[questID]( questData1 ) .. " " .. questString )
					end
				end
			end
			
			-- Threatening Barbarians event
			if minorPlayer:IsThreateningBarbariansEventActiveForPlayer(majorPlayerID) then
				table_insert(tTooltipOther,"[ICON_RAZING] " .. L("TXT_KEY_CITY_STATE_QUEST_INVADING_BARBS_FORMAL"))
			end

			-- Proxy War event
			if bnw_mode and minorPlayer:IsProxyWarActiveForMajor(majorPlayerID) then
				table_insert(tTooltipOther,"[ICON_RESISTANCE] " .. L("TXT_KEY_CITY_STATE_QUEST_GIFT_UNIT_FORMAL"))
			end

			-- CBP
			-- Denied Quest Influence
			if minorPlayer:IsQuestInfluenceDisabled(majorPlayerID) then
				table_insert(tTooltipOther,"[ICON_NOINFLUENCE] " .. L("TXT_KEY_CITY_STATE_DISABLED_QUEST_INFLUENCE_YES_TT", minorPlayer:GetName()))
			end

			-- Married
			if minorPlayer:IsMarried(majorPlayerID) then
				table_insert(tTooltipOther,"[ICON_RES_MARRIAGE] " .. L("TXT_KEY_DIPLO_MAJOR_CIV_DIPLO_STATE_MARRIED_TT"))
			end
			-- END
		else
			print("Lua error - invalid player index")
		end -- minorPlayer
		
		local sGatheredTooltipsForQuests = ""
		
		local bHasGlobalQuests = #tTooltipQuestGlobal > 0
		local bHasPersonalQuests = #tTooltipQuestPersonal > 0
		local bHasOther = #tTooltipOther > 0
		
		if bHasGlobalQuests then
		
			sGatheredTooltipsForQuests = sGatheredTooltipsForQuests .. L("TXT_KEY_CITY_STATE_QUEST_GLOBAL_HEADER") .. newLine.. table_concat( tTooltipQuestGlobal, newLine )
		end
		
		if bHasPersonalQuests then
			if sGatheredTooltipsForQuests ~= "" then
				sGatheredTooltipsForQuests = sGatheredTooltipsForQuests .. newLine .. newLine
			end
			
			sGatheredTooltipsForQuests = sGatheredTooltipsForQuests .. L("TXT_KEY_CITY_STATE_QUEST_LOCAL_HEADER") .. newLine .. table_concat( tTooltipQuestPersonal, newLine )
		end
		
		if bHasOther then
			if sGatheredTooltipsForQuests ~= "" then
				sGatheredTooltipsForQuests = sGatheredTooltipsForQuests .. newLine .. newLine
			end
			
			sGatheredTooltipsForQuests = sGatheredTooltipsForQuests .. L("TXT_KEY_CITY_STATE_QUEST_OTHER_HEADER") .. newLine .. table_concat( tTooltipOther, newLine )
		end
		
		if sGatheredTooltipsForQuests ~= "" then
			return sGatheredTooltipsForQuests
		else
			return L("TXT_KEY_CITY_STATE_QUEST_NONE_FORMAL")
		end
	end
else
	function GetActiveQuestToolTip(majorPlayerID, minorPlayerID)
		local minorPlayer = Players[minorPlayerID]
		if minorPlayer then
			local questID = minorPlayer:GetActiveQuestForPlayer(majorPlayerID)
			if questID and questID >= 0 then
				return QuestString( majorPlayerID, minorPlayer, questID, minorPlayer:GetQuestData1(majorPlayerID), minorPlayer:GetQuestData2(majorPlayerID) )
			end
		else
			print("Lua error - invalid player index")
		end -- minorPlayer
		return L("TXT_KEY_CITY_STATE_BARB_QUEST_SHORT")..": "..L("TXT_KEY_SV_ICONS_NONE")
	end
end -- gk_mode

function GetCityStateTraitText(minorPlayerID)

	local minorPlayer = Players[minorPlayerID]

	if minorPlayer then
		local minorCivTraitID = minorPlayer:GetMinorCivTrait()
		for key, value in pairs(MinorCivTraitTypes) do
			if minorCivTraitID == value then
				return L("TXT_KEY_CITY_STATE" .. key:sub(16) .. "_ADJECTIVE")
			end
		end
	else
		print("Lua error - invalid player index")
	end

	return ""
end

function GetCityStateTraitToolTip( minorPlayerID )
	local toolTip = ""
	local minorPlayer = Players[minorPlayerID]

	if minorPlayer then
		local minorCivTraitID = minorPlayer:GetMinorCivTrait()

		if gk_mode and minorCivTraitID == MinorCivTraitTypes.MINOR_CIV_TRAIT_MILITARISTIC then
			toolTip = L("TXT_KEY_CITY_STATE_MILITARISTIC_NO_UU_TT")
			if minorPlayer:IsMinorCivHasUniqueUnit() then
				local eUniqueUnit = minorPlayer:GetMinorCivUniqueUnit()
				if GameInfo.Units[eUniqueUnit] then
					local ePrereqTech = GameInfo.Units[eUniqueUnit].PrereqTech
					if not ePrereqTech then
						-- If no prereq then just make it Agriculture, but make sure that Agriculture is in our database. Otherwise, show the fallback tooltip.
						ePrereqTech = GameInfo.Technologies.TECH_AGRICULTURE
						ePrereqTech = ePrereqTech and ePrereqTech.ID
					end

					if ePrereqTech then
						if GameInfo.Technologies[ePrereqTech] then
							toolTip = L("TXT_KEY_CITY_STATE_MILITARISTIC_TT", GameInfo.Units[eUniqueUnit].Description, GameInfo.Technologies[ePrereqTech].Description)
						end
					end
				else
					print("Scripting error - City-State's unique unit not found!")
				end
			end
		else
			for key,value in pairs(MinorCivTraitTypes) do
				if minorCivTraitID == value then
					toolTip = L("TXT_KEY_CITY_STATE" .. key:sub(16) .. "_TT")
					break
				end
			end
		end
	else
		print("Lua error - invalid player index")
	end

	return toolTip
end

function GetCityStateStatusAlly( majorPlayerID, minorPlayerID, isFullInfo )
	local majorPlayer = Players[majorPlayerID]
	local minorPlayer = Players[minorPlayerID]
	local toolTip = ""
	if not gk_mode then
		toolTip = L("TXT_KEY_CITY_STATE_ALLY_TT")
	elseif majorPlayer and minorPlayer then
		local allyID = minorPlayer:GetAlly()
		local minorCivFriendshipWithMajor = minorPlayer:GetMinorCivFriendshipWithMajor(majorPlayerID)
		if allyID and allyID ~= -1 then -- already has an ally

			local minorCivFriendshipAlly = minorPlayer:GetMinorCivFriendshipWithMajor(allyID) - minorCivFriendshipWithMajor + 1	-- needs to pass up the current ally, not just match
			local ally = Players[allyID]

			if Teams[majorPlayer:GetTeam()]:IsHasMet(ally:GetTeam()) then
				toolTip = L("TXT_KEY_CITY_STATE_ALLY_TT", ally:GetCivilizationShortDescriptionKey(), minorCivFriendshipAlly )
			else
				toolTip = L("TXT_KEY_CITY_STATE_ALLY_UNKNOWN_TT", minorCivFriendshipAlly )
			end
		else
			toolTip = L("TXT_KEY_CITY_STATE_ALLY_NOBODY_TT", GameDefines.FRIENDSHIP_THRESHOLD_ALLIES - minorCivFriendshipWithMajor )
		end
		if not isFullInfo then
			return toolTip:sub(1,(toolTip:find("[NEWLINE]",1,true) or 999)-1)
		end
	else
		print("Lua error - invalid player index")
	end
	return toolTip
end