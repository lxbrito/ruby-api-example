require_relative 'user_params_entity'
class Api
  module ApiEntities
    class UserEntity < UserParamsEntity
      unexpose :password
    end
  end
end