const axios = require('axios');
const cheerio = require('cheerio');
const maxRetries = 5;
const initialRetryDelay = 2000; // in milliseconds

async function scrapeWikiPageWithRetry(title, retries = 0) {
  try {
    // Attempt to scrape the page
    return await scrapeWikiPage(title);
  } catch (error) {
    if (error.code === 'ECONNRESET' && retries < maxRetries) {
      const delay = initialRetryDelay * Math.pow(2, retries); // Exponential backoff
      console.error(`Error scraping page "${title}". Retrying in ${delay}ms...`, error.message);
      await sleep(delay);
      return scrapeWikiPageWithRetry(title, retries + 1); // Retry with incremented retry count
    } else {
      console.error(`Max retries reached for page "${title}".`, error.message);
      throw error; // Rethrow the error after max retries
    }
  }
}

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
    
    // Extract the first image inside a <tr> with class "infobox-image"
    let thumbnail = '';
    const infoboxImage = $('td.infobox-image img').first();
    if (infoboxImage.length > 0) {
      thumbnail = infoboxImage.attr('src');
      if (thumbnail.startsWith('//')) {
        thumbnail = 'https:' + thumbnail;
      }
    }
  
    return {
      title: title.replace(/\s+/g, '_'), // Replace spaces with underscores
      content: content,
      last_updated: new Date().toISOString(),
      link: link,
      thumbnail: thumbnail,
    };
  }

  module.exports = { scrapeWikiPageWithRetry, parseWikiContent };
  