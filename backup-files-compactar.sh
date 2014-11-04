#!/bin/bash

#
#Esse é o script que cria o gz do backup criado pelo diferencial. 
#http://www.vivaolinux.com.br/artigo/Script-de-backup-full-+-diferencial-+-compactador-+-restauracao?pagina=4
#

echo "Script de compactação"
DSTDIR="/projetos/Cursos";

DATAIN=`date +%c`
echo "Data de inicio: $DATAIN"

gzip -9 "$DSTDIR/*.tar"

echo "Compactação concluída"
DATAFIN=`date +%c`
echo "Data de termino: $DATAFIN"
echo "Compactação concluída"
echo "INICIO: $DATAIN" >> /var/log/backup_compactacao.log
echo "FIM: $DATAFIN" >> /var/log/backup_compactacao.log
echo "Realizado pelo usuário: $USER" >> /var/log/backup_compactacao.log
echo "-----------------------------------" >> /var/log/backup_compactacao.log
echo "Log gerado em /var/log/backup_compactacao.log"

exit 0