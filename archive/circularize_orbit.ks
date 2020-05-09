// Circularize orbit by adding and executing a maneuver node at either
// the apoapsis or periapsis to alter the other apsis.
// https://github.com/process1183/ksp-kos
// Copyright (C) 2020  Josh Gadeken
// License: GPLv3

runoncepath("/lib/math.ks").

// Apsis you want to set the circular orbit to.
// E.g. specifying "apoapsis" will create a maneuver
// node at the apoapsis to adjust the periapsis to
// match the existing apoapsis.
// Valid options are "apoapsis" or "periapsis".
// Invalid options will be ignored and the default of
// "apoapsis" will be used.
parameter apsis is "apoapsis".

// Planet or moon craft is orbiting. Defaults to the body the vessel
// is currently orbiting.
// Example options: kerbin, mun, duna
// https://ksp-kos.github.io/KOS/structures/celestial_bodies/body.html
parameter celestial_body is ship:obt:body.



if apsis = "periapsis" {
    set apsis_ref to lexicon("name", "Periapsis", "eta", eta:periapsis, "alt", alt:periapsis).
    set apsis_tgt to lexicon("name", "Apoapsis", "eta", eta:apoapsis, "alt", alt:apoapsis).
} else {
    set apsis_ref to lexicon("name", "Apoapsis", "eta", eta:apoapsis, "alt", alt:apoapsis).
    set apsis_tgt to lexicon("name", "Periapsis", "eta", eta:periapsis, "alt", alt:periapsis).
}

print "Altering " + apsis_tgt:name + " to circularize orbit around " + celestial_body:name + "...".
print apsis_ref:name + " ETA: " + round(apsis_ref:eta, 2) + "s".

set orbit_r to apsis_ref:alt + celestial_body:radius.
print "Orbital radius: " + round(orbit_r, 2) + "m".

set orbit_a to (apsis_ref:alt + apsis_tgt:alt) / 2 + celestial_body:radius.
print "Semi-major axis: " + round(orbit_a, 2) + "m".

set apsis_ref:velocity to vis_viva(celestial_body:mu, orbit_r, orbit_a).
print apsis_ref:name + " velocity: " + round(apsis_ref:velocity, 2) + "m/s".

set circular_orbit_v to vis_viva(celestial_body:mu, orbit_r, orbit_r).
print "Circular orbit velocity: " + round(circular_orbit_v, 2) + "m/s".

set delta_v to circular_orbit_v - apsis_ref:velocity.
print "Delta-V: " + round(delta_v, 2) + "m/s".

set circularize_node to node(time():seconds + apsis_ref:eta, 0, 0, delta_v).
add circularize_node.
print "Maneuver node added to flight plan.".
