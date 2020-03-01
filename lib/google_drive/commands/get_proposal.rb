module GoogleDrive
  module Commands
    class GetProposal
      def self.call(uuid:)
        new(uuid).call
      end

      def initialize(uuid)
        @client = GoogleDrive::Client.new
        @uuid = uuid
      end

      def call
        client.get_proposal(uuid)
      end

      private
      attr_reader :client, :uuid
    end
  end
end
