#!/bin/bash

#Verificando arquivo script.
function verificarArquivo(){

    function criarDesinstalar(){
        echo -e "#!/bin/bash\nfunction desinstalar() {\n\techo -e '\e[34;1mTchau \e[1;37m' \n\tsudo rm -f /bin/atualizar\n\tsudo rm -f /bin/atualizar-desinstalar\n}\ndesinstalar" | sudo tee -a atualizar-desinstalar.sh > /dev/null
        sudo chmod +x atualizar-desinstalar.sh
        sudo mv atualizar-desinstalar.sh atualizar-desinstalar
    }


    function moverArquivos(){
        comandoAddrMover=`sudo find / -type f -name 'atualizar.sh' 2>/dev/null`
        sudo mv $comandoAddrMover /bin
        cd /bin
        sudo chmod +x atualizar.sh
        sudo mv atualizar.sh atualizar
        clear
        echo -e " \e[34;1mInstalação completa. \e[1;37m"
    }
    
    function execAtualizar(){
        
        valor1="0" # Informação de reinicialização
        valor2="0" # Informação de instalação de apps
        
        # 1- Atualizar os repositórios.
        function f1() {
            clear
            echo ""
            echo -e " \e[34;1m(1/7)Atualizando Repositórios. \e[1;37m"
            echo ""
            sudo apt update -y
        }
        
        # 2- Atualizar Kernel Linux.
        function f2() {
            clear
            echo ""
            echo -e " \e[34;1m(2/7)Atualizando Kernel Linux. \e[1;37m"
            echo ""
            sudo apt upgrade -y
        }
        
        # 3- Atualizar a distribuição Linux.
        function f3() {
            clear
            echo ""
            echo -e " \e[34;1m(3/7)Atualizando Distribuição Linux. \e[1;37m"
            echo ""
            sudo apt dist-upgrade -y
        }
        
        # 4- Removendo arquivos desnecessários para o Sistema usados na atualização.
        function f4() {
            clear
            echo ""
            echo -e " \e[34;1m(4/7)Removendo arquivos desnecessários para o Sistema usados na atualização. \e[1;37m"
            echo ""
            sudo apt autoclean -y
        }
        
        # 5- Removendo arquivos do repositório local desnecessários para o Sistema.
        function f5() {
            clear
            echo ""
            echo -e " \e[34;1m(5/7)Removendo arquivos do repositório local desnecessários para o Sistema.  \e[1;37m"
            echo ""
            sudo apt autoremove -y
        }
        
        # 6- Removendo Remove os arquivos do /var/cache/apt/archives/ e /var/cache/apt/archives/partial/.
        function f6() {
            clear
            echo ""
            echo -e " \e[34;1m(6/7)Removendo os arquivos do /var/cache/apt/archives/ e /var/cache/apt/archives/partial/. \e[1;37m"
            echo ""
            sudo apt clean -y
        }
        
        # 7- Mostra versões instaladas.
        function f7() {
            clear
            echo -e "\e[34;1m(7/7)Atualização conclúida com sucesso. \e[1;37m"
            echo ""
            echo -e "\e[34;0mSistema: \e[1;37m"
            sudo uname -o
            echo ""
            echo -e "\e[34;0mVersão do Kernel: \e[1;37m"
            sudo uname -r
            echo ""
            echo -e "\e[34;0mVersão da distribuição: \e[1;37m"
            sudo cat /etc/issue.net
            echo ""
            echo -e '\e]8;;https://github.com/bill1300/atualizar\aProjeto atualizar (GitHub)\e]8;;\a'
            echo ""
        }
        
        # Adicionar temporizador para leitura do usuário de f7()
        function sys_reboot() {
            if [ "$valor1" = "S" ] || [ "$valor1" = "s" ]; then
                echo -e ""
                echo -e "\e[1;41mO SISTEMA VAI REINICIAR EM 60 SEGUNDOS."
                echo -e ""
                echo -e "\e[1;41mS - PARA REINICIAR AGORA"
                echo -e "\e[1;41mN - PARA CANCELAR O REINÍCIO AUTOMÁTICO.\e[0m"
                
                v_cont=0
                valorR="X"
                while [ $v_cont -lt 60 ]; do
                    read -n1 -t1 valorR
                    if [ "$valorR" == "S" -o "$valorR" == "s" ]; then
                        sudo reboot
                    fi
                    if [ "$valorR" == "N" -o "$valorR" == "n" ]; then
                        clear
                        exit
                    fi
                    let v_cont=v_cont+1
                done
                sudo reboot
            fi
        }
        
        # Informação de usuário para execução
        function menuVerificacao() {
            while [ "$valor1" != "S" -a "$valor1" != "s" -a "$valor1" != "N" -a "$valor1" != "n" ]; do
                clear
                echo -e " \e[1;41m DESEJA REINICIAR APÓS A ATUALIZAÇÃO? (S/N) \e[0m"
                read -n1 valor1
            done
            
            while [ "$valor2" != "S" -a "$valor2" != "s" -a "$valor2" != "N" -a "$valor2" != "n" ]; do
                clear
                echo -e " \e[34;1m Deseja instalar algum outro aplicativo? (S/N) \e[1;37m"
                read -n1 valor2
            done
            
            if [ $valor2 = "S" -o $valor2 = "s" ]; then
                f_apps
            fi
        }
        
        function f_apps() {
            
            valorRecebido="0" 	#Valor de entrada do usuário
            nPagina=1 	  		#Paginamento de Apps
            nMaxPagina=3        #Numero Maximo de paginas
            
            v_app1=0          	#Spotify
            v_app2=0          	#VSCode
            v_app3=0          	#Discord
            v_app4=0          	#Opera
            v_app5=0         	#VLC
            v_app6=0         	#GitKraken
            v_app7=0         	#GNOME Tweaks
            v_app8=0            #Telegram Desktop
            v_app9=0            #Node.js
            v_app10=0
            v_app11=0
            v_app12=0
            v_app13=0
            v_app14=0
            v_app15=0
            
            # Verificação de instalar/não instalar (Switch true-false)
            function switchValorApp(){
                
                valorRecebido=$(( ($nPagina - 1) * 5 + $valorRecebido ))
                
                if [ $valorRecebido = 1 ]; then
                    if [ $v_app1 = 1 ]; then
                        v_app1=0
                    else
                        v_app1=1
                    fi
                fi
                
                if [ $valorRecebido = 2 ]; then
                    if [ $v_app2 = 1 ]; then
                        v_app2=0
                    else
                        v_app2=1
                    fi
                fi
                
                if [ $valorRecebido = 3 ]; then
                    if [ $v_app3 = 1 ]; then
                        v_app3=0
                    else
                        v_app3=1
                    fi
                fi
                
                if [ $valorRecebido = 4 ]; then
                    if [ $v_app4 = 1 ]; then
                        v_app4=0
                    else
                        v_app4=1
                    fi
                fi
                
                if [ $valorRecebido = 5 ]; then
                    if [ $v_app5 = 1 ]; then
                        v_app5=0
                    else
                        v_app5=1
                    fi
                fi
                
                if [ $valorRecebido = 6 ]; then
                    if [ $v_app6 = 1 ]; then
                        v_app6=0
                    else
                        v_app6=1
                    fi
                fi
                
                if [ $valorRecebido = 7 ]; then
                    if [ $v_app7 = 1 ]; then
                        v_app7=0
                    else
                        v_app7=1
                    fi
                fi
                
                if [ $valorRecebido = 8 ]; then
                    if [ $v_app8 = 1 ]; then
                        v_app8=0
                    else
                        v_app8=1
                    fi
                fi
                
                if [ $valorRecebido = 9 ]; then
                    if [ $v_app9 = 1 ]; then
                        v_app9=0
                    else
                        v_app9=1
                    fi
                fi
                
                if [ $valorRecebido = 10 ]; then
                    if [ $v_app10 = 1 ]; then
                        v_app10=0
                    else
                        v_app10=1
                    fi
                fi
                
                if [ $valorRecebido = 11 ]; then
                    if [ $v_app11 = 1 ]; then
                        v_app11=0
                    else
                        v_app11=1
                    fi
                fi
                
                if [ $valorRecebido = 12 ]; then
                    if [ $v_app12 = 1 ]; then
                        v_app12=0
                    else
                        v_app12=1
                    fi
                fi
                
                if [ $valorRecebido = 13 ]; then
                    if [ $v_app13 = 1 ]; then
                        v_app13=0
                    else
                        v_app13=1
                    fi
                fi
                
                if [ $valorRecebido = 14 ]; then
                    if [ $v_app14 = 1 ]; then
                        v_app14=0
                    else
                        v_app14=1
                    fi
                fi
                
                if [ $valorRecebido = 15 ]; then
                    if [ $v_app15 = 1 ]; then
                        v_app15=0
                    else
                        v_app15=1
                    fi
                fi
            }
            
            #Definição de comandos para instalação
            function instalarApps(){
                sudo apt install snapd
                
                if [ $v_app1 -eq 1 ]; then
                    echo -e " \e[34;1mInstalando Spotify\e[1;37m"
                    sudo snap install spotify
                    clear
                fi
                
                if [ $v_app2 -eq 1 ]; then
                    echo -e " \e[34;1mInstalando Visual Studio Code\e[1;37m"
                    sudo snap install vscode --classic
                    clear
                fi
                
                if [ $v_app3 -eq 1 ]; then
                    echo -e " \e[34;1mInstalando Discord\e[1;37m"
                    sudo snap install discord
                    clear
                fi
                
                if [ $v_app4 -eq 1 ]; then
                    echo -e " \e[34;1mInstalando Opera\e[1;37m"
                    sudo snap install opera
                    clear
                fi
                
                if [ $v_app5 -eq 1 ]; then
                    echo -e " \e[34;1mInstalando VLC\e[1;37m"
                    sudo snap install vlc
                    clear
                fi
                
                if [ $v_app6 -eq 1 ]; then
                    echo -e " \e[34;1mInstalando GitKraken (com git)\e[1;37m"
                    sudo apt install git
                    sudo snap install gitkraken --classic
                    clear
                fi
                
                if [ $v_app7 -eq 1 ]; then
                    echo -e " \e[34;1mInstalando Ubuntu Tweaks (GNOME)\e[1;37m"
                    sudo apt-get install gnome-tweaks
                    clear
                fi
                
                if [ $v_app8 -eq 1 ]; then
                    echo -e " \e[34;1mInstalando Telegram Desktop\e[1;37m"
                    sudo snap install telegram-desktop
                    clear
                fi
                
                if [ $v_app9 -eq 1 ]; then
                    echo -e " \e[34;1mInstalando Node.js\e[1;37m"
                    sudo snap install node --classic
                    clear
                fi
                
                if [ $v_app10 -eq 1 ]; then
                    echo -e " \e[34;1m \e[1;37m"
                fi
                
                if [ $v_app11 -eq 1 ]; then
                    echo -e " \e[34;1m \e[1;37m"
                fi
                
                if [ $v_app12 -eq 1 ]; then
                    echo -e " \e[34;1m \e[1;37m"
                fi
                
                if [ $v_app13 -eq 1 ]; then
                    echo -e " \e[34;1m \e[1;37m"
                fi
                
                if [ $v_app14 -eq 1 ]; then
                    echo -e " \e[34;1m \e[1;37m"
                fi
                
                if [ $v_app15 -eq 1 ]; then
                    echo -e " \e[34;1m \e[1;37m"
                fi
            }
            
            #Paginação de menu de Apps
            function paginasApps(){
                case $nPagina in
                    1)
                        clear
                        if [ $v_app1 = 1 ]; then
                            echo -e " \e[34;1m(OK)  1 - Spotify\e[1;37m"
                        else
                            echo -e " \e[34;1m(  )  1 - Spotify\e[1;37m"
                        fi
                        
                        if [ $v_app2 = 1 ]; then
                            echo -e " \e[34;1m(OK)  2 - Visual Studio Code\e[1;37m"
                        else
                            echo -e " \e[34;1m(  )  2 - Visual Studio Code\e[1;37m"
                        fi
                        
                        if [ $v_app3 = 1 ]; then
                            echo -e " \e[34;1m(OK)  3 - Discord\e[1;37m"
                        else
                            echo -e " \e[34;1m(  )  3 - Discord\e[1;37m"
                        fi
                        
                        if [ $v_app4 = 1 ]; then
                            echo -e " \e[34;1m(OK)  4 - Opera\e[1;37m"
                        else
                            echo -e " \e[34;1m(  )  4 - Opera\e[1;37m"
                        fi
                        
                        if [ $v_app5 = 1 ]; then
                            echo -e " \e[34;1m(OK)  5 - VLC\e[1;37m"
                        else
                            echo -e " \e[34;1m(  )  5 - VLC\e[1;37m"
                        fi
                    ;;
                    2)
                        clear
                        if [ $v_app6 = 1 ]; then
                            echo -e " \e[34;1m(OK)  1 - GitKraken (com git)\e[1;37m"
                        else
                            echo -e " \e[34;1m(  )  1 - GitKraken (com git)\e[1;37m"
                        fi
                        
                        if [ $v_app7 = 1 ]; then
                            echo -e " \e[34;1m(OK)  2 - Ubuntu Tweaks (GNOME)\e[1;37m"
                        else
                            echo -e " \e[34;1m(  )  2 - Ubuntu Tweaks (GNOME)\e[1;37m"
                        fi
                        
                        if [ $v_app8 = 1 ]; then
                            echo -e " \e[34;1m(OK)  3 - Telegram Desktop\e[1;37m"
                        else
                            echo -e " \e[34;1m(  )  3 - Telegram Desktop\e[1;37m"
                        fi
                        
                        if [ $v_app9 = 1 ]; then
                            echo -e " \e[34;1m(OK)  4 - Node.js\e[1;37m"
                        else
                            echo -e " \e[34;1m(  )  4 - Node.js\e[1;37m"
                        fi
                        
                        if [ $v_app10 = 1 ]; then
                            echo -e " \e[34;1m(OK)  5 - (vazio)\e[1;37m"
                        else
                            echo -e " \e[34;1m(  )  5 - (vazio)\e[1;37m"
                        fi
                    ;;
                    3)
                        clear
                        if [ $v_app11 = 1 ]; then
                            echo -e " \e[34;1m(OK)  1 - (vazio)\e[1;37m"
                        else
                            echo -e " \e[34;1m(  )  1 - (vazio)\e[1;37m"
                        fi
                        
                        if [ $v_app12 = 1 ]; then
                            echo -e " \e[34;1m(OK)  2 - (vazio)\e[1;37m"
                        else
                            echo -e " \e[34;1m(  )  2 - (vazio)\e[1;37m"
                        fi
                        
                        if [ $v_app13 = 1 ]; then
                            echo -e " \e[34;1m(OK)  3 - (vazio)\e[1;37m"
                        else
                            echo -e " \e[34;1m(  )  3 - (vazio)\e[1;37m"
                        fi
                        
                        if [ $v_app14 = 1 ]; then
                            echo -e " \e[34;1m(OK)  4 - (vazio)\e[1;37m"
                        else
                            echo -e " \e[34;1m(  )  4 - (vazio)\e[1;37m"
                        fi
                        
                        if [ $v_app15 = 1 ]; then
                            echo -e " \e[34;1m(OK)  5 - (vazio)\e[1;37m"
                        else
                            echo -e " \e[34;1m(  )  5 - (vazio)\e[1;37m"
                        fi
                    ;;
                esac
            }
            
            # Loop de seleção de aplicativos
            while [ $valorRecebido != "S" -a $valorRecebido != "s" -a $valorRecebido != "N" -a $valorRecebido != "n" ]; do
                
                if [ $valorRecebido = "P" -o $valorRecebido = "p" ]; then
                    let nPagina=nPagina+1
                    if [ $nPagina -gt $nMaxPagina ]; then
                        let nPagina=1
                    fi
                fi
                paginasApps
                
                echo ""
                echo " S-Continuar  N-Cancelar  P-Próxima Página ($nPagina/$nMaxPagina)"
                read -n1 valorRecebido
                clear
                
                if [ $valorRecebido != "S" -a $valorRecebido != "s" ];then
                    if [ $valorRecebido -ge 1 -a $valorRecebido -le 5 ];then
                        switchValorApp
                    fi
                fi
                
            done
            
            # Caso S - Instalação de aplicativos
            if [ $valorRecebido = "S" -o $valorRecebido = "s" ];then
                instalarApps
                # Caso N - Limpando variáveis
            else
                v_app1=0
                v_app2=0
                v_app3=0
                v_app4=0
                v_app5=0
                
                v_app6=0
                v_app7=0
                v_app8=0
                v_app9=0
                v_app10=0
                
                v_app11=0
                v_app12=0
                v_app13=0
                v_app14=0
                v_app15=0
                
                clear
            fi
        }
        
        menuVerificacao
        f1
        f2
        f3
        f4
        f5
        f6
        f7
        sys_reboot
        
    }
    
    echo -e " \e[34;1mIniciando... \e[1;37m"
    comandoAddrFixo=`sudo find /bin -type f -name "atualizar"`
    
    if [ -z $comandoAddrFixo ];then
        moverArquivos
        criarDesinstalar   
    else
        execAtualizar
    fi
}

##################################################

verificarArquivo