require "pg"

$db = PG.connect ({dbname: 'wiki'})