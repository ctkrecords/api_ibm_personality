module RequestTweets
    def self.get_tweets(username)
        cad = "Request done!"
        response = HTTParty.get("http://personality-api-test.herokuapp.com/api/v1/users/#{username}")
        puts response.code
        tweets = response.body
        if response.code != 200 || response.body.to_s == "null"
            nil
        else
            file = File.open("lib/assets/tweets_prueba.txt", "w")
            file.puts tweets.encode!("UTF-8", invalid: :replace, undef: :replace).force_encoding("utf-8")
            file.close
            cad = lastfm_request
            cad
        end
    end

    def self.personality_request
        include IBMWatson
        authenticator = Authenticators::IamAuthenticator.new(
            apikey: ENV["IBM_CLOUD_APIKEY"]
          )
          personality_insights = PersonalityInsightsV3.new(
            version: "2017-10-13",
            authenticator: authenticator
          )
          personality_insights.service_url = "https://gateway.watsonplatform.net/personality-insights/api"

          begin
            File.open("lib/assets/tweets_prueba.txt") do |profile_json|
              profile = personality_insights.profile(
                accept: "application/json",
                content: profile_json.read,
                content_type: "text/plain; charset=utf-8",
                content_language: "es",
                accept_language: "es"
              )
              profile_response = JSON.pretty_generate(profile.result)
              #file = File.open("personality.json", "w")
              #file.puts JSON.pretty_generate(profile.result)
              #file.close
              profile_response
            end
          rescue IBMWatson::ApiException => ex
            nil
          end
    end

    def self.lastfm_request
      if personality_request.nil?
        nil
      else
        data_hash = JSON.parse(personality_request)
        api_key=ENV["LAST_FM_API_KEY"]

        new_hash = {}
        5.times do |num|
          new_hash[data_hash['personality'][num]['percentile']] = data_hash['personality'][num]['name']
        end

        per = new_hash.sort

        personalidades = ["Apertura a experiencias", "Responsabilidad", "Extroversión", "Amabilidad", "Rango emocional"]
        genres = ["classical", "blues", "jazz", "folk", "rap", "hip-hop", "soul", "electronic", "dance", "country", "pop", "upbeat"]

        case per.last.last
        when personalidades[0]
            apertura_hash = {}
            classical = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=tag.gettopalbums&tag=classical&limit=6&api_key=#{api_key}&format=json")
            blues = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=tag.gettopalbums&tag=blues&limit=6&api_key=#{api_key}&format=json")
            jazz = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=tag.gettopalbums&tag=jazz&limit=6&api_key=#{api_key}&format=json")
            folk = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=tag.gettopalbums&tag=folk&limit=6&api_key=#{api_key}&format=json")
            6.times do |num|
                apertura_hash[classical['albums']['album'][num]['name']]=classical['albums']['album'][num]['url']
                apertura_hash[blues['albums']['album'][num]['name']]=blues['albums']['album'][num]['url']
                apertura_hash[jazz['albums']['album'][num]['name']]=jazz['albums']['album'][num]['url']
                apertura_hash[folk['albums']['album'][num]['name']]=folk['albums']['album'][num]['url']
            end
            puts apertura_hash
            JSON.parse(apertura_hash.to_json)
        when personalidades[1]
            responsabilidad = genres.sample(6)
            responsabilidad_hash = {}
            genre1 = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=tag.gettopalbums&tag=#{responsabilidad[0]}&limit=6&api_key=#{api_key}&format=json")
            genre2 = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=tag.gettopalbums&tag=#{responsabilidad[1]}&limit=6&api_key=#{api_key}&format=json")
            genre3 = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=tag.gettopalbums&tag=#{responsabilidad[2]}&limit=6&api_key=#{api_key}&format=json")
            genre4 = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=tag.gettopalbums&tag=#{responsabilidad[3]}&limit=6&api_key=#{api_key}&format=json")
            genre5 = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=tag.gettopalbums&tag=#{responsabilidad[4]}&limit=6&api_key=#{api_key}&format=json")
            genre6 = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=tag.gettopalbums&tag=#{responsabilidad[5]}&limit=6&api_key=#{api_key}&format=json")
            6.times do |num|
                responsabilidad_hash[genre1['albums']['album'][num]['name']]=genre1['albums']['album'][num]['url']
                responsabilidad_hash[genre2['albums']['album'][num]['name']]=genre2['albums']['album'][num]['url']
                responsabilidad_hash[genre3['albums']['album'][num]['name']]=genre3['albums']['album'][num]['url']
                responsabilidad_hash[genre4['albums']['album'][num]['name']]=genre4['albums']['album'][num]['url']
                responsabilidad_hash[genre5['albums']['album'][num]['name']]=genre5['albums']['album'][num]['url']
                responsabilidad_hash[genre6['albums']['album'][num]['name']]=genre6['albums']['album'][num]['url']
            end
            puts responsabilidad_hash
            JSON.parse(responsabilidad_hash.to_json)
        when personalidades[2]
            extroversion_hash = {}
            rap = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=tag.gettopalbums&tag=rap&limit=6&api_key=#{api_key}&format=json")
            hip_hop = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=tag.gettopalbums&tag=hip-hop&limit=6&api_key=#{api_key}&format=json")
            soul = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=tag.gettopalbums&tag=soul&limit=6&api_key=#{api_key}&format=json")
            electronic = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=tag.gettopalbums&tag=electronic&limit=6&api_key=#{api_key}&format=json")
            dance = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=tag.gettopalbums&tag=dance&limit=6&api_key=#{api_key}&format=json")
            6.times do |num|
                extroversion_hash[rap['albums']['album'][num]['name']]=rap['albums']['album'][num]['url']
                extroversion_hash[hip_hop['albums']['album'][num]['name']]=hip_hop['albums']['album'][num]['url']
                extroversion_hash[soul['albums']['album'][num]['name']]=soul['albums']['album'][num]['url']
                extroversion_hash[electronic['albums']['album'][num]['name']]=electronic['albums']['album'][num]['url']
                extroversion_hash[dance['albums']['album'][num]['name']]=dance['albums']['album'][num]['url']
            end
            puts extroversion_hash
            JSON.parse(extroversion_hash.to_json)
        when personalidades[3]
            amabilidad = genres.take(11).sample(3)
            amabilidad_hash = {}
            genre1 = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=tag.gettopalbums&tag=#{amabilidad[0]}&limit=6&api_key=#{api_key}&format=json")
            genre2 = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=tag.gettopalbums&tag=#{amabilidad[1]}&limit=6&api_key=#{api_key}&format=json")
            genre3 = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=tag.gettopalbums&tag=#{amabilidad[2]}&limit=6&api_key=#{api_key}&format=json")
            upbeat = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=tag.gettopalbums&tag=upbeat&limit=3&api_key=#{api_key}&format=json")
            6.times do |num|
                amabilidad_hash[genre1['albums']['album'][num]['name']]=genre1['albums']['album'][num]['url']
                amabilidad_hash[genre2['albums']['album'][num]['name']]=genre2['albums']['album'][num]['url']
                amabilidad_hash[genre3['albums']['album'][num]['name']]=genre3['albums']['album'][num]['url']
            end
            3.times do |num|
                amabilidad_hash[upbeat['albums']['album'][num]['name']]=upbeat['albums']['album'][num]['url']
            end
            puts amabilidad_hash
            JSON.parse(amabilidad_hash.to_json)
        when personalidades[4]
            rango_emocional_hash = {}
            country = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=tag.gettopalbums&tag=country&limit=6&api_key=#{api_key}&format=json")
            pop = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=tag.gettopalbums&tag=pop&limit=6&api_key=#{api_key}&format=json")
            6.times do |num|
                rango_emocional_hash[country['albums']['album'][num]['name']]=country['albums']['album'][num]['url']
                rango_emocional_hash[pop['albums']['album'][num]['name']]=pop['albums']['album'][num]['url']
            end
            puts rango_emocional_hash
            JSON.parse(rango_emocional_hash.to_json)
        end
      end
    end
end
