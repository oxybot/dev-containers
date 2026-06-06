#!/bin/bash

#             ┏━┓     ┏━┓
# ┏━━━┳━┳━┳━┳━┫ ┗━┳━━━┫ ┗━┓
# ┃ · ┃   ┃ ┃ ┃ · ┃ · ┃ ┏━┛
# ┗━━━┻━┻━╋━  ┣━━━┻━━━┻━┛
#         ┗━━━┛

DOT='\033[38;2;255;87;34m'
LOGO='\033[38;2;255;234;0m'
RESET='\033[0m'

LINE_1="Dev container with ${DOT}${OXYBOT_CONTENT}${RESET}"
LINE_2="Connected as ${DOT}$(git config user.name)${RESET}"
LINE_3="Happy coding! 🍵"

printf '%b\n' "${LOGO}            ┏━┓     ┏━┓${RESET}"
printf '%b\n' "${LOGO}┏━━━┳━┳━┳━┳━┫ ┗━┳━━━┫ ┗━┓${RESET}    ${LINE_1}"
printf '%b\n' "${LOGO}┃ ${DOT}·${LOGO} ┃   ┃ ┃ ┃ ${DOT}·${LOGO} ┃ ${DOT}·${LOGO} ┃ ┏━┛${RESET}    ${LINE_2}"
printf '%b\n' "${LOGO}┗━━━┻━┻━╋━  ┣━━━┻━━━┻━┛${RESET}      ${LINE_3}"
printf '%b\n' "${LOGO}        ┗━━━┛${RESET}"
