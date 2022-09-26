#!/bin/bash
versao="22.09"

#Verificando arquivo script.
function verificarArquivo() {

    function moverArquivos() {
        comandoEnderecoMover=`pwd 2>/dev/null`
        comandoEnderecoMover="$comandoEnderecoMover/atualizar.sh"
        
        sudo mv $comandoEnderecoMover /bin
        cd /bin
        sudo chmod +x atualizar.sh
        sudo mv atualizar.sh atualizar

        # Diretório de logs.
        sudo mkdir ~/.atualizar
        sudo mkdir ~/.atualizar/logs
        sudo mkdir ~/.atualizar/imagens
        
        sudo wget -P ~/.atualizar/imagens https://i.imgur.com/sDdxIJ9.png
        sudo mv ~/.atualizar/imagens/sDdxIJ9.png ~/.atualizar/imagens/atualizar.png

        sudo echo -e "[Desktop Entry]
Name=atualizar
Type=Application
Comment=Script para atualização completa do sistema Linux, de modo simples e fácil.
Categories=Utility,System,Settings
Exec=atualizar
Terminal=true
Version=$versao
Icon=/home/$USER/.atualizar/imagens/atualizar.png" | sudo tee /usr/share/applications/atualizar.desktop

        clear
        echo -e " \e[34;1mInstalação completa. \e[1;37m"
    }
    
    function execAtualizar() {
        
        parametroExec=$1
        valorReiniciar="0" # Informação de reinicialização
        valorInstalarApps="0" # Informação de instalação de apps

        versaoAnterior=`uname -a`

        # 1o sed - Remove a palavra 'Listing...'; 2o sed - Lista cada pacote em uma nova linha; 3o sed - Exclui o 1o caractere (espaco vazio); 4o sed - Remove linha em branco; wc -l (contador de linhas).
        exibirPacotes=`sudo apt list --upgradable 2>/dev/null | sed 's/Listing...//' | sed 's/] /]\n/g' | sed 's/^ //' | sed '1d'`
        numeroPacotes=`sudo apt list --upgradable 2>/dev/null | sed 's/Listing...//' | sed 's/] /]\n/g' | sed 's/^ //' | sed '1d' | wc -l`

        # Criar Log com infomações da execução.
        function criarLog() {
            
            parametroLog=$1

            versaoAtual=`uname -a`
            dataLog=`date '+%d-%m-%Y_%H-%M-%S'`
            
            usuarioTexto=`whoami`
            dataTexto=`date '+%d/%m/%Y %H:%M:%S'`

            # Gravar dados.
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
        
        # 9- Mostra informações.
        function f9() {
            parametroF7=$1
            reset
            if [ "$parametroF7" = "[S]" ];
            then
                criarLog $parametroF7
                notify-send -i ~/.atualizar/imagens/atualizar.png "atualizar (Simples)" "Atualização concluída com sucesso."
                echo -e "\e[34;1m(4/4)Atualização conclúida com sucesso. \e[1;37m"
            else
                criarLog
                notify-send -i ~/.atualizar/imagens/atualizar.png "atualizar (Padrão)" "Atualização concluída com sucesso."
                echo -e "\e[34;1m(9/9)Atualização conclúida com sucesso. \e[1;37m"
            fi

            echo -e "\n\e[34;0mSistema: \e[1;37m"
            sudo uname -o
            echo -e "\n\e[34;0mVersão do Kernel: \e[1;37m"
            sudo uname -r
            echo -e "\n\e[34;0mVersão da distribuição: \e[1;37m"
            sudo cat /etc/issue.net
            echo -e "\n\e[34;0mPacotes atualizados:\n\e[1;37m$numeroPacotes"

            mostrarApps=false
            for i in ${!vetorValor[*]};
            do
                if [ ${vetorValor[i]} == true ];
                then
                    mostrarApps=true
                fi
            done

            if $mostrarApps;
            then
                echo -e "\n\e[34;0mAplicativos instalados: \e[1;37m"
                for i in ${!vetorValor[*]};
                do
                    if [ ${vetorValor[i]} == true ] && [ ${vetorNome[i]} != "(vazio)" ];
                    then
                        echo -e "\e[1;37m${vetorNome[i]}\e[1;37m"
                    fi
                done
            fi

            echo -e "\n\e]8;;https://github.com/bill1300/atualizar\aProjeto atualizar (GitHub)\e]8;;\a"
            echo -e "\e]8;;https://forms.gle/ysh5avJ1WCGsWeoH6\aFeedback (Google Forms)\e]8;;\a\n"
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
        
        # Informação de usuário para execução.
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
            
            valorRecebido="0" 	#Valor de entrada do usuário.
            nPagina=1 	  		#Paginamento de Apps.
            nMaxPagina=3        #Numero Maximo de paginas.

            # Spotify ➜            https://dl.flathub.org/repo/appstream/com.spotify.Client.flatpakref
            # Discord ➜            https://dl.flathub.org/repo/appstream/com.discordapp.Discord.flatpakref
            # Telegram Desktop ➜   https://dl.flathub.org/repo/appstream/org.telegram.desktop.flatpakref
            # Slack ➜              https://dl.flathub.org/repo/appstream/com.slack.Slack.flatpakref
            # Draw.io ➜            https://dl.flathub.org/repo/appstream/com.jgraph.drawio.desktop.flatpakref
            # Visual Studio Code ➜ https://dl.flathub.org/repo/appstream/com.visualstudio.code.flatpakref
            # GitKracken ➜         https://dl.flathub.org/repo/appstream/com.axosoft.GitKraken.flatpakref
            # AnyDesk ➜            https://dl.flathub.org/repo/appstream/com.anydesk.Anydesk.flatpakref
            # AuthPass ➜           https://dl.flathub.org/repo/appstream/app.authpass.AuthPass.flatpakref
            # Google Chrome ➜      https://dl.flathub.org/repo/appstream/com.google.Chrome.flatpakref

            vetorNome=("Spotify" "Discord" "Telegram Desktop" "Slack" "Draw.io" "Visual Studio Code" "GitKraken" "AnyDesk" "AuthPass" "Google Chrome" "(vazio)" "(vazio)" "(vazio)" "(vazio)" "(vazio)")
            vetorComando=("https://dl.flathub.org/repo/appstream/com.spotify.Client.flatpakref" "https://dl.flathub.org/repo/appstream/com.discordapp.Discord.flatpakref" "https://dl.flathub.org/repo/appstream/org.telegram.desktop.flatpakref" "https://dl.flathub.org/repo/appstream/com.slack.Slack.flatpakref" "https://dl.flathub.org/repo/appstream/com.jgraph.drawio.desktop.flatpakref" "https://dl.flathub.org/repo/appstream/com.visualstudio.code.flatpakref" "https://dl.flathub.org/repo/appstream/com.axosoft.GitKraken.flatpakref" "https://dl.flathub.org/repo/appstream/com.anydesk.Anydesk.flatpakref" "https://dl.flathub.org/repo/appstream/app.authpass.AuthPass.flatpakref" "https://dl.flathub.org/repo/appstream/com.google.Chrome.flatpakref" "(vazio)" "(vazio)" "(vazio)" "(vazio)" "(vazio)")
            vetorValor=( false false false false false false false false false false false false false false false )
            

            # Verificação de instalar/não instalar (Switch true-false).
            function mudarValorInstalar() {
                
                valorRecebido=$(( ($nPagina - 1) * 5 + ($valorRecebido - 1) ))
                echo $valorRecebido

                if [ ${vetorValor[$valorRecebido]} == true ];
                then
                    vetorValor[$valorRecebido]=false
                else
                    vetorValor[$valorRecebido]=true
                fi
            }
            
            # Definição de comandos para instalação de aplicativos Snapcraft.
            function instalarApps() {
                sudo apt install flatpak -y
                sudo apt install gnome-software-plugin-flatpak -y
                for i in ${!vetorValor[*]};
                do
                    if [ ${vetorValor[i]} == true ] && [ ${vetorNome[i]} != "(vazio)" ];
                    then
                        clear
                        echo -e " \e[1;37mInstalando ${vetorNome[i]}...\e[1;37m\n"
                        sudo flatpak install ${vetorComando[i]} -y
                    fi
                done
                sudo flatpak update -y
            }
            
            # Paginação de menu de Apps.
            function paginasApps() {
                
                function imprimirTela() {
                    if [ ${vetorValor[i]} == true ];
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
            
            # Loop de seleção de aplicativos.
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
                        mudarValorInstalar
                    fi
                fi   
            done
            
            # Caso S - Instalação de aplicativos.
            if [ "$valorRecebido" = "S" -o "$valorRecebido" = "s" ];then
                instalarApps

            # Caso N - Cancelar intalação.
            else
                clear
                for i in ${vetorValor[*]};
                do
                    vetorValor[i]=false
                done
            fi
        }

        if ping -q -c 1 -W 1 8.8.8.8 >/dev/null;
        then
            # Chamada de modo "Simples".
            if [ "$parametroExec" = "[S]" ]
            then
                f1 $parametroExec
                f2 $parametroExec
                f3 $parametroExec
                f9 $parametroExec
            # Chamada de modo "Padrão".
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
        else
            apresentarErroConexao
        fi
    }

    function apresentarErroConexao() {
        clear
        echo -e " \e[34;1mSem conexão com a Internet\e[1;37m\n
 Tente:
   Verificar os cabos de rede, modem e roteador.
   Conectar à rede Wi-Fi novamente.
   Entrar em contato com o suporte do seu provedor de Internet.\n"
    }
    # Função de desinstalar programa e logs.
    function desinstalar() {
        function desinstalarComandos() {
            clear
            echo -e " \e[34;1mTchau \e[1;37m"
            sudo rm -r ~/.atualizar 2>/dev/null
            sudo rm -f /bin/atualizar
        }
        parametroS=$1
        # Execução direta / Com confirmação.
        if [ "$parametroS" = "-S" ];
        then
            desinstalarComandos
        else
            valorDesinstalar=0
            while [ "$valorDesinstalar" != "S" -a "$valorDesinstalar" != "s" -a "$valorDesinstalar" != "N" -a "$valorDesinstalar" != "n" ]; do
                clear
                echo -e " \e[1;41m VOCÊ REALMENTE DESEJA DESINSTALAR? (S/N) \e[0m"
                read -n1 valorDesinstalar
            done
            if [ "$valorDesinstalar" = "S" -o "$valorDesinstalar" = "s" ]; then
                desinstalarComandos
            else
                clear
                echo -e " \e[34;1mOperação cancelada \e[1;37m"
            fi
        fi
    }

    

    # Função de apresentar parâmetros de entrada.
    function ajuda() {
        clear
        echo -e " \e[34;1mComandos: \e[1;37m\n
 -a, --ajuda           [USE PARA APRESENTAR OS PARÂMETROS DE ENTRADA, O LINK DO PROJETO E O LINK DE FEEDBACK]\n
 -d, --desinstalar     [USE PARA DESINSTALAR, HÁ UM PEDIDO DE CONFIRMAÇÃO]
 -D                    [USE PARA DESINSTALAR]\n
 -s, --simples         [USE PARA EXECUTAR SOMENTE FUNÇÕES SIMPLES DE ATUALIZAÇÃO DE DIRETÓRIOS, KERNEL E DISTRIBUIÇÃO]\n
 -r, --reescrever      [USE PARA BAIXAR E INSTALAR A ÚLTIMA VERSÃO DO ARQUIVO DISPONÍVEL, HÁ UM PEDIDO DE CONFIRMAÇÃO]
 -R                    [USE PARA BAIXAR E INSTALAR A ÚLTIMA VERSÃO DO ARQUIVO DISPONÍVEL]\n
 -v, --versao          [USE PARA APRESENTAR A VERSÃO ATUAL]\n
 \e]8;;https://github.com/bill1300/atualizar\aProjeto atualizar (GitHub)\e]8;;\a
 \e]8;;https://forms.gle/ysh5avJ1WCGsWeoH6\aFeedback (Google Forms)\e]8;;\a\n"
    }

    # Função de execução simples (f1, f2, f3 e f7). 
    function simples() {
        simples="[S]"
        execAtualizar $simples
    }

    # Função de reescrita de arquivo usando o arquivo "raw" no GitHub.
    function atualizarArquivo() {
        function atualizarArquivoComandos() {
            sudo snap install curl 2>/dev/null
            sudo curl -sS https://raw.githubusercontent.com/Bill1300/atualizar/main/atualizar.sh | sudo tee /usr/bin/atualizar >/dev/null
            clear
            mostrarVersao
        }
        parametroS=$1
        if ping -q -c 1 -W 1 8.8.8.8 >/dev/null;
        then
            # Execução direta / Com confirmação.
            if [ "$parametroS" = "-S" ];
            then
                atualizarArquivoComandos
            else
                valorReescrita=0
                while [ "$valorReescrita" != "S" -a "$valorReescrita" != "s" -a "$valorReescrita" != "N" -a "$valorReescrita" != "n" ]; do
                    clear
                    echo -e " \e[34;1mVocê realmente deseja reescrever o arquivo para a versão mais atual? (S/N) \e[1;37m"
                    read -n1 valorReescrita
                done
                if [ "$valorReescrita" = "S" -o "$valorReescrita" = "s" ]; then
                    atualizarArquivoComandos
                else
                    clear
                    echo -e " \e[34;1mOperação cancelada \e[1;37m"
                fi
            fi
        else
            apresentarErroConexao
        fi
    }

    # Função de apresentar versão.
    function mostrarVersao() {
         echo -e "O atualizar está na versão: \033[1m$versao\033[0m"
    }
    
    comandoEnderecoFixo=`sudo find /usr/bin -type f -name atualizar`
    
    if [ -z "$comandoEnderecoFixo" ];then
        echo -e " \e[34;1mIniciando... \e[1;37m"
        moverArquivos
    else
        if [ -n "$parametro" ];
        then
            case $parametro in
            -d | --desinstalar)
                desinstalar
            ;;
            -D)
                desinstalar -S
            ;;
            -a | --ajuda)
                ajuda
            ;;
            -s | --simples)
                simples
            ;;
            -r | --reescrever)
                atualizarArquivo
            ;;
            -R)
                atualizarArquivo -S
            ;;
            -v | --versao)
                mostrarVersao
            ;;
            *)
                echo -e "Parâmetro desconhecido, tente: \033[1matualizar --ajuda\033[0m para ver os parâmetros disponíveis."
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