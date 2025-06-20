#!/bin/bash

current_dir=$(dirname $0)
cd $current_dir

read -p "APakah akan menghapus dan menginstall ulang database stackoverflow ? (ketik ya jika ingin melakukan) " keputusan

if [ "$keputusan" = "ya" ]
then

	sudo -u postgres psql -c "DROP DATABASE stackoverflow;"
	sudo -u postgres psql -c "DROP USER stackoverflow_user;"
	sudo -u postgres psql -c "CREATE USER stackoverflow_user WITH PASSWORD 'stackoverflow_pass';";
	sudo -u postgres psql -c "CREATE DATABASE stackoverflow OWNER stackoverflow_user;"

	dir=$(mktemp -d)
	chmod -R 777 $dir
	cd $dir

	for i in {00..14}
	do
		filepart="https://github.com/radityopw/stackoverflow-postgresql/raw/refs/heads/main/stackoverflow-pg-2010-v0.1.tar.gz.part$i"
		echo download $filepart
		wget $filepart
	done

	cat *.part* > db.tar.gz
	rm *.part*
	tar xfv db.tar.gz
	rm *.tar.gz
	cd stackoverflow-postgres-2010-v0.1
	sudo -u postgres pg_restore -d stackoverflow dump-stackoverflow2010-202408101013.dump
	cd $current_dir
	rm -rf $dir
 
fi
