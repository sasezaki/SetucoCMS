/*****************************************************
 * CREATE TABLES
 *****************************************************/

-- account table
CREATE TABLE IF NOT EXISTS account (
    id       INT AUTO_INCREMENT NOT NULL,
    login_id VARCHAR(255) NOT NULL,
    nickname VARCHAR(255) NOT NULL,
    password TEXT NOT NULL,
    PRIMARY KEY(id),
    UNIQUE(login_id),
    UNIQUE(nickname)
)
ENGINE=INNODB CHARACTER SET utf8 COLLATE utf8_bin;

-- tag table 
CREATE TABLE IF NOT EXISTS tag (
    id      INT AUTO_INCREMENT NOT NULL,
    name    VARCHAR(255) NOT NULL,
    PRIMARY KEY(id),
    UNIQUE(name)
) ENGINE=INNODB CHARACTER SET utf8 COLLATE utf8_general_ci;

-- media table
CREATE TABLE media (
    id          INT AUTO_INCREMENT NOT NULL,
    name        TEXT NOT NULL,
    type        TEXT NOT NULL,
    create_date TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
    update_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    comment     TEXT,
    PRIMARY KEY(id)
) ENGINE=INNODB CHARACTER SET utf8 COLLATE utf8_unicode_ci;

-- category table
CREATE TABLE IF NOT EXISTS category (
    id          INT AUTO_INCREMENT NOT NULL,
    name        VARCHAR(255) NOT NULL,
    parent_id   INT DEFAULT -1,
    PRIMARY KEY(id),
    UNIQUE(name, parent_id),
    FOREIGN KEY(parent_id) REFERENCES category(id) ON DELETE CASCADE
) ENGINE=INNODB CHARACTER SET utf8 COLLATE utf8_general_ci;

-- page table
CREATE TABLE IF NOT EXISTS page (
    id          INT AUTO_INCREMENT NOT NULL,
    title       TEXT NOT NULL,
    contents    TEXT NOT NULL,
    outline     TEXT,
    status      INT NOT NULL,
    category_id INT,
    account_id  INT,
    create_date TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
    update_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(id),
    FOREIGN KEY(account_id) REFERENCES account(id) ON DELETE SET NULL,
    FOREIGN KEY(category_id) REFERENCES category(id) ON DELETE SET NULL
) ENGINE=INNODB CHARACTER SET utf8 COLLATE utf8_unicode_ci;

-- free_space table
CREATE TABLE IF NOT EXISTS free_space (
    id      INT NOT NULL AUTO_INCREMENT,
    title  TEXT NOT NULL,
    content TEXT NOT NULL,
    PRIMARY KEY ( `id` )
) ENGINE = InnoDB CHARACTER SET utf8 COLLATE utf8_unicode_ci;

-- page_media table
CREATE TABLE IF NOT EXISTS page_media (
    page_id INT NOT NULL,
    media_id INT NOT NULL,
    PRIMARY KEY(media_id,page_id),
    FOREIGN KEY(page_id) REFERENCES page(id) ON DELETE CASCADE,
    FOREIGN KEY(media_id) REFERENCES media(id) ON DELETE CASCADE
) CHARACTER SET utf8 COLLATE utf8_bin;

-- page_tag table 
CREATE TABLE IF NOT EXISTS page_tag (
    page_id     INT NOT NULL,
    tag_id      INT NOT NULL,
    PRIMARY KEY(page_id,tag_id),
    INDEX (tag_id),
    FOREIGN KEY(page_id) REFERENCES page(id) ON DELETE CASCADE,
    FOREIGN KEY(tag_id) REFERENCES tag(id) ON DELETE CASCADE
) CHARACTER SET utf8 COLLATE utf8_bin;

-- site table 
CREATE TABLE IF NOT EXISTS site (
    id          INT AUTO_INCREMENT NOT NULL,
    name        TEXT NOT NULL,
    url         TEXT NOT NULL,
    comment     TEXT,
    keyword     TEXT,
    open_date   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(id)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;

-- ambition table
CREATE TABLE IF NOT EXISTS ambition (
    id          INT AUTO_INCREMENT NOT NULL,
    ambition    TEXT NOT NULL,
    PRIMARY KEY(id)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;

-- goal table
CREATE TABLE IF NOT EXISTS goal (
    id           INT AUTO_INCREMENT NOT NULL,
    page_count   INT NOT NULL,
    target_month DATE NOT NULL UNIQUE,
    PRIMARY KEY(id)
) CHARACTER SET utf8 COLLATE utf8_bin;

-- template table
CREATE TABLE IF NOT EXISTS template (
     id INT NOT NULL AUTO_INCREMENT ,
     account_id INT NOT NULL ,
     title VARCHAR( 255 ) NOT NULL ,
     file_name VARCHAR( 255 ) NOT NULL ,
     explanation TINYTEXT NOT NULL ,
PRIMARY KEY ( `id` )
) ENGINE=INNODB CHARACTER SET utf8 COLLATE utf8_bin;



/*****************************************************
 * INSERT DEFAULTS RECORDS
 *****************************************************/

-- insert statements
INSERT IGNORE INTO account 
    (id, login_id, nickname, password)
VALUES
    (1, 'admin', '管理者', SHA1('password'));

INSERT IGNORE INTO category 
    (id, name, parent_id)
VALUES
    (-1, 'no_parent', null);

INSERT IGNORE INTO site 
    (id, name, url, comment, keyword, open_date)
VALUES
    (1,
     'サイト名を設定してください',
     'http://example.com/',
     'サイトの説明を設定してください。',
     'サイトのキーワードを設定してください。',
     now());

INSERT IGNORE INTO free_space
    (id, title, content)
VALUES (
    1,
    'フリースペース',
    'フリースペースです。コンテンツを設定してください。');


INSERT INTO ambition 
    (id, ambition)
VALUES
    (1, '目標を設定してください。');

INSERT IGNORE INTO goal 
    (id, page_count, target_month)
VALUES
    (1, 10, cast(date_format(now(), '%Y-%m-1') as date));

commit;
