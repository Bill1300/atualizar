#!/bin/bash

#Verificando arquivo script.
function verificarArquivo(){

    function moverArquivos(){
        comandoEnderecoMover=`pwd 2>/dev/null`
        comandoEnderecoMover="$comandoEnderecoMover/atualizar.sh"
        
        sudo mv $comandoEnderecoMover /bin
        cd /bin
        sudo chmod +x atualizar.sh
        sudo mv atualizar.sh atualizar

        #Diretório de logs.
        sudo mkdir ~/.atualizar
        sudo mkdir ~/.atualizar/logs
        
        clear
        echo -e " \e[34;1mInstalação completa. \e[1;37m"
    }
    
    function execAtualizar(){
        
        parametroExec=$1
        valorReiniciar="0" # Informação de reinicialização
        valorInstalarApps="0" # Informação de instalação de apps

        versaoAnterior=`uname -a`

        # 1o sed - Remove a palavra 'Listing...'; 2o sed - Lista cada pacote em uma nova linha; 3o sed - Exclui o 1o caractere (espaco vazio); 4o sed - Remove linha em branco; wc -l (contador de linhas).
        exibirPacotes=`sudo apt list --upgradable 2>/dev/null | sed 's/Listing...//' | sed 's/] /]\n/g' | sed 's/^ //' | sed '1d'`
        numeroPacotes=`sudo apt list --upgradable 2>/dev/null | sed 's/Listing...//' | sed 's/] /]\n/g' | sed 's/^ //' | sed '1d' | wc -l`

        #Criar Log com infomações da execução.
        function criarLog(){
            
            parametroLog=$1

            versaoAtual=`uname -a`
            dataLog=`date '+%d-%m-%Y_%H-%M-%S'`
            
            usuarioTexto=`whoami`
            dataTexto=`date '+%d/%m/%Y %H:%M:%S'`

            #Gravar dados.
            sudo echo -e "Executado por $usuarioTexto ($dataTexto)." | sudo tee -a ~/.atualizar/logs/log_$dataLog.txt > /dev/null
            
            if [ "$parametroLog" = "[S]" ];
            then
                sudo echo -e "Executado em modo \"Simples\"." | sudo tee -a ~/.atualizar/logs/log_$dataLog.txt > /dev/null
            else
                sudo echo -e "Executado em modo \"Padrão\"." | sudo tee -a ~/.atualizar/logs/log_$dataLog.txt > /dev/null
            fi

            if [ "$versaoAtual" = "$versaoAnterior" ];
            then
                sudo echo -e "A versão NÃO foi modificada: $versaoAtual.\n" | sudo sudo tee -a ~/.atualizar/logs/log_$dataLog.txt > /dev/null
            else
                sudo echo -e "Versão Anterior: $versaoAnterior" | sudo tee -a ~/.atualizar/logs/log_$dataLog.txt > /dev/null
                sudo echo -e "Versão Instalada:$versaoAtual\n" | sudo tee -a ~/.atualizar/logs/log_$dataLog.txt > /dev/null
            fi

            if [ "$numeroPacotes" -eq 0 ];
            then
                sudo echo -e "Nenhum pacote foi adicionado." | sudo tee -a ~/.atualizar/logs/log_$dataLog.txt > /dev/null
            else
                sudo echo -e "$numeroPacotes pacote(s) adicionados:\n$exibirPacotes" | sudo tee -a ~/.atualizar/logs/log_$dataLog.txt > /dev/null
            fi
        }
        
        # 1- Atualizar os repositórios.
        function f1() {
            parametroF1=$1
            clear
            if [ "$parametroF1" = "[S]" ]
            then
                echo -e "\n \e[34;1m(1/4)Atualizando Repositórios. \e[1;37m\n"
            else
                echo -e "\n \e[34;1m(1/9)Atualizando Repositórios. \e[1;37m\n"
            fi
            sudo apt update -y
        }
        
        # 2- Atualizar Linux.
        function f2() {
            parametroF2=$1
            clear
            if [ "$parametroF2" = "[S]" ]
            then
                echo -e "\n \e[34;1m(2/4)Atualizando Linux. \e[1;37m\n"
            else
                echo -e "\n \e[34;1m(2/9)Atualizando Linux. \e[1;37m\n"
            fi
            sudo apt upgrade -y
        }
        
        # 3- Atualizar a distribuição Linux.
        function f3() {
            parametroF3=$1
            clear
            if [ "$parametroF3" = "[S]" ]
            then
                echo -e "\n \e[34;1m(3/4)Atualizando Distribuição Linux. \e[1;37m\n"
            else
                echo -e "\n \e[34;1m(3/9)Atualizando Distribuição Linux. \e[1;37m\n"
            fi
            sudo apt dist-upgrade -y
        }

        # 4- Atualizar Grub.
        function f4() {
            clear
            echo -e "\n \e[34;1m(4/9)Atualizando Grub. \e[1;37m\n"
            sudo update-grub -y
        }

        # 5- Corrigir pacotes corrompidos.
        function f5() {
            clear
            echo -e "\n \e[34;1m(5/9) Corrigindo pacotes corrompidos. \e[1;37m\n"
            sudo apt install -f
        }
        
        # 6- Removendo arquivos desnecessários para o Sistema usados na atualização.
        function f6() {
            clear
            echo -e "\n \e[34;1m(6/9)Removendo arquivos desnecessários para o Sistema usados na atualização. \e[1;37m\n"
            sudo apt autoclean -y
        }
        
        # 7- Removendo arquivos do repositório local desnecessários para o Sistema.
        function f7() {
            clear
            echo -e "\n \e[34;1m(7/9)Removendo arquivos do repositório local desnecessários para o Sistema.  \e[1;37m\n"
            sudo apt autoremove -y
        }
        
        # 8- Removendo Remove os arquivos do /var/cache/apt/archives/ e /var/cache/apt/archives/partial/.
        function f8() {
            clear
            echo -e "\n \e[34;1m(8/9)Removendo os arquivos do /var/cache/apt/archives/ e /var/cache/apt/archives/partial/. \e[1;37m\n"
            sudo apt clean -y
        }
        
        # - Mostra informações.
        function f9() {
            parametroF7=$1
            
            reset
            if [ "$parametroF7" = "[S]" ];
            then
                criarLog $parametroF7
            else
                criarLog
            fi

            notify-send "atualizar" "Atualização conclúida com sucesso."
            
            if [ "$parametroF7" = "[S]" ];
            then
                echo -e "\e[34;1m(4/4)Atualização conclúida com sucesso. \e[1;37m"
            else
                echo -e "\e[34;1m(9/9)Atualização conclúida com sucesso. \e[1;37m"
            fi

            echo -e "\n\e[34;0mSistema: \e[1;37m"
            sudo uname -o
            echo -e "\n\e[34;0mVersão do Kernel: \e[1;37m"
            sudo uname -r
            echo -e "\n\e[34;0mVersão da distribuição: \e[1;37m"
            sudo cat /etc/issue.net
            echo -e "\n\e[34;0mPacotes atualizados:\n\e[1;37m$numeroPacotes"
            echo -e "\n\e]8;;https://github.com/bill1300/atualizar\aProjeto atualizar (GitHub)\e]8;;\a\n"
        }
               
        # Adicionar temporizador para leitura do usuário de f7.
        function sys_reboot() {
            if [ "$valorReiniciar" = "S" -o "$valorReiniciar" = "s" ];
            then

                echo -e "\n\e[1;41mO SISTEMA VAI REINICIAR EM 60 SEGUNDOS."
                echo -e "\n\e[1;41mS - PARA REINICIAR AGORA"
                echo -e "\e[1;41mN - PARA CANCELAR O REINÍCIO AUTOMÁTICO.\e[0m"
                
                valorR=""
                tempoInicial=`date +%s`
                tempoFinal=$((tempoInicial + 60))

                while [[ tempoInicial -le tempoFinal ]]; do
                    if [ "$valorR" == "S" -o "$valorR" == "s" ]; then
                        sudo reboot
                    fi
                    if [ "$valorR" == "N" -o "$valorR" == "n" ]; then
                        clear
                        exit
                    fi
                    read -n1 -t1 valorR
                    tempoInicial=`date +%s`
                done
                sudo reboot
            fi
        }
        
        # Informação de usuário para execução
        function menuVerificacao() {
            while [ "$valorReiniciar" != "S" -a "$valorReiniciar" != "s" -a "$valorReiniciar" != "N" -a "$valorReiniciar" != "n" ]; do
                clear
                echo -e " \e[1;41m DESEJA REINICIAR APÓS A ATUALIZAÇÃO? (S/N) \e[0m"
                read -n1 valorReiniciar
            done
            
            while [ "$valorInstalarApps" != "S" -a "$valorInstalarApps" != "s" -a "$valorInstalarApps" != "N" -a "$valorInstalarApps" != "n" ]; do
                clear
                echo -e " \e[34;1m Deseja instalar algum outro aplicativo? (S/N) \e[1;37m"
                read -n1 valorInstalarApps
            done
            
            if [ "$valorInstalarApps" = "S" -o "$valorInstalarApps" = "s" ]; then
                f_apps
            fi
        }
        
        function f_apps() {
            
            valorRecebido="0" 	#Valor de entrada do usuário
            nPagina=1 	  		#Paginamento de Apps
            nMaxPagina=3        #Numero Maximo de paginas
            
            vetorNome=("Spotify" "Discord" "Telegram Desktop" "Slack" "Draw.io" "Visual Studio Code (Classic)" "Visual Studio Code Insiders (Classic)" "Apache NetBeans" "Android Studio" "InkScape" "(vazio)" "(vazio)" "(vazio)" "(vazio)" "(vazio)")
            vetorComando=("spotify" "discord" "telegram-desktop" "slack --classic" "drawio" "code --classic" "(code-insiders --classic)" "netbeans --classic" "android-studio --classic" "inkscape" "(vazio)" "(vazio)" "(vazio)" "(vazio)" "(vazio)")
            vetorValor=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
            
            # Verificação de instalar/não instalar (Switch true-false)
            function switchValorApp(){
                
                valorRecebido=$(( ($nPagina - 1) * 5 + ($valorRecebido - 1) ))
                echo $valorRecebido

                if [[ "${vetorValor[$valorRecebido]}" -eq 1 ]];
                then
                    vetorValor[$valorRecebido]=0
                else
                    vetorValor[$valorRecebido]=1
                fi
            }
            
            #Definição de comandos para instalação.
            function instalarApps(){
                sudo apt install snapd
                
                for i in ${vetorValor[*]};
                do
                    if [[ "${vetorValor[i]}" -eq 1 ]];
                    then
                        clear
                        echo -e " \e[1;37mInstalando ${vetorNome[i]}...\e[1;37m\n"
                        sudo snap install ${vetorComando[i]}
                    fi
                done
            }
            
            #Paginação de menu de Apps.
            function paginasApps(){
                
                function imprimirTela(){
                    if [[ "${vetorValor[i]}" -eq 1 ]];
                    then
                        echo -e " \e[34;1m(OK)  $indiceCatalogo - ${vetorNome[i]}\e[1;37m"
                    else
                        echo -e " \e[34;1m(  )  $indiceCatalogo - ${vetorNome[i]}\e[1;37m"
                    fi
                    indiceCatalogo=$((indiceCatalogo+1))
                }

                case $nPagina in
                    1)
                        clear
                        indiceCatalogo=1
                        for i in {0..4..1};
                        do
                            imprimirTela
                        done
                    ;;
                    2)
                        clear
                        indiceCatalogo=1
                        for i in {5..9..1};
                        do
                            imprimirTela          
                        done
                    ;;
                    3)
                        clear
                        indiceCatalogo=1
                        for i in {10..14..1};
                        do
                            imprimirTela
                        done
                    ;;
                esac
            }
            
            # Loop de seleção de aplicativos
            while [ "$valorRecebido" != "S" -a "$valorRecebido" != "s" -a "$valorRecebido" != "N" -a "$valorRecebido" != "n" ]; do
                
                if [ "$valorRecebido" = "P" -o "$valorRecebido" = "p" ]; then
                    nPagina=$((nPagina+1))
                    if [ $nPagina -gt $nMaxPagina ]; then
                        nPagina=1
                    fi
                fi
                paginasApps
                
                echo -e "\n S-Continuar  N-Cancelar  P-Próxima Página ($nPagina/$nMaxPagina)"
                read -n1 valorRecebido
                clear
                
                if [ "$valorRecebido" != "S" -a "$valorRecebido" != "s" ];then
                    if [ "$valorRecebido" -ge 1 -a "$valorRecebido" -le 5 ];then
                        switchValorApp
                    fi
                fi   
            done
            
            # Caso S - Instalação de aplicativos.
            if [ "$valorRecebido" = "S" -o "$valorRecebido" = "s" ];then
                instalarApps

            #Caso N - Cancelar intalação.
            else
                clear
                for i in ${vetorValor[*]};
                do
                    vetorValor[i]=0
                done
            fi
        }

        #Chamada de modo "Simples"
        if [ "$parametroExec" = "[S]" ]
        then
            f1 $parametroExec
            f2 $parametroExec
            f3 $parametroExec
            f9 $parametroExec
        #Chamada de modo "Padrão"
        else
            menuVerificacao
            f1
            f2
            f3
            f4
            f5
            f6
            f7
            f8
            f9
            sys_reboot
        fi
    }

    # Função de execução simples (f1, f2, f3 e f7). 
    function simples() {
        simples="[S]"
        execAtualizar $simples
    }

    function desinstalar() {
        echo -e " \e[34;1mTchau \e[1;37m"
        sudo rm -f /bin/atualizar
        sudo rm -r ~/.atualizar 2>/dev/null
    }

    function ajuda() {
        clear
        echo -e " \e[34;1mComandos: \e[1;37m\n"
        echo -e "-a, --ajuda, -h, --help   [USE PARA APRESENTAR OS PARÂMETROS DE ENTRADA E O LINK DO PROJETO (GITHUB)]\n"
        echo -e "-d, --desinstalar, -u, --uninstall   [USE PARA DESINSTALAR]\n"
        echo -e "-s, --simples, --simple   [USE PARA EXECUTAR SOMENTE FUNÇÕES SIMPLES DE ATUALIZAÇÃO DE DIRETÓRIOS, KERNEL E DISTRIBUIÇÃO]\n\n"
        echo -e '\e]8;;https://github.com/bill1300/atualizar\aProjeto atualizar (GitHub)\e]8;;\a\n'
    }
    
    comandoEnderecoFixo=`sudo find /bin -type f -name "atualizar"`
    
    if [ -z "$comandoEnderecoFixo" ];then
        echo -e " \e[34;1mIniciando... \e[1;37m"
        moverArquivos
    else
        if [ -n "$parametro" ];
        then
            case $parametro in
            -d | --desinstalar | -u | --uninstall)
                desinstalar
            ;;
            -a | --ajuda | -h | --help)
                ajuda
            ;;
            -s | --simples | --simple)
                simples
            ;;
            *)
                echo -e "\nParâmetro desconhecido, tente: \033[1matualizar --help\033[0m para ver os parâmetros disponíveis."
            ;;
            esac
        else
            echo -e " \e[34;1mIniciando... \e[1;37m"
            execAtualizar
        fi
    fi
}
parametro=$1
verificarArquivo