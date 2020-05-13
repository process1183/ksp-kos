// Boot script for the SLS III
// https://github.com/process1183/ksp-kos
// Copyright (C) 2020  Josh Gadeken
// License: GPLv3

set launch_script to "sls3_launch.ks".

// Only run firstboot when on launchpad or runway
if ship:status = "prelaunch" {
    set to_copy to list(
        launch_script,
        "circularize_orbit.ks",
        "exenode.ks"
    ).

    runpath("0:/firstboot.ks", to_copy).
}

print ship:name + " ready.".

// Run launch script if on launchpad or runway
if ship:status = "prelaunch" {
    print "Press ENTER to launch " + ship:name.
    wait until terminal:input:getchar() = terminal:input:RETURN.
    runpath(launch_script).
}
