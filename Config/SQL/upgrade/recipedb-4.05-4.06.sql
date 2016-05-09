begin;

ALTER TABLE recipe_ingredients DROP COLUMN ingredient_price;
ALTER TABLE recipe_ingredients drop CONSTRAINT recipe_ingredients_ingredient_name_key;
ALTER TABLE recipe_ingredients add unique (ingredient_name, ingredient_user);

commit;
