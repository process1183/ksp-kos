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


// Perform an action on engine modules with the specified nametag.
// https://ksp-kos.github.io/KOS/structures/vessels/partmodule.html#method:PARTMODULE:DOACTION
// https://ksp-kos.github.io/KOS/general/nametag.html
function emod_action {
    parameter nametag.
    parameter action_name.
    parameter action_bool.
    parameter verbose.

    for engine in ship:partstagged(nametag) {
        if engine:hasmodule("ModuleEngines") {
            set emod to engine:getmodule("ModuleEngines").
        } else if engine:hasmodule("ModuleEnginesFX") {
            set emod to engine:getmodule("ModuleEnginesFX").
        } else {
            print "Error! " + engine:tag + "does not have a 'ModuleEngines' or 'ModuleEnginesFX' module!".
            return.
        }

        emod:doaction(action_name, action_bool).

        if verbose {
            print engine:tag + ": " + action_name + ": " + action_bool.
        }
    }
}


// Shutdown all engines with the specified nametag.
// https://ksp-kos.github.io/KOS/general/nametag.html
function shutdown_engine {
    parameter nametag.
    parameter verbose is false.

    emod_action(nametag, "shutdown engine", true, verbose).
}


// Activate all engines with the specified nametag.
// https://ksp-kos.github.io/KOS/general/nametag.html
function activate_engine {
    parameter nametag.
    parameter verbose is false.

    emod_action(nametag, "activate engine", true, verbose).
}


// Countdown from `t` to 0 in 1 second decrements
function countdown {
    parameter t.

    from {local i is round(t).} until i <= 0 step {set i to i - 1.} do {
        print "T-" + i.
        wait 1.
    }
}
