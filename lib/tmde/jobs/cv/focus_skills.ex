defmodule Tmde.Jobs.CV.FocusSkills do
  @moduledoc """
  Connects CV.Focus to skills gained
  """
  use Tmde, :schema
  alias Tmde.Jobs.{CV, Skill}

  schema "cv_focus_skills" do
    field :sort_order, :integer
    field :rating, :integer

    belongs_to :job_seeker, CV.Focus
    belongs_to :skill, Skill

    embeds_many :description, Translation
    embeds_many :rating_text, Translation
  end
end
