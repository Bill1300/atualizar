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
[Discord](https://discord.com/) | snap install discord
[Telegram Desktop](https://desktop.telegram.org/) | snap install telegram-desktop
[Slack](https://slack.com/) | snap install slack --classic
[Draw.io](https://www.diagrams.net) | snap drawio
[Visual Studio Code (Classic)](https://code.visualstudio.com/) | snap install code
[Visual Studio Code Insiders (Classic)](https://code.visualstudio.com/insiders/) | snap install code-insiders --classic
[Apache NetBeans](https://netbeans.apache.org) | snap install netbeans --classic
[Android Studio](https://developer.android.com/studio) | snap install android-studio --classic
[InkScape](https://inkscape.org/pt-br/) | snap install inkscape

### Comandos de atualização do sistema
Comando  | Descrição
------------- | -------------
apt update | Atualiza os diretórios atuais.
apt upgrade | Atualiza o sistema com novos diretórios necessários.
apt dist-upgrade | Atualiza a distribuição Linux.
apt autoclean | Remove os arquivos desnecessários para o sistema usados na atualização.
apt autoremove | Remove os arquivos do repositório local desnecessários para o sistema.   
apt clean | Remove os arquivos do **/var/cache/apt/archives/** e **/var/cache/apt/archives/partial/**.
uname -o | Apresenta a versão do sistema.
uname -v | Apresenta a versão do Kernel Linux.
cat /etc/issue.net | Apresenta a versão da distribuição Linux.
reboot | Reinicia o computador.

### Logs
A aplicação cria documentos de texto no diretório **~/.atualizar/logs** mostrando as informações de todas as vezes que executado. O arquivo de texto é salvo com a data, nome do usuário, versões modificadas e pacotes instalados.