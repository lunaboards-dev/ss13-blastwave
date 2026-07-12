/datum/sc_holder/tty
	var/datum/sc_holder/computer/owner
	var/obj/holder

	proc/OpenTerminal(mob/user, datum/tgui/ui)
		// hoh
		ui = SStgui.try_update_ui(user, holder, ui)
		if (!ui)
			ui = new(user, holder, "SCTerminalInterface")
			ui.open()

	proc/TguiData(mob/user)
		var/list/data = list(
			"id" = id,
			"url" = SSspesscomputers.ws_url,
			"port" = SSspesscomputers.ws_port,
			"local" = TRUE
		)
		return data

/datum/sc_holder/tty/New(obj/dev)
	holder = dev
