class Api
  module Workers
    class RegistrationMailWorker
      include ::Sidekiq::Worker

      def perform(user)

      end
    end
  end
end
