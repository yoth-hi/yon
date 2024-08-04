import { Pool } from 'pg';

// Your PostgreSQL URL
const postgresUrl = (process.env as any).POSTGRES_URL as string

// Parse the URL
const url = new URL(postgresUrl);

// Extract components
const user = url.username;
const password = url.password;
const host = url.hostname;
const port = parseInt(url.port, 10); // Convert port from string to number
const database = url.pathname.slice(1); // Remove the leading '/' from pathname

// Create a PostgreSQL Pool instance
const pool = new Pool({
  user,
  host,
  database,
  password,
  port,
});

export default pool;
