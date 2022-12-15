require 'test_helper'

class RequestLoginTest < ActiveSupport::TestCase

    test "Testando e obtendo token login API" do
        token = Helper.token_login
        assert token.present?
    end

end