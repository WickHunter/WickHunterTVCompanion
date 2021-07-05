const { join } = require('path');
require('dotenv').config({ path: join(__dirname, '.env') });
const { init } = require('@wickhunter/trader');


init();