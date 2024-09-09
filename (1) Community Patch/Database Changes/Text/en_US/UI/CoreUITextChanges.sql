------------------------------------------------
-- Ranking popup
------------------------------------------------
UPDATE Language_en_US
SET Text = 'Ranks players by the average [ICON_PRODUCTION] Production generated by all of their cities.'
WHERE Tag = 'TXT_KEY_PROGRESS_SCREEN_PRODUCTION_TT';

------------------------------------------------
-- Advisors
------------------------------------------------
UPDATE Language_en_US
SET Text = 'I''m not sure if the {1_LongCivName:textkey} has an army at all. Any hostilities with them would be laughably one-sided.'
WHERE Tag = 'TXT_KEY_DIPLOSTRATEGY_MILITARY_STRENGTH_COMPARED_TO_US_PATHETIC';

------------------------------------------------
-- Tech tree
------------------------------------------------
UPDATE Language_en_US
SET Text = 'Allows land units to embark and cross water Tiles.'
WHERE Tag = 'TXT_KEY_ALLOWS_EMBARKING';

UPDATE Language_en_US
SET Text = 'Allowed units receive [COLOR_POSITIVE_TEXT]{@1_PromotionName}[ENDCOLOR] Promotion: {@2_PromotionHelp}'
WHERE Tag = 'TXT_KEY_FREE_PROMOTION_FROM_TECH';

UPDATE Language_en_US
SET Text = '{@1_ImprovementDescription}: +{3_Yield} {4_Icon} {@2_YieldDescription}'
WHERE Tag = 'TXT_KEY_CIVILOPEDIA_SPECIALABILITIES_YIELDCHANGES';

UPDATE Language_en_US
SET Text = '{@1_ImprovementDescription}: +{3_Yield} {4_Icon} {@2_YieldDescription} {TXT_KEY_ABLTY_FRESH_WATER_STRING}'
WHERE Tag = 'TXT_KEY_CIVILOPEDIA_SPECIALABILITIES_FRESHWATERYIELDCHANGES';

UPDATE Language_en_US
SET Text = '{@1_ImprovementDescription}: +{3_Yield} {4_Icon} {@2_YieldDescription} {TXT_KEY_ABLTY_NO_FRESH_WATER_STRING}'
WHERE Tag = 'TXT_KEY_CIVILOPEDIA_SPECIALABILITIES_NOFRESHWATERYIELDCHANGES';

UPDATE Language_en_US
SET Text = '{TXT_KEY_ABLTY_FASTER_MOVEMENT_STRING} {@1_RouteDescription}'
WHERE Tag = 'TXT_KEY_CIVILOPEDIA_SPECIALABILITIES_MOVEMENT';

UPDATE Language_en_US
SET Text = '{1_ImprovementName:textkey}: +{3_Num} {2_YieldType:textkey} (Fresh Water).'
WHERE Tag = 'TXT_KEY_FRESH_WATER';

UPDATE Language_en_US
SET Text = '{1_ImprovementName:textkey}: +{3_Num} {2_YieldType:textkey} (Not Fresh Water).'
WHERE Tag = 'TXT_KEY_NO_FRESH_WATER';

UPDATE Language_en_US
SET Text = '(Fresh Water)'
WHERE Tag = 'TXT_KEY_ABLTY_FRESH_WATER_STRING';

UPDATE Language_en_US
SET Text = '(Not Fresh Water)'
WHERE Tag = 'TXT_KEY_ABLTY_NO_FRESH_WATER_STRING';

------------------------------------------------
-- Civilopedia
------------------------------------------------
UPDATE Language_en_US
SET Text = 'Welcome to the Civilopedia! Here you will find detailed descriptions of all aspects of the game. Use the "Search" field to search for articles on any specific subject. Clicking on the tabs on the top edge of the screen will take you to the various major sections of the Civilopedia. The Navigation Bar on the left side of the screen will display the various entries within a section. Click on an entry to go directly there.[NEWLINE][NEWLINE]In the upper left-hand portion of the screen you will find the forward and back buttons which will help you navigate between pages. Click on the "X" on the upper right portion of the screen to return to the game.[NEWLINE][NEWLINE]Welcome to the Community Patch, a mod containing several bugfixes and AI improvements. [COLOR_YELLOW]Game Concepts that have been changed in the Community Patch are highlighted in yellow in the Civilopedia.[ENDCOLOR]'
WHERE Tag = 'TXT_KEY_PEDIA_HOME_PAGE_HELP_TEXT';

UPDATE Language_en_US
SET Text = 'Civilization V examines all of human history - from the deep past to the day after tomorrow. The "Game Concepts" portion of the Civilopedia explains some of the more important parts of the game - how to build and manage cities, how to fight wars, how to research technology, and so forth. The left Navigation Bar displays the major concepts; click on an entry to see the subsections within the concepts.[NEWLINE][NEWLINE][COLOR_YELLOW]Game Concepts that have been changed in the Community Patch are highlighted in yellow.[ENDCOLOR]'
WHERE Tag = 'TXT_KEY_PEDIA_GAME_CONCEPT_HELP_TEXT';

UPDATE Language_en_US
SET Text = 'Base Yield:'
WHERE Tag = 'TXT_KEY_PEDIA_YIELD_LABEL';

UPDATE Language_en_US
SET Text = 'Connected By:'
WHERE Tag = 'TXT_KEY_PEDIA_IMPROVEMENTS_LABEL';

UPDATE Language_en_US
SET Text = 'Kyivan'
WHERE Tag = 'TXT_KEY_CIV5_RUSSIA_HEADING_4';

UPDATE Language_en_US
SET Text = 'The eighth century saw the first written record of "Kyivan Rus." The Rus are believed to have been Scandinavian Vikings who migrated south from the Baltic coast (although this is disputed by some Russian scholars, who believe that the original founders of Kyivan Rus were Slavs). By 860 the Rus were sending raiding parties as far south as Constantinople, and by 1000 AD Kyivan Rus controlled a trade route from the Baltic to the Black Sea; this would form the economic backbone of the growing regional power.[NEWLINE][NEWLINE]By the 12th century, the Kyiv Empire covered much of what would become eastern Russia, extending from Poland in the west to the Volga in the east, and from Finland in the north to the Ukraine in the south. It was a vast territory to manage from one centralized location, especially as component parts of the Empire began developing individual identities and national aspirations. Economically, the Empire also became divided, with northern provinces aligning themselves with the Baltic powers while the western areas were drawn to Poland and Hungary, and the southern regions to Asia Minor and the Mediterranean. By the closing of the 12th century Rus Kyiv was dissolved in all but name, replaced by a number of smaller quasi-feudal states.'
WHERE Tag = 'TXT_KEY_CIV5_RUSSIA_TEXT_4';

UPDATE Language_en_US
SET Text = 'The first Mongol incursion into Kyivan territory occurred in 1223, when a Mongol reconnaissance unit met the combined warriors of several Rus states under the command of the wonderfully-named "Mstislav the Bold" and "Mstislav Romanovich the Old" at the Battle of the Kalka River. The Rus forces enjoyed early success, but they became disorganized in the pursuit of the retreating foe. The Mongol horsemen rallied and defeated the pursuers in detail before they could reorganize. A large portion of the Rus forces surrendered to the Mongols on the condition that they would be spared; the Mongols accepted the conditions then slaughtered them anyway. The Mongols then left Rus for several years before returning in much greater force.[NEWLINE][NEWLINE]In 1237 a vast Mongol army of some 30,000 or more horse archers once again crossed the Volga River. In a few short years the Mongols captured, looted and destroyed dozens of Russian cities and towns, including Ryazan, Kolomna, Moscow, Rostov, Kashin, Dmitrov, Kozelsk, Halych and Kyiv. They soundly thrashed every force raised to oppose them. By 1240 most of Rus was a smoking ruin, firmly under the control of the Mongols, who then turned their sight further west, towards Hungary and Poland.[NEWLINE]'
WHERE Tag = 'TXT_KEY_CIV5_RUSSIA_TEXT_5';

------------------------------------------------
-- City screen/banner
------------------------------------------------
UPDATE Language_en_US
SET Text = 'Do you want to annex the puppet of {@1_CityName} into your empire? It will allow you to manage the City, but will increase your [ICON_HAPPINESS_4] Unhappiness and the cost of new [ICON_CULTURE] Policies, [ICON_RESEARCH] Technologies, and [ICON_GOLDEN_AGE] Golden Ages. You will not be able to reverse this.'
WHERE Tag = 'TXT_KEY_POPUP_ANNEX_PUPPET';

UPDATE Language_en_US
SET Text = '[NEWLINE]Requires {TXT_KEY_GRAMMAR_A_AN << {1_BuildingName:textkey}} in this City.'
WHERE Tag = 'TXT_KEY_NO_ACTION_UNIT_REQUIRES_BUILDING';

UPDATE Language_en_US
SET Text = 'LEFT CLICK adds an additional item to the end of the production queue.[NEWLINE]CTRL + LEFT CLICK adds an additional item in front of the production queue.[NEWLINE]ALT + LEFT CLICK adds the chosen item to the end of the production queue on repeat.[NEWLINE]SHIFT + LEFT CLICK replaces everything in the production queue with the chosen item.[NEWLINE]H hides the chosen building from this city''s production options.'
WHERE Tag = 'TXT_KEY_CITYVIEW_QUEUE_PROD_TT';

UPDATE Language_en_US
SET Text = 'Click here to stop this city from growing in [ICON_CITIZEN] Population.'
WHERE Tag = 'TXT_KEY_CITYVIEW_FOCUS_AVOID_GROWTH_TT';

UPDATE Language_en_US
SET Text = '[NEWLINE][ICON_BULLET][ICON_CONNECTED] Empire Modifier from Policies etc: {1_Num}%'
WHERE Tag = 'TXT_KEY_FOODMOD_PLAYER';

UPDATE Language_en_US
SET Text = '[NEWLINE][ICON_BULLET][ICON_RELIGION_PANTHEON] Religious Beliefs Modifier: {1_Num}%'
WHERE Tag = 'TXT_KEY_FOODMOD_RELIGION';

UPDATE Language_en_US
SET Text = '[NEWLINE][ICON_BULLET][ICON_HAPPINESS_1] "We Love the King Day" Modifier: {1_Num}%'
WHERE Tag = 'TXT_KEY_FOODMOD_WLTKD';

UPDATE Language_en_US
SET Text = '{1_Num} [ICON_CULTURE] from Great Works and Themes'
WHERE Tag = 'TXT_KEY_CULTURE_FROM_GREAT_WORKS';

UPDATE Language_en_US
SET Text = '{1_Num} [ICON_TOURISM] Tourism from {2_Num} [ICON_GREAT_WORK] {2_Num: plural 1?Great Work; other?Great Works;}'
WHERE Tag = 'TXT_KEY_CO_CITY_TOURISM_GREAT_WORKS';

UPDATE Language_en_US
SET Text = '{1_Num} [ICON_TOURISM] Tourism from buildings purchased with [ICON_PEACE] Faith'
WHERE Tag = 'TXT_KEY_CO_CITY_TOURISM_FAITH_BUILDINGS';

UPDATE Language_en_US
SET Text = '{1_ReligionIcon} {2_NumFollowers} {2_NumFollowers: plural 1?Follower; other?Followers;} {3_PressureString}'
WHERE Tag = 'TXT_KEY_RELIGION_TOOLTIP_LINE';

UPDATE Language_en_US
SET Text = '{1_ReligionIcon} {2_NumFollowers} {2_NumFollowers: plural 1?Follower; other?Followers;} {3_PressureString} ({4_Num} trade routes)'
WHERE Tag = 'TXT_KEY_RELIGION_TOOLTIP_LINE_WITH_TRADE';

------------------------------------------------
-- Conquest picker
------------------------------------------------
UPDATE Language_en_US
SET Text = '[COLOR_POSITIVE_TEXT]Razing[ENDCOLOR] The City will burn [ICON_RAZING] down each turn until it reaches 0 population, and is removed from the game. This produces a lot of [ICON_HAPPINESS_4] Unhappiness, but also increases your [COLOR_POSITIVE_TEXT]War Score[ENDCOLOR] versus this player.'
WHERE Tag = 'TXT_KEY_POPUP_CITY_CAPTURE_INFO_RAZE';

------------------------------------------------
-- Great Person panel
------------------------------------------------
UPDATE Language_en_US
SET Text = '{1_Progress}/{2_Threshold}, {3_Turns} {3_Turns: plural 1?Turn; other?Turns;} Remaining'
WHERE Tag = 'TXT_KEY_GPLIST_PROGRESS';

------------------------------------------------
-- Unit panel
------------------------------------------------
UPDATE Language_en_US
SET Text = '{1_Num} {1_Num: plural 1?Turn; other?Turns;}'
WHERE Tag = 'TXT_KEY_BUILD_NUM_TURNS';

UPDATE Language_en_US
SET Text = 'After this action is performed, [COLOR_POSITIVE_TEXT]{2_NumFollowers}[ENDCOLOR] {2_NumFollowers: plural 1?Citizens; other?Citizens;} will be following [COLOR_POSITIVE_TEXT]{1_ReligionName}[ENDCOLOR].'
WHERE Tag = 'TXT_KEY_MISSION_SPREAD_RELIGION_RESULT';

UPDATE Language_en_US
SET Text = 'Your Unit may move {1_Num} more {1_Num: plural 1?tile; other?tiles;} this turn.'
WHERE Tag = 'TXT_KEY_UPANEL_UNIT_MAY_MOVE';

UPDATE Language_en_US
SET Text = 'Your Unit may strike within {1_Num} {1_Num: plural 1?tile; other?tiles;} or rebase within {2_Num} tiles.'
WHERE Tag = 'TXT_KEY_UPANEL_UNIT_MAY_STRIKE_REBASE';

------------------------------------------------
-- Combat simulator
------------------------------------------------
UPDATE Language_en_US
SET Text = '[COLOR_CYAN]Capture chance if defeated[ENDCOLOR]'
WHERE Tag = 'TXT_KEY_EUPANEL_CAPTURE_CHANCE';

UPDATE Language_en_US
SET Text = '[COLOR_WARNING_TEXT]{1_Number} Interceptors![ENDCOLOR]'
WHERE Tag = 'TXT_KEY_EUPANEL_VISIBLE_AA_UNITS';

------------------------------------------------
-- Diplomacy overview / player icon tooltip
------------------------------------------------

-- Neutral Indicators
UPDATE Language_en_US
SET Text = 'ELIMINATED'
WHERE Tag = 'TXT_KEY_EMOTIONLESS';

------------------------------------------------
-- Opinion modifiers
------------------------------------------------

-- Dispute Modifiers
UPDATE Language_en_US
SET Text = 'Territorial disputes strain your relationship.'
WHERE Tag = 'TXT_KEY_DIPLO_LAND_DISPUTE';

UPDATE Language_en_US
SET Text = 'You are competing for World Wonders.'
WHERE Tag = 'TXT_KEY_DIPLO_WONDER_DISPUTE';

UPDATE Language_en_US
SET Text = 'You are competing for the favor of the same City-States!'
WHERE Tag = 'TXT_KEY_DIPLO_MINOR_CIV_DISPUTE';

-- War Stuff
UPDATE Language_en_US
SET Text = 'They have some early concerns about your warmongering.'
WHERE Tag = 'TXT_KEY_DIPLO_WARMONGER_THREAT_MINOR';

UPDATE Language_en_US
SET Text = 'They are wary of the potential threat posed by your warmongering.'
WHERE Tag = 'TXT_KEY_DIPLO_WARMONGER_THREAT_MAJOR';

UPDATE Language_en_US
SET Text = 'They believe your warmongering has become an existential threat.'
WHERE Tag = 'TXT_KEY_DIPLO_WARMONGER_THREAT_SEVERE';

UPDATE Language_en_US
SET Text = 'They fear your warmongering will end this world in fire!'
WHERE Tag = 'TXT_KEY_DIPLO_WARMONGER_THREAT_CRITICAL';

UPDATE Language_en_US
SET Text = '[SPACE](They strongly dislike warmongers.)'
WHERE Tag = 'TXT_KEY_WARMONGER_HATE_HIGH';

UPDATE Language_en_US
SET Text = '[SPACE](They dislike warmongers.)'
WHERE Tag = 'TXT_KEY_WARMONGER_HATE_MID';

UPDATE Language_en_US
SET Text = '[SPACE](They overlook modest warmongering.)'
WHERE Tag = 'TXT_KEY_WARMONGER_HATE_LOW';

UPDATE Language_en_US
SET Text = 'You plundered their trade routes!'
WHERE Tag = 'TXT_KEY_DIPLO_PLUNDERING_OUR_TRADE_ROUTES';

UPDATE Language_en_US
SET Text = 'You nuked them!'
WHERE Tag = 'TXT_KEY_DIPLO_NUKED';

UPDATE Language_en_US
SET Text = 'You have gone to war in the past.'
WHERE Tag = 'TXT_KEY_DIPLO_PAST_WAR_BAD';

UPDATE Language_en_US
SET Text = 'You captured their original capital.'
WHERE Tag = 'TXT_KEY_DIPLO_CAPTURED_CAPITAL';

-- Recent diplomatic actions
UPDATE Language_en_US
SET Text = 'Your recent diplomatic actions please them.'
WHERE Tag = 'TXT_KEY_DIPLO_ASSISTANCE_TO_THEM';

UPDATE Language_en_US
SET Text = 'Your recent diplomatic actions disappoint them.'
WHERE Tag = 'TXT_KEY_DIPLO_REFUSED_REQUESTS';

-- Player has done nice stuff
UPDATE Language_en_US
SET Text = 'We are trade partners.'
WHERE Tag = 'TXT_KEY_DIPLO_TRADE_PARTNER';

UPDATE Language_en_US
SET Text = 'We fought together against a common foe.'
WHERE Tag = 'TXT_KEY_DIPLO_COMMON_FOE';

UPDATE Language_en_US
SET Text = 'You freed their captured citizens!'
WHERE Tag = 'TXT_KEY_DIPLO_CIVILIANS_RETURNED';

UPDATE Language_en_US
SET Text = 'You built a Landmark in their territory.'
WHERE Tag = 'TXT_KEY_DIPLO_LANDMARKS_BUILT';

UPDATE Language_en_US
SET Text = 'You restored their civilization after they were annihilated!'
WHERE Tag = 'TXT_KEY_DIPLO_RESURRECTED';

UPDATE Language_en_US
SET Text = 'You liberated their original capital.'
WHERE Tag = 'TXT_KEY_DIPLO_LIBERATED_CAPITAL';

UPDATE Language_en_US
SET Text = 'You have liberated some of their people!'
WHERE Tag = 'TXT_KEY_DIPLO_CITIES_LIBERATED';

UPDATE Language_en_US
SET Text = 'They have an embassy in your capital.'
WHERE Tag = 'TXT_KEY_DIPLO_HAS_EMBASSY';

UPDATE Language_en_US
SET Text = 'You forgave them for spying.'
WHERE Tag = 'TXT_KEY_DIPLO_FORGAVE_FOR_SPYING';

UPDATE Language_en_US
SET Text = 'You have shared intrigue with them.'
WHERE Tag = 'TXT_KEY_DIPLO_SHARED_INTRIGUE';

-- Player has done mean stuff
UPDATE Language_en_US
SET Text = 'You stole their territory while at peace!'
WHERE Tag = 'TXT_KEY_DIPLO_CULTURE_BOMB';

UPDATE Language_en_US
SET Text = 'Your spies were caught stealing from them.'
WHERE Tag = 'TXT_KEY_DIPLO_CAUGHT_STEALING';

-- Player has asked us to do things we don't like
UPDATE Language_en_US
SET Text = 'You demanded they not settle near your lands!'
WHERE Tag = 'TXT_KEY_DIPLO_NO_SETTLE_ASKED';

UPDATE Language_en_US
SET Text = 'You asked them not to spy on you.'
WHERE Tag = 'TXT_KEY_DIPLO_STOP_SPYING_ASKED';

UPDATE Language_en_US
SET Text = 'You made a trade demand of them!'
WHERE Tag = 'TXT_KEY_DIPLO_TRADE_DEMAND';

UPDATE Language_en_US
SET Text = 'You forced them to pay tribute.'
WHERE Tag = 'TXT_KEY_DIPLO_PAID_TRIBUTE';

-- Denouncing
UPDATE Language_en_US
SET Text = 'We have denounced them!'
WHERE Tag = 'TXT_KEY_DIPLO_DENOUNCED_BY_US';

UPDATE Language_en_US
SET Text = 'They have denounced us!'
WHERE Tag = 'TXT_KEY_DIPLO_DENOUNCED_BY_THEM';

UPDATE Language_en_US
SET Text = 'You have denounced a leader they made a Declaration of Friendship with!'
WHERE Tag = 'TXT_KEY_DIPLO_HUMAN_DENOUNCED_FRIEND';

UPDATE Language_en_US
SET Text = 'You have denounced one of their declared enemies!'
WHERE Tag = 'TXT_KEY_DIPLO_MUTUAL_ENEMY';

UPDATE Language_en_US
SET Text = 'Their friends or allies have denounced you!'
WHERE Tag = 'TXT_KEY_DIPLO_DENOUNCED_BY_PEOPLE_WE_TRUST_MORE';

-- Promises
UPDATE Language_en_US
SET Text = 'You made a promise not to declare war on them, and then broke it!'
WHERE Tag = 'TXT_KEY_DIPLO_MILITARY_PROMISE';

UPDATE Language_en_US
SET Text = 'You made a promise not to declare war on another civilization, and then broke it!'
WHERE Tag = 'TXT_KEY_DIPLO_MILITARY_PROMISE_BROKEN_WITH_OTHERS';

UPDATE Language_en_US
SET Text = 'You refused to move your troops away from their borders when they asked!'
WHERE Tag = 'TXT_KEY_DIPLO_MILITARY_PROMISE_IGNORED';

UPDATE Language_en_US
SET Text = 'You made a promise to stop settling near them, and then broke it!'
WHERE Tag = 'TXT_KEY_DIPLO_EXPANSION_PROMISE';

UPDATE Language_en_US
SET Text = 'They asked you to stop settling near them, and you ignored them!'
WHERE Tag = 'TXT_KEY_DIPLO_EXPANSION_PROMISE_IGNORED';

UPDATE Language_en_US
SET Text = 'You made a promise to stop buying land near them, and then broke it!'
WHERE Tag = 'TXT_KEY_DIPLO_BORDER_PROMISE';

UPDATE Language_en_US
SET Text = 'They asked you to stop buying land near them, and you ignored them!'
WHERE Tag = 'TXT_KEY_DIPLO_BORDER_PROMISE_IGNORED';

UPDATE Language_en_US
SET Text = 'You made a promise not to conquer a City-State protected by them, and then broke it!'
WHERE Tag = 'TXT_KEY_DIPLO_CITY_STATE_PROMISE';

UPDATE Language_en_US
SET Text = 'You made a promise not to conquer another civilization''s protected City-State, and then broke it!'
WHERE Tag = 'TXT_KEY_DIPLO_CITY_STATE_PROMISE_BROKEN_WITH_OTHERS';

UPDATE Language_en_US
SET Text = 'They asked you to stop attacking a City-State protected by them, and you ignored them!'
WHERE Tag = 'TXT_KEY_DIPLO_CITY_STATE_PROMISE_IGNORED';

UPDATE Language_en_US
SET Text = 'You made a promise to stop demanding tribute from a City-State protected by them, and then broke it!'
WHERE Tag = 'TXT_KEY_DIPLO_BULLY_CITY_STATE_PROMISE_BROKEN';

UPDATE Language_en_US
SET Text = 'They asked you to stop demanding tribute from a City-State protected by them, and you ignored them!'
WHERE Tag = 'TXT_KEY_DIPLO_BULLY_CITY_STATE_PROMISE_IGNORED';

UPDATE Language_en_US
SET Text = 'You made a promise to stop converting their cities, and then broke it!'
WHERE Tag = 'TXT_KEY_DIPLO_NO_CONVERT_PROMISE_BROKEN';

UPDATE Language_en_US
SET Text = 'They asked you to stop converting their cities, and you ignored them!'
WHERE Tag = 'TXT_KEY_DIPLO_NO_CONVERT_PROMISE_IGNORED';

UPDATE Language_en_US
SET Text = 'You made a promise to stop excavating their artifacts, and then broke it!'
WHERE Tag = 'TXT_KEY_DIPLO_NO_DIG_PROMISE_BROKEN';

UPDATE Language_en_US
SET Text = 'They asked you to stop excavating their artifacts, and you ignored them!'
WHERE Tag = 'TXT_KEY_DIPLO_NO_DIG_PROMISE_IGNORED';

UPDATE Language_en_US
SET Text = 'You made a promise to stop spying on them, and then broke it!'
WHERE Tag = 'TXT_KEY_DIPLO_SPY_PROMISE_BROKEN';

UPDATE Language_en_US
SET Text = 'They asked you to stop spying on them, and you ignored them!'
WHERE Tag = 'TXT_KEY_DIPLO_SPY_PROMISE_IGNORED';

UPDATE Language_en_US
SET Text = 'You made a promise to start a cooperative war against another empire, and then broke it!'
WHERE Tag = 'TXT_KEY_DIPLO_COOP_WAR_PROMISE';

-- Religion / Ideology
UPDATE Language_en_US
SET Text = 'They have happily adopted your religion in the majority of their cities.' -- note for translators: swapped HIS and MY text keys from vanilla
WHERE Tag = 'TXT_KEY_DIPLO_ADOPTING_HIS_RELIGION';

UPDATE Language_en_US
SET Text = 'You have adopted their religion in the majority of your cities.'  -- note for translators: swapped HIS and MY text keys from vanilla
WHERE Tag = 'TXT_KEY_DIPLO_ADOPTING_MY_RELIGION';

UPDATE Language_en_US
SET Text = 'They are spreading their own religion, but you converted some of their cities to your religion.'
WHERE Tag = 'TXT_KEY_DIPLO_RELIGIOUS_CONVERSIONS';

UPDATE Language_en_US
SET Text = 'You have both chosen to adopt the {1_PolicyTree} Ideology.'
WHERE Tag = 'TXT_KEY_DIPLO_SAME_LATE_POLICY_TREES';

UPDATE Language_en_US
SET Text = 'You have chosen to adopt the {1_YourPolicyTree} Ideology, but they believe in {2_TheirPolicyTree}.'
WHERE Tag = 'TXT_KEY_DIPLO_DIFFERENT_LATE_POLICY_TREES';

-- Protected Minors
UPDATE Language_en_US
SET Text = 'You have conquered City-States under their protection!'
WHERE Tag = 'TXT_KEY_DIPLO_PROTECTED_MINORS_KILLED';

UPDATE Language_en_US
SET Text = 'You have attacked City-States under their protection!'
WHERE Tag = 'TXT_KEY_DIPLO_PROTECTED_MINORS_ATTACKED';

UPDATE Language_en_US
SET Text = 'You have demanded tribute from City-States under their protection!'
WHERE Tag = 'TXT_KEY_DIPLO_PROTECTED_MINORS_BULLIED';

UPDATE Language_en_US
SET Text = 'They mistreated your protected City-States, and you didn''t look the other way!'
WHERE Tag = 'TXT_KEY_DIPLO_SIDED_WITH_MINOR';

-- Declaration of Friendship
UPDATE Language_en_US
SET Text = 'We have made a public Declaration of Friendship!'
WHERE Tag = 'TXT_KEY_DIPLO_DOF';

UPDATE Language_en_US
SET Text = 'We have made Declarations of Friendship with the same leaders!'
WHERE Tag = 'TXT_KEY_DIPLO_MUTUAL_DOF';

UPDATE Language_en_US
SET Text = 'You have made a Declaration of Friendship with one of their enemies!'
WHERE Tag = 'TXT_KEY_DIPLO_HUMAN_DOF_WITH_ENEMY';

-- Traitor Opinion
UPDATE Language_en_US
SET Text = 'Your friends found reason to denounce you!'
WHERE Tag = 'TXT_KEY_DIPLO_HUMAN_DENOUNCED_BY_FRIENDS';

UPDATE Language_en_US
SET Text = 'You have denounced leaders you''ve made Declarations of Friendship with!'
WHERE Tag = 'TXT_KEY_DIPLO_HUMAN_DENOUNCED_FRIENDS';

UPDATE Language_en_US
SET Text = 'We made a Declaration of Friendship and then denounced them!'
WHERE Tag = 'TXT_KEY_DIPLO_HUMAN_FRIEND_DENOUNCED';

UPDATE Language_en_US
SET Text = 'You have declared war on leaders you''ve made Declarations of Friendship with!'
WHERE Tag = 'TXT_KEY_DIPLO_HUMAN_DECLARED_WAR_ON_FRIENDS';

UPDATE Language_en_US
SET Text = 'We made a Declaration of Friendship and then declared war on them!'
WHERE Tag = 'TXT_KEY_DIPLO_HUMAN_FRIEND_DECLARED_WAR';

-- Reckless Expander
UPDATE Language_en_US
SET Text = 'They believe we are expanding our empire too aggressively!'
WHERE Tag = 'TXT_KEY_DIPLO_RECKLESS_EXPANDER';

-- World Congress
UPDATE Language_en_US
SET Text = 'They liked our proposal to the World Congress.'
WHERE Tag = 'TXT_KEY_DIPLO_LIKED_OUR_PROPOSAL';

UPDATE Language_en_US
SET Text = 'They disliked our proposal to the World Congress.'
WHERE Tag = 'TXT_KEY_DIPLO_DISLIKED_OUR_PROPOSAL';

UPDATE Language_en_US
SET Text = 'We passed their proposal in the World Congress.'
WHERE Tag = 'TXT_KEY_DIPLO_SUPPORTED_THEIR_PROPOSAL';

UPDATE Language_en_US
SET Text = 'We defeated their proposal in the World Congress.'
WHERE Tag = 'TXT_KEY_DIPLO_FOILED_THEIR_PROPOSAL';

UPDATE Language_en_US
SET Text = 'We helped relocate the World Congress to their lands.'
WHERE Tag = 'TXT_KEY_DIPLO_SUPPORTED_THEIR_HOSTING';

------------------------------------------------
-- City-State screen/tooltip
------------------------------------------------
UPDATE Language_en_US
SET Text = 'A befriended [COLOR_POSITIVE_TEXT]Militaristic[ENDCOLOR] City-State will provide you occasional gifts of advanced military units.[NEWLINE][NEWLINE]They know the secrets of the [COLOR_POSITIVE_TEXT]{@1_UniqueUnitName}[ENDCOLOR]. If you are their Ally and have researched [COLOR_CYAN]{@2_PrereqTech}[ENDCOLOR], they will provide that unit as their gift.'
WHERE Tag = 'TXT_KEY_CITY_STATE_MILITARISTIC_TT';

UPDATE Language_en_US
SET Text = '{1_CivName:textkey} {1_CivName: plural 1?is; other?are;} their current Ally. You need another {2_NumInfluence} [ICON_INFLUENCE] Influence to surpass {1_CivName:textkey} and become their Ally.[NEWLINE][NEWLINE]If a player becomes the Ally of a City-State, they receive extra bonuses relating to that City-State''s trait, and they will also receive any luxury and strategic Resources the City-State has connected.'
WHERE Tag = 'TXT_KEY_CITY_STATE_ALLY_TT';

UPDATE Language_en_US
SET Text = 'Enslave {@1_Unit} - lose {2_NumInfluence} [ICON_INFLUENCE] Influence'
WHERE Tag = 'TXT_KEY_POPUP_MINOR_BULLY_UNIT_AMOUNT';

UPDATE Language_en_US
SET Text = 'If this City-State is more [COLOR_POSITIVE_TEXT]afraid[ENDCOLOR] of you than they are [COLOR_WARNING_TEXT]resilient[ENDCOLOR], you can demand one {@3_Unit} as tribute of at the cost of [ICON_INFLUENCE] Influence. {1_FearLevel}{2_FactorDetails}'
WHERE Tag = 'TXT_KEY_POP_CSTATE_BULLY_UNIT_TT';

UPDATE Language_en_US
SET Text = 'They want you to defeat Barbarian units that are invading their territory. You are allowed to enter their territory until the Barbarians are defeated.'
WHERE Tag = 'TXT_KEY_CITY_STATE_QUEST_INVADING_BARBS_FORMAL';

UPDATE Language_en_US
SET Text = '{TXT_KEY_CITY_STATE_QUEST_CONTEST_TECHS_FORMAL} So far, you have the lead with [COLOR_POSITIVE_TEXT]{1_PlayerScore}[ENDCOLOR] {1_PlayerScore: plural 1?Technology; other?Technologies;}.'
WHERE Tag = 'TXT_KEY_CITY_STATE_QUEST_CONTEST_TECHS_WINNING_FORMAL';

UPDATE Language_en_US
SET Text = '{TXT_KEY_CITY_STATE_QUEST_CONTEST_TECHS_FORMAL} So far, the leader has {1_LeaderScore} {1_LeaderScore: plural 1?Technology; other?Technologies;} and you have [COLOR_POSITIVE_TEXT]{2_PlayerScore}[ENDCOLOR].'
WHERE Tag = 'TXT_KEY_CITY_STATE_QUEST_CONTEST_TECHS_LOSING_FORMAL';

------------------------------------------------
-- Top panel
------------------------------------------------

-- Anarchy (Gold, Science, Culture, Faith)
UPDATE Language_en_US
SET Text = '[COLOR_NEGATIVE_TEXT]The empire is in Anarchy due to a change in Ideology for {1_Turns} more {1_Num: plural 1?turn; other?turns;}. During Anarchy, the empire will not gain any [ICON_RESEARCH] Science, [ICON_GOLD] Gold, [ICON_CULTURE] Culture, or [ICON_PEACE] Faith, and cities have no [ICON_PRODUCTION] Production to build anything[ENDCOLOR].'
WHERE Tag = 'TXT_KEY_TP_ANARCHY';

-- Culture
UPDATE Language_en_US
SET Text = 'Next Policy: {1_Num} {1_Num: plural 1?Turn; other?Turns;}'
WHERE Tag = 'TXT_KEY_NEXT_POLICY_TURN_LABEL';

-- Faith
UPDATE Language_en_US
SET Text = '{1_Num} [ICON_PEACE] Faith is the minimum required to found the next religious Pantheon. If you wish to found a Pantheon, you must do it before there is an Enhanced Religion in the game (though you may always form one if there have not been as many Pantheons as the maximum number of Religions).'
WHERE Tag = 'TXT_KEY_TP_FAITH_NEXT_PANTHEON';

UPDATE Language_en_US
SET Text = '{1_Num} [ICON_PEACE] Faith is the minimum required for your next chance at a Great Prophet.'
WHERE Tag = 'TXT_KEY_TP_FAITH_NEXT_PROPHET';

-- Trade routes
UPDATE Language_en_US
SET Text = 'You have {1_TradeRoutesUsedNum} {1_TradeRoutesUsedNum: plural 1?Trade Unit; other?Trade Units;}.[NEWLINE]You have {2_TradeRoutesAvailableNum} {2_TradeRoutesAvailableNum: plural 1?Trade Route; other?Trade Routes;} available.'
WHERE Tag = 'TXT_KEY_TOP_PANEL_INTERNATIONAL_TRADE_ROUTES_TT';

UPDATE Language_en_US
SET Text = 'You have {1_Num} unassigned {2_UnitName}{1_Num: plural 1?; other?s;}.[NEWLINE]'
WHERE Tag = 'TXT_KEY_TOP_PANEL_INTERNATIONAL_TRADE_ROUTES_TT_UNASSIGNED';

------------------------------------------------
-- Demographics
------------------------------------------------
UPDATE Language_en_US
SET Text = 'Deployable Troops'
WHERE Tag = 'TXT_KEY_DEMOGRAPHICS_ARMY_MEASURE';

------------------------------------------------
-- Espionage overview
------------------------------------------------
UPDATE Language_en_US
SET Text = '[COLOR_POSITIVE_TEXT]Chance to kill enemy spies: {1_Num}%[ENDCOLOR]'
WHERE Tag = 'TXT_KEY_EO_SPY_COUNTER_INTEL_SUM_TT';

UPDATE Language_en_US
SET Text = '{1_RankName} {2_SpyName} is attempting to rig the election in {3_CityName} to increase our influence there.[NEWLINE][NEWLINE]Only one civilization may successfuly rig an election. If more than one spy is in a City-State, the highest ranked spy that has been in that City-State the longest has the greatest chance of successfully rigging the election in its favor. Successfully rigging elections also increases the success chance of a coup in the City-State.[NEWLINE][NEWLINE][COLOR_POSITIVE_TEXT]If you successfully rig the next election, your influence will increase by {4_Influence}.[ENDCOLOR]'
WHERE Tag = 'TXT_KEY_EO_SPY_RIGGING_ELECTIONS_TT';

UPDATE Language_en_US
SET Text = 'All city-states around the world hold elections simultaneously every {1_Num} Turns. The next election will be in {2_Num} {2_Num: plural 1?Turn; other?Turns;}.'
WHERE Tag = 'TXT_KEY_EO_CITY_STATE_ELECTION';

------------------------------------------------
-- Religion overview
------------------------------------------------
UPDATE Language_en_US
SET Text = 'Head of {1_ReligionName}'
WHERE Tag = 'TXT_KEY_RO_STATUS_FOUNDER';

------------------------------------------------
-- Cultural overview
------------------------------------------------

-- CV progress screen
UPDATE Language_en_US
SET Text = '+{1_Num}% Bonus from Trade Route between Empires[NEWLINE]'
WHERE Tag = 'TXT_KEY_CO_PLAYER_TOURISM_TRADE_ROUTE';

UPDATE Language_en_US
SET Text = 'Influential in {1_Num} {1_Num: plural 1?Turn; other?Turns;} (assuming Tourism output remains unchanged)'
WHERE Tag = 'TXT_KEY_CO_INFLUENTIAL_TURNS_TT';

------------------------------------------------
-- Deal overview
------------------------------------------------
UPDATE Language_en_US
SET Text = 'Ends after:[NEWLINE]Turn {1_turn}'
WHERE Tag = 'TXT_KEY_DO_ENDS_ON';

------------------------------------------------
-- Trade Route picker
------------------------------------------------
UPDATE Language_en_US
SET Text = 'You have discovered {1_Num} {1_Num: plural 1?Technology; other?Technologies;} that {2_CivName} {2_CivName: plural 1?does; other?do;} not know.[NEWLINE]They are receiving +{3_Num} [ICON_RESEARCH] Science on this route due to their Cultural Influence over you.'
WHERE Tag = 'TXT_KEY_CHOOSE_INTERNATIONAL_TRADE_ROUTE_ITEM_TT_THEIR_SCIENCE_EXPLAINED';

UPDATE Language_en_US
SET Text = '{1_CivName} {1_CivName: plural 1?has; other?have;} discovered {2_Num} {2_Num: plural 1?Technology; other?Technologies;} that you do not know.[NEWLINE]You are receiving +{3_Num} [ICON_RESEARCH] Science on this route due to your Cultural Influence over them.'
WHERE Tag = 'TXT_KEY_CHOOSE_INTERNATIONAL_TRADE_ROUTE_ITEM_TT_YOUR_SCIENCE_EXPLAINED';

------------------------------------------------
-- World Congress screen
------------------------------------------------
UPDATE Language_en_US
SET Text = '[NEWLINE][ICON_BULLET]{1_NumVotes} from Wonders'
WHERE Tag = 'TXT_KEY_LEAGUE_OVERVIEW_MEMBER_DETAILS_WONDER_VOTES';

UPDATE Language_en_US
SET Text = '[NEWLINE][NEWLINE]Our knowledge of other Civs'' desires:'
WHERE Tag = 'TXT_KEY_LEAGUE_OVERVIEW_VOTE_OPINIONS';

UPDATE Language_en_US
SET Text = '[NEWLINE][NEWLINE]Civilizations positively affected by this:'
WHERE Tag = 'TXT_KEY_LEAGUE_OVERVIEW_PROPOSAL_OPINIONS_POSITIVE';

UPDATE Language_en_US
SET Text = '[NEWLINE][NEWLINE]Civilizations negatively affected by this:'
WHERE Tag = 'TXT_KEY_LEAGUE_OVERVIEW_PROPOSAL_OPINIONS_NEGATIVE';

------------------------------------------------
-- Leader screen
------------------------------------------------
UPDATE Language_en_US
SET Text = 'You cannot negotiate peace with this player for another {1_Num} {1_Num: plural 1?turn; other?turns;} because of a deal you made with another player.'
WHERE Tag = 'TXT_KEY_DIPLO_NEGOTIATE_PEACE_BLOCKED_TT';

------------------------------------------------
-- Trade screen
------------------------------------------------
UPDATE Language_en_US
SET Text = 'Unlocks advanced trade options with this Civilization and reveals the location of their Capital.'
WHERE Tag = 'TXT_KEY_DIPLO_ALLOW_EMBASSY_TT';

UPDATE Language_en_US
SET Text = 'Allows the other player''s military or civilian Units to pass through one''s territory (lasts {1_Num} turns).[NEWLINE][NEWLINE]Note: Military Units belonging to different players may never stack.'
WHERE Tag = 'TXT_KEY_DIPLO_OPEN_BORDERS_TT';

UPDATE Language_en_US
SET Text = 'If either player is attacked by another major civilization, the other player will immediately and automatically go to war with the aggressor. This agreement lasts {1_Num} turns.[NEWLINE][NEWLINE]You can make Defensive Pacts with a maximum of [COLOR_CYAN]{2_Num}[ENDCOLOR] civs. This is based on the number of living, non-vassal civs in the world.'
WHERE Tag = 'TXT_KEY_DIPLO_DEF_PACT_TT';

UPDATE Language_en_US
SET Text = 'We already have an Embassy in their Capital!'
WHERE Tag = 'TXT_KEY_DIPLO_ALLOW_EMBASSY_HAVE';

UPDATE Language_en_US
SET Text = 'They already have an Embassy in our Capital!'
WHERE Tag = 'TXT_KEY_DIPLO_ALLOW_EMBASSY_THEY_HAVE';

UPDATE Language_en_US
SET Text = 'You do not have the Technology to establish an Embassy (Writing).'
WHERE Tag = 'TXT_KEY_DIPLO_ALLOW_EMBASSY_NO_TECH_PLAYER';

UPDATE Language_en_US
SET Text = 'They do not have the Technology to establish an Embassy (Writing).'
WHERE Tag = 'TXT_KEY_DIPLO_ALLOW_EMBASSY_NO_TECH_OTHER_PLAYER';

UPDATE Language_en_US
SET Text = 'We are already allowing Open Borders!'
WHERE Tag = 'TXT_KEY_DIPLO_OPEN_BORDERS_HAVE';

UPDATE Language_en_US
SET Text = 'They are already allowing Open Borders!'
WHERE Tag = 'TXT_KEY_DIPLO_OPEN_BORDERS_THEY_HAVE';

UPDATE Language_en_US
SET Text = 'Neither player yet has the Technology to trade this item (Civil Service).'
WHERE Tag = 'TXT_KEY_DIPLO_OPEN_BORDERS_NO_TECH';

UPDATE Language_en_US
SET Text = 'You need an Embassy with their Civilization to trade this item.'
WHERE Tag = 'TXT_KEY_DIPLO_YOU_NEED_EMBASSY_TT';

UPDATE Language_en_US
SET Text = 'They need an Embassy with your Civilization to trade this item.'
WHERE Tag = 'TXT_KEY_DIPLO_THEY_NEED_EMBASSY_TT';

UPDATE Language_en_US
SET Text = 'Both parties need an Embassy to trade this item.'
WHERE Tag = 'TXT_KEY_DIPLO_BOTH_NEED_EMBASSY_TT';

UPDATE Language_en_US
SET Text = 'We already have a Defensive Pact!'
WHERE Tag = 'TXT_KEY_DIPLO_DEF_PACT_EXISTS';

UPDATE Language_en_US
SET Text = 'Neither player yet has the Technology to trade this item (Chivalry).'
WHERE Tag = 'TXT_KEY_DIPLO_DEF_PACT_NO_TECH';

UPDATE Language_en_US
SET Text = 'We already have a Research Agreement!'
WHERE Tag = 'TXT_KEY_DIPLO_RESCH_AGREEMENT_EXISTS';

UPDATE Language_en_US
SET Text = 'One or both of us have already researched all Technologies.'
WHERE Tag = 'TXT_KEY_DIPLO_RESCH_AGREEMENT_ALL_TECHS_RESEARCHED';

UPDATE Language_en_US
SET Text = 'Neither player yet has the Technology to trade this item (Philosophy).'
WHERE Tag = 'TXT_KEY_DIPLO_RESCH_AGREEMENT_NO_TECH';

UPDATE Language_en_US
SET Text = 'A Declaration of Friendship is needed to trade this item.'
WHERE Tag = 'TXT_KEY_DIPLO_NEED_DOF_TT';

UPDATE Language_en_US
SET Text = 'A City-State Alliance prevents this action.'
WHERE Tag = 'TXT_KEY_DIPLO_MINOR_ALLY_AT_WAR';

UPDATE Language_en_US
SET Text = 'A City-State Alliance prevents this action.'
WHERE Tag = 'TXT_KEY_DIPLO_NO_WAR_ALLIES';

UPDATE Language_en_US
SET Text = 'A recent Peace Treaty prevents this action.'
WHERE Tag = 'TXT_KEY_DIPLO_FORCE_PEACE';

UPDATE Language_en_US
SET Text = 'We have no tradeable cities and/or we do not have an Embassy with them.'
WHERE Tag = 'TXT_KEY_DIPLO_TO_TRADE_CITY_NO_TT';

UPDATE Language_en_US
SET Text = 'They have no tradeable cities and/or they do not have an Embassy with us.'
WHERE Tag = 'TXT_KEY_DIPLO_TO_TRADE_CITY_NO_THEM';

------------------------------------------------
-- Discussion/Dialogue options
------------------------------------------------
UPDATE Language_en_US
SET Text = 'Our Declaration of Friendship must end.'
WHERE Tag = 'TXT_KEY_DIPLO_DISCUSS_MESSAGE_END_WORK_WITH_US';

UPDATE Language_en_US
SET Text = 'Impossible. You go too far.'
WHERE Tag = 'TXT_KEY_DIPLO_DISCUSS_HOW_DARE_YOU';

------------------------------------------------
-- Banner message
------------------------------------------------
UPDATE Language_en_US
SET Text = 'Your Merchant of Venice bought a City-State!'
WHERE Tag = 'TXT_KEY_VENETIAN_MERCHANT_BOUGHT_CITY_STATE';