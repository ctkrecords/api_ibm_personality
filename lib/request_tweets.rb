module RequestTweets
    def self.get_tweets(username)
        #cad  = "http://localhost:3000/api/v1/users/#{username}"
        cad = "Request done!"
        response = HTTParty.get("http://localhost:3000/api/v1/users/#{username}")
        puts response.code 
        #puts response.body.class
        tweets = response.body
        if response.code != 200
            nil
        else
            file = File.open("lib/assets/tweets_prueba.txt", "w")
            file.puts tweets.encode!("UTF-8", invalid: :replace, undef: :replace).force_encoding("utf-8")
            file.close
            cad
        end
    end

    def self.test_method
        puts "hola desde Personality Insights"
        personality_request
    end

    def self.personality_request
        include IBMWatson
        authenticator = Authenticators::IamAuthenticator.new(
            apikey: "IpVwSclXM4QTpGJN_ymBGrV2-Xx4MGlrI1f2EgeMh4E9"
          )
          personality_insights = PersonalityInsightsV3.new(
            version: "2017-10-13",
            authenticator: authenticator
          )
          personality_insights.service_url = "https://gateway.watsonplatform.net/personality-insights/api"
          
          File.open("lib/assets/tweets_prueba.txt") do |profile_json|
            profile = personality_insights.profile(
              accept: "application/json",
              content: profile_json.read,
              content_type: "text/plain; charset=utf-8",
              content_language: "es",
              accept_language: "es"
            )
            puts JSON.pretty_generate(profile.result)
            file = File.open("personality.json", "w")
            file.puts JSON.pretty_generate(profile.result)
            file.close
          end
    end
end