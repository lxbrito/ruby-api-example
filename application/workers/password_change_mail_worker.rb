class Api
  module Workers
    class PasswordChangeMailWorker
      include ::Sidekiq::Worker

      def perform(user)

      end
    end
  end
end