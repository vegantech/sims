    def basic_auth(user, pass)
      encoded_login = ["#{user}:#{pass}"].pack("m*").gsub(/\n/, '')
      set_headers({'HTTP_AUTHORIZATION' =>   "Basic #{encoded_login}"})
    end

    def xhr
      set_headers({"HTTP_X_REQUESTED_WITH" => "XMLHttpRequest"})
    end
