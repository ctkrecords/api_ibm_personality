module PersonalityTest
    class Base < Grape::API
        mount PersonalityTest::V1::PersonalityTest
    end
end