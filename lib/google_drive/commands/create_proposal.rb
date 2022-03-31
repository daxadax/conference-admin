module GoogleDrive
  module Commands
    class CreateProposal
      def self.call(params)
        new(params).call
      end

      # example params
      # {
      #   "name"=>"dax",
      #   "birthday"=>'2020-01-01",
      #   "email"=>"d.dax@email.com",
      #   "traveling_from"=>"ber",
      #   "avatar_url"=>"https://www.google.com",
      #   "title"=>"My Title",
      #   "bio"=>"i'm a good person",
      #   "abstract"=>"some text about the proposal",
      #   "type"=>"ritual",
      #   "tradition"=>"witchcraft",
      #   "special_requirements"=>"i want a free ticket and five free tickets for my friends",
      #   "previous_experience"=>"3",
      #   "portfolio_description"=>"",
      #   "portfolio"=>"youtube.com/something",
      #   "participate_in_panels"=>"on",
      #   "participate_in_divination"=>"on",
      #   "sell_merch"=>"on"
      #   "vendor_electric"=>"on"
      # }
      def initialize(params)
        @client = GoogleDrive::Client.new
        @params = params
      end

      def call
        client.create_proposal(
          uuid: SecureRandom.uuid,
          name: params['name'],
          birthday: params['birthday'],
          email: params['email'],
          traveling_from: params['traveling_from'],
          type: params['type'],
          title: params['title'],
          bio: params['bio'],
          abstract: params['abstract'],
          tradition: params['tradition'],
          avatar_url: params.fetch('avatar_url') { 'http://www.tinyurl.com/vaquboq' },
          special_requirements: params['special_requirements'],
          public_speaking_experience: params['previous_experience'],
          previous_talks: params['previous_talks'],
          portfolio: params['portfolio'],
          portfolio_description: params['portfolio_description'],
          participate_in_panels: params['participate_in_panels'],
          participate_in_divination: params['participate_in_divination'],
          sell_merch: params['sell_merch'],
          vendor_electric: params['vendor_electric'],
          applied_at: Time.now.utc
        )
      end

      private
      attr_reader :client, :params
    end
  end
end
