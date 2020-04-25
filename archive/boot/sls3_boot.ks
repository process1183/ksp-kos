// Boot script for the SLS III
// Copyright (C) 2020  Josh Gadeken
// https://github.com/process1183/ksp-kos
// License: GPLv3



set to_copy to lexicon().
// to_copy:add("<source file in archive>", "<destination file on ship>").


runpath("0:/common_boot.ks", to_copy, true).
