module GoogleDrive
  module Commands
    class UpdateProposal
      def self.call(uuid:, params:)
        new(uuid, params).call
      end

      # example params
      # {
      #   "name"=>"dax",
      #   "email"=>"d.dax@email.com",
      #   "traveling_from"=>"ber",
      #   "avatar_url"=>"https://www.google.com",
      #   "title"=>"My Title",
      #   "abstract"=>"some text about the proposal",
      #   "type"=>"ritual",
      #   "tradition"=>"witchcraft",
      #   "special_requirements"=>"i want a free ticket and five free tickets for my friends",
      #   "previous_experience"=>"3",
      #   "portfolio_description"=>"",
      #   "portfolio"=>"youtube.com/something",
      #   "participate_in_panels"=>"on",
      #   "participate_in_divination"=>"on",
      #   "sell_merch"=>"on",
      #   "doots"=>"{\"dax\":1,\"giorgia\":-1}"
      # }
      def initialize(uuid, params)
        @client = GoogleDrive::Client.new
        @uuid = uuid
        @params = params
      end

      def call
        client.update_proposal(uuid, params)
      end

      private
      attr_reader :client, :uuid, :params
    end
  end
end
