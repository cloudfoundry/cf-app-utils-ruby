require 'json'

module CF::App
  class Service #:nodoc:
    class << self
      def find_by_name(name)
        all.detect do |service|
          service['name'] == name
        end
      end

      def find_by_tag(tag)
        all.detect do |service|
          service['tags'].include?(tag)
        end
      end

      def find_by_label(label)
        all.detect do |service|
          service['label'] == label
        end
      end

      private

      def all
        @services ||= begin
          services = JSON.parse(ENV['VCAP_SERVICES']).map(&:last).flatten
          services.map do |service|
            service['label'] =~ /^(.*)-(.*)$/
            label, version = $1, $2
            service['label'] = label
            service['version'] = version
            service
          end
        end
      end
    end
  end
end
