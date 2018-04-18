require 'rubygems'
require 'pry'
require 'dotenv'
require 'twitter'
require 'json'

SELECT_FILE = "townhalls_exemple.json" 						# permet de changer de fichier de facon easy

Dotenv.load

CLIENT = Twitter::REST::Client.new do |config|
	config.consumer_key        = ENV["TWITTER_API_KEY"]
  	config.consumer_secret     = ENV["TWITTER_API_SECRET"]
  	config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
  	config.access_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"]
end


 def json_to_ruby 											# on convertit le json en ruby
    json = File.read('../database/'+SELECT_FILE) 			# on lit le fichier json
    obj = JSON.parse(json) 									# pour le transformer en object avec lequel on va se servir comme d'un tableau
    return obj
 end


def name_townhall 											# on définit une fonction qui récupére le nom des villes
	name = []
	json_to_ruby.each do |i| 
		name.push(i['name'])
 	end
 	name
end


def name_user 												# on définit une fonction pour récuperer les utilisateurs
        twittos = [] 										# on met les twittos (les gentils user de twitter) dans un tableau
        townhall = name_townhall 							# on dis que les villes = fonction d'au dessus donc : nom des villes
		townhall.each do |i|
			CLIENT.search(i).take(1).collect do |tweet| 	# on recherche 1 tweet dans lequel apparait le nom d'une ville
				twittos.push("#{tweet.user.screen_name}") 
			end
		 end
	return twittos 											# on récupére des ID
end
name_user


def handle_twitter 											# on définit une fonction handle_twitter pour mettre dans un tableau 
    j = 0													# les noms des utilisateurs de twitter au lieu des ID
    handle =[]
    name_user.each do |i|
    	handle.push["@#{i}"]
    	j +=1
    end
end

def handle 													# on définit une fonction handle qui permet d'ajouter le @ avant la fonction handle_twitter  
															# pour obtenir le vrai pseudo twitter des utilisateurs qu'on veux afficher 
	result = json_to_ruby
	i=0
	result.each do |handle|
		name_at = '@'&&name_user[i]
        result[i]['handle_twitter'] = name_at
	    i += 1
	end
	return result
end

 File.open("../database/"+SELECT_FILE,"w") do |f| 			# on écrit un nouveau fichier json ou on remplace celui déjà créé dans lequel  
     f.write(handle.to_json)								# on a toute nos infos de bases sur les communes + maintenant le noms des twittos :D
 end