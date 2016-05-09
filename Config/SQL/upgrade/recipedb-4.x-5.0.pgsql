begin;

ALTER TABLE security_users RENAME TO users;

ALTER TABLE users RENAME COLUMN user_id to id;
ALTER SEQUENCE security_users_user_id_seq RENAME to users_id_seq;
ALTER TABLE users ALTER COLUMN id SET DEFAULT nextval('users_id_seq');

ALTER TABLE users RENAME COLUMN user_login TO username;
ALTER TABLE users ADD UNIQUE(username);

ALTER TABLE users RENAME COLUMN user_password TO password;
ALTER TABLE users ALTER COLUMN password TYPE text;

ALTER TABLE users RENAME COLUMN user_name TO name;

ALTER TABLE users RENAME COLUMN user_access_level TO access_level;

ALTER TABLE users RENAME COLUMN user_language TO language;

ALTER TABLE users RENAME COLUMN user_country TO country;

ALTER TABLE users RENAME COLUMN user_date_created TO created;
ALTER TABLE users ALTER COLUMN created TYPE timestamp;

ALTER TABLE users RENAME COLUMN user_last_login TO last_login;
ALTER TABLE users ALTER COLUMN last_login TYPE timestamp;

ALTER TABLE users RENAME COLUMN user_email TO email;

ALTER TABLE users ADD modified timestamp;
ALTER TABLE users ADD locked BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE users ADD reset_token VARCHAR(255) NULL;
ALTER TABLE users ADD reset_time timestamp NULL;
ALTER TABLE users ADD meal_plan_start_day integer NOT NULL DEFAULT '0';
UPDATE users SET password = '';
UPDATE users SET locked = true;

DROP TABLE IF EXISTS security_openid;
DROP TABLE IF EXISTS security_providers;
DROP TABLE IF EXISTS recipe_settings;

ALTER TABLE recipe_stores RENAME TO stores;

ALTER TABLE stores ADD COLUMN id serial primary key;
ALTER TABLE stores RENAME COLUMN store_name TO name;
ALTER TABLE stores RENAME COLUMN store_layout TO layout;
ALTER TABLE stores DROP store_user;

ALTER TABLE recipe_ethnicity RENAME TO ethnicities;
ALTER TABLE ethnicities RENAME COLUMN ethnic_id TO id;
--CREATE SEQUENCE ethnicities_id_seq OWNED BY ethnicities.id START WITH (select MAX(id) + 1 FROM ethnicities);
ALTER SEQUENCE recipe_ethnic_id_seq RENAME to ethnicities_id_seq;
ALTER TABLE ethnicities ALTER COLUMN id SET DEFAULT nextval('ethnicities_id_seq');

ALTER TABLE ethnicities RENAME COLUMN ethnic_desc TO name;

ALTER TABLE recipe_units RENAME TO units;
ALTER TABLE units RENAME COLUMN unit_id TO id;
CREATE SEQUENCE units_id_seq OWNED BY units.id;
select setval('units_id_seq', (select MAX(id) FROM units));
ALTER TABLE units ALTER COLUMN id SET DEFAULT nextval('units_id_seq');

ALTER TABLE units RENAME COLUMN unit_desc TO name;
ALTER TABLE units RENAME COLUMN unit_abbr TO abbreviation;
ALTER TABLE units RENAME COLUMN unit_system TO system;
ALTER TABLE units ALTER COLUMN system SET NOT NULL;
ALTER TABLE units RENAME COLUMN unit_order TO sort_order;
ALTER TABLE units ALTER COLUMN sort_order SET NOT NULL;

ALTER TABLE recipe_locations RENAME TO locations;
ALTER TABLE locations RENAME COLUMN location_id TO id;
ALTER SEQUENCE recipe_location_id_seq RENAME to locations_id_seq;
ALTER TABLE locations ALTER COLUMN id SET DEFAULT nextval('locations_id_seq');

ALTER TABLE locations RENAME COLUMN location_desc TO name;

ALTER TABLE recipe_bases RENAME TO base_types;
ALTER TABLE base_types RENAME COLUMN base_id TO id;
ALTER SEQUENCE recipe_base_id_seq RENAME to base_types_id_seq;
ALTER TABLE base_types ALTER COLUMN id SET DEFAULT nextval('base_types_id_seq');

ALTER TABLE base_types RENAME COLUMN base_desc TO name;
ALTER TABLE base_types ADD UNIQUE(name);

ALTER TABLE recipe_prep_time RENAME TO preparation_times;
ALTER TABLE preparation_times RENAME COLUMN time_id TO id;
ALTER SEQUENCE recipe_time_id_seq RENAME to preparation_times_id_seq;
ALTER TABLE preparation_times ALTER COLUMN id SET DEFAULT nextval('preparation_times_id_seq');

ALTER TABLE preparation_times RENAME COLUMN time_desc TO name;
ALTER TABLE preparation_times ALTER COLUMN name SET NOT NULL;
ALTER TABLE preparation_times ADD UNIQUE(name);

ALTER TABLE recipe_courses RENAME TO courses;
ALTER TABLE courses RENAME COLUMN course_id TO id;
ALTER SEQUENCE recipe_course_id_seq RENAME to courses_id_seq;
ALTER TABLE courses ALTER COLUMN id SET DEFAULT nextval('courses_id_seq');

ALTER TABLE courses RENAME COLUMN course_desc TO name;
ALTER TABLE courses ALTER COLUMN name SET NOT NULL;
ALTER TABLE courses ADD UNIQUE(name);

ALTER TABLE recipe_difficulty RENAME TO difficulties;
ALTER TABLE difficulties RENAME COLUMN difficult_id TO id;
ALTER SEQUENCE recipe_difficult_id_seq RENAME to difficulties_id_seq;
ALTER TABLE difficulties ALTER COLUMN id SET DEFAULT nextval('difficulties_id_seq');

ALTER TABLE difficulties RENAME COLUMN difficult_desc TO name;
ALTER TABLE difficulties ALTER COLUMN name SET NOT NULL;
ALTER TABLE difficulties ADD UNIQUE(name);

ALTER TABLE recipe_core_ingredients RENAME TO core_ingredients;
ALTER TABLE core_ingredients RENAME COLUMN description TO name;

ALTER TABLE recipe_core_weights RENAME TO core_weights;

ALTER TABLE recipe_ingredients RENAME TO ingredients;
ALTER TABLE ingredients RENAME COLUMN ingredient_id TO id;
ALTER SEQUENCE recipe_ingredient_id_seq rename to ingredients_id_seq;
ALTER TABLE ingredients ALTER COLUMN id SET DEFAULT nextval('ingredients_id_seq');

ALTER TABLE ingredients RENAME COLUMN ingredient_core TO core_ingredient_id;
ALTER TABLE ingredients RENAME COLUMN ingredient_name TO name;
ALTER TABLE ingredients RENAME COLUMN ingredient_desc TO description;
ALTER TABLE ingredients RENAME COLUMN ingredient_location TO location_id;
ALTER TABLE ingredients RENAME COLUMN ingredient_unit TO unit_id;
ALTER TABLE ingredients RENAME COLUMN ingredient_solid TO solid;
ALTER TABLE ingredients RENAME COLUMN ingredient_system TO system;
ALTER TABLE ingredients RENAME COLUMN ingredient_user TO user_id;

ALTER TABLE recipe_sources RENAME TO sources;
ALTER TABLE sources RENAME COLUMN source_id TO id;
ALTER SEQUENCE recipe_sources_source_id_seq rename to sources_id_seq;
ALTER TABLE sources ALTER COLUMN id SET DEFAULT nextval('sources_id_seq');
ALTER TABLE sources RENAME COLUMN source_title TO name;
ALTER TABLE sources ALTER COLUMN name TYPE text;
ALTER TABLE sources RENAME COLUMN source_desc TO description;
ALTER TABLE sources RENAME COLUMN source_user TO user_id;

ALTER TABLE recipe_recipes RENAME TO recipes;

ALTER TABLE recipes RENAME COLUMN recipe_id TO id;
ALTER TABLE recipes RENAME COLUMN recipe_name TO name;
ALTER TABLE recipes RENAME COLUMN recipe_ethnic TO ethnicity_id;
ALTER TABLE recipes RENAME COLUMN recipe_base TO base_type_id;
ALTER TABLE recipes RENAME COLUMN recipe_course TO course_id;
ALTER TABLE recipes RENAME COLUMN recipe_prep_time TO preparation_time_id;
ALTER TABLE recipes RENAME COLUMN recipe_difficulty TO difficulty_id;
ALTER TABLE recipes RENAME COLUMN recipe_serving_size TO serving_size;
ALTER TABLE recipes RENAME COLUMN recipe_directions TO directions;
ALTER TABLE recipes RENAME COLUMN recipe_comments TO comments;
ALTER TABLE recipes RENAME COLUMN recipe_source TO source_id;
ALTER TABLE recipes RENAME COLUMN recipe_source_desc TO source_description;
ALTER TABLE recipes RENAME COLUMN recipe_modified TO modified;
ALTER TABLE recipes RENAME COLUMN recipe_picture TO picture;
ALTER TABLE recipes RENAME COLUMN recipe_picture_type TO picture_type;
ALTER TABLE recipes RENAME COLUMN recipe_private TO private;
ALTER TABLE recipes RENAME COLUMN recipe_system TO system;
ALTER TABLE recipes RENAME COLUMN recipe_user TO user_id;

ALTER SEQUENCE recipe_recipe_id_seq rename to recipes_id_seq;
ALTER TABLE recipes ALTER COLUMN id SET DEFAULT nextval('recipes_id_seq');


CREATE table attachments (
    id serial primary key,
    recipe_id integer NOT NULL REFERENCES recipes(id) ON DELETE CASCADE,
    name varchar(32) NOT NULL,
    attachment varchar(255) NOT NULL,
    dir varchar(255) DEFAULT NULL,
    "type" varchar(255) DEFAULT NULL,
    size integer DEFAULT 0,
    sort_order integer
	);


ALTER TABLE recipe_ingredient_mapping DROP CONSTRAINT recipe_ingredient_mapping_pkey;
ALTER TABLE recipe_ingredient_mapping RENAME TO ingredient_mappings;

ALTER TABLE ingredient_mappings ADD COLUMN id serial PRIMARY KEY;
ALTER TABLE ingredient_mappings RENAME COLUMN map_recipe TO recipe_id;
ALTER TABLE ingredient_mappings RENAME COLUMN map_ingredient TO ingredient_id;
ALTER TABLE ingredient_mappings RENAME COLUMN map_quantity TO quantity;
ALTER TABLE ingredient_mappings RENAME COLUMN map_unit TO unit_id;
ALTER TABLE ingredient_mappings RENAME COLUMN map_qualifier TO qualifier;
ALTER TABLE ingredient_mappings RENAME COLUMN map_optional TO optional;
ALTER TABLE ingredient_mappings RENAME COLUMN map_order TO sort_order;


CREATE TABLE shopping_lists (
	id serial primary key,
	name VARCHAR(64) NOT NULL,
	user_id integer NULL REFERENCES users(id) ON DELETE SET DEFAULT ON UPDATE CASCADE
	);

CREATE TABLE shopping_list_recipes (
        id serial primary key,
	shopping_list_id integer NOT NULL REFERENCES shopping_lists(id) ON DELETE CASCADE,
	recipe_id integer NOT NULL REFERENCES recipes(id) ON DELETE CASCADE,
	servings integer DEFAULT 1,
        user_id integer NULL REFERENCES users(id) ON DELETE SET DEFAULT ON UPDATE CASCADE
			);

DROP TABLE IF EXISTS recipe_list_recipes;
DROP TABLE IF EXISTS recipe_list_ingredients;
DROP TABLE IF EXISTS recipe_list_names;

CREATE TABLE shopping_list_ingredients (
        id serial PRIMARY key,
	shopping_list_id integer NOT NULL REFERENCES shopping_lists(id) ON DELETE CASCADE,
	ingredient_id integer NOT NULL REFERENCES ingredients(id) ON DELETE CASCADE,
	unit_id integer NOT NULL REFERENCES units(id) ON DELETE SET NULL,
	qualifier VARCHAR(32),
	quantity FLOAT NOT NULL,
	user_id integer NULL REFERENCES users(id) ON DELETE SET DEFAULT ON UPDATE CASCADE);

ALTER TABLE recipe_related_recipes DROP CONSTRAINT recipe_related_recipes_pkey;
ALTER TABLE recipe_related_recipes RENAME TO related_recipes;
ALTER TABLE related_recipes ADD id serial PRIMARY KEY;

ALTER TABLE related_recipes RENAME COLUMN related_parent TO parent_id;
ALTER TABLE related_recipes RENAME COLUMN related_child TO recipe_id;
ALTER TABLE related_recipes RENAME COLUMN related_required TO required;
ALTER TABLE related_recipes RENAME COLUMN related_order TO sort_order;

DROP TABLE IF EXISTS recipe_favorites;

CREATE TABLE vendors (
  	id serial PRIMARY key,
	name VARCHAR(64) NOT NULL UNIQUE,
        home_url VARCHAR(255) NULL,
        add_url VARCHAR(255) NULL

);

CREATE TABLE vendor_products (
  	id serial PRIMARY key,
        ingredient_id integer NOT NULL REFERENCES ingredients(id) ON DELETE CASCADE,
        vendor_id integer NOT NULL REFERENCES vendors(id) ON DELETE CASCADE,
        code VARCHAR(32),
        user_id integer NULL REFERENCES users(id) ON DELETE SET DEFAULT ON UPDATE CASCADE
);

INSERT INTO vendors (name, home_url, add_url)
    VALUES ('Presto Fresh Grocery',
    'http://www.prestofreshgrocery.com/',
    'http://www.prestofreshgrocery.com/checkout/cart/add/uenc/a/product/');

ALTER TABLE recipe_meals RENAME TO meal_names;
ALTER TABLE meal_names RENAME COLUMN meal_id TO id;
ALTER TABLE meal_names RENAME COLUMN meal_name TO name;
ALTER SEQUENCE recipe_meal_id_seq rename to meal_names_id_seq;
ALTER TABLE meal_names ALTER COLUMN id SET DEFAULT nextval('meal_names_id_seq');

ALTER TABLE recipe_mealplans DROP CONSTRAINT recipe_mealplans_pkey;
ALTER TABLE recipe_mealplans RENAME TO meal_plans;

ALTER TABLE meal_plans ADD id serial PRIMARY KEY;
ALTER TABLE meal_plans RENAME COLUMN mplan_date TO mealday;
ALTER TABLE meal_plans RENAME COLUMN mplan_meal TO meal_name_id;
ALTER TABLE meal_plans RENAME COLUMN mplan_recipe TO recipe_id;
ALTER TABLE meal_plans RENAME COLUMN mplan_servings TO servings;
ALTER TABLE meal_plans RENAME COLUMN mplan_user TO user_id;
ALTER TABLE meal_plans ADD UNIQUE (mealday,meal_name_id,recipe_id,user_id);

ALTER TABLE recipe_reviews DROP CONSTRAINT recipe_reviews_pkey;
ALTER TABLE recipe_reviews RENAME TO reviews;
ALTER TABLE reviews ADD id serial PRIMARY KEY;
ALTER TABLE reviews RENAME COLUMN review_recipe TO recipe_id;
ALTER TABLE reviews RENAME COLUMN review_comments TO comments;
ALTER TABLE reviews RENAME COLUMN review_date TO created;
ALTER TABLE reviews RENAME COLUMN review_user TO user_id;
ALTER TABLE reviews ADD rating integer;
ALTER TABLE reviews ADD UNIQUE (recipe_id,user_id);

--INSERT INTO reviews (recipe_id, rating, comments)
--    SELECT rating_recipe, rating_score, '' FROM recipe_ratings;

DROP TABLE IF EXISTS recipe_ratings;

ALTER TABLE recipe_prices RENAME TO price_ranges;
ALTER TABLE price_ranges RENAME COLUMN price_id TO id;
ALTER TABLE price_ranges RENAME COLUMN price_desc TO name;

ALTER SEQUENCE recipe_price_id_seq RENAME to price_ranges_id_seq;
ALTER TABLE price_ranges ALTER COLUMN id SET DEFAULT nextval('price_ranges_id_seq');
ALTER TABLE price_ranges ADD UNIQUE (name);

ALTER TABLE recipe_restaurants RENAME TO restaurants;

ALTER TABLE restaurants RENAME COLUMN restaurant_id TO id;
ALTER TABLE restaurants RENAME COLUMN restaurant_name TO name;
ALTER TABLE restaurants RENAME COLUMN restaurant_address TO street;
ALTER TABLE restaurants RENAME COLUMN restaurant_city TO city;
ALTER TABLE restaurants RENAME COLUMN restaurant_state TO state;
ALTER TABLE restaurants RENAME COLUMN restaurant_zip TO zip;
ALTER TABLE restaurants RENAME COLUMN restaurant_country TO country;
ALTER TABLE restaurants RENAME COLUMN restaurant_phone TO phone;
ALTER TABLE restaurants RENAME COLUMN restaurant_hours TO hours;
ALTER TABLE restaurants RENAME COLUMN restaurant_picture TO picture;
ALTER TABLE restaurants RENAME COLUMN restaurant_picture_type TO picture_type;
ALTER TABLE restaurants RENAME COLUMN restaurant_menu_text TO menu_text;
ALTER TABLE restaurants RENAME COLUMN restaurant_comments TO comments;
ALTER TABLE restaurants RENAME COLUMN restaurant_price TO price_range_id;
ALTER TABLE restaurants RENAME COLUMN restaurant_delivery TO delivery;
ALTER TABLE restaurants RENAME COLUMN restaurant_carry_out TO carry_out;
ALTER TABLE restaurants RENAME COLUMN restaurant_dine_in TO dine_in;
ALTER TABLE restaurants RENAME COLUMN restaurant_credit TO credit;
ALTER TABLE restaurants RENAME COLUMN restaurant_website TO website;
ALTER TABLE restaurants RENAME COLUMN restaurant_user TO user_id;


ALTER SEQUENCE recipe_restaurant_id_seq RENAME to restaurants_id_seq;
ALTER TABLE restaurants ALTER COLUMN id SET DEFAULT nextval('restaurants_id_seq');
ALTER TABLE restaurants ADD UNIQUE (name, user_id);

CREATE TABLE preparation_methods (
    	id serial primary key,
	name VARCHAR(64)
);
ALTER TABLE recipes ADD preparation_method_id integer REFERENCES preparation_methods(id) on DELETE SET NULL;
INSERT INTO preparation_methods (name) VALUES ('Slow cooker');
INSERT INTO preparation_methods (name) VALUES ('BBQ');
INSERT INTO preparation_methods (name) VALUES ('Microwave');
INSERT INTO preparation_methods (name) VALUES ('Canning');

commit;
