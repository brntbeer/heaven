class Status
  attr_accessor :number, :nwo, :output, :token
  def initialize(token, nwo, number)
    @nwo    = nwo
    @token  = token
    @number = number
  end

  def api
    @api ||= Octokit::Client.new(:access_token => @token)
  end

  def url
    "https://api.github.com/repos/#{nwo}/deployments/#{number}"
  end

  def pending!
    api.create_deployment_status(url, 'pending', {:target_url => output})
  end

  def complete!(successful)
    state = successful ? "success" : "failure"
    api.create_deployment_status(url, state, {:target_url => output})
  end
end
