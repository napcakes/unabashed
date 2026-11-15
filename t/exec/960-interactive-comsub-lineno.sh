# An interactive shell, outside a sourced file, numbers the lines of a
# command substitution from 1 when it parses the text again to run it,
# and a ${ ...; } from 2: at the top level, in functions, eval and
# loops, and in a simple command run as a pipeline stage or in the
# background. A child it forks for a ( ), command or process
# substitution, compound command or coprocess is not interactive and
# goes on from the current line, as does a sourced file. So does a
# shell reading a script. (Lines typed begin with a space, so that
# bash's echo of them on a non-terminal can be removed.)
exec 2>&1
cmds=(
    ' true'
    ' echo a $LINENO $(echo $LINENO) `echo $LINENO`'
    ' echo b $(true; echo $(echo $LINENO))'
    ' echo c $(true'
    ' true'
    ' echo $(echo $LINENO))'
    ' echo d $('
    ' echo $LINENO)'
    ' ( true; echo e $(echo $LINENO) )'
    ' { true; echo f $(echo $LINENO); } | cat'
    ' { echo g $(echo $LINENO); } & wait'
    ' echo h $(echo $LINENO) | cat'
    ' echo i $(echo $LINENO) & wait'
    ' coproc { echo j $(echo $LINENO); }; cat <&${COPROC[0]}; wait'
    ' cat <(echo k $(echo $LINENO))'
    ' g() { echo l $(echo $LINENO); }'
    ' g'
    " eval 'echo m \$(echo \$LINENO)'"
    ' for x in 1; do echo n $(echo $LINENO); done'
    ' echo p ${ echo $LINENO; } ${| REPLY=$LINENO; }'
    ' echo q ${ true'
    ' echo $LINENO; }'
    ' echo r $( (true'
    ' echo $LINENO) )'
    " echo 'true; echo s \$(echo \$LINENO)' >sourced"
    ' true; . ./sourced'
    ' echo $((<<.)#)'
    ' echo $((<<.)#)'
)
printf '%s\n' "${cmds[@]}" >cmds
PS1= PS2= bash -i <cmds 2>&1 | sed '/^ /d; /tcsetattr/d; /^\[1\] /d; /job control/d; /terminal process group/d'
echo ---
printf '%s\n' "${cmds[@]}" >script
bash script
