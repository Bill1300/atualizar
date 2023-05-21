Versão: 23.5.4
[Documentação ➜](https://bill1300.github.io/atualizar-docs/)

Este obra está licenciado com uma [Licença Creative Commons Atribuição-NãoComercial-CompartilhaIgual 4.0 Internacional](https://creativecommons.org/licenses/by-nc-sa/4.0/).

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

#### Mudar idioma ➜
 Use para mudar o idioma:
 `-i` ou `--idioma`, seguido da sigla do idioma selecionado. (Por padrão é selecionado **Português do Brasil**).

 Exemplo:
> atualizar --idioma pt-br

Idiomas disponíveis:

| Idiomas                      | Parâmetro |
| ---------------------------- | --------- |
| :brazil: Português do Brasil | pt-br     |
| :us: United States English   | en-us     |

#### Agendar atualização ➜
 Use para agendar atualização:
 `-t` ou `--temporizador`, seguido da sigla do valor selecionado. (Por padrão é selecionado **nenhum**).

 Exemplo:
> atualizar --temporizador mes

Períodos disponíveis:

| Períodos                                 | Parâmetro       |
| ---------------------------------------- | --------------- |
| Agenda atualizações todas as **horas**   | `hora` ou `1`   |
| Agenda atualizações todas os **dias**    | `dia` ou `2`    |
| Agenda atualizações todas as **semanas** | `semana` ou `3` |
| Agenda atualizações todas os **meses**   | `mes` ou `4`    |

Para deletar os agendamentos de atualizações utilize: `nenhum` ou `0`

#### Mostrar histórico ➜
 Use para apresentar um histórico de execuções com detalhes:
 `-h` ou `--historico`

 Exemplo:
> atualizar --historico

 Com a adição de um parâmetro é possível exportar a planilha:

| Extensões                                                | Parâmetro |
| -------------------------------------------------------- | --------- |
| Exporta o histórico em uma planilha com extensão **CSV** | csv       |
| Exporta o histórico em uma planilha com extensão **XML** | xml       |

 A planilha é gerada no diretório: `~/.atualizar/planinhas`

#### Mostrar versão ➜
 Use para apresentar a versão atual:
 `-v` ou `--versao`

 Exemplo:
> atualizar --versao

### Logs
A aplicação cria documentos de texto no diretório `~/.atualizar/registros` mostrando as informações de todas as vezes que executado. O arquivo de texto é salvo com a data, nome do usuário, versões modificadas e pacotes instalados.

### Feedback
Você teve algum problema ao executar? Alguma ideia de funcionalidade nova? [Escreva aqui ➜](https://forms.gle/ysh5avJ1WCGsWeoH6)
