#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function control_c() {
    echo -e "\n${yellowColour}[!]${endColour} ${redColour}Saliendo...${endColour}\n"
    tput cnorm
    exit 1
}

# Control + C
trap control_c INT

function helpPanel() {
    echo -e "\n${yellowColour}[+]${endColour}${grayColour}Uso:${endColour}"
    echo -e "\t${purpleColour}m)${endColour}${grayColour} Cantidad de dinero que queres utilizar${endColour}"
    echo -e "\t${purpleColour}t)${endColour}${grayColour} Tecnica a utilizar${endColour}"
    echo -e "\t${purpleColour}h)${endColour}${grayColour} Mostrar este panel de ayuda${endColour}"
}

function martingala() {
    echo -e "\n ${grayColour}Dinero actual:${endColour} ${yellowColour}\$$money${endColour}"
    echo -ne "${yellowColour}[+]${endColour}${grayColour}Cuanto dinero tienes pensado apostar? ==>${endColour} " && read initial_bet
    echo -ne "${yellowColour}[+]${endColour}${grayColour}A que deseas apostar continuamente (par/impar)? ==>${endColour} " && read par_impar
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Vamos a jugar con una cantidad inicial de${endColour} ${turquoiseColour}$initial_bet${endColour} ${grayColour}a${endColour} ${turquoiseColour}$par_impar${endColour}\n"

    backup_bet=$initial_bet
    play_counter=0
    jugadas_malas=""
    initial_money=$money
    max_money=0

    tput civis
    while true; do
        money=$(($money - $initial_bet))
        random_number="$(($RANDOM % 37))"

        if [ $money -ge 0 ]; then
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} Acabas de apostar${endColour}${yellowColour} \$$initial_bet${endColour}${grayColour} y tienes un total de${endColour}${yellowColour} \$$money${endColour}"
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ha salido el numero${endColour}${yellowColour} $random_number${endColour}"
            if [ $par_impar == "par" ]; then
                if [ "$(($random_number % 2))" -eq 0 ]; then
                    if [ "$random_number" -eq 0 ]; then
                        echo -e "\n${yellowColour}[+]${endColour}${redColour} Ha salido 0, por lo tanto pierdes${endColour}"
                        initial_bet=$(($initial_bet * 2))
                        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Te quedas con un total de${endColour} ${yellowColour}\$$money${endColour}\n"
                        jugadas_malas+="$random_number "
                    else
                        echo -e "\n${greenColour}[+] El numero es par, ganas!${endColour}"
                        reward=$(($initial_bet * 2))
                        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ganas un total de${endColour} ${yellowColour}\$$reward${endColour}"
                        money=$(($money + $reward))
                        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Te quedas con un total de${endColour} ${yellowColour}\$$money${endColour}\n"
                        initial_bet=$backup_bet
                        jugadas_malas=""
                        max_money=$money
                    fi
                else
                    echo -e "\n${yellowColour}[+]${endColour}${redColour} El numero es impar, pierdes!${endColour}"
                    initial_bet=$(($initial_bet * 2))
                    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Te quedas con un total de${endColour} ${yellowColour}\$$money${endColour}\n"
                    jugadas_malas+="$random_number "
                fi

            elif [ $par_impar == "impar" ]; then

                if [ "$(($random_number % 2))" -eq 1 ]; then
                    if [ "$random_number" -eq 0 ]; then
                        echo -e "\n${yellowColour}[+]${endColour}${redColour} Ha salido 0, por lo tanto pierdes${endColour}"
                        initial_bet=$(($initial_bet * 2))
                        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Te quedas con un total de${endColour} ${yellowColour}\$$money${endColour}\n"
                        jugadas_malas+="$random_number "
                    else
                        echo -e "\n${greenColour}[+] El numero es impar, ganas!${endColour}"
                        reward=$(($initial_bet * 2))
                        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ganas un total de${endColour} ${yellowColour}\$$reward${endColour}"
                        money=$(($money + $reward))
                        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Te quedas con un total de${endColour} ${yellowColour}\$$money${endColour}\n"
                        initial_bet=$backup_bet
                        jugadas_malas=""
                        max_money=$money
                    fi
                else
                    echo -e "\n${yellowColour}[+]${endColour}${redColour} El numero es par, pierdes!${endColour}"
                    initial_bet=$(($initial_bet * 2))
                    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Te quedas con un total de${endColour} ${yellowColour}\$$money${endColour}\n"
                    jugadas_malas+="$random_number "
                fi
            else
                echo -e "\n${yellowColour}[+]${endColour}${redColour} Ese tipo de apuesta no existe, es par o impar!${endColour}"
                tput cnorm
                exit 1
            fi

            sleep 0.1
        else
            echo -e "\n${redColour}[!] Te has quedado sin dinero!!${endColour}\n"
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} Han habido un total de${endColour}${yellowColour} $play_counter${endColour}${grayColour} jugadas${endColour}\n"
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} Cantidad de jugadas malas consecutivas:${endColour}\n"
            echo -e "\n${blueColour} $jugadas_malas${endColour}\n"
            if [ $max_money -gt $initial_money ]; then
                echo -e "\n${blueColour}[+] Haz alcanzado un maximo de \$$max_money ${endColour}\n"
                echo -e "\n${blueColour}[+] Con una ganancia total de ==> \$$(($max_money - $initial_money)) ${endColour}\n"
            fi
            tput cnorm
            exit 0
        fi

        let play_counter+=1
    done
    tput cnorm
}

function inverseLab() {
    echo -e "\n ${grayColour}Dinero actual:${endColour} ${yellowColour}\$$money${endColour}"
    echo -ne "${yellowColour}[+]${endColour}${grayColour}A que deseas apostar continuamente (par/impar)? ==>${endColour} " && read par_impar

    declare -a my_sequence=(1 2 3 4)

    echo -e "${yellowColour}[+]${endColour}${grayColour} Comenzamos con la secuencia${endColour}${greenColour} [${my_sequence[@]}]${endColour}"

    bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
    bet_to_renew=$(($money + 50))
    jugadas_totales=0

    tput civis
    while true; do
        random_number=$(($RANDOM % 37))
        let money-=$bet
        if [ $money -ge 0 ]; then
            let jugadas_totales+=1
            echo -e "${yellowColour}[+]${endColour}${grayColour} Apostamos${endColour} ${blueColour}\$$bet${endColour}"
            echo -e "${yellowColour}[+]${endColour} ${grayColour}Tenemos un total de${endColour} ${yellowColour}\$$money${endColour}"

            echo -e "${yellowColour}[+]${endColour} ${grayColour}Ha salido el numero${endColour} ${greenColour}$random_number${endColour}"

            if [ "$par_impar" == "par" ]; then
                if [ $(($random_number % 2)) -eq 0 ]; then
                    echo -e "${greenColour}[+] El numero que ha salido es par, ganas!${endColour}"
                    reward=$(($bet * 2))
                    let money+=$reward
                    echo -e "${yellowColour}[+]${endColour} ${grayColour}Tenemos un total de${endColour} ${yellowColour}\$$money${endColour}"

                    if [ $money -gt $bet_to_renew ]; then
                        echo -e "${yelloColour}[+]${endColour}${grayColour} Nuestro dinero ha superado el tope de${endColour}${yellowColour} \$${bet_to_renew}${endColour}${grayColour} establecidos para renovar nuestra secuencia${endColour}"
                        bet_to_renew=$(($bet_to_renew + 50))
                        echo -e "${yellowColour}[+]${endColour}${grayColour} El tope se ha establecido en${endColour}${yellowColour} \$${bet_to_renew}${endColour}"
                        my_sequence=(1 2 3 4)
                        bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                        echo -e "${yellowColour}[+]${endColour}${grayColour} La secuencia se ha restablecido a ${endColour}${blueColour} [${my_sequence[@]}]${endColour}"
                    else
                        my_sequence+=($bet)
                        my_sequence=(${my_sequence[@]})

                        echo -e "${yellowColour}[+]${endColour} ${grayColour}Nuestra nueva secuencia es${endColour} ${blueColour}[${my_sequence[@]}]${endColour}\n"

                        if [ "${#my_sequence[@]}" -gt 1 ]; then
                            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                        elif [ "${#my_sequence[@]}" -eq 1 ]; then
                            bet=${my_sequence[@]}
                        else
                            echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}\n"
                            my_sequence=(1 2 3 4)
                            echo -e "${yellowColour}[+]${endColour} ${grayColour}Restablecemos la secuencia a${endColour} ${blueColour}${my_sequence[@]}${endColour}\n"
                        fi
                    fi
                elif [ "$random_number" -eq 0 ] || [ "$(($random_number % 2))" -eq 1 ]; then

                    if [ "$random_number" -eq 0 ]; then
                        echo -e "${redColour}[!] El numero que ha salido es 0, pierdes${endColour}\n"
                    else
                        echo -e "${redColour}[!] El numero que ha salido es impar, pierdes${endColour}"
                    fi

                    if [ $money -lt $(($bet_to_renew - 100)) ]; then
                        echo -e "[+] Hemos llegado a un minimo critico, se procede a reajustar el tope"
                        bet_to_renew=$(($bet_to_renew - 50))
                        echo -e "[+] El tope ha sido renovado a $bet_to_renew"

                        unset my_sequence[0]
                        unset my_sequence[-1] 2>/dev/null
                        my_sequence=(${my_sequence[@]})

                        echo -e "${yellowColour}[+]${endColour} ${grayColour}Nuestra secuencia queda en${endColour} ${blueColour}[${my_sequence[@]}]${endColour}\n"

                        if [ "${#my_sequence[@]}" -gt 1 ]; then
                            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                        elif [ "${#my_sequence[@]}" -eq 1 ]; then
                            bet=${my_sequence[@]}
                        else
                            echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
                            my_sequence=(1 2 3 4)
                            echo -e "${yellowColour}[+]${endColour} ${grayColour}Restablecemos la secuencia a${endColour} ${blueColour}[${my_sequence[@]}]${endColour}\n"
                            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                        fi
                    else

                        unset my_sequence[0]
                        unset my_sequence[-1] 2>/dev/null
                        my_sequence=(${my_sequence[@]})

                        echo -e "${yellowColour}[+]${endColour} ${grayColour}Nuestra secuencia queda en${endColour} ${blueColour}[${my_sequence[@]}]${endColour}\n"
                        if [ "${#my_sequence[@]}" -gt 1 ]; then
                            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                        elif [ "${#my_sequence[@]}" -eq 1 ]; then
                            bet=${my_sequence[@]}
                        else
                            echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
                            my_sequence=(1 2 3 4)
                            echo -e "${yellowColour}[+]${endColour} ${grayColour}Restablecemos la secuencia a${endColour} ${blueColour}[${my_sequence[@]}]${endColour}\n"
                            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                        fi
                    fi
                fi
            elif [ "$par_impar" == "impar" ]; then
                if [ $(($random_number % 2)) -eq 1 ]; then
                    echo -e "${greenColour}[+] El numero que ha salido es impar, ganas!${endColour}"
                    reward=$(($bet * 2))
                    let money+=$reward
                    echo -e "${yellowColour}[+]${endColour} ${grayColour}Tenemos un total de${endColour} ${yellowColour}\$$money${endColour}"

                    if [ $money -gt $bet_to_renew ]; then
                        echo -e "${yelloColour}[+]${endColour}${grayColour} Nuestro dinero ha superado el tope de${endColour}${yellowColour} \$${bet_to_renew}${endColour}${grayColour} establecidos para renovar nuestra secuencia${endColour}"
                        bet_to_renew=$(($bet_to_renew + 50))
                        echo -e "${yellowColour}[+]${endColour}${grayColour} El tope se ha establecido en${endColour}${yellowColour} \$${bet_to_renew}${endColour}"
                        my_sequence=(1 2 3 4)
                        bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                        echo -e "${yellowColour}[+]${endColour}${grayColour} La secuencia se ha restablecido a ${endColour}${blueColour} [${my_sequence[@]}]${endColour}"
                    else
                        my_sequence+=($bet)
                        my_sequence=(${my_sequence[@]})

                        echo -e "${yellowColour}[+]${endColour} ${grayColour}Nuestra secuencia queda en${endColour} ${blueColour}[${my_sequence[@]}]${endColour}\n"

                        if [ "${#my_sequence[@]}" -gt 1 ]; then
                            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                        elif [ "${#my_sequence[@]}" -eq 1 ]; then
                            bet=${my_sequence[@]}
                        else
                            echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}\n"
                            my_sequence=(1 2 3 4)
                            echo -e "${yellowColour}[+]${endColour} ${grayColour}Restablecemos la secuencia a${endColour} ${blueColour}${my_sequence[@]}${endColour}\n"
                        fi
                    fi
                elif [ "$random_number" -eq 0 ] || [ "$(($random_number % 2))" -eq 0 ]; then
                    if [ "$random_number" -eq 0 ]; then
                        echo -e "${redColour}[!] El numero que ha salido es 0, pierdes${endColour}\n"
                    else
                        echo -e "${redColour}[!] El numero que ha salido es par, pierdes${endColour}"
                    fi

                    if [ $money -lt $(($bet_to_renew - 100)) ]; then
                        echo -e "[+] Hemos llegado a un minimo critico, se procede a reajustar el tope"
                        bet_to_renew=$(($bet_to_renew - 50))
                        echo -e "[+] El tope ha sido renovado a $bet_to_renew"
                        unset my_sequence[0]
                        unset my_sequence[-1] 2>/dev/null
                        my_sequence=(${my_sequence[@]})

                        echo -e "${yellowColour}[+]${endColour} ${grayColour}Nuestra secuencia queda en${endColour} ${blueColour}[${my_sequence[@]}]${endColour}\n"
                        if [ "${#my_sequence[@]}" -gt 1 ]; then
                            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                        elif [ "${#my_sequence[@]}" -eq 1 ]; then
                            bet=${my_sequence[@]}
                        else
                            echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
                            my_sequence=(1 2 3 4)
                            echo -e "${yellowColour}[+]${endColour} ${grayColour}Restablecemos la secuencia a${endColour} ${blueColour}[${my_sequence[@]}]${endColour}\n"
                            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                        fi
                    else
                        unset my_sequence[0]
                        unset my_sequence[-1] 2>/dev/null
                        my_sequence=(${my_sequence[@]})

                        echo -e "${yellowColour}[+]${endColour} ${grayColour}Nuestra nueva secuencia es${endColour} ${blueColour}[${my_sequence[@]}]${endColour}\n"
                        if [ "${#my_sequence[@]}" -gt 1 ]; then
                            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                        elif [ "${#my_sequence[@]}" -eq 1 ]; then
                            bet=${my_sequence[@]}
                        else
                            echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
                            my_sequence=(1 2 3 4)
                            echo -e "${yellowColour}[+]${endColour} ${grayColour}Restablecemos la secuencia a${endColour} ${blueColour}[${my_sequence[@]}]${endColour}\n"
                            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                        fi
                    fi
                fi
            fi
        else
            echo -e "\n${redColour}[!] Te quedaste sin dinero${endColour}"
            echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Han habido${endColour}${blueColour} $jugadas_totales${endColour}${grayColour} jugadas totales${endColour}"
            tput cnorm
            exit 1
        fi
    done
    tput cnorm
}

while getopts "m:t:h" arg; do
    case $arg in
        m) money=$OPTARG ;;
        t) technique=$OPTARG ;;
        h) ;;
    esac
done

if [ $money ] && [ $technique ]; then
    if [ $technique == "martingala" ]; then
        martingala
    elif [ "$technique" == "inverseLab" ]; then
        inverseLab
    else
        echo -e "\n${redColour}[!]La tecnica introducida no existe${endColour}\n"
        helpPanel
    fi
else
    helpPanel
fi

