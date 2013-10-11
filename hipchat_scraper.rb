require 'net/http'
require 'json'

t = Time.now
# t.strftime("Printed on %m/%d/%Y")   #=> "Printed on 04/09/2003"
# t.strftime("at %I:%M%p")            #=> "at 08:56AM"

PERSONAL_HIPCHAT_TOKEN = ""
ROOM_ID = ""

all_urls = Hash.new

(1..11).each do |index|
  uri = URI("https://api.hipchat.com/v2/room/#{ROOM_ID}/history?auth_token=#{PERSONAL_HIPCHAT_TOKEN}&max-results=100&date=2013-10-#{index}T00:00:08+00:00")
  Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
    request = Net::HTTP::Get.new uri
    response = http.request request # Net::HTTPResponse object
    JSON.parse(response.body)["items"].each do |item|       
      urls = item["message"].split(/\s+/).find_all { |u| u =~ /^https?:/ }
      
      urls.compact.each do |url|
        all_urls[url] = {
          date: item["date"],
          name: item["from"]["name"],
          url: url
        }
      end
    end
  end
end

puts all_urls.map{|key, value| value}.to_json
