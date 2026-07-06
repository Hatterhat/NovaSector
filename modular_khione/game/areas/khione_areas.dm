/area/khione
	name = "Khione Location Basetype Do Not Fucking Use"
	icon = 'icons/area/areas_away_missions.dmi'
	icon_state = "away"
	default_gravity = STANDARD_GRAVITY
	ambience_index = AMBIENCE_AWAY
	sound_environment = SOUND_ENVIRONMENT_FOREST

/area/khione/outside
	name = "Khione Location Outdoors Basetype Do Not Fucking Use"

/area/khione/outside/wilderness
	name = "Khione Wilderness"
	icon_state = "away2"
	requires_power = FALSE
	static_lighting = TRUE
	ambientsounds = list('modular_khione/soundambience/breeze1.ogg',\
						'modular_khione/soundambience/breeze2.ogg',\
						'modular_khione/soundambience/breeze3.ogg',\
						'modular_khione/soundambience/breeze4.ogg',\
						'modular_khione/soundambience/breeze5.ogg',\
						'modular_khione/soundambience/breeze6.ogg')

/area/khione/indoors
	name = "Khione Location Indoors Basetype Do Not Fucking Use"
	sound_environment = SOUND_ENVIRONMENT_ROOM

/area/khione/indoors/grant_residence
	name = "Grant Residence"
	icon_state = "away1"
	requires_power = TRUE
	ambientsounds = list ('modular_khione/sound/ambience/silence.ogg')
