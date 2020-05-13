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


// vis-viva equation
// https://en.wikipedia.org/wiki/Vis-viva_equation
function vis_viva {
    parameter u. // standard gravitational parameter
    parameter r. // distance at which the speed is to be calculated
    parameter a. // length of the semi-major axis of the elliptical orbit

    return sqrt(u * (2/r - 1/a)).
}
