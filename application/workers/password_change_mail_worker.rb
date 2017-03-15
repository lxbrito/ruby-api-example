class Api
  module Workers
    class PasswordChangeMailWorker
      include ::Sidekiq::Worker

      def perform(user_id)
        user = Models::User.find(id: user_id)
        Mail.deliver do
          from     SUPPORT_EMAIL
          to       user.email
          subject  'Ruby Api'
          body     MESSAGE.gsub('USER_NAME', user.full_name)
        end
      end

      MESSAGE = <<~EOF
      Hi, USER_NAME!
      You succefully changed your password for Ruby Api Example.
      EOF
    end
  end
end