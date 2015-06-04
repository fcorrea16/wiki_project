DROP DATABASE IF EXISTS wiki;

CREATE DATABASE wiki;
\c wiki

CREATE TABLE authors (
	id SERIAL PRIMARY KEY, 
	fname VARCHAR NOT NULL,
	lname VARCHAR NOT NULL, 
	email VARCHAR NOT NULL,
	password VARCHAR NOT NULL,
	bio VARCHAR
);

CREATE TABLE categories (
	id SERIAL PRIMARY KEY,
	cat_name VARCHAR NOT NULL, 
	summary VARCHAR
);

CREATE TABLE articles (
	id SERIAL PRIMARY KEY, 
	name VARCHAR NOT NULL, 
	content TEXT,
	created_at TIMESTAMP NOT NULL, 
	edited_on TIMESTAMP NOT NULL,
	category_id INTEGER NOT NULL,	
	author_id INTEGER NOT NULL 
);

-- REFERENCES categories(id),
-- REFERENCES authors(id)

-- CREATE TABLE tags (
-- 	id SERIAL PRIMARY KEY,
-- 	name VARCHAR NOT NULL
-- );
