module BracketsHelper
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
