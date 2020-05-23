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
