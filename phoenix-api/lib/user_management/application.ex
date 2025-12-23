defmodule UserManagement.Application do
  use Application

  def start(_type, _args) do
    children = [
      UserManagement.Repo,
      {DNSCluster, query: Application.get_env(:user_management, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: UserManagement.PubSub},
      # Musi być tutaj:
      UserManagementWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: UserManagement.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
