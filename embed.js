const fs = require('fs');
let html = fs.readFileSync('/app/prepx_Anatomy.html', 'utf8');
const data = fs.readFileSync('/tmp/extracted_tests.json', 'utf8');
html = html.replace('__QUIZ_DATA__', data);
fs.writeFileSync('/app/prepx_Anatomy.html', html);
