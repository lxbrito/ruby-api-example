class Api
  module ApiEntities
    class UserParamsEntity < Grape::Entity
      format_with(:iso_timestamp) { |dt| dt && dt.strftime("%Y-%m-%d %H:%M:%S") }

      expose :first_name, documentation: { type: 'string', desc: 'first name of user', required: true }
      expose :last_name, documentation: { type: 'string', desc: 'last name of user', required: true }

      expose :email, documentation: { type: 'string', desc: 'email of user', required: true }
      expose :password, documentation: { type: 'string', desc: 'password of user', required: true }
      with_options(format_with: :iso_timestamp) do
        expose :born_on, documentation: { type: 'string', desc: 'birthday of user', required: false }
      end
    end
  end
end