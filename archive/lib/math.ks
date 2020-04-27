// Math functions
// https://github.com/process1183/ksp-kos
// Copyright (C) 2020  Josh Gadeken
// License: GPLv3



// Kerboscript version of Arduino's map() function
// https://www.arduino.cc/reference/en/language/functions/math/map/
function map {
    parameter x. // the number to map
    parameter in_min. // the lower bound of the value’s current range
    parameter in_max. // the upper bound of the value’s current range
    parameter out_min. // the lower bound of the value’s target range
    parameter out_max. // the upper bound of the value’s target range

    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min.
}
