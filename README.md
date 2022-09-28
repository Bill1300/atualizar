Versão: 22.09

<div align="center">
  <img width="128" height="128" src="https://user-images.githubusercontent.com/42590905/192646234-96f838eb-a651-40fb-b8ef-c528b6aa7bc3.png">
</div>

### Instalação
 Para instalar o programa execute o comando:
>bash atualizar.sh

### Execução
 Para utilizar o programa execute o comando:
>atualizar

Ou execute o aplicativo "atualizar" na sua lista de aplicativos.

### Parâmetros
#### Ajuda ➜
 Use para apresentar os parâmetros de entrada e o link do projeto (GitHub):
 `-a` ou `--ajuda`

 Exemplo:
> atualizar --ajuda

#### Desinstalar ➜
 Use para desinstalar:
 `-d` ou `--desinstalar` (use `-D` para desinstalar sem uma confirmação).

 Exemplo:
> atualizar --desinstalar

#### Modo "Simples" ➜
 Use para executar somente funções simples de atualização de diretórios, kernel e distribuição:
 `-s`, `--simples`

 Exemplo:
> atualizar --simples

#### Reescrever ➜
 Use para baixar e instalar a última versão do arquivo disponível:
 `-r` ou `--reescrever` (use `-R` para reescrever sem uma confirmação).

 Exemplo:
> atualizar --reescrever

#### Mostrar versão ➜
 Use para apresentar a versão atual:
 `-v` ou `--versao`

 Exemplo:
> atualizar --versao

#### Mudar idioma ➜
 Use para mudar o idioma:
 `-i` ou `--idioma`, seguido da sigla do idioma selecionado. (Por padrão é selecionado **Português do Brasil**).

 Exemplo:
> atualizar --idioma pt-br

Idioma  | Sigla
------------- | -------------
Português do Brasil | pt-br
United States English | en-us



### Aplicativos
Os aplicativos disponibilizados usam **flatpak**, que é instalado quando algum dos aplicativo da lista for selecionado.

Aplicativo  | Link de instalação
------------- | -------------
[Spotify ➜](https://www.spotify.com/br/) | https://dl.flathub.org/repo/appstream/com.spotify.Client.flatpakref
[Discord ➜](https://discord.com/) | https://dl.flathub.org/repo/appstream/com.discordapp.Discord.flatpakref
[Telegram Desktop ➜](https://desktop.telegram.org/) | https://dl.flathub.org/repo/appstream/org.telegram.desktop.flatpakref
[Slack ➜](https://slack.com/) | https://dl.flathub.org/repo/appstream/com.slack.Slack.flatpakref
[Draw.io ➜](https://www.diagrams.net) | https://dl.flathub.org/repo/appstream/com.jgraph.drawio.desktop.flatpakref
[Visual Studio Code ➜](https://code.visualstudio.com/) | https://dl.flathub.org/repo/appstream/com.visualstudio.code.flatpakref
[GitKraken ➜](https://www.gitkraken.com) | https://dl.flathub.org/repo/appstream/com.axosoft.GitKraken.flatpakref
[AnyDesk ➜](https://anydesk.com/pt) | https://dl.flathub.org/repo/appstream/com.anydesk.Anydesk.flatpakref
[AuthPass ➜](https://authpass.app) | https://dl.flathub.org/repo/appstream/app.authpass.AuthPass.flatpakref
[Google Chrome ➜](https://www.google.com/intl/pt-BR/chrome/) | https://dl.flathub.org/repo/appstream/com.google.Chrome.flatpakref

### Funções
Descrição | Comando | Modo
------------- | ------------- | -------------
Atualizar os repositórios. | apt update | Simples/Padrão
Atualizar Linux. | apt upgrade | Simples/Padrão
Atualizar a distribuição Linux. | apt dist-upgrade | Simples/Padrão
Atualizar grub. | update-grub | Padrão
Corrigir pacotes corrompidos. | apt install -f | Padrão
Remove os arquivos desnecessários para o sistema usados na atualização. | apt autoclean | Padrão
Remove os arquivos do repositório local desnecessários para o sistema. | apt autoremove | Padrão
Remove os arquivos do `/var/cache/apt/archives/` e `/var/cache/apt/archives/partial/`. | apt clean | Padrão
Atualizar programas Flatpak | flatpak update | Padrão

### Logs
A aplicação cria documentos de texto no diretório `~/.atualizar/logs` mostrando as informações de todas as vezes que executado. O arquivo de texto é salvo com a data, nome do usuário, versões modificadas e pacotes instalados.

### Feedback
Você teve algum problema ao executar? Alguma ideia de funcionalidade nova? [Escreva aqui ➜](https://forms.gle/ysh5avJ1WCGsWeoH6)
