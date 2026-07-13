# Lesson 16

This section documents exercise 1 from lesson 16

---

### Database project for app


#### Exercise requirements:

* Users table with informations about their profiles
* Table with articles and posts.
* Table with categories
* Table of comments
* Table of tags
* Relations between those tables
* Articles with comments
* Queries with subqueries with articles with  comments above average


#### Database Schema

##### CREATE TABLE

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    content TEXT NOT NULL,
    image_url VARCHAR(500),
    user_id INT NOT NULL,
    category_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    content TEXT NOT NULL,
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (post_id) REFERENCES posts(id)
);

CREATE TABLE tags (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE post_tags (
    post_id INT NOT NULL,
    tag_id INT NOT NULL,
    PRIMARY KEY (post_id, tag_id),
    FOREIGN KEY (post_id) REFERENCES posts(id),
    FOREIGN KEY (tag_id) REFERENCES tags(id)
);
```

###### INSERT

```sql
INSERT INTO users (username, email, password_hash) VALUES
('jan_kowalski', 'jan@gmail.com', 'hash123'),
('maria_nowak', 'maria@gmail.com', 'hash456'),
('piotr_wisniewski', 'piotr@gmail.com', 'hash789');

INSERT INTO categories (name) VALUES
('Technologia'),
('Gotowanie'),
('Podróże'),
('Sport');

INSERT INTO posts (title, slug, content, user_id, category_id) VALUES
('Mój pierwszy post o Linuxie', 'moj-pierwszy-post-o-linuxie', 'Treść o Linuxie...', 1, 1),
('Przepis na pizzę', 'przepis-na-pizze', 'Składniki i przygotowanie...', 2, 2),
('Podróż do Japonii', 'podroz-do-japonii', 'Wrażenia z podróży...', 1, 3),
('Najlepsze laptopy 2026', 'najlepsze-laptopy-2026', 'Przegląd sprzętu...', 3, 1),
('Bieganie dla początkujących', 'bieganie-dla-poczatkujacych', 'Jak zacząć biegać...', 2, 4);

INSERT INTO tags (name) VALUES
('linux'),
('devops'),
('python'),
('kuchnia'),
('travel');

INSERT INTO comments (content, user_id, post_id) VALUES
('Świetny post!', 2, 1),
('Bardzo pomocne', 3, 1),
('Spróbuję tego przepisu', 1, 2),
('Marzy mi się taka podróż', 3, 3),
('Dobry przegląd', 2, 4);

INSERT INTO post_tags (post_id, tag_id) VALUES
(1, 1),
(1, 2),
(2, 4),
(3, 5),
(4, 1),
(4, 2),
(5, 4);
```

##### VIEW

```sql
CREATE VIEW posts_with_comment_count AS
SELECT posts.id, posts.title, posts.created_at, 
       users.username AS author,
       categories.name AS category,
       COUNT(comments.id) AS comment_count
FROM posts
LEFT JOIN comments ON posts.id = comments.post_id
LEFT JOIN users ON posts.user_id = users.id
LEFT JOIN categories ON posts.category_id = categories.id
GROUP BY posts.id, posts.title, posts.created_at, users.username, categories.name;
```

##### Indexes

```sql
CREATE INDEX idx_posts_user_id ON posts(user_id);
CREATE INDEX idx_posts_category_id ON posts(category_id);
CREATE INDEX idx_comments_post_id ON comments(post_id);
CREATE INDEX idx_comments_user_id ON comments(user_id);
CREATE INDEX idx_post_tags_post_id ON post_tags(post_id);
```

##### Queries

```sql
-- Most popular article
SELECT posts.title, COUNT(comments.id) AS comment_count
FROM posts
LEFT JOIN comments ON posts.id = comments.post_id
GROUP BY posts.id, posts.title
ORDER BY comment_count DESC;

-- Most popular authors
SELECT users.username, COUNT(posts.id) AS post_count
FROM users
LEFT JOIN posts ON users.id = posts.user_id
GROUP BY users.id, users.username
ORDER BY post_count DESC;

-- Most popular categories
SELECT categories.name, COUNT(posts.id) AS post_count
FROM categories
LEFT JOIN posts ON categories.id = posts.category_id
GROUP BY categories.id, categories.name
ORDER BY post_count DESC;

-- Queries with subqueries about articles and comments above certain average
SELECT title, comment_count
FROM posts_with_comment_count
WHERE comment_count > (
    SELECT AVG(comment_count) 
    FROM posts_with_comment_count
);
```
##### Users table

```csv
"id","username","email","password_hash","created_at"
1,"jan_kowalski","jan@gmail.com","hash123","2026-07-08 22:57:10.195782"
2,"maria_nowak","maria@gmail.com","hash456","2026-07-08 22:57:10.195782"
3,"piotr_wisniewski","piotr@gmail.com","hash789","2026-07-08 22:57:10.195782"
```

##### Articles and posts table

```csv
"title","comment_count"
"My first post about Linux",2
"Trip to Japan",1
"Best laptops of 2026",1
"Pizza recipe",1
"Running for beginers",0
```

##### Categories table

```csv
"name","post_count"
"Technology",2
"Sport",1
"Cooking",1
"Travel",1
```

##### Articles with comments

```csv
"id","title","created_at","author","category","comment_count"
1,"My first post about Linux","2026-07-09 21:21:02.907513","jan_kowalski","Technology",2
2,"Pizza recipe","2026-07-09 21:21:02.907513","maria_nowak","Cooking",1
3,"Trip to Japan","2026-07-09 21:21:02.907513","jan_kowalski","Travel",1
4,"Best laptops of 2026","2026-07-09 21:21:02.907513","piotr_wisniewski","Technology",1
5,"Running for beginers","2026-07-09 21:21:02.907513","maria_nowak","Sport",0
```

##### Queries with subqueries about articles and comments above certain average

```csv
"title","comment_count"
"My first post about Linux",2
```