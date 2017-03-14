require 'jwt'
class Api
  module Auth
    extend ActiveSupport::Concern

    included do |base|
      helpers HelperMethods
    end

    module HelperMethods
      def authenticate!
        data = get_data_from_token(get_token_from_header)
        user_id = data.fetch("data", {}).fetch("user_id")
        current_user = Models::User.find(id: user_id)
        error!('401 Unauthorized', 401) unless current_user
      end

      def get_token(user)
        payload = {data: {user_id: user.id}}
        JWT.encode payload, TOKEN_SECRET, 'HS256'
      end

      def current_user
        @current_user
      end

      def current_user=(user)
        @current_user = user
      end

      private
      def get_token_from_header
        token_header = request.headers.slice('Authorization')["Authorization"]
        token_header.to_s.split('=').last
      end

      def get_data_from_token(token)
        error!('401 Unauthorized', 401) unless token
        decoded_token = JWT.decode token, TOKEN_SECRET, true, { :algorithm => 'HS256' }
        decoded_token.detect{|h| h["data"]} || {}
      end
    end
  end
end
