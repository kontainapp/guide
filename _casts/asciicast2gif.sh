# from: https://techblog.dac.digital/how-to-embed-recorded-terminal-sessions-asciicasts-in-your-posts-c25ac30019c3
alias asciicast2gif='docker run --rm -v $PWD:/data asciinema/asciicast2gif -s 2 -t'
asciicast2gif $1