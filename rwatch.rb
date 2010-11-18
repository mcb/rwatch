require 'rubygems'
require 'mechanize'
require 'hirb'

username = "username"
password = "password"

 a = Mechanize.new { |agent|
   agent.user_agent_alias = 'Mac Safari'
   agent.follow_meta_refresh = true
 }

 a.get('https://signin.ebay.de/ws/eBayISAPI.dll?SignIn&UsingSSL=1') do |page|
   login = page.form_with(:name => 'SignInForm') do |search|
     search.userid = username
     search.pass = password
   end.submit
   
   overview = login.link_with(:href => "http://my.ebay.de/ws/eBayISAPI.dll?MyeBay").click
   
   array = []
   
   overview.search(".my_itl-itR").each do |product|
     row = []
     product.search(".g-asm").each do |detail|
      row << detail.text
     end
     array << row
   end
   puts Hirb::Helpers::AutoTable.render(array)
 end