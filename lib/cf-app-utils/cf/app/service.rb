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
          service['label'].match /^#{label}(-.*)?$/
        end
      end

      private

      def all
        @services ||= JSON.parse(ENV['VCAP_SERVICES']).values.flatten
      end
    end
  end
end
