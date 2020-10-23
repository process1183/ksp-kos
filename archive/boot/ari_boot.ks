// Boot script for Ari
// https://github.com/process1183/ksp-kos
// Copyright (C) 2020  Josh Gadeken
// License: GPLv3

// Only run firstboot when on launchpad or runway
if ship:status = "prelaunch" {
    set to_copy to list(
        "circularize_orbit.ks",
        "exenode.ks"
    ).

    runpath("0:/firstboot.ks", to_copy).
}

print ship:name + " ready.".
