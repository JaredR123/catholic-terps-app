const fs = require('fs');
const path = require('path');
const axios = require('axios');

async function saveQueryResultsToFile(tag, titles) {
  const dir = path.join(__dirname, 'wiki');
  const filePath = path.join(dir, `${tag}_titles.txt`);

  // Create the directory if it doesn't exist
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }

  try {
    fs.writeFileSync(filePath, titles.join('\n'), 'utf8');
    console.log(`Saved ${titles.length} titles to ${filePath}`);
  } catch (error) {
    console.error(`Error saving to file: ${error.message}`);
  }
}

async function searchArticlesByKeyword(keyword) {
  let allTitles = [];
  let continueToken = '';

  do {
    const url = `https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=${encodeURIComponent(keyword)}&format=json&utf8=1&srlimit=500${continueToken ? `&sroffset=${continueToken}` : ''}`;

    try {
      const response = await axios.get(url);
      const data = response.data;

      // Check if the 'query' and 'search' properties exist
      if (data.query && data.query.search) {
        const pages = data.query.search;
        
        // Extract titles and add to allTitles array
        const titles = pages.map(page => page.title.replace(/\s+/g, '_'));
        allTitles = allTitles.concat(titles);

        // Check if there's more data to fetch
        continueToken = data.continue ? data.continue.sroffset : null;
      } else {
        console.error('No search results found');
        break;
      }

    } catch (error) {
      console.error(`Error searching Wikipedia: ${error.message}`);
      break;
    }

  } while (continueToken);

  await saveQueryResultsToFile(keyword, allTitles);

  return allTitles;
}

searchArticlesByKeyword('Christian_Saints');
