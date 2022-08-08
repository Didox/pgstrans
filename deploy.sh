echo "========[Mensagem commit]========="
read commit
git add .
git commit -am "$commit"
git pull
git push


ansible-playbook -i ansible/hosts ansible/provisiona.yml -u pgsadmin --private-key ansible/id_rsa

# ssh -i ansible/id_rsa pgsadmin@172.26.10.6