// Math functions
// https://github.com/process1183/ksp-kos
// Copyright (C) 2020  Josh Gadeken
// License: GPLv3



// KerboScript version of Arduino's map() function
// https://www.arduino.cc/reference/en/language/functions/math/map/
function map {
    parameter x. // the number to map
    parameter in_min. // the lower bound of the value's current range
    parameter in_max. // the upper bound of the value's current range
    parameter out_min. // the lower bound of the value's target range
    parameter out_max. // the upper bound of the value's target range

    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min.
}


// Wrapper around map() that clamps the output to out_min or out_max
// if the input (x) is less than in_min or greater than in_max.
function clamped_map {
    parameter x. // the number to map
    parameter in_min. // the lower bound of the value's current range
    parameter in_max. // the upper bound of the value's current range
    parameter out_min. // the lower bound of the value's target range
    parameter out_max. // the upper bound of the value's target range

    if x < in_min {
        return out_min.
    }
    if x > in_max {
        return out_max.
    }

    return map(x, in_min, in_max, out_min, out_max).
}


// vis-viva equation
// https://en.wikipedia.org/wiki/Vis-viva_equation
function vis_viva {
    parameter u. // standard gravitational parameter
    parameter r. // distance at which the speed is to be calculated
    parameter a. // length of the semi-major axis of the elliptical orbit

    return sqrt(u * (2/r - 1/a)).
}


// Calculate the exhaust velocity in m/s from a given ISP
// https://en.wikipedia.org/wiki/Specific_impulse#Specific_impulse_as_effective_exhaust_velocity
function exhaust_velocity {
    parameter isp. // specific impulse in seconds

    return isp * constant:g0.
}


// Calculate the combined ISP for multiple engines
// https://wiki.kerbalspaceprogram.com/wiki/Specific_impulse#Multiple_engines
function combined_isp {
    // list of Engines, https://ksp-kos.github.io/KOS/structures/vessels/engine.html
    parameter englist.

    set sft to 0.
    set sm to 0.

    for eng in englist {
        set sft to sft + eng:possiblethrust.
        set sm to sm + (eng:possiblethrust / eng:isp).
    }

    return sft / sm.
}


// Calculate the combined available thrust for multiple engines
// https://ksp-kos.github.io/KOS/structures/vessels/engine.html#attribute:ENGINE:AVAILABLETHRUST
function combined_available_thrust {
    // list of Engines, https://ksp-kos.github.io/KOS/structures/vessels/engine.html
    parameter englist.

    set ct to 0.

    for eng in englist {
        set ct to ct + eng:availablethrust.
    }

    return ct.
}


// Calculate burn time for a given Delta-V
// https://space.stackexchange.com/questions/27375/how-do-i-calculate-a-rockets-burn-time-from-required-velocity
function burn_time {
    parameter m0. // rocket mass at beginning of burn
    parameter ve. // exhaust velocity in m/s
    parameter f. // thrust in newtons
    parameter dv. // delta-v of burn in m/s

    return ((m0 * ve) / f) * (1 - constant:e ^ (-(dv/ve))).
}
