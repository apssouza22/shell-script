#!/bin/bash

#Autor: Jhoni Vieceli
#Programa de restauração de backup e visualização de registro
#http://www.vivaolinux.com.br/artigo/Script-de-backup-full-+-diferencial-+-compactador-+-restauracao?pagina=5

HD_O=/dev/sda1 #hd onde estão os arquivos de backup
HD_MTD=/mnt/teste #diretório onde será montado o hd de onde estão os backups 
DVD_MTD=/media/cdrom/ #dispositivo de mídia existente na máquina
DSTBKP=/mnt/extra/dir_bkp  #diretório onde o backup será restaurado (diretório deverá ser criado antes)
controle=0
DATA=`date +%x-%k%M%S`

principal(){
    clear
    if [ $controle -eq 0 ] ; then
       echo "Programa de restauração de backup"
       echo " "
       echo "1 - Restaurar Backup Full"
       echo "2 - Restaurar Backup Diferencial"
       echo "3 - Ver registros de backup"
       echo "4 - Sair"
       echo "Opção: "
       read opcao
    elif [ $controle -eq 1 ] ; then 
       echo "------------------------------------------------------"
       echo "ATENÇÃO: FALHA na tentativa anterior tente novamente"
       echo "------------------------------------------------------"
       echo " "
       echo "1 - Restaurar Backup Full"
       echo "2 - Restaurar Backup Diferencial"
       echo "3 - Ver registros de backup"
       echo "4 - Sair"
       echo "Opção: "
       read opcao
    else
       echo "-----------------------------------"
       echo "RESTAURAÇÃO REALIZADA COM SUCESSO!"
       echo "-----------------------------------"
       echo " "
       echo "1 - Restaurar Backup Full"
       echo "2 - Restaurar Backup Diferencial"
       echo "3 - Ver registros de backup"
       echo "4 - Sair"
       echo "ATENÇÃO! DEPOIS DE CONCLUÍDO O BACKUP, COPIAR OS ARQUIVOS DO DIRETÓRIO $DSTBKP PARA OUTRO DIRETÓRIO, CASO CONTRARIO A NOVA RESTAURAÇÃO APAGARA OS ARQUIVOS RESTAURADOS ANTERIORMENTE DO DIRETÓRIO $DSTBKP"
       echo "Log gerado em /var/log/restore.log"
       echo "Opção: "
       read opcao
    fi
    case $opcao in
       1) restorefull;;
       2) restoredif;;
       3) registros;;
       4) echo "Saindo...";;
       *) echo "Opção desconhecida"; principal;;
    esac
}

restorefull(){
    echo " "
    echo "Mídia (dvd ou hd)"
    read midia
    if [ $midia == dvd ] ; then
       #$XFSCHECK /dev/cdrom
       mount /dev/cdrom $DVD_MTD    #montar o dvd
       ls -lat $DVD_MTD      #listar arquivos por tamanho do dvd
       echo "Qual a data do arquivo que quer restaurar? (dd-mm-aaaa)"
       read "data"
       rm -rf $DSTBKP/*      #apagar arquivos do diretório de backup de destino
       cd $DSTBKP         #entra no diretório onde sera colocado o backup
       find $DVD_MTD -name "full-$data-*.*" -exec tar -xzvf {} ";" #procura os arquivos de backup baseado na data informada e extrai
       tam_dir=`du --max-depth=0 $DSTBKP|cut -f 1`   #extrai tamanho do diretório onde o backup foi colocado
       if [ $tam_dir -lt 10 ] ; then
          controle=1   # se o tam do diretório for igual 4 k falha senão sucesso
          echo "Restore de backup Full em DVD falhou" >> /var/log/restore.log
          echo "Realizado pelo usuário: $USER" >> /var/log/restore.log
          echo "$DATA" >> /var/log/restore.log
          echo "-----------------------------------------" >> /var/log/restore.log
          principal      
       else
          echo "Restore de backup Full em DVD realizado com sucesso!" >> /var/log/restore.log
          echo "Realizado pelo usuário: $USER" >> /var/log/restore.log
          echo "$DATA" >> /var/log/restore.log
          echo "-----------------------------------------" >> /var/log/restore.log
          controle=2
          principal
       fi

      elif [ $midia == hd ] ; then 
       #$XFSCHECK /dev/sda1
         mount $HD_O $HD_MTD
       ls -lat $HD_MTD
       echo "Qual a data do arquivo que quer restaurar? (dd-mm-aaaa)"
       read "data"
       rm -rf $DSTBKP/*
       cd $DSTBKP
       find $HD_MTD -name "full-$data-*.*" -exec tar -xzvf {} ";"
       tam_dir=`du --max-depth=0 $DSTBKP|cut -f 1`
       if [ $tam_dir -lt 10 ] ; then
          echo "Restore de backup Full em HD falhou" >> /var/log/restore.log
          echo "Realizado pelo usuário: $USER" >> /var/log/restore.log
          echo "$DATA" >> /var/log/restore.log
          echo "-----------------------------------------" >> /var/log/restore.log
          controle=1
          principal      
       else
          echo "Restore de backup Full em HD realizado com sucesso!" >> /var/log/restore.log
          echo "Realizado pelo usuário: $USER" >> /var/log/restore.log
          echo "$DATA" >> /var/log/restore.log
          echo "-----------------------------------------" >> /var/log/restore.log
          controle=2
          principal
       fi
    else
            echo "Tipo de mídia não encontrado, tente novamente"
       restorefull

    fi
}

restoredif(){
    echo " "
    echo "Mídia (dvd ou hd)"
    read midia
    if [ $midia == dvd ] ; then
       #$XFSCHECK /dev/cdrom
       mount /dev/cdrom $DVD_MTD
       ls -la $DVD_MTD
       echo "Qual a data do arquivo que quer restaurar? (dd-mm-aaaa)"
       read "data"
       rm -rf $DSTBKP/*
       cd $DSTBKP
       find $DVD_MTD -name "dif-$data-*.*" -exec tar -xzvf {} ";"
       tam_dir=`du --max-depth=0 $DSTBKP|cut -f 1`
       if [ $tam_dir -lt 10 ] ; then
          echo "Restore de backup diferencial em DVD Falhou" >> /var/log/restore.log
          echo "Realizado pelo usuário: $USER" >> /var/log/restore.log
          echo "$DATA" >> /var/log/restore.log
          echo "-----------------------------------------" >> /var/log/restore.log
          controle=1
          principal      
       else
          echo "Restore de backup diferencial em DVD realizado com sucesso!" >> /var/log/restore.log
          echo "Realizado pelo usuário: $USER" >> /var/log/restore.log
          echo "$DATA" >> /var/log/restore.log
          echo "-----------------------------------------" >> /var/log/restore.log
          controle=2
          principal
       fi
    elif [ $midia == hd ] ; then 
       #$XFSCHECK /dev/sda1
         mount $HD_O $HD_MTD
       ls -la $HD_MTD
       echo "Qual a data do arquivo que quer restaurar? (dd-mm-aaaa)"
       read "data"
       rm -rf $DSTBKP/*
       cd $DSTBKP
       find $HD_MTD -name "dif-$data-*.*" -exec tar -xzvf {} ";"
       tam_dir=`du --max-depth=0 $DSTBKP|cut -f 1`
       if [ $tam_dir -lt 10 ] ; then
          echo "Restore de backup diferencial em HD falhou" >> /var/log/restore.log
          echo "Realizado pelo usuário: $USER" >> /var/log/restore.log
          echo "$DATA" >> /var/log/restore.log
          echo "-----------------------------------------" >> /var/log/restore.log
          controle=1
          principal      
       else
          echo "Restore de backup diferencial em HD realizado com sucesso!" >> /var/log/restore.log
          echo "Realizado pelo usuário: $USER" >> /var/log/restore.log
          echo "$DATA" >> /var/log/restore.log
          echo "-----------------------------------------" >> /var/log/restore.log
          controle=2
          principal
       fi

    else
            echo "Tipo de mídia não encontrado, tente novamente"
       restoredif

    fi
}

registros(){
    echo "Que registros quer visualizar?"
    echo "1 - Restauração"
    echo "2 - Backups full realizados"
    echo "3 - Backups diferenciais realizados"
    echo "4 - Compactações realizadas"
    echo "5 - Voltar ao menu principal"
    echo "6 - Sair do programa de restore"
    echo "-----------------------------------------------------"
    echo "Atenção: usar setas direcionais ou PgUp PgDown para navegar no registro ao finalizar apertar a tecla Q"
    echo "-----------------------------------------------------"
    read opcao

    case $opcao in
       1) cat /var/log/restore.log|less;registros;;
       2) cat /var/log/backup_full.log|less;registros;;
       3) cat /var/log/backup_diferencial.log|less;registros;;
       4) cat /var/log/backup_compactacao.log|less;registros;;
       5) principal;;
       6) echo "Saindo ...";;
       *) echo "Opção desconhecida"; registros;;
    esac
}

principal
exit 0