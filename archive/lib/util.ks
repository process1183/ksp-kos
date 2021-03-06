// Utility functions
// https://github.com/process1183/ksp-kos
// Copyright (C) 2020  Josh Gadeken
// License: GPLv3

runoncepath("/lib/math.ks").



// Return a list of all currently enabled engines
function get_active_engines {
    set ae to list().

    // https://ksp-kos.github.io/KOS/structures/vessels/engine.html
    list engines in engs.
    for eng in engs {
        if eng:availablethrust > 0 {
            ae:add(eng).
        }
    }

    return ae.
}


// Perform an action on a module of a part tagged with `nametag`
// https://ksp-kos.github.io/KOS/structures/vessels/partmodule.html#method:PARTMODULE:DOACTION
// https://ksp-kos.github.io/KOS/general/nametag.html
function part_module_action {
    parameter nametag.
    parameter modlist. // List of module names to try `action_name` on
    parameter action_name.
    parameter action_bool.
    parameter console_message.
    parameter verbose.

    if console_message {
        print console_message.
    }

    for prt in ship:partstagged(nametag) {
        set prtmod to false.

        for modname in modlist {
            if prt:hasmodule(modname) {
                set prtmod to prt:getmodule(modname).
                if verbose {
                    print "Found " + modname + " in " + prt:tag.
                }
            }
        }

        if not prtmod:istype("PartModule") {
            print "Error! '" + prt:tag + "' does not have one of the specified modules!".
            return.
        }

        prtmod:doaction(action_name, action_bool).

        if verbose {
            print prt:tag + ": " + action_name + ": " + action_bool.
        }
    }
}


// Shutdown all engines with the specified nametag.
// https://ksp-kos.github.io/KOS/general/nametag.html
function shutdown_engine {
    parameter nametag.
    parameter message is "".
    parameter verbose is false.

    part_module_action(nametag, list("ModuleEngines", "ModuleEnginesFX"), "shutdown engine", true, message, verbose).
}


// Activate all engines with the specified nametag.
// https://ksp-kos.github.io/KOS/general/nametag.html
function activate_engine {
    parameter nametag.
    parameter message is "".
    parameter verbose is false.

    part_module_action(nametag, list("ModuleEngines", "ModuleEnginesFX"), "activate engine", true, message, verbose).
}


// Extend all solar panels tagged with `nametag`
function extend_solar_panels {
    parameter nametag.
    parameter message is "".
    parameter verbose is false.

    part_module_action(nametag, list("ModuleDeployableSolarPanel"), "extend solar panel", true, message, verbose).
}


// Retract all solar panels tagged with `nametag`
function retract_solar_panels {
    parameter nametag.
    parameter message is "".
    parameter verbose is false.

    part_module_action(nametag, list("ModuleDeployableSolarPanel"), "retract solar panel", true, message, verbose).
}


// Deploy all fairings tagged with `nametag`
function deploy_fairing {
    parameter nametag.
    parameter message is "".
    parameter verbose is false.

    part_module_action(nametag, list("ModuleProceduralFairing"), "deploy", true, message, verbose).
}


// Countdown from `t` to 0 in 1 second decrements
function countdown {
    parameter t.

    from {local i is round(t).} until i <= 0 step {set i to i - 1.} do {
        print "T-" + i.
        wait 1.
    }
}


// Display `prompt` string and read user's keyboard input until
// they press Enter.
// Returns a string containing the user's typed characters.
function user_input_prompt {
    parameter prompt. // String to display before user input

    print prompt.

    set s to "".
    set c to "".

    until c = terminal:input:RETURN {
        set c to terminal:input:getchar().
        set s to s + c.

        // Echo what the user is typing.
        // This will print each character on a new line, as there is currently
        // no way to suppress a newline in the print command.
        // https://github.com/KSP-KOS/KOS/issues/2522
        // https://github.com/KSP-KOS/KOS/issues/2524
        print c.
    }

    print " ". // Print extra newline after done getting user input

    return s:trim().
}


// Prompt the user for a compass direction (0-359).
// This will keep asking until a valid direction is entered.
// Returns a Scalar.
function compass_direction_prompt {
    // String to display before user input
    parameter prompt is "Please type a compass direction (0-359) and press Enter:".

    until 0 {
        set d to user_input_prompt(prompt):tonumber(-1).

        if d < 0 or d > 359 {
            print "Invalid compass direction!".
        } else {
            return d.
        }
    }
}


// Return a list of the status strings for SRBs tagged with `nametag`
function srb_status {
    parameter nametag.

    set srbs to list().
    for srb in ship:partstagged(nametag) {
        set srbm to srb:getmodule("ModuleEnginesFX").
        srbs:add(srbm:getfield("status")).
    }

    return srbs.
}


// Return true if all SRBs tagged with `nametag` are in flame-out state.
function is_srb_flameout {
    parameter nametag.

    set flameout to true.
    for status in srb_status(nametag) {
        if status <> "Flame-Out!" {
            set flameout to false.
            break.
        }
    }

    return flameout.
}
