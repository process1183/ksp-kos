// Deploy payload, then deorbit the SLS III
// https://github.com/process1183/ksp-kos
// Copyright (C) 2020  Josh Gadeken
// License: GPLv3

runoncepath("/lib/util.ks").

// Name of payload vessel once deployed.
parameter payload_vessel_name.

// Distance in meters that the launch vehicle should be
// from the payload before activating the payload.
parameter payload_activation_distance is 50.

// Activation message to send to payload.
parameter payload_activation_message is "activate".



print "Deploying payload and deorbiting launch vehicle...".

if sas {
    sas off.
    print "SAS disabled.".
}

shutdown_engine("MainEngine").
print "Main engine shutdown.".

print "Turning ship to prograde...".
lock steering to lookdirup(ship:prograde:vector, ship:facing:topvector).
wait until vang(ship:prograde:vector, ship:facing:vector) < 0.25.
print "done.".

stage. // Stage 0. Decouple payload and activate Ant engines

wait 0.1.

lock throttle to 1.0.

set payload to vessel(payload_vessel_name).

set target to payload.
print "Waiting until " + payload_activation_distance + "m from payload...".
wait until target:distance >= payload_activation_distance.
lock throttle to 0.
set target to "".

set pc to payload:connection.
if pc:sendmessage(payload_activation_message) {
    print "Activation message sent to " + payload:name + ".".
} else {
    print "ERROR! Failed to send activation message to " + payload:name + "!".
}

shutdown_engine("AntEngine").
print "Ant engines shutdown.".

activate_engine("MainEngine").
print "Main engine activated.".

print "Turning ship to retrograde...".
lock steering to lookdirup(ship:retrograde:vector, ship:facing:topvector).
wait until vang(ship:retrograde:vector, ship:facing:vector) < 0.25.
print "done.".

lock throttle to 1.0.
print "Lowering periapsis to 0m...".
wait until ship:periapsis <= 0.
lock throttle to 0.
print "done.".

unlock steering.
unlock throttle.
set ship:control:pilotmainthrottle to 0.
print "Steering and throttle unlocked.".

print "bye.".
