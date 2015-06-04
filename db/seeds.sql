INSERT INTO authors 
(fname,lname,email,password,bio)
VALUES 
('fernanda','correa','nandasc@gmail.com','pass', 'hi'), 
('nanda','sampaio','fer@gmail.com','pass1', 'my name is ... '), 
('yas','martins','yas@gmail.com','pass2', 'test'), 
('violet','knockout','vko@gmail.com','pass3', 'hello'), 
('tara','bahgat','tara@gmail.com','pass4', 'what up'), 
('duby','sosa','duby@gmail.com','pass5', 'this is me'), 
('pippi','strongstocking','pips@gmail.com','pass6', 'welcome'), 
('java','script','js@gmail.com','pass7', 'my articles are kick ass'), 
('marcy','lang','whisky@gmail.com','pass8', 'hazaaa');


INSERT INTO categories
(cat_name,summary)
VALUES
('burgers', 'best burgers in the city'),
('cheap', 'cheap quality rest in the city'),
('traditional', 'traditional restaurants in the city');

INSERT INTO categories
(cat_name)
VALUES
('new'),
('fancy');


-- INSERT INTO tags 
-- (name)
-- VALUES
-- ('fancy'),
-- ('traditional'),
-- ('classic'),
-- ('cheap'),
-- ('burgers'),
-- ('desserts');


-- INSERT INTO articles
-- (name,content,tags,created_at,edited_on, category_id)
-- VALUES
-- ('Cheap rest in nyc', 'vapiano,chipotle,shake shack,dos toros', '[cheap,nyc]', CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,2),
-- ('Traditional rest in nyc', 'balthazar, cipriani,', '[traditional,nyc]', CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,3),
-- ('Best Burger in nyc', 'five guys, shake shack, umami', '[burgers,nyc]', CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1);
