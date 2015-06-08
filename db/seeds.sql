
INSERT INTO users 
(fname,lname,email,password,bio)
VALUES 
('fernanda','correa','nandasc@gmail.com','pass', 'hi'), 
('yas','martins','yas@gmail.com','pass2', 'test'), 
('violet','green','vko@gmail.com','pass3', 'hello'), 
('tara','bahgat','tara@gmail.com','pass4', 'what up'), 
('duby','sosa','duby@gmail.com','pass5', 'this is me'), 
('Pippi','Webb','pips@gmail.com','pass6', 'welcome'), 
('Veronica','Andrews','js@gmail.com','pass7', 'my articles are kick ass'), 
('marcy','lang','whisky@gmail.com','pass8', 'hazaaa');


INSERT INTO categories
(name)
VALUES
('burgers'), 
('cheap'), 
('new'),
('fancy'),
('breakfast'),
('donuts'),
('traditional');



INSERT INTO articles
(name,content,created_at,edited_on, category_id, created_by, updated_by)
VALUES
('Cheap rest in nyc', 'vapiano,chipotle,shake shack,dos toros', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,2, 1, 4),
('Traditional rest in nyc', 'balthazar, cipriani,', CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,5, 3, 3),
('Best Burger in nyc', 'five guys, shake shack, umami', CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,1,2, 2);
