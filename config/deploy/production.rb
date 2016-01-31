set :stage, :production
set :stage_url, ""
server "", user: "deploy", roles: %w{app}
set :deploy_to, ""

set :branch, "master"
