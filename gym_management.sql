const express = require("express");
const mysql = require("mysql2");

const app = express();
const port = 3100;

// Create a MySQL connection
const connection = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "Dabu6039###",  // Replace with your actual MySQL password
  database: "gym_management",
});

// Connect to the MySQL database
connection.connect(err => {
  if (err) {
    console.error("Error connecting to MySQL:", err);
    return;
  }
  console.log("Connected to MySQL");
});

// Route to get all data in one place (Gyms, Members, Coaches, Sessions, Member_Sessions)
app.get("/all-data", (req, res) => {
  const queries = {
    gyms: "SELECT * FROM Gym",
    members: "SELECT * FROM Member",
    coaches: "SELECT * FROM Coach",
    sessions: "SELECT * FROM Session",
    memberSessions: "SELECT * FROM Member_Session"
  };

  let allData = {};

  // Execute all queries one after the other
  connection.query(queries.gyms, (err, gyms) => {
    if (err) {
      return res.status(500).json({ error: "Database query error" });
    }
    allData.gyms = gyms;

    connection.query(queries.members, (err, members) => {
      if (err) {
        return res.status(500).json({ error: "Database query error" });
      }
      allData.members = members;

      connection.query(queries.coaches, (err, coaches) => {
        if (err) {
          return res.status(500).json({ error: "Database query error" });
        }
        allData.coaches = coaches;

        connection.query(queries.sessions, (err, sessions) => {
          if (err) {
            return res.status(500).json({ error: "Database query error" });
          }
          allData.sessions = sessions;

          connection.query(queries.memberSessions, (err, memberSessions) => {
            if (err) {
              return res.status(500).json({ error: "Database query error" });
            }
            allData.memberSessions = memberSessions;

            // Once all queries are done, send the full result
            res.json(allData);
          });
        });
      });
    });
  });
});

// Route to fetch all gyms
app.get("/gyms", (req, res) => {
  connection.query("SELECT * FROM Gym", (err, results) => {
    if (err) {
      res.status(500).send("Database query error");
      return;
    }
    res.json(results);
  });
});

// Route to fetch all members
app.get("/members", (req, res) => {
  connection.query("SELECT * FROM Member", (err, results) => {
    if (err) {
      res.status(500).send("Database query error");
      return;
    }
    res.json(results);
  });
});

// Route to fetch all coaches
app.get("/coaches", (req, res) => {
  connection.query("SELECT * FROM Coach", (err, results) => {
    if (err) {
      res.status(500).send("Database query error");
      return;
    }
    res.json(results);
  });
});

// Route to fetch all sessions
app.get("/sessions", (req, res) => {
  connection.query("SELECT * FROM Session", (err, results) => {
    if (err) {
      res.status(500).send("Database query error");
      return;
    }
    res.json(results);
  });
});

// Route to fetch all member-session records
app.get("/member-sessions", (req, res) => {
  connection.query("SELECT * FROM Member_Session", (err, results) => {
    if (err) {
      res.status(500).send("Database query error");
      return;
    }
    res.json(results);
  });
});

// Start the server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
