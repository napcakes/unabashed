# A command whose words all expand to nothing takes the status of the
# last command substitution in its words or its assignments, which
# expand after the words. A $((...)) that is no arithmetic is parsed
# again as a command substitution, so its syntax error gives 2.
$(exit 3); echo $?
`exit 4`; echo $?
$(exit 3) $(exit 5); echo $?
x=$(exit 6) $(exit 3); echo $?
$(exit 3) >/dev/null; echo $?
false; $(true); echo $?
false; $empty; echo $?
f() { $(exit 7); }; f; echo $?
$( (exit 8) ) || echo or $?
$(exit 9) && echo and || echo not $?
$((<)#); echo $?
