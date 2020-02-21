module GoogleDrive
  class Proposals
    def initialize
      @data = GoogleDrive::Client.new.proposals_sheet
    end

    def attributes
      data.rows[0]
    end

    def all
      data.rows[1..-1]
    end

    private
    attr_reader :data
  end
end
