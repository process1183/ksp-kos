// Utility functions
// https://github.com/process1183/ksp-kos
// Copyright (C) 2020  Josh Gadeken
// License: GPLv3

runoncepath("/lib/math.ks").



// Wrapper around map() for converting velocity to pitch.
// This wrapper is needed because if current_velocity is outside the range
// of velocity_min and velocity_max, the resulting pitch will also be
// outside the range of pitch_min and pitch_max.
function velocity_to_pitch {
    parameter current_velocity. // Scalar
    parameter velocity_min. // Scalar
    parameter velocity_max. // Scalar
    parameter pitch_min. // Scalar
    parameter pitch_max. // Scalar

    if current_velocity < velocity_min {
        return pitch_min.
    }
    if current_velocity > velocity_max {
        return pitch_max.
    }

    return round(map(current_velocity, velocity_min, velocity_max, pitch_min, pitch_max)).
}


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
