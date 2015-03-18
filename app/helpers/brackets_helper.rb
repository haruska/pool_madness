module BracketsHelper
  def cache_key_for_bracket_points(pool)
    max_updated_at = pool.bracket_points.maximum(:updated_at).to_i
    "pool-#{pool.id}/bracket_points/all-#{max_updated_at}"
  end

  def cache_key_for_bracket_final_four(bracket)
    "#{bracket.cache_key}/final-four"
  end

  def status_to_label(status)
    out = '<span class="badge-'
    case status
    when :ok
      out += 'success">OK'
    when :unpaid
      out += 'alert">Unpaid'
    when :incomplete
      out += 'error">Incomplete'
    end
    out += '</span>'
    out.html_safe
  end
end
