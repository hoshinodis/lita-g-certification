require "open-uri"
require "nokogiri"

module Lita
  module Handlers
    class GCertification < Handler

      route(/(?<question>.*)/, :exec, command: true)

      def exec(response)
        question = response.match_data['question']

        url = 'https://www.adwords-exam.info/search?q=' + question
        url_escape = URI.escape(url)
        html = Nokogiri::HTML(open(url_escape))
        urls = html.css('.entry-title-link').map{|p| p[:href]}
        titles = html.css('.entry-title-link').map{|a| a.text}

        if urls.size > 1
          response.reply("いっぱい見つかっちゃったニャン\n```\n#{titles.join("\n")}\n```")
        else
          ans_html = Nokogiri::HTML(open(urls.first))
          ans = ans_html.css('.entry-content')
          response.reply("#{ans.css('p').first.text}\n\n#{ans.css("p")[1].to_s.gsub("<br>", "\n").gsub("<p>", "").gsub("</p>", "").gsub('"', "").gsub("<span style=color: #ff0000;>", "").gsub("</span>", "").gsub("<strong>", "*").gsub("</strong>", "*")
          }\n#{ans.css("p")[2].to_s.gsub("<br>", "\n").gsub("<p>", "").gsub("</p>", "").gsub('"', "").gsub("<span style=color: #ff0000;>", "").gsub("</span>", "").gsub("<strong>", "*").gsub("</strong>", "*")
          }")
        end

      rescue OpenURI::HTTPError => e
        response.reply("情報がなかったニャン。URLが正しいか確認してニャン。")
        response.reply("今回使用したURL:#{url}")
      end

      Lita.register_handler(self)
    end
  end
end
