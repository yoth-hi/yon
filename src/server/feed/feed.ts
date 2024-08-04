import pool from "../_database";

export async function get_feed_data(req: any, res: Response, lang:string){
    const data = await pool.query(`SELECT * FROM video`);
    console.log(data)
}