#!/bin/bash
versao="22.09"
idioma="pt-br" # "pt-br" ou "en-us"

#Verificando arquivo script.
function verificarArquivo() {

    function moverArquivos() {
        comandoEnderecoMover=$(pwd 2>/dev/null)
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
        valorReiniciar="0"    # Informação de reinicialização
        valorInstalarApps="0" # Informação de instalação de apps

        versaoAnterior=$(uname -a)

        # 1o sed - Remove a palavra 'Listing...'; 2o sed - Lista cada pacote em uma nova linha; 3o sed - Exclui o 1o caractere (espaco vazio); 4o sed - Remove linha em branco; wc -l (contador de linhas).
        exibirPacotes=$(sudo apt list --upgradable 2>/dev/null | sed 's/Listing...//' | sed 's/] /]\n/g' | sed 's/^ //' | sed '1d')
        numeroPacotes=$(sudo apt list --upgradable 2>/dev/null | sed 's/Listing...//' | sed 's/] /]\n/g' | sed 's/^ //' | sed '1d' | wc -l)

        # Criar Log com infomações da execução.
        function criarLog() {

            parametroLog=$1
            usuarioTexto=$(whoami)
            versaoAtual=$(uname -a)

            data=$(date +%x)
            hora=$(date +%X)
            dataLog=$(date '+%d-%m-%Y_%H-%M-%S')

            dataTexto="$data $hora"

            if [ "$idioma" = "pt-br" ]; then
                dataLog=$(date '+%d-%m-%Y_%H-%M-%S')
                infoUsuario="Executado por: $usuarioTexto ($dataTexto)."
                infoModoSimples="Executado em modo: \"Simples\"."
                infoModoPadrao="Executado em modo: \"Padrão\""
                infoVersao="A versão NÃO foi modificada. Versão atual: $versaoAtual"
                infoVersaoAnterior="Versão Anterior: $versaoAnterior"
                infoVersaoInstalada="Versão Instalada: $versaoAtual"
                infoPacotes1="Nenhum pacote foi adicionado."
                infoPacotes2="$numeroPacotes pacote(s) adicionados:"
            fi
            if [ "$idioma" = "en-us" ]; then
                dataLog=$(date '+%m-%d-%Y_%H-%M-%S')
                infoUsuario="Executed by: $usuarioTexto ($dataTexto)."
                infoModoSimples="Execution mode: \"Simple\"."
                infoModoPadrao="Execution mode: \"Default\"."
                infoVersao="The version has NOT been modified. Current version: $versaoAtual"
                infoVersaoAnterior="Previous version: $versaoAnterior"
                infoVersaoInstalada="Installed Version: $versaoAtual"
                infoPacotes1="No packages have been added."
                infoPacotes2="$numeroPacotes package(s) installed:"
            fi

            # Gravar dados.
            sudo echo -e "$infoUsuario" | sudo tee -a ~/.atualizar/logs/log_$dataLog.txt >/dev/null

            if [ "$parametroLog" = "paramS" ]; then
                sudo echo -e "$infoModoSimples" | sudo tee -a ~/.atualizar/logs/log_$dataLog.txt >/dev/null
            else
                sudo echo -e "$infoModoPadrao" | sudo tee -a ~/.atualizar/logs/log_$dataLog.txt >/dev/null
            fi

            if [ "$versaoAtual" = "$versaoAnterior" ]; then
                sudo echo -e "$infoVersao.\n" | sudo sudo tee -a ~/.atualizar/logs/log_$dataLog.txt >/dev/null
            else
                sudo echo -e "$infoVersaoAnterior" | sudo tee -a ~/.atualizar/logs/log_$dataLog.txt >/dev/null
                sudo echo -e "$infoVersaoInstalada\n" | sudo tee -a ~/.atualizar/logs/log_$dataLog.txt >/dev/null
            fi

            if [ "$numeroPacotes" -eq 0 ]; then
                sudo echo -e "$infoPacotes1" | sudo tee -a ~/.atualizar/logs/log_$dataLog.txt >/dev/null
            else
                sudo echo -e "$infoPacotes2\n$exibirPacotes" | sudo tee -a ~/.atualizar/logs/log_$dataLog.txt >/dev/null
            fi
        }

        # 1- Atualizar os repositórios.
        function f1() {
            if [ "$idioma" = "pt-br" ]; then
                frase="Atualizando Repositórios"
            fi
            if [ "$idioma" = "en-us" ]; then
                frase="Updating Repositories"
            fi
            parametroF1=$1
            clear
            if [ "$parametroF1" = "paramS" ]; then
                echo -e "\n \e[34;1m(1/4) $frase ➜ \e[1;37m\n"
            else
                echo -e "\n \e[34;1m(1/9) $frase ➜ \e[1;37m\n"
            fi
            sudo apt update -y
        }

        # 2- Atualizar Linux.
        function f2() {
            if [ "$idioma" = "pt-br" ]; then
                frase="Atualizando Linux"
            fi
            if [ "$idioma" = "en-us" ]; then
                frase="Updating Linux"
            fi
            parametroF2=$1
            clear
            if [ "$parametroF2" = "paramS" ]; then
                echo -e "\n \e[34;1m(2/4) $frase ➜ \e[1;37m\n"
            else
                echo -e "\n \e[34;1m(2/9) $frase ➜ \e[1;37m\n"
            fi
            sudo apt upgrade -y
        }

        # 3- Atualizar a distribuição Linux.
        function f3() {
            if [ "$idioma" = "pt-br" ]; then
                frase="Atualizando Distribuição Linux"
            fi
            if [ "$idioma" = "en-us" ]; then
                frase="Updating Linux Distribution"
            fi
            parametroF3=$1
            clear
            if [ "$parametroF3" = "paramS" ]; then
                echo -e "\n \e[34;1m(3/4) $frase ➜ \e[1;37m\n"
            else
                echo -e "\n \e[34;1m(3/9) $frase ➜ \e[1;37m\n"
            fi
            sudo apt dist-upgrade -y
        }

        # 4- Atualizar Grub.
        function f4() {
            if [ "$idioma" = "pt-br" ]; then
                frase="Atualizando Grub"
            fi
            if [ "$idioma" = "en-us" ]; then
                frase="Updating Grub"
            fi
            clear
            echo -e "\n \e[34;1m(4/9) $frase ➜ \e[1;37m\n"
            sudo update-grub -y
        }

        # 5- Corrigir pacotes corrompidos.
        function f5() {
            if [ "$idioma" = "pt-br" ]; then
                frase=" Corrigindo pacotes corrompidos"
            fi
            if [ "$idioma" = "en-us" ]; then
                frase="Fixing corrupted packages"
            fi
            clear
            echo -e "\n \e[34;1m(5/9) $frase ➜ \e[1;37m\n"
            sudo apt install -f
        }

        # 6- Removendo arquivos desnecessários para o Sistema usados na atualização.
        function f6() {
            if [ "$idioma" = "pt-br" ]; then
                frase="Removendo arquivos desnecessários para o Sistema usados na atualização"
            fi
            if [ "$idioma" = "en-us" ]; then
                frase="Removing unnecessary files for the System used in the update"
            fi
            clear
            echo -e "\n \e[34;1m(6/9) $frase ➜ \e[1;37m\n"
            sudo apt autoclean -y
        }

        # 7- Removendo arquivos do repositório local desnecessários para o Sistema.
        function f7() {
            if [ "$idioma" = "pt-br" ]; then
                frase="Removendo arquivos desnecessários para o Sistema usados na atualização"
            fi
            if [ "$idioma" = "en-us" ]; then
                frase="Removing unnecessary files from the local repository for the System"
            fi
            clear
            echo -e "\n \e[34;1m(7/9) $frase ➜ \e[1;37m\n"
            sudo apt autoremove -y
        }

        # 8- Removendo Remove os arquivos do /var/cache/apt/archives/ e /var/cache/apt/archives/partial/.
        function f8() {
            if [ "$idioma" = "pt-br" ]; then
                frase="Removendo os arquivos do /var/cache/apt/archives/ e /var/cache/apt/archives/partial/"
            fi
            if [ "$idioma" = "en-us" ]; then
                frase="Removing files from /var/cache/apt/archives/ and /var/cache/apt/archives/partial/"
            fi
            clear
            echo -e "\n \e[34;1m(8/9) $frase ➜ \e[1;37m\n"
            sudo apt clean -y
        }

        # 9- Mostra informações.
        function f9() {
            if [ "$idioma" = "pt-br" ]; then
                frase="Atualização conclúida com sucesso"
                notificacaoSimples="atualizar (Simples)"
                notificacaoPadrao="atualizar (Padrão)"
                info1="Sistema:"
                info2="Versão do Kernel:"
                info3="Versão da distribuição:"
                info4="Pacotes atualizados:"
                infoApps="Aplicativos instalados:"
                infoLink="Projeto Atualizar"
            fi
            if [ "$idioma" = "en-us" ]; then
                frase="Update completed successfully"
                notificacaoSimples="atualizar (Simple)"
                notificacaoPadrao="atualizar (Default)"
                info1="System:"
                info2="Kernel version:"
                info3="Distribution version:"
                info4="Updated packages:"
                infoApps="Installed apps:"
                infoLink="Atualizar project"
            fi
            parametroF7=$1
            reset
            if [ "$parametroF7" = "paramS" ]; then
                criarLog $parametroF7
                notify-send -i ~/.atualizar/imagens/atualizar.png "$notificacaoSimples" "$frase ➜"
                echo -e "\e[34;1m(4/4) $frase ➜ \e[1;37m"
            else
                criarLog
                notify-send -i ~/.atualizar/imagens/atualizar.png "$notificacaoPadrao" "$frase ➜"
                echo -e "\e[34;1m(9/9) $frase ➜ \e[1;37m"
            fi

            echo -e "\n\e[34;0m$info1 \e[1;37m"
            sudo uname -o
            echo -e "\n\e[34;0m$info2 \e[1;37m"
            sudo uname -r
            echo -e "\n\e[34;0m$info3 \e[1;37m"
            sudo cat /etc/issue.net
            echo -e "\n\e[34;0m$info4\n\e[1;37m$numeroPacotes"

            mostrarApps=false
            for i in ${!vetorValor[*]}; do
                if [ ${vetorValor[i]} == true ]; then
                    mostrarApps=true
                fi
            done

            if $mostrarApps; then
                echo -e "\n\e[34;0m$infoApps \e[1;37m"
                for i in ${!vetorValor[*]}; do
                    if [ ${vetorValor[i]} == true ] && [ ${vetorNome[i]} != "(vazio)" ]; then
                        echo -e "\e[1;37m${vetorNome[i]}\e[1;37m"
                    fi
                done
            fi

            echo -e "\n\e]8;;https://github.com/bill1300/atualizar\a$infoLink (GitHub)\e]8;;\a"
            echo -e "\e]8;;https://forms.gle/ysh5avJ1WCGsWeoH6\aFeedback (Google Forms)\e]8;;\a\n"
        }

        # Adicionar temporizador para leitura do usuário de f7.
        function reiniciarComputador() {
            if [ "$idioma" = "pt-br" ]; then
                alerta="O SISTEMA VAI REINICIAR EM 60 SEGUNDOS."
                info1="PARA REINICIAR AGORA"
                info2="PARA CANCELAR O REINÍCIO AUTOMÁTICO."
            fi
            if [ "$idioma" = "en-us" ]; then
                alerta="THE SYSTEM WILL RESTART IN 60 SECONDS."
                info1="RESTART NOW"
                info2="CANCEL AUTO RESTART."
            fi
            if [ "$valorReiniciar" = "S" -o "$valorReiniciar" = "s" ]; then

                echo -e "\n\e[1;41m$alerta"
                echo -e "\n\e[1;41mS - $info1"
                echo -e "\e[1;41mN - $info2\e[0m"

                valorR=""
                tempoInicial=$(date +%s)
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
                    tempoInicial=$(date +%s)
                done
                sudo reboot
            fi
        }

        # Informação de usuário para execução.
        function menuVerificacao() {
            if [ "$idioma" = "pt-br" ]; then
                info1="DESEJA REINICIAR APÓS A ATUALIZAÇÃO?"
                info2="Deseja instalar algum outro aplicativo?"
            fi
            if [ "$idioma" = "en-us" ]; then
                info1="DO YOU WANT TO RESTART AFTER UPDATE?"
                info2="Do you want to install some other application?"
            fi
            while [ "$valorReiniciar" != "S" -a "$valorReiniciar" != "s" -a "$valorReiniciar" != "N" -a "$valorReiniciar" != "n" ]; do
                clear
                echo -e " \e[1;41m $info1 (S/N) \e[0m"
                read -n1 valorReiniciar
            done

            while [ "$valorInstalarApps" != "S" -a "$valorInstalarApps" != "s" -a "$valorInstalarApps" != "N" -a "$valorInstalarApps" != "n" ]; do
                clear
                echo -e " \e[34;1m $info2 (S/N) \e[1;37m"
                read -n1 valorInstalarApps
            done

            if [ "$valorInstalarApps" = "S" -o "$valorInstalarApps" = "s" ]; then
                funcaoApps
            fi
        }

        function funcaoApps() {

            valorRecebido="0" #Valor de entrada do usuário.
            nPagina=1         #Paginamento de Apps.
            nMaxPagina=3      #Numero Maximo de paginas.

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
            vetorValor=(false false false false false false false false false false false false false false false)

            # Verificação de instalar/não instalar (Switch true-false).
            function mudarValorApps() {

                valorRecebido=$((($nPagina - 1) * 5 + ($valorRecebido - 1)))
                echo $valorRecebido

                if [ ${vetorValor[$valorRecebido]} == true ]; then
                    vetorValor[$valorRecebido]=false
                else
                    vetorValor[$valorRecebido]=true
                fi
            }

            # Definição de comandos para instalação de aplicativos Snapcraft.
            function instalarApps() {
                if [ "$idioma" = "pt-br" ]; then
                    frase="Instalando:"
                fi
                if [ "$idioma" = "en-us" ]; then
                    frase="Installing:"
                fi
                sudo apt install flatpak -y
                sudo apt install gnome-software-plugin-flatpak -y
                for i in ${!vetorValor[*]}; do
                    if [ ${vetorValor[i]} == true ] && [ ${vetorNome[i]} != "(vazio)" ]; then
                        clear
                        echo -e " \e[1;37m$frase ${vetorNome[i]}...\e[1;37m\n"
                        sudo flatpak install ${vetorComando[i]} -y
                    fi
                done
                sudo flatpak update -y
            }

            # Paginação de menu de Apps.
            function paginasApps() {

                function imprimirTela() {
                    if [ ${vetorValor[i]} == true ]; then
                        echo -e " \e[34;1m(OK)  $indiceCatalogo - ${vetorNome[i]}\e[1;37m"
                    else
                        echo -e " \e[34;1m(  )  $indiceCatalogo - ${vetorNome[i]}\e[1;37m"
                    fi
                    indiceCatalogo=$((indiceCatalogo + 1))
                }

                case $nPagina in
                1)
                    clear
                    indiceCatalogo=1
                    for i in {0..4..1}; do
                        imprimirTela
                    done
                    ;;
                2)
                    clear
                    indiceCatalogo=1
                    for i in {5..9..1}; do
                        imprimirTela
                    done
                    ;;
                3)
                    clear
                    indiceCatalogo=1
                    for i in {10..14..1}; do
                        imprimirTela
                    done
                    ;;
                esac
            }

            # Loop de seleção de aplicativos.
            if [ "$idioma" = "pt-br" ]; then
                info1="Continuar"
                info2="Cancelar"
                info3="Próxima página"
            fi
            if [ "$idioma" = "en-us" ]; then
                info1="Continue"
                info2="Cancel"
                info3="Next page"
            fi
            while [ "$valorRecebido" != "S" -a "$valorRecebido" != "s" -a "$valorRecebido" != "N" -a "$valorRecebido" != "n" ]; do

                if [ "$valorRecebido" = "P" -o "$valorRecebido" = "p" ]; then
                    nPagina=$((nPagina + 1))
                    if [ $nPagina -gt $nMaxPagina ]; then
                        nPagina=1
                    fi
                fi
                paginasApps

                echo -e "\n S-$info1  N-$info2  P-$info3 ($nPagina/$nMaxPagina)"
                read -n1 valorRecebido
                clear

                if [ "$valorRecebido" != "S" -a "$valorRecebido" != "s" ]; then
                    if [ "$valorRecebido" -ge 1 -a "$valorRecebido" -le 5 ]; then
                        mudarValorApps
                    fi
                fi
            done

            # Caso S - Instalação de aplicativos.
            if [ "$valorRecebido" = "S" -o "$valorRecebido" = "s" ]; then
                instalarApps

            # Caso N - Cancelar intalação.
            else
                clear
                for i in ${vetorValor[*]}; do
                    vetorValor[i]=false
                done
            fi
        }

        if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
            # Chamada de modo "Simples".
            if [ "$parametroExec" = "paramS" ]; then
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
                reiniciarComputador
            fi
        else
            apresentarErroConexao
        fi
    }

    function apresentarErroConexao() {
        clear

        if [ "$idioma" = "pt-br" ]; then
            echo -e " \e[34;1mSem conexão com a Internet ➜ \e[1;37m\n
 Tente:
   Verificar os cabos de rede, modem e roteador.
   Conectar à rede Wi-Fi novamente.
   Entrar em contato com o suporte do seu provedor de Internet.\n"
        fi
        if [ "$idioma" = "en-us" ]; then
            echo -e " \e[34;1mNo Internet ➜ \e[1;37m\n
 Try:
   Checking the network cables, modem and router.
   Reconnecting to Wi-Fi.
   Contact your ISP's support.\n"
        fi
    }
    # Função de desinstalar programa e logs.
    function desinstalar() {
        if [ "$idioma" = "pt-br" ]; then
            info1="VOCÊ REALMENTE DESEJA DESINSTALAR?"
            info2="Operação cancelada"
            info3="Tchau"
        fi
        if [ "$idioma" = "en-us" ]; then
            info1="DO YOU REALLY WANT TO UNINSTALL?"
            info2="Operation canceled"
            info3="Bye"
        fi
        function desinstalarComandos() {
            clear
            echo -e " \e[34;1m$info3 \e[1;37m"
            sudo rm -r ~/.atualizar 2>/dev/null
            sudo rm -f /bin/atualizar
        }
        parametroS=$1
        # Execução direta / Com confirmação.
        if [ "$parametroS" = "-S" ]; then
            desinstalarComandos
        else
            valorDesinstalar=0
            while [ "$valorDesinstalar" != "S" -a "$valorDesinstalar" != "s" -a "$valorDesinstalar" != "N" -a "$valorDesinstalar" != "n" ]; do
                clear
                echo -e " \e[1;41m $info1 (S/N) \e[0m"
                read -n1 valorDesinstalar
            done
            if [ "$valorDesinstalar" = "S" -o "$valorDesinstalar" = "s" ]; then
                desinstalarComandos
            else
                clear
                echo -e " \e[34;1m$info2 \e[1;37m"
            fi
        fi
    }

    # Função de apresentar parâmetros de entrada.
    function ajuda() {
        clear
        if [ "$idioma" = "pt-br" ]; then
            echo -e " \e[34;1mComandos: \e[1;37m\n
 \033[1m-a\033[0m ou \033[1m--ajuda\033[0m ➜         Use para apresentar os parâmetros de entrada e outras informações.\n
 \033[1m-d\033[0m ou \033[1m--desinstalar\033[0m ➜   Use para desinstalar, há uma mensagem para confirmação.
 \033[1m-D\033[0m ➜                    Use para desinstalar.\n
 \033[1m-s\033[0m ou \033[1m--simples\033[0m ➜       Use para executar somente funções simples de atualização de diretórios, kernel e distribuição.\n
 \033[1m-r\033[0m ou \033[1m--reescrever\033[0m ➜    Use para baixar e instalar a última versão do arquivo disponível, há um pedido de confirmação.
 \033[1m-R\033[0m ➜                    Use para baixar E instalar a última versão do arquivo disponível.\n
 \033[1m-v\033[0m ou \033[1m--versao\033[0m ➜        Use para apresentar a versão atual.\n
 \e]8;;https://github.com/bill1300/atualizar\aProjeto Atualizar (GitHub)\e]8;;\a
 \e]8;;https://forms.gle/ysh5avJ1WCGsWeoH6\aFeedback (Google Forms)\e]8;;\a\n"
        fi
        if [ "$idioma" = "en-us" ]; then
            echo -e " \e[34;1mCommands: \e[1;37m\n
 \033[1m-a\033[0m or \033[1m--ajuda\033[0m ➜         Use to display input parameters and other information.\n
 \033[1m-d\033[0m or \033[1m--desinstalar\033[0m ➜   Use to uninstall, there is a message for confirmation.
 \033[1m-D\033[0m ➜                    Use to uninstall.\n
 \033[1m-s\033[0m or \033[1m--simples\033[0m ➜       Use to perform simple directory, kernel, and distribution update functions only.\n
 \033[1m-r\033[0m or \033[1m--reescrever\033[0m ➜    Use to download and install the latest available file version, there is a message for confirmation.
 \033[1m-R\033[0m ➜                    Use to download and install the latest available file version.\n
 \033[1m-v\033[0m or \033[1m--versao\033[0m ➜        Use to display the current version\n
 \e]8;;https://github.com/bill1300/atualizar\aAtualizar project (GitHub)\e]8;;\a
 \e]8;;https://forms.gle/ysh5avJ1WCGsWeoH6\aFeedback (Google Forms)\e]8;;\a\n"

        fi
    }

    # Função de execução simples (f1, f2, f3 e f7).
    function simples() {
        simples="paramS"
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
        if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
            # Execução direta / Com confirmação.
            if [ "$parametroS" = "-S" ]; then
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
        if [ "$idioma" = "pt-br" ]; then
            echo -e "Atualizar está na versão: \033[1m$versao\033[0m"
        fi
        if [ "$idioma" = "en-us" ]; then
            echo -e "Atualizar is in version: \033[1m$versao\033[0m"
        fi
    }

    # Função de apresentar versão.
    function mudarIdioma() {
        idioma=$1
        if [ "$idioma" = "pt-br" ]; then
            escrever="idioma=\"pt-br\" # \"pt-br\" ou \"en-us\""
            sudo sed -i "3 c$escrever" /bin/atualizar >/dev/null
            echo -e "O Atualizar está no idioma: \033[1mPortuguês do Brasil\033[0m"
        fi
        if [ "$idioma" = "en-us" ]; then
            escrever="idioma=\"en-us\" # \"pt-br\" ou \"en-us\""
            sudo sed -i "3 c$escrever" /bin/atualizar >/dev/null
            echo -e "Atualizar is in the language: \033[1mUnited States English\033[0m"
        fi
    }

    if [ "$idioma" = "pt-br" ]; then
        info1="Parâmetro desconhecido, tente: \033[1matualizar --ajuda\033[0m para ver os parâmetros disponíveis."
        info2="Iniciando..."
    fi
    if [ "$idioma" = "en-us" ]; then
        info1="Unknown parameter, try: \033[1matualizar --ajuda\033[0m to see availabl  e parameters."
        info2="Starting..."
    fi

    comandoEnderecoFixo=$(sudo find /usr/bin -type f -name atualizar)

    if [ -z "$comandoEnderecoFixo" ]; then
        echo -e " \e[34;1m$info2 \e[1;37m"
        moverArquivos
    else
        if [ -n "$param1" ]; then
            case $param1 in
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
            -i | --idioma)
                mudarIdioma $param2
                ;;
            -v | --versao)
                mostrarVersao
                ;;
            *)
                echo -e "$info1"
                ;;
            esac
        else
            echo -e " \e[34;1m$info2 \e[1;37m"
            execAtualizar
        fi
    fi
}
param1=$1
param2=$2
verificarArquivo