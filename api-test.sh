#! /bin/bash

##########################################################
# Script para testes simples de uma API
# Paulo Collares
# ago/2021
##########################################################

#Variaveis globais
URL_BASE='https://swapi.dev/api/'
AUTHORIZATION=""

#Não modificar
COUNT_TESTS=0
COUNT_TESTS_OK=0

#Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

#Funcao para efetuar o teste do endpoint
function testEndpoint {
    METODO=$1
        case $METODO in
            "GET")
                ((COUNT_TESTS++))
                URL=$URL_BASE$2
                echo "Testando $URL ($METODO)..."
                status_code=$(curl -k -H "Authorization: $AUTHORIZATION" --write-out %{http_code} --connect-timeout 3 --max-time 3 --silent --output /dev/null $URL)
                if [ $status_code = 200 ]; then
                    ((COUNT_TESTS_OK++))
                    printf "${GREEN}OK${NC}"
                else
                    printf "${RED}Falhou ($status_code)${NC}"
                fi
                echo ""
                echo ""
            ;;
    esac
}

#Main
echo ""
echo "----------------------------------"
echo "------ INICIANDO TESTES ----------"
echo "----------------------------------"
echo ""

while read line; do
    [[ "$line" = ^# ]] && continue #Verifica se a linha é um comentário
        testEndpoint $line
done < "$1"

echo ""
echo "----------------------------------"
echo "------ TESTES FINALIZADOS --------"
echo "----------------------------------"

echo ""
echo "Resultados: "
echo ""

let COUNT_TESTS_FAIL=$COUNT_TESTS-$COUNT_TESTS_OK

if [ $COUNT_TESTS_OK = $COUNT_TESTS ]; then
    printf "${GREEN}Todos os $COUNT_TESTS testes foram aprovados!${NC}"
else
    printf "${RED}$COUNT_TESTS_FAIL de $COUNT_TESTS testes falharam${NC}"
fi

echo ""
echo ""
printf "Testes executados: $COUNT_TESTS, sucessos: $COUNT_TESTS_OK, falhas: $COUNT_TESTS_FAIL"
echo ""
echo ""

