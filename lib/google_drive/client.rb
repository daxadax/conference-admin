module GoogleDrive
  class Client
    CLIENT_ID = ENV['GOOGLE_CLIENT_ID']
    CLIENT_SECRET = ENV['GOOGLE_CLIENT_SECRET']
    CLIENT_TOKEN = ENV['GOOGLE_CLIENT_TOKEN']
    PROPOSALS_SHEET_ID = ENV['PROPOSALS_SHEET_ID']

    # NOTE: This needs to be set manually when creating a new client app.
    # 1/1. create new app in google console and ad client_id/secret
    # 1/2. run session with blank './config.json' as first arg
    # 1/3. get the link in terminal and authorize in brower
    # 1/4. copy confirmation code into terminal
    # 1/5. client token is removed from created config.js file and used as CLIENT_TOKEN
    # 1/6. replace './config.json' with config method as first argument
    #
    # 2/1. create a new spreadsheet manually
    # 2/2. for the sake of christ, give it name that corresponds to the client
    # 2/3. add the file id as ENV['PROPOSALS_SHEET_ID']
    # 2/4. add headers as required for form data
    def initialize
      print "[GOOGLE DRIVE] Restoring session...\n"
      @session = GoogleDrive::saved_session(config, nil, CLIENT_ID, CLIENT_SECRET)
    end

    def create_proposal(params)
      # NOTE: important to cache for the duration of this method
      # otherwise the sheet will not be updated
      sheet = proposals_sheet
      sheet.list.push(params)
      sheet.save
    end

    def get_proposal(uuid)
      proposals_sheet.list.detect { |row| row['uuid'] == uuid }
    end

    def update_proposal(uuid, params)
      sheet = proposals_sheet
      proposal = sheet.list.detect { |row| row['uuid'] == uuid }
      proposal.update(params)
      sheet.save
    end

    def proposals_sheet
      print "[GOOGLE DRIVE] Fetching proposals...\n"
      session.spreadsheet_by_key(PROPOSALS_SHEET_ID).worksheets.first
    end

    private
    attr_reader :session, :proposal_sheet_id

    def config
      OpenStruct.new(
        scope: [
          "https://www.googleapis.com/auth/drive",
          "https://spreadsheets.google.com/feeds/"
        ],
        refresh_token: CLIENT_TOKEN
      )
    end
  end
end
