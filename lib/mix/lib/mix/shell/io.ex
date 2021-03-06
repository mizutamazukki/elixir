defmodule Mix.Shell.IO do
  @moduledoc """
  This is Mix's default shell.

  It simply prints messages to stdio and stderr.
  """

  @behaviour Mix.Shell

  @doc """
  Prints the current application to the shell if it
  was not printed yet.
  """
  def print_app do
    if name = Mix.Shell.printable_app_name do
      IO.puts "==> #{name}"
    end
  end

  @doc """
  Executes the given command and prints its output
  to stdout as it comes.
  """
  def cmd(command, opts \\ []) do
    print_app? = Keyword.get(opts, :print_app, true)
    Mix.Shell.cmd(command, opts, fn data ->
      if print_app?, do: print_app()
      IO.write(data)
    end)
  end

  @doc """
  Prints the given message to the shell followed by a newline.
  """
  def info(message) do
    print_app()
    IO.puts IO.ANSI.format message
  end

  @doc """
  Prints the given error to the shell followed by a newline.
  """
  def error(message) do
    print_app()
    IO.puts :stderr, IO.ANSI.format(red(message))
  end

  @doc """
  Prints a message and prompts the user for
  input. Input will be consumed until Enter is pressed.
  """
  def prompt(message) do
    print_app()
    IO.gets message <> " "
  end

  @doc """
  Prints a message and asks the user if they want to proceed.
  The user must press Enter or type anything that matches the "yes"
  regex `~r/^(Y(es)?)?$/i`.
  """
  def yes?(message) do
    print_app()
    got_yes? IO.gets(message <> " [Yn] ")
  end

  defp got_yes?(answer) when is_binary(answer) do
    answer =~ ~r/^(Y(es)?)?$/i
  end

  # The IO server may return :eof or :error
  defp got_yes?(_), do: false

  defp red(message) do
    [:red, :bright, message]
  end
end
