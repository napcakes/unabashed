# personality: native
# Hand-checked against w64devkit's busybox sh (#9): an explicit path
# without an extension is run, described and typed with busybox-w32's
# extension added (add_win32_extension), also beside a file of the bare
# name that cannot run. A bare name that can run is taken as is.
p=C:/w64/bin/argv
"$p" x && echo runs
command -v "$p"
command -V "$p"
type "$p"
type -P "$p"
type -t "$p"
command -v C:/w64/bin/ARGV
cd C:/work
printf 'echo noshebang\n' >y
cp C:/w64/bin/argv.exe y.exe
./y q
echo "status $?"
command -v ./y
: >w
cp C:/w64/bin/argv.exe w.exe
command -v ./w
printf '#!/bin/sh\necho bare\n' >x
cp C:/w64/bin/argv.exe x.exe
./x
command -v ./x
printf 'echo s\n' >s.sh
command -v ./s
