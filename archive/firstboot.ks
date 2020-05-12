// Shared boot code for ships. Not placed in /boot to avoid being presented
// as a boot option in-game.
// https://github.com/process1183/ksp-kos
// Copyright (C) 2020  Josh Gadeken
// License: GPLv3

// List of files to copy from the archive
parameter copy_files.

// Copy /lib/ directory to ship?
parameter incl_lib is true.



print "Initializing " + ship:name + "...".

if incl_lib {
    copy_files:add("lib/").
}

print "Copying files from Archive...".
for f in copy_files {
    set src to "0:/" + f.
    print "'" + src + "' -> '" + f + "'".
    copypath(src, f).
}

print "done.".
