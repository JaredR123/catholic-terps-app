const db = require('./initializeFirebase');
const scrapeData = require('./scraper');

async function writeToFirebase(collectionName, data) {
    try {
      const batch = db.batch();
      data.forEach((item, index) => {
        const docRef = db.collection(collectionName).doc(`${item.tag}-${index}`);
        batch.set(docRef, item);
      });
  
      await batch.commit();
      console.log('Documents successfully written!');
    } catch (error) {
      console.error('Error writing documents:', error);
    }
  }
  
  (async () => {
    const scrapedData = await scrapeData('https://catholicterps.org/');
    if (scrapedData.length > 0) {
      await writeToFirebase('csc_home', scrapedData);
    }
  })();


