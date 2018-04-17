require 'pry'
require 'rubygems'
require 'nokogiri'  
require 'open-uri'

# Fonction get_the_email_of_a_townhall_from_its_webpage
# @params : 
# 	townhall_url : la page de la mairie
# return : 
#   name_of_town : le nom de la ville
#   mail_adress : l'adresse mail de la mairie
def get_the_email_of_a_townhal_from_its_webpage (townhall_url)
	page = Nokogiri::HTML(open(townhall_url))   
	# Chaque page de mairie contient un lien vers la page elle-même, avec comme ancre le nom de la ville. On prend donc le texte correspondant 
	name_of_town_with_zip_code = page.xpath('/html/body/div[1]/main/section[1]/div/div/div/h1').text.split (" - ") # On sépare le nom de la ville et le code postale
	name_of_town = name_of_town_with_zip_code[0] # on récupére le nom de la ville seulement
	# Champ département ciblé avec l'inspecteur d'élément
	department = page.xpath('/html/body/div[1]/main/section[4]/div/table/tbody/tr[1]/td[2]').text
	# Champ mail_adress ciblé avec l'inspecteur d'élément
	mail_adress = page.xpath('/html/body/div[1]/main/section[2]/div/table/tbody/tr[4]/td[2]').text
	return name_of_town, department, mail_adress
end

# Fonction get_all_the_urls_of_calvados_townhalls
# @params : none
# return : 
#   array_of_URL : un tableau avec les URLs des pages de mairie
def get_all_the_urls_of_calvados_townhalls
	# Etant donné qu'il est utilisé à deux reprises, on stocke l'URL de base
	base_url = "http://annuaire-des-mairies.com"
	# URL de la page répertoriant les communes
	page = Nokogiri::HTML(open(base_url+"/calvados.html"))
	# On récupère l'adresse de la page. Les liens étant en .commune, on utilise d'abord la base de l'URL, 
	# on enlève le point du lien([1..-1]), puis on rajoute la partie correspondante à la commune. 
	array_of_URL = page.xpath('//a[@class = "lientxt"]').map { |node| base_url + node.attributes["href"].value[1..-1] }
	return array_of_URL		# Tableau des URLs
end

# Fonction get_name_email_of_calvados
# @params : none
# return : 
#   array_of_URL : un tableau avec les URLs des pages de mairie
def get_name_email_of_calvados
	result = []
	# On récupère la liste des URLs des pages de chaque ville
	list_url = get_all_the_urls_of_calvados_townhalls
	# Pour chaque commune, on utilise la fonction pour récupérer le nom et le mail de la commune, puis on range les informations dans un tableau de hash
	list_url.each {|town_URL| name, depart, mail = get_the_email_of_a_townhal_from_its_webpage(town_URL); result.push({:name => name.to_s, :department => depart.to_s, :email => mail})}
	return result
end

def perform
	puts get_name_email_of_calvados
end

perform
