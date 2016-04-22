request = require('request');
cheerio = require('cheerio');
htmlparser = require("htmlparser2");
fs = require('fs');


cpage = 1

request(

  url:'http://catalog.sdstate.edu/search_advanced.php?cur_cat_oid=26&cpage='+cpage+'&search_database=Search&filter%5B3%5D=1&ecpage=1&ppage=1&pcpage=1&spage=1&tpage=1&sorting_type=1'
  (error,response,body) ->
    process(body) if (body)
)

process = (body) ->
  $ = cheerio.load(body,
  normalizeWhitespace: false,
  xmlMode: false,
  decodeEntities: true
  )
  table = $('.block_content').children('table').eq(2)
  items = $(table).children()
  items = $(items).slice(2,12)
  items = $(items).text().replace(/\n\s*\n\s*\n/g, '\n\n');
  console.log items
  fs.appendFile 'sdsuClasses.txt', items , (err) ->
    if !err
      console.log Math.round(cpage/319 * 100) + '%'
      cpage++
      if cpage < 319
        request(
          url:'http://catalog.sdstate.edu/search_advanced.php?cur_cat_oid=26&cpage='+cpage+'&search_database=Search&filter%5B3%5D=1&ecpage=1&ppage=1&pcpage=1&spage=1&tpage=1&sorting_type=1'
          (error,response,body) ->
            process(body) if (body)
          )
