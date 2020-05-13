// Execute a maneuver node
// https://github.com/process1183/ksp-kos
// Copyright (C) 2020  Josh Gadeken
// License: GPLv3

runoncepath("/lib/math.ks").
runoncepath("/lib/util.ks").

// Extra time before burn start to allow for ship turning
parameter prepare_time is 30.

// Remove maneuver node once executed?
parameter rmn is true.



print "Executing maneuver node...".
print "Node in: " + round(nextnode:eta, 2) + "s, Delta-V: " + round(nextnode:deltav:mag, 3) + "m/s".

// Calculate burn time for this maneuver
set engs to get_active_engines().
set cisp to combined_isp(engs).
set ve to exhaust_velocity(cisp).
set cat to combined_available_thrust(engs).
set burn_t to burn_time(ship:mass, ve, cat, nextnode:deltav:mag).
print "Maneuver burn time: " + round(burn_t, 2) + "s".

print "Waiting until " + prepare_time + " seconds to burn start...".
wait until nextnode:eta <= (burn_t / 2 + prepare_time).

set initial_sas_state to SAS.
set initial_sas_mode to SASMODE.
if initial_sas_state {
    sas off.
    print "SAS disabled.".
}

print "Aligning ship to burn vector...".

// Point ship to node, keeping roll value
lock steering to lookdirup(nextnode:deltav, ship:facing:topvector).
wait until vang(steering:vector, ship:facing:vector) < 0.25.

print "Ship aligned to burn vector. Burn in T-" + round(nextnode:eta, 2) + "s".
wait until nextnode:eta <= (burn_t / 2).

print "Initiating burn.".

lock throttle to 1.0.
wait burn_t.
lock throttle to 0.

print "Burn complete.".

unlock steering.
unlock throttle.
set ship:control:pilotmainthrottle to 0.
print "Steering and throttle unlocked.".

if rmn {
    remove nextnode.
    print "Maneuver node removed.".
}

if initial_sas_state {
    sas on.
    wait 0.5.
    set sasmode to initial_sas_mode.
    print "SAS mode '" + initial_sas_mode + "' enabled.".
}
