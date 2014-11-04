#!/bin/bash

#
# Script backup-full: o objetivo desse script é criar um backup de todo o conteúdo pré-determinado, 
# ele também exclui backups full feitos a mais de 15 dias na mídia de destino;
#http://www.vivaolinux.com.br/artigo/Script-de-backup-full-+-diferencial-+-compactador-+-restauracao?pagina=2
#

echo "Programa de backup full"
#Autor: Jhoni Vieceli
#Programa de criação de backup full
echo " "

dadosfull() {
    SRCDIR="/projetos/Cursos/patterns" #diretórios que serão feito backup
    DSTDIR="/projetos/Cursos" #diretório de destino do backup
    DATA=`date +%d%m%Y%S` #pega data atual
    TIME_BKCP=+15 #número de dias em que será deletado o arquivo de backup

    #criar o arquivo full-data.tar no diretório de destino
    ARQ="$DSTDIR/full-$DATA.tar.gz"
    #data de inicio backup
    DATAIN=`date +%c`
    echo "Data de inicio: $DATAIN"
}

backupfull(){
    sync
    tar -czvf $ARQ $SRCDIR 
    if [ $? -eq 0 ] ; then
       echo "----------------------------------------"
            echo "Backup Full concluído com Sucesso"
       DATAFIN=`date +%c`
       echo "Data de termino: $DATAFIN"
       echo "Backup realizado com sucesso" >> /var/log/backup_full.log
       echo "Criado pelo usuário: $USER" >> /var/log/backup_full.log
       echo "INICIO: $DATAIN" >> /var/log/backup_full.log
       echo "FIM: $DATAFIN" >> /var/log/backup_full.log
       echo "-----------------------------------------" >> /var/log/backup_full.log
       echo " "
       echo "Log gerado em /var/log/backup_full.log"

    else
       echo "ERRO! Backup do dia $DATAIN" >> /var/log/backup_full.log
    fi   
}

procuraedestroifull(){
    #apagando arquivos mais antigos (a mais de 20 dias que existe)
    find $DSTDIR -name "f*" -ctime $TIME_BKCP -exec rm -f {} ";"
   if [ $? -eq 0 ] ; then
      echo "Arquivo de backup mais antigo eliminado com sucesso!"
   else
      echo "Erro durante a busca e destruição do backup antigo!"
   fi
}

dadosfull
backupfull
procuraedestroifull

exit 0