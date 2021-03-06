class ConfAdminApp < Sinatra::Application
  enable :sessions

  before do
    if request.path.match?(/^\/admin/)
      logger.info "Authenticating request"
      authenticate!
      set_current_user!
    end
  end

  get '/' do
    redirect 'proposal/new'
  end

  get '/proposal/new' do
    display_page 'proposals/form'
  end

  get '/proposal/submitted' do
    display_page 'proposals/submitted'
  end

  post '/proposal' do
    logger.info "#{params['name']} (#{params['email']}) submitted a proposal"
    GoogleDrive::Commands::CreateProposal.call(params)
    status = 201
  rescue GoogleDrive::Error => e
    logger.info "Failed to create proposal: #{e.message}"
    status = 500
    messages << 'Sorry, something went wrong. Please try again or contact us'
  ensure
    status
  end

  get '/proposal/:uuid' do
    result = GoogleDrive::Commands::GetProposal.call(uuid: params[:uuid])
    # result = cached_proposals.all.detect { |row| row['uuid'] == params[:uuid] }

    {
      abstract: result['abstract'],
      doots: result['doots'],
      applied_at: result['applied_at'],
      avatar_url: result['avatar_url'],
      participate_in_divination: result['participate_in_divination'],
      participate_in_panels: result['participate_in_panels'],
      portfolio: result['portfolio'],
      portfolio_description: result['portfolio_description'],
      previous_talks: result['previous_talks'],
      public_speaking_experience: result['public_speaking_experience'],
      sell_merch: result['sell_merch'],
      special_requirements: result['special_requirements'],
      tradition: result['tradition']
    }.to_json
  end

  patch '/proposal/upvote/:uuid' do
    return status 401 if session['current_user'].nil?

    existing = GoogleDrive::Commands::GetProposal.call(uuid: params[:uuid])
    existing['doots'] = '{}' if existing['doots'].empty?
    updated_doots = JSON.parse(existing['doots']).merge({session['current_user'] => 1})

    GoogleDrive::Commands::UpdateProposal.call(
      uuid: params[:uuid],
      params: {
        doots: updated_doots.to_json
      }
    )

    status 200
  end

  patch '/proposal/downvote/:uuid' do
    return status 401 if session['current_user'].nil?

    existing = GoogleDrive::Commands::GetProposal.call(uuid: params[:uuid])
    existing['doots'] = '{}' if existing['doots'].empty?
    updated_doots = JSON.parse(existing['doots']).merge({session['current_user'] => -1})

    GoogleDrive::Commands::UpdateProposal.call(
      uuid: params[:uuid],
      params: {
        doots: updated_doots.to_json
      }
    )

    status 200
  end

  patch '/proposal/removeVote/:uuid' do
    return status 401 if session['current_user'].nil?

    existing = GoogleDrive::Commands::GetProposal.call(uuid: params[:uuid])
    return status 400 if existing['doots'].empty?

    updated_doots = JSON.parse(existing['doots']).merge({session['current_user'] => 0})

    GoogleDrive::Commands::UpdateProposal.call(
      uuid: params[:uuid],
      params: {
        doots: updated_doots.to_json
      }
    )

    status 200
  end

  ## ADMIN

  get '/admin' do
    display_admin_page 'dashboard',
      show_header: true,
      proposals: GoogleDrive::Entities::Proposals.new
  end

  get '/admin/login' do
    display_admin_page 'login'
  end

  get '/admin/logout' do
    session['current_user'] = nil
    redirect 'admin/login'
  end

  post '/admin/login' do
    logger.info "Processing login for user #{params['username']}"

    user_key = ENV[params['username'].upcase]
    auth_key = params['password']

    if user_key == auth_key
      session['current_user'] = params['username']
      redirect 'admin'
    else
      messages << 'Login failed. Please contact administrator if you need help.'
      redirect 'admin/login'
    end
  end

  private

  def authenticate!
    return if current_user?
    return if request.path_info == '/admin/login'
    redirect 'admin/login'
  end

  def current_user?
    !!session['current_user']
  end

  def set_current_user!
    @current_user = session['current_user']
  end

  def messages
    session['messages'] ||= Array.new
  end

  def display_messages_and_reset_cache(&block)
    messages.each &block
    messages.clear
  end

  def display_page(location, locals = {})
    @show_header = locals.delete(:show_header)
    options = {
      layout_options: { views: 'views/layouts' },
      layout: locals.fetch(:layout) { :default },
      locals: locals
    }

    haml location.to_sym, options
  end

  def display_admin_page(location, locals = {})
    display_page("admin/#{location}", locals.merge(layout: :admin))
  end

  def display_partial(location, locals = {})
    @hide_header = locals.delete(:hide_header)
    haml location.to_sym, layout: false, locals: locals
  end
end
