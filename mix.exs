defmodule ExBin.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_bin,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "ExBin",
      package: package(),
      source_url: "https://github.com/zcking/ex_bin",
      description: description()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Zachary King"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/zcking/ex_bin"}
    ]
  end

  defp description do
    "Binary helpers for dealing with bits and bytes in Elixir."
  end
end
