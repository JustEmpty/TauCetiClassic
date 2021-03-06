/atom/movable/proc/waddle(waddle_angle, waddle_height)
	var/matrix/old_transform = transform
	var/old_pixel_z = pixel_z
	animate(src, pixel_z = pixel_z + waddle_height, time = 0)
	animate(pixel_z = old_pixel_z, transform = turn(transform, waddle_angle), time=2)
	animate(transform = old_transform, time = 0)

	SEND_SIGNAL(src, COMSIG_MOVABLE_WADDLE, waddle_angle, waddle_height)

/atom/movable/proc/can_waddle()
	return !anchored

/mob/can_waddle()
	return !notransform && !anchored && !incapacitated()


/*
 * This component is used to cause things to waddle on given signals.
 */
/datum/component/waddle
	// The height to which the thing will waddle.
	var/waddle_height
	// All angles that can be acquired during waddling.
	var/list/waddle_angles

/datum/component/waddle/Initialize(_waddle_height, _waddle_angles, list/waddle_on)
	if(!istype(parent, /atom/movable))
		return COMPONENT_INCOMPATIBLE

	waddle_height = _waddle_height
	waddle_angles = _waddle_angles

	RegisterSignal(parent, waddle_on, .proc/try_waddle)

/datum/component/waddle/proc/try_waddle(atom/movable/AM, dir)
	var/atom/movable/waddler = parent
	if(waddler.can_waddle())
		var/waddle_angle = pick(waddle_angles)
		waddler.waddle(waddle_angle, waddle_height)
