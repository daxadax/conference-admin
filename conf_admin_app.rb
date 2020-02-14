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
    redirect 'proposal'
  end

  get '/proposal' do
    display_page 'proposal_form'
  end

  post '/proposal' do
    logger.info "#{params['name']} submitted a proposal"
    # TODO
    p params
  end

  get '/proposal_submitted' do
    display_page 'proposal_submitted'
  end

  ## ADMIN

  get '/admin' do
    display_admin_page 'dashboard',
      show_header: true,
      proposals: GoogleDrive::Proposals.new
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
