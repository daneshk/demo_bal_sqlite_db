import ballerina/sql;
import ballerinax/java.jdbc;
import ballerina/io;

jdbc:Client dbClient = check new("jdbc:sqlite:./data.db");

public function main() returns error? {

    // Create a table
    _ = check dbClient->execute(`
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            age INTEGER NOT NULL
        )
    `);
    // Insert data
    _ = check dbClient->execute(`INSERT INTO users (name, age) VALUES ('John', 30)`);
    _ = check dbClient->execute(`INSERT INTO users (name, age) VALUES ('Doe', 25)`);

    // Query data
    stream<User, sql:Error?> queryResult = dbClient->query(`SELECT * FROM users`);
    check from User user in queryResult
    do {
        io:println(`User ID: ${user.id}, Name: ${user.name}, Age: ${user.age}`);
    };
}

type User record {|
    int id;
    string name;
    int age;
|};
