module CF::App
  class Credentials
    class << self
      # Returns credentials for the service with the given +name+.
      def find_by_service_name(name)
        service = Service.find_by_name(name)
        service['credentials'] if service
      end

      # Returns credentials for the first service with the given +tag+.
      def find_by_service_tag(tag)
        service = Service.find_by_tag(tag)
        service['credentials'] if service
      end

      # Returns credentials for the first service with the given +label+.
      def find_by_service_label(label)
        service = Service.find_by_label(label)
        service['credentials'] if service
      end
    end
  end
end
