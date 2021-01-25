class TrackSanitizer < BaseService
  attr_accessor :text
  def call
    normalize(text)
  end

  private
    def normalize(text)
      text = CGI.unescapeHTML(text.to_s)
      text = fix_encoding text.encode("UTF-8", invalid: :replace, replace: "")
      remove_unwanted(text).squish.titleize
    end

    def remove_unwanted(text)
      text.gsub(/\|.*/i, "") # remove everyting starts with | like '| Fm4 Homebase'
        .gsub(/Rock Antenne/i, "") # special rock antenne intros
        .gsub("/Rock Nonstop/i", "")
        .gsub("Nachrichten", "")
    end

    def fix_encoding(text)
      {
        "Ã€" => "À",
        "Ãƒ" => "Ã",
        "Ã„" => "Ä",
        "Ã…" => "Å",
        "Ã†" => "Æ",
        "Ã‡" => "Ç",
        "Ãˆ" => "È",
        "Ã‰" => "É",
        "ÃŠ" => "Ê",
        "Ã‹" => "Ë",
        "ÃŒ" => "Ì",
        "ÃŽ" => "Î",
        "Ã‘" => "Ñ",
        "Ã’" => "Ò",
        "Ã“" => "Ó",
        "Ã”" => "Ô",
        "Ã•" => "Õ",
        "Ã–" => "Ö",
        "Ã—" => "×",
        "Ã˜" => "Ø",
        "Ã™" => "Ù",
        "Ãš" => "Ú",
        "Ã›" => "Û",
        "Ãœ" => "Ü",
        "Ãž" => "Þ",
        "ÃŸ" => "ß",
        "Ã¡" => "á",
        "Ã¢" => "â",
        "Ã£" => "ã",
        "Ã¤" => "ä",
        "Ã¥" => "å",
        "Ã¦" => "æ",
        "Ã§" => "ç",
        "Ã¨" => "è",
        "Ã©" => "é",
        "Ãª" => "ê",
        "Ã«" => "ë",
        "Ã¬" => "ì",
        "Ã­" => "í",
        "Ã®" => "î",
        "Ã¯" => "ï",
        "Ã°" => "ð",
        "Ã±" => "ñ",
        "Ã²" => "ò",
        "Ã³" => "ó",
        "Ã´" => "ô",
        "Ãµ" => "õ",
        "Ã¶" => "ö",
        "Ã·" => "÷",
        "Ã¸" => "ø",
        "Ã¹" => "ù",
        "Ãº" => "ú",
        "Ã»" => "û",
        "Ã¼" => "ü",
        "Ã½" => "ý",
        "Ã¾" => "þ",
        "Ã¿" => "ÿ"
      }.each do |from, to|
        text = text.gsub(/#{from}/i, to)
      end
      text
    end
end
