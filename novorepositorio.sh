#!/bin/bash

echo "Digite o nome da pasta"
read folder

if [ -d "$folder" ]; then
	echo "Erro. Esse repositório já existe."
else
	mkdir "$folder" && \ 
	chmod 777 -R "$folder" && \
	cd "$folder" && \
	mkdir "git" && \
	cd "git" && \

	git init --bare && \

	echo -e "#!/bin/sh\nGIT_WORK_TREE=/home/storage/3/c1/55/salveqa/public_html/$folder git checkout -f" >> hooks/post-receive && \
	chmod +x hooks/post-receive
	echo "Repositório criado com sucesso!"
fi

echo "Caminho SSH: salveqa@186.202.112.17:/home/salveqa/public_html/$folder/git"