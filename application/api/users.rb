class Api
  resource :users do
    params do
      includes :basic_search
    end
    get do
      users = SEQUEL_DB[:users].all
      present users, with: ApiEntities::UserEntity
    end

    params do
      optional :user, type: Hash do
        requires :first_name, type:String
        requires :last_name, type:String
        requires :email, type:String
        requires :password, type:String
      end
    end
    post do
      user_form = Models::UserForm.new(params[:user]).validate
      if user_form.success?
        user = Models::User.new(user_form.to_hash).save
        present user, with: ApiEntities::UserEntity
      else
        {
            errors: user_form.errors
        }
      end

    end
  end
end
