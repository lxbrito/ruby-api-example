require_relative '../config/hanami'
require 'hanami/validations'
require 'hanami/validations/form'

class Api
  module Models
    class UserForm
      include Hanami::Validations
      predicates FormPredicates

      validations do
        required("first_name") { filled? & str? }
        required("last_name") { filled? & str? }
        required("password") { filled? & str? & size?(6..60)}
        required("email")  { filled? & str? & email? }
        optional("born_on") { filled? & datetime_str? }
      end

      def born_on=(born_on)
        return born_on unless born_on.is_a? String
        Date.parse(born_on)
      end
    end
  end
end