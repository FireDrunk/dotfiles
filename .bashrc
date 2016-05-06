# .bashrc
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

function scr() {
    # Get the current directory and the name of the command
    #
    local working_dir=`pwd`
    local command=$1
    shift

    if [[ -z ${STY} ]]; then
        # Not in screen so run the command.
        #
        ${command} $*
    else
        # Use screen to run the command.
        #
        screen -X chdir ${working_dir}

        if [[ ${command} == "ssh" ]]; then
            local ssh_server="${3##*@}"
            local ssh_user=$2
            local ssh_os=`ssh -l ${ssh_user} ${ssh_server} uname`

            screen -X screen -t "$ssh_server" ${command} $*
        else
            screen -X screen -t "$command $*" ${command} $*
        fi
    fi
}

alias ls='ls -lah --color=auto'
alias man='scr man $*'
alias info='scr info $*'
alias vim='scr vim $*'

export PS1="\[\033[35m\]\t\[\033[m\]-\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "
