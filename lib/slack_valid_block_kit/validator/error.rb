module SlackValidBlockKit::Validator
  class Error
    attr_reader :kind, :option
    def initialize(kind, option = nil)
      @kind = kind
      @option = option
    end

    def self.messages(errors_by_path)
      errors_by_path.map { |path, errors|
        errors.map { |e| "#{path} : #{e.kind}" }
      }.flatten
    end
  end
end
