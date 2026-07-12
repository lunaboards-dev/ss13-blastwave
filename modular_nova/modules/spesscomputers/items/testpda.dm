/obj/item/sc_test_pda
	name = "SpessComputers test PDA"
	desc = "Hopefully it doesn't explode."
	icon = 'icons/obj/machines/computer.dmi'
	icon_state = "laptop"
	var/datum/sc_holder/tty/tty_holder

/obj/item/sc_test_pda/New()
	..()
	tty_holder = SSspesscomputers.CreateTTY(src)

/obj/item/sc_test_pda/ui_interact(mob/user, datum/tgui/ui)
	tty_holder.OpenTerminal(user, ui)

/obj/item/sc_test_pda/ui_data(mob/user)
	return tty_holder.TguiData(user)

/obj/item/ui_act()
	..()
