const fs = require('fs');
const path = require('path');

function walkDir(dir, callback) {
  fs.readdirSync(dir).forEach(f => {
    let dirPath = path.join(dir, f);
    let isDirectory = fs.statSync(dirPath).isDirectory();
    isDirectory ? walkDir(dirPath, callback) : callback(path.join(dir, f));
  });
}

walkDir('lib', function(filePath) {
  if (filePath.endsWith('.dart')) {
    let oldContent = fs.readFileSync(filePath, 'utf8');
    let content = oldContent;

    // Convert relative state imports to absolute
    content = content.replace(/import\s+['"](?:\.\.\/)+state\/(.*?)['"];/g, "import 'package:mobile_spendly/state/$1';");
    content = content.replace(/import\s+['"](?:\.\/)?state\/(.*?)['"];/g, "import 'package:mobile_spendly/state/$1';");

    // Convert relative model imports to absolute
    content = content.replace(/import\s+['"](?:\.\.\/)+models\/(.*?)['"];/g, "import 'package:mobile_spendly/models/$1';");
    content = content.replace(/import\s+['"](?:\.\/)?models\/(.*?)['"];/g, "import 'package:mobile_spendly/models/$1';");
    
    // Specifically fix transaction_model to transaction.dart
    content = content.replace(/mobile_spendly\/models\/transaction_model\.dart/g, 'mobile_spendly/models/transaction.dart');

    // Convert relative utils imports
    content = content.replace(/import\s+['"](?:\.\.\/)+utils\/utils\.dart['"];/g, "import 'package:mobile_spendly/utils/app_theme.dart';\nimport 'package:mobile_spendly/utils/formatters.dart';");
    content = content.replace(/import\s+['"](?:\.\/)?utils\/utils\.dart['"];/g, "import 'package:mobile_spendly/utils/app_theme.dart';\nimport 'package:mobile_spendly/utils/formatters.dart';");

    content = content.replace(/import\s+['"](?:\.\.\/)+utils\/(.*?)['"];/g, "import 'package:mobile_spendly/utils/$1';");
    content = content.replace(/import\s+['"](?:\.\/)?utils\/(.*?)['"];/g, "import 'package:mobile_spendly/utils/$1';");

    // Convert relative common widgets imports
    content = content.replace(/import\s+['"](?:\.\.\/)+widgets\/(.*?)['"];/g, "import 'package:mobile_spendly/widgets/$1';");

    // Fix other pages
    content = content.replace(/import\s+['"](?:\.\.\/)+pages\/(.*?)['"];/g, "import 'package:mobile_spendly/pages/$1';");
    content = content.replace(/import\s+['"](?:\.\/)?pages\/(.*?)['"];/g, "import 'package:mobile_spendly/pages/$1';");

    if (content !== oldContent) {
      fs.writeFileSync(filePath, content, 'utf8');
      console.log('Updated imports in: ' + filePath);
    }
  }
});
