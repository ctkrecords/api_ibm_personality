module PersonalityTest
    module V1
        class PersonalityTest < Grape::API
            version 'v1', using: :path
            format :json
            prefix :api

            route_param :user do
                get do
                    #u = params[:user]
                    u = RequestTweets.get_tweets(params[:user])
                    present u
                end
            end

        end
    end
end

