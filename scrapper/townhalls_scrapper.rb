require 'pry'
require 'rubygems'
require 'nokogiri'  
require 'open-uri'
require 'json'

# Majuscule car constante
SELECT_FILE = "data.json"

# Fonction get_the_email_of_a_townhall_from_its_webpage
# @params : 
# 	townhall_url : la page de la mairie
# return : 
#   name_of_town : le nom de la ville
#   mail_adress : l'adresse mail de la mairie
def get_the_email_of_a_townhal_from_its_webpage (townhall_url)
	begin
		page = Nokogiri::HTML(open(townhall_url))   
		# Chaque page de mairie contient un lien vers la page elle-même, avec comme ancre le nom de la ville. On prend donc le texte correspondant 
		name_of_town_with_zip_code = page.xpath('/html/body/div[1]/main/section[1]/div/div/div/h1').text.split (" - ") # On sépare le nom de la ville et le code postale
		name_of_town = name_of_town_with_zip_code[0] # on récupére le nom de la ville seulement
		# Champ département ciblé avec l'inspecteur d'élément
		department = page.xpath('/html/body/div[1]/main/section[4]/div/table/tbody/tr[1]/td[2]').text
		# Champ mail_adress ciblé avec l'inspecteur d'élément
		mail_adress = page.xpath('/html/body/div[1]/main/section[2]/div/table/tbody/tr[4]/td[2]').text
		return name_of_town, mail_adress
	rescue Exception => e 	# Certaine fois, les pages mairies n'existent pas (c'est le cas dans le calvados). Gérer l'exception permet de ne pas faire crasher le programme
		  puts "Page non exploitable : #{townhall_url}"
		  return nil,nil
	end
end

# Fonction get_all_the_urls_of_calvados_townhalls
# @params : none
# return : 
#   array_of_URL : un tableau avec les URLs des pages de mairie
def get_all_the_urls_of_townhalls(name_departement)
	# Etant donné qu'il est utilisé à deux reprises, on stocke l'URL de base
	array_of_URL = []
	base_url = "http://annuaire-des-mairies.com"
	# URL de la page répertoriant les communes
	page = Nokogiri::HTML(open(base_url+"/#{name_departement}.html"))
	list_img = page.xpath('//a/img')
	list_url_pages = list_img.map { |element| base_url+"/"+element.parent["href"]}
	
	list_url_pages.each{ |url|
		page = Nokogiri::HTML(open(url)) unless page == (base_url+"/#{name_departement}.html")
		# On récupère l'adresse de la page. Les liens étant en base commune, on utilise d'abord la base de l'URL, 
		# on enlève le point du lien([1..-1]), puis on rajoute la partie correspondante à la commune. 
		array_of_URL.concat(page.xpath('//a[@class = "lientxt"]').map { |node| base_url + node.attributes["href"].value[1..-1] })
	}
	return array_of_URL		# Tableau des URLs
end

# Fonction get_name_email_of_calvados
# @params : none
# return : 
#   array_of_hash_of_URL : un tableau avec hash comprenant les noms des villes, des URLs des pages de mairie
def get_name_email_of_departement(name_departement)
	result = []
	# On met directement le nom du département en minuscule pour éviter les soucis dans l'URL
	name_departement.downcase!
	# On récupère la liste des URLs des pages de chaque ville
	list_url = get_all_the_urls_of_townhalls(name_departement)
	# Pour chaque commune, on utilise la fonction pour récupérer le nom et le mail de la commune, puis on range les informations dans un tableau de hash
	list_url.each {|town_URL| 
		name, mail = get_the_email_of_a_townhal_from_its_webpage(town_URL)
		# On vérifie que l'exception n'a pas été levé, ce qui aurait pour conséquence de retourner nil nil à la méthode précédente
		unless (name == nil)
			result.push({:name => name.to_s, :department => name_departement.to_s, :email => mail})
		end
	}
	return result
end

# Fonction to_json
# Permet de tranformer l'array en fichier json ("emailsmairies.json")
# @params : array
# return : none
def to_json(array_object)
	# Crée le fichier ou écris au dessus
	File.open("../database/"+SELECT_FILE,"w") do |f|
		# La fontion .to_json permet de transformer l'objet en JSON. require 'json'
		f.write(array_object.to_json)
	end
end

def perform
	
	result = []
	puts "Commencement du scrapping pour le département du Calvados"
	result.concat(get_name_email_of_departement("calvados"))
	puts "Commencement du scrapping pour le département de la Manche"
	result.concat(get_name_email_of_departement("manche"))
	puts "Commencement du scrapping pour le département du Finistère"
	result.concat(get_name_email_of_departement("finistere"))
	to_json(result)	
end
perform