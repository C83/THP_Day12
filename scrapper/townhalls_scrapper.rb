require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'pry'

def townhall (link_townhall)
  page = Nokogiri::HTML(open(link_townhall))
  townhall_name_and_zip = page.css("div[1]/main/section[1]/div/div/div/h1").text.split(" - ")
  townhall_name = townhall_name_and_zip[0]
  townhall_zip = townhall_name_and_zip[1]
  department = page.xpath('/html/body/div[1]/main/section[4]/div/table/tbody/tr[1]/td[2]').text
  townhall_mail = page.css("div[1]/main/section[2]/div/table/tbody/tr[4]/td[2]").text
  hash_townhall = Hash[:name => townhall_name, :department => department, :email => townhall_mail]
  return hash_townhall
end

def scan_list_townhall (link_url)
  url_origin = "http://annuaire-des-mairies.com/"
  list_townhall = []
  page_origin = Nokogiri::HTML(open(link_url))
  link_town = page_origin.css('a.lientxt')
  link_town.each {|x|
    link = x['href']
    link_to_town = URI.join(url_origin, link).to_s
    list_townhall.push(townhall(link_to_town))
  }
  return list_townhall
end

def perform
  url_origin = "http://annuaire-des-mairies.com/calvados.html"
  puts scan_list_townhall(url_origin)
end

perform