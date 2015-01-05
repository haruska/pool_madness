module BracketsHelper
  def status_to_label(status)
    out = '<span class="label label-'
    case status
    when :ok
      out += 'success">OK'
    when :unpaid
      out += 'warning">Unpaid'
    when :incomplete
      out += 'important">Incomplete'
    end
    out += "</span>"
    out.html_safe
  end
end
