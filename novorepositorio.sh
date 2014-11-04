#!/bin/bash

echo "Digite o nome da pasta"
read folder

if [ -d "$folder" ]; then
	echo "Erro. Esse repositário já existe."
else
	mkdir "$folder" && \ 
	chmod 777 -R "$folder" && \
	cd "$folder" && \
	mkdir "git" && \
	cd "git" && \

	git init --bare && \

	echo -e "#!/bin/sh\nGIT_WORK_TREE=/home/apssouza/public_html/$folder git checkout -f" >> hooks/post-receive && \
	chmod +x hooks/post-receive
	echo "Repositório criado com sucesso!"
fi

echo "Caminho SSH: apssouza@apssouza.com.br:/home/apssouza/public_html/jobs/$folder/git"