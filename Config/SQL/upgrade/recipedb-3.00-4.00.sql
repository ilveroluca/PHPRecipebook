begin;

DROP TABLE  IF EXISTS security_members;
DROP TABLE  IF EXISTS security_groups;
ALTER TABLE security_users DROP CONSTRAINT security_users_pkey cascade;
ALTER TABLE security_users ADD user_id serial primary key;

CREATE TABLE security_providers (
	provider_id serial primary key,
	provider_name text NOT NULL UNIQUE
);

CREATE TABLE security_openid (
	login_id INT NOT NULL REFERENCES security_users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
	provider_id INT NOT NULL REFERENCES security_providers(provider_id) ON DELETE CASCADE ON UPDATE CASCADE,
	user_identity VARCHAR(255) NOT NULL UNIQUE
);

ALTER TABLE recipe_stores ADD store_user INT NULL REFERENCES security_users(user_id);

UPDATE recipe_stores s
SET store_user = u.user_id
from security_users u
WHERE s.store_owner = u.user_login;

ALTER TABLE recipe_stores DROP COLUMN store_owner;

ALTER TABLE recipe_sources ADD source_user INT NULL REFERENCES security_users(user_id) ON DELETE SET DEFAULT ON UPDATE CASCADE;

ALTER TABLE recipe_recipes ADD recipe_user INT NULL REFERENCES security_users(user_id) ON DELETE SET DEFAULT ON UPDATE CASCADE;

UPDATE recipe_recipes s
SET recipe_user = u.user_id
from security_users u
WHERE s.recipe_owner = u.user_login;
ALTER TABLE recipe_recipes DROP COLUMN recipe_owner;
ALTER TABLE recipe_recipes DROP COLUMN recipe_cost;
ALTER TABLE recipe_recipes DROP CONSTRAINT recipe_recipes_recipe_name_key;

ALTER TABLE recipe_list_names ADD list_user INT NULL REFERENCES security_users(user_id) ON DELETE SET DEFAULT ON UPDATE CASCADE;

UPDATE recipe_list_names s
SET list_user = u.user_id
from  security_users u
WHERE s.list_owner = u.user_login;
ALTER TABLE recipe_list_names DROP COLUMN list_owner;

ALTER TABLE recipe_favorites ADD favorite_user INT NULL REFERENCES security_users(user_id) ON DELETE SET DEFAULT ON UPDATE CASCADE;

UPDATE recipe_favorites s
SET favorite_user = u.user_id
from security_users u
WHERE s.favorite_owner = u.user_login;
ALTER TABLE recipe_favorites DROP COLUMN favorite_owner;
-- PK dropped with favorite_owner column eLTER TABLE recipe_favorites DROP CONSTRAINT recipe_favorites_pkey;
ALTER TABLE recipe_favorites ADD PRIMARY KEY (favorite_recipe,favorite_user);


ALTER TABLE recipe_mealplans ADD mplan_user INT NULL REFERENCES security_users(user_id) ON DELETE SET DEFAULT ON UPDATE CASCADE;

UPDATE recipe_mealplans s
SET mplan_user = u.user_id
from security_users u
WHERE s.mplan_owner = u.user_login;

ALTER TABLE recipe_mealplans DROP COLUMN mplan_owner;
ALTER TABLE recipe_mealplans ADD PRIMARY KEY (mplan_date,mplan_meal,mplan_recipe,mplan_user);

ALTER TABLE recipe_reviews ADD review_user INT NULL REFERENCES security_users(user_id) ON DELETE SET DEFAULT ON UPDATE CASCADE;

UPDATE recipe_reviews s
SET review_user = u.user_id
from security_users u
WHERE s.review_owner = u.user_login;

ALTER TABLE recipe_reviews DROP COLUMN review_owner;
ALTER TABLE recipe_reviews ADD PRIMARY KEY (review_recipe,review_comments,review_user);

ALTER TABLE recipe_restaurants ADD restaurant_user INT NULL REFERENCES security_users(user_id) ON DELETE SET DEFAULT ON UPDATE CASCADE;
UPDATE recipe_restaurants SET restaurant_user = 1;

ALTER TABLE recipe_ingredients ADD ingredient_user INT NULL REFERENCES security_users(user_id) ON DELETE SET DEFAULT ON UPDATE CASCADE;
UPDATE recipe_ingredients SET ingredient_user = 1;

CREATE TABLE recipe_core_ingredients (
	id INT NOT NULL,
	group_id INT NOT NULL,
	description text NOT NULL,
	short_description text NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE recipe_core_weights (
	id INT NOT NULL REFERENCES recipe_core_ingredients(id) ON DELETE SET NULL,
	sequence INT NOT NULL,
	amount INT,
	measure VARCHAR(80),
	weight INT,
	PRIMARY KEY (id, sequence)
);
ALTER TABLE recipe_ingredients ADD ingredient_core INT NULL REFERENCES recipe_core_ingredients(id) ON DELETE SET NULL;

DROP TABLE recipe_settings;
CREATE TABLE recipe_settings (
	setting_name VARCHAR(32),
	setting_value VARCHAR(64),
	setting_user INT NULL REFERENCES security_users(user_id) ON DELETE SET DEFAULT ON UPDATE CASCADE,
	PRIMARY KEY (setting_name, setting_user)
);
INSERT INTO recipe_settings values ('MealPlanStartDay', '0', 1);


insert into security_providers VALUES (1, 'google');
insert into security_providers VALUES (2, 'facebook');

-- ALTER TABLE recipe_restaurants ADD restaurant_website VARCHAR(254);
-- ALTER TABLE recipe_restaurants ADD restaurant_country VARCHAR(64);

UPDATE recipe_bases set base_desc = 'Grain/Pasta' where base_id =  2;

ALTER TABLE recipe_units ADD unit_system INT;
ALTER TABLE recipe_units ADD unit_order INT;

UPDATE recipe_units SET unit_system = 0 where unit_id < 11;
UPDATE recipe_units SET unit_system = 1 where unit_id > 10 AND unit_id < 19;
UPDATE recipe_units SET unit_system = 2 where unit_id > 18;
UPDATE recipe_units SET unit_order = unit_id;

commit;
