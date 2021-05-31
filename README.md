### Instalação
 Para instalar o programa execute o comando:
>bash atualizar.sh

### Execução
 Para utilizar o programa execute o comando:
>atualizar

### Parâmetros
 Use para apresentar os parâmetros de entrada e o link do projeto (GitHub):
 `-a`, `--ajuda`, `-h` ou `--help`
 Exemplo:
> atualizar --ajuda

 Use para desinstalar:
 `-d`, `--desinstalar`, `-u` ou `--uninstall`
 Exemplo:
> atualizar --desinstalar

 Use para executar somente funções simples de atualização de diretórios, kernel e distribuição:
 `-s`, `--simples` ou `--simple`
 Exemplo:
> atualizar --simples

### Aplicativos
Alguns dos pacotes instalados dos aplicativos disponibilizados usam **snap**, que é instalado quando algum dos aplicativo da lista for selecionado.

Aplicativo  | Comando de instalação
------------- | -------------
[Spotify](https://www.spotify.com/br/) | snap install spotify
[Visual Studio Code](https://code.visualstudio.com/) | snap install code
[Discord](https://discord.com/) | snap install discord
[Opera](https://www.opera.com/pt-br) | snap install opera
[VLC](https://www.videolan.org/vlc/index.pt-BR.html) | snap install vlc
[git](https://git-scm.com/) | apt install git
[GitKraken](https://www.gitkraken.com/) | snap install gitkraken --classic
Ubuntu Tweaks (GNOME) | apt install gnome-tweaks
[Telegram Desktop](https://desktop.telegram.org/) | snap install telegram-desktop
[Node.js](https://nodejs.org/en/) | snap install node --classic

### Comandos de atualização do sistema
Comando  | Descrição
------------- | -------------
apt update -y | Atualiza os diretórios atuais.
apt upgrade -y | Atualiza o sistema com novos diretórios necessários.
apt dist-upgrade -y | Atualiza a distribuição Linux.
apt autoclean -y | Remove os arquivos desnecessários para o sistema usados na atualização.
apt autoremove -y | Remove os arquivos do repositório local desnecessários para o sistema.   
apt clean -y | Remove os arquivos do **/var/cache/apt/archives/** e **/var/cache/apt/archives/partial/**.
uname -o | Apresenta a versão do sistema.
uname -v | Apresenta a versão do Kernel Linux.
cat /etc/issue.net | Apresenta a versão da distribuição Linux.
reboot | Reinicia o computador.
