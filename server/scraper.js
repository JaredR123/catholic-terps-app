const axios = require('axios');
const cheerio = require('cheerio');

async function scrapeData(url) {
  try {
    const response = await axios.get(url);
    const $ = cheerio.load(response.data);

    const tags = ['h1', 'h2', 'h3', 'p', 'img']; // List of tags to scrape
    let data = [];

    tags.forEach(tag => {
      if (tag === 'img') {
        $('img').each((i, el) => {
          data.push({
            tag: 'img',
            content: $(el).attr('src'),
            order: data.length
          });
        });
      } else {
        $(tag).each((i, el) => {
          data.push({
            tag: tag,
            content: $(el).text(),
            order: data.length
          });
        });
      }
    });

    return data;
  } catch (error) {
    console.error('Error scraping data:', error);
    return [];
  }
}

module.exports = scrapeData;
