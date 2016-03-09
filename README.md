# Intro
This repository contains a series of short scripts which can be used in a
workshop setting to teach participants some of the tools available in R, as
well as some reproducible code
patterns.

# dplyr Example
1. Extract the export files (they start with EXP) from the .zip files to a
folder (default: `C:\TEMP\dplyr-example` or `/temp/dplyr-example`
(same thing)). Perhaps consider creating a symlink to that directory using
`ln -s` on OS X/Linux and `mklink /J` on Windows.
2. Save the `exports.csv` file to the same folder. `exports.csv` is a short
file with total monthly exports out of Brazil.
3. If you extract the files to a different folder, edit the PATH variable in
the `consolidate.r` script
4. Install packages `dplyr`, `readr`, and `TTR` in R using
`install.package('name')`
5. Source the `consolidate.r` script
6. Wait.
7. There should be a file called `dplyr-example.csv` in the PATH folder with the
results.
