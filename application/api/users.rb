class Api
  include Auth
  resource :users do
    desc 'Return all users'
    params do
      includes :basic_search
    end
    get do
      authenticate!
      users = SEQUEL_DB[:users].all
      present users, with: ApiEntities::UserEntity
    end

    params do
      optional :user, type: Hash do
        requires :first_name, type:String
        requires :last_name, type:String
        requires :email, type:String
        requires :password, type:String
        optional :born_on, type:String
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

    params do
      optional :user, type: Hash do
        requires :first_name, type:String
        requires :last_name, type:String
        #requires :email, type:String #Do not change email as it would include confirmation logic
        optional :born_on, type:String
      end
    end
    put '/:id' do
      authenticate!
      user = Models::User.find(id: params[:id])
      error!('401 Unauthorized', 401) unless current_user.can?(:edit, user)
      user.update(params[:user])
      present user, with: ApiEntities::UserEntity
    end

    params do
      optional :user, type: Hash do
        requires :new_password, type:String
        requires :confirm_password, type:String
      end
    end
    patch '/:id/reset_password' do
      authenticate!
      user = Models::User.find(id: params[:id])
      error!('401 Unauthorized', 401) unless current_user.can?(:edit, user)
      pass_form = Models::PasswordForm.new(params[:user]).validate
      if pass_form.success?
        user.update(password: pass_form["new_password"])
        {
            message:"password successfully changed"
        }
      else
        {
          errors: pass_form.errors
        }
      end
    end

    params do
      optional :user, type: Hash do
        requires :email, type:String
        requires :password, type:String
      end
    end
    post '/login' do
      login = params[:user]
      user = Models::User.where(email:login[:email], password: login[:password]).first
      error!('401 Unauthorized', 401) unless user
      token = get_token(user)
      {token: token }
    end


  end
end
