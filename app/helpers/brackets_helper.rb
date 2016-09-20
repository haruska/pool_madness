module BracketsHelper
  def cache_key_for_tournament_bracket(tournament)
    "tournament-#{tournament.id}/bracket"
  end

  def cache_key_for_bracket_points(pool)
    max_updated_at = pool.bracket_points.maximum(:updated_at).to_i
    "pool-#{pool.id}/bracket_points/all-#{max_updated_at}"
  end

  def cache_key_for_bracket_final_four(bracket)
    "#{bracket.cache_key}/final-four"
  end

  def status_to_label(status)
    case status
    when :ok
      content_tag(:span, "OK", class: "badge-success")
    when :unpaid
      content_tag(:span, "Unpaid", class: "badge-alert")
    when :incomplete
      content_tag(:span, "Incomplete", class: "badge-error")
    end
  end
end
