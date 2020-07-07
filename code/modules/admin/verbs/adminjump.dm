/mob/proc/on_mob_jump()
	return

/mob/abstract/observer/on_mob_jump()
	stop_following()

/client/proc/Jump(var/area/A in all_areas)
	set name = "Jump to Area"
	set desc = "Area to jump to"
	set category = "Admin"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG|R_DEV))
		return
	
	if(istype(usr, /mob/abstract/new_player))
		return

	if(config.allow_admin_jump)
		usr.on_mob_jump()
		usr.forceMove(pick(get_area_turfs(A)))

		log_admin("[key_name(usr)] jumped to [A]", admin_key=key_name(usr))
		message_admins("[key_name_admin(usr)] jumped to [A]", 1)
		feedback_add_details("admin_verb","JA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else
		alert("Admin jumping disabled")

/client/proc/jumptoturf(var/turf/T in turfs)
	set name = "Jump to Turf"
	set category = "Admin"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG|R_DEV))
		return

	if(isnewplayer(usr))
		return

	if(config.allow_admin_jump)
		log_admin("[key_name(usr)] jumped to [T.x],[T.y],[T.z] in [T.loc]",admin_key=key_name(usr))
		message_admins("[key_name_admin(usr)] jumped to [T.x],[T.y],[T.z] in [T.loc]", 1)
		usr.on_mob_jump()
		usr.forceMove(T)
		feedback_add_details("admin_verb","JT") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else
		alert("Admin jumping disabled")
	return

/client/proc/jumptomob(var/mob/M in mob_list)
	set category = "Admin"
	set name = "Jump to Mob Admin"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG|R_DEV))
		return

	if(isnewplayer(usr))
		return

	if(config.allow_admin_jump)
		log_admin("[key_name(usr)] jumped to [key_name(M)]", admin_key=key_name(usr),ckey=key_name(M))
		message_admins("[key_name_admin(usr)] jumped to [key_name_admin(M)]", 1)
		if(src.mob)
			var/mob/A = src.mob
			var/turf/T = get_turf(M)
			if(isturf(T))
				feedback_add_details("admin_verb","JM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
				A.on_mob_jump()
				A.forceMove(T)
			else
				to_chat(A, "This mob is not located in the game world.")
	else
		alert("Admin jumping disabled")

/client/proc/jumptocoord(tx as num, ty as num, tz as num)
	set category = "Admin"
	set name = "Jump to Coordinate"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG|R_DEV))
		return

	if (config.allow_admin_jump)
		if(src.mob)
			var/mob/A = src.mob
			A.on_mob_jump()
			A.x = tx
			A.y = ty
			A.z = tz
			feedback_add_details("admin_verb","JC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		message_admins("[key_name_admin(usr)] jumped to coordinates [tx], [ty], [tz]")

	else
		alert("Admin jumping disabled")

/client/proc/jumptokey()
	set category = "Admin"
	set name = "Jump to Key"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG|R_DEV))
		return

	if(config.allow_admin_jump)
		var/list/keys = list()
		for(var/mob/M in player_list)
			keys += M.client
		var/selection = input("Please, select a player!", "Admin Jumping", null, null) as null|anything in sortKey(keys)
		if(!selection)
			to_chat(src, "No keys found.")
			return
		var/mob/M = selection:mob
		log_admin("[key_name(usr)] jumped to [key_name(M)]",admin_key=key_name(usr),ckey=key_name(M))
		message_admins("[key_name_admin(usr)] jumped to [key_name_admin(M)]", 1)
		usr.on_mob_jump()
		usr.forceMove(M.loc)
		feedback_add_details("admin_verb","JK") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else
		alert("Admin jumping disabled")

/client/proc/Getmob(var/mob/M in mob_list)
	set category = "Admin"
	set name = "Get Mob"
	set desc = "Mob to teleport"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return
	if(config.allow_admin_jump)
		log_admin("[key_name(usr)] teleported [key_name(M)]",admin_key=key_name(usr),ckey=key_name(M))
		message_admins("[key_name_admin(usr)] teleported [key_name_admin(M)]", 1)
		M.on_mob_jump()
		M.forceMove(get_turf(usr))
		feedback_add_details("admin_verb","GM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else
		alert("Admin jumping disabled")

/client/proc/Getkey()
	set category = "Admin"
	set name = "Get Key"
	set desc = "Key to teleport"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	if(config.allow_admin_jump)
		var/list/keys = list()
		for(var/mob/M in player_list)
			keys += M.client
		var/selection = input("Please, select a player!", "Admin Jumping", null, null) as null|anything in sortKey(keys)
		if(!selection)
			return
		var/mob/M = selection:mob

		if(!M)
			return
		log_admin("[key_name(usr)] teleported [key_name(M)]",admin_key=key_name(usr),ckey=key_name(M))
		message_admins("[key_name_admin(usr)] teleported [key_name(M)]", 1)
		if(M)
			M.on_mob_jump()
			M.forceMove(get_turf(usr))
			feedback_add_details("admin_verb","GK") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else
		alert("Admin jumping disabled")

/client/proc/sendmob(var/mob/M in sortmobs())
	set category = "Admin"
	set name = "Send Mob"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return
	var/area/A = input(usr, "Pick an area.", "Pick an area") in all_areas
	if(A)
		if(config.allow_admin_jump)
			M.on_mob_jump()
			M.forceMove(pick(get_area_turfs(A)))
			feedback_add_details("admin_verb","SMOB") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

			log_admin("[key_name(usr)] teleported [key_name(M)] to [A]",admin_key=key_name(usr),ckey=key_name(M))
			message_admins("[key_name_admin(usr)] teleported [key_name_admin(M)] to [A]", 1)
		else
			alert("Admin jumping disabled")
