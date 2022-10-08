#!/bin/bash
versao="22.10.1"
idioma="pt-br"

_alt="\e[1;41m"     #Alerta
_ttl=" \e[34;1m"    #Titulo
_bld="\033[1m"      #Bold
_nml="\033[0m"      #Normal
_lnk="\e]8;;"       #Link

#Verificando arquivo script.
function verificarArquivo() {

    function moverArquivos() {
        comandoEnderecoMover=$(pwd 2>/dev/null)
        comandoEnderecoMover="$comandoEnderecoMover/atualizar.sh"

        sudo mv $comandoEnderecoMover /bin
        cd /bin
        sudo chmod +x atualizar.sh
        sudo mv atualizar.sh atualizar

        # Diretório de registros.
        sudo mkdir ~/.atualizar
        sudo mkdir ~/.atualizar/registros
        sudo mkdir ~/.atualizar/imagens
        sudo touch ~/.atualizar/dados.list
        echo -e "idioma=\"pt-br\"\n" | sudo tee ~/.atualizar/dados.list

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
        echo -e "${_ttl}Instalação completa.${_nml}"
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
            
            criarHistorico() {
                versaoDistro=$(cat /etc/issue.net)
                linha="$hora     $data     $versaoDistro     $numeroPacotes"
                sudo sed -i "2i $linha" ~/.atualizar/dados.list
            }

            parametroLog=$1
            usuarioTexto=$(whoami)
            versaoAtual=$(uname -a)

            data=$(date +%x)
            hora=$(date +%X)
            dataLog=$(date '+%d-%m-%Y_%H-%M-%S')

            dataTexto="$data $hora"
            distroNome=$(lsb_release -cs)

            criarHistorico

            if [ "$idioma" = "pt-br" ]; then
                dataLog=$(date '+%d-%m-%Y_%H-%M-%S')
                infoUsuario="Executado por: $usuarioTexto ($dataTexto)."
                infoModoSimples="Executado em modo: \"Simples\"."
                infoModoPadrao="Executado em modo: \"Padrão\""
                infoVersao="A versão NÃO foi modificada. Versão atual: $versaoAtual ($distroNome)"
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
                infoVersao="The version has NOT been modified. Current version: $versaoAtual ($distroNome)"
                infoVersaoAnterior="Previous version: $versaoAnterior"
                infoVersaoInstalada="Installed Version: $versaoAtual"
                infoPacotes1="No packages have been added."
                infoPacotes2="$numeroPacotes package(s) installed:"
            fi

            # Gravar dados.
            sudo echo -e "$infoUsuario" | sudo tee -a ~/.atualizar/registros/registro_$dataLog.txt >/dev/null

            if [ "$parametroLog" = "paramS" ]; then
                sudo echo -e "$infoModoSimples" | sudo tee -a ~/.atualizar/registros/registro_$dataLog.txt >/dev/null
            else
                sudo echo -e "$infoModoPadrao" | sudo tee -a ~/.atualizar/registros/registro_$dataLog.txt >/dev/null
            fi

            if [ "$versaoAtual" = "$versaoAnterior" ]; then
                sudo echo -e "$infoVersao.\n" | sudo sudo tee -a ~/.atualizar/registros/registro_$dataLog.txt >/dev/null
            else
                sudo echo -e "$infoVersaoAnterior" | sudo tee -a ~/.atualizar/registros/registro_$dataLog.txt >/dev/null
                sudo echo -e "$infoVersaoInstalada\n" | sudo tee -a ~/.atualizar/registros/registro_$dataLog.txt >/dev/null
            fi

            if [ "$numeroPacotes" -eq 0 ]; then
                sudo echo -e "$infoPacotes1" | sudo tee -a ~/.atualizar/registros/registro_$dataLog.txt >/dev/null
            else
                sudo echo -e "$infoPacotes2\n$exibirPacotes" | sudo tee -a ~/.atualizar/registros/registro_$dataLog.txt >/dev/null
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
                echo -e "${_ttl}(1/4) $frase ➜ ${_nml}\n"
            else
                echo -e "${_ttl}(1/7) $frase ➜ ${_nml}\n"
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
                echo -e "${_ttl}(2/4) $frase ➜ ${_nml}\n"
            else
                echo -e "${_ttl}(2/7) $frase ➜ ${_nml}\n"
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
                echo -e "${_ttl}(3/4) $frase ➜ ${_nml}\n"
            else
                echo -e "${_ttl}(3/7) $frase ➜ ${_nml}\n"
            fi
            sudo apt do-release-upgrade -y
        }

        # 4- Corrigir pacotes corrompidos.
        function f4() {
            if [ "$idioma" = "pt-br" ]; then
                frase=" Corrigindo pacotes corrompidos"
            fi
            if [ "$idioma" = "en-us" ]; then
                frase="Fixing corrupted packages"
            fi
            clear
            echo -e "${_ttl}(4/7) $frase ➜ ${_nml}\n"
            sudo apt install -f
        }

        # 5- Removendo arquivos desnecessários para o Sistema usados na atualização.
        function f5() {
            if [ "$idioma" = "pt-br" ]; then
                frase="Removendo arquivos desnecessários para o Sistema usados na atualização"
            fi
            if [ "$idioma" = "en-us" ]; then
                frase="Removing unnecessary files for the System used in the update"
            fi
            clear
            echo -e "${_ttl}(5/7) $frase ➜ ${_nml}\n"
            sudo apt autoclean -y
        }

        # 6- Removendo arquivos do repositório local desnecessários para o Sistema.
        function f6() {
            if [ "$idioma" = "pt-br" ]; then
                frase="Removendo arquivos desnecessários para o Sistema usados na atualização"
            fi
            if [ "$idioma" = "en-us" ]; then
                frase="Removing unnecessary files from the local repository for the System"
            fi
            clear
            echo -e "${_ttl}(6/7) $frase ➜ ${_nml}\n"
            sudo apt autoremove -y
        }

        # 7- Mostra informações.
        function f7() {
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
                echo -e "${_ttl}(7/4) $frase ➜ ${_nml}"
            else
                criarLog
                notify-send -i ~/.atualizar/imagens/atualizar.png "$notificacaoPadrao" "$frase ➜"
                echo -e "${_ttl}(7/7) $frase ➜ ${_nml}"
            fi

            echo -e "\n${_bld}$info1 ${_nml}"
            sudo uname -o
            echo -e "\n${_bld}$info2 ${_nml}"
            sudo uname -r
            echo -e "\n${_bld}$info3 ${_nml}"
            sudo cat /etc/issue.net
            echo -e "\n${_bld}$info4\n${_nml}$numeroPacotes"

            mostrarApps=false
            for i in ${!vetorValor[*]}; do
                if [ ${vetorValor[i]} == true ]; then
                    mostrarApps=true
                fi
            done

            if $mostrarApps; then
                echo -e "\n${_bld}$infoApps ${_nml}"
                for i in ${!vetorValor[*]}; do
                    if [ ${vetorValor[i]} == true ] && [ "${vetorNome[i]}" != "(vazio)" ]; then
                        echo -e "${vetorNome[i]}"
                    fi
                done
            fi

            echo -e "\n${_lnk}https://github.com/bill1300/atualizar\a$infoLink (GitHub)${_lnk}\a"
            echo -e "${_lnk}https://forms.gle/ysh5avJ1WCGsWeoH6\aFeedback (Google Forms)${_lnk}\a"
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

                echo -e "\n${_alt}$alerta"
                echo -e "\n${_alt}S - $info1"
                echo -e "${_alt}N - $info2\e[0m"

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
                echo -e "${_alt}$info1 (S/N) ${_nml}"
                read -n1 valorReiniciar
            done

            while [ "$valorInstalarApps" != "S" -a "$valorInstalarApps" != "s" -a "$valorInstalarApps" != "N" -a "$valorInstalarApps" != "n" ]; do
                clear
                echo -e "${_ttl} $info2 (S/N) ${_nml}"
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
                        echo -e "${_bld}$frase ${vetorNome[i]} ➜ ${_nml}\n"
                        sudo flatpak install ${vetorComando[i]} -y
                    fi
                done
                sudo flatpak update -y
            }

            # Paginação de menu de Apps.
            function paginasApps() {

                function imprimirTela() {
                    if [ ${vetorValor[i]} == true ]; then
                        echo -e "${_ttl}(OK)  $indiceCatalogo - ${vetorNome[i]} ${_nml}"
                    else
                        echo -e "${_ttl}(  )  $indiceCatalogo - ${vetorNome[i]} ${_nml}"
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
                f7 $parametroExec
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
                reiniciarComputador
            fi
        else
            apresentarErroConexao
        fi
    }

    function apresentarErroConexao() {
        clear

        if [ "$idioma" = "pt-br" ]; then
            echo -e "${_ttl}Sem conexão com a Internet ➜ ${_nml}\n
 Tente:
   Verificar os cabos de rede, modem e roteador.
   Conectar à rede Wi-Fi novamente.
   Entrar em contato com o suporte do seu provedor de Internet.\n"
        fi
        if [ "$idioma" = "en-us" ]; then
            echo -e "${_ttl}No Internet ➜ ${_nml}\n
 Try:
   Checking the network cables, modem and router.
   Reconnecting to Wi-Fi.
   Contact your ISP's support.\n"
        fi
    }
    # Função de desinstalar programa e registros.
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
            echo -e "${_ttl}$info3. ${_nml}"
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
                echo -e " ${_alt}$info1 (S/N) \e[0m"
                read -n1 valorDesinstalar
            done
            if [ "$valorDesinstalar" = "S" -o "$valorDesinstalar" = "s" ]; then
                desinstalarComandos
            else
                clear
                echo -e "${_ttl}$info2 ${_nml}"
            fi
        fi
    }

    # Função de apresentar parâmetros de entrada.
    function ajuda() {
        clear
        if [ "$idioma" = "pt-br" ]; then
            echo -e "${_ttl}Comandos: ${_nml}\n
 ${_bld}-a${_nml} ou ${_bld}--ajuda${_nml} ➜         Use para apresentar os parâmetros de entrada e outras informações.\n
 ${_bld}-d${_nml} ou ${_bld}--desinstalar${_nml} ➜   Use para desinstalar, há uma mensagem para confirmação.
 ${_bld}-D${_nml} ➜                    Use para desinstalar.\n
 ${_bld}-s${_nml} ou ${_bld}--simples${_nml} ➜       Use para executar somente funções simples de atualização de diretórios, kernel e distribuição.\n
 ${_bld}-r${_nml} ou ${_bld}--reescrever${_nml} ➜    Use para baixar e instalar a última versão do arquivo disponível, há um pedido de confirmação.
 ${_bld}-R${_nml} ➜                    Use para baixar E instalar a última versão do arquivo disponível.\n
 ${_bld}-i [idioma]${_nml} ou ${_bld}--idioma [idioma]${_nml} ➜    Use para mudar o idioma.\n
    ${_bld}Idiomas disponíveis:${_nml}
    Português do Brasil ➜      pt-br
    United States English ➜    us-en\n
 ${_bld}-v${_nml} ou ${_bld}--versao${_nml} ➜        Use para apresentar a versão atual.\n
 \e]8;;https://github.com/bill1300/atualizar\aProjeto Atualizar (GitHub)\e]8;;\a
 \e]8;;https://bill1300.github.io/atualizar-docs/\aDocumentação (GitHub Pages)\e]8;;\a
 \e]8;;https://forms.gle/ysh5avJ1WCGsWeoH6\aFeedback (Google Forms)\e]8;;\a\n"
        fi
        if [ "$idioma" = "en-us" ]; then
            echo -e "${_ttl}Commands: ${_nml}\n
 ${_bld}-a${_nml} or ${_bld}--ajuda${_nml} ➜         Use to display input parameters and other information.\n
 ${_bld}-d${_nml} or ${_bld}--desinstalar${_nml} ➜   Use to uninstall, there is a message for confirmation.
 ${_bld}-D${_nml} ➜                    Use to uninstall.\n
 ${_bld}-s${_nml} or ${_bld}--simples${_nml} ➜       Use to perform simple directory, kernel, and distribution update functions only.\n
 ${_bld}-r${_nml} or ${_bld}--reescrever${_nml} ➜    Use to download and install the latest available file version, there is a message for confirmation.
 ${_bld}-R${_nml} ➜                    Use to download and install the latest available file version.\n
  ${_bld}-i [language]${_nml} ou ${_bld}--idioma [language]${_nml} ➜    Use to change language.\n
    ${_bld}Available languages:${_nml}
    Português do Brasil ➜      pt-br
    United States English ➜    us-en\n
 ${_bld}-v${_nml} or ${_bld}--versao${_nml} ➜        Use to display the current version\n
 \e]8;;https://github.com/bill1300/atualizar\aAtualizar project (GitHub)\e]8;;\a
 \e]8;;https://bill1300.github.io/atualizar-docs/\aDocumentation (GitHub Pages)\e]8;;\a
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
                    echo -e "${_ttl}Você realmente deseja reescrever o arquivo para a versão mais atual? (S/N) ${_nml}"
                    read -n1 valorReescrita
                done
                if [ "$valorReescrita" = "S" -o "$valorReescrita" = "s" ]; then
                    atualizarArquivoComandos
                else
                    clear
                    echo -e "${_ttl}Operação cancelada ${_nml}"
                fi
            fi
        else
            apresentarErroConexao
        fi
    }

    # Função de apresentar versão.
    function mostrarVersao() {
        if [ "$idioma" = "pt-br" ]; then
            echo -e "Atualizar está na versão: ${_bld}$versao${_nml}"
        fi
        if [ "$idioma" = "en-us" ]; then
            echo -e "Atualizar is in version: ${_bld}$versao${_nml}"
        fi
    }

    # Função de mudar o idioma.
    function mudarIdioma() {
        idiomaEntrada=$1

        if [ "$idioma" = "pt-br" ]; then
            frase="Parâmetro desconhecido, tente: ${_bld}atualizar --ajuda${_nml} para ver os parâmetros disponíveis."
        fi
        if [ "$idioma" = "en-us" ]; then
            frase="Unknown parameter, try: ${_bld}atualizar --ajuda${_nml} to see available  e parameters."
        fi
        
        if [ -z "$idiomaEntrada" ]; then
            echo -e "$frase"
        else
            case "$idiomaEntrada" in
                pt-br)
                    escrever="idioma=\"pt-br\""
                    sudo sed -i "1c$escrever" ~/.atualizar/dados.list
                    echo -e "O Atualizar está no idioma: ${_bld}Português do Brasil${_nml}"
                ;;
                en-us)
                    escrever="idioma=\"en-us\""
                    sudo sed -i "1c$escrever" ~/.atualizar/dados.list
                    echo -e "Atualizar is in the language: ${_bld}United States English${_nml}"
                ;;
                *)
                    echo -e "$frase"
                ;;
            esac
        fi
    }

    # Função de apresentar histórico (lista de arquivo: ~/.atualizar/dados.list)
    function apresentarHistorico() {
        if [ "$idioma" = "pt-br" ]; then
            cabecalho="Horário / Data / Versão / Número de pacotes"
            info1="Para acessar todos os registros de atualizações com mais informações entre no diretório: ➜  ${_bld}~/.atualizar/registros/${_nml}\n"
            info2="Histórico vazio."
        fi
        if [ "$idioma" = "en-us" ]; then
            cabecalho="Time / Date / Version / Number of packages"
            info1="To access all updates registros with more information, enter the directory: ➜  ${_bld}~/.atualizar/registros/${_nml}\n"
            info2="History is empty."
        fi
        clear
        cmdLista=$(sudo sed -n '2,$p' ~/.atualizar/dados.list)
        if [ -z "$cmdLista" ]; then
            echo -e "${_bld}$info2"
        else
            echo -e "$info1"
            echo -e "${_ttl}$cabecalho"
            echo -e "${_nml}$cmdLista"
        fi
    }

    idiomaDoc=$(sudo sed -n '1p' ~/.atualizar/dados.list)
    sudo sed -i "3c$idiomaDoc" /bin/atualizar >/dev/null
    
    if [ "$idioma" = "pt-br" ]; then
        info1="Parâmetro desconhecido, tente: ${_bld}atualizar --ajuda${_nml} para ver os parâmetros disponíveis."
        info2="Iniciando..."
    fi
    if [ "$idioma" = "en-us" ]; then
        info1="Unknown parameter, try: ${_bld}atualizar --ajuda${_nml} to see available parameters."
        info2="Starting..."
    fi

    comandoEnderecoFixo=$(sudo find /usr/bin -type f -name atualizar)

    if [ -z "$comandoEnderecoFixo" ]; then
        echo -e "${_ttl}$info2 ${_nml}"
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
            -h | --historico)
                apresentarHistorico
                ;;
            *)
                echo -e "$info1"
                ;;
            esac
        else
            echo -e "${_ttl}$info2 ${_nml}"
            execAtualizar
        fi
    fi
}
param1=$1
param2=$2
verificarArquivo
