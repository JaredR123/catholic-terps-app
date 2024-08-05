const axios = require('axios');
const cheerio = require('cheerio');

async function scrapeWikiPage(title) {
  const url = `https://en.wikipedia.org/wiki/${title}`;
  try {
    const response = await axios.get(url);
    const $ = cheerio.load(response.data);
    const content = $.html(); // Or any specific content you need
    return content;
  } catch (error) {
    console.error(`Error scraping Wikipedia page: ${error}`);
    return null;
  }
}

function parseWikiContent(htmlContent, link) {
    const $ = cheerio.load(htmlContent);
    const title = $('h1').text(); // Page title
    console.log('Parsed title:', title); // Add this line to debug
    const content = $('#mw-content-text').html(); 
  
    return {
      title: title.replace(/\s+/g, '_'), // Replace spaces with underscores
      content: content,
      last_updated: new Date().toISOString(),
      link: link,
    };
  }

  module.exports = { scrapeWikiPage, parseWikiContent };
  