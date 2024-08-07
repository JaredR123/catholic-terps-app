const fs = require('fs');
const path = require('path');

function mergeAndRemoveDuplicates(filePaths, outputFile) {
    const allTitles = new Set();
  
    filePaths.forEach(filePath => {
      const resolvedPath = path.resolve(__dirname, filePath); // Resolve the full path
      try {
        const data = fs.readFileSync(resolvedPath, 'utf8');
        const titles = data.split('\n').filter(Boolean); // Filter out any empty lines
  
        titles.forEach(title => allTitles.add(title));
  
      } catch (error) {
        console.error(`Error reading file ${resolvedPath}: ${error.message}`);
      }
    });
  
    // Convert Set to Array and save to the output file
    const mergedTitles = Array.from(allTitles);
    const outputFilePath = path.resolve(__dirname, outputFile); // Resolve the full path for the output file
    try {
      fs.writeFileSync(outputFilePath, mergedTitles.join('\n'), 'utf8');
      console.log(`Merged ${mergedTitles.length} unique titles into ${outputFilePath}`);
    } catch (error) {
      console.error(`Error saving merged file: ${error.message}`);
    }
  }
  
  // Example usage:
  const filesToMerge = [
    'wiki/Catholic_Architecture_titles.txt',
    'wiki/Jesus_titles.txt',
    'wiki/Catholic_Art_titles.txt',
    'wiki/Catholic_Music_titles.txt',
    'wiki/Catholic_History_titles.txt',
    'wiki/Pope_titles.txt',
    'wiki/J_R_R_Tolkien_titles.txt',
    'wiki/Christian_Saints_titles.txt'
  ];

  mergeAndRemoveDuplicates(filesToMerge, 'wiki/christian_wiki_articles.txt');
