const fs = require('fs');
const path = require('path');
const db = require('./initializeFirebase');
const { scrapeWikiPageWithRetry, parseWikiContent } = require('./wikiscraper');
const cheerio = require('cheerio');
const { start } = require('repl');
const pLimit = require('p-limit');
const limit = pLimit(5);

const maxChunkSize = 1048487; // Firestore limit
const maxRetries = 5;
const initialRetryDelay = 2000; // in milliseconds

async function retryFirestoreOperation(operation, args, retries = 0) {
  try {
    await operation(...args);
  } catch (error) {
    if (retries < maxRetries) {
      const delay = initialRetryDelay * Math.pow(2, retries); // Exponential backoff
      console.error(`Firestore operation failed. Retrying in ${delay}ms...`, error.message);
      await sleep(delay);
      await retryFirestoreOperation(operation, args, retries + 1); // Retry with incremented retry count
    } else {
      console.error(`Max retries reached for Firestore operation.`, error.message);
      throw error; // Rethrow the error after max retries
    }
  }
}

async function writeChunkToFirebase(title, chunkIndex, chunkContent, collectionName) {
  try {
      const $ = cheerio.load(chunkContent);
      const chunkRef = db.collection(collectionName).doc(`${title}_part_${chunkIndex + 1}`);
      let thumbnail = '';
      
      if (chunkIndex == 0) {
        const infoboxImage = $('td.infobox-image img').first();
        if (infoboxImage.length > 0) {
          thumbnail = infoboxImage.attr('src');
          if (thumbnail.startsWith('//')) {
            thumbnail = 'https:' + thumbnail;
          }
        }
      }

      await retryFirestoreOperation(chunkRef.set.bind(chunkRef), [{
        content: chunkContent,
        last_updated: new Date().toISOString(),
        link: `https://en.wikipedia.org/wiki/${title}`,
        title: title,
        thumbnail: thumbnail,
      }]);
      console.log(`Chunk ${chunkIndex + 1} of ${title} uploaded successfully!`);
  } catch (error) {
      console.error(`Error uploading chunk to Firestore: ${error}`);
  }
}

async function writeToFirebase(collectionName, pageData) {
    try {
        const pageRef = db.collection(collectionName).doc(pageData.title);
        await retryFirestoreOperation(pageRef.set.bind(pageRef), [pageData]);
        console.log(`Page ${pageData.title} uploaded successfully!`);
      } catch (error) {
        console.error(`Error uploading to Firestore: ${error}`);
      }
  }
  
async function scrapeAndUploadWikiPage(title) {
    const htmlContent = await scrapeWikiPageWithRetry(title);
    if (!htmlContent) return;

    const contentSize = Buffer.byteLength(htmlContent, 'utf8');

    if (contentSize > maxChunkSize) {
        const error = new Error('Content exceeds Firestore document size limit');
        error.code = 'CONTENT_TOO_LARGE';
        throw error;
    }

    const pageData = parseWikiContent(htmlContent, `https://en.wikipedia.org/wiki/${title}`);
    await writeToFirebase('wiki_pages', pageData);
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

async function processWikiPage(title) {
  try {
    await sleep(2000);
    await scrapeAndUploadWikiPage(title);
  } catch (error) {
    if (error.code === 'CONTENT_TOO_LARGE') {
      handleLargeContent(title);
    } else {
      console.error(`An unexpected error occurred: ${error.message}`);
    }
  }
}

function splitContentIntoChunks(content, maxChunkSize = 1024000) {
  const chunks = [];
  let startIndex = 0;

  while (startIndex < content.length) {
    let endIndex = Math.min(startIndex + maxChunkSize, content.length);
    let chunk = content.slice(startIndex, endIndex);
    chunks.push(chunk);
    startIndex = endIndex;
  }

  return chunks;
}
  
async function handleLargeContent(title) {
  const htmlContent = await scrapeWikiPageWithRetry(title);
  if (!htmlContent) return;

  const pageData = parseWikiContent(htmlContent, `https://en.wikipedia.org/wiki/${title}`);
  const chunks = splitContentIntoChunks(htmlContent);

  // Store chunks in Firestore
  const chunkPromises = chunks.map((chunk, index) =>
      writeChunkToFirebase(title, index, chunk, 'wiki_pages')
  );

  await Promise.all(chunkPromises);
}

async function main() {
  const filePath = path.join(__dirname, 'wiki', 'christian_wiki_articles.txt');
  const titles = fs.readFileSync(filePath, 'utf8').split('\n').filter(Boolean);

  const batchSize = 1000;
  const startIndex = 53000;
  
  for (let i = startIndex; i < titles.length; i += batchSize) {
    const titlesToProcess = titles.slice(i, i + batchSize);

    console.log(`Processing titles from ${i} to ${Math.min(i + batchSize - 1, titles.length - 1)}`);
    
    await Promise.all(titlesToProcess.map(title => 
      limit(() => processWikiPage(title))
    ));
  }
}

// Execute the main function
main().catch(error => {
  console.error(`Error in main function: ${error.message}`);
});

// TODO: Files 53,000 to the end