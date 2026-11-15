# An interactive shell's syntax errors name no line, nor quote it, but
# bash's children are not interactive: a subshell, pipeline stage, job,
# coprocess or command or process substitution names its line, though
# not in a warning. A syntax error in a command substitution in eval or
# a sourced file discards that line and goes on with the next. At the
# prompt each level of command substitution it was within adds one more
# "syntax error". Afterward the parser looks for no closing `)' or `}'
# that was open, and in eval a later plain syntax error ends it. (Lines
# typed begin with a space, so that bash's echo of them on a
# non-terminal can be removed.)
exec 2>&1
cmds=(
    ' echo A; eval "(<)"'
    ' echo B; ( eval "(<)" )'
    ' echo C; echo $(eval "(<)")'
    ' echo D; { eval "(<)"; } | cat'
    ' echo E; ( eval "cat <<." )'
    ' echo F; $((<)#); echo $?'
    ' echo G; ( $((<)#) )'
    ' echo H; f() { eval "(<)"; }; f'
    ' echo I; eval "(<)" | cat'
    ' echo J; eval "(<)" & wait'
    ' echo K; coproc { eval "(<)"; }; wait'
    ' echo L; cat <(eval "(<)")'
    ' echo M; eval "x=\$(eval (<) )"; echo $?'
    " eval '\$( (<) ); echo no"
    " echo yes'; echo \$?"
    " printf '%s\\n' '\$( (<) ); echo no' 'echo yes' >sourced; . ./sourced"
    ' ( eval "\$( (<) )"; echo no ); echo $?'
    ' echo $( (<) ) no'
    ' echo $( echo $( (<) ) ) no'
    ' echo ${ (<); } no'
    ' echo $( if ) no'
    ' echo ${x:-$( (<) )} no'
    ' echo $( : ) $( echo $( : ) ) ) no'
    ' if;'
    ' $(;'
    ' if;'
    ' echo $( $(; )'
    ' if;'
    ' echo ${ echo $(; }'
    ' if;'
    " eval 'echo \$(;"
    "if;"
    "echo no'; echo \$?"
    ' x=$( (<'
    ' echo end'
)
printf '%s\n' "${cmds[@]}" >cmds
PS1= PS2= bash -i <cmds 2>&1 | sed '/^ /d; /tcsetattr/d; /^\[1\] /d; /job control/d; /terminal process group/d'
