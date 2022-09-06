defmodule TmdeWeb.Components.MailerComponentTest do
  use ExUnit.Case
  alias TmdeWeb.Components.MailerComponents

  @width 540

  describe "calculate_column_widths/2" do
    test "distributes space evenly when no widths are defined" do
      assert ["270px", "270px"] = MailerComponents.calculate_column_widths([%{}, %{}], @width)
    end

    test "fixed widths columns consume their space and only free space is distributed" do
      calculated_widths =
        [%{}, %{width: "240px"}]
        |> MailerComponents.calculate_column_widths(@width)

      assert ["300px", "240px"] = calculated_widths
    end

    test "distribute space according to the weights" do
      calculated_widths =
        [%{width: "1*"}, %{width: "2*"}]
        |> MailerComponents.calculate_column_widths(@width)

      assert ["180px", "360px"] = calculated_widths
    end

    test "interprets everything apart from * weights as pixel lengths" do
      calculated_widths =
        [%{width: "160"}, %{width: "10%"}, %{width: "100vh"}]
        |> MailerComponents.calculate_column_widths(@width)

      assert ["160px", "10px", "100px"] = calculated_widths
    end

    test "works with integers, floats and crazy atoms" do
      calculated_widths =
        [%{width: 130}, %{width: 9.9}, %{width: :"100vh"}, %{width: "1.5*"}, %{width: "0.75*"}]
        |> MailerComponents.calculate_column_widths(@width)

      assert ["130px", "10px", "100px", "200px", "100px"] = calculated_widths
    end
  end
end
