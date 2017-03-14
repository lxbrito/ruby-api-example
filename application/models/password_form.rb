require_relative '../config/hanami'
require 'hanami/validations'
require 'hanami/validations/form'

class Api
  module Models
    class PasswordForm
      include Hanami::Validations
      predicates FormPredicates

      validations do
        required("new_password") { filled? & str? & size?(6..60)}
        required("confirm_password") { filled? & str? & size?(6..60)}
        rule(password_match: ["new_password", "confirm_password"]) do |new_password, confirm_password|
          new_password.eql?(confirm_password)
        end
      end

      def born_on=(born_on)
        return born_on unless born_on.is_a? String
        Date.parse(born_on)
      end


    end
  end
end