// Boot script for the SLS III
// https://github.com/process1183/ksp-kos
// Copyright (C) 2020  Josh Gadeken
// License: GPLv3

set launch_script to "launch.ks".
set to_copy to lexicon().
to_copy:add("sls3_launch.ks", launch_script).
to_copy:add("circularize_orbit.ks", "circularize_orbit.ks").

runpath("0:/common_boot.ks", to_copy).

print "Press ENTER to launch " + ship:name.
wait until terminal:input:getchar() = terminal:input:RETURN.
runpath(launch_script).
