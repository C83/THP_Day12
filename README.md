# Projet THP jour 12

## Introduction
Ce projet a été fait dans le cadre de THP. Il permet d'utiliser nos compétences acquises au cours des derniers jours : écriture d'objet dans des fichiers (ici en JSON), utilisation de gem pour écrire un mail avec GMail, pour utliser Twitter, pour débugguer...

Une fois le projet clôné, faire un ```bundle install```

## Equipe
Pacôme P. a travaillé sur le scrapper et la partie twitter.

Cyril M. a participé au scrapper et mis en place la partie mailer

## Organisation des fichiers 
Il y a trois grandes fonctions utilisées dans ce projet : 
1. scrapper les informations de trois départements et enregistrer les données en JSON (dossier scrapper)
2. lire les données en JSON et envoyer un mail aux adresses mails du fichier (dossier mailer)
3. lire les données en JSON, rechercher les comptes Twitter des mairies, le renseigner dans le fichier JSON et leur envoyer un tweet (dossier twitter)

Un quatrième dossier nommé database permet de ranger les fichiers de données, qui seront ensuite lus par les différents programmes. 

## Utilisation du programme
### Scrapper
Il est possible de modifier le nom du fichier qui sera enregistré dans le dossier database. Pour cela, modifier la constante SELECT_FILE. 
**Exception :** Si une page est down, l'exception est normalement prise en compte. 
**Résultat :** A titre d'exemple, les résultats ont été mis dans le fichier database/data_result.json.

1. **Rester à la racine du projet** (important pour le bon enregistrement du fichier !)
2. Lancer le programme en ruby : ```ruby scrapper/townhalls_scrapper.rb```
3. Patienter
4. Patienter si nécessaire, l'opération peut prendre plusieurs minutes
5. Le fichier a été enregistré dans le dossier database 

### Mailer
Il est possible de modifier le fichier qui sera lu dans le dossier database. Pour cela, modifier la constante SELECT_FILE. 
**Gestion des identifiants :** un fichier .env est invoqué dans le programme. Le placer à la racine du projet. Celui-ci doit contenir une constante GMAIL_EMAIL et une autre GMAIL_MDP, correspondant respectivement à l'adresse mail et au mot de passe de votre compte GMail. Pour plus de détail sur dotenv, voir [ici](https://github.com/felhix/cheat_sheets/blob/master/Ruby/dotenv.md).
**Prénom de l'élève :** Vous pouvez adapter le nom de l'élève en fonction de l'adresse mail d'envoie utilisée en modifiant la constante NAME_OF_SENDER
**Test :** Par défaut, le fichier JSON lu sera un jeu de donnée de test. Les mails seront envoyés sur l'adresse yopmail huzobiqy-4491@yopmail.com. Pour utiliser le fichier du scrapper, coordonner la constante SELECT_FILE de ces deux fichiers.  

1. **Rester à la racine du projet** (important pour le bon enregistrement du fichier !)
2. Lancer le programme en ruby : ```ruby mailer/townhalls_mailer.rb```
3. Patienter
4. Patienter encore et toujours 
5. Les mails ont été envoyés

### Twitter
Il est possible de modifier le fichier qui sera lu dans le dossier database. Pour cela, modifier la constante SELECT_FILE. 
TODO

## Gems utilisées
Les Gems utilisées sont les suivantes  :
* gem 'pry' : utilisée pour le débugage 
* gem 'twitter' : utilisée pour accéder à Twitter
* gem 'nokogiri' : utilisée pour parser le site
* gem 'gmail' : utlisée pour accéder à Gmail
* gem 'dotenv' : utilisée pour la gestion des identifiants
* gem 'json' : utilisée pour l'enregistrement des datas


## Réalisation
Les datas sur les mairies des trois départements ont été scrappées. La fonction d'envoie de mail a été testée avec des données similaires à la prod. 
