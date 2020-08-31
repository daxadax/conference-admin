module GoogleDrive
  module Entities
    class Proposals
      def initialize
        @data = GoogleDrive::Client.new.proposals_sheet
      end

      def attributes
        data.rows[0]
      end

      def all
        @all ||= data.rows[1..-1].map { |row| Proposal.new(Hash[attributes.zip(row)]) }
      end

      def sorted_by_votes
        all.sort_by do |proposal|
          proposal.doots.values.sum
        end.reverse
      end

      def types
        all.map { |proposal| proposal.type.split('_').map(&:capitalize).join(' ') }.uniq
      end

      private
      attr_reader :data

      class Proposal
        NAMED_ATTRIBUTES = %w[
          name title type traveling_from uuid avatar_url doots public_speaking_experience portfolio_description abstract email
        ]

        def initialize(row)
          @row = row
        end

        def name
          row['name']
        end

        def title
          row['title']
        end

        def type
          row['type']
        end

        def location
          row['traveling_from']
        end

        def uuid
          row['uuid']
        end

        def avatar_url
          row['avatar_url']
        end

        def abstract
          row['abstract']
        end

        def email
          row['email']
        end

        def doots
          row['doots'].empty? ? {} : JSON.parse(row['doots'])
        end

        def experience_description
          if !row['public_speaking_experience'].empty?
            case row['public_speaking_experience'].to_i
            when 1..2 then 'Low public speaking experience'
            when 3 then 'Average public speaking experience'
            when 4 then 'Above-average public speaking experience'
            when 5 then 'Professional public speaker'
            end
          else
            row['portfolio_description']
          end
        end

        # NOTE: this should actually be in a presenter but...
        def experience_description_class
          if !row['public_speaking_experience'].empty?
            case experience_description
            when /Low/ then 'danger'
            when /Above/ then 'primary'
            when /Professional/ then 'success'
            else
              'warning'
            end
          end
        end

        def additional_information
          row.reject do |key, value|
            NAMED_ATTRIBUTES.include?(key) || value.empty? || value == 'on'
          end
        end

        def checkboxes
          row.select { |key, value| value == 'on' }
        end

        private
        attr_reader :row
      end
    end
  end
end
