# TutorialAuth

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

# Step One

Generate boilerplate from

# Step 2

- setup some resources that should have some protected routes. Generate `products` resources by running:
- `mix phx.gen.pretty_html Products Product products name description:text price:float`
```sh
tutorial_auth on  main [!] via 💧 v1.11.2 took 51s 885ms
 [I] ➜ mix phx.gen.pretty_html Products Product products name description:text price:float

* creating lib/tutorial_auth_web/controllers/product_controller.ex
* creating lib/tutorial_auth_web/templates/product/edit.html.eex
* creating lib/tutorial_auth_web/templates/product/form.html.eex
* creating lib/tutorial_auth_web/templates/product/index.html.eex
* creating lib/tutorial_auth_web/templates/product/new.html.eex
* creating lib/tutorial_auth_web/templates/product/show.html.eex
* creating lib/tutorial_auth_web/views/product_view.ex
* creating test/tutorial_auth_web/controllers/product_controller_test.exs
* creating lib/tutorial_auth/products/product.ex
* creating priv/repo/migrations/20210111164720_create_products.exs
* creating lib/tutorial_auth/products.ex
* injecting lib/tutorial_auth/products.ex
* creating test/tutorial_auth/products_test.exs
* injecting test/tutorial_auth/products_test.exs

Add the resource to your browser scope in lib/tutorial_auth_web/router.ex:

    resources "/products", ProductController


Remember to update your repository by running migrations:

```

Add `resources "/products", ProductController` and configure private/public routes in `lib/tutorial_auth_web/router.ex`

see [diff](https://github.com/idkjs/phx-gen-auth/commit/059ac5729126219f042c8a32af35d1ffdd37d5a6#diff-a541bf4bf7baaa51ad5b1c45a7f2ece2c7975e1ba0504c68f96ee4d81608098a)

Then run `ecto.migrate`:
```sh
tutorial_auth on  main [!?] via 💧 v1.11.2
 [I] ➜ mix ecto.migrate
Compiling 1 file (.ex)
warning: this clause cannot match because a previous clause at line 23 always matches
  lib/tutorial_auth_web/router.ex:83

warning: TutorialAuthWeb.PageController.init/1 is undefined (module TutorialAuthWeb.PageController is not available or is yet to be defined)
  lib/tutorial_auth_web/router.ex:83: TutorialAuthWeb.Router.__checks__/0

Generated tutorial_auth app

17:54:44.332 [info]  == Running 20210111164720 TutorialAuth.Repo.Migrations.CreateProducts.change/0 forward

17:54:44.341 [info]  create table products

17:54:44.399 [info]  == Migrated 20210111164720 in 0.0s

tutorial_auth on  main [!?] via 💧 v1.11.2
 [I] ➜

```

# Step 3 - Update tests

If I run the tests now, I will get some failing controller tests. That is because some of the routes are private and we need to make sure we run them as an authenticated user.

Open the test file for [product_controller_test.exs](test/tutorial_auth_web/controllers/product_controller_test.exs) and add a `setup` before the first `describe` block. Then run `mix test`. All tests should pass.

```sh
 setup :register_and_log_in_user
```

Running the tests will pass now:

```sh
Generated tutorial_auth app
........................................................................................................................

Finished in 33.8 seconds
120 tests, 0 failures

Randomized with seed 720355
```
