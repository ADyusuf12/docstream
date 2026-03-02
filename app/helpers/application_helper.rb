module ApplicationHelper
  def highlight_risk_factors(text)
    return "" if text.blank?

    # Define the keywords the TIRS system should look for
    risk_keywords = %w[discrepancy risk missing inconsistent anomaly high-risk caution warning]

    # We use a regex to find these words (case-insensitive)
    highlighted_text = text.gsub(/(#{risk_keywords.join('|')})/i) do |match|
      # Wrap the match in a bold, red-tinted span
      "<span class='text-rose-600 font-bold bg-rose-50 px-1 rounded'>#{match}</span>"
    end

    # Use 'simple_format' to handle line breaks and 'html_safe' so our spans render
    simple_format(highlighted_text).html_safe
  end
end
