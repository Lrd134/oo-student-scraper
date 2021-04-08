require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    
    
    doc = Nokogiri::HTML(open(index_url))
    
    student_urls = doc.xpath('//div/a/@href').text.strip
    student_urls = student_urls.split(".html")

    names = []
    student_names = doc.css(".student-name")
    student_names.each { | stu_card | names << stu_card.children.text }
    
    locations = []
    student_locations = doc.css(".student-location")
    student_locations.each { | stu_css_ele | locations << stu_css_ele.children.text}

    students = []
    names.each_with_index do | name, index |
       students << { :name => name,
                      :location => locations[index],
                      :profile_url => "#{student_urls[index]}.html" }
    end

    students
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url)) # Opening the doc
    student_urls = doc.xpath('//div/a/@href').text.strip
    student_urls = student_urls.split("http")
    urls = []
    student_urls.each { | url| urls << url }
    quotes = []
    student_quotes = doc.css("div .profile-quote")
    student_quotes.each { | stu_card | quotes << stu_card.children.text } # quotes << stu_card.children.text }
    biographies = []
    student_bio = doc.css("div.description-holder")
    student_bio.each { | stu_card | biographies << stu_card.children.text }
    student_info = { }
    urls.each do | url | 
      if url.include? "twitter"
        student_info[:twitter] = "http#{url}"
      elsif url.include? "linked"
        student_info[:linkedin] = "http#{url}"
      elsif url.include? "github"
        student_info[:github] = "http#{url}"
      elsif url.include? ".com"
        student_info[:blog] = "http#{url}"
      end
    end
    
   
    # biographies.each_with_index do | info, index |
    #  binding.pry
    student_info[:bio] = biographies[0].strip
                      
    student_info[:profile_quote] = quotes[0]
  
    student_info
    # binding.pry
  end
  
end

