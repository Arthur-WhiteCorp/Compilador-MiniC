#!/bin/bash

# Perguntar ao usuário se ele deseja baixar o arquivo
echo "Este programa necessita do arquivo ANTLR JAR para funcionar corretamente."
echo "Caso ele não esteja disponível no seu computador, o arquivo será baixado automaticamente."

# Perguntar ao usuário se ele autoriza o download do arquivo
echo -n "Você deseja permitir o download do arquivo ANTLR JAR? (y/n): "
read resposta
# Converter a resposta para minúsculo
resposta=$(echo "$resposta" | tr '[:upper:]' '[:lower:]')

# Verificar se a resposta é 'y' ou 'sim' (aceitação)
if [[ "$resposta" == "y" || "$resposta" == "sim" ]]; then
    echo "Você aceitou o download."
    exit 0  # Sucesso
else
    echo "Você rejeitou o download."
    exit 1  # Falha
fi
