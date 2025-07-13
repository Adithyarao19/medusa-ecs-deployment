const dotenv = require("dotenv");
dotenv.config();

module.exports = {
  projectConfig: {
    database_url: process.env.DATABASE_URL,
    database_type: "postgres",
    store_cors: "*",
    admin_cors: "*",
  },
};
