module CF::App
  class Credentials

      attr_reader :service_service

      def initialize(env)
          @service_service = Service.new(env)
      end

      # Returns credentials for the service instance with the given +name+.
      def find_by_service_name(name)
        service = service_service.find_by_name(name)
        service['credentials'] if service
      end

      # Returns credentials for the first service instance with the given +tag+.
      def find_by_service_tag(tag)
        service = service_service.find_by_tag(tag)
        service['credentials'] if service
      end

      def find_all_by_service_tag(tag)
        services = service_service.find_all_by_tag(tag)
        services.map do |service|
          service['credentials']
        end
      end

      # Returns credentials for the service instances with all the given +tags+.
      def find_all_by_all_service_tags(tags)
        return [] if tags.empty?

        service_service.find_all_by_tags(tags).map { |service| service['credentials'] }
      end

      # Returns credentials for the first service instance with the given +label+.
      def find_by_service_label(label)
        service = service_service.find_by_label(label)
        service['credentials'] if service
      end

      # Returns credentials for all service instances with the given +label+.
      def find_all_by_service_label(label)
        services = service_service.find_all_by_label(label)
        services.map do |service|
          service['credentials']
        end
      end

      def self.method_missing(message, *args, &block)
          Credentials.new(ENV).public_send(message, *args, &block)
      end
  end
end
