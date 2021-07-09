defmodule ContentDisposition.MixProject do
  use Mix.Project

  @version "1.0.0"
  @repo_url "https://github.com/jeroenvisser101/content_disposition"

  def project do
    [
      app: :content_disposition,
      version: @version,
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Hex
      package: package(),
      description: "A tiny package for properly formatting Content-Disposition headers",

      # Docs
      name: "ContentDisposition",
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [extra_applications: [:logger]]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [{:ex_doc, ">= 0.19.0", only: :dev}]
  end

  defp package do
    [
      maintainers: ["Jeroen Visser"],
      licenses: ["MIT"],
      links: %{"GitHub" => @repo_url}
    ]
  end

  defp docs do
    [
      main: "ContentDisposition",
      source_ref: "v#{@version}",
      source_url: @repo_url
    ]
  end
end
