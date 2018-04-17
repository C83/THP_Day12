require 'pry'
require 'gmail'
require 'dotenv'
require 'json'

# Majuscule car constantes
# SELECT_FILE = "townhalls_exemple.json"
SELECT_FILE = "data.json"
NAME_OF_SENDER = "Julia"

# Fonction get_the_email_text
# Permet de disposer du message au format texte
# @params : 
# 	name : nom de la commune
# @return : 
# 	body : message au format texte 
def get_the_email_text(name)
	name.capitalize!
	body = "Bonjour,
Je m'appelle #{NAME_OF_SENDER}, je suis élève à The Hacking Project, une formation au code gratuite, sans locaux, sans sélection, sans restriction géographique. La pédagogie de notre école est celle du peer-learning, où nous travaillons par petits groupes sur des projets concrets qui font apprendre le code. Le projet du jour est d'envoyer (avec du codage) des emails aux mairies pour qu'ils nous aident à faire de The Hacking Project un nouveau format d'éducation pour tous.

Déjà 300 personnes sont passées par The Hacking Project. Est-ce que la mairie de #{name} veut changer le monde avec nous ?

Charles, co-fondateur de The Hacking Project pourra répondre à toutes vos questions : 06.95.46.60.80

Merci pour votre attention !
Julia"
end

# Fonction get_the_email_html
# Permet de disposer du message au format html
# @params : 
# 	name : nom de la commune
# @return : 
# 	body : message au format html
def get_the_email_html(name)
	name.capitalize!	# Permet de s'assurer que le nom de la commune commence par une majuscule
	# On intègre le nom de la commune
	body = "Bonjour,<br><br>
Je m'appelle <em>#{NAME_OF_SENDER}</em>, je suis <em>élève à The Hacking Project</em>, une formation au code gratuite, sans locaux, sans sélection, sans restriction géographique. La pédagogie de notre école est celle du peer-learning, où nous travaillons par petits groupes sur des projets concrets qui font apprendre le code. Le projet du jour est d'envoyer (avec du codage) des emails aux mairies pour qu'ils nous aident à faire de The Hacking Project un nouveau format d'éducation pour tous.<br>
<br>
Déjà 300 personnes sont passées par The Hacking Project. Est-ce que la mairie de #{name} veut changer le monde avec nous ?<br>
<br>
Charles, co-fondateur de The Hacking Project pourra répondre à toutes vos questions : 06.95.46.60.80<br>
<br>
Merci pour votre attention !<br>
Julia"

end

# Fonction send_mails
# Se connecte au compte Gmail et envoie des mails à partir d'un tableau de hash 
# @params : 
# 	array_of_hash : tableau de hash comprenant une clé nom, une clé département, une clé adresse email
# @return : none
# Remarque : on utilise dotenv pour les variables. Voir README.md
def send_mails(array_of_hash)
	# On récupère les IDs : 
	Dotenv.load
	# On se connecte à partir des identifiants
	gmail = Gmail.connect(ENV['GMAIL_EMAIL'], ENV['GMAIL_MDP'])
	# Indication 
	puts "Je suis loggué ? : " + gmail.logged_in?.to_s
	array_of_hash.each do |line_hash|	
	# On passe sur chaque élément du tableau de hash. On manipule alors un hash
		gmail.deliver do 	# Selon la doc de la gem
		  to line_hash['email']
		  subject "The Hacking Project"
		  text_part do
		    body get_the_email_text(line_hash['name'])
		  end
		  html_part do
		    content_type 'text/html; charset=UTF-8'
		    body get_the_email_html(line_hash['name'])
		  end
		end 
	end
	gmail.logout	
end

def load_data
	json = File.read('../database/'+SELECT_FILE)
	array_of_hash = JSON.parse(json)
end

def process
	send_mails(load_data)
end

process
binding.pry