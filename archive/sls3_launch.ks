// SLS III launch script
// https://github.com/process1183/ksp-kos
// Copyright (C) 2020  Josh Gadeken
// License: GPLv3

runoncepath("/lib/util.ks").



print "Launching SLS III...".

if sas {
    sas off.
    print "SAS disabled.".
}

// Point ship to `pitch` degrees above the horizon, keeping current roll value
// https://ksp-kos.github.io/KOS/math/direction.html#function:LOOKDIRUP
set pitch to 90.
lock steering to lookdirup(heading(90, pitch):vector, ship:facing:topvector).
lock throttle to 0.

// Countdown
from {local i is 10.} until i = 0 step {set i to i - 1.} do {
    print "T-" + i.
    wait 1.
}

stage. // Stage 3, SRBs
print "Liftoff!".

wait 0.5. // Delay to allow SRBs to actually fire

until ship:maxthrust = 0 {
    // Gradually turn ship starting at 50m/s and 90 degrees, and stop
    // turning at 800m/s and 20 degrees
    set pitch to velocity_to_pitch(ship:velocity:surface:mag, 50, 800, 90, 20).
    WAIT 0.001.
}

print "SRBs exhausted.".
stage. // Stage 2, Decouple SRBs and activate Terrier LFE

// Point ship to prograde, keeping current roll value
// https://ksp-kos.github.io/KOS/math/direction.html#function:LOOKDIRUP
lock steering to lookdirup(ship:prograde:vector, ship:facing:topvector).

set wait_alt to 70_000.
print "Waiting until altitude is above " + wait_alt + "m...".
wait until ship:altitude > wait_alt.
stage. // Stage 1, Deploy fairing (shed extra weight).

print "Extending solar panels...".
for sp in ship:partstagged("SolarPanel") {
    set sp_module to sp:getmodule("ModuleDeployableSolarPanel").
    sp_module:doaction("extend solar panel", true).
}

unlock steering.
unlock throttle.
set ship:control:pilotmainthrottle to 0.
print "Steering and throttle unlocked.".

sas on.
wait 0.5.
set sasmode to "prograde".
print "SAS set to '" + sasmode + "'.".

runpath("/circularize_orbit.ks").
