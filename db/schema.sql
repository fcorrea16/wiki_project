DROP TABLE IF EXISTS authors;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS articles;

CREATE TABLE authors (
	id 			 SERIAL   PRIMARY KEY,
	fname 	 VARCHAR  NOT NULL,
	lname 	 VARCHAR  NOT NULL,
	email 	 VARCHAR  NOT NULL,
	password VARCHAR  NOT NULL,
	bio 		 VARCHAR
);

CREATE TABLE categories (
	id 	 SERIAL  PRIMARY KEY,
	name VARCHAR UNIQUE NOT NULL
);

CREATE TABLE articles (
	id 					SERIAL 		PRIMARY KEY,
	name 				VARCHAR 	NOT NULL,
	content 		TEXT 			NOT NULL,
	created_at 	TIMESTAMP NOT NULL,
	edited_on 	TIMESTAMP NOT NULL,
	category_id INTEGER 	REFERENCES categories(id),
	author_id 	INTEGER 	REFERENCES authors(id)
);


-- REFERENCES categories(id),
-- REFERENCES authors(id)

-- CREATE TABLE tags (
-- 	id SERIAL PRIMARY KEY,
-- 	name VARCHAR NOT NULL
-- );
