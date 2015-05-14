module ContentHelper
  def check_spell(text)
    @results = Spellchecker.check(text, dictionary='es')
    words = content_tag :div, class: "mi clase" do
      word = content_tag(:span, "")
      content_words = content_tag(:span, "")
      @results.each do |w|
        if w[:correct]
          word = content_tag(:span, "#{w[:original]}", class: "")
        else
          li = "<ul class='suggestions'>#{w[:suggestions].map { |word|  "<li>#{word}</li>"}.join}</ul>" #list suggestions
          word = content_tag(:span, "#{w[:original]}", class: "wrong-text", :title => 'Sugerencias', 'data-content' => "#{li.html_safe}", "data-toggle" => "popover")
        end
        content_words = content_words + " " + word
      end
      content_words
    end
    return words
  end

end
