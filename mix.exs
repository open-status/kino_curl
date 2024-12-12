defmodule KinoCurl.MixProject do
  use Mix.Project

  @source_url "https://github.com/open-status/kino_curl"

  def project do
    [
      app: :kino_curl,
      version: "0.2.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package()
    ]
  end

  def application do
    [
      mod: {KinoCurl.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.35", only: :dev, runtime: false},
      {:kino, "~> 0.8.0"},
      {:jason, ">= 1.0.0"},
      {:ex_curl, "~> 0.3.0"}
    ]
  end

  defp docs do
    [
      main: "components",
      source_url: @source_url,
      extras: ["guides/components.livemd"]
    ]
  end

  defp package do
    [
      description: "cURL integration with Kino for Livebook.",
      maintainers: ["Daniel Rudnitski"],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end
end
