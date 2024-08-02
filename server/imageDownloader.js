const firestore = require('./initializeFirebase');
const fs = require('fs');
const path = require('path');
const axios = require('axios');

let db = 'csc_home';

async function downloadImage(url, filepath) {
    const response = await axios({
      url,
      responseType: 'stream',
    });
  
    return new Promise((resolve, reject) => {
      const writer = fs.createWriteStream(filepath);
      response.data.pipe(writer);
      let error = null;
      writer.on('error', err => {
        error = err;
        writer.close();
        reject(err);
      });
      writer.on('close', () => {
        if (!error) {
          resolve(true);
        }
      });
    });
  }
  
  async function downloadImages() {
    try {
      const snapshot = await firestore.collection(db).get();
      if (snapshot.empty) {
        console.log('No documents found.');
        return;
      }
  
      snapshot.forEach(async doc => {
        const data = doc.data();
        if (data.tag === 'img') {
          const url = data.content;
  
          // Define the custom filepath
          const customFilepath = path.resolve(__dirname, '../assets/images', `${db}_${doc.id}.jpg`);
  
          // Ensure the directory exists
          if (!fs.existsSync(path.dirname(customFilepath))) {
            fs.mkdirSync(path.dirname(customFilepath), { recursive: true });
          }
  
          await downloadImage(url, customFilepath);
          console.log(`Downloaded: ${customFilepath}`);
        }
      });
    } catch (error) {
      console.error('Error downloading images:', error);
    }
  }
  
  downloadImages();