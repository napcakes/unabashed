# Inside a function, an interactive shell outside a sourced file numbers
# lines from the function body's: for simple commands, (( )), [[ ]] and
# an arithmetic for's first expression, and in what they call (BASH_LINENO,
# caller), but not in a for, case or ( ) header. A ${ ...; } counts as a
# function, though it keeps the body's line, so at the top level its
# lines start at 2. A shell reading a script numbers the file's lines.
# Either way a signal's trap action is numbered from line 1, while DEBUG,
# ERR and RETURN keep the current line, and an arithmetic for evaluates
# its test and step at its own line. (Lines typed begin with a space, so
# that bash's echo of them on a non-terminal can be removed.)
exec 2>&1
cmds=(
    ' true'
    ' true'
    ' f() {'
    ' true'
    ' echo a $LINENO'
    ' (( x = LINENO )); echo b $x'
    ' [[ $LINENO == * ]] && echo c $LINENO'
    ' for i in $LINENO; do echo d $i; done'
    ' case $LINENO in *) echo e $LINENO;; esac'
    ' for ((y = LINENO, z = 0; z < 1 && (w = LINENO); z++)); do echo f $y $w; done'
    ' g'
    ' echo h ${BASH_LINENO[0]} $(caller)'
    ' echo i ${ echo $LINENO; }'
    ' ( echo j $LINENO )'
    ' echo k $(echo $LINENO)'
    ' }'
    ' g() { echo g $LINENO ${BASH_LINENO[0]}; }'
    ' f'
    ' echo l ${ echo $LINENO; } ${| REPLY=$LINENO; }'
    ' ( echo m ${ echo $LINENO; } )'
    ' echo n $(true; f2() { echo $LINENO; }; f2)'
    ' eval '\''true'
    ' f3() { echo o $LINENO; }; f3'\'''
    ' printf '\''true\nf4() {\ntrue\necho p $LINENO\n}\n'\'' > fsrc'
    ' . ./fsrc; f4'
    ' f5()'
    ' {'
    ' echo q $LINENO'
    ' }'
    ' f5'
    ' trap '\''echo r $LINENO'\'' USR1; kill -USR1 $$'
    ' f6() { kill -USR1 $$; }; f6'
    ' trap - USR1'
    ' trap '\''echo s $LINENO'\'' DEBUG; true; trap - DEBUG'
    ' f7() { trap '\''echo t $LINENO'\'' RETURN; true'
    ' }; f7; trap - RETURN'
    ' f8() { false; }; trap '\''echo u $LINENO'\'' ERR; f8; trap - ERR'
    ' for ((v = 0; v < LINENO - 36; v += LINENO > 0)); do'
    ' true'
    ' echo v $v; done'
)
printf '%s\n' "${cmds[@]}" >cmds
PS1= PS2= bash -i <cmds 2>&1 | sed '/^ /d; /tcsetattr/d; /job control/d; /terminal process group/d'
echo ---
printf '%s\n' "${cmds[@]}" >script
bash script
