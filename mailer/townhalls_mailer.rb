require 'pry'
require 'gmail'
require 'dotenv'
require 'json'

SELECT_FILE = "townhalls_exemple.json"

def get_the_email_text(name)
	name.capitalize!
	body = "Bonjour,
Je m'appelle Julia, je suis élève à The Hacking Project, une formation au code gratuite, sans locaux, sans sélection, sans restriction géographique. La pédagogie de notre école est celle du peer-learning, où nous travaillons par petits groupes sur des projets concrets qui font apprendre le code. Le projet du jour est d'envoyer (avec du codage) des emails aux mairies pour qu'ils nous aident à faire de The Hacking Project un nouveau format d'éducation pour tous.

Déjà 300 personnes sont passées par The Hacking Project. Est-ce que la mairie de #{name} veut changer le monde avec nous ?

Charles, co-fondateur de The Hacking Project pourra répondre à toutes vos questions : 06.95.46.60.80

Merci pour votre attention !
Julia"
end

def get_the_email_html(name)
	name.capitalize!
	body = "Bonjour,<br><br>
Je m'appelle <em>Julia</em>, je suis <em>élève à The Hacking Project</em>, une formation au code gratuite, sans locaux, sans sélection, sans restriction géographique. La pédagogie de notre école est celle du peer-learning, où nous travaillons par petits groupes sur des projets concrets qui font apprendre le code. Le projet du jour est d'envoyer (avec du codage) des emails aux mairies pour qu'ils nous aident à faire de The Hacking Project un nouveau format d'éducation pour tous.<br>
<br>
Déjà 300 personnes sont passées par The Hacking Project. Est-ce que la mairie de #{name} veut changer le monde avec nous ?<br>
<br>
Charles, co-fondateur de The Hacking Project pourra répondre à toutes vos questions : 06.95.46.60.80<br>
<br>
Merci pour votre attention !<br>
Julia"

end

def send_mails(array_of_hash)
	gmail = Gmail.connect(ENV['GMAIL_EMAIL'], ENV['GMAIL_MDP'])
	puts gmail.logged_in?
	array_of_hash.each do |line_hash|
		gmail.deliver do
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

def process
	Dotenv.load

	json = File.read('../database/'+SELECT_FILE)
	array_of_hash = JSON.parse(json)

	send_mails(array_of_hash)

end

process
binding.pry