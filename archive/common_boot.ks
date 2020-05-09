// Shared boot code for ships. Not placed in /boot to avoid being presented
// as a boot option in-game.
// https://github.com/process1183/ksp-kos
// Copyright (C) 2020  Josh Gadeken
// License: GPLv3

// Lexicon of source archive file names and destination ship file names.
// copy_files:add("<source file in archive>", "<destination file on ship>").
parameter copy_files.

// Copy /lib/ directory to ship?
parameter incl_lib is true.



print "Initializing " + ship:name + "...".

copy_files:add("common_boot.ks", "common_boot.ks").

if incl_lib {
    // https://ksp-kos.github.io/KOS/commands/files.html#copypath-frompath-topath
    copy_files:add("lib/", "lib/").
}

print "Copying files from Archive...".
for f in copy_files:keys {
    set src to "0:/" + f.
    print "'" + src + "' -> '" + copy_files[f] + "'".
    copypath(src, copy_files[f]).
}

print "done.".
