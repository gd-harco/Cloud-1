############ NGINX DOCKERFILE ############

FROM debian:oldstable

LABEL createdBy="gd-harco" mail="gd-harco@student.42lyon.fr"

#mettre a jour apt
#Installer nginx et openssl
RUN	apt-get update \
	&& apt-get upgrade \
	&& apt-get install nginx openssl --no-install-recommends -y \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl
#Generation de la cle SSH et du certificat
# source : https://www.openssl.org/docs/manmaster/man1/openssl-req.html
# 	- demande de CSR (Certificat Signing Request)
# 	- outputs a certificate instead of a certificate request
# 	- ne pas chiffrer la cle (pas de prompt, deprecie dans OpenSSL 3.0, remplacer par -noenc si besoin)
# 	- Generer une nouvelel cle prive. [rsa:]nbits generates an RSA key nbits in size (defaut 2048).
# 	- emplacement de la cle Generee
# 	- sortie du certificat
# 	- donne les infos requise pour eviter un prompt
RUN openssl req \
	-x509 \
	-nodes \
	-newkey rsa \
	-keyout /etc/nginx/ssl/gd-harco.42.fr.key \
	-out /etc/nginx/ssl/gd-harco.42.fr.crt \
	-subj "/C=FR/ST=Auvergne-Rhone-Alpes/L=Lyon/UID=gd-harco/emailAddress=gd-harco@student.42lyon.fr"

#copier le fichier de configuration de notre serveur
COPY conf/default.conf /etc/nginx/sites-available/cloud-1.ft-server.fr.conf

#creer un lien symbolique de sites-available vers site-enable
#pour activer le site.
#Supprimer le default.conf pour faire bonne figure
RUN ln -s /etc/nginx/sites-available/cloud-1.ft-server.fr.conf /etc/nginx/sites-enabled/cloud-1.ft-server.fr
#RUN rm /etc/nginx/sites-enabled/default.conf

#lancement de nginx en arriere plan pour pas que le conteneur se ferme apres la commande
CMD ["nginx", "-g", "daemon off;"]
