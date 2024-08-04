import pool from "../_database";

export async function get_feed_data(){
    pool.query(`SELECT * FROM video`)
}