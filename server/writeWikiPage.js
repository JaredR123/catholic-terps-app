const db = require('./initializeFirebase');
const { scrapeWikiPage, parseWikiContent } = require('./wikiscraper');

const maxChunkSize = 1048487; // Firestore limit

async function writeChunkToFirebase(title, chunkIndex, chunkContent, collectionName) {
  try {
      const chunkRef = db.collection(collectionName).doc(`${title}_part_${chunkIndex + 1}`);
      await chunkRef.set({
          content: chunkContent,
          last_updated: new Date().toISOString(),
          link: `https://en.wikipedia.org/wiki/${title}`,
      });
      console.log(`Chunk ${chunkIndex + 1} of ${title} uploaded successfully!`);
  } catch (error) {
      console.error(`Error uploading chunk to Firestore: ${error}`);
  }
}

async function writeToFirebase(collectionName, pageData) {
    try {
        const pageRef = db.collection(collectionName).doc(pageData.title);
        await pageRef.set(pageData);
        console.log(`Page ${pageData.title} uploaded successfully!`);
      } catch (error) {
        console.error(`Error uploading to Firestore: ${error}`);
      }
  }
  
async function scrapeAndUploadWikiPage(title) {
    const htmlContent = await scrapeWikiPage(title);
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

async function processWikiPage(title) {
    try {
        await scrapeAndUploadWikiPage(title);
    } catch (error) {
        if (error.code === 'CONTENT_TOO_LARGE') {
          // Perform a different operation, such as splitting the content or storing it in Cloud Storage
          handleLargeContent(title);
        } else {
          // Handle other errors
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
  const htmlContent = await scrapeWikiPage(title);
  if (!htmlContent) return;

  const pageData = parseWikiContent(htmlContent, `https://en.wikipedia.org/wiki/${title}`);
  const chunks = splitContentIntoChunks(htmlContent);

  // Store chunks in Firestore
  const chunkPromises = chunks.map((chunk, index) =>
      writeChunkToFirebase(title, index, chunk, 'wiki_pages')
  );

  await Promise.all(chunkPromises);
}

const titles = ['Pope_Francis', 'Council_of_Nicaea', 'Saint_Peter']; // Add more titles as needed

titles.forEach(title => {
    processWikiPage(title);
});